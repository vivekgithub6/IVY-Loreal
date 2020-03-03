public class OrderApprovalQueuable implements Queueable {
    
    public void execute(QueueableContext qc) {  
        OrderApprovalQueuable.approvalProcess(OrderIds,getSignatureLink,imageUrlSet); 
        
    }
    public OrderApprovalQueuable(set<Id> OrderIds,List<Id> getSignatureLink,List<String> imageUrlSet)
    {
        
        this.OrderIds=OrderIds;
        this.getSignatureLink=getSignatureLink;
        this.imageUrlSet=imageUrlSet;
    }
    public set<Id> OrderIds;
    public List<Id> getSignatureLink;
    public List<String> imageUrlSet;
    public static void approvalProcess(set<Id> OrderIds,List<Id> getSignatureLink,List<String> imageUrlSet) {
       /* map<string,string> JourneyplanIdOwnerIdMap=new map<string,string>();
        List<String> resourceTypeNameList = new List<String>{ 'Area','Regional','National'};
            Id submitterId = UserInfo.getUserId();
        Map<String,Id> ApproverIdSet=new Map<String,Id>();
        
        List<ivybase__HHT_Module_Master__mdt> moduleData = [Select DeveloperName,ivybase__Flag__c from ivybase__HHT_Module_Master__mdt where DeveloperName='Order_Approval'];
        if(moduleData.size()!=null  && moduleData[0].ivybase__Flag__c == 1){
            ApproverIdSet=   ApproverIds.getAllLevelApproverIds(submitterId);
            system.debug('ApproverIds'+ApproverIdSet);
            
            string Approverid;
            for(Integer i = 0; i < resourceTypeNameList.size(); i++){
                if(Approverid==Null){
                    if(ApproverIdSet.size()>0 && ApproverIdSet.containskey(resourceTypeNameList[i]) && ApproverIdSet.get(resourceTypeNameList[i])!=Null)
                        Approverid=ApproverIdSet.get(resourceTypeNameList[i]);
                }
            }
            for(id s:OrderIds){
                // Create an approval request for the Opportunity
                if(Approverid!=Null){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval');
                    req1.setObjectId(s);
                    req1.setNextApproverIds(new Id[] {Approverid});
                    // Submit the approval request for the Opportunity
                    Approval.ProcessResult result = Approval.process(req1);  
                }
            } 
        } 
        else{
            /*contact  contact1=[select id,email from contact limit 1];//This is required for target object id 
            EmailTemplate template =  [SELECT Id, Name FROM EmailTemplate WHERE Name like 'OrderDetailsToStore' LIMIT 1];
            List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();*/
           /* List<ivydsd__Order__c> orders = [Select Id,ivydsd__Order_Status__c,Saloon_Email__c from ivydsd__Order__c where Id IN : OrderIds];
            for(ivydsd__Order__c m:orders){
                m.ivydsd__Order_Status__c='Approved';
               /* String[] toAddresses = new String[] {m.Saloon_Email__c}; 
                    Messaging.SingleEmailMessage oneEmail = new Messaging.SingleEmailMessage();    
                system.debug(toAddresses);
                oneEmail.setTreatTargetObjectAsRecipient(false);        
                oneEmail.setTargetObjectId(contact1.id);   
                oneEmail.setSaveAsActivity(false);
                oneEmail.setWhatId(m.id);
                oneEmail.setTemplateId(template.Id);
                oneEmail.setToAddresses(toAddresses);
                myEmails.add(oneEmail);
            } 
           // Messaging.SendEmailResult[] results=  Messaging.sendEmail(myEmails);
            update orders;
        }
        /*if(getSignatureLink.size()>0){
                System.enqueueJob(new S3ImageDownload(imageUrlSet,null,getSignatureLink,getSignatureLink.size()));  
            }   */
       
    }
    
}