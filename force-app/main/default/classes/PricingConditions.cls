public with sharing class PricingConditions {
    public static map<id,map<id,map<string,decimal>>> getprice(Map<id,set<id>> accidprodidMap,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap,Map<Id,Map<Id,Decimal>> BOMParentChildMap,map<id,id> accountpriceidMapParam){
        //quering account with price based on account id coming from trigger handler as a param
        list<account> acclist= new list<account>();
        if(accidprodidMap!=null){
            acclist= [select id,Price_List__c from account where id IN:accidprodidMap.keySet()];
        }
        Set<Id> ProdcutId = new Set<Id>();
        //get all the products
        for(Id acc:accidprodidMap.keyset())
        {
            ProdcutId.addAll(accidprodidMap.get(acc));
        }
        getQuantityIfItsBOMProduct(ProdcutId,BOMParentChildMap);
        system.debug('BOMParentChildMap in pricing condition'+BOMParentChildMap);
        Set<Id> parentBOM = new Set<Id>();
        Set<Id> child = new Set<Id>();
        for(Id parentBOMId:BOMParentChildMap.keyset())
        {
            parentBOM.add(parentBOMId);
            child.addAll(BOMParentChildMap.get(parentBOMId).keyset());
        }
        
        
        
        set<id> pricelistid= new set<id>();// holding the price ids
        map<id,id> accountpriceidMap=accountpriceidMapParam;// holding the accid priceids
        for(account acc:acclist ){
            if(acc.Price_List__c!=null){
                pricelistid.add(acc.Price_List__c);
                accountpriceidMap.put(acc.id,acc.Price_List__c); 
            }
        }
        //all the child products price will be populated here
        if(BOMParentChildMap.keyset().size()>0){
            getAllChildProductPrice(parentBOM,child,pricelistid,BOMParentChildMap,BOMChildPriceMap);
        }
        system.debug('pricelistid'+pricelistid);
        //querying the pricelist entry based on accountpriceidMap keyset
        list<ivybase__Price_List_Entrie__c> pleList= new list<ivybase__Price_List_Entrie__c>();
        pleList=[select id,ivybase__Price_List__c,ivybase__Product__c,ivybase__UOM_1_Price__c,Type__c,ivybase__Active__c,ivybase__Price_List__r.ivybase__Is_Standard__c 
                 from ivybase__Price_List_Entrie__c where ivybase__Price_List__c IN:pricelistid and ivybase__Price_List__r.ivybase__Is_Standard__c =false];
        system.debug('pleList'+pleList);
        map<id,list<ivybase__Price_List_Entrie__c>> priceidPriceEntryMap = new map<id,list<ivybase__Price_List_Entrie__c>>();
        //iterating ovver the list entry and froming a map with pricelist id and pricelist entry rec
        for(ivybase__Price_List_Entrie__c ple:pleList){
            if(priceidPriceEntryMap.containsKey(ple.ivybase__Price_List__c)){
                priceidPriceEntryMap.get(ple.ivybase__Price_List__c).add(ple);
            }else{
                list<ivybase__Price_List_Entrie__c> plelist1=new list<ivybase__Price_List_Entrie__c>();
                plelist1.add(ple);
                priceidPriceEntryMap.put(ple.ivybase__Price_List__c,plelist1); 
            }
        }
        map<id,map<id,map<string,decimal>>> accountproducttypecashMap = new  map<id,map<id,map<string,decimal>>>();
        //iterating over Account id and price list to get the respect product price and type 
        for(id accid:accountpriceidMap.keyset()){
            if(accountpriceidMap.get(accid)!=null){
                if(priceidPriceEntryMap!=null && priceidPriceEntryMap.containskey(accountpriceidMap.get(accid))){
                    for(ivybase__Price_List_Entrie__c pe:priceidPriceEntryMap.get(accountpriceidMap.get(accid))){
                        // priceidPriceEntryMap.put(accid)
                        //map<string,decimal> mapPriceType = new map<string,decimal>();
                        //Map<Id,map<string,decimal>> mapProdIdmapPriceType =new Map<Id,map<string,decimal>>();
                        if(MapClass.getkeyfromMapwithValue(accidprodidMap,pe.ivybase__Product__c)!=null){
                            system.debug('prod******'+pe.ivybase__Product__c);
                            if(accountproducttypecashMap.containsKey(accid))
                            {
                                if(accountproducttypecashMap.get(accid).containsKey(pe.ivybase__Product__c))
                                {
                                        accountproducttypecashMap.get(accid).get(pe.ivybase__Product__c).put(pe.Type__c,pe.ivybase__UOM_1_Price__c);   
                                }
                                else
                                {
                                map<string,decimal> mapPriceType = new map<string,decimal>();
                                mapPriceType.put(pe.Type__c,pe.ivybase__UOM_1_Price__c);//+','+pe.ivybase__Product__c      
                                accountproducttypecashMap.get(accid).put(pe.ivybase__Product__c,mapPriceType);
                                    
                                }
                                
                            }else
                            {
                                map<string,decimal> mapPriceType = new map<string,decimal>();
                                mapPriceType.put(pe.Type__c,pe.ivybase__UOM_1_Price__c);//+','+pe.ivybase__Product__c      
                                Map<Id,map<string,decimal>> mapProdIdmapPriceType =new Map<Id,map<string,decimal>>();
                                mapProdIdmapPriceType.put(pe.ivybase__Product__c,mapPriceType);
                                accountproducttypecashMap.put(accid ,mapProdIdmapPriceType);
                                
                            }
                        }
                    }
                }
            }
        }
        system.debug('accountproducttypecashMap'+accountproducttypecashMap);
        return accountproducttypecashMap;
    }
    //method for getting BOM priceValue
    //getChildBOMValue
    public static void populateMapBOMChild(Id PriceListId,Id BOMParent,Id ChildBOM,String CodeType,Decimal Price,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap)
    {
        if(BOMChildPriceMap.containsKey(PriceListId))
        {
            if(BOMChildPriceMap.get(PriceListId).containsKey(BOMParent))
            {
                if(BOMChildPriceMap.get(PriceListId).get(BOMParent).containsKey(ChildBOM)==false)
                {
                    Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                    typeDecimal.put(CodeType,Price);
                    BOMChildPriceMap.get(PriceListId).get(BOMParent).put(ChildBOM,typeDecimal); 
                    
                }
                else
                {
                    BOMChildPriceMap.get(PriceListId).get(BOMParent).get(ChildBOM).put(CodeType,Price); 
                }
            }
            else
            {
                Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
                typeDecimal.put(CodeType,Price);
                Map<Id,Map<String,Decimal>> ChilddiscountMap = new Map<Id,Map<String,Decimal>>();
                ChilddiscountMap.put(ChildBOM,typeDecimal);
                Map<Id,Map<Id,Map<String,Decimal>>> BOMChildDiscMap = new Map<Id,Map<Id,Map<String,Decimal>>>();
                BOMChildPriceMap.get(PriceListId).put(BOMParent,ChilddiscountMap);
            }
            
        }
        else
        {
            Map<String,Decimal> typeDecimal= new Map<String,Decimal>();
            typeDecimal.put(CodeType,Price);
            Map<Id,Map<String,Decimal>> ChilddiscountMap = new Map<Id,Map<String,Decimal>>();
            ChilddiscountMap.put(ChildBOM,typeDecimal);
            Map<Id,Map<Id,Map<String,Decimal>>> BOMChildDiscMap = new Map<Id,Map<Id,Map<String,Decimal>>>();
            BOMChildDiscMap.put(BOMParent,ChilddiscountMap);
            BOMChildPriceMap.put(PriceListId,BOMChildDiscMap);
            
        }
        
        
    }
    public static void getAllChildProductPrice(Set<Id> BOM,Set<Id> child,Set<Id> priceList,Map<Id,Map<Id,Decimal>> BOMChildMap,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap)
    {
        
        List<ivybase__Price_List_Entrie__c> grandChildPriceEntry = [select id,ivybase__Price_List__c,ivybase__Product__c,ivybase__UOM_1_Price__c,Type__c,ivybase__Active__c,
                                                                    ivybase__Price_List__r.ivybase__Is_Standard__c,Parent__r.ivybase__Product__c,
                                                                    Parent__r.ivybase__Price_List__c from ivybase__Price_List_Entrie__c where Parent__r.ivybase__Product__c=:BOM and Parent__r.ivybase__Price_List__c=:priceList];
        Set<Id> gotPriceEntry = new Set<Id>();
        for(ivybase__Price_List_Entrie__c grandChild:grandChildPriceEntry)
        {
            populateMapBOMChild(grandChild.Parent__r.ivybase__Price_List__c,grandChild.Parent__r.ivybase__Product__c,grandChild.ivybase__Product__c,grandChild.Type__c,grandChild.ivybase__UOM_1_Price__c,BOMChildPriceMap);
            
        } 
        
        
        List<ivybase__Price_List_Entrie__c> directChildPriceEntry = [select id,ivybase__Price_List__c,ivybase__Product__c,ivybase__UOM_1_Price__c,Type__c,ivybase__Active__c,
                                                                     ivybase__Price_List__r.ivybase__Is_Standard__c,Parent__r.ivybase__Product__c,
                                                                     Parent__r.ivybase__Price_List__c from ivybase__Price_List_Entrie__c where ivybase__Product__c=:child and ivybase__Price_List__c=:priceList];
        
        for(ivybase__Price_List_Entrie__c directEntry :directChildPriceEntry)
        {
            for(Id b:BOMChildMap.keyset())
            {
                populateMapBOMChild(directEntry.ivybase__Price_List__c,b,directEntry.ivybase__Product__c,directEntry.Type__c,directEntry.ivybase__UOM_1_Price__c,BOMChildPriceMap);
            }
        }
        
        List<ivybase__Price_List_Entrie__c> StandardChildPriceEntry = [select id,ivybase__Price_List__c,ivybase__Product__c,ivybase__UOM_1_Price__c,Type__c,ivybase__Active__c,
                                                                       ivybase__Price_List__r.ivybase__Is_Standard__c,Parent__r.ivybase__Product__c,
                                                                       Parent__r.ivybase__Price_List__c from ivybase__Price_List_Entrie__c where ivybase__Price_List__r.ivybase__Is_Standard__c=true and ivybase__Product__c=:child  ];
        
        system.debug('StandardChildPriceEntry'+StandardChildPriceEntry);
        for(ivybase__Price_List_Entrie__c directEntry :StandardChildPriceEntry)
        {
            for(Id price:priceList)
            {
                for(Id b:BOMChildMap.keyset())
                {
                    populateMapBOMChild(price,b,directEntry.ivybase__Product__c,directEntry.Type__c,directEntry.ivybase__UOM_1_Price__c,BOMChildPriceMap);
                }
            }
            
            
        }
        
        
        
        
        
        system.debug('BOMChildPriceMap'+BOMChildPriceMap);
        
        
    }
    
    
    
    //check if its bom product
    public static boolean isBOMProduct(Id productId,Map<Id,Map<Id,Decimal>> BOMParentChildMap)
    {
        if(BOMParentChildMap.containsKey(productId))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    //method for getting the standard price data
    public static map<id,map<string,decimal>> getstandardprice(){
        list<ivybase__Price_List_Entrie__c> pleList= new list<ivybase__Price_List_Entrie__c>();
        pleList=[select id,ivybase__Price_List__c,ivybase__Product__c,ivybase__UOM_1_Price__c,Type__c,ivybase__Active__c,ivybase__Price_List__r.ivybase__Is_Standard__c 
                 from ivybase__Price_List_Entrie__c where  ivybase__Price_List__r.ivybase__Is_Standard__c =True]; 
        map<id,map<string,decimal>> prdtypepriceMap= new map<id,map<string,decimal>>();
        for(ivybase__Price_List_Entrie__c pe:pleList){
            map<string,decimal> typeprc= new map<string,decimal>();
            typeprc.put(pe.Type__c,pe.ivybase__UOM_1_Price__c);
            prdtypepriceMap.put(pe.ivybase__Product__c,typeprc);
        }
        return prdtypepriceMap;
    }
    
    public static void getQuantityIfItsBOMProduct(Set<Id> BOM,Map<Id,Map<Id,Decimal>> BOMChildQuantity)
    {
        List<ivybase__Bill_Of_Material_SKU_Detail__c> skudetail = [select id,name, ivybase__Bill_Of_Material_SKU__c,ivybase__Bill_Of_Material_SKU__r.External_Code__c,ivybase__Product__r.External_Code__c, ivybase__Product__c,ivybase__Quantity__c  from ivybase__Bill_Of_Material_SKU_Detail__c where ivybase__Bill_Of_Material_SKU__c=:BOM];
        system.debug('skudetail'+skudetail);
        
        
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
        
        
    }
}