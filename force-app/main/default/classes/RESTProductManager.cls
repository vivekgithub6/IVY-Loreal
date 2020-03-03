@RestResource(urlMapping='/v1/ProductMaster/Masters/*')
global with sharing class RESTProductManager  {
    
    @HttpGet
    global static void getProductMasters() {
        
        if(!Test.isRunningTest()){
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
        
        RestRequest req = Restcontext.request;
        Map<String,String> getHeaders = req.Headers;
        
        try { 
            
            system.debug('entering');
            //Get all Product Level info configured in Standard List Maste
            List<ivybase__Standard_List_Master__c> stdList = StandardListMasterService.getStandardListUsingListType(new List<String>{'PRODUCT_HIERARCHY'});//,'PRODUCT_UOM' removed from list by DV
            Map<String, String> storeRecordTypeWithLevelId = StandardListMasterTranslator.getListTypeWithListId(stdList);
            Map<Id,String> prodidwithuomMap = new Map<Id,String>();
            system.debug('storeRecordTypeWithLevelId'+storeRecordTypeWithLevelId);
            List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
            Set<Id> userTerritoryId = new Set<Id>(); 
            for(ivybase__Location_Hierarchy__c l:userTerritory)
             {
                 userTerritoryId.add(l.id);
             }
             system.debug('userTerritoryId'+userTerritoryId);
             
             Set<Id> divId = DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
            system.debug('divId'+divId); 
            //Get all own (non-competitor) Product data 
             set<Id> productHierarchyFunctionId = new Set<Id>(); 
            set<id> SKUIDs=new set<id>();
            List<ivybase__Product__c> prodList = ProductService.getAllProduct_List(divId);
            for(ivybase__Product__c p:prodList)
            {
                SKUIDs.add(p.id);
                productHierarchyFunctionId.add(p.ivybase__Parent__c);
            }
            system.debug('SKUIDs'+SKUIDs);
          map<string,string> SubAxeLevelLovids = ProductHierarchyService.getSubAxeLevelLOVids(SKUIDs);
            System.debug('SubAxeLevelLovids:::'+SubAxeLevelLovids);
            //Get all own (non-competitor) Product Hierarchy data            
            List<ivybase__Product_Hierarchy__c> prodHierachyList =  ProductHierarchyService.getAllProductHierarchy_List_For_The_Function(productHierarchyFunctionId);
            
            
            //Prepare the data
            List<ivybase__Product_UOM__c> prdtUOMList = ProductUOMService.getProductUOMList(divId);
            
            for(ivybase__Product_UOM__c uom : prdtUOMList){
                String uoms = '';
                if(!prodidwithuomMap.containskey(uom.ivybase__Product__c)){
                    
                    prodidwithuomMap.put(uom.ivybase__Product__c,'');
                }
                if(prodidwithuomMap.get(uom.ivybase__Product__c) != ''){ 
                    uoms = prodidwithuomMap.get(uom.ivybase__Product__c) + '/';
                }
                uoms += uom.ivybase__UOM__c;
                prodidwithuomMap.put(uom.ivybase__Product__c,uoms);
            }
           
            String responseJSON = ProductTranslator.productMasterResponse(prodHierachyList, prodList, storeRecordTypeWithLevelId,prodidwithuomMap, SubAxeLevelLovids, stdList, prdtUOMList, null);
            if(!Test.isRunningTest()){
            
                RestContext.response.responseBody = Blob.valueOf(responseJSON);
            }           

          
        
        } /*catch (SecurityUtility.ExtSFDCAccessControlException ex) {

            if(ex.objectName.containsIgnoreCase('Standard_List_Master__c')) {
                String responseJSON = ProductTranslator.productMasterResponse(null,null,null,null,null,null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
                if(!Test.isRunningTest()){
            
                    RestContext.response.responseBody = Blob.valueOf(responseJSON);
                } 
            }else if(ex.objectName.containsIgnoreCase('Product_UOM__c')) {
                String responseJSON = ProductTranslator.productMasterResponse(null,null,null,null,null,null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
                if(!Test.isRunningTest()){
            
                    RestContext.response.responseBody = Blob.valueOf(responseJSON);
                } 
            }
        } catch (SecurityUtility.SFDCAccessControlException ex) {*/
        catch(Exception ex) {
            String responseJSON = ProductTranslator.productMasterResponse(null,null,null,null,null,null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            if(!Test.isRunningTest()){
            
                RestContext.response.responseBody = Blob.valueOf(responseJSON);
            } 
        }   
    }
}