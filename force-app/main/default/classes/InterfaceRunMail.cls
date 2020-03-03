public class InterfaceRunMail {
    public string IntefaceRunid{get;set;}
    public Interface_Run__c interfacerun=new Interface_Run__c();
    
    public static void SendMail(List<Interface_Run__c> interfaceRunList)
    {
        try{
            //User u = [select id,IsActive from user where IsActive=true limit 1];
            List<Messaging.SingleEmailMessage>  emailsToBeSent = new List<Messaging.SingleEmailMessage>();
            String[] names = new String[] {};
            String market_iso = interfaceRunList[0].Market_ISO__c;
            for (Inteface_Run_Emails__mdt t : [SELECT Id, Email__c FROM Inteface_Run_Emails__mdt 
                            WHERE Country_Codes__c LIKE :('%' + market_iso + '%')]) {
                names.add(t.Email__c);
            }
     
            EmailTemplate template = [SELECT Id, Name, Subject FROM EmailTemplate WHERE Name ='InterfaceRunMail' LIMIT 1] ;
                              
            for(Interface_Run__c ir : interfaceRunList){
                if(ir.Name != 'Archiving' && ir.File_Path__c == null &&  (ir.Total_Rows__c > 0 || ir.Error_Message__c != null)){
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setOrgWideEmailAddressId(Label.orgWideEmailId);
                    msg.setTemplateId(template.Id);
                    msg.setWhatId(ir.id);
                    msg.setTargetObjectId(UserInfo.getUserId());
                    msg.setSaveAsActivity(false); 
                    msg.setTreatTargetObjectAsRecipient(false);
                    msg.setSubject(market_iso + ' - Interface Run Details');
                    String s = String.join(names, ', ');
                    msg.setToAddresses(names);
                    emailsToBeSent.add(msg);
                    System.debug(msg);
                }
               
               messaging.sendEmail(emailsToBeSent);
            }
        } catch(Exception e){
            system.debug('error'+e.getMessage() +'trace->'+e.getStackTraceString());
        }
    }
}