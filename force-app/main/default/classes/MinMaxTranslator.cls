public with sharing class MinMaxTranslator {

    public static RExAPIResponseDomain.ResponseInfo objectToMinMax(String errorcode) {
    
        List<ivybase__Location_Hierarchy__c> userTerritory = new List<ivybase__Location_Hierarchy__c>(LocationMasterService.getUserTerritory());
        Set<Id> userTerritoryIdSet = new Set<Id>(); 
        for(ivybase__Location_Hierarchy__c l:userTerritory) {
             userTerritoryIdSet.add(l.id);
        }
                 
        Set<Id> divIdSet = new Set<Id>(DivisionSerivce.getDivisionForUserTerritory(userTerritoryIdSet));
        Map<Id, ivybase__Product__c> productDivMap = new Map<Id, ivybase__Product__c>([SELECT Id FROM ivybase__Product__c WHERE Division__c IN :divIdSet]);
        Map<String, String> slmMap = new Map<String, String>();
        for(ivybase__Standard_List_Master__c slm : StandardListMasterService.getStandardListUsingListType(new List<String>{'DIVISION_TYPE'})) {
            slmMap.put(slm.ivybase__List_Name__c, slm.Name);
        }
        List<Min_Max_Product_Capping__c> minMaxList = [SELECT Id, Name, Maximum_Qty__c, Minimum_Qty__c, Product__r.ivybase__InternalId__c, Salon__c,
                                            Product__r.Division__r.Name, Product_Hierarchy__r.ivybase__Internal_Id__c,End_Date__c, Start_Date__c,
                                            Salon__r.ivybase__Internal_Id__c, Division__r.Name
                                            FROM Min_Max_Product_Capping__c WHERE Is_Active__c = true AND (Start_Date__c = null OR Start_Date__c <= TODAY) 
                                            AND (End_Date__c = null OR End_Date__c >= TODAY) AND (Product__c =:productDivMap.keySet() 
                                                OR (Product_Hierarchy__c != null AND (Division__c = null OR Division__c =:divIdSet)))];
        
        RExAPIResponseDomain.ResponseInfo MinMAxMasterResponse = new RExAPIResponseDomain.ResponseInfo();
        MinMAxMasterResponse.Master='ProductCappingAllocationMaster';
        MinMAxMasterResponse.Field = new List<String>{'PId', 'RId', 'DivisionId', 'MinQty', 'MaxQty'};
        MinMAxMasterResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        MinMAxMasterResponse.Next = '0';
        List<List<String>> MinMaxRecords = new List<List<String>>();
        
        if(MinMAxlist != null) {
        
          for(Min_Max_Product_Capping__c mmpc : minMAxlist){
          
            List<String> MinMaxListInfo = new List<String>();
            
            if(mmpc.Product__c != null) {
                MinMaxListInfo.add(String.valueOf(mmpc.Product__r.ivybase__InternalId__c));
            } else if(mmpc.Product_Hierarchy__r.ivybase__Internal_Id__c != null) {
                MinMaxListInfo.add(String.valueOf(mmpc.Product_Hierarchy__r.ivybase__Internal_Id__c));
            } else {
                MinMaxListInfo.add('0');                
            }//PId
            
            if(mmpc.Salon__r.ivybase__Internal_Id__c != null) {
                MinMaxListInfo.add(String.valueOf(mmpc.Salon__r.ivybase__Internal_Id__c));
            } else {
                MinMaxListInfo.add('0');
            }//RId
            
            if(String.isNotBlank(mmpc.Product__r.Division__r.Name) == true && slmMap.containsKey(mmpc.Product__r.Division__r.Name) == true) {
                MinMaxListInfo.add(String.valueOf(slmMap.get(mmpc.Product__r.Division__r.Name)));
            } else if(String.isNotBlank(mmpc.Division__r.Name) == true && slmMap.containsKey(mmpc.Division__r.Name) == true) {
                MinMaxListInfo.add(String.valueOf(slmMap.get(mmpc.Division__r.Name)));
            } else {
                MinMaxListInfo.add('0');                
            }//DivisionId
            
            if(mmpc.Minimum_Qty__c != null) {
                MinMaxListInfo.add(String.valueOf(mmpc.Minimum_Qty__c));
            } else {
                MinMaxListInfo.add('0');                
            }//minQty
            
            if(mmpc.Maximum_Qty__c != null) {
                MinMaxListInfo.add(String.valueOf(mmpc.Maximum_Qty__c));
            } else {
                MinMaxListInfo.add('0');                
            }//maxQty
            MinMaxRecords.add(MinMaxListInfo);                
          }
        }
        
        MinMAxMasterResponse.Data=MinMaxRecords;
        
        return MinMAxMasterResponse ;
    }
}