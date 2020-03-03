public class AdhocTranslator {
    
    public static void translateData(LIST<LorealUploadclass.AdhocActivityPlanDetailInfo> AdhocActivityDetail) {
        
        LIST<ivybase__Standard_List_Master__c> standardListMasterLIST = new LIST<ivybase__Standard_List_Master__c>(); // MAP to store standlist master records.
        MAP<String, String> standlistMasterMAP = new MAP<String, String>();	// Map to store standard list master name and its Id.
        LIST<AdhocActivityPlanDetail__c> upsertLIST = new LIST<AdhocActivityPlanDetail__c>(); // List to upsert 
        SET<String> TidINSfLIST = new SET<String>();  // to store Tid's Ids in SF
        
        MAP<String, String> userInternalIdMAP = new MAP<String, String>();
        for(User u: [SELECT ID, ivybase__Internal_Id__c FROM USER WHERE Market_ISO__c = 'JPN']) {
            if(!userInternalIdMAP.containsKey(String.valueOf(u.ivybase__Internal_Id__c))){
                userInternalIdMAP.put(String.valueOf(u.ivybase__Internal_Id__c),u.Id);
            }
        }
        
        
        // to Store Tid map
        MAP<String, LorealUploadclass.AdhocActivityPlanDetailInfo> TidMAP = new MAP<String,LorealUploadclass.AdhocActivityPlanDetailInfo>();
        
        standardListMasterList = [SELECT ID, NAME 
                                  FROM ivybase__Standard_List_Master__c ];
        
        for(ivybase__Standard_List_Master__c std : standardListMasterList) {
            if(!standlistMasterMAP.containsKey(std.Name)) {
                standlistMasterMAP.put(std.Name,std.Id);
            }
        }
        system.debug('standlistMasterMAP'+ standlistMasterMAP);
        
        // Checking if AdhocActivityDetail is not null
        if(AdhocActivityDetail != NULL) {
            for(LorealUploadclass.AdhocActivityPlanDetailInfo adhocInfo : AdhocActivityDetail) {
                TidMAP.put(String.valueOf(adhocInfo.TId), adhocInfo);
            }
        }
        
        
        SET<String> IdNotinSfLIST = new SET<String>();
        IdNotinSfLIST.addAll(TidMAP.keySet());
        
        for(AdhocActivityPlanDetail__c adhocplan : [SELECT ID, Comments__c, Hour_Spent__c, TId__c
                                                    FROM AdhocActivityPlanDetail__c 
                                                    WHERE TId__c In: TidMAP.keySet()]) 
        {
            adhocplan.Comments__c = TidMAP.get(adhocplan.TId__c).Comment != NULL && TidMAP.get(adhocplan.TId__c).Comment != '' ?  TidMAP.get(adhocplan.TId__c).Comment : adhocplan.Comments__c;
            adhocplan.Hour_Spent__c = TidMAP.get(adhocplan.TId__c).HourSpent != NULL && TidMAP.get(adhocplan.TId__c).HourSpent != '' ?  TidMAP.get(adhocplan.TId__c).HourSpent.replace('Hours','HH:MM') : adhocplan.Hour_Spent__c;                 
            upsertLIST.add(adhocplan); 
            TidINSfLIST.add((String)adhocplan.TId__c);
        }
        
        
        IdNotinSfLIST.removeAll(TidINSfLIST);
        
        for(String s : TidMAP.keySet()) {
            
            if(IdNotinSfLIST.contains(s)) {
                
                //system.debug('debug****'+ standlistMasterMAP.get(TidMAP.get(s).TypeId));
                AdhocActivityPlanDetail__c adhocPlan = new AdhocActivityPlanDetail__c();
                adhocPlan.TId__c = TidMAP.get(s).TId != NULL && TidMAP.get(s).TId != '' ? TidMAP.get(s).TId : '';
                adhocPlan.Date__c = TidMAP.get(s).ActivityDate != NULL && TidMAP.get(s).ActivityDate != '' ? ConversionUtility.StringToDateConversion(TidMAP.get(s).ActivityDate) : NULL;
                adhocPlan.Standard_List_Master__c = TidMAP.get(s).TypeId != NULL && TidMAP.get(s).TypeId != '' ? standlistMasterMAP.get(TidMAP.get(s).TypeId) : '';
                adhocPlan.Comments__c = TidMAP.get(s).Comment != NULL && TidMAP.get(s).Comment != '' ? TidMAP.get(s).Comment : '';
                adhocPlan.StartTime__c = TidMAP.get(s).StartTime != NULL &&  TidMAP.get(s).StartTime != '' ? TidMAP.get(s).StartTime : '';
                adhocPlan.EndTime__c = TidMAP.get(s).EndTime != NULL && TidMAP.get(s).EndTime != '' ? TidMAP.get(s).EndTime : '';
                adhocPlan.Plan_Name__c = TidMAP.get(s).PlanName != NULL && TidMAP.get(s).PlanName != '' ? TidMAP.get(s).PlanName : '';
                adhocPlan.Hour_Spent__c = TidMAP.get(s).HourSpent != NULL && TidMAP.get(s).HourSpent != '' ? TidMAP.get(s).HourSpent.replace('Hours','HH:MM') : '';
                adhocPlan.User_Id__c = TidMAP.get(s).UserId != NULL && TidMAP.get(s).UserId != '' ? userInternalIdMAP.get(TidMAP.get(s).UserId) : NULL;
                
                upsertLIST.add(adhocPlan);
            }
        }
        
        Database.upsert(upsertLIST);
        
    }
}