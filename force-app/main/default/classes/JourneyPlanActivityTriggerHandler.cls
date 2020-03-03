public class JourneyPlanActivityTriggerHandler {

    public Static void handlerMethod(SET<Id> journeyPladIdSet){
        
        /* Checking if journeyPladIdSet is not NULL */
        if(journeyPladIdSet != NULL) {
            
            LIST<JourneyPlanActivity__c> journeyPlanActivityList = new LIST<JourneyPlanActivity__c>();
            
            /* Querying for journey plan activity */
            journeyPlanActivityList = [SELECT Id, Activity_Name__c, JourneyPlan__c 
                               FROM  JourneyPlanActivity__c 
                               WHERE JourneyPlan__c IN : journeyPladIdSet order by Activity_Name__c];
            
            //LIST<ivybase__Standard_List_Master__c> stdList = new LIST<ivybase__Standard_List_Master__c>();
            MAP<Id,STring> standardListMasterMap = new MAP<Id,String>();
            
            for(ivybase__Standard_List_Master__c std : [SELECT Id, ivybase__List_Name__c FROM ivybase__Standard_List_Master__c WHERE ivybase__List_Type__c = 'JP_ACTIVITY' OR ivybase__List_Type__c = 'VISIT_TYPE']) {
                
                   if(!standardListMasterMap.containsKey(std.Id)){
                       standardListMasterMap.put(std.Id, std.ivybase__List_Name__c);
                   }                                 
            }
            
            system.debug('standardListMasterMap'+ standardListMasterMap);
            
            LIST<JourneyPlan__c> journeyPlanUpdateList =  new LIST<JourneyPlan__c>();
            AggregateResult[] aggregateResults = [SELECT count(Id) snt, TypeId__c  aname, JourneyPlan__c
                                                  FROM  JourneyPlanActivity__c 
                                                  WHERE JourneyPlan__c IN : journeyPladIdSet group by TypeId__c,JourneyPlan__c];
            
           	MAP<id,JourneyPlan__c> jpMap = new MAP<id,JourneyPlan__c>();
            
            for(AggregateResult a : aggregateResults) {
                
                system.debug('a****'+ a);
                String recordId = (Id)a.get('JourneyPlan__c');
                JourneyPlan__c jp = new JourneyPlan__c(Id = recordId);
              
                Integer totalVisits;
                if(jpMap.containskey(jp.Id)){
                    journeyPlan__c jc = jpMap.get(jp.Id);
                    if(jc.Number_of_Business_Visit_Records__c != NULL)
                        jp.put('Number_of_Business_Visit_Records__c',jc.Number_of_Business_Visit_Records__c);
                    if(jc.Number_of_Rinten_Records__c != NULL)
                        jp.put('Number_of_Rinten_Records__c',jc.Number_of_Rinten_Records__c);
                    if(jc.Number_of_Doko_Records__c != NULL)
                        jp.put('Number_of_Doko_Records__c',jc.Number_of_Doko_Records__c);
                    if(jc.Number_of_Agent_Visits__c != NULL)
                        jp.put('Number_of_Agent_Visits__c',jc.Number_of_Agent_Visits__c);
                    if(jc.Number_of_Other_Visits__c != NULL){
                         jp.put('Number_of_Other_Visits__c',(Integer)jc.Number_of_Other_Visits__c);
                        totalVisits = (Integer)jc.Number_of_Other_Visits__c;
                    }
                       // jp.put('Number_of_Other_Visits__c',jc.Number_of_Other_Visits__c);
                    
                }
                
                if(standardListMasterMap.containsKey((string)a.get('aname')) && standardListMasterMap.get((string)a.get('aname')) == 'Business Visit') {
                    jp.put('Number_of_Business_Visit_Records__c',(Integer)a.get('snt'));
                } 
                
                if( standardListMasterMap.containsKey((string)a.get('aname')) &&  standardListMasterMap.get((string)a.get('aname')) == 'Rinten') {
                    jp.put('Number_of_Rinten_Records__c',(Integer)a.get('snt'));
                }
                
                if(standardListMasterMap.containsKey((string)a.get('aname')) && standardListMasterMap.get((string)a.get('aname')) == 'Doko' && a.get('snt') != NULL) {
                    jp.put('Number_of_Doko_Records__c',(Integer)a.get('snt'));
                }
                    
                if(standardListMasterMap.containsKey((string)a.get('aname')) &&  standardListMasterMap.get((string)a.get('aname')) == 'Agent Visit' && a.get('snt') != NULL) {
                	jp.put('Number_of_Agent_Visits__c',(Integer)a.get('snt'));
                }
                if(standardListMasterMap.containsKey((string)a.get('aname')) && 
                   standardListMasterMap.get((string)a.get('aname')) != 'Agent Visit' &&
				   standardListMasterMap.get((string)a.get('aname')) != 'Doko' && 
                   standardListMasterMap.get((string)a.get('aname')) != 'Rinten' && 
                   standardListMasterMap.get((string)a.get('aname')) != 'Business Visit' &&
                   a.get('snt') != NULL){
                       system.debug('other visits **** '+ (Integer)a.get('snt'));
                       system.debug('totalVisits '+ totalVisits);
                       if(totalVisits != NULL) {
                           jp.put('Number_of_Other_Visits__c',totalVisits + (Integer)a.get('snt'));
                       } else {
                           jp.put('Number_of_Other_Visits__c',(Integer)a.get('snt'));
                           //jp.Number_of_Other_Visits__c = (Integer)a.get('snt');
                       }
                       system.debug('number of other visits '+ jp.get('Number_of_Other_Visits__c'));
                   }
                system.debug('jp-->'+ jp);
               jpMap.put(jp.Id,jp);
                
            }
            system.debug('jpMap.values()'+ jpMap.values());
            database.update(jpMap.values());
        }
    }
}