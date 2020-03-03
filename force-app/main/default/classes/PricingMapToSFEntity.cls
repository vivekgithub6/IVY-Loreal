/**
 * Created By : Ivy Mobility
 * Purpose : The utility class for the Pricing Daily batch Jobs
 * Test Classes : TESTPricingMasterStageBatch
*/
public with sharing class PricingMapToSFEntity {
    public static ivybase__Price_List__c createPriceList(String AccountName,Date FromDate,Date ToDate,String CountryCode,String currencyCode)
    {
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+AccountName+' Price List';
        priceList.ivybase__Valid_To__c=ToDate;
        priceList.ivybase__Valid_From__c=FromDate;
        priceList.ivybase__Active__c='Yes';
        priceList.Market_ISO__c=CountryCode;
        priceList.CurrencyIsoCode=currencyCode;
        return priceList;
    }
    public static ivybase__Price_List_Entrie__c createPriceListEntry(Id PriceListId,Id ProductId,Decimal Value,String PriceType,String CountryCode,String currencyCode)
    {
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=PriceListId;
        priceListEntry.ivybase__Product__c=ProductId;
        priceListEntry.ivybase__UOM_1_Price__c=Value;
        priceListEntry.Type__c=PriceType;
        priceListEntry.Market_ISO__c=CountryCode;
        priceListEntry.CurrencyIsoCode=currencyCode;
        system.debug(priceListEntry);
        return priceListEntry;
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
    public static void insertOrUpdateStandardPriceList(List<Id> PriceListId,List<Id> ProductId,Decimal price,String PriceType,String CountryCode,String currencyCode)
    {
        Map<String,ivybase__Price_List_Entrie__c> EntryCombination = PriceListEntryService.CheckIfTheCombinationExist(ProductId,PriceListId);
        for(Integer i=0;i<PriceListId.size();i++){
            if(!EntryCombination.containsKey(ProductId[i]+''+PriceListId[i])){
                ivybase__Price_List_Entrie__c pl=createPriceListEntry(PriceListId[i],ProductId[i],price,PriceType,CountryCode,currencyCode);
                insert pl;
            }
            else
            {
                ivybase__Price_List_Entrie__c pl = EntryCombination.get(ProductId[i]+''+PriceListId[i]);
                pl.ivybase__UOM_1_Price__c=price;
                update pl;
            }
        }
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
    public static boolean populateAccountAndProductCodeMap(List<String> KeyList,List<String> KeyNameList,Map<Id,Map<String,String>> AccountAndProductCodeMap,Pricing_Master_Stage__c record,Map<String,String> codeAndDescMap,List<String> CustomerOrCustomerHierarchyCode,Set<String> materialGroupSet,String CountryISOCode)
    {
        if(Test.isRunningTest())
        {
            CountryISOCode='';
        }
        Boolean materialGroupCheck = false; 
        for(String s:KeyNameList)
        {
            if(materialGroupSet.contains(s))
            {
                materialGroupCheck=true;
            }
        }
        if(!AccountAndProductCodeMap.containsKey(record.Id))
        {
            String ProductCode='';
            String ProductHierarchyCode='';
            String Product ='';
            String ProductHierarchy ='';
            String Division='';
            String DivisionCode='';
            String BomCode='';
            String Bom='';
            String MaterialGroupCode='';
            String MaterialGroup='';
            
            
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
                    if(materialGroupCheck==false){
                        ProductHierarchyCode=ProductHierarchyCode+KeyList[i];
                    }
                    else
                    {
                        if(ProductHierarchyCode=='')
                        {
                            ProductHierarchyCode=KeyList[i];
                        }else
                        {
                            ProductHierarchyCode=ProductHierarchyCode + KeyList[i]; //Changed on 2019-06-13
                        }
                        
                    }
                }
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='Division' )
                {
                    Division=codeAndDescMap.get(KeyNameList[i]);
                    DivisionCode=KeyList[i];
                }
                if(codeAndDescMap.containsKey(KeyNameList[i]) && codeAndDescMap.get(KeyNameList[i])=='Material Group' )
                {
                    MaterialGroup=codeAndDescMap.get(KeyNameList[i]);
                    MaterialGroupCode=KeyList[i];
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
                AccountAndProductCodeMap.get(record.Id).put(Product,ProductCode+CountryISOCode);
                AccountAndProductCodeMap.get(record.Id).put(ProductHierarchy,ProductHierarchyCode+CountryISOCode);
                AccountAndProductCodeMap.get(record.Id).put(Bom,BomCode+CountryISOCode);
                AccountAndProductCodeMap.get(record.Id).put(Division,DivisionCode);
                AccountAndProductCodeMap.get(record.Id).put(MaterialGroup,MaterialGroupCode+CountryISOCode);
            }
            else
            {
                Map<String,String> ProductAndHierarchyMap = new Map<String,String>();
                ProductAndHierarchyMap.put(Product,ProductCode+CountryISOCode);
                ProductAndHierarchyMap.put(ProductHierarchy,ProductHierarchyCode+CountryISOCode);
                ProductAndHierarchyMap.put(Bom,BomCode+CountryISOCode);
                ProductAndHierarchyMap.put(Division,DivisionCode);
                ProductAndHierarchyMap.put(MaterialGroup,MaterialGroupCode+CountryISOCode);
                AccountAndProductCodeMap.put(record.Id,ProductAndHierarchyMap);
            }
        }
        return materialGroupCheck;
    }
    /*
getEntityMappedRecord will get Pricing_Master_Stage__c records and process Variable key and Variable name and
create record in stage 2 with lookup to records in saleforce org from the values in Variable key
if corresponding record not found in Salesforce , exception thrown and  Pricing_Master_Stage__c records mark as pending.
*/
    public static void getEntityMappedRecord(Pricing_Master_Stage__c record,String CountryCode,String currencyCode){
        system.debug('CountryCode'+CountryCode);
        try{
            Map<String,String> CountryISOAndCodeMap = new Map<String,String>();
            String CountryISOCode='';
            List<Pricing_Stage_2__c> stage2ListToInsert = new List<Pricing_Stage_2__c>();
            Pricing_Stage_2__c newRec = new Pricing_Stage_2__c();
            // Get the Codes from Metadata data and use them to identify entity type
            List<PricingAndDiscountCode__mdt> PricingAndDiscountList =[select Code__c,Description__c,Ignore__c,Priority__c from PricingAndDiscountCode__mdt];
            List<CountryCodeMarketISO__mdt> countryCodeAndISOList = [select Country__c , Country_Code__c  from CountryCodeMarketISO__mdt];
            for(CountryCodeMarketISO__mdt m:countryCodeAndISOList)
            {
                if(m.Country__c!=null && m.Country_Code__c!=null){
                    CountryISOAndCodeMap.put(m.Country__c,m.Country_Code__c);
                    }
            }
            if(CountryISOAndCodeMap.containsKey(CountryCode))
            {
                CountryISOCode=CountryISOAndCodeMap.get(CountryCode);
            }
            Set<String> StringToIgnore = new Set<String>();
            Set<String> MaterialGroupSet = new Set<String>();
            Set<String> CustomerSet = new Set<String>();
            Map<String,String> codeAndDescMap = new Map<String,String>();
            List<String> CustomerOrCustomerHierarchyCodeList= new List<String>();
            String Error=null;
            Boolean RecordStatus=True;
            for(PricingAndDiscountCode__mdt pdc:PricingAndDiscountList)
            {
                //if its marked as Ignore
                if(pdc.Ignore__c)
                {
                    StringToIgnore.add(pdc.Code__c);
                }
                else
                {
                    codeAndDescMap.put(pdc.Code__c,pdc.Description__c);
                    if(String.valueOf(pdc.Description__c).contains('Material'))
                    {
                        MaterialGroupSet.add(pdc.Code__c); 
                    }
                    if(String.valueOf(pdc.Description__c).contains('Customer'))
                    {
                        CustomerSet.add(pdc.Code__c); 
                    }
                }
            } 
            String Key = record.Variable_Key__c;
            String KeyName = record.Variable_Key_Fields_Name__c; 
            record.Price__c=record.Price__c.setScale(2);
            //if the price is negative , convert to positive 
            if(record.Price__c<0){
                record.Price__c=record.Price__c*(-1);
            }
            newRec.Price__c = record.price__c;
            newRec.Pricing_Condition_Type__c = record.Pricing_Condition_Type__c;
            newRec.Valid_From_Date__c=record.Valid_From_Date__c;
            newRec.Valid_To_Date__c=record.Valid_To_Date__c;
            system.debug('Key'+Key);
            system.debug('KeyName'+KeyName);
            system.debug('From Date'+record.Valid_From_Date__c);
            system.debug('To Date'+record.Valid_To_Date__c);
            //split both the strings
            List<String> KeyList = Key.split('/');
            List<String> KeyNameList = KeyName.split('/');
            
            //remove unwanted key and name from the list
            if(KeyList.size()==KeyNameList.size())
            {
                removeUnWantedKeyFromList(KeyList,KeyNameList,StringToIgnore);
            }
            
            //map<recordId,<Customer(Or)CustomerHierarchy,Key>
            //map<recordId,<Product(Or)ProductHierarchyHierarchy,Key>
            
            //eg : <001p000000SNGnGAAX, <Customer , 0000702288 > >
            //eg: <001p000000SNGnGAAX, <CustomerHierarchy , 0000800089 > >
            //eg: <001p000000SNGnGAAX, <ProductHierarchyHierarchy , C2 > >
            //eg: <001p000000SNGnGAAX, <Product , FR280010 > >
            //eg: <001p000000SNGnGAAX, <BOM , UP002325 > >
            //eg: <001p000000SNGnGAAX, <Division , 32 > >
            Map<Id,Map<String,String>> AccountAndProductCodeMap = new Map<Id,Map<String,String>>();
            
            //populate the map AccountAndProductCodeMap it populates CustomerOrCustomerHierarchyCodeList as well.
            boolean materialGroupCheck = populateAccountAndProductCodeMap(KeyList,KeyNameList,AccountAndProductCodeMap,record,codeAndDescMap,CustomerOrCustomerHierarchyCodeList,MaterialGroupSet,CountryISOCode);
            
            String CustomerOrCustomerHierarchyCode=null;
            for(String cs:CustomerOrCustomerHierarchyCodeList){
                CustomerOrCustomerHierarchyCode=cs;
            }
            
            
            
            Set<String> CustomerHierarchyCode = new Set<String>();
            Set<String> CustomerCode = new Set<String>();
            Set<String> ProductCode = new Set<String>();
            Set<String> ProductHierarchyCode = new Set<String>();
            Set<String> BOMCode = new Set<String>();
            Set<String> DivisionCode = new Set<String>();
            Set<String> MaterialGroupCode = new Set<String>();
            Set<String> ChildBOMCode = new Set<String>();
            system.debug('AccountAndProductCodeMap'+AccountAndProductCodeMap);
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
                //getting all division to search in division
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Division'))
                {
                    DivisionCode.add(AccountAndProductCodeMap.get(record.Id).get('Division'));
                }
                //getting all material Group to search in prodcut master
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Material Group'))
                {
                    MaterialGroupCode.add(AccountAndProductCodeMap.get(record.Id).get('Material Group'));
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
            
            system.debug('CustomerHierarchyCode'+CustomerHierarchyCode);
            system.debug('CustomerCode'+CustomerCode);
            system.debug('ProductCode'+ProductCode);
            system.debug('ChildBOMCode'+ChildBOMCode);
            system.debug('ProductHierarchyCode'+ProductHierarchyCode);
            system.debug('DivisionCode'+DivisionCode);
            Map<Id,ivybase__Product__c> ProductIdAndRecordMap = new map <Id,ivybase__Product__c>();
            Map<String,Id> ProductCodeAndProductMap = new Map<String,ID>();
            List<ivybase__Product__c> relatedProduct = new List<ivybase__Product__c>();
            //if its standard price will be inserted here itself
            if(record.Pricing_Condition_Type__c=='YPR0')
            {
                if(ProductCode.size()>0)
                {
                    relatedProduct=ProductService.getProductFromProductCode(ProductCode);
                    for(ivybase__Product__c p:relatedProduct)
                    {
                        ProductIdAndRecordMap.put(p.Id,p);
                        ProductCodeAndProductMap.put(p.External_Code__c,p.id);
                    }
                }
                system.debug('Its Standard Price');
                if(AccountAndProductCodeMap.get(record.Id).containsKey('Product') && AccountAndProductCodeMap.get(record.Id).containsKey('BOM')==false  )
                {
                    system.debug('we got some product');
                    String standardPriceListId = PriceService.getSTDPriceListId(CountryCode);
                    if(ProductCodeAndProductMap.containsKey(AccountAndProductCodeMap.get(record.Id).get('Product')) ){
                        List<Id> ProductIdList = new List<Id>();
                        List<Id> PriceIdList = new List<Id>();
                        
                        ProductIdList.add(ProductCodeAndProductMap.get(AccountAndProductCodeMap.get(record.Id).get('Product'))); 
                        
                        if(standardPriceListId==null){
                            ivybase__Price_List__c standardpriceList = createPriceList('Standard '+CountryCode,null,null,CountryCode,currencyCode);
                            standardpriceList.ivybase__Is_Standard__c=true;
                            insert standardpriceList;
                            standardPriceListId=standardpriceList.Id;                                     
                        }
                        PriceIdList.add(Id.ValueOf(standardPriceListId));
                        Decimal PriceValue  = record.Price__c;
                        system.debug('PriceIdList in standard list '+PriceIdList);
                        insertOrUpdateStandardPriceList(PriceIdList,ProductIdList,record.Price__c,record.Pricing_Condition_Type__c,CountryCode,currencyCode);
                    }
                    else
                    {
                        Error+='Product Code related product not found In Product master. ';
                        RecordStatus=false;
                    }
                }
                else if(AccountAndProductCodeMap.get(record.Id).containsKey('BOM'))
                {
                    Error+='bad data =  BOm Product No StandardPrice List applied';
                    RecordStatus=false;    
                }
                else
                {
                    system.debug('bad data =  bcoz for standard price list we need to populate Product level data in price list entry we dont have product Data here.');
                    //bad data =  bcoz for standard price list we need to populate Product level data in price list entry we dont have product Data here 
                    Error+='bad data =  bcoz for standard price list we need to populate Product level data in price list entry we dont have product Data here. ';
                    RecordStatus=false;
                }
            }
            else{
                if(CustomerHierarchyCode.size()>0)
                {   
                    ivybase__Store_Hierarchy__c hier = [select id from ivybase__Store_Hierarchy__c where Store_Number__c in :CustomerHierarchyCode];
                    newRec.Store_Hierarchy__c = hier.id;
                }
                
                //get all account records 
                if(CustomerCode.size()>0)
                {
                    Account acc = [select id from Account where Sold_To_Party_Number__c in :CustomerCode];
                    newRec.Account__c = acc.id;
                }
                //get all product hierarchy records 
                if(ProductHierarchyCode.size()>0 && materialGroupCheck==false)
                {
                    ivybase__Product_Hierarchy__c prodhier = [select id from ivybase__Product_Hierarchy__c where Code__c in :ProductHierarchyCode];
                    newRec.Product_Hierarchy__c = prodhier.id;
                }
                if(DivisionCode.size()>0)
                {
                    Division__c div = [select id from Division__c where Division_Code__c in :DivisionCode];
                    newRec.Division__c = div.id;
                }
                
                //get all product master records 
                if(ProductCode.size()>0)
                {                
                    if(AccountAndProductCodeMap.get(record.Id).containsKey('BOM'))
                    {
                        
                        ivybase__Product__c prod = [select id from ivybase__Product__c where External_Code__c in :BOMCode and ivybase__Active__c='Yes' and ivybase__Is_Competitor__c=False];
                        newRec.Product_Master__c  = prod.id;  
                        
                        ivybase__Product__c prodchild = [select id from ivybase__Product__c where External_Code__c in :ChildBOMCode and ivybase__Active__c='Yes' and ivybase__Is_Competitor__c=False];
                        newRec.Child_Product_Master__c  = prodchild.id;  
                        
                    }
                    else
                    {
                        system.debug('non bom');
                        ivybase__Product__c prod = [select id from ivybase__Product__c where External_Code__c in :ProductCode and ivybase__Active__c='Yes' and ivybase__Is_Competitor__c=False];
                        newRec.Product_Master__c = prod.id;  
                        system.debug('system'+prod.id);
                    }
                    
                }
                newRec.Parent_stage_record__c=record.id;
                newRec.RelatedCustomerCode__c=record.Variable_Key_Fields_Name__c;
                newRec.Market_ISO__c=CountryCode;
                newRec.CurrencyIsoCode=currencyCode;
                if(checkIfItsDivisionLevelDiscounts(record.Variable_Key_Fields_Name__c,CustomerSet) && codeAndDescMap.containsKey(record.Pricing_Condition_Type__c) && codeAndDescMap.get(record.Pricing_Condition_Type__c)=='Discount')
                {
                    stage2ListToInsert.add(newRec);
                }
                
                else if(materialGroupCheck==true)
                {
                    newRec.Division__c=null;
                    stage2ListToInsert.addAll(MaterialGroupStage2Records(newRec,MaterialGroupCode,ProductHierarchyCode));
                }
                else{
                    newRec.Division__c=null;
                    stage2ListToInsert.add(newRec);                
                }
                if(stage2ListToInsert.size()>0){
                    system.debug('stage2ListToInsert'+stage2ListToInsert);
                    insert stage2ListToInsert;
                }
                system.debug('newRec'+newRec);
            }
            if(RecordStatus)
            {
                record.Status__c='Completed';
            }
            else
            {
                record.Status__c='pending'; 
            }
            record.ErrorMessage__c=(Error==null?'':Error);
            update record;
            system.debug('record'+record);
        }catch(Exception e)
        {
            system.debug('e'+e);
            system.debug('e'+e.getCause());
            system.debug('e'+e.getMessage());
            system.debug('e'+e.getStackTraceString());
            record.Status__c='pending';
            record.ErrorMessage__c='May be related Data not found in salesforce'+e.getMessage()+''+e.getStackTraceString()+''+e.getCause();
            update record;
            system.debug('record'+record);
        }
    }
    public static List<Pricing_Stage_2__c> MaterialGroupStage2Records(Pricing_Stage_2__c newRec,set<String> MaterialGroupCode,set<String> ProductHierarchyCode)
    {
        List<Pricing_Stage_2__c> stage2Records = new List<Pricing_Stage_2__c>();
        Set<string> HierarchyCode = new Set<String>();
        for(String s :ProductHierarchyCode)
        {
            HierarchyCode.add(s);
        } 
        SYSTEM.debug('HierarchyCode'+HierarchyCode);
        Map<Id,Id> SkuVsFunctionMap = new Map<Id,Id>();
        Set<id> functionIdSet  = new Set<Id>();
        List<ivybase__Product__c> prod = [select id,ivybase__Parent__c from ivybase__Product__c where Customer_Material__c in :MaterialGroupCode];
        for(ivybase__Product__c p:prod)
        {
            functionIdSet.add(p.ivybase__Parent__c);
            SkuVsFunctionMap.put(p.id,p.ivybase__Parent__c); 
        }
        List<ivybase__Product_Hierarchy__c> ProductHierarchyList = ProductHierarchyService.getAllProductHierarchy_List_For_The_Function(functionIdSet);
        Map<Id,ivybase__Product_Hierarchy__c> productHierarchyMap = new Map<Id,ivybase__Product_Hierarchy__c>();
        Map<Id,Id> productHierarchyParentMap = new Map<Id,Id>();
        for(ivybase__Product_Hierarchy__c h:ProductHierarchyList)
        {
            productHierarchyMap.put(h.id,h);
            productHierarchyParentMap.put(h.id,h.ivybase__Parent__c);    
        }
        Map<Id,Set<Id>> FunctionRelatedSetOfHierarchy = new Map<Id,Set<Id>>();
        for(Id funcitonId:functionIdSet)
        {
            if(FunctionRelatedSetOfHierarchy.containsKey(funcitonId))
            {
                
            }
            else
            {
                Set<Id> AllRelatedParent = new Set<Id>();
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
        system.debug('productHierarchyMap'+productHierarchyMap);
        Set<Id> givenProductHierarchy = new Set<Id>();
        for(Id phId :productHierarchyMap.keySet())
        {
            if(HierarchyCode.contains(productHierarchyMap.get(phId).Code__c))
            {
                givenProductHierarchy.add(phId);
            }
        }
        SYSTEM.debug('givenProductHierarchy'+givenProductHierarchy);
        SYSTEM.debug('FunctionRelatedSetOfHierarchy'+FunctionRelatedSetOfHierarchy);
        SYSTEM.debug('SkuVsFunctionMap'+SkuVsFunctionMap);
        Set<Id> matchedFunction=MapClass.getSetOfkeyfromMapwithValueMatchingWithOurValueSet(FunctionRelatedSetOfHierarchy,givenProductHierarchy);
        system.debug('matchedFunction'+matchedFunction);
        Set<Id> matchedProduct = MapClass.getSetOfKey_From_Map_With_Matching_Value(SkuVsFunctionMap,matchedFunction);
        for(Id product: matchedProduct)
        {
            Pricing_Stage_2__c stage2 = newRec.clone();
            stage2.Product_Master__c = product;
            stage2Records.add(stage2);
        }
        return stage2Records;
    }
    public static boolean checkIfItsDivisionLevelDiscounts(String VariableKey,Set<String> CustomerCode)
    {
        system.debug('VariableKey'+VariableKey+'CustomerCode'+CustomerCode);
        for(String code:CustomerCode)
        {
            if(VariableKey.endsWithIgnoreCase(code))
            {
                return true;
            }
        }
        return false;
    }
}