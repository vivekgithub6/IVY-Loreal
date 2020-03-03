public with sharing class CreatePricingAndDiscount {
    
    public static void processStage3Records(List<Pricing_Stage_3__c> PricingRecords,List<Pricing_Stage_3__c> DiscountRecords,Account accountRecord)
    {
        List<Pricing_Stage_3__c> PriceListRecords = PricingRecords;
        Date AccountPriceListFromDate = null;
        Date AccountPriceListToDate = null;
        for(Pricing_Stage_3__c stage:PriceListRecords)
        {
            
                AccountPriceListFromDate=stage.Valid_From_Date__c;
                AccountPriceListToDate=stage.Valid_To_Date__c;
        }
        
        createDiscountRecords(DiscountRecords,accountRecord);
        createPriceListRecords(PriceListRecords,accountRecord,AccountPriceListFromDate,AccountPriceListToDate);
        
    }
    public static void createPriceListRecords(List<Pricing_Stage_3__c> PriceListRecords,Account accountRecord,Date AccountPriceListFromDate,Date AccountPriceListToDate)
    {
        //need to create price list for the account 
        //need to create Seperate price list for the BOM Product
        //Map<String,Id> priceListid Map = {Key format= AccountId+'-'+'BOMId+'-Price List',value=Pricelist Id} 
        //create priceListEntry	
        
        //create priceListFortheAccount
        Id AccountPriceListID=null;
        if(accountRecord.Price_List__c!=null)
        {
            AccountPriceListID=accountRecord.Price_List__c;
        }
        else//create priceListAndUpdateAccount
        {
            ivybase__Price_List__c priceList = createPriceList(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c,AccountPriceListFromDate,AccountPriceListToDate,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
            insert priceList;
            AccountPriceListID=priceList.Id;
            accountRecord.Price_List__c=priceList.Id;
            update accountRecord;   
        }
        
        Set<Id> ChildBOM = new Set<Id>();
        Set<Id> BOM = new Set<Id>();
        
        Map<String,ivybase__Price_List__c> MapForBOMPriceList = new Map<String,ivybase__Price_List__c>();
        //create price list for BOM Products 
        for(Pricing_Stage_3__c stage:PriceListRecords)
        {
            if(stage.Child_Product__c!=null)
            {
                BOM.add(stage.Product__c);
                ChildBOM.add(stage.Child_Product__c);
                if(MapForBOMPriceList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM')==false){
                    ivybase__Price_List__c priceList = createPriceList(accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM',AccountPriceListFromDate,AccountPriceListToDate,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                    MapForBOMPriceList.put(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM',priceList);
                }
            }
        }
        
        Map<Id,Map<Id,Decimal>> BOMAndChildQuantity = getQuantityIfItsBOMProduct(ChildBOM,BOM);
        
        if(MapForBOMPriceList.values().size()>0)
        {
            insert MapForBOMPriceList.values();
        }
        system.debug('MapForBOMPriceList'+MapForBOMPriceList);
        //insert priceList
        List<ivybase__Price_List_Entrie__c> PriceListEntryToInsert = new List<ivybase__Price_List_Entrie__c>();
        
        Map<String,ivybase__Price_List_Entrie__c> ParentBOMPriceListEntry = new Map<String,ivybase__Price_List_Entrie__c>();
        
        for(Pricing_Stage_3__c stage:PriceListRecords)
        {
            system.debug('child'+stage.Child_Product__c);
            if(stage.Child_Product__c!=null)
            {
                if(ParentBOMPriceListEntry.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM')==false){ 
                    ivybase__Price_List_Entrie__c PLEntry = createPriceListEntry(AccountPriceListID,stage.Product__c,null,stage.Pricing_Condition_Type__c,null,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                    ParentBOMPriceListEntry.put(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM',PLEntry);
                }
            }
            else
            {
                system.debug('Normal Products');
                ivybase__Price_List_Entrie__c PLEntry = createPriceListEntry(AccountPriceListID,stage.Product__c,stage.Price__c,stage.Pricing_Condition_Type__c,null,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                PriceListEntryToInsert.add(PLEntry);
            }
        }
        
        //insert parent and normal priceList entry
        if(ParentBOMPriceListEntry.values().size()>0)
        {
            insert ParentBOMPriceListEntry.values();
        }
        
        system.debug('BOMAndChildQuantity'+BOMAndChildQuantity);
        //create grandChild Price list entry 
        for(Pricing_Stage_3__c stage:PriceListRecords)
        {
            if(stage.Child_Product__c!=null)
            {
                if(ParentBOMPriceListEntry.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM') && MapForBOMPriceList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM') )
                {
                    Id SeperatePriceListId=MapForBOMPriceList.get(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM').Id;
                    Id ParentPriceListEntry=ParentBOMPriceListEntry.get(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Product__c+'-BOM').Id;

                    if(BOMAndChildQuantity.containsKey(stage.Product__c))
                    {
                        if(BOMAndChildQuantity.get(stage.Product__c).containsKey(stage.Child_Product__c))
                        {
                            ivybase__Price_List_Entrie__c PLEntry = createPriceListEntry(SeperatePriceListId,stage.Child_Product__c,stage.Price__c,stage.Pricing_Condition_Type__c,ParentPriceListEntry,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                            PriceListEntryToInsert.add(PLEntry);
                        }
                    }
                }
            }
        }
        //insert all price list entry
        if(PriceListEntryToInsert.size()>0)
        {
            insert PriceListEntryToInsert;
        }
        
    }
    public static void createDiscountRecords(List<Pricing_Stage_3__c> DiscountRecords,Account accountRecord)
    {
        //create main discountList for all the discount code
        Map<String,ivydsd__Discount__c> MapForDiscountList = new Map<String,ivydsd__Discount__c>();
        List<ivydsd__Discount_Mapping__c> discountMapping = new List<ivydsd__Discount_Mapping__c>();
        List<ivydsd__Discount__c> discountList = new List<ivydsd__Discount__c>();
        List<ivydsd__Discount_Detail__c> discountDetailList = new List<ivydsd__Discount_Detail__c>();
        //creating main discountList for each discount code 
        for(Pricing_Stage_3__c stage:DiscountRecords)
        {
            if(MapForDiscountList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c)==false)
            {
                ivydsd__Discount__c discount = createDiscountList(stage.Pricing_Condition_Type__c,stage.Valid_From_Date__c,stage.Valid_To_Date__c,accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                MapForDiscountList.put(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c,discount);
            }
        }
        if(MapForDiscountList.values().size()>0)
        {
            insert MapForDiscountList.values();
        }
        //create discount Mapping 
        for(String key:MapForDiscountList.keyset())
        {
            Id discountId =MapForDiscountList.get(key).id;
            ivydsd__Discount_Mapping__c mapping = createDiscountMapping(accountRecord.Id,discountId,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
            discountMapping.add(mapping);
        }
        if(discountMapping.size()>0)
        {
            insert discountMapping;
        }
        //create orphan discount list for bom prodcuts 
        Map<String,ivydsd__Discount__c> MapForBOMDiscountList = new Map<String,ivydsd__Discount__c>();
        for(Pricing_Stage_3__c stage:DiscountRecords)
        {
            if(stage.Child_Product__c!=null)
            {
                if(MapForBOMDiscountList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM')==false)
                {
                    ivydsd__Discount__c discount = createDiscountList(stage.Pricing_Condition_Type__c,stage.Valid_From_Date__c,stage.Valid_To_Date__c,accountRecord.Sold_To_Party_Number__c+''+stage.Product__c+'BOM',accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                    MapForBOMDiscountList.put(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM',discount);
                }
            }
        }
        if(MapForBOMDiscountList.values().size()>0)
        {
            insert MapForBOMDiscountList.values();
        }
       
        Map<String,ivydsd__Discount_Detail__c> MapForParentDiscountDetailEntry = new Map<String,ivydsd__Discount_Detail__c>();
        //create parent BOM Product discount detail and normal product or product hierarchy discount detail 
        for(Pricing_Stage_3__c stage:DiscountRecords)
        {
            //parent BOM Product discount detail
            if(stage.Child_Product__c!=null)
            {
                if(MapForParentDiscountDetailEntry.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM')==false)
                {
                    
                    Id discountId = null;
                    if(MapForDiscountList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c))
                    {
                        discountId=MapForDiscountList.get(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c).Id;
                    }
                    if(discountId!=null){
                        ivydsd__Discount_Detail__c details =createDiscountDetail(stage.Product__c,discountId, null,null,null,null,stage.RelatedCustomerCode__c,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                        MapForParentDiscountDetailEntry.put(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM',details);
                    }
                }
            }
            else
            {
                Id discountId = null;
                if(MapForDiscountList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c))
                {
                    discountId=MapForDiscountList.get(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c).Id;
                }
                system.debug('for tthis '+accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c);
                system.debug('DIscount Id for this '+discountId);
                if(discountId!=null){
                    //normal product discount detail
                    if(stage.Product__c!=null)
                    {
                        ivydsd__Discount_Detail__c detail =createDiscountDetail(stage.Product__c,discountId,null,(stage.Price__c!=null?(stage.Price__c):stage.Price__c),null,null,stage.RelatedCustomerCode__c,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                        discountDetailList.add(detail);
                    }
                    //product hierarchy discount detail
                    if(stage.Product_Hierarchy__c!=null)
                    {
                        ivydsd__Discount_Detail__c detail = createDiscountDetail(null,discountId,stage.Product_Hierarchy__c,(stage.Price__c!=null?(stage.Price__c):stage.Price__c),null,null,stage.RelatedCustomerCode__c,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                        system.debug('create discount under '+discountId);
                        discountDetailList.add(detail);
                    }
                    //Division discount detail
                    if(stage.Division__c!=null)
                    {
                        ivydsd__Discount_Detail__c detail = createDiscountDetail(null,discountId,null,(stage.Price__c!=null?(stage.Price__c):stage.Price__c),null,stage.Division__c,stage.RelatedCustomerCode__c,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                        system.debug('create discount under '+discountId);
                        discountDetailList.add(detail);
                    }
                }
            }
        }
	for(ivydsd__Discount_Detail__c d :discountDetailList)
    {
        system.debug('d'+d);
    }
        if(MapForParentDiscountDetailEntry.values().size()>0)
        {
            insert MapForParentDiscountDetailEntry.values();
        }
        //create grandchild discount detail
        for(Pricing_Stage_3__c stage:DiscountRecords)
        {
            if(stage.Child_Product__c!=null)
            {
                Id discountId = null;
                if(MapForBOMDiscountList.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM'))
                {
                    discountId=MapForBOMDiscountList.get(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM').id;
                    Id parent =null;
                    if(MapForParentDiscountDetailEntry.containsKey(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM'))
                    {
                        parent=MapForParentDiscountDetailEntry.get(accountRecord.Name+'-'+accountRecord.Sold_To_Party_Number__c+'-'+stage.Pricing_Condition_Type__c+'-'+stage.Product__c+'-BOM').Id;
                        if(parent!=null)
                        {
                            ivydsd__Discount_Detail__c detail =createDiscountDetail(stage.Child_Product__c,discountId,null,(stage.Price__c!=null?(stage.Price__c):stage.Price__c),parent,null,stage.RelatedCustomerCode__c,accountRecord.Market_ISO__c,accountRecord.CurrencyIsoCode);
                            discountDetailList.add(detail);
                        }
                    }
                }
            }
        }

        if(discountDetailList.size()>0)
        {
            insert discountDetailList;
        }
        
        
    }
    public static Decimal ceilOrFloorDecimalPlaceTO2Digit(Decimal input)
    {
        if(input!=null){
        Decimal result =  Math.round(input*100.0)/100.0;
        return result;
        }
        else
            {
                return null;
            }
    }
    public static ivybase__Price_List_Entrie__c createPriceListEntry(Id PriceListId,Id ProductId,Decimal Value,String PriceType,Id ParentId,String CountryCode,String currencyCode)
    {
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=PriceListId;
        priceListEntry.ivybase__Product__c=ProductId;
        priceListEntry.ivybase__UOM_1_Price__c=ceilOrFloorDecimalPlaceTO2Digit(Value);
        priceListEntry.Type__c=PriceType;
        priceListEntry.Parent__c=ParentId; 
        priceListEntry.Market_ISO__c=CountryCode;
        priceListEntry.CurrencyIsoCode=currencyCode;
        system.debug(priceListEntry);
        return priceListEntry;
    }
    public static ivybase__Price_List__c createPriceList(String AccountName,Date FromDate,Date ToDate,String CountryCode,String currencyCode)
    {
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+AccountName+'-Price List';
        priceList.ivybase__Valid_To__c=ToDate;
        priceList.ivybase__Valid_From__c=FromDate;
        priceList.ivybase__Active__c='Yes';
        priceList.Market_ISO__c=CountryCode;
        priceList.CurrencyIsoCode=currencyCode;
        return priceList;
    }
    public static ivydsd__Discount__c createDiscountList(String DiscountTypeCode,Date FromDate,Date ToDate,String AccountName,String CountryCode,String currencyCode)
    {
        ivydsd__Discount__c DiscountList = new ivydsd__Discount__c();
        DiscountList.Name=AccountName+' '+DiscountTypeCode+' Discount List';
        DiscountList.ivydsd__Effective_To__c=ToDate;
        DiscountList.ivydsd__Effective_From__c=FromDate;
        DiscountList.ivydsd__Apply_Type__c='Bill';
        DiscountList.ivydsd__Discount_Type__c='Bill';
        DiscountList.ivydsd__Module_Type__c='Invoice';
        DiscountList.Type__c=DiscountTypeCode;
        DiscountList.ivydsd__Value__c=0.00;
        DiscountList.Market_ISO__c=CountryCode;
        DiscountList.CurrencyIsoCode=currencyCode;
        
        return DiscountList;
    }
    public static ivydsd__Discount_Mapping__c createDiscountMapping(Id AccountId,Id DiscountListId,String CountryCode,String currencyCode)
    {
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Discount__c=DiscountListId;
        if(AccountId!=null){
            DiscountMapping.ivydsd__Account__c=AccountId;
        }
        DiscountMapping.Market_ISO__c=CountryCode;
        DiscountMapping.CurrencyIsoCode=currencyCode;
        return DiscountMapping;
    }
    public static ivydsd__Discount_Detail__c createDiscountDetail(Id ProductId,Id DiscountListId, Id ProductHierarchyId,Decimal DiscountPrice,Id Parent,Id Division,String variableKey,String CountryCode,String currencyCode)
    {
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c();
        DiscountDetail.ivydsd__Discounts__c=DiscountListId;
        DiscountDetail.ivydsd__Value__c=ceilOrFloorDecimalPlaceTO2Digit(DiscountPrice);
        DiscountDetail.Parent__c=Parent; 
        DiscountDetail.RelatedCustomerCode__c=variableKey;
        if(ProductId!=null){
            DiscountDetail.ivydsd__Product__c=ProductId;
        }
        if(ProductHierarchyId!=null)
        {
            DiscountDetail.ivydsd__Product_Hierarchy__c=ProductHierarchyId;
        }
        if(Division!=null)
        {
        DiscountDetail.Division__c=Division;	
        }
        DiscountDetail.Market_ISO__c=CountryCode;
        DiscountDetail.CurrencyIsoCode=currencyCode;
        return DiscountDetail;
    }
    
    public static Map<Id,Map<Id,Decimal>> getQuantityIfItsBOMProduct(Set<Id> ChildBOM, Set<Id> BOM)
    {
        List<ivybase__Bill_Of_Material_SKU_Detail__c> skudetail = [select id,name, ivybase__Bill_Of_Material_SKU__c,ivybase__Bill_Of_Material_SKU__r.External_Code__c,ivybase__Product__r.External_Code__c, ivybase__Product__c,ivybase__Quantity__c  from ivybase__Bill_Of_Material_SKU_Detail__c where ivybase__Bill_Of_Material_SKU__c=:BOM];
        system.debug('skudetail'+skudetail);
        
        Map<Id,Map<Id,Decimal>> BOMChildQuantity = new Map<Id,Map<Id,Decimal>>();
        for(ivybase__Bill_Of_Material_SKU_Detail__c det:skudetail)
        {
            if(BOMChildQuantity.containsKey(det.ivybase__Bill_Of_Material_SKU__c))
            {
                BOMChildQuantity.get(det.ivybase__Bill_Of_Material_SKU__c).put(det.ivybase__Product__c,det.ivybase__Quantity__c); 
            }
            else{
                Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
                prodMap.put(det.ivybase__Product__c,det.ivybase__Quantity__c);
                BOMChildQuantity.put(det.ivybase__Bill_Of_Material_SKU__c,prodMap);
            }
        }
        system.debug('BOMChildQuantity'+BOMChildQuantity);
        
        return  BOMChildQuantity;
    }
    
    
}