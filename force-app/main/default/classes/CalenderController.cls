public class CalenderController {
    
    @AuraEnabled
    public static JourneyPlanWrapper loadCalender(String salesRepUserId) {
        
        User userRecord = [SELECT ID, Market_ISO__c 
                           FROM USER 
                           WHERE ID =: userInfo.getUserId()];
        
        system.debug('salesRepUserId'+ salesRepUserId);
        
        JourneyPlanWrapper jpInstance = new JourneyPlanWrapper();
        
        LIST<CountryCodeMarketISO__mdt>  userMdtLIST = new LIST<CountryCodeMarketISO__mdt>();
        
        userMdtLIST   = [SELECT ID, Country__c, Display_Journey_Plan_Calender__c, Calender_Date_Range__c 
                         FROM CountryCodeMarketISO__mdt 
                         WHERE Country__c =: userRecord.Market_ISO__c AND Display_Journey_Plan_Calender__c = TRUE];
        
        system.debug('userMdtLIST'+ userMdtLIST);
        
        if(userMdtLIST.size() >0 ) {
            
            LIST<JourneyPlanActivity__c> jpActivityRecordsLIST = new LIST<JourneyPlanActivity__c>();
            
            LIST<Rintin_Plan_Details__c>  AllRintenPlanDetailsList = new LIST<Rintin_Plan_Details__c>();
            LIST<Rintin_Plan_Details__c>  rintenPlanDetailsList = new LIST<Rintin_Plan_Details__c>();
            LIST<Rintin_Plan_Details__c>  dokoPlanDetailsList = new LIST<Rintin_Plan_Details__c>();
            
            LIST<Id> journeyPlanIdList = new LIST<Id>();
            
            Integer dateRange = (Integer)userMdtLIST[0].Calender_Date_Range__c;
            
            jpActivityRecordsList = [SELECT ID, NAME, JourneyPlan__c, JourneyPlan__r.Name, 
                                     Date__c, Activity_Name__c, End_Time__c, Start_Time__c 
                                     FROM JourneyPlanActivity__c 
                                     WHERE (date__c = LAST_MONTH OR date__c = THIS_MONTH OR  date__c = NEXT_N_MONTHS:3 )
                                     AND CreatedById =: salesRepUserId AND Activity_Name__c != 'Rinten' AND Activity_Name__c != 'Doko'];
            
            for(JourneyPlanActivity__c jpa : jpActivityRecordsList) {
				journeyPlanIdList.add(jpa.JourneyPlan__c);                
            }
            
            AllRintenPlanDetailsList = [SELECT Id, Name,  Rintin_Plan__c, Rintin_Plan__r.Name, Agent__c, Agent__r.Name, Hair_Dresser__c, 
                                        IsDoko__c, Retailer_Id__c, Retailer_Id__r.Name,isActive__c, IsRinten__c, Rintin_Plan__r.StartTime__c,
                                        Rintin_Plan__r.EndTime__c, Rintin_Plan__r.Date__c  
                                        FROM Rintin_Plan_Details__c 
                                        WHERE   CreatedById =: salesRepUserId AND Rintin_Plan__r.Journey_Plan__r.Id IN: journeyPlanIdList AND
                                        (Rintin_Plan__r.Date__c = LAST_MONTH OR Rintin_Plan__r.Date__c = THIS_MONTH 
                                         OR  Rintin_Plan__r.Date__c = NEXT_N_MONTHS:3)];
            
            for(Rintin_Plan_Details__c rpd : AllRintenPlanDetailsList) {
                
                if(rpd.IsDoko__c) {
                    dokoPlanDetailsList.add(rpd);
                }  else {
                   rintenPlanDetailsList.add(rpd);
                }
            }
            jpInstance.journeyPlanActivityRecords = jpActivityRecordsList;
            jpInstance.RintinPlanDetails = rintenPlanDetailsList;
            jpInstance.DokoPlanDetails = dokoPlanDetailsList;
            
            system.debug(jpInstance);
        }
        return jpInstance;
    }
    
    public class JourneyPlanWrapper {
        
        @AuraEnabled public LIST<JourneyPlan__c> journeyplanRecords;
        @AuraEnabled public LIST<JourneyPlanActivity__c> journeyPlanActivityRecords;
        @AuraEnabled public LIST<Rintin_Plan_Details__c> RintinPlanDetails;
        @AuraEnabled public LIST<Rintin_Plan_Details__c> DokoPlanDetails;
        
    }
    
}