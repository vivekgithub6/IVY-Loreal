global class InterfaceEmailBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext bc){

        
        String query='SELECT Id,Error_Message__c,Name,Duplicate_Rows__c,Error_Rows__c,File_Path__c,Interface_Run_Date_Time__c,Market_ISO__c,'
                     +'Processed_Rows__c,Rejected_Rows__c,Total_Rows__c '
                     +'FROM Interface_Run__c '
                     +'WHERE CreatedDate = TODAY AND Name != \'Archiving\' AND File_Path__c = null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Interface_Run__c> interfaceRunList){
        
        System.debug('interfaceRunList===>'+interfaceRunList.size());
        Map<String, List<Interface_Run__c>> countrycodeIRMap = new Map<String, List<Interface_Run__c>>();
        
        for(Interface_Run__c intRun : interfaceRunList) {
            
            if(intRun.Market_ISO__c != null) {
            
                if(countrycodeIRMap.containskey(intRun.Market_ISO__c)) {
                    
                    countrycodeIRMap.get(intRun.Market_ISO__c).add(intRun);
                }
                else {
                    
                    List<Interface_Run__c> intRunList = new List<Interface_Run__c>();
                    intRunList.add(intRun);
                    countrycodeIRMap.put(intRun.Market_ISO__c, intRunList);
                }
            }
        }     
        
        Map<String, String> countryCodeEmailBodyStringMap = new Map<String, String>();
        
        for(String marketCode : countrycodeIRMap.keyset()){
           
           Boolean isError = false;
           Boolean isSucess = false;
           String emailBodyString = '';
           emailBodyString = '<html>'
                                      +'Hi,<br/><br/> The below fields contains interface run information<br/><br/>';
           String error_table = '<table border="1"><tr><td>Interface Name</td><td>Error Message</td></tr>';
           String success_table = '<table border="1"><tr><td>Interface Name</td><td>Total Rows</td><td>Processed Rows</td><td>Error Rows</td>'
                                   +'<td>Rejected Rows</td><td>Duplicate Rows</td><td>Date and Time</td></tr>';
            
           for(Interface_Run__c InterfaceId :countrycodeIRMap.get(marketCode)) {
                
                if(InterfaceId.Total_Rows__c > 0 || InterfaceId.Error_Message__c != null){  
                                               
                    if(string.isNotBlank(InterfaceId.Error_Message__c) == true) {
                        error_table += '<tr><td>'+InterfaceId.Name+'</td><td>'+InterfaceId.Error_Message__c+'</td></tr>';
                        isError = true;
                    }
                    else {
                         String interface_name = String.isNotBlank(InterfaceId.Name) == true ? InterfaceId.Name : '';
                         String total_rows = InterfaceId.Total_Rows__c != null ? String.valueOf(Integer.valueOf(InterfaceId.Total_Rows__c)) : '0';
                         String processed_rows = InterfaceId.Processed_Rows__c != null ? String.valueOf(Integer.valueOf(InterfaceId.Processed_Rows__c)) : '0';
                         String error_rows = InterfaceId.Error_Rows__c != null ? String.valueOf(Integer.valueOf(InterfaceId.Error_Rows__c)) : '0';
                         String rejected_rows = InterfaceId.Rejected_Rows__c != null ? String.valueOf(Integer.valueOf(InterfaceId.Rejected_Rows__c)) : '0';
                         String duplicate_rows = InterfaceId.Duplicate_Rows__c != null ? String.valueOf(Integer.valueOf(InterfaceId.Duplicate_Rows__c)) : '0';
                         String run_time = InterfaceId.Interface_Run_Date_Time__c!= null ? InterfaceId.Interface_Run_Date_Time__c.format('dd-MMM-YYYY hh:mm aa') : '';
                         success_table += '<tr><td>' + interface_name +'</td><td>'+total_rows+'</td>'
                                             +'<td>'+processed_rows+'</td><td>'+error_rows+'</td>'
                                             +'<td>'+rejected_rows+'</td><td>'+duplicate_rows+'</td>'
                                             +'<td>'+run_time+'</td></tr>';
                         isSucess = true;
                    }
                }                
            }
            System.debug('emailBodyString===>'+emailBodyString);
            error_table += '</table>';
            success_table += '</table>';
            
            if(isError == true) {
                emailBodyString += error_table + '<br/><br/>';
            }
            if(isSucess == true) {
                emailBodyString += success_table;
            }
            countryCodeEmailBodyStringMap.put(marketCode, emailBodyString);
        }
        //System.debug('countryCodeEmailBodyStringMap===>'+countryCodeEmailBodyStringMap);      
        
        List<Messaging.SingleEmailMessage>  emailsToBeSent = new List<Messaging.SingleEmailMessage>();
        Map<String, String[]> countryUserEmailMap = new Map<String, String[]>();
        
        //List<Inteface_Run_Emails__mdt> =
        
        for (Inteface_Run_Emails__mdt IREmail : [SELECT Id, Email__c, Country_Codes__c FROM Inteface_Run_Emails__mdt]) {
            
            System.debug('IREmail===>'+IREmail);
            
            String[] codeStringArray;
                    
            if(String.isNotBlank(IREmail.Country_Codes__c) == true) {                             
                codeStringArray = IREmail.Country_Codes__c.split(',');
            }
                        
            System.debug('codeStringArray===>'+codeStringArray);
            
            if(codeStringArray != null){
            
                for(String codeString : codeStringArray) {
                    
                    if(countryUserEmailMap.size()>0 && countryUserEmailMap.containskey(codeString)) {
                        
                        countryUserEmailMap.get(codeString).add(IREmail.Email__c);
                    }
                    else {
                        
                        String[] names = new String[] {};
                        names.add(IREmail.Email__c);
                        countryUserEmailMap.put(codeString,names);
                    }
                }
            }
        }
        
        System.debug('countryUserEmailMap===>'+countryUserEmailMap);
        //EmailTemplate template = [SELECT Id, Name, Subject FROM EmailTemplate WHERE Name ='InterfaceRunMail' LIMIT 1] ;
        
        Set<String> marketSet = new Set<String>();
                      
        for(String marketCode : countrycodeIRMap.keyset()){
            
            System.debug('msg===>'+marketCode);
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setOrgWideEmailAddressId(Label.orgWideEmailId);
            msg.setTargetObjectId(UserInfo.getUserId());
            msg.setSaveAsActivity(false); 
            msg.setTreatTargetObjectAsRecipient(false);
            msg.setSubject(marketCode + '- Interface Run Information');
            //System.debug(countryCodeEmailBodyStringMap.get(marketCode));
            msg.setHtmlBody(countryCodeEmailBodyStringMap.get(marketCode));          
            //String s = String.join(countryUserEmailMap.get(marketCode), ', ');            
            msg.setToAddresses(countryUserEmailMap.get(marketCode));
            emailsToBeSent.add(msg);
           
        }
        messaging.sendEmail(emailsToBeSent);
    }
    global void finish(Database.BatchableContext bc){
        
    }
}