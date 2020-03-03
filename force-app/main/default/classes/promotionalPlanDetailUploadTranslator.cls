public class promotionalPlanDetailUploadTranslator {
    public static void translate(Map<String,Id> Sales_Forecast_Tid_Id_Map,List<LorealUploadclass.PromotionalPlanningDetail> PromotionalPlanningDetails)
    {
        Set<String> setOfSchemeId = new Set<String>();
            Map<String,Id> schemeIdMap = new Map<String,Id>();
            Set<Decimal> setOfRetailerId = new Set<Decimal>();
            Map<String,Id> RetailerIdMap = new Map<String,Id>();
            Set<String> setOflovid = new Set<String>();
            Map<String,Id> ProductIdMap = new Map<String,Id>();
        	map<string,Id> lovidmap= new map<string,Id> ();
            List<Sales_Forecast_Detail__c> recordsToInsert = new List<Sales_Forecast_Detail__c>();
        	//deleting the exisiting records 
        	Set<Id> masterId = new Set<Id>();
        	for(String tid:Sales_Forecast_Tid_Id_Map.keyset())
            {
                masterId.add(Sales_Forecast_Tid_Id_Map.get(tid));
            }
        	List<Sales_Forecast_Detail__c> recordToDelete = [select id,name from Sales_Forecast_Detail__c where Sales_Forecast__c=:masterId];
        	delete recordToDelete;
            for(LorealUploadclass.PromotionalPlanningDetail res:PromotionalPlanningDetails)
            {
                if(res.pid!=null)
                {
                    setOflovid.add(res.pid);// instead of Phid we are getting Standardlist master LovID
                }
                if(res.RetailerId!=null && String.isEmpty(res.RetailerId)==false)
                {
                    setOfRetailerId.add(Decimal.valueOf(res.RetailerId)); 
                }
                if(res.SchemeId!=null)
                {
                    setOfSchemeId.add(res.SchemeId);
                }
               
                
            }
        map<String,string> schemeTypeMap = Schemeutility.update_IsNewLaunchCheckbox(setOfSchemeId);
        system.debug('schemeTypeMap'+schemeTypeMap);
        List<RecordType> recordTypeList = RecordTypeService.getObjectBasedRecordTypesCustomOne('Sales_Forecast_Detail__c');
		Map<String,Id> recordTypeNameAndIdMap = new Map<String,Id>();
        for(RecordType r:recordTypeList)
        {
         recordTypeNameAndIdMap.put(r.DeveloperName, r.Id);   
        }
                system.debug('recordTypeNameAndIdMap'+recordTypeNameAndIdMap);
            //getting saelsforce Id for all the internal id came in JSON
            for(ivydsd__Scheme__c rec:[select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c where ivydsd__Internal_Id__c=:setOfSchemeId])
            {
                schemeIdMap.put(rec.ivydsd__Internal_Id__c,rec.Id);
            }
            for(Account rec:[select id,ivybase__Internal_Id__c  from Account where ivybase__Internal_Id__c=:setOfRetailerId])
            {
                RetailerIdMap.put(String.valueOf(rec.ivybase__Internal_Id__c),rec.Id);
            }
        	system.debug('setOflovid'+setOflovid);
            for(ivybase__Standard_List_Master__c lovrec:[select id,name  from ivybase__Standard_List_Master__c	 where name IN:setOflovid])
            {
                system.debug('lovrec'+lovrec);
                lovidmap.put((String)lovrec.name,lovrec.Id);
            }
            for(LorealUploadclass.PromotionalPlanningDetail res:PromotionalPlanningDetails){
                Sales_Forecast_Detail__c records=new Sales_Forecast_Detail__c ();
                if(Sales_Forecast_Tid_Id_Map.containsKey(res.TId)){
                    records.Sales_Forecast__c=Sales_Forecast_Tid_Id_Map.get(res.TId);
                    if(res.RetailerId!=null)
                    {
                        if(RetailerIdMap.containsKey(res.RetailerId)){
                            records.Store__c=RetailerIdMap.get(res.RetailerId);
                        }
                    }
                   	system.debug('res.SchemeId'+res.SchemeId);
                    if(res.SchemeId!=null && String.isEmpty(res.SchemeId)==false)
                    {
                        if(schemeTypeMap.containsKey(res.SchemeId))
                            {
                                if(recordTypeNameAndIdMap.containsKey(schemeTypeMap.get(res.SchemeId)))
                                {
                                    records.RecordTypeId=recordTypeNameAndIdMap.get(schemeTypeMap.get(res.SchemeId));
                                	system.debug('recordTypeNameAndIdMap.get(schemeTypeMap.get(res.SchemeId))'+recordTypeNameAndIdMap.get(schemeTypeMap.get(res.SchemeId)));
                                }
                            }
                        if(schemeIdMap.containsKey(res.SchemeId)){
                            records.Scheme__c=schemeIdMap.get(res.SchemeId);
                            if(res.Value!=null && String.isEmpty(res.Value)==false)
                            {
                                records.Target__c=ConversionUtility.StringToDecimal(res.Value); 
                            }
                            if(res.Qty!=null && String.isEmpty(res.Qty)==false)
                            {
                                records.Quantity__c =ConversionUtility.StringToDecimal(res.Qty);
                            }
                        }
                    }
                    system.debug('res.pid'+res.pid);
                    if(res.pid!=null && res.pid!='')
                    {
                        system.debug('lovidmap'+lovidmap);
                        if(lovidmap.containsKey(res.pid)){
                            records.Standard_List_Master__c=lovidmap.get(res.pid);
                            
                            if(res.Value!=null && String.isEmpty(res.Value)==false)
                            {
                                records.Target__c=ConversionUtility.StringToDecimal(res.Value);
                            }
                            if(res.Qty!=null && String.isEmpty(res.Qty)==false)
                            {
                                records.Quantity__c =ConversionUtility.StringToDecimal(res.Qty);
                            }
                        }
                    }
                    recordsToInsert.add(records);
                }
            }
            if(recordsToInsert.size()>0)
            {
                insert recordsToInsert;
            }
    }

}