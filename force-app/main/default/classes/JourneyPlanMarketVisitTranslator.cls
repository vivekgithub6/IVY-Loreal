/************************************************************
* @description This is an Translator class for RESTGeographicalHierarchyManager.
It will convert the  GeographicalHierarchy records into JSON format 
and Send to the master class.
************************************************************/
public class JourneyPlanMarketVisitTranslator {
    
    /**************************************************************************
* @description This Method will send the GeographicalHierarchy records to manager
* @param  List of GeographicalHierarchy records which are coming from service class,
Map of StandardListMaster ListName(Key) and Name(Value),Error code    

****************************************************************************/ 
    public static RExAPIResponseDomain.ResponseInfo translateJourneyMarketVisit(List<JourneyPlanActivity__c> MarketVisitList, String errorCode){
        RExAPIResponseDomain.ResponseInfo MarketVisitMasterResponce = new RExAPIResponseDomain.ResponseInfo();
        MarketVisitMasterResponce.Master = 'JourneyPlan_MarketVisitDetail';
        
        // To send data only for japan
        ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
        
        if(loggedInResource.Market_ISO__c == 'JPN') {
         MarketVisitMasterResponce.Field = new List<String>{'TId','Date','RetailerId','StartTime','EndTime','VisitType'};
        } else {
          MarketVisitMasterResponce.Field = new List<String>{'TId','Date','RetailerId'};       
        }
       
            MarketVisitMasterResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        MarketVisitMasterResponce.Next = '0';
        
        List<List<String>> marketVisitRecords = new List<List<String>>();
        
        
        
        
        if(MarketVisitList != null && errorCode == null){
            
            for(JourneyPlanActivity__c marketVisit : MarketVisitList){
                List<String> mVisitList = new List<String>();
                if(marketVisit.JourneyPlan__r.Tid__c != null){
                    mVisitList.add(marketVisit.JourneyPlan__r.Tid__c);
                }else if(marketVisit.JourneyPlan__r.InternalId__c != null){
                    mVisitList.add(marketVisit.JourneyPlan__r.InternalId__c);
                }
                else{
                    mVisitList.add(''); 
                }
                if(marketVisit.Date__c != null){
                    integer d=marketVisit.Date__c.day();
                    integer mo=marketVisit.Date__c.month();
                    integer yr=marketVisit.Date__c.year();
                    DateTime DT = DateTime.newInstance(yr, mo, d);
                    mVisitList.add(DT.format('yyyy/MM/dd'));
                }else{
                    mVisitList.add(''); 
                }
                if(marketVisit.Store__c != null){
                    mVisitList.add(string.valueof((marketVisit.Store__r.ivybase__Internal_Id__c)));
                }else{
                    mVisitList.add(''); 
                }
                
                if(loggedInResource.Market_ISO__c == 'JPN') { 
                    
                    // To send start time (Added newly for ANZ)
                    mVisitList.add(marketVisit.Start_Time__c != NULL ? marketVisit.Start_Time__c:'');
                    mVisitList.add(marketVisit.End_Time__c != NULL ? marketVisit.End_Time__c:'');
                    // Untril here (Added newly for ANZ)
                    
                    //typeid
                    if(marketVisit.TypeId__r.Name != null){
                        mVisitList.add(marketVisit.TypeId__r.Name);
                    }else{
                        mVisitList.add(''); 
                    }
                }
                marketVisitRecords.add(mVisitList);
            }
        }
        MarketVisitMasterResponce.Data = marketVisitRecords;
        return MarketVisitMasterResponce;
    }
    
    public static RExAPIResponseDomain.ResponseInfo translateMarketVisitForToday(List<JourneyPlanActivity__c> MarketVisitList, 
                                                                                 Map<String, String> visitLovIdMap, String errorCode)
    {
        RExAPIResponseDomain.ResponseInfo marketVisitMasterResponse = new RExAPIResponseDomain.ResponseInfo();
        marketVisitMasterResponse.Master = 'RetailerClientMappingMaster';
        marketVisitMasterResponse.Field = new List<String>{'RID', 'CompanyID', 'UserId', 'WeekNo', 'Date',
            'isAudit', 'WalkingSeq', 'VisitTypeId','TimeIn','TimeOut'};
                marketVisitMasterResponse.ErrorCode  = errorCode == NULL ? '0' : errorCode;
        marketVisitMasterResponse.Next = '0';
        
        List<List<String>> marketVisitRecords = new List<List<String>>();
        List<String> mVisitList;
        
        if(MarketVisitList != NULL && errorCode == NULL){
            
            for(JourneyPlanActivity__c marketVisit : MarketVisitList){
                mVisitList = new List<String>();
                
                //RID (RetailerId):
                if(marketVisit.Store__r.ivybase__Internal_Id__c != NULL)
                    mVisitList.add(String.valueOf(marketVisit.Store__r.ivybase__Internal_Id__c));
                else
                    mVisitList.add(''); 
                
                //CompanyID : 
                mVisitList.add('');
                
                //UserId : 
                mVisitList.add('');
                
                //WeekNo :
                mVisitList.add('');
                
                //Date : 
                if(marketVisit.Date__c != NULL){
                    DateTime dt = DateTime.newInstance(marketVisit.Date__c.year(), marketVisit.Date__c.month(), marketVisit.Date__c.day());
                    mVisitList.add(dt.format('yyyy/MM/dd'));
                } else 
                    mVisitList.add(System.NOW().format('yyyy/MM/dd'));
                
                //isAudit :
                mVisitList.add('');
                
                //WalkingSeq :
                mVisitList.add('');
                
                //VisitTypeId :
                if(visitLovIdMap != NULL && marketVisit.TypeId__c != NULL && visitLovIdMap.containskey(marketVisit.TypeId__r.ivybase__List_Code__c) 
                   && visitLovIdMap.get(marketVisit.TypeId__r.ivybase__List_Code__c) != NULL)
                    mVisitList.add(visitLovIdMap.get(marketVisit.TypeId__r.ivybase__List_Code__c));
                else
                    mVisitList.add('');
                //TimeIn
                if(marketVisit.Start_Time__c != NULL){
                    mVisitList.add(marketVisit.Start_Time__c);
                } else 
                    mVisitList.add('');
                //TimeOut
                if(marketVisit.End_Time__c != NULL){
                    mVisitList.add(marketVisit.End_Time__c);
                } else 
                    mVisitList.add('');
                
                marketVisitRecords.add(mVisitList);
            }
        }
        marketVisitMasterResponse.Data = marketVisitRecords;
        return marketVisitMasterResponse;
    }
}