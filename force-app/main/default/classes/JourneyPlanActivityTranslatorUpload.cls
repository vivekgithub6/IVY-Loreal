public class JourneyPlanActivityTranslatorUpload {
    public static List<PostResponse.PostResponseObject> activityTranslator(Map<String,List<LorealUploadclass.JourneyPlanDetailInfo>> TidAndActivityListMap,Map<String,Id> TypeIdAndStandardListMap,Map<String,Id> TidAndSalesforceIdMap)
    {
        //delete the existing records
        Set<Id> JourneyPlanIdList = new Set<Id>();
        for(String id:TidAndSalesforceIdMap.keySet())
        {
            JourneyPlanIdList.add(TidAndSalesforceIdMap.get(id));
        }
        List<JourneyPlanActivity__c> ActivityRecordsToDelete = [select id,name from JourneyPlanActivity__c where JourneyPlan__c=:JourneyPlanIdList and (TypeId__c!=null or Store__c=null)];
        delete ActivityRecordsToDelete;
        
        List<PostResponse.PostResponseObject> result = new List<PostResponse.PostResponseObject>();
        JourneyPlanActivity__c  activityRec;
        //map format : map<tid,List<activity records>>
        List<JourneyPlanActivity__c> activityRecToInsert = new List<JourneyPlanActivity__c>();
        
        // To send data only for japan
        ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
        
        //iterate over tid key of map
        for(String id:TidAndActivityListMap.keySet())
        {
            if(TidAndActivityListMap.get(id)!=null && TidAndActivityListMap.get(id).size()>0 && TidAndSalesforceIdMap.keyset().size()>0)
            {
                List<LorealUploadclass.JourneyPlanDetailInfo> ActvtyRec  = TidAndActivityListMap.get(id);
                //iterate over all the records inside the tid
                for(LorealUploadclass.JourneyPlanDetailInfo act:ActvtyRec)
                {
                    activityRec = new JourneyPlanActivity__c();
                    activityRec.Date__c = ConversionUtility.StringToDateConversion(act.date_X);
                    activityRec.TypeId__c=act.TypeId==null?null:TypeIdAndStandardListMap.get(act.TypeId);
                    activityRec.WorkWithUserId__c =act.WorkWithUserId;
                    activityRec.Name=''+activityRec.Date__c+' Activity';
                    activityRec.Comments__c=act.Comments==null?null:act.Comments;
                    activityRec.JourneyPlan__c = TidAndSalesforceIdMap.get(id)==null?null:TidAndSalesforceIdMap.get(id);
                    
                    if(loggedInResource.Market_ISO__c == 'JPN') {
                        // Added newly for ANZ and JP
                        activityRec.Start_Time__c = act.StartTime;
                        activityRec.End_Time__c = act.EndTime;
                        // Until here added for ANZ and JP
                    }
                    activityRecToInsert.add(activityRec);
                }
                
            }
        }
        
        Database.SaveResult[] srList=database.insert(activityRecToInsert,false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted ' + sr.getId());
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