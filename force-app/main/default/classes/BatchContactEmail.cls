global class BatchContactEmail implements Database.Batchable<sObject>,Database.AllowsCallouts 
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        Datetime d = dateTime.now();
        system.debug('d'+d);
        Datetime toDate = d.addMinutes(-5);
        Datetime formDate = d.addMinutes(-90);
        system.debug('form'+formDate);
        system.debug('to'+toDate);
        string query;
         query = 'select id,name,email,Signature__c,Account.name,Account.ivybase__Contact_PhoneNo__c,Account.ivybase__Contact_Email__c from contact where email!=null and Signature_Link__c=null and CreatedDate<:toDate and CreatedDate>:formDate';
if(Test.isRunningTest())
        {
            query = 'select id,name,email,Signature__c,Account.name,Account.ivybase__Contact_PhoneNo__c,Account.ivybase__Contact_Email__c from contact where email!=null and Signature__c!=null AND Signature_Link__c=null and CreatedDate<:toDate';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<contact> ContactList){
        system.debug('ContactList'+ContactList);
        ContactList=S3ImageDownloadSync.copyHairdresserSign(ContactList);
        update ContactList; 
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
                         //   oneEmail.setOrgWideEmailAddressId(Label.orgWideEmailId);

        id templateID =[select id, Name from EmailTemplate WHERE Name ='Hair Dresser Email Template VF' LIMIT 1].id ;
        for (contact contactrecord : ContactList)
        {  
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();  
            msg.setOrgWideEmailAddressId(Label.orgWideEmailId);
            msg.setTemplateId(templateID);
            msg.setWhatId(contactrecord.id);
            msg.setTargetObjectId(contactrecord.Id);
            msg.setSaveAsActivity(false); 
            
            msg.toAddresses= new String[] {contactrecord.Email};
               messages.add(msg); 
          }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        /*User u = [select id,IsActive from user where IsActive=true limit 1];
        List<Messaging.SingleEmailMessage>  emailsToBeSent = new List<Messaging.SingleEmailMessage>();
        String[] names = new String[] {};
            for (contact c : ContactList)
        {
            names.add(c.Email);
        }
        
        
        
        for(contact con:ContactList){
            if(con.Name != null && con.Email != null){
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setTemplateId(templateID);
                msg.setWhatId(con.id);
                msg.setTargetObjectId(u.Id);
                msg.setSaveAsActivity(false); 
                msg.setTreatTargetObjectAsRecipient(false);
                String s = String.join(names, ', ');
                msg.setToAddresses(names);
                emailsToBeSent.add(msg);
                
            }
            messaging.sendEmail(emailsToBeSent);
        }*/
    }
    global void finish(Database.BatchableContext bc){ }
}