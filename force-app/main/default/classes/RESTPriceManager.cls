@RestResource(urlMapping='/v1/PriceMaster/Masters/*') 
global with sharing class RESTPriceManager {
    
    @HttpGet 
    global static RExAPIResponseDomain.MultipleResponseInfo getPriceMasters() {
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        
        RExAPIResponseDomain.ResponseInfo priceInfo = new RExAPIResponseDomain.ResponseInfo ();
        RExAPIResponseDomain.ResponseInfo NetpriceRetailerInfo = new RExAPIResponseDomain.ResponseInfo ();
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        
        try {
            
            // Id sellerId = ContactService.getLoginSellerId()
            Set<String> priceListIdSet = new Set<String>();
            map<string,string> AccountPriceIdmap=new  map<string,string>();
            List<Account> RetailerRelatedToResource = AccountService.getAllRetailerMaster_List_for_Resource();
            system.debug('RetailerRelatedToResource'+RetailerRelatedToResource);
            for(Account acc:RetailerRelatedToResource)
            {
                system.debug('acc.name'+acc.name);
                if(acc.Price_List__c!=null){
                    AccountPriceIdmap.put(acc.Price_List__c, string.valueof(acc.ivybase__Internal_Id__c));
                    priceListIdSet.add(acc.Price_List__c);
                }
            }
            System.debug('****priceListIdSet**'+priceListIdSet);
            String stdPriceListId = PriceService.getSTDPriceListId(); //Get Standard PriceList
            priceListIdSet.add(stdPriceListId);
            System.debug('****priceListIdSet**'+priceListIdSet);
            List<ivybase__Price_List_Entrie__c> priceList = PriceService.getAllPriceEntries(priceListIdSet);
            System.debug('****priceList**'+priceList);
            Set<Id> productIds = new Set<Id>();
            System.debug('priceListEntry::'+priceList);
            Set<Id> BomPriceListEntryId = new Set<Id>();
            Set<Id> BOMProductId = new Set<Id>();
            for (ivybase__Price_List_Entrie__c ple :priceList) {
                if(ple.ivybase__UOM_1_Price__c==null)
                {
                    BOMProductId.add(ple.ivybase__Product__c);
                    BomPriceListEntryId.add(ple.id);
                }
                productIds.add(ple.ivybase__Product__c);
            }
            system.debug(BomPriceListEntryId);
            List<ivybase__Product_UOM__c> puomList = new List<ivybase__Product_UOM__c>();
            Map<Id, Map<String, String>> productIdwithUOMTypewithNumberMap = new Map<Id, Map<String, String>>();
            //{productId => {'Piece' => 'UOM 1', 'Case' = > 'UOM 2', 'Outer' => 'UOM 3'}}
            if (productIds != null && productIds.size() > 0) {
                puomList = ProductUOMService.getProductUOMs(productIds);
                if (puomList != null && puomList.size() > 0) {
                    for (ivybase__product_UOM__c puom: puomList) {
                        if (!productIdwithUOMTypewithNumberMap.containskey(puom.ivybase__Product__c)) {
                            productIdwithUOMTypewithNumberMap.put(puom.ivybase__Product__c, new Map<String, String>());
                        } 
                        productIdwithUOMTypewithNumberMap.get(puom.ivybase__Product__c).put(puom.ivybase__UOM__c, puom.ivybase__UOM_Number__c);                        
                    }
                }
            }
            Map<Id,Map<Id,Decimal>> BOMChildQuantity = new Map<Id,Map<Id,Decimal>> ();
            PricingConditions.getQuantityIfItsBOMProduct(BOMProductId,BOMChildQuantity);
            system.debug('BOMChildQuantity'+BOMChildQuantity);
            Map<Id,Map<Id,Decimal>> BOMFinalPrice = new Map<Id,Map<Id,Decimal>>();
            List<ivybase__Price_List_Entrie__c> grandChildPriceListEntry = PriceService.getAllGrandChildPriceListEntries(BomPriceListEntryId);
            /*for(ivybase__Price_List_Entrie__c ple:grandChildPriceListEntry)
            {
                if(BOMFinalPrice.containsKey(ple.Parent__r.ivybase__Price_List__c))
                {
                    if(BOMFinalPrice.get(ple.Parent__r.ivybase__Price_List__c).containsKey(ple.Parent__r.ivybase__product__c))
                    {
                        if(BOMChildQuantity.containsKey(ple.Parent__r.ivybase__product__c))
                        {
                            if(BOMChildQuantity.get(ple.Parent__r.ivybase__product__c).containsKey(ple.ivybase__product__c))
                            {
                                Decimal qty = BOMChildQuantity.get(ple.Parent__r.ivybase__product__c).get(ple.ivybase__product__c);
                                if(qty!=null)
                                {
                                    Decimal price = qty*ple.ivybase__UOM_1_Price__c;
                                    if(price!=null){
                                        DEcimal exisitngprice=BOMFinalPrice.get(ple.Parent__r.ivybase__Price_List__c).get(ple.Parent__r.ivybase__product__c);
                                        BOMFinalPrice.get(ple.Parent__r.ivybase__Price_List__c).put(ple.Parent__r.ivybase__product__c,price+exisitngprice); 
                                    }
                                }
                            }
                        }
                        
                    }
                    else
                    {
                        if(BOMChildQuantity.containsKey(ple.Parent__r.ivybase__product__c))
                        {
                            if(BOMChildQuantity.get(ple.Parent__r.ivybase__product__c).containsKey(ple.ivybase__product__c))
                            {
                                Decimal qty = BOMChildQuantity.get(ple.Parent__r.ivybase__product__c).get(ple.ivybase__product__c);
                                if(qty!=null)
                                {
                                    Decimal price = qty*ple.ivybase__UOM_1_Price__c;
                                    if(price!=null){
                                        BOMFinalPrice.get(ple.Parent__r.ivybase__Price_List__c).put(ple.Parent__r.ivybase__product__c,price);
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }else
                {
                    if(BOMChildQuantity.containsKey(ple.Parent__r.ivybase__product__c))
                    {
                        if(BOMChildQuantity.get(ple.Parent__r.ivybase__product__c).containsKey(ple.ivybase__product__c))
                        {
                            Decimal qty = BOMChildQuantity.get(ple.Parent__r.ivybase__product__c).get(ple.ivybase__product__c);
                            if(qty!=null)
                            {
                                Decimal price = qty*ple.ivybase__UOM_1_Price__c;
                                if(price!=null){
                                    Map<Id,Decimal> bomPrice = new Map<Id,Decimal>();
                                    bomPrice.put(ple.Parent__r.ivybase__product__c,price);
                                    BOMFinalPrice.put(ple.Parent__r.ivybase__Price_List__c,bomPrice);
                                }
                            }
                        }
                    }
                }
                
            }*/
            priceList.addAll(grandChildPriceListEntry);
            system.debug('BOMFinalPrice'+BOMFinalPrice);
            priceInfo = PriceTranslator.objectToPriceMasterInfo(priceList, productIdwithUOMTypewithNumberMap, null);
            response.Tables.add(priceInfo); 
            system.debug('AccountPriceIdmap'+AccountPriceIdmap);
            NetpriceRetailerInfo= PriceTranslator.objectToPricenetMasterInfo(priceList, AccountPriceIdmap,BOMFinalPrice, null);
            response.Tables.add(NetpriceRetailerInfo); 
            
        } catch (SecurityUtility.SFDCAccessControlException ex) {
            
            system.debug('++++'+'Inside catch'+'++++'+ex);
            priceInfo = PriceTranslator.objectToPriceMasterInfo(null, null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(priceInfo);  
            NetpriceRetailerInfo= PriceTranslator.objectToPricenetMasterInfo(null, null,null,  CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(NetpriceRetailerInfo);
        }
        return response;
    }
}