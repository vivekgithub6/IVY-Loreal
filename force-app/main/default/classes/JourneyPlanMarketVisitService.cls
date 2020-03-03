/************************************************************
* @description This is an Service class for Journey Plan Market Visit
It will retrieve the Journey Plan Market Visit records related to Parent -Journey Plan
************************************************************/
public class JourneyPlanMarketVisitService {

    /**************************************************************************
* @description This Method will retrieve the Journey Plan Market Visit records based on Journey Plan
* @param  Journey Plan id
* @return List of Journey Plan Market Visit records
****************************************************************************/  
    public static List<JourneyPlanActivity__c> getJourneyPlanMarketVisit(List<id> JourneyPlanId){
        String[] MarketVisitFields = new String[]{'Name','Date__c','Store__r.ivybase__Internal_Id__c','Start_Time__c','End_Time__c'};

        if(SecurityUtility.checkIsAccessible('JourneyPlanActivity__c', MarketVisitFields)){
            List<JourneyPlanActivity__c> MarketVisitList = new List<JourneyPlanActivity__c>();
            System.debug('entered in If');
            MarketVisitList=[select id,Name,JourneyPlan__r.InternalId__c,JourneyPlan__r.Tid__c,Date__c,Store__r.ivybase__Internal_Id__c,Start_Time__c,End_Time__c,TypeId__r.Name from JourneyPlanActivity__c where  JourneyPlan__c=:JourneyPlanId AND Store__c !=null ];//And TypeId__c=null
            System.debug('MarketVisitList::'+MarketVisitList);
            return MarketVisitList;      
        }
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }

    }

    public static Map<Id, JourneyPlanActivity__c> getJPlanVisitForToday(){

        String[] marketVisitFields = new String[]{'Id', 'Name', 'CurrencyIsoCode', 'Comments__c', 'Date__c', 'JourneyPlan__c',
                                                  'Store__c', 'TypeId__c', 'WorkWithUserId__c', 'journeyplanactivity_internal_id__c', 'Market_ISO__c',
                                                  'Start_Time__c', 'End_Time__c', 'Store__r.ivybase__Internal_Id__c', 'TypeId__r.ivybase__List_Code__c',
                                                  'JourneyPlan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id'};

        if(SecurityUtility.checkIsAccessible('JourneyPlanActivity__c', marketVisitFields))
        {
            Map<Id, JourneyPlanActivity__c> marketVisitMap = new Map<Id, JourneyPlanActivity__c>([
                SELECT Id, Name, CurrencyIsoCode, Comments__c, Date__c, JourneyPlan__c, Store__c, TypeId__c,
                WorkWithUserId__c, journeyplanactivity_internal_id__c, Market_ISO__c, Start_Time__c, End_Time__c,
                Store__r.ivybase__Internal_Id__c, TypeId__r.ivybase__List_Code__c
                FROM JourneyPlanActivity__c 
                WHERE JourneyPlan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id = :userinfo.getUserId() 
                AND Store__c != NULL 
                AND Date__c = :System.today() AND JourneyPlan__r.Status__c='Approved'
            ]);
            system.debug('marketVisitMap '+marketVisitMap);
            return marketVisitMap;      
        }
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
}