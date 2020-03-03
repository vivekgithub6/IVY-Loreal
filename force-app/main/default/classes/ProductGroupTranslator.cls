public class ProductGroupTranslator {

    public static RExAPIResponseDomain.ResponseInfo objectToProductTaggingInfo(List<ivybase__Product_Group__c> prodgrpList,List<ivybase__Standard_List_Master__c> SLMList, String errorCode) {
       
        RExAPIResponseDomain.ResponseInfo progrpList = new RExAPIResponseDomain.ResponseInfo();
        Map<String,String>  nameIdMap = new Map<String,String>();
        Set<STring> uniqueTop20SKU = new Set<String>();
        if(SLMList != null && SLMList.size()>0){
            
            for(ivybase__Standard_List_Master__c slm : SLMList){
               
                if(!nameIdMap.Containskey(slm.ivybase__List_Name__c)){
                    nameIdMap.put(slm.ivybase__List_Name__c,slm.Name);
                }
            }
        }
       
        progrpList.Master = 'ProductTaggingMaster';
        progrpList.Field = new List<String> {'GroupId','TaggingTypelovID'};
        List<List<String>> progrpRec = new List<List<String>>();
        
        if(prodgrpList != null && errorCode == null) {
           
            for (ivybase__Product_Group__c prodgrp : prodgrpList) {
                List<String> progrp = new List<String>();
                
                progrp.add(prodgrp.ivybase__Internal_Id__c);//GroupId
                
               /* if(prodgrp.Grouping_Type__c != NULL && nameIdMap.containskey(prodgrp.Grouping_Type__c)){
                     progrp.add(nameIdMap.get(prodgrp.Grouping_Type__c));
                }else{
                    progrp.add('');
                }*/
                
                if(prodgrp.RecordType.developerName != NULL && nameIdMap.containskey(prodgrp.RecordType.Name)){
                     progrp.add(nameIdMap.get(prodgrp.RecordType.Name));
                }else{
                    progrp.add('');
                }//TaggingTypelovID
                
                
                progrpRec.add(progrp);
            }
        }
        progrpList.Data = progrpRec;
        progrpList.ErrorCode = errorCode == null ? '0' : errorCode; 
        progrpList.Next = '0';
        return progrpList;
    }
    
    public static RExAPIResponseDomain.ResponseInfo objectToProductGroupDetailInfo(List<ivybase__Product_Group_Detail__c> prodgrpdetList, String errorCode) {
        
        RExAPIResponseDomain.ResponseInfo progrpList = new RExAPIResponseDomain.ResponseInfo();
                
        progrpList.Master = 'ProductTaggingGroupMapping';
        progrpList.Field = new List<String> {'Groupid','pid','FromNorm','ToNorm','Weightage','isOwn','catLovId','Seq','isStock','isAvail','isFacing'};
        List<List<String>> progrpdetRec = new List<List<String>>();
        Map<String,String> slmMap = new Map<String,String>();
        
        List<String> SLmTypeString = new List<String>();
        SLmTypeString.add('STORE_AST');
        //---added
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        Set<Id> userTerritoryId = new Set<Id>(); 
        for(ivybase__Location_Hierarchy__c l:userTerritory)
        {
            userTerritoryId.add(l.id);
        }
        Set<Id> divId = DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
        system.debug('divId'+divId);
        //----
        for(ivybase__Standard_List_Master__c slm : StandardListMasterService.getStandardListUsingListType(SLmTypeString)){
            if(!slmMap.containskey(slm.ivybase__List_Name__c)){
                slmMap.put(slm.ivybase__List_Name__c,slm.Name);
            }
        }
       
        if(prodgrpdetList != null && errorCode == null) {
           
            for (ivybase__Product_Group_Detail__c prodetgrp : prodgrpdetList) {
                List<String> progrp = new List<String>();
                System.debug('+++RecordType.DeveloperName'+prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName);
                System.debug('+++prodetgrp.ivybase__Product__c'+prodetgrp.ivybase__Product__c);
                System.debug('+++prodetgrp.ivybase__Product__r.Division__c'+prodetgrp.ivybase__Product__r.Division__c);
                System.debug('+++divId'+divId);
                
                if(prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Top20sku'&& prodetgrp.ivybase__Product__c != null && divId.contains(prodetgrp.ivybase__Product__r.Division__c)){
                
                progrp.add(prodetgrp.ivybase__Product_Group__r.ivybase__Internal_Id__c != null ? prodetgrp.ivybase__Product_Group__r.ivybase__Internal_Id__c : '');
                
                    
                   progrp.add(prodetgrp.ivybase__Product__c != null && prodetgrp.ivybase__Product__r.ivybase__InternalId__c != null 
                                ? String.valueOf(prodetgrp.ivybase__Product__r.ivybase__InternalId__c) : ''); 
                    
                       
                String fromToNorm = '';
                if(prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Price_Check'){
                
                    fromToNorm = prodetgrp.ivybase__Target_Price__c != null ? String.valueOf(prodetgrp.ivybase__Target_Price__c) : '';
                    
                } else if(prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Check'
                        || prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Assortment'){
                        
                    fromToNorm = prodetgrp.ivybase__Target__c != null ? String.valueOf(prodetgrp.ivybase__Target__c) : '';
                    
                }
                progrp.add(fromToNorm);//FromNorm
                progrp.add(fromToNorm);//ToNorm
                
                progrp.add(''); //Weightage
                progrp.add(prodetgrp.ivybase__Product__r.ivybase__Is_Competitor__c ? '0':'1'); //isOwn
                
                progrp.add(( prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Check' 
                                 || prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Assortment')
                           && prodetgrp.ivybase__Category__c != null && slmmap.get(prodetgrp.ivybase__Category__c) != null 
                           ? String.valueOf(slmmap.get(prodetgrp.ivybase__Category__c))
                           : ( prodetgrp.ivybase__Standard_List_Master__c != null 
                               ? prodetgrp.ivybase__Standard_List_Master__r.Name 
                               : ''));
                            
                
                
                progrp.add(prodetgrp.ivybase__Sequence__c != null ? prodetgrp.ivybase__Sequence__c :''); //Seq
                progrp.add(prodetgrp.ivybase__isStock__c ? '1':'0'); //isStock
                progrp.add(prodetgrp.ivybase__isAvail__c ? '1':'0'); //isAvail
                progrp.add(prodetgrp.ivybase__isFacing__c ? '1':'0'); //isFacing
                
                progrpdetRec.add(progrp);
                    system.debug('progrpdetRec'+progrpdetRec);
            }
                
                else if((prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName != 'Top20sku')){
                   progrp.add(prodetgrp.ivybase__Product_Group__r.ivybase__Internal_Id__c != null ? prodetgrp.ivybase__Product_Group__r.ivybase__Internal_Id__c : '');
                
                     progrp.add(prodetgrp.ivybase__Product__c != null && prodetgrp.ivybase__Product__r.ivybase__InternalId__c != null 
                                ? String.valueOf(prodetgrp.ivybase__Product__r.ivybase__InternalId__c) : '');
                       
                String fromToNorm = '';
                if(prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Price_Check'){
                
                    fromToNorm = prodetgrp.ivybase__Target_Price__c != null ? String.valueOf(prodetgrp.ivybase__Target_Price__c) : '';
                    
                } else if(prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Check'
                        || prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Assortment'){
                        
                    fromToNorm = prodetgrp.ivybase__Target__c != null ? String.valueOf(prodetgrp.ivybase__Target__c) : '';
                    
                }
                progrp.add(fromToNorm);//FromNorm
                progrp.add(fromToNorm);//ToNorm
                
                progrp.add(''); //Weightage
                progrp.add(prodetgrp.ivybase__Product__r.ivybase__Is_Competitor__c ? '0':'1'); //isOwn
                
                progrp.add(( prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Check' 
                                 || prodetgrp.ivybase__Product_Group__r.RecordType.DeveloperName == 'Stock_Assortment')
                           && prodetgrp.ivybase__Category__c != null && slmmap.get(prodetgrp.ivybase__Category__c) != null 
                           ? String.valueOf(slmmap.get(prodetgrp.ivybase__Category__c))
                           : ( prodetgrp.ivybase__Standard_List_Master__c != null 
                               ? prodetgrp.ivybase__Standard_List_Master__r.Name 
                               : ''));
                            
                
                
                progrp.add(prodetgrp.ivybase__Sequence__c != null ? prodetgrp.ivybase__Sequence__c :''); //Seq
                progrp.add(prodetgrp.ivybase__isStock__c ? '1':'0'); //isStock
                progrp.add(prodetgrp.ivybase__isAvail__c ? '1':'0'); //isAvail
                progrp.add(prodetgrp.ivybase__isFacing__c ? '1':'0'); //isFacing
                
                progrpdetRec.add(progrp); 
                }
            }
        }
        progrpList.Data = progrpdetRec;
        progrpList.ErrorCode = errorCode == null ? '0' : errorCode; 
        progrpList.Next = '0';
        return progrpList;
    }
    
    public static RExAPIResponseDomain.ResponseInfo objectToProductGroupMappingInfo(List<ivybase__Product_Group_Mapping__c> prodmapList, String errorCode) {
        
        RExAPIResponseDomain.ResponseInfo progrpmapList = new RExAPIResponseDomain.ResponseInfo();
        progrpmapList.Master = 'ProductTaggingCriteriaMapping';
        progrpmapList.Field = new List<String> {'Groupid','Distributorid','locid','accid','criteriaid','criteriatype'};
        List<List<String>> progrpmapRec = new List<List<String>>();
        
        
        if(prodmapList != null && errorCode == null){
            
            for(ivybase__Product_Group_Mapping__c promap: prodmapList){
                
                List<String> progrpmap = new List<String>();
                String pid='';
                
                if(promap.ivybase__Product_Group__r.ivybase__Internal_Id__c != null){
                    progrpmap.add(promap.ivybase__Product_Group__r.ivybase__Internal_Id__c);
                }else{
                    progrpmap.add('0');
                }//Groupid
                
                if(promap.ivybase__Distributor__r.ivybase__Internal_Id__c != null){
                    if(promap.ivybase__Distributor__r.RecordType.DeveloperName == 'Retail_Account'){
                        progrpmap.add(String.Valueof(promap.ivybase__Distributor__r.ivybase__Internal_Id__c));
                        pid = 'RETAILER';
                    }else{
                        progrpmap.add(String.Valueof(promap.ivybase__Distributor__r.ivybase__Internal_Id__c));
                        pid = 'DISTRIBUTOR';
                    }
                    
                }else{
                    progrpmap.add('0');
                }//Distributorid
                
                if(promap.ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c != null && promap.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c != null){
                    progrpmap.add(promap.ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c);
                    pid='LOCATION';
                }/* else if (promap.ivybase__Territory__r.ivybase__InternalId__c != null && promap.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c != null) {
                    progrpmap.add(String.valueOf(promap.ivybase__Territory__r.ivybase__InternalId__c));
                    pid='LOCATION';
                }*/ else{
                    progrpmap.add('0');
                }//locid
                
                progrpmap.add('0');//accid
                
                if(promap.ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c != null){
                    progrpmap.add(promap.ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c);
                    pid='LOCATION';
                } else if (promap.ivybase__Territory__r.ivybase__InternalId__c != null) {
                    progrpmap.add(String.valueOf(promap.ivybase__Territory__r.ivybase__InternalId__c));
                    pid='LOCATION';
                } else if(promap.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c != null){
                    progrpmap.add(promap.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c);
                    pid = 'CHANNEL'; 
                }else if (promap.ivybase__Distributor__r.ivybase__Internal_Id__c != null){
                    if(promap.ivybase__Distributor__r.RecordType.DeveloperName == 'Retail_Account' ) {
                        progrpmap.add(String.valueOf(String.Valueof(promap.ivybase__Distributor__r.ivybase__Internal_Id__c)));
                        pid='RETAILER';
                    }/* else{
                        progrpmap.add(String.Valueof(promap.ivybase__Distributor__r.ivybase__Internal_Id__c));
                        pid = 'DISTRIBUTOR';
                    }*/
                }else{
                    progrpmap.add('0');
                }//criteriaid
                
                progrpmap.add(pid);//criteriatype
                
                progrpmapRec.add(progrpmap);
            }
        }
       
        progrpmapList.Data = progrpmapRec;
        progrpmapList.ErrorCode = errorCode == null ? '0' : errorCode; 
        progrpmapList.Next = '0';
        return progrpmapList;
    }     
}