public class JourneyPlanMarketTraslatorUpload {
    public static List<PostResponse.PostResponseObject> marketVisitTranslator(Map<String,List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>> TidAndMarketListMap,Map<String,Id> TidAndSalesforceIdMap,Map<String,Id> AccountInternalIdMap, Map<String,Id> TypeIdAndStandardListMap)
    {
        List<PostResponse.PostResponseObject> result =new List<PostResponse.PostResponseObject>();
        JourneyPlanActivity__c marketVisitRec;
        //delete the existing records
        Set<Id> JourneyPlanIdList = new Set<Id>();
        for(String id:TidAndSalesforceIdMap.keySet())
        {
            JourneyPlanIdList.add(TidAndSalesforceIdMap.get(id));
        }
        List<JourneyPlanActivity__c> marketRecordsToDelete = [select id,name from JourneyPlanActivity__c where JourneyPlan__c=:JourneyPlanIdList and (Store__c!=null AND TypeId__c!=null)];
        delete marketRecordsToDelete;
        
        List<JourneyPlanActivity__c > marketListToInsert = new List<JourneyPlanActivity__c>();
        system.debug('TidAndMarketListMap market'+TidAndMarketListMap);
        system.debug('TidAndSalesforceIdMap market'+TidAndSalesforceIdMap);
        
        // To send data only for japan
        ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
        
        for(String id:TidAndMarketListMap.keySet())
        {
            if(TidAndMarketListMap.get(id)!=null && TidAndMarketListMap.get(id).size()>0 && TidAndSalesforceIdMap.keyset().size()>0)
            {
                List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo> marketRec  = TidAndMarketListMap.get(id);
                for(LorealUploadclass.JorneyMarketMarketVisitDetailInfo m:marketRec)
                {
                    marketVisitRec = new JourneyPlanActivity__c();
                    marketVisitRec.JourneyPlan__c = TidAndSalesforceIdMap.get(id)==null?null:TidAndSalesforceIdMap.get(id);
                    marketVisitRec.Date__c=m.date_x==null?null:ConversionUtility.StringToDateConversion(m.date_x);
                    if(m.RetailerId!=null){
                        marketVisitRec.Store__c= AccountInternalIdMap.get(m.RetailerId)==null?null:AccountInternalIdMap.get(m.RetailerId);                   
                    }
                    marketVisitRec.Name=''+marketVisitRec.Date__c+'-Visit';
                    
                    // Code only JP
                    if(loggedInResource.Market_ISO__c == 'JPN') {
                        // Added newly for ANZ and JP
                        marketVisitRec.Start_Time__c = m.StartTime;
                        marketVisitRec.End_Time__c = m.EndTime;
                        // Until here
                        // To Insert Visit Type
                        marketVisitRec.TypeId__c=m.VisitType==null?null:TypeIdAndStandardListMap.get(m.VisitType);
                    }
                    
                    marketListToInsert.add(marketVisitRec);
                }
            }
        }
        Database.SaveResult[] srList = database.insert(marketListToInsert,false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted marketvist ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                     result.add(new PostResponse.PostResponseObject('0',err.getMessage()));                 
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    
                }
            }
        }
        if(result.size()==0)
        {
            result.add(new PostResponse.PostResponseObject('1','Success'));
        }
            
        
        return result;
    }
}