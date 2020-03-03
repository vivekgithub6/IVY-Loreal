@RestResource(urlMapping='/v1/DiscountManager/Masters/*')
global with sharing class RESTDiscountManager {
    
    @HttpGet
    global static void getDiscount() {
        
        if(!Test.isRunningTest()) {
            RestContext.response.addHeader('Content-Type', 'application/json');
        }
        
        RestRequest req = Restcontext.request;
        Map<String,String> getHeaders = req.Headers;
        String responseJSON = '';
        JSONGenerator jsongen = JSON.createGenerator(true);
                
        try {
            Set<Id> storeHierarchyIds = new Set<Id>();
            Id sellerId = ResourceService.getLoginSellerId();
            storeHierarchyIds = AccountService.getSetOfHierarchyForThisResource(); 
            
            Set<Id> accountId = new Set<Id>();
            List<Account> accountlist = AccountService.getAllRetailerMaster_List_for_Resource();
            for(Account a:accountlist) {
                accountId.add(a.id);
            }
            Set<Id> discountId = new Set<Id>();
            List<ivydsd__Discount_Mapping__c> discmaplist=DiscountService.getDiscountFromDiscountMapping(storeHierarchyIds,accountId);
            for(ivydsd__Discount_Mapping__c d:discmaplist)
            {
               discountId.add(d.ivydsd__Discount__c); 
            }
            List<ivydsd__Discount__c> discountList = DiscountService.getAllDiscount_List(discountId);
            List<String> Listtype = new List<String> {'DISCOUNT_TYPE','DISCOUNT_APPLY_TYPE','DISCOUNT_MODULE_TYPE'};
            List<ivybase__Standard_List_Master__c> SLMList = StandardListMasterService.getStandardListUsingListType(Listtype);
                               
            jsongen = DiscountTranslator.objectToDiscountInfo(jsongen, discountList,SLMList,null);
            
            List<ivybase__Location_Hierarchy__c> territoryList = [SELECT Id, Name, ivybase__Primary_Resource__r.Name FROM ivybase__Location_Hierarchy__c 
                                                   WHERE ivybase__Primary_Resource__r.ivybase__Related_User__c =:UserInfo.getUserId() AND ivybase__Active__c = 'Yes'
                                                        AND RecordType.DeveloperName = 'Territory' ORDER  BY LastModifiedDate LIMIT 1];
            List<CountryCodeMarketISO__mdt> cmdList = new List<CountryCodeMarketISO__mdt>();
            if(territoryList != null && territoryList.isEmpty() == false) {
                 cmdList = [SELECT Id FROM CountryCodeMarketISO__mdt WHERE Country__c = 'SG' AND 
                                                 Attachment_Discount__c LIKE :'%'+territoryList[0].ivybase__Primary_Resource__r.Name+'%'];
            }
            if(cmdList != null && cmdList.isEmpty() == false) {
                jsongen = DiscountTranslator.objectToDiscountDetailInfo(jsongen, new List<ivydsd__Discount_Detail__c>(), new Map<Id,Map<Id,Decimal>>(), null);
        	} else {
                List<ivydsd__Discount_Detail__c> discproddetlist = DiscountService.getAllDiscountDetail_List(discountId);
                System.debug('discproddetlist::'+discproddetlist);
                
                Set<Id> BOMDiscountDetail = new Set<Id>();
                Set<Id> BOMDiscountProduct = new Set<Id>();
                
                for(ivydsd__Discount_Detail__c dd:discproddetlist)
                {
                    if(dd.ivydsd__Value__c==null)
                    {
                     BOMDiscountDetail.add(dd.id);
                     BOMDiscountProduct.add(dd.ivydsd__Product__c);
                    }
                }
                Map<Id,Map<Id,Decimal>> BOMChildQuantity = new Map<Id,Map<Id,Decimal>> ();
                PricingConditions.getQuantityIfItsBOMProduct(BOMDiscountProduct,BOMChildQuantity);
                Map<Id,Map<Id,Decimal>> BOMFinalPrice = new Map<Id,Map<Id,Decimal>>();
                List<ivydsd__Discount_Detail__c> grandChildDiscountDetailEntry = DiscountService.getAllDiscountDetail_List_GrandChild(BOMDiscountDetail);
              
                system.debug('BOMFinalPrice'+BOMFinalPrice);
                discproddetlist.addAll(grandChildDiscountDetailEntry);
                
                jsongen = DiscountTranslator.objectToDiscountDetailInfo(jsongen, discproddetlist,BOMFinalPrice,null);
                
            }
            jsongen = DiscountTranslator.objectToDiscountMappingInfo(jsongen, discmaplist,null);
             if(!Test.isRunningTest()) {
                RestContext.response.responseBody = Blob.valueOf(jsongen.getAsString());
            }
            /*else {
                Attachment att = [SELECT Id, Name, Body FROM Attachment WHERE Name =:territory.Id + '.txt'];
                responseJSON = att.Body.toString();
                system.debug('****responseJSON'+responseJSON);
                jsongen = DiscountTranslator.objectToDiscountMappingInfo(jsongen, discmaplist,null);
                string sss= jsongen.getAsString();
                Map<String, Object> metadata_Map = new Map<String, Object>();
                metadata_Map = (Map<String, object>) JSON.deserializeUntyped(sss);
                List<Object> lstObj = new List<Object>();
                list<Object> lst =  (list<object>)metadata_Map.get('Tables');
                object o= json.deserializeUntyped(responseJSON);
                lst.add(o);
                metadata_Map.put('Tables',lst);
                if(!Test.isRunningTest()){
                    RestContext.response.responseBody = Blob.valueOf(json.serializePretty(metadata_Map) );
                }
            }*/
            
            System.debug('++++' + jsongen);
         } catch (SecurityUtility.SFDCAccessControlException ex) {
            
            jsongen  = DiscountTranslator.objectToDiscountInfo(jsongen, null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            jsongen = DiscountTranslator.objectToDiscountDetailInfo(jsongen, null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            jsongen  = DiscountTranslator.objectToDiscountMappingInfo(jsongen, null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            responseJSON = jsongen.getAsString();
            if(!Test.isRunningTest()){
                RestContext.response.responseBody = Blob.valueOf(responseJSON);
            }
        }
    }
}