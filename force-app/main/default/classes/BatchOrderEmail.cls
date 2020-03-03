global class BatchOrderEmail implements Database.Batchable<sObject>,Database.AllowsCallouts  {
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query;
        Date todayDate = system.today();
        Set<String> ignoreStatusSet = new Set<String>{'Draft', 'Pending For Approval','Approved','Rejected','Deleted', '','Ordered', null};
        query = 'SELECT Id, Name, ivydsd__Order_Date__c, ivydsd__Order_Value__c, Resource_Email__c,Email_Sent__c, Signature_Image_Path__c, Signature_Link1__c,'
            + 'Saloon_Email__c FROM ivydsd__Order__c WHERE (Resource_Email__c!=null OR Saloon_Email__c!=null) AND Signature_Link1__c=null'
            + ' AND ivydsd__Order_Status__c NOT IN :ignoreStatusSet AND Argo_Order__c = true AND Email_Sent__c != true AND createddate >= TODAY  ';// AND   AND id=\'a1g6F00000B8YtvQAF\' id=\'a1g6F000009j6ngQAA\'
            //+' AND ivydsd__Store__r.Order_Email__c = true';
        if(Test.isRunningTest())
        {
           query = 'SELECT Id, Name, ivydsd__Order_Date__c, ivydsd__Order_Value__c, Resource_Email__c,Email_Sent__c, Signature_Image_Path__c, Signature_Link1__c,'
               +'Saloon_Email__c FROM ivydsd__Order__c where (Resource_Email__c!=null OR Saloon_Email__c!=null) AND Signature_Link1__c=null '
               +'AND ivydsd__Order_Status__c NOT IN :ignoreStatusSet AND Argo_Order__c = true AND Email_Sent__c != true AND createddate >= TODAY ';
            //+' AND ivydsd__Store__r.Order_Email__c = true';// removed because no need to send for respective saloon.
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ivydsd__Order__c> OrderList){
        system.debug('OrderList'+OrderList);
        Set<String> resEmail = new Set<String>();
        for(ivydsd__Order__c o:OrderList)
        {
            if(o.Resource_Email__c!=null)
            {
                resEmail.add(o.Resource_Email__c);  
            }
        }
        Map<String,Id> EmailUserIdMap= new Map<String,id>();
        list<ivybase__Resource__c> resourceList = [SELECT Id, ivybase__Email__c, ivybase__Related_User__c FROM ivybase__Resource__c 
                                        WHERE ivybase__Email__c IN :resEmail];
        for(ivybase__Resource__c r:resourceList)
        {
            EmailUserIdMap.put(r.ivybase__Email__c, r.ivybase__Related_User__c); 
        }
        
        OrderList = S3ImageDownloadSync.copyOrderSign(OrderList);
        update OrderList; 
        EmailTemplate template =  [SELECT Id, Name FROM EmailTemplate WHERE Name like 'OrderDetailsToStore' LIMIT 1];
        List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();
        for(ivydsd__Order__c Ord:OrderList){
            //system.debug('emailsent'+Ord.Email_Sent__c);
            if(Ord.Saloon_Email__c!=null || Ord.Resource_Email__c!=null ){
                
                List<String> toAddresses = new List<String>(); 
               /* if(Ord.Saloon_Email__c!=null) {
                    toAddresses.add(Ord.Saloon_Email__c);
                }*/// removed because no need to send for respective saloon.
        
                if(Ord.Resource_Email__c!=null) {
                    system.debug('OrderID '+Ord.id );
                    toAddresses.add(Ord.Resource_Email__c);
                    system.debug('toAddresses '+toAddresses );
                }
                    
                Messaging.SingleEmailMessage oneEmail = new Messaging.SingleEmailMessage();
                oneEmail.setOrgWideEmailAddressId(Label.orgWideEmailId);
                system.debug(toAddresses);
                
                oneEmail.setTreatTargetObjectAsRecipient(false);        
                if(EmailUserIdMap.containsKey(Ord.Resource_Email__c)) {
                    //oneEmail.setSubject('Your Order(#'+Ord.Name+'Dated'+ord.ivydsd__Order_Date__c+')');
                    oneEmail.setTargetObjectId(EmailUserIdMap.get(Ord.Resource_Email__c));
                    oneEmail.setSaveAsActivity(false);
                    oneEmail.setWhatId(Ord.id);
                    oneEmail.setTemplateId(template.Id);
                    oneEmail.setToAddresses(toAddresses);
                    myEmails.add(oneEmail);
                }
            }
        } 
        Messaging.sendEmail(myEmails);
    }
    global void finish(Database.BatchableContext bc){ }
}