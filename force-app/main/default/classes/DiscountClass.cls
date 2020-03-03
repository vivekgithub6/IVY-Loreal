public with sharing class DiscountClass {
    public static Integer BOMChildDiscountMapwithKey(Id account,Id BOMParent,Id ChildBOM,String CodeType,Decimal Discount,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap,Integer ChildGotValueParam,String VariableKey,Map<Id,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>> BOMChildDiscountMapwithKey)
    {
        system.debug('account'+account);
                system.debug('BOMParent'+BOMParent);
                        system.debug('ChildBOM'+ChildBOM);
                                system.debug('VariableKey'+VariableKey);
        							system.debug('CodeType'+CodeType);
        Integer ChildGotValue=ChildGotValueParam;
        system.debug('BOMChildDiscountMapwithKey'+BOMChildDiscountMapwithKey);
        if(BOMChildDiscountMapwithKey.containsKey(account))
        {
            if(BOMChildDiscountMapwithKey.get(account).containsKey(BOMParent))
            {
                if(BOMChildDiscountMapwithKey.get(account).get(BOMParent).containsKey(ChildBOM))
                {
                    if(BOMChildDiscountMapwithKey.get(account).get(BOMParent).get(ChildBOM).containsKey(CodeType))
                    {
                        BOMChildDiscountMapwithKey.get(account).get(BOMParent).get(ChildBOM).get(CodeType).put(VariableKey,Discount);
                    }
                    else
                    {
                        Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                        typeDecimal.put(VariableKey,Discount);
                        BOMChildDiscountMapwithKey.get(account).get(BOMParent).get(ChildBOM).put(CodeType,typeDecimal); 
                    }
                }
                else
                {
                    Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                    typeDecimal.put(VariableKey,Discount);
                    Map<String,Map<String,Decimal>> codeKeyDecimalMap = new Map<String,Map<String,Decimal>>();
                    codeKeyDecimalMap.put(CodeType,typeDecimal);
                    BOMChildDiscountMapwithKey.get(account).get(BOMParent).put(ChildBOM,codeKeyDecimalMap); 
                }
            }
            else
            {
                Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                typeDecimal.put(VariableKey,Discount);
                Map<String,Map<String,Decimal>> codeKeyDecimalMap = new Map<String,Map<String,Decimal>>();
                codeKeyDecimalMap.put(CodeType,typeDecimal);
                Map<Id,Map<String,Map<String,Decimal>>> ChilddiscountMap = new Map<Id,Map<String,Map<String,Decimal>>>();
                ChilddiscountMap.put(ChildBOM,codeKeyDecimalMap);
                Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> BOMChildDiscMap = new Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>();
                BOMChildDiscountMapwithKey.get(account).put(BOMParent,ChilddiscountMap);
            }
            
        }
        else
        {
            Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
            typeDecimal.put(VariableKey,Discount);
            Map<String,Map<String,Decimal>> codeKeyDecimalMap = new Map<String,Map<String,Decimal>>();
            codeKeyDecimalMap.put(CodeType,typeDecimal);
            Map<Id,Map<String,Map<String,Decimal>>> ChilddiscountMap = new Map<Id,Map<String,Map<String,Decimal>>>();
            ChilddiscountMap.put(ChildBOM,codeKeyDecimalMap);
            Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> BOMChildDiscMap = new Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>();
            BOMChildDiscMap.put(BOMParent,ChilddiscountMap);
            BOMChildDiscountMapwithKey.put(account,BOMChildDiscMap);
        }
        return ChildGotValue;
    }
    public static void getAllChildProductDiscount(Set<Id> BOM,Set<Id> child,Set<Id> AccountIdSet,Map<Id,Map<Id,Decimal>> BOMChildMap,Map<Id,Set<Id>> accountProductMap,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap,Map<Id,Id> ProductDivisionMap)
    {
        Map<Id,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>> BOMChildDiscountMapwithKey = new Map<Id,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>>();
        Set<Id> functionIdSet = new Set<Id>();
        Map<Id,Id> SkuVsFunctionMap=getSKUVsFunctionMap(child);
        for(Id Sku:SkuVsFunctionMap.keySet())
        {
            functionIdSet.add(SkuVsFunctionMap.get(sku)); 
        }
        Map<Id,List<Id>> FunctionRelatedSetOfHierarchy=getAllProductHierarchyRelatedToFunction(functionIdSet);
        List<ivydsd__Discount_Mapping__c> discountMappingList = DiscountService.getDiscountFromDiscountMapping(null,AccountIdSet);
        system.debug('discountMappingList'+discountMappingList);
        Set<Id> discountId = new Set<Id>();
        Map<Id,Set<Id>> DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet = new Map<Id,Set<Id>>();
        Map<Id,Id> DiscountMappingVsDiscountIdMap = new Map<Id,Id>();
        for(ivydsd__Discount_Mapping__c dm:discountMappingList)
        {
            DiscountMappingVsDiscountIdMap.put(dm.Id,dm.ivydsd__Discount__c);
            discountId.add(dm.ivydsd__Discount__c);
            Set<Id> acc_StoreHierarchy_Id = new Set<Id>(); 
            if(dm.ivydsd__Account__c!=null){
                acc_StoreHierarchy_Id.add(dm.ivydsd__Account__c);
            }
            if(dm.ivydsd__Store_Hierarchy__c!=null)
            {
                acc_StoreHierarchy_Id.add(dm.ivydsd__Store_Hierarchy__c);                
            }
            DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet.put(dm.id,acc_StoreHierarchy_Id);
        }
        Map<Id,Set<Id>> DiscountVsRelatedDiscountDetailMap = new Map<Id,Set<Id>>();
        Map<Id,ivydsd__Discount_Detail__c> DiscountDetailMap = new Map<Id,ivydsd__Discount_Detail__c>();
        List<ivydsd__Discount_Detail__c> discountDetail = DiscountService.getAllDiscountDetail_List_GrandChild(discountId,BOM);
        system.debug('discountDetail'+discountDetail);
        for(ivydsd__Discount_Detail__c dd:discountDetail)
        {
            DiscountDetailMap.put(dd.Id,dd);
            if(DiscountVsRelatedDiscountDetailMap.containsKey(dd.Parent__r.ivydsd__Discounts__c))
            {
                DiscountVsRelatedDiscountDetailMap.get(dd.Parent__r.ivydsd__Discounts__c).add(dd.id);
            }
            else
            {
                Set<Id> discountDetailIdSet = new Set<Id>();
                discountDetailIdSet.add(dd.Id);
                DiscountVsRelatedDiscountDetailMap.put(dd.Parent__r.ivydsd__Discounts__c,discountDetailIdSet);
            }
        }
        List<ivydsd__Discount_Detail__c> ChildInMaindiscountDetail = DiscountService.getAllDiscountDetail_List(discountId);
        system.debug('ChildInMaindiscountDetail'+ChildInMaindiscountDetail);
        Map<Id,Set<Id>> DiscountVsRelatedDiscountDetailMapChild = new Map<Id,Set<Id>>();
        for(ivydsd__Discount_Detail__c dd:ChildInMaindiscountDetail)
        {
            DiscountDetailMap.put(dd.Id,dd);
            if(DiscountVsRelatedDiscountDetailMapChild.containsKey(dd.ivydsd__Discounts__c))
            {
                DiscountVsRelatedDiscountDetailMapChild.get(dd.ivydsd__Discounts__c).add(dd.id);
            }
            else
            {
                Set<Id> discountDetailIdSet = new Set<Id>();
                discountDetailIdSet.add(dd.Id);
                DiscountVsRelatedDiscountDetailMapChild.put(dd.ivydsd__Discounts__c,discountDetailIdSet);
            }
        }
        system.debug('DiscountVsRelatedDiscountDetailMapChild'+DiscountVsRelatedDiscountDetailMapChild);
        
        Integer NoOfChild=0;
        for(Id BOMkey:BOMChildMap.keyset())
        {
            for(Id ChildKey:BOMChildMap.get(BOMkey).keyset())
            {
                NoOfChild++;
            }
        }
        system.debug('NoOfChild'+NoOfChild);
        Integer ChildGotValue = 0;
        for(Id account:accountProductMap.keySet())
        {
            
            Set<Id> relatedDiscountMapping = MapClass.getSetOfKey_From_Map_With_Matching_Value(DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet,account);
            system.debug('relatedDiscountMapping'+relatedDiscountMapping);
            Set<Id> relatedDiscountId = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountMappingVsDiscountIdMap,relatedDiscountMapping);
            system.debug('relatedDiscountId'+relatedDiscountId);
            system.debug('DiscountVsRelatedDiscountDetailMap'+DiscountVsRelatedDiscountDetailMap);
            Set<Id> relatedDiscountDetail = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountVsRelatedDiscountDetailMap,relatedDiscountId);
            if(relatedDiscountDetail!=null && relatedDiscountDetail.size()>0){
                for(Id dd:relatedDiscountDetail)
                {
                    ivydsd__Discount_Detail__c grandChildDiscountDetail = DiscountDetailMap.get(dd);
                    ChildGotValue=BOMChildDiscountMapwithKey(account,grandChildDiscountDetail.Parent__r.ivydsd__Product__c,grandChildDiscountDetail.ivydsd__Product__c,grandChildDiscountDetail.Parent__r.ivydsd__Discounts__r.Type__c,grandChildDiscountDetail.ivydsd__Value__c,BOMChildDiscountMap,ChildGotValue,grandChildDiscountDetail.RelatedCustomerCode__c,BOMChildDiscountMapwithKey);
                }
            }
            system.debug('ChildGotValue'+ChildGotValue);
            if(ChildGotValue<NoOfChild){
                Set<Id> relatedChildDiscountDetail = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountVsRelatedDiscountDetailMapChild,relatedDiscountId);
                if(relatedChildDiscountDetail!=null && relatedChildDiscountDetail.size()>0)
                {
                    for(Id dd:relatedChildDiscountDetail)
                    {
                        ivydsd__Discount_Detail__c ChildDiscountDetail = DiscountDetailMap.get(dd);
                        for(Id BOMParent:BOMChildMap.keyset())
                        {
                            if(BOMChildMap.get(BOMParent).containsKey(ChildDiscountDetail.ivydsd__Product__c)){
                                
                                ChildGotValue=BOMChildDiscountMapwithKey(account,BOMParent,ChildDiscountDetail.ivydsd__Product__c,ChildDiscountDetail.ivydsd__Discounts__r.Type__c,ChildDiscountDetail.ivydsd__Value__c,BOMChildDiscountMap,ChildGotValue,ChildDiscountDetail.RelatedCustomerCode__c,BOMChildDiscountMapwithKey);
                            }
                        }
                    }
                    
                }
            }
            system.debug('ChildGotValue'+ChildGotValue);
            system.debug('BOMChildMap'+BOMChildMap);
            if(ChildGotValue<NoOfChild)
            {
                for(Id BOMParent:BOMChildMap.keyset())
                {
                    for(Id BOMChild:BOMChildMap.get(BOMParent).keyset())
                    {
                        
                        List<Id> ProductHierarchyList = FunctionRelatedSetOfHierarchy.get(SkuVsFunctionMap.get(BOMChild));
                        Boolean GotAMatch=false;
                        Integer index=0;
                        while(GotAMatch!=True && ProductHierarchyList!=null && index<ProductHierarchyList.size())
                        {
                            Id ProductHierarchy = ProductHierarchyList[index];
                            Set<Id> relatedChildDiscountDetail = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountVsRelatedDiscountDetailMapChild,relatedDiscountId);
                            
                            if(relatedChildDiscountDetail!=null && relatedChildDiscountDetail.size()>0)
                            {
                                for(Id dd:relatedChildDiscountDetail)
                                {
                                    ivydsd__Discount_Detail__c ChildDiscountDetail = DiscountDetailMap.get(dd);
                                    if(ChildDiscountDetail.ivydsd__Product_Hierarchy__c==ProductHierarchy)
                                    {
                                        
                                        GotAMatch=true;
                                        ChildGotValue=BOMChildDiscountMapwithKey(account,BOMParent,BOMChild,ChildDiscountDetail.ivydsd__Discounts__r.Type__c,ChildDiscountDetail.ivydsd__Value__c,BOMChildDiscountMap,ChildGotValue,ChildDiscountDetail.RelatedCustomerCode__c,BOMChildDiscountMapwithKey);
                                    }
                                }
                            }
                            index=index+1;  
                        }
                        
                        
                    }//
                }
                
            }
            if(ChildGotValue<NoOfChild){
                Set<Id> relatedChildDiscountDetail = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountVsRelatedDiscountDetailMapChild,relatedDiscountId);
                if(relatedChildDiscountDetail!=null && relatedChildDiscountDetail.size()>0)
                {
                    for(Id dd:relatedChildDiscountDetail)
                    {
                        ivydsd__Discount_Detail__c ChildDiscountDetail = DiscountDetailMap.get(dd);
                        for(Id BOMParent:BOMChildMap.keyset())
                        {
                            for(Id BOMChild:BOMChildMap.get(BOMParent).keySet())
                            {
                                if(ProductDivisionMap.containsKey(BOMChild))
                                {
                                    Id childProductDivision = ProductDivisionMap.get(BOMChild);
                                    if(ChildDiscountDetail.Division__c!= null && ChildDiscountDetail.Division__c==childProductDivision)
                                    {
                                        ChildGotValue=BOMChildDiscountMapwithKey(account,BOMParent,ChildDiscountDetail.ivydsd__Product__c,ChildDiscountDetail.ivydsd__Discounts__r.Type__c,ChildDiscountDetail.ivydsd__Value__c,BOMChildDiscountMap,ChildGotValue,ChildDiscountDetail.RelatedCustomerCode__c,BOMChildDiscountMapwithKey);
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            
            
            
        }
        system.debug('BOMChildDiscountMap'+BOMChildDiscountMap);
        getDiscountCodeBasedOnVariableKeyPriorityForBOM(BOMChildDiscountMapwithKey,BOMChildDiscountMap);
    }
    public static void getDiscountCodeBasedOnVariableKeyPriorityForBOM (Map<Id,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>> BOMChildDiscountMapwithKey,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap)
    {
        List<Variable_key_Priority__mdt> CodePriority =[select Variable_Key__c,Priority__c,Pricing_Code__c from Variable_key_Priority__mdt];
        Map<String,Map<String,Decimal>> CustomerCodeAndPriorityMap = new Map<String,Map<String,Decimal>>();
        for(Variable_key_Priority__mdt pdc:CodePriority)
        {
            String pricingCode=pdc.Pricing_Code__c.trim();
            String VariableKey=pdc.Variable_Key__c.trim();
            //if its marked as Ignore
            
            if(pdc.Priority__c!=null)
            {
                if(CustomerCodeAndPriorityMap.containsKey(pricingCode))
                {
                    CustomerCodeAndPriorityMap.get(pricingCode).put(VariableKey,pdc.Priority__c);
                }
                else
                {
                    Map<String,Decimal> KeyPriority = new Map<String,Decimal>();
                    KeyPriority.put(VariableKey,pdc.Priority__c);
                    CustomerCodeAndPriorityMap.put(pricingCode,KeyPriority);
                }
                
            }
            
        } 
        for(Id account:BOMChildDiscountMapwithKey.keyset())
        {
            for(Id Product:BOMChildDiscountMapwithKey.get(account).keySet())
            {
                for(Id ChildProduct:BOMChildDiscountMapwithKey.get(account).get(Product).keyset())
                {
                    for(String discountCode : BOMChildDiscountMapwithKey.get(account).get(Product).get(ChildProduct).keyset())
                    {
                        Decimal highPriorityValue=null;
                        String highPriorityKey = '';
                        for(String VariableKey:BOMChildDiscountMapwithKey.get(account).get(Product).get(ChildProduct).get(discountCode).keyset())
                        {
                            if(highPriorityValue==null){
                                highPriorityValue=BOMChildDiscountMapwithKey.get(account).get(Product).get(ChildProduct).get(discountCode).get(VariableKey);
                                highPriorityKey=VariableKey;
                            }
                            else
                            {
                                if(CustomerCodeAndPriorityMap.containsKey(discountCode))
                                {
                                    if(CustomerCodeAndPriorityMap.get(discountCode).containsKey(VariableKey) &&  CustomerCodeAndPriorityMap.get(discountCode).containsKey(highPriorityKey))
                                    {
                                        Decimal exisitingPriority = CustomerCodeAndPriorityMap.get(discountCode).get(highPriorityKey);
                                        Decimal CurrentPriority = CustomerCodeAndPriorityMap.get(discountCode).get(VariableKey);
                                        system.debug('exisitingPriority'+exisitingPriority);
                                        system.debug('CurrentPriority'+CurrentPriority);
                                        if(CurrentPriority!=null && exisitingPriority!=null && CurrentPriority<=exisitingPriority)
                                        {
                                            highPriorityValue=BOMChildDiscountMapwithKey.get(account).get(Product).get(ChildProduct).get(discountCode).get(VariableKey);
                                            highPriorityKey=VariableKey;
                                        }
                                    }
                                    
                                }
                                
                            } 
                            
                        }
                        populateBOMChildDiscountMap(BOMChildDiscountMap,account,Product,ChildProduct,discountCode,highPriorityValue);
                    }
                }
                
            }
        }
    }
    public static void populateBOMChildDiscountMap(Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap,Id account,Id BOMParent,Id ChildBOM,String CodeType,Decimal Discount)
    {
        if(BOMChildDiscountMap.containsKey(account))
                    {
                        if(BOMChildDiscountMap.get(account).containsKey(BOMParent))
                        {
                            if(BOMChildDiscountMap.get(account).get(BOMParent).containsKey(ChildBOM)==false)
                            {
                                Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                                typeDecimal.put(CodeType,Discount);
                                BOMChildDiscountMap.get(account).get(BOMParent).put(ChildBOM,typeDecimal); 
                            }
                            else
                            {
                                BOMChildDiscountMap.get(account).get(BOMParent).get(ChildBOM).put(CodeType,Discount); 
                            }
                        }
                        else
                        {
                            Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                            typeDecimal.put(CodeType,Discount);
                            Map<Id,Map<String,Decimal>> ChilddiscountMap = new Map<Id,Map<String,Decimal>>();
                            ChilddiscountMap.put(ChildBOM,typeDecimal);
                            Map<Id,Map<Id,Map<String,Decimal>>> BOMChildDiscMap = new Map<Id,Map<Id,Map<String,Decimal>>>();
                            BOMChildDiscountMap.get(account).put(BOMParent,ChilddiscountMap);

                        }
                        
                    }
                    else
                    {
                        Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                        typeDecimal.put(CodeType,Discount);
                        Map<Id,Map<String,Decimal>> ChilddiscountMap = new Map<Id,Map<String,Decimal>>();
                        ChilddiscountMap.put(ChildBOM,typeDecimal);
                        Map<Id,Map<Id,Map<String,Decimal>>> BOMChildDiscMap = new Map<Id,Map<Id,Map<String,Decimal>>>();
                        BOMChildDiscMap.put(BOMParent,ChilddiscountMap);
                        BOMChildDiscountMap.put(account,BOMChildDiscMap);

                    }
        
    }
    public static Map<Id,Map<Id,Map<String,Decimal>>> getAccountProductTypeValueMap(Map<Id,Set<Id>> accountProductMap,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap)
    {
        system.debug('accountProductMap'+accountProductMap);
        //Map<AccountId<ProductId<DiscountCode,VariableKey,Value>>>>
        Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> AccountProductTypeValueMap = new Map<Id,Map<Id,Map<String,Map<String,Decimal>>>>();
        Set<Id> allAccountId = new Set<Id>();
        Set<Id> allProductSKuId = new Set<Id>();
        
        Set<Id> ProductId = new Set<Id>();
        Set<Id> AccountIdset = new Set<Id>();
        for(Id acc:accountProductMap.keyset())
        {
            ProductId.addAll(accountProductMap.get(acc));
            AccountIdset.add(acc);
        }
        Map<Id,Map<Id,Decimal>> BOMParentChildMap= new Map<Id,Map<Id,Decimal>>();
        PricingConditions.getQuantityIfItsBOMProduct(ProductId,BOMParentChildMap);
        
        Set<Id> parentBOM = new Set<Id>();
        Set<Id> child = new Set<Id>();
        for(Id parentBOMId:BOMParentChildMap.keyset())
        {
            parentBOM.add(parentBOMId);
            child.addAll(BOMParentChildMap.get(parentBOMId).keyset());
            ProductId.addAll(child);
        }
        
        Map<Id,Id> ProductDivisionMap = ProductService.getProductAndDivisionMap(ProductId);
        
        if(BOMParentChildMap.keyset().size()>0){
            getAllChildProductDiscount(parentBOM,child,AccountIdset,BOMParentChildMap,accountProductMap,BOMChildDiscountMap,ProductDivisionMap);
        }
        for(Id AccountId:accountProductMap.keySet())
        {
            allAccountId.add(AccountId);
            allProductSKuId.addAll(accountProductMap.get(AccountId));
        }
        Set<Id> functionIdSet = new Set<Id>();
        Map<Id,Id> SkuVsFunctionMap=getSKUVsFunctionMap(allProductSKuId);
        for(Id Sku:SkuVsFunctionMap.keySet())
        {
            functionIdSet.add(SkuVsFunctionMap.get(sku)); 
        }
        Map<Id,List<Id>> FunctionRelatedSetOfHierarchy=getAllProductHierarchyRelatedToFunction(functionIdSet);
        Map<Id,List<Id>> AccountRelatedSetOfHierarchy=getAccountAndRelatedStoreHierarchyMap(allAccountId);
        Set<Id> StoreHierarchySet = new Set<Id>();
        for(Id acc:AccountRelatedSetOfHierarchy.keySet())
        {
            StoreHierarchySet.addAll(AccountRelatedSetOfHierarchy.get(acc));
        }
        List<ivydsd__Discount_Mapping__c> discountMappingList = DiscountService.getDiscountFromDiscountMapping(StoreHierarchySet,allAccountId);
        
        Set<Id> discountId = new Set<Id>();
        Map<Id,Set<Id>> DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet = new Map<Id,Set<Id>>();
        Map<Id,Id> DiscountMappingVsDiscountIdMap = new Map<Id,Id>();
        for(ivydsd__Discount_Mapping__c dm:discountMappingList)
        {
            DiscountMappingVsDiscountIdMap.put(dm.Id,dm.ivydsd__Discount__c);
            discountId.add(dm.ivydsd__Discount__c);
            Set<Id> acc_StoreHierarchy_Id = new Set<Id>(); 
            if(dm.ivydsd__Account__c!=null){
                acc_StoreHierarchy_Id.add(dm.ivydsd__Account__c);
            }
            if(dm.ivydsd__Store_Hierarchy__c!=null)
            {
                acc_StoreHierarchy_Id.add(dm.ivydsd__Store_Hierarchy__c);                
            }
            DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet.put(dm.id,acc_StoreHierarchy_Id);
        }
        Map<Id,Set<Id>> DiscountVsRelatedDiscountDetailMap = new Map<Id,Set<Id>>();
        Map<Id,ivydsd__Discount_Detail__c> DiscountDetailMap = new Map<Id,ivydsd__Discount_Detail__c>();
        List<ivydsd__Discount_Detail__c> discountDetail = DiscountService.getAllDiscountDetail_List(discountId);
        
        for(ivydsd__Discount_Detail__c dd:discountDetail)
        {
            DiscountDetailMap.put(dd.Id,dd);
            if(DiscountVsRelatedDiscountDetailMap.containsKey(dd.ivydsd__Discounts__c))
            {
                DiscountVsRelatedDiscountDetailMap.get(dd.ivydsd__Discounts__c).add(dd.id);
            }
            else
            {
                Set<Id> discountDetailIdSet = new Set<Id>();
                discountDetailIdSet.add(dd.Id);
                DiscountVsRelatedDiscountDetailMap.put(dd.ivydsd__Discounts__c,discountDetailIdSet);
            }
        }
        
        for(Id account:accountProductMap.keySet())
        {
            Boolean GotAMatch=False;
            Set<Id> relatedDiscountMapping = MapClass.getSetOfKey_From_Map_With_Matching_Value(DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet,account);
            Set<Id> relatedDiscountId = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountMappingVsDiscountIdMap,relatedDiscountMapping);
            Set<Id> relatedDiscountDetail = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountVsRelatedDiscountDetailMap,relatedDiscountId);
            for(Id Product:accountProductMap.get(account))
            {
                GotAMatch=MatchInProductAndAccount(relatedDiscountDetail,DiscountDetailMap,Product,account,AccountProductTypeValueMap);  
                
                if(GotAMatch==False)
                {
                    
                    if(SkuVsFunctionMap.containsKey(Product))
                    {
                        
                        if(FunctionRelatedSetOfHierarchy.containsKey(SkuVsFunctionMap.get(Product)))
                        {
                            List<Id> ProductHierarchyList = FunctionRelatedSetOfHierarchy.get(SkuVsFunctionMap.get(Product));
                            
                            Integer index=0;
                            while(GotAMatch!=True && index<ProductHierarchyList.size())
                            {
                                Id ProductHierarchy = ProductHierarchyList[index];
                                GotAMatch=MatchInProductHierarchyAndAccount(relatedDiscountDetail,DiscountDetailMap,Product,ProductHierarchy,account,AccountProductTypeValueMap);  
                                index=index+1;  
                            }
                        }
                    }
                    
                }
                if(GotAMatch==False)
                {
                    
                    if(ProductDivisionMap.containsKey(Product))
                    {	
                        Id divisionId = ProductDivisionMap.get(Product);
                        GotAMatch=MatchInDivisionAndAccount(relatedDiscountDetail,DiscountDetailMap,Product, account,AccountProductTypeValueMap,divisionId);
                    }
                    
                }
                
            }
            if(GotAMatch==False)
            {
                if(AccountRelatedSetOfHierarchy.containsKey(account))
                {
                    List<Id> StoreHierarchyIdList =AccountRelatedSetOfHierarchy.get(account);
                    
                    for(Id StoreHierarchy:StoreHierarchyIdList)
                    {
                        relatedDiscountMapping = MapClass.getSetOfKey_From_Map_With_Matching_Value(DiscountMapping_Vs_RelatedAccount_And_StoreHierarchySet,StoreHierarchy);
                        relatedDiscountId = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountMappingVsDiscountIdMap,relatedDiscountMapping);
                        relatedDiscountDetail = MapClass.getSetOfValue_From_Map_With_Matching_Key(DiscountVsRelatedDiscountDetailMap,relatedDiscountId);
                        for(Id Product:accountProductMap.get(account))
                        {
                            GotAMatch=MatchInProductAndAccount(relatedDiscountDetail,DiscountDetailMap,Product,account,AccountProductTypeValueMap);  
                            if(GotAMatch==False)
                            {
                                if(SkuVsFunctionMap.containsKey(Product))
                                {
                                    if(FunctionRelatedSetOfHierarchy.containsKey(SkuVsFunctionMap.get(Product)))
                                    {
                                        List<Id> ProductHierarchyList = FunctionRelatedSetOfHierarchy.get(SkuVsFunctionMap.get(Product));
                                        Integer index=0;
                                        while(GotAMatch!=True && index<ProductHierarchyList.size())
                                        {
                                            Id ProductHierarchy = ProductHierarchyList[index];
                                            GotAMatch=MatchInProductHierarchyAndAccount(relatedDiscountDetail,DiscountDetailMap,Product,ProductHierarchy,account,AccountProductTypeValueMap);  
                                            index=index+1;  
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
            }
        }
        
        system.debug('AccountProductTypeKeyValueMap' +AccountProductTypeValueMap);
        return getDiscountCodeBasedOnVariableKeyPriority(AccountProductTypeValueMap);
    }
    public static Map<Id,Map<Id,Map<String,Decimal>>> getDiscountCodeBasedOnVariableKeyPriority (Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> AccountProductTypeVaraibleValueMap)
    {
        Map<Id,Map<Id,Map<String,Decimal>>> AccountProductTypeValueMap = new Map<Id,Map<Id,Map<String,Decimal>>>();
        List<Variable_key_Priority__mdt> CodePriority =[select Variable_Key__c,Priority__c,Pricing_Code__c from Variable_key_Priority__mdt];
        Map<String,Map<String,Decimal>> CustomerCodeAndPriorityMap = new Map<String,Map<String,Decimal>>();
        for(Variable_key_Priority__mdt pdc:CodePriority)
        {
            String pricingCode=pdc.Pricing_Code__c.trim();
            String VariableKey=pdc.Variable_Key__c.trim();
            //if its marked as Ignore
            
            if(pdc.Priority__c!=null)
            {
                if(CustomerCodeAndPriorityMap.containsKey(pricingCode))
                {
                    CustomerCodeAndPriorityMap.get(pricingCode).put(VariableKey,pdc.Priority__c);
                }
                else
                {
                    Map<String,Decimal> KeyPriority = new Map<String,Decimal>();
                    KeyPriority.put(VariableKey,pdc.Priority__c);
                    CustomerCodeAndPriorityMap.put(pricingCode,KeyPriority);
                }
                
            }
            
        } 
        for(Id account:AccountProductTypeVaraibleValueMap.keyset())
        {
            for(Id Product:AccountProductTypeVaraibleValueMap.get(account).keySet())
            {
                for(String discountCode : AccountProductTypeVaraibleValueMap.get(account).get(Product).keySet())
                {
                    Decimal highPriorityValue=null;
                    String highPriorityKey = '';
                    for(String VariableKey:AccountProductTypeVaraibleValueMap.get(account).get(Product).get(discountCode).keySet())
                    {
                        if(highPriorityValue==null){
                            highPriorityValue=AccountProductTypeVaraibleValueMap.get(account).get(Product).get(discountCode).get(VariableKey);
                            highPriorityKey=VariableKey;
                        }
                        else
                        {
                            if(CustomerCodeAndPriorityMap.containsKey(discountCode))
                            {
                                if(CustomerCodeAndPriorityMap.get(discountCode).containsKey(VariableKey) &&  CustomerCodeAndPriorityMap.get(discountCode).containsKey(highPriorityKey))
                                {
                                    Decimal exisitingPriority = CustomerCodeAndPriorityMap.get(discountCode).get(highPriorityKey);
                                    Decimal CurrentPriority = CustomerCodeAndPriorityMap.get(discountCode).get(VariableKey);
                                    system.debug('exisitingPriority'+exisitingPriority);
                                    system.debug('CurrentPriority'+CurrentPriority);
                                    if(CurrentPriority!=null && exisitingPriority!=null && CurrentPriority<=exisitingPriority)
                                    {
                                        highPriorityValue=AccountProductTypeVaraibleValueMap.get(account).get(Product).get(discountCode).get(VariableKey);
                                        highPriorityKey=VariableKey;
                                        
                                    }
                                }
                                
                            }
                            
                        } 
                        
                    }
                    populateAccountProductTypeValueMap(AccountProductTypeValueMap,account,Product,discountCode,highPriorityValue);
                }
            }
        }
        return  	AccountProductTypeValueMap;
    }
    public static void populateAccountProductTypeValueMap(Map<Id,Map<Id,Map<String,Decimal>>> AccountProductTypeValueMap, Id AccountId,Id ProductId,String DiscCode,Decimal Value)
    {
        system.debug('entered put valeus into map');
        if(AccountProductTypeValueMap.containsKey(AccountId))
        {
            if(AccountProductTypeValueMap.get(AccountId).containsKey(ProductId))
            {
                if(!AccountProductTypeValueMap.get(AccountId).get(ProductId).containsKey(DiscCode))
                {
                    AccountProductTypeValueMap.get(AccountId).get(ProductId).put(DiscCode,Value);
                }
            }
            else
            {
                Map<String,Decimal> TypeVsDecimalMap = new Map<String,Decimal>();
                TypeVsDecimalMap.put(DiscCode,Value);
                AccountProductTypeValueMap.get(AccountId).put(ProductId,TypeVsDecimalMap);
            }
            
        }
        else
        {
            Map<String,Decimal> TypeVsDecimalMap = new Map<String,Decimal>();
            TypeVsDecimalMap.put(DiscCode,Value);
            Map<Id,Map<String,Decimal>> ProductVsTypeDecimal = new Map<Id,Map<String,Decimal>>();
            ProductVsTypeDecimal.put(ProductId,TypeVsDecimalMap);
            AccountProductTypeValueMap.put(AccountId,ProductVsTypeDecimal);   
        }
        
    }
    public static boolean MatchInProductHierarchyAndAccount(Set<Id> relatedDiscountDetail,Map<Id,ivydsd__Discount_Detail__c> DiscountDetailMap,Id Product,Id ProductHierarchy,Id account,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> AccountProductTypeValueMap)
    {
        
        Boolean GotAMatch=False;
        if(relatedDiscountDetail !=null && relatedDiscountDetail.size()>0){
            for(Id discountDetailId:relatedDiscountDetail)
            {
                if(DiscountDetailMap.containsKey(discountDetailId))
                {
                    if(DiscountDetailMap.get(discountDetailId).ivydsd__Product_Hierarchy__c==ProductHierarchy)
                    {   GotAMatch=False;
                     if(DiscountDetailMap.get(discountDetailId).ivydsd__Discounts__r.Type__c!=null && DiscountDetailMap.get(discountDetailId).ivydsd__Value__c!=null)
                     {
                         putValuesIntoMainMap(AccountProductTypeValueMap,account,Product,DiscountDetailMap.get(discountDetailId).ivydsd__Discounts__r.Type__c,DiscountDetailMap.get(discountDetailId).ivydsd__Value__c,DiscountDetailMap.get(discountDetailId).RelatedCustomerCode__c);                                
                     }
                     
                    }
                    
                    
                }
            }
        }
        return GotAMatch;
    }
    public static boolean MatchInProductAndAccount(Set<Id> relatedDiscountDetail,Map<Id,ivydsd__Discount_Detail__c> DiscountDetailMap,Id Product,Id account,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> AccountProductTypeValueMap)
    {
        Boolean GotAMatch=False;
        if(relatedDiscountDetail !=null && relatedDiscountDetail.size()>0){
            for(Id discountDetailId:relatedDiscountDetail)
            {
                if(DiscountDetailMap.containsKey(discountDetailId))
                {
                    if(DiscountDetailMap.get(discountDetailId).ivydsd__Product__c==Product)
                    {   GotAMatch=False;
                     if(DiscountDetailMap.get(discountDetailId).ivydsd__Discounts__r.Type__c!=null && DiscountDetailMap.get(discountDetailId).ivydsd__Value__c!=null)
                     {
                         putValuesIntoMainMap(AccountProductTypeValueMap,account,Product,DiscountDetailMap.get(discountDetailId).ivydsd__Discounts__r.Type__c,DiscountDetailMap.get(discountDetailId).ivydsd__Value__c,DiscountDetailMap.get(discountDetailId).RelatedCustomerCode__c);                                
                     }
                    }
                }
            }}
        return GotAMatch;
    }
    public static boolean MatchInDivisionAndAccount(Set<Id> relatedDiscountDetail,Map<Id,ivydsd__Discount_Detail__c> DiscountDetailMap,Id Product,Id account,Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> AccountProductTypeValueMap,Id Division)
    {
        Boolean GotAMatch=False;
        if(relatedDiscountDetail !=null && relatedDiscountDetail.size()>0){
            for(Id discountDetailId:relatedDiscountDetail)
            {
                if(DiscountDetailMap.containsKey(discountDetailId))
                {
                    if(DiscountDetailMap.get(discountDetailId).Division__c==Division)
                    {   GotAMatch=False;
                     if(DiscountDetailMap.get(discountDetailId).ivydsd__Discounts__r.Type__c!=null && DiscountDetailMap.get(discountDetailId).ivydsd__Value__c!=null)
                     {
                         putValuesIntoMainMap(AccountProductTypeValueMap,account,Product,DiscountDetailMap.get(discountDetailId).ivydsd__Discounts__r.Type__c,DiscountDetailMap.get(discountDetailId).ivydsd__Value__c,DiscountDetailMap.get(discountDetailId).RelatedCustomerCode__c);                                
                     }
                    }
                }
            }}
        return GotAMatch;
    }
    public static void putValuesIntoMainMap(Map<Id,Map<Id,Map<String,Map<String,Decimal>>>> AccountProductTypeValueMap, Id AccountId,Id ProductId,String DiscCode,Decimal Value,String variableKey)
    {
        system.debug('entered put valeus into map'+variableKey);
        if(AccountProductTypeValueMap.containsKey(AccountId))
        {
            if(AccountProductTypeValueMap.get(AccountId).containsKey(ProductId))
            {
                if(AccountProductTypeValueMap.get(AccountId).get(ProductId).containsKey(DiscCode))
                {
                    AccountProductTypeValueMap.get(AccountId).get(ProductId).get(DiscCode).put(variableKey,Value);
                }
                else
                {
                    Map<String,Decimal> keyVsDecimalMap = new Map<String,Decimal>();
                    keyVsDecimalMap.put(variableKey,Value);
                    AccountProductTypeValueMap.get(AccountId).get(ProductId).put(DiscCode,keyVsDecimalMap);
                }
            }
            else
            {
                Map<String,Decimal> keyVsDecimalMap = new Map<String,Decimal>();
                keyVsDecimalMap.put(variableKey,Value);
                Map<String,Map<String,Decimal>> codeVsKeyDecimalMap = new Map<String,Map<String,Decimal>>();
                codeVsKeyDecimalMap.put(DiscCode,keyVsDecimalMap);
                AccountProductTypeValueMap.get(AccountId).put(ProductId,codeVsKeyDecimalMap);
            }
            
        }
        else
        {
            Map<String,Decimal> keyVsDecimalMap = new Map<String,Decimal>();
            keyVsDecimalMap.put(variableKey,Value);
            Map<String,Map<String,Decimal>> codeVsKeyDecimalMap = new Map<String,Map<String,Decimal>>();
            codeVsKeyDecimalMap.put(DiscCode,keyVsDecimalMap);
            Map<Id,Map<String,Map<String,Decimal>>> ProductVsTypeDecimal = new Map<Id,Map<String,Map<String,Decimal>>>();
            ProductVsTypeDecimal.put(ProductId,codeVsKeyDecimalMap);
            AccountProductTypeValueMap.put(AccountId,ProductVsTypeDecimal);   
        }
        
    }
    //returns <ProductId,FunctionId>
    public static Map<Id,Id> getSKUVsFunctionMap (Set<Id> ProductSKUSet){
        List<ivybase__Product__c> productSkuList = ProductHierarchyService.getfuntionbyproduct(ProductSKUSet);
        Map<Id,Id> SkuVsFunctionMap = new Map<Id,Id>();
        for(ivybase__Product__c p:productSkuList)
        {
            SkuVsFunctionMap.put(p.id,p.ivybase__Parent__c); 
        }
        return SkuVsFunctionMap;
    }
    //returns <functionId,List<ProductHierarchyId Upto Signature>>
    public Static Map<Id,List<Id>> getAllProductHierarchyRelatedToFunction(Set<Id> functionIdSet){
        List<ivybase__Product_Hierarchy__c> ProductHierarchyList = ProductHierarchyService.getAllProductHierarchy_List_For_The_Function(functionIdSet);
        Map<Id,ivybase__Product_Hierarchy__c> productHierarchyMap = new Map<Id,ivybase__Product_Hierarchy__c>();
        Map<Id,Id> productHierarchyParentMap = new Map<Id,Id>();
        for(ivybase__Product_Hierarchy__c h:ProductHierarchyList)
        {
            productHierarchyMap.put(h.id,h);
            productHierarchyParentMap.put(h.id,h.ivybase__Parent__c);    
        }
        Map<Id,List<Id>> FunctionRelatedSetOfHierarchy = new Map<Id,List<Id>>();
        for(Id funcitonId:functionIdSet)
        {
            if(FunctionRelatedSetOfHierarchy.containsKey(funcitonId))
            {
                
            }
            else
            {
                List<Id> AllRelatedParent = new List<Id>();
                AllRelatedParent.add(funcitonId);
                if(productHierarchyParentMap.containsKey(funcitonId))
                {
                    Id level = productHierarchyParentMap.get(funcitonId);
                    
                    while(level!=null)
                    {
                        AllRelatedParent.add(level);  
                        level = productHierarchyParentMap.get(level);  
                    }
                }
                FunctionRelatedSetOfHierarchy.put(funcitonId,AllRelatedParent);
            }
        }
        
        return FunctionRelatedSetOfHierarchy;  
    }
    public static Map<Id,Id> getAccountVsNode4HierarchyMap(Set<Id> allAccountId)
    {
        List<account> accountList=StoreHierarchyService.getNode4ForThisAccount(allAccountId);
        Map<Id,Id> accountVsNode4Map = new Map<Id,Id>();
        for(account a:accountList){
            accountVsNode4Map.put(a.Id,a.ivybase__Store_Hierarchy__c);
        }
        return accountVsNode4Map;
    }
    //return <AccountId,List<Sto>>  
    public static Map<Id,List<Id>> getAccountAndRelatedStoreHierarchyMap(Set<Id> allAccountId)
    {
        Map<Id,Id> accountVsNode4Map = getAccountVsNode4HierarchyMap(allAccountId);
        Set<Id> node4Store = new Set<Id>();
        for(Id a:accountVsNode4Map.keyset()){
            node4Store.add(accountVsNode4Map.get(a));
        }
        system.debug(accountVsNode4Map);
        Set<Id> allStoreHierarchy = StoreHierarchyService.getParentStorehierarchyIdFromNode4(node4Store);
        map<id,ivybase__Store_Hierarchy__c> storeMap = StoreHierarchyService.getstoreHierarchyRecords(allStoreHierarchy);
        Map<Id,Id> nodeVSParentMap = new Map<Id,Id>();
        for(Id sh:storeMap.keySet())
        {
            nodeVSParentMap.put(sh,storeMap.get(sh).ivybase__Parent__c);
        }
        system.debug('nodeVSParentMap'+nodeVSParentMap);
        Map<Id,List<Id>> AccountRelatedListOfHierarchy = new Map<Id,List<Id>>();
        for(Id account:allAccountId)
        {
            if(!AccountRelatedListOfHierarchy.containsKey(account))
            {
                List<Id> AllRelatedParent = new List<Id>();
                Id Node4Id = accountVsNode4Map.get(account);
                AllRelatedParent.add(Node4Id);
                if(nodeVSParentMap.containsKey(Node4Id))
                {
                    Id level = nodeVSParentMap.get(Node4Id);
                    
                    while(level!=null)
                    {
                        AllRelatedParent.add(level);  
                        level = nodeVSParentMap.get(level);  
                    }
                }
                AccountRelatedListOfHierarchy.put(account,AllRelatedParent);
            }
        }
        system.debug('AccountRelatedListOfHierarchy'+AccountRelatedListOfHierarchy);
        return AccountRelatedListOfHierarchy;
    }
}