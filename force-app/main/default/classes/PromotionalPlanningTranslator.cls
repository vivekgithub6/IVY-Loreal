public class PromotionalPlanningTranslator {
/**************************************************************************
        * @description This Method will send the Promotionalplan records to Restclass
        * @param  List of promotionalplan records which are coming from service class,
             Map of StandardListMaster ListName(Key) and Name(Value),Error code    
        
        ****************************************************************************/
    public static RExAPIResponseDomain.ResponseInfo objectToPromotionalPlan(List<Sales_Forecast__c> promotionplanlist,map<string,string> statusMapListCode,string errorcode){
    RExAPIResponseDomain.ResponseInfo promotionalPlanMasterResponse = new RExAPIResponseDomain.ResponseInfo();
    promotionalPlanMasterResponse.Master='PromotionalPlanningHeader';
    promotionalPlanMasterResponse.Field = new List<String>{'TId','Date','Status','UserId','SupervisorComments'};
    promotionalPlanMasterResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    promotionalPlanMasterResponse.Next = '0';
    
        //used to holding the list of Promotion plan records.
    List<List<String>> promoplanRecords = new List<List<String>>();
    system.debug('promotionplanlist'+promotionplanlist);
    if(promotionplanlist !=Null){
        //iterating the list of records which are passing from service class
    	for(Sales_Forecast__c promotionalPlanrecordList :promotionplanlist ){
    	List<String> pplanListInfo = new List<String>();
    	
           
    	if(promotionalPlanrecordList.Name != null){
                     pplanListInfo.add(promotionalPlanrecordList.Name);
                 }else{
                    pplanListInfo.add(''); 
                 }
         if(promotionalPlanrecordList.Date__c != null){
            		// Date d = journyPlanrecordList.Date__c;
             		integer d=promotionalPlanrecordList.Date__c.day();
                     integer mo=promotionalPlanrecordList.Date__c.month();
                     integer yr=promotionalPlanrecordList.Date__c.year();
                     DateTime DT = DateTime.newInstance(yr, mo, d);
             
                     pplanListInfo.add(dt.format('yyyy/MM/dd'));
                 }else{
                    pplanListInfo.add(''); 
                 }
            if(promotionalPlanrecordList.Status__c != null){
                     //jplanListInfo.add(journyPlanrecordList.Status__c);
                     pplanListInfo.add(statusMapListCode.get(promotionalPlanrecordList.Status__c));
                 }else{
                    pplanListInfo.add(''); 
                 } 
    	  if(promotionalPlanrecordList.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c != null){
                     pplanListInfo.add((promotionalPlanrecordList.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c).format());
                 }else{
                    pplanListInfo.add(''); 
                 }
          
           if(promotionalPlanrecordList.SupervisorComments__c != null){
                     pplanListInfo.add(promotionalPlanrecordList.SupervisorComments__c);
                 }else{
                    pplanListInfo.add(''); 
                 }
            
          
          promoplanRecords.add(pplanListInfo);                
    	}
    }
    
    promotionalPlanMasterResponse.Data=promoplanRecords;
    
    return promotionalPlanMasterResponse;
    }

    public static RExAPIResponseDomain.ResponseInfo objectToPromotionalPlanDetail(List<Sales_Forecast_Detail__c> promotionplanDetlist,string errorcode){
    RExAPIResponseDomain.ResponseInfo promotionalPlanMasterResponse = new RExAPIResponseDomain.ResponseInfo();
    promotionalPlanMasterResponse.Master='PromotionalPlanningDetails';
    promotionalPlanMasterResponse.Field = new List<String>{'TId','SchemeId','RetailerId','pid','Value','Qty'};
    promotionalPlanMasterResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    promotionalPlanMasterResponse.Next = '0';
        
            List<List<String>> promoplanDetRecords = new List<List<String>>();
            system.debug('promotionplanDetlist'+promotionplanDetlist);
            if(promotionplanDetlist !=Null){
                for(Sales_Forecast_Detail__c forecstDetail : promotionplanDetlist){
                    List<String> planListDetInfo = new List<String>();
                    if(forecstDetail.Sales_Forecast__c != null){
                        planListDetInfo.add(forecstDetail.Sales_Forecast__r.Name);
                    }else{
                        planListDetInfo.add('');
                    }
                    
                    if(forecstDetail.Scheme__c != null){
                        planListDetInfo.add(forecstDetail.Scheme__r.ivydsd__Internal_Id__c);
                    }else{
                        planListDetInfo.add('');
                    }
                    
                    if(forecstDetail.Store__c != null){
                        planListDetInfo.add(String.valueOf(forecstDetail.Store__r.ivybase__Internal_Id__c));
                    }else{
                       planListDetInfo.add(''); 
                    }
                    
                   if(forecstDetail.Standard_List_Master__c != null){
                        planListDetInfo.add(forecstDetail.Standard_List_Master__r.Name);
                    }else{
                        planListDetInfo.add('');
                    }
                    
                    if(forecstDetail.Target__c != null){
                        planListDetInfo.add(String.valueOf(forecstDetail.Target__c));
                    }else{
                        planListDetInfo.add(''); 
                    }
                    
                    if(forecstDetail.Quantity__c != null){
                        planListDetInfo.add(String.valueOf(forecstDetail.Quantity__c));
                    }else{
                        planListDetInfo.add('');
                    }
                    
                    promoplanDetRecords.add(planListDetInfo);
                    
                }
                
            }
        promotionalPlanMasterResponse.Data = promoplanDetRecords;
        return promotionalPlanMasterResponse;
        
        
    }
}