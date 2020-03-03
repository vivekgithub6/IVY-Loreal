public class promotionalPlanHeaderUploadTranslator {
    public static Map<String,Id> translate(List<LorealUploadclass.PromotionalPlanninginfo> PromotionalPlanningHeader,List<ivybase__Location_Hierarchy__c> userTerritory)
    {
        system.debug('userTerritory'+userTerritory);
        List<String> tidList = new List<String>();
        List<String> tidListTemp = new List<String>();
        Set<String> tidInSF = new Set<String>();
        Map<String,Id> Sales_Forecast_Tid_Id_Map = new Map<String,Id>();
        Map<String,LorealUploadclass.PromotionalPlanninginfo> Json_Tid_Map = new Map<String,LorealUploadclass.PromotionalPlanninginfo>();
        List<Sales_Forecast__c> sales_Forecase_Rec_To_insert = new List<Sales_Forecast__c>();
        List<Sales_Forecast__c> sales_Forecase_Rec_To_update = new List<Sales_Forecast__c>();
        String[] lstMstrFields = new String[]{'ivybase__List_Code__c','ivybase__List_Type__c','ivybase__List_Name__c','Name'};
        map<string,string> statusMapListCode = RESTJourneyPlan.getJP_ActivtyFromStandardListMaaster(lstMstrFields);
            map<string,string> statusMapListCodeForStatus=new map<string,string>();
            for(string code:statusMapListCode.keyset()){
                statusMapListCodeForStatus.put(statusMapListCode.get(code),code);
            }
        if(PromotionalPlanningHeader!=null)
        {
            for(LorealUploadclass.PromotionalPlanninginfo res:PromotionalPlanningHeader)
            {
                /*if(res.date_x!=null)
                {
                    res.date_x=LOrealUploadTranslator.ConvertTOSFFormatDate(res.date_x);
                }*/
                if(res.Status!='A'){
                tidList.add(res.TId);
                Json_Tid_Map.put(res.TId,res);
                }
            }
            system.debug('tidList'+tidList);
                        system.debug('Json_Tid_Map'+Json_Tid_Map);
            list<Sales_Forecast__c> removeExistingDraftPlan= [select id,Name from Sales_Forecast__c where Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__c=:userinfo.getUserId() AND Status__c='Draft' AND name!=:tidList];
            if(removeExistingDraftPlan.size()>0)
            {
              //  delete removeExistingDraftPlan;
            }
            List<Sales_Forecast__c> salesForecastRec = [select id,Name,Date__c,Territory__c,SuperVisorComments__c,Status__c  from Sales_Forecast__c where name=:tidList];
            for(Sales_Forecast__c rec:salesForecastRec)
            {
                tidInSF.add(rec.Name);
                if(rec.Status__c!='Approved'){ 
                
                Sales_Forecast_Tid_Id_Map.put(rec.Name,rec.id);
                rec.Date__c=Json_Tid_Map.get(rec.Name).date_x==null?rec.Date__c:ConversionUtility.StringToDateConversion(Json_Tid_Map.get(rec.Name).date_x);
                rec.Status__c=Json_Tid_Map.get(rec.Name).Status==null?rec.Status__c:statusMapListCodeForStatus.get(Json_Tid_Map.get(rec.Name).Status);
                rec.SuperVisorComments__c=Json_Tid_Map.get(rec.Name).SupervisorComments==null?rec.SuperVisorComments__c:Json_Tid_Map.get(rec.Name).SupervisorComments;
                    if(userTerritory.size()>0){
                    rec.Territory__c=userTerritory[0].id;
                    }
                sales_Forecase_Rec_To_update.add(rec);
                }
            }
            system.debug('tidInSF'+tidInSF);
            //remove the exsiting tid 
            tidListTemp=tidList;
            Set<String> tidSet= new Set<String>();
            tidSet.addAll(tidList);
            
            system.debug('tidListTemp'+tidListTemp.size());
            for(String s:tidListTemp)
            {
                if(tidInSF.contains(s))
                {
                    tidSet.remove(s);
                }
            }
            tidList.clear();
            tidList.addAll(tidSet);
           system.debug('tid To Insert'+tidList);
            //insert new records
            for(String tid:tidList)
            {
                Sales_Forecast__c rec = new Sales_Forecast__c();
                rec.Date__c=Json_Tid_Map.get(tid).date_x==null?null:ConversionUtility.StringToDateConversion(Json_Tid_Map.get(tid).date_x);
                rec.Status__c=Json_Tid_Map.get(tid).Status==null?null:statusMapListCodeForStatus.get(Json_Tid_Map.get(tid).Status);
                rec.SuperVisorComments__c=Json_Tid_Map.get(tid).SupervisorComments==null?null:Json_Tid_Map.get(tid).SupervisorComments;
                if(userTerritory.size()>0){
                rec.Territory__c=userTerritory[0].id;
                }
                sales_Forecase_Rec_To_insert.add(rec);
            }
            system.debug('sales_Forecase_Rec_To_update'+sales_Forecase_Rec_To_update);
                        system.debug('sales_Forecase_Rec_To_insert'+sales_Forecase_Rec_To_insert);
            if(sales_Forecase_Rec_To_update.size()>0)
            {
                System.debug('++++ sales_Forecase_Rec_To_update ++++' + sales_Forecase_Rec_To_update);
                update sales_Forecase_Rec_To_update;
            }
            if(sales_Forecase_Rec_To_insert.size()>0)
            {
                insert sales_Forecase_Rec_To_insert;
                for(Integer i=0;i<sales_Forecase_Rec_To_insert.size();i++)
                {
                    Sales_Forecast_Tid_Id_Map.put(tidList[i],sales_Forecase_Rec_To_insert[i].id);
                }
            }
        
    }
        system.debug('Sales_Forecast_Tid_Id_Map'+Sales_Forecast_Tid_Id_Map);
        return Sales_Forecast_Tid_Id_Map;
    }
}