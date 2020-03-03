public with sharing class PricingAndDiscountCreation {
    public static void getStagingRecordAndProcess(Pricing_Master_Stage__c record)
    {
        //querying custom metadata to get all records related to pricing 
        List<PricingAndDiscountCode__mdt> PricingAndDiscountList =[select Code__c,Description__c,Ignore__c,Priority__c from PricingAndDiscountCode__mdt];
        Set<String> StringToIgnore = new Set<String>();
        Map<String,String> codeAndDescMap = new Map<String,String>();
        
        Map<String,Decimal> CustomerCodeAndPriorityMap = new Map<String,Decimal>();
        
        Boolean RecordStatus = True;
        List<String> CustomerOrCustomerHierarchyCodeList= new List<String>();
        String Error ='';
        try{
            for(PricingAndDiscountCode__mdt pdc:PricingAndDiscountList)
            {
                //if its marked as Ignore
                if(pdc.Ignore__c)
                {
                    StringToIgnore.add(pdc.Code__c);
                }
                else
                {
                    if(pdc.Priority__c!=null)
                    {
                        CustomerCodeAndPriorityMap.put(pdc.Code__c,pdc.Priority__c);
                    }
                    codeAndDescMap.put(pdc.Code__c,pdc.Description__c);	
                }
            } 
            String Key = record.Variable_Key__c;
            String KeyName = record.Variable_Key_Fields_Name__c; 
            record.Price__c=record.Price__c.setScale(2);
            //if the price is negative , convert to positive 
            if(record.Price__c<0){
                record.Price__c=record.Price__c*(-1);
            }
            system.debug('Key'+Key);
            system.debug('KeyName'+KeyName);
            system.debug('From Date'+record.Valid_From_Date__c);
            system.debug('To Date'+record.Valid_To_Date__c);
            //split both the strings
            List<String> KeyList = Key.split('/');
            List<String> KeyNameList = KeyName.split('/');
            
            //remove unwanted key from the list
            if(KeyList.size()==KeyNameList.size())
            {
                removeUnWantedKeyFromList(KeyList,KeyNameList,StringToIgnore);
            }
            //map<recordId,<Customer(Or)CustomerHierarchy,Key>
            //map<recordId,<Product(Or)ProductHierarchyHierarchy,Key>
            Map<Id,Map<String,String>> AccountAndProductCodeMap = new Map<Id,Map<String,String>>();
            
            //populate the map
            populateTheMap(KeyList,KeyNameList,AccountAndProductCodeMap,record,codeAndDescMap,CustomerOrCustomerHierarchyCodeList);
            
            String CustomerOrCustomerHierarchyCode='';
            for(String cs:CustomerOrCustomerHierarchyCodeList){
                CustomerOrCustomerHierarchyCode=cs;
            }
            
            system.debug('CustomerOrCustomerHierarchyCode'+CustomerOrCustomerHierarchyCode);
            system.debug('AccountAndProductCodeMap'+AccountAndProductCodeMap);
            
            Set<String> CustomerHierarchyCode = new Set<String>();
            Set<String> CustomerCode = new Set<String>();
            Set<String> ProductCode = new Set<String>();
            Set<String> ProductHierarchyCode = new Set<String>();
            Set<String> BOMCode = new Set<String>();
            Set<String> ChildBOMCode = new Set<String>();
            if(AccountAndProductCodeMap.containsKey(record.Id))
            {
                //getting all customer Hierarchy code to search in Store Hierarchy
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer Hierarchy'))
                {
                    CustomerHierarchyCode.add(AccountAndProductCodeMap.get(record.Id).get('Customer Hierarchy'));
                }
                //getting all customer code to search in Account
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer'))
                {
                    CustomerCode.add(AccountAndProductCodeMap.get(record.Id).get('Customer'));
                }
                //getting all Product code to search inProduct
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Product'))
                {
                    ProductCode.add(AccountAndProductCodeMap.get(record.Id).get('Product'));
                    ChildBOMCode.add(AccountAndProductCodeMap.get(record.Id).get('Product'));
                }
                //getting all Product Hierarchy  code to search in Product Hierarchy
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Product Hierarchy'))
                {
                    ProductHierarchyCode.add(AccountAndProductCodeMap.get(record.Id).get('Product Hierarchy'));
                }
                //getting all BOM code and store in ProductCode bcoz BOM also will be stored on product Master
                if(AccountAndProductCodeMap.get(record.Id).containsKey('BOM'))
                {
                    ProductCode.add(AccountAndProductCodeMap.get(record.Id).get('BOM'));
                    BOMCode.add(AccountAndProductCodeMap.get(record.Id).get('BOM'));
                }
            }
            
            Map<String,Map<String,Decimal>> BOMChildQuantity=getQuantityIfItsBOMProduct(ChildBOMCode,BOMCode);
            Decimal QuantityToCalculateForBOMChild=null;
            if(AccountAndProductCodeMap.get(record.Id).containsKey('BOM'))
            {
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Product'))
                {
                    if(BOMChildQuantity.containsKey(AccountAndProductCodeMap.get(record.Id).get('BOM')))
                    {
                        if(BOMChildQuantity.get(AccountAndProductCodeMap.get(record.Id).get('BOM')).containsKey(AccountAndProductCodeMap.get(record.Id).get('Product')))
                        {
                            QuantityToCalculateForBOMChild=BOMChildQuantity.get(AccountAndProductCodeMap.get(record.Id).get('BOM')).get(AccountAndProductCodeMap.get(record.Id).get('Product')); 
                        }
                    }
                }
            }
            system.debug('QuantityToCalculateForBOMChild'+QuantityToCalculateForBOMChild);
			
            system.debug('CustomerHierarchyCode'+CustomerHierarchyCode);
            system.debug('CustomerCode'+CustomerCode);
            system.debug('ProductCode'+ProductCode);
            system.debug('ProductHierarchyCode'+ProductHierarchyCode);
            
            Map<Id,Id> AccountRelatedStoreHierarchyId = new Map<Id,Id>();
            List<Account> relatedAccount= new List<Account>();
            Map<Id,Account> AccountIdAndRecordMap = new Map<Id,Account>();
            Map<Id,ivybase__Store_Hierarchy__c> StoreHieIdAndRecordMap = new Map<Id,ivybase__Store_Hierarchy__c>();
            Map<Id,ivybase__Product__c> ProductIdAndRecordMap = new map <Id,ivybase__Product__c>();
            List<ivybase__Store_Hierarchy__c> relatedStoreHierarchy= new List<ivybase__Store_Hierarchy__c>();
            List<ivybase__Product_Hierarchy__c> relatedProductHierarchy = new List<ivybase__Product_Hierarchy__c>();
            List<ivybase__Product__c> relatedProduct = new List<ivybase__Product__c>();
            //if price and store hierarchy is given get all realted account and process
            Map<String,Set<Id>> StoreCodeAndAccountSet = new Map<String,Set<Id>>();
            
            Map<String,Id> StoreHierarchyCodeAndStoreHierarchyMap = new Map<String,ID>();
            Map<String,Id> CustomerCodeAndAccoutMap = new Map<String,ID>();
            Map<String,Id> ProductCodeAndProductMap = new Map<String,ID>();
            Map<String,Id> ProductHierarchyCodeAndProductHierarchyMap = new Map<String,ID>();
            if(CustomerHierarchyCode.size()>0)
            {
                //if its store hierarchy get all account related to store hierarchy and process
                Set<Id> StoreRelatedId = StoreHierarchyService.getStoreHierarchyAndRelatedChildFromStoreCode(CustomerHierarchyCode);
                system.debug('StoreRelatedId'+StoreRelatedId);
                Set<Id> accountIdset = StoreDivisionMappingService.getAllAccountIdForStoreHierarchy(StoreRelatedId);
                List<Account> accountList = [select id,name,ivybase__Store_Hierarchy__c,Sold_To_Party_Number__c,Price_List__c From Account where id=:accountIdset];
                for(Account a:accountList)
                {
                    AccountIdAndRecordMap.put(a.Id,a);
                }
                system.debug('accountIdset'+accountIdset);
                if(accountIdset.size()>0){
                    StoreCodeAndAccountSet.put(AccountAndProductCodeMap.get(record.Id).get('Customer Hierarchy'),accountIdset);
                }
                AccountRelatedStoreHierarchyId=StoreDivisionMappingService.getOneMatchingStoreHierarchyForAccount(accountList);
                
            }
            system.debug('StoreCodeAndAccountSet'+StoreCodeAndAccountSet);
            system.debug('AccountRelatedStoreHierarchyId'+AccountRelatedStoreHierarchyId);
            //get all account records 
            if(CustomerCode.size()>0)
            {
                relatedAccount=AccountService.GetRelatedAccountFormCustomerCode(CustomerCode);
                AccountRelatedStoreHierarchyId=StoreDivisionMappingService.getOneMatchingStoreHierarchyForAccount(relatedAccount);
                for(Account a:relatedAccount)
                {
                    CustomerCodeAndAccoutMap.put(a.Sold_To_Party_Number__c,a.Id);
                    AccountIdAndRecordMap.put(a.Id,a);
                }
                
            }
            //get all product hierarchy records 
            if(ProductHierarchyCode.size()>0)
            {
                relatedProductHierarchy=ProductHierarchyService.getProductHierarchyFrom(ProductHierarchyCode);
                for(ivybase__Product_Hierarchy__c ph:relatedProductHierarchy)
                {
                    ProductHierarchyCodeAndProductHierarchyMap.put(ph.Code__c,ph.Id);
                }
            }
            system.debug('ProductHierarchyCodeAndProductHierarchyMap'+ProductHierarchyCodeAndProductHierarchyMap);
            //get all product master records 
            if(ProductCode.size()>0)
            {
                relatedProduct=ProductService.getProductFromProductCode(ProductCode);
                for(ivybase__Product__c p:relatedProduct)
                {
                    ProductIdAndRecordMap.put(p.Id,p);
                    ProductCodeAndProductMap.put(p.External_Code__c,p.id);
                }
            }
            system.debug('ProductIdAndRecordMap'+ProductIdAndRecordMap);
            system.debug('ProductCodeAndProductMap'+ProductCodeAndProductMap);
            system.debug('AccountRelatedStoreHierarchyId'+AccountRelatedStoreHierarchyId);
            system.debug('AccountIdAndRecordMap'+AccountIdAndRecordMap);
            //creating Records 
            system.debug('CustomerCodeAndAccoutMap'+CustomerCodeAndAccoutMap);
            if(AccountAndProductCodeMap.containsKey(record.Id))
            {
                if(codeAndDescMap.containsKey(record.Pricing_Condition_Type__c) && codeAndDescMap.get(record.Pricing_Condition_Type__c)=='Price'){
                    //if its base price 
                    if(record.Pricing_Condition_Type__c=='YPR0')
                    {
                        system.debug('Its Standard Price');
                        if(AccountAndProductCodeMap.get(record.Id).containsKey('Product') || AccountAndProductCodeMap.get(record.Id).containsKey('BOM')  )
                        {
                            system.debug('we got some product');
                            String standardPriceListId = PriceService.getSTDPriceListId();
                            if(ProductCodeAndProductMap.containsKey(AccountAndProductCodeMap.get(record.Id).get('Product')) || ProductCodeAndProductMap.containsKey(AccountAndProductCodeMap.get(record.Id).get('BOM')) ){
                                List<Id> ProductIdList = new List<Id>();
                                List<Id> PriceIdList = new List<Id>();
                                
                                Boolean isBomProdcut = AccountAndProductCodeMap.get(record.Id).ContainsKey('BOM');
                                if(isBomProdcut){
                                    ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('BOM')));
                                }
                                else
                                {
                                    ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('Product'))); 	
                                }
                                
                                if(standardPriceListId==null){
                                    ivybase__Price_List__c standardpriceList = createPriceList('Standard ',null,null);
                                    standardpriceList.ivybase__Is_Standard__c=true;
                                    insert standardpriceList;
                                    standardPriceListId=standardpriceList.Id;                                     
                                }
                                PriceIdList.add(Id.ValueOf(standardPriceListId));
                                Decimal PriceValue  = record.Price__c;
                                system.debug('PriceIdList in standard list '+PriceIdList);
                                RecordStatus=insertOrUpdatePriceListEntry(ProductIdList,PriceIdList,PriceValue,record.Pricing_Condition_Type__c,CustomerOrCustomerHierarchyCode,CustomerCodeAndPriorityMap,isBomProdcut,QuantityToCalculateForBOMChild);
                            }
                            else
                            {
                                Error+='Product Code related product not found In Product master. ';
                                RecordStatus=false;
                                
                            }					
                        }
                        else
                        {
                            system.debug('bad data =  bcoz for standard price list we need to populate Product level data in price list entry we dont have product Data here.');
                            //bad data =  bcoz for standard price list we need to populate Product level data in price list entry we dont have product Data here 
                            Error+='bad data =  bcoz for standard price list we need to populate Product level data in price list entry we dont have product Data here. ';
                            RecordStatus=false;
                        }
                    }
                    else
                    {
                        //structural price 
                        system.debug('Entered structural Price');
                        if(AccountAndProductCodeMap.get(record.Id).containsKey('Product'))
                        {
                            if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer'))
                            {
                                if(CustomerCodeAndAccoutMap.containsKey(AccountAndProductCodeMap.get(record.Id).get('Customer')))
                                {  
                                    Id accountId = CustomerCodeAndAccoutMap.get(AccountAndProductCodeMap.get(record.Id).get('Customer'));
                                    system.debug('got account id matching ');
                                    system.debug('AccountIdAndRecordMap'+AccountIdAndRecordMap);
                                    if(AccountIdAndRecordMap.containsKey(accountId))
                                    {
                                        if(AccountIdAndRecordMap.get(accountId).Price_List__c!=null)
                                        {
                                            Account acc =AccountIdAndRecordMap.get(accountId);
                                            List<Id> ProductIdList = new List<Id>();
                                            List<Id> PriceIdList = new List<Id>();
                                            Boolean isBomProdcut = AccountAndProductCodeMap.get(record.Id).ContainsKey('BOM');
                                            if(isBomProdcut){
                                                ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('BOM')));
                                            }
                                            else
                                            {
                                                ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('Product'))); 	
                                            }
                                            PriceIdList.add(acc.Price_List__c);
                                            Decimal PriceValue  = record.Price__c;
                                            RecordStatus=insertOrUpdatePriceListEntry(ProductIdList,PriceIdList,PriceValue,record.Pricing_Condition_Type__c,CustomerOrCustomerHierarchyCode,CustomerCodeAndPriorityMap,isBomProdcut,QuantityToCalculateForBOMChild);
                                            if(RecordStatus==false)
                                            {
                                                Error= 'Product Code related product not found In Product master'; 
                                            }
                                            system.debug('Price list there , entries inserted');
                                        }
                                        else
                                        {
                                            system.debug('No Price list for Account');
                                            Account acc =AccountIdAndRecordMap.get(accountId);
                                            ivybase__Price_List__c priceList = createPriceList(acc.Name+''+acc.Sold_To_Party_Number__c,record.Valid_From_Date__c,record.Valid_To_Date__c);
                                            insert priceList;
                                            acc.Price_List__c=priceList.Id;
                                            update acc;
                                            List<Id> ProductIdList = new List<Id>();
                                            List<Id> PriceIdList = new List<Id>();
                                            Boolean isBomProdcut = AccountAndProductCodeMap.get(record.Id).ContainsKey('BOM');
                                            if(isBomProdcut){
                                                ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('BOM')));
                                            }
                                            else
                                            {
                                                ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('Product'))); 	
                                            }
                                            PriceIdList.add(acc.Price_List__c);
                                            Decimal PriceValue  = record.Price__c;
                                            RecordStatus=insertOrUpdatePriceListEntry(ProductIdList,PriceIdList,PriceValue,record.Pricing_Condition_Type__c,CustomerOrCustomerHierarchyCode,CustomerCodeAndPriorityMap,isBomProdcut,QuantityToCalculateForBOMChild);
                                            if(RecordStatus==false)
                                            {
                                                Error= 'Product Code related product not found In Product master'; 
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    Error+='Customer Code Related Account not found.';
                                    RecordStatus=false;
                                }
                            }
                            else if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer Hierarchy'))
                            {
                                if(StoreCodeAndAccountSet.containsKey(AccountAndProductCodeMap.get(record.Id).get('Customer Hierarchy')))
                                {
                                    List<Account> accountToUpdate = new List<Account>();
                                    List<ivybase__Price_List_Entrie__c> priceListEntryTOInsert = new List<ivybase__Price_List_Entrie__c>();
                                    List<ivybase__Price_List__c> priceListToInsert = new List<ivybase__Price_List__c>(); 
                                    Map<String,Id> PriceListNameAndAccountMap = new Map<String,Id>(); 
                                    Map<Id,Id>  AccountPriceListMap = new Map<Id,Id>();
                                    Set<Id> AccountId = StoreCodeAndAccountSet.get(AccountAndProductCodeMap.get(record.Id).get('Customer Hierarchy'));
                                    system.debug('Account id for this Hierarchy size'+AccountId.size());
                                    for(Id accId:AccountId)
                                    {
                                        Account acc =AccountIdAndRecordMap.get(accId);
                                        if(acc.Price_List__c==null)
                                        {
                                            ivybase__Price_List__c PL=createPriceList(acc.Name+''+acc.Sold_To_Party_Number__c,record.Valid_From_Date__c,record.Valid_To_Date__c);
                                            PriceListNameAndAccountMap.put(acc.Name+''+acc.Sold_To_Party_Number__c+' Price List',accId);
                                            priceListToInsert.add(PL);
                                        }
                                        else
                                        {
                                            AccountPriceListMap.put(accId,acc.Price_List__c);
                                        }
                                    }
                                    system.debug('priceListToInsert size'+priceListToInsert.size());
                                    if(priceListToInsert.size()>0)
                                    {
                                        insert priceListToInsert;
                                    }
                                    for(ivybase__Price_List__c PL:priceListToInsert)
                                    {
                                        if(PriceListNameAndAccountMap.containsKey(PL.Name))
                                        {
                                            AccountPriceListMap.put(PriceListNameAndAccountMap.get(PL.Name),PL.Id);
                                        }
                                    }
                                    system.debug('AccountPriceListMap'+AccountPriceListMap);
                                    List<Id> ProductIdList = new List<Id>();
                                    List<Id> PriceIdList = new List<Id>();
                                    Decimal PriceValue  = record.Price__c;
                                    Boolean isBomProdcut=false;
                                    for(Id accId:AccountId)
                                    {
                                        Account acc =AccountIdAndRecordMap.get(accId);
                                        acc.Price_List__c=AccountPriceListMap.get(accId);
                                        accountToUpdate.add(acc);
                                        isBomProdcut = AccountAndProductCodeMap.get(record.Id).ContainsKey('BOM');
                                        if(isBomProdcut){
                                            ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('BOM')));
                                        }
                                        else
                                        {
                                            ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('Product'))); 	
                                        }
                                        PriceIdList.add(AccountPriceListMap.get(accId));
                                        
                                    }
                                    if(accountToUpdate.size()>0)
                                    {
                                        update accountToUpdate;
                                    }
                                    system.debug('Price list Id List '+ProductIdList);
                                    RecordStatus=insertOrUpdatePriceListEntry(ProductIdList,PriceIdList,PriceValue,record.Pricing_Condition_Type__c,CustomerOrCustomerHierarchyCode,CustomerCodeAndPriorityMap,isBomProdcut,QuantityToCalculateForBOMChild);
                                    if(RecordStatus==false)
                                    {
                                        Error= 'Product Code related product not found In Product master'; 
                                    }
                                }else{
                                    system.debug('no related account found');
                                    Error+='no related account found. ';
                                    RecordStatus=false;
                                }
                                
                            }
                            else
                            {
                                Error+='No Customer or Customer Hierarchy found. ';
                                RecordStatus=false;
                                
                            }
                        }
                        else
                        {
                            //bad data =  bcoz for  price list we need to populate Product level data in price list entry we dont have product Data here 
                            system.debug('Product Data not present for Structutal price');
                            Error='Product Data not present for Structutal price ';
                            RecordStatus=false;
                        }
                        
                    }
                }
                if(codeAndDescMap.containsKey(record.Pricing_Condition_Type__c) && codeAndDescMap.get(record.Pricing_Condition_Type__c)=='Discount'){
                    //create discount Data
                    String DiscountTypeCode = record.Pricing_Condition_Type__c;
                    Map<String,Set<Id>> DiscountTypeCodeAndIdMap = new map<String,Set<Id>>();
                    //first check if the Discount mapping is there for customer or customer hierarchy and related valid discount list for the type.
                    system.debug('Entering discount');
                    //create discount mapping 
                    //we got account 
                    if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer'))
                    {
                        if(CustomerCodeAndAccoutMap.containsKey(AccountAndProductCodeMap.get(record.Id).get('Customer'))){
                            set<Id> accountIdSet = new Set<Id>();
                            Id AccountId = CustomerCodeAndAccoutMap.get(AccountAndProductCodeMap.get(record.Id).get('Customer'));
                            accountIdSet.add(AccountId);
                            Map<String,ivydsd__Discount_Mapping__c>  discountDetailCombinationMap = DiscountService.CheckIfDiscoutMappingExistWithValidDiscountList(DiscountTypeCode,accountIdSet);
                            
                            if(discountDetailCombinationMap.containsKey(AccountId))
                            {
                                system.debug('Combination exists');
                                ivydsd__Discount_Mapping__c Discountdetail =  discountDetailCombinationMap.get(AccountId);
                                Set<Id> discIdSet = new Set<Id>();
                                discIdSet.add(Discountdetail.ivydsd__Discount__c);
                                DiscountTypeCodeAndIdMap.put(DiscountTypeCode,discIdSet);
                            }
                            else
                            {
                                //no mapping found create it 
                                system.debug(' No Combination exists');
                                Account acc =AccountIdAndRecordMap.get(AccountId);
                                ivydsd__Discount__c discountList = createDiscountList(DiscountTypeCode,record.Valid_From_Date__c,record.Valid_To_Date__c,acc.Name);
                                insert 	discountList;
                                system.debug('Discount List inserted');
                                Set<Id> discIdSet = new Set<Id>();
                                discIdSet.add(discountList.Id);
                                DiscountTypeCodeAndIdMap.put(DiscountTypeCode,discIdSet);
                                ivydsd__Discount_Mapping__c mapping = createDiscountMapping(AccountId,discountList.Id);
                                insert mapping;
                                system.debug('Discount Mapping inserted');
                            }
                        }
                        else
                        {
                            Error+='Customer Code matching Account not found. ';
                            RecordStatus=false;
                            
                        }
                    }
                    //we got store Hierarchy
                    else if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer Hierarchy'))
                    {
                        //store hierarchy new code 
                        if(StoreCodeAndAccountSet.containsKey(AccountAndProductCodeMap.get(record.Id).get('Customer Hierarchy')))
                        {
                            Map<String,Id> discountListAccountId = new Map<String,Id>();
                            List<ivydsd__Discount__c> discountListToInsert = new List<ivydsd__Discount__c>();
                            List<ivydsd__Discount_Mapping__c> discountMappingToInsert = new List<ivydsd__Discount_Mapping__c>();
                            Set<Id> AccountIdSet = StoreCodeAndAccountSet.get(AccountAndProductCodeMap.get(record.Id).get('Customer Hierarchy'));
                            Map<String,ivydsd__Discount_Mapping__c>  discountMappingCombinationMap = DiscountService.CheckIfDiscoutMappingExistWithValidDiscountList(DiscountTypeCode,AccountIdSet);
                            Set<Id> discId = new Set<Id>();
                            
                            for(Id AccountId:AccountIdSet)
                            {
                                if(discountMappingCombinationMap.containsKey(AccountId))
                                {
                                    system.debug('Combination exists');
                                    ivydsd__Discount_Mapping__c DiscountMapping =  discountMappingCombinationMap.get(AccountId);
                                    
                                    discId.add(DiscountMapping.ivydsd__Discount__c);
                                    
                                }
                                else
                                {
                                    //no mapping found create it 
                                    system.debug(' No Combination exists');
                                    Account acc =AccountIdAndRecordMap.get(AccountId);
                                    ivydsd__Discount__c discountList = createDiscountList(DiscountTypeCode,record.Valid_From_Date__c,record.Valid_To_Date__c,acc.Name+''+acc.Sold_To_Party_Number__c);
                                    discountListAccountId.put(acc.Name+''+acc.Sold_To_Party_Number__c+' '+DiscountTypeCode+' Discount List',AccountId);
                                    discountListToInsert.add(discountList);
                                    system.debug('Discount List inserted');
                                }
                            }
                            if(discId.size()>0){
                                DiscountTypeCodeAndIdMap.put(DiscountTypeCode,discId);
                            }
                            if(discountListToInsert.size()>0)
                            {
                                insert  discountListToInsert;
                            }
                            
                            Set<Id> discIdSet = new Set<Id>();
                            for(ivydsd__Discount__c d:discountListToInsert)
                            {
                                discIdSet.add(d.Id);
                                if(discountListAccountId.containsKey(d.Name)){ 
                                    ivydsd__Discount_Mapping__c mapping = createDiscountMapping(discountListAccountId.get(d.Name),d.Id);
                                    discountMappingToInsert.add(mapping);
                                    system.debug('Discount Mapping inserted');
                                }
                            }
                            if(discountMappingToInsert.size()>0)
                            {
                                insert  discountMappingToInsert; 
                            }
                            
                            
                            if(DiscountTypeCodeAndIdMap.containsKey(DiscountTypeCode))
                            {
                                DiscountTypeCodeAndIdMap.get(DiscountTypeCode).addAll(discIdSet);
                            }
                            else
                            {
                                DiscountTypeCodeAndIdMap.put(DiscountTypeCode,discIdSet);	
                            }
                            
                            
                            
                            
                        }else{
                            system.debug('no related account found');
                            Error+='no related account found. ';
                            RecordStatus=false;
                        }
                        
                    }
                    else
                    {
                        Error+='No Customer or Customer Hierarchy found for this discount cant create discount list , discount mapping , bad data. ';
                        RecordStatus=false;
                    }
                    system.debug('DiscountTypeCodeAndIdMap'+DiscountTypeCodeAndIdMap);
                    //Discount Detail 
                    if(AccountAndProductCodeMap.get(record.Id).containsKey('Product'))
                    {
                        Id ProductId ;
                        Boolean isBomProdcut = AccountAndProductCodeMap.get(record.Id).ContainsKey('BOM');
                        if(isBomProdcut){
                            ProductId=ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('BOM'));
                        }
                        else
                        {
                            ProductId=ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('Product')); 	
                        }
                        if(ProductId!=null){
                            if(DiscountTypeCodeAndIdMap.containsKey(record.Pricing_Condition_Type__c))
                            {
                                List<ivydsd__Discount_Detail__c> detailToUpdate  = new List<ivydsd__Discount_Detail__c>();
                                List<ivydsd__Discount_Detail__c> detailToInsert  = new List<ivydsd__Discount_Detail__c>();
                                Set<Id> disc = new Set<Id>();
                                disc = DiscountTypeCodeAndIdMap.get(record.Pricing_Condition_Type__c);
                                Map<String,ivydsd__Discount_Detail__c>  discountDetailCombinationMap = DiscountService.CheckIfDiscountDetailCombinationExist(ProductId,disc,null);
                                for(Id DiscountId:disc)
                                {
                                    if(discountDetailCombinationMap.containsKey(ProductId+''+DiscountId))
                                    {
                                        ivydsd__Discount_Detail__c  discountDetail=discountDetailCombinationMap.get(ProductId+''+DiscountId);
                                        if(discountDetail.RelatedCustomerCode__c!=null && (String.IsEmpty(CustomerOrCustomerHierarchyCode)==false) && CustomerCodeAndPriorityMap.containsKey(CustomerOrCustomerHierarchyCode) && CustomerCodeAndPriorityMap.containsKey(discountDetail.RelatedCustomerCode__c) )
                                        {
                                            Decimal exisitingPriority = CustomerCodeAndPriorityMap.get(discountDetail.RelatedCustomerCode__c);
                                            Decimal CurrentPriority = CustomerCodeAndPriorityMap.get(CustomerOrCustomerHierarchyCode);
                                            system.debug('exisitingPriority'+exisitingPriority);
                                            system.debug('CurrentPriority'+CurrentPriority);
                                            if(CurrentPriority<=exisitingPriority)
                                            {
                                                
                                                if(isBomProdcut){
                                                    discountDetail.ivydsd__Value__c+=(record.Price__c*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild));
                                                }
                                                else
                                                {
                                                    discountDetail.ivydsd__Value__c=record.Price__c;
                                                }                              
                                                detailToUpdate.add(discountDetail);
                                                system.debug('Discount detail  updated '+discountDetail);
                                                
                                            }
                                        }
                                        
                                    }
                                    else
                                    {
                                        ivydsd__Discount_Detail__c	discountDetail = createDiscountDetail(ProductId,DiscountId,null,(record.Price__c*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild)),CustomerOrCustomerHierarchyCode);
                                        detailToInsert.add(discountDetail);
                                        system.debug('Discount detail  Inserted '+discountDetail);
                                    }
                                }
                                if(detailToUpdate.size()>0)
                                {
                                    update detailToUpdate;
                                }
                                if(detailToInsert.size()>0)
                                {
                                    insert detailToInsert;
                                }
                                
                            }
                            else
                            {
                                Error+='No Related discount List found to insert this Product. ';
                                RecordStatus=false;
                            }
                        }
                        else
                        {
                            Error+='No Product Code related Product found .';
                            RecordStatus=false;
                            
                        }
                        
                    }
                    else if(AccountAndProductCodeMap.get(record.Id).containsKey('Product Hierarchy'))
                    {
                        Id ProductHierarchyId = ProductHierarchyCodeAndProductHierarchyMap.get(AccountAndProductCodeMap.get(record.Id).get('Product Hierarchy'));
                        if(ProductHierarchyId!=null){
                            system.debug('ProductHierarchyId'+ProductHierarchyId);
                            if(DiscountTypeCodeAndIdMap.containsKey(record.Pricing_Condition_Type__c))
                            {
                                List<ivydsd__Discount_Detail__c> detailToUpdate  = new List<ivydsd__Discount_Detail__c>();
                                List<ivydsd__Discount_Detail__c> detailToInsert  = new List<ivydsd__Discount_Detail__c>();
                                Set<Id> disc = new Set<Id>();
                                disc = DiscountTypeCodeAndIdMap.get(record.Pricing_Condition_Type__c);
                                Map<String,ivydsd__Discount_Detail__c>  discountDetailCombinationMap = DiscountService.CheckIfDiscountDetailCombinationExist(null,disc,ProductHierarchyId);
                                for(Id DiscountId:disc)
                                {
                                    if(discountDetailCombinationMap.containsKey(ProductHierarchyId+''+DiscountId))
                                    {
                                        if(AccountAndProductCodeMap.get(record.Id).containsKey('Customer Hierarchy')==false){
                                            ivydsd__Discount_Detail__c  discountDetail=discountDetailCombinationMap.get(ProductHierarchyId+''+DiscountId);
                                            
                                            discountDetail.ivydsd__Value__c=(record.Price__c*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild));
                                            
                                            detailToUpdate.add(discountDetail);
                                            system.debug('Discount detail  updated '+discountDetail);
                                        }
                                    }
                                    else
                                    {
                                        ivydsd__Discount_Detail__c	discountDetail = createDiscountDetail(null,DiscountId,ProductHierarchyId,(record.Price__c*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild)),CustomerOrCustomerHierarchyCode);
                                        detailToInsert.add(discountDetail);
                                        system.debug('Discount detail  Inserted '+discountDetail);
                                    }
                                }
                                if(detailToUpdate.size()>0)
                                {
                                    update detailToUpdate;
                                }
                                if(detailToInsert.size()>0)
                                {
                                    insert detailToInsert;
                                }
                                
                            }else
                            {
                                Error+='No Related discount List found to insert this Product Hierarchy. ';
                                RecordStatus=false;
                            }
                        }
                        else
                        {
                            Error+='No Product Hierarchy found for this Product Hierarchy code. ';
                            RecordStatus=false;
                            
                        }
                    }
                    else
                    {
                        Error+='No Product or Product Hierarachy data found , bad data cant create discount detail. ';
                        RecordStatus=false;
                    }            
                }//if its discount 
            }
            
            
        }catch(Exception e){
            
            Error=Error+'Cause:'+e.getCause();
            Error=Error+'Message:'+e.getMessage();
            Error=Error+'Trace:'+e.getStackTraceString();
            RecordStatus=false;
            record.Status__c='Pending';
            record.ErrorMessage__c=Error;
            system.debug('Error'+Error);
            update record;
        }
        
        if(RecordStatus==false)
        {
            record.Status__c='Pending';
            record.ErrorMessage__c=Error;
        }
        else
        {
            record.Status__c='Completed';
            record.ErrorMessage__c='';
        }
        update record;        
        
    }
    public static void populateTheMap(List<String> KeyList,List<String> KeyNameList,Map<Id,Map<String,String>> AccountAndProductCodeMap,Pricing_Master_Stage__c record,Map<String,String> codeAndDescMap,List<String> CustomerOrCustomerHierarchyCode )
    {
        if(!AccountAndProductCodeMap.containsKey(record.Id))
        {
            String ProductCode='';
            String ProductHierarchyCode='';
            String Product ='';
            String ProductHierarchy ='';
            
            String BomCode='';
            String Bom='';
            
            for(Integer i=0;i<KeyList.size();i++)
            {
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='Customer' )
                {
                    Map<String,String> CustomerCodeMap = new Map<String,String>();
                    CustomerCodeMap.put(codeAndDescMap.get(KeyNameList[i]),KeyList[i]);
                    CustomerOrCustomerHierarchyCode.add(KeyNameList[i]);
                    AccountAndProductCodeMap.put(record.Id,CustomerCodeMap);
                }
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='Customer Hierarchy' )
                {
                    Map<String,String> CustomerHierarchyCodeMap = new Map<String,String>();
                    CustomerHierarchyCodeMap.put(codeAndDescMap.get(KeyNameList[i]),KeyList[i]);
                    CustomerOrCustomerHierarchyCode.add(KeyNameList[i]);
                    AccountAndProductCodeMap.put(record.Id,CustomerHierarchyCodeMap);
                }
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='Product Hierarchy' )
                {
                    ProductHierarchy=codeAndDescMap.get(KeyNameList[i]);
                    ProductHierarchyCode=ProductHierarchyCode+KeyList[i];
                }
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='Product' )
                {
                    Product=codeAndDescMap.get(KeyNameList[i]);
                    ProductCode=ProductCode+stripAwayFrontZero(KeyList[i]);
                }
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='BOM' )
                {
                    Bom=codeAndDescMap.get(KeyNameList[i]);
                    BomCode=BomCode+stripAwayFrontZero(KeyList[i]);
                }
            }
            system.debug(ProductCode+'-*-'+ProductCode);
            system.debug(ProductHierarchy+'-*-'+ProductHierarchyCode);
            system.debug(Bom+'-*-'+BomCode);
            if(AccountAndProductCodeMap.containsKey(record.Id)){
                AccountAndProductCodeMap.get(record.Id).put(Product,ProductCode);
                AccountAndProductCodeMap.get(record.Id).put(ProductHierarchy,ProductHierarchyCode);
                AccountAndProductCodeMap.get(record.Id).put(Bom,BomCode);
            }
            else
            {
                Map<String,String> ProductAndHierarchyMap = new Map<String,String>();
                ProductAndHierarchyMap.put(Product,ProductCode);
                ProductAndHierarchyMap.put(ProductHierarchy,ProductHierarchyCode);
                ProductAndHierarchyMap.put(Bom,BomCode);
                AccountAndProductCodeMap.put(record.Id,ProductAndHierarchyMap);
            }
        }
        
    }
    public static void removeUnWantedKeyFromList(List<String> KeyList,List<String> KeyNameList,Set<String> StringToIgnore)
    {
        
        for(Integer i=KeyList.size()-1;i>=0;i--)
        {
            if(StringToIgnore.contains(KeyNameList[i]))
            {
                KeyList.remove(i);
                KeyNameList.remove(i);
            }   
            
        }
    }
    public static ivybase__Price_List_Entrie__c createPriceListEntry(Id PriceListId,Id ProductId,Decimal Value,String PriceType,String CustomerOrCustomerHierarchyCode)
    {
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=PriceListId;
        priceListEntry.ivybase__Product__c=ProductId;
        priceListEntry.ivybase__UOM_1_Price__c=Value;
        priceListEntry.Type__c=PriceType;
        priceListEntry.RelatedCustomerCode__c=CustomerOrCustomerHierarchyCode;
        system.debug(priceListEntry);
        return priceListEntry;
    }
    public static ivybase__Price_List__c createPriceList(String AccountName,Date FromDate,Date ToDate)
    {
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+AccountName+' Price List';
        priceList.ivybase__Valid_To__c=ToDate;
        priceList.ivybase__Valid_From__c=FromDate;
        priceList.ivybase__Active__c='Yes';
        return priceList;
    }
    public static ivydsd__Discount__c createDiscountList(String DiscountTypeCode,Date FromDate,Date ToDate,String AccountName)
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
        return DiscountList;
    }
    public static ivydsd__Discount_Mapping__c createDiscountMapping(Id AccountId,Id DiscountListId)
    {
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Discount__c=DiscountListId;
        if(AccountId!=null){
            DiscountMapping.ivydsd__Account__c=AccountId;
        }
        return DiscountMapping;
    }
    public static ivydsd__Discount_Detail__c createDiscountDetail(Id ProductId,Id DiscountListId, Id ProductHierarchyId,Decimal DiscountPrice,String CustomerOrCustomerHierarchyCode)
    {
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c();
        DiscountDetail.ivydsd__Discounts__c=DiscountListId;
        DiscountDetail.ivydsd__Value__c=DiscountPrice;
        DiscountDetail.RelatedCustomerCode__c=CustomerOrCustomerHierarchyCode; 
        if(ProductId!=null){
            DiscountDetail.ivydsd__Product__c=ProductId;
        }
        if(ProductHierarchyId!=null)
        {
            DiscountDetail.ivydsd__Product_Hierarchy__c=ProductHierarchyId;
        }
        return DiscountDetail;
    }
    
    public static Map<String,Map<String,Decimal>> getQuantityIfItsBOMProduct(Set<String> ChildBOMCode, Set<String> BOMCode)
    {
        List<ivybase__Bill_Of_Material_SKU_Detail__c> skudetail = [select id,name, ivybase__Bill_Of_Material_SKU__c,ivybase__Bill_Of_Material_SKU__r.External_Code__c,ivybase__Product__r.External_Code__c, ivybase__Product__c,ivybase__Quantity__c  from ivybase__Bill_Of_Material_SKU_Detail__c where ivybase__Bill_Of_Material_SKU__r.External_Code__c=:BOMCode and ivybase__Product__r.External_Code__c=:ChildBOMCode];
        system.debug('skudetail'+skudetail);
        
        Map<String,Map<String,Decimal>> BOMChildQuantity = new Map<String,Map<String,Decimal>>();
        for(ivybase__Bill_Of_Material_SKU_Detail__c det:skudetail)
        {
            
                Map<String,Decimal> prodMap = new Map<String,Decimal>();
                prodMap.put(det.ivybase__Product__r.External_Code__c,det.ivybase__Quantity__c);
                BOMChildQuantity.put(det.ivybase__Bill_Of_Material_SKU__r.External_Code__c,prodMap);
            
        }
        system.debug('BOMChildQuantity'+BOMChildQuantity);
        
       return  BOMChildQuantity;
    }
    
    public static Boolean insertOrUpdatePriceListEntry(List<Id> ProductId,List<Id> PriceListId,Decimal PriceValue,String PriceType,String CustomerOrCustomerHierarchyCode,Map<String,Decimal> CustomerCodeAndPriorityMap,Boolean IsBOMProduct,Decimal QuantityToCalculateForBOMChild)
    {
        Boolean RecordStatus=True;   
        system.debug('Insert or update = ProductId'+ProductId);
        system.debug('Insert or update = PriceListId'+PriceListId);
        system.debug('Insert or update = PriceValue'+PriceValue);
        List<ivybase__Price_List_Entrie__c> PriceListEntryToUpdate = new List<ivybase__Price_List_Entrie__c>();
        List<ivybase__Price_List_Entrie__c> PriceListEntryToInsert = new List<ivybase__Price_List_Entrie__c>();
        Map<String,ivybase__Price_List_Entrie__c> EntryCombination = PriceListEntryService.CheckIfTheCombinationExist(ProductId,PriceListId);
        for(Integer i=0;i<PriceListId.size();i++){
            if(ProductId[i]!=null){
                if(!EntryCombination.containsKey(ProductId[i]+''+PriceListId[i])){
                    System.debug('No Combination exists');
                    ivybase__Price_List_Entrie__c pl=createPriceListEntry(PriceListId[i],ProductId[i],(PriceValue*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild)),PriceType,CustomerOrCustomerHierarchyCode);
                    PriceListEntryToInsert.add(pl);
                }
                else
                {
                    system.debug('Already a combination exist');
                    //if its standard price we will not currently update anything  
                    ivybase__Price_List_Entrie__c pl = EntryCombination.get(ProductId[i]+''+PriceListId[i]);
                    if(pl.RelatedCustomerCode__c!=null && (String.IsEmpty(CustomerOrCustomerHierarchyCode)==false) && CustomerCodeAndPriorityMap.containsKey(CustomerOrCustomerHierarchyCode) && CustomerCodeAndPriorityMap.containsKey(pl.RelatedCustomerCode__c) )
                    {
                        Decimal exisitingPriority = CustomerCodeAndPriorityMap.get(pl.RelatedCustomerCode__c);
                        Decimal CurrentPriority = CustomerCodeAndPriorityMap.get(CustomerOrCustomerHierarchyCode);
                        system.debug('exisitingPriority'+exisitingPriority);
                        system.debug('CurrentPriority'+CurrentPriority);
                        if(CurrentPriority<=exisitingPriority)
                        {
                            system.debug('Since we got Equal or priority we update price');
                            system.debug('IsBOMProduct='+IsBOMProduct);
                            if(IsBOMProduct){
                                system.debug('PriceValue'+(PriceValue*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild)));
                                pl.ivybase__UOM_1_Price__c+=(PriceValue*(QuantityToCalculateForBOMChild==null?1:QuantityToCalculateForBOMChild));
								system.debug('pl.ivybase__UOM_1_Price__c'+pl.ivybase__UOM_1_Price__c);
                            }
                            else
                            {
                                pl.ivybase__UOM_1_Price__c=PriceValue;	
                            }
                            pl.Type__c=PriceType;
                            pl.RelatedCustomerCode__c=CustomerOrCustomerHierarchyCode;
                            PriceListEntryToUpdate.add(pl);
                            system.debug('p1'+pl);
                        }
                    }
                    
                }
            }
            else
            {
                RecordStatus=false;
            }
        }
        if(PriceListEntryToInsert.size()>0)
        {
            insert PriceListEntryToInsert;
            system.debug('PriceListEntryInserted'+PriceListEntryToInsert);
        }
        if(PriceListEntryToUpdate.size()>0)
        {
            update PriceListEntryToUpdate;
            system.debug('PriceListEntryUpdated'+PriceListEntryToUpdate);
        }
        return RecordStatus;   
    }
    public static String stripAwayFrontZero(String input)
    {
        String result='';
        List<String> slist=input.split('');
        Boolean numberCame=false;
        for(String s : slist)
        {
            
            if(s!='0')
            {
                numberCame=true; 
            }
            
            if(numberCame==true)
            {
                result+=s+'';  
            }
            
        }
        system.debug('result'+result);
        return result;
        
        
    }
    
}