public with sharing class OrderLineItemTriggerhandler {
     public static void productLineItemValidation(list<ivydsd__Order_Line_Item__c> OLI)
    {
        Set<Id> orderId = new Set<Id>();
        Set<Id> ProductId = new Set<Id>();
        for(ivydsd__Order_Line_Item__c line:OLI)
        {
            orderId.add(line.ivydsd__Order__c);
            ProductId.add(line.ivydsd__Product1__c);
        }
        List<ivybase__Product__c> product = [select id,name,ivybase__Non_Saleable__c,Division__c  from ivybase__Product__c where id=:ProductId];
        Map<id,id> productDivision = new Map<Id,Id>();
        Map<id,boolean> productNonSalableMap = new Map<Id,boolean>();
        for(ivybase__Product__c p:product)
        {
            productDivision.put(p.id,p.Division__c);
            productNonSalableMap.put(p.id,p.ivybase__Non_Saleable__c);
        }
        List<ivydsd__Order__c> order = [select id,name,RecordType.DeveloperName, Division__c from ivydsd__Order__c where id=:orderId];
        Map<Id,String> OrderRecordTypeMap = new Map<Id,String>();
        Map<Id,Id> OrderDivisionMap = new Map<Id,String>();
        for(ivydsd__Order__c o:order)
        {
            OrderRecordTypeMap.put(o.id,o.RecordType.DeveloperName);
            OrderDivisionMap.put(o.id,o.Division__c);
        }
        for(ivydsd__Order_Line_Item__c line:OLI)
        {
            if(line.ivydsd__Product1__c!=null)
            {
                if(productDivision.containsKey(line.ivydsd__Product1__c)==true && productDivision.get(line.ivydsd__Product1__c)!=null && OrderDivisionMap.containsKey(line.ivydsd__Order__c)==true &&  OrderDivisionMap.get(line.ivydsd__Order__c)!=null)
                {
                    if(productDivision.get(line.ivydsd__Product1__c)!=OrderDivisionMap.get(line.ivydsd__Order__c))
                    {
                       line.addError('Unable To Create Product Under Different Division'); 
                    }
                }
                if(OrderRecordTypeMap.containsKey(line.ivydsd__Order__c)==true && OrderRecordTypeMap.get(line.ivydsd__Order__c)!=null && productNonSalableMap.containsKey(line.ivydsd__Product1__c)==true && productNonSalableMap.get(line.ivydsd__Product1__c)!=null)
                {
                    if(OrderRecordTypeMap.get(line.ivydsd__Order__c)=='POSM_Order')
                    {
                        if(productNonSalableMap.get(line.ivydsd__Product1__c)==false)
                        {
                         line.addError('Unable To Create Sellable Product In INSALON MATERIAL Order');    
                        }
                    }
                }
            }
            
        }
        
    }
        public static void PopulateLineItemNumber(list<ivydsd__Order_Line_Item__c> OLI)
        {
            Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'LineItemNumber_Deactive'});
            if(triggerLogicMap.get('LineItemNumber_Deactive') == Null || triggerLogicMap.get('LineItemNumber_Deactive') == true){
                
                Trigger_Logic_Configuration__c config = Trigger_Logic_Configuration__c.getInstance('LineItemNumber_Deactive');
                if(config!=null && config.UserName__c != null && userinfo.getUserName() != config.UserName__c){
                    set<id> OrderID = new set<id>();
                    for(ivydsd__Order_Line_Item__c O :OLI)
                    {
                        OrderID.add(O.ivydsd__Order__c);
                    }
                    list<ivydsd__Order_Line_Item__c> OLIExisting = [select id,name,ivydsd__Product1__c,ivydsd__Order__c,Item_Number__c from ivydsd__Order_Line_Item__c where ivydsd__Order__c=:OrderID];
                    map<id,decimal> NoOfOrderLineItemMap = new map<id,decimal>(); 
                    for(ivydsd__Order_Line_Item__c OLIE : OLIExisting)
                    {
                        if(NoOfOrderLineItemMap.containsKey(OLIE.ivydsd__Order__c) && OLIE.Item_Number__c!=null)
                        {
                            system.debug('in forst for loop ');
                            if(NoOfOrderLineItemMap.get(OLIE.ivydsd__Order__c) < OLIE.Item_Number__c)
                            {
                                NoOfOrderLineItemMap.put(OLIE.ivydsd__Order__c,(OLIE.Item_Number__c));
                            }
                        }
                        else if(NoOfOrderLineItemMap.containsKey(OLIE.ivydsd__Order__c) == false)
                        {
                            system.debug('in forst else if loop ');
                            NoOfOrderLineItemMap.put(OLIE.ivydsd__Order__c,10);
                        }
                    }
                    for(ivydsd__Order_Line_Item__c O : OLI)
                    {
                        system.debug('In loop');
                        if(NoOfOrderLineItemMap.containsKey(O.ivydsd__Order__c))
                        {
                            O.Item_Number__c = NoOfOrderLineItemMap.get(O.ivydsd__Order__c)+10;
                            NoOfOrderLineItemMap.put(O.ivydsd__Order__c,O.Item_Number__c);
                            system.debug(' O.Item_Number__c -->'+ O.Item_Number__c);
                        }
                        else
                        {
                            O.Item_Number__c=10;
                            NoOfOrderLineItemMap.put(O.ivydsd__Order__c,O.Item_Number__c);
                        }
                    }        
                }
            }
        }
        
    //wrapper class to store Rate and Discount of all child product
    public class RateAndDiscount
    {
        public String Calculation;
        public Decimal Rate;
        public Decimal Discount;
        public Decimal DtypeDiscount;
        public RateAndDiscount()
        {
            Rate=0;
            Discount=0;
            DtypeDiscount=0;
            Calculation='';
        }
    }
    //calculateBOM product RateAndDiscount
    public static RateAndDiscount calculateBOMRateAndDiscount(Map<Id,Map<Id,Decimal>> BOMParentChildMap,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap,Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap,Id AccountId,Id BOM,map<string,string> conditionmaps,Map<String,Decimal> PricingCodeAndPriorityMap,map<id,id> accountpriceidMap){
        RateAndDiscount finalValue= new RateAndDiscount();
        system.debug('its bom');
        if(BOMParentChildMap.containsKey(BOM))
        {
            //getting all the child under that product
            for(Id child:BOMParentChildMap.get(BOM).keyset())
            {
                Decimal rate=0;
                Decimal discount=0;
                Decimal DtypeDiscount=0;
                String Calculation='';
                Decimal QuantityForChild = BOMParentChildMap.get(BOM).get(child);
                //get child price 
                if(accountpriceidMap.containsKey(AccountId))
                {
                    Id priceList =accountpriceidMap.get(AccountId);
                    if(BOMChildPriceMap.containsKey(priceList))
                    {
                        if(BOMChildPriceMap.get(priceList).containsKey(BOM))
                        {
                            if(BOMChildPriceMap.get(priceList).get(BOM).containsKey(child))
                            {
                                Calculation+='Child Product-{'+child+'}';
                                map<string,decimal> typepriceMap = BOMChildPriceMap.get(priceList).get(BOM).get(child);
                                system.debug('typepriceMap'+typepriceMap);
                                boolean gotaMatch = false;
                                for(String tpe:typepriceMap.keyset())
                                {if(gotaMatch!=true){
                                    if(conditionmaps.containskey(tpe)){
                                        if(conditionmaps.get(tpe)=='C'){
                                            rate=typepriceMap.get(tpe)*(QuantityForChild!=null?QuantityForChild:1);
                                            system.debug('its c type price '+rate);
                                            Calculation+='-[Type C Rate'+rate+']';
                                            gotaMatch=true;
                                        }
                                        else if(conditionmaps.get(tpe)=='A')
                                        {
                                            gotaMatch=true;
                                            Decimal Discout=null;
                                            if(BOMChildDiscountMap!=null && BOMChildDiscountMap.containskey(AccountId) && BOMChildDiscountMap.get(AccountId).containskey(BOM)
                                               && BOMChildDiscountMap.get(AccountId).get(BOM).containsKey(child)){
                                                   map<string,decimal> DiscountTypeMap=BOMChildDiscountMap.get(AccountId).get(BOM).get(child);
                                                   if(DiscountTypeMap!=null){
                                                       for(string disctype:DiscountTypeMap.keyset()){
                                                           if(conditionmaps.containskey(disctype)){
                                                               if(conditionmaps.get(disctype)=='D'){
                                                                   String codeGroup = conditionmaps.get(disctype); 
                                                                   if(Discout==null)
                                                                   {
                                                                       Discout=DiscountTypeMap.get(disctype);
                                                                       Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                                   }else
                                                                   {
                                                                       Discout+=DiscountTypeMap.get(disctype);
                                                                       Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                                   }
                                                                   
                                                               }
                                                               
                                                           }
                                                       }
                                                   }
                                               }
                                            if(Discout!=null){
                                                system.debug('Its a-d combo');
                                                rate= typepriceMap.get(tpe)*(QuantityForChild!=null?QuantityForChild:1);
                                                Calculation+='-- Price Type A Rate['+rate+']';
                                                discount=((Discout==0)?0:(Discout)/100);
                                                
                                                system.debug('Its a-d rate '+rate);
                                                system.debug('Its a-d discount '+discount);
                                            }
                                            else
                                            {
                                                rate= typepriceMap.get(tpe)*(QuantityForChild!=null?QuantityForChild:1);
                                                system.debug('Its a-d rate '+rate);
                                                Calculation+='-- Price Type A Rate['+rate+']';
                                            }
                                        }
                                        else if(conditionmaps.get(tpe)=='base')
                                        {   gotaMatch=true;
                                         Decimal Discout=null;
                                         if(BOMChildDiscountMap!=null && BOMChildDiscountMap.containskey(AccountId) && BOMChildDiscountMap.get(AccountId).containskey(BOM)
                                            && BOMChildDiscountMap.get(AccountId).get(BOM).containsKey(child)){
                                                map<string,decimal> DiscountTypeMap=BOMChildDiscountMap.get(AccountId).get(BOM).get(child);
                                                if(DiscountTypeMap!=null){
                                                    for(string disctype:DiscountTypeMap.keyset()){
                                                        if(conditionmaps.containskey(disctype)){
                                                            if(conditionmaps.get(disctype)=='B'){
                                                                String codeGroup = conditionmaps.get(disctype); 
                                                                if(Discout==null)
                                                                {
                                                                    Discout=DiscountTypeMap.get(disctype);
                                                                    Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                                }else
                                                                {
                                                                    Discout+=DiscountTypeMap.get(disctype);
                                                                    Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                                }
                                                            }
                                                            if(conditionmaps.get(disctype)=='D'){
                                                                String codeGroup = conditionmaps.get(disctype); 
                                                                if(DtypeDiscount==0)
                                                                {
                                                                    DtypeDiscount=DiscountTypeMap.get(disctype);
                                                                    Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                                }else
                                                                {
                                                                    DtypeDiscount+=DiscountTypeMap.get(disctype);
                                                                    Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                         if(Discout!=null || DtypeDiscount!=0){
                                             
                                             rate= typepriceMap.get(tpe)*(QuantityForChild!=null?QuantityForChild:1);
                                             if(Discout!=null){
                                                 discount=((Discout==0)?0:(Discout)/100);
                                             }
                                             if(DtypeDiscount!=0){
                                                 DtypeDiscount=((DtypeDiscount==0)?0:(DtypeDiscount)/100); 
                                             }
                                             system.debug('Its YPRO-B rate '+rate);
                                             system.debug('Its YPRO-B discount '+discount);
                                             Calculation+='-- Price Type YPRO Rate['+rate+']';
                                             
                                         }
                                         else
                                         {
                                             rate= typepriceMap.get(tpe)*(QuantityForChild!=null?QuantityForChild:1);
                                             system.debug('Its YPRO-B rate '+rate);
                                             Calculation+='-- Price Type YPRO Rate['+rate+']';
                                         }
                                         
                                        }
                                    }
                                }   
                                }
                                //for loop type map ends
                            }
                        }
                    }
                }
                    Decimal preQuantityDiscount= rate*discount;
                    preQuantityDiscount=roundingUP2DecimalPlaces(preQuantityDiscount);
                    Decimal PerQuantityPrice=Rate-preQuantityDiscount;
                    PerQuantityPrice=roundingUP2DecimalPlaces(PerQuantityPrice);
                    Decimal perQuantityDDiscount=PerQuantityPrice*DtypeDiscount;
                    perQuantityDDiscount=roundingUP2DecimalPlaces(perQuantityDDiscount);
                    Decimal perQuantityFinalPrice= PerQuantityPrice-perQuantityDDiscount;
                    perQuantityFinalPrice=roundingUP2DecimalPlaces(perQuantityFinalPrice);
                
                finalValue.Rate+=(perQuantityFinalPrice==null?0:perQuantityFinalPrice);
                finalValue.Discount+=(preQuantityDiscount==null?0:preQuantityDiscount);
                finalValue.Calculation+=Calculation;
                finalValue.DtypeDiscount+=(perQuantityDDiscount==null?0:perQuantityDDiscount);
            }
        }
        system.debug('finalValue'+finalValue);
        
        return finalValue;
    }    
    public static void getlineitems(list<ivydsd__Order_Line_Item__c> olitemslist){
        
        
        List<PricingAndDiscountCode__mdt> PricingAndDiscountList =[select Code__c,Description__c,Ignore__c,Priority__c from PricingAndDiscountCode__mdt];
        Map<String,Decimal> PricingCodeAndPriorityMap = new Map<String,Decimal>();
        Map<String,String> codeAndDescMap = new Map<String,String>();
        for(PricingAndDiscountCode__mdt pdc:PricingAndDiscountList)
        {
            //if its marked as Ignore dont take it 
            if(pdc.Ignore__c)
            {
                
            }
            else
            {
                codeAndDescMap.put(pdc.Code__c,pdc.Description__c); 
                if(pdc.Priority__c!=null)
                {
                    PricingCodeAndPriorityMap.put(pdc.Code__c,pdc.Priority__c);
                }
            }
            
        }
        
        
        
        List<Pricing_Group__mdt> pricingGroup = [select id,DeveloperName,Grouping__c  from Pricing_Group__mdt];
        
        map<string,string> conditionmaps= new map<string,string>();
        for(Pricing_Group__mdt pg:pricingGroup)
        {
            if(pg.DeveloperName!=null && pg.Grouping__c!=null)
            {
                conditionmaps.put(pg.DeveloperName,pg.Grouping__c);
            }
        }
        /*conditionmaps.put('ZPNA','C');
        conditionmaps.put('ZPN2','C');
        conditionmaps.put('ZPNB','C');
        conditionmaps.put('ZSNP','A');
        conditionmaps.put('ZSN1','A');
        //discount
        conditionmaps.put('ZSA1','B');
        conditionmaps.put('ZSA2','B');
        conditionmaps.put('ZS03','B');
        conditionmaps.put('ZSAL','B');
        
        conditionmaps.put('ZPA1','D');
        conditionmaps.put('ZPA2','D');
        conditionmaps.put('YPXB','D');
        
        conditionmaps.put('YPR0','base'); */       
        set<id> ordid = new set<id>();//getting order id from the lineitem
        for(ivydsd__Order_Line_Item__c oli:olitemslist){
            ordid.add(oli.ivydsd__Order__c);
        }
        list<ivydsd__Order__c> ordlist = new list<ivydsd__Order__c>();
        if(ordid!=null && ordid.size()>0){
            //querying the order based on the ordid set 
            ordlist= [select id,ivydsd__Store__c,ivydsd__Store__r.recordtype.name from ivydsd__Order__c where id IN:ordid];
        }
        System.debug('ordlist:: '+ordlist);
        //iterating over the orders and creating a map for order and store ids
        map<id,id> orderStoreMap = new map<id,id>();
        if(ordlist!=null){
            for(ivydsd__Order__c ord:ordlist){
                orderStoreMap.put(ord.id,ord.ivydsd__Store__c);
            }   
        }
        System.debug('orderStoreMap:: '+orderStoreMap);
        //list<ivydsd__Order_Line_Item__c> olilist =[select id,ivydsd__Order__c,ivydsd__Order__r.ivydsd__Store__c,ivydsd__Product1__c from ivydsd__Order_Line_Item__c where ivydsd__Order__c IN:orderStoreMap.keySet()];
        //eg accprodIdMap=:<AccountId,Set<ProductId>>
        map<id,set<id>> accprodIdMap= new map<id,set<id>>();
        
        //iterating over a trigger.new lineitem list to form a accountid and set of productid Map
        for(ivydsd__Order_Line_Item__c olit:olitemslist){
            if(orderStoreMap!=null && orderStoreMap.containskey(olit.ivydsd__Order__c)){
                if(accprodIdMap.containskey(orderStoreMap.get(olit.ivydsd__Order__c))){
                    accprodIdMap.get(orderStoreMap.get(olit.ivydsd__Order__c)).add(olit.ivydsd__Product1__c);
                }
                else{
                    set<id> prdid = new set<id>();
                    prdid.add(olit.ivydsd__Product1__c);
                    accprodIdMap.put(orderStoreMap.get(olit.ivydsd__Order__c),prdid);  
                }
            }
        }
        
        //getting the picelistvalue prices when ever a price is taggged to account
        System.debug('accprodIdMap:: '+accprodIdMap);
        //creating map to strore BOM child Price value
        //eg BOMChildPriceMap=:<AccountRelatedPriceListId,<BOMProductId,<ChildProductId,<PriceCode,Price>>>>
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        //eg BOMChildDiscountMap=:<AccountId,<BOMProductId,<ChildProductId,<DiscountCode,Discount>>>>
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        //eg BOMParentChildMap=:<BOMProductId,<ChildProductId,Quantity>> //we get from Bill Of Material SKU 
        Map<Id,Map<Id,Decimal>> BOMParentChildMap = new Map<Id,Map<Id,Decimal>> ();
        //eg:accountpriceidMap <accountId,PricelistId>
        map<id,id> accountpriceidMap = new Map<Id,Id>();
        //eg:accountproductcashtypeMap <accountId<ProductId<PriceCode,Price>>>
        map<id,map<id,map<string,decimal>>> accountproductcashtypeMap= PricingConditions.getprice(accprodIdMap,BOMChildPriceMap,BOMParentChildMap,accountpriceidMap);
        
        system.debug('*******accountpriceidMap'+accountpriceidMap);
        system.debug('*****BOMChildPriceMap'+BOMParentChildMap);
        system.debug('*****BOMChildPriceMap'+BOMChildPriceMap);
        //getting the standard price
        //eg:productcashtypeMap <ProductId<PriceCode,Price>>
        map<id,map<string,decimal>> productcashtypeMap= PricingConditions.getstandardprice();
        //eg:accountproductcashtypeMap <accountId<ProductId<DiscountCode,Discount>>>
        map<id,map<id,map<string,decimal>>> DiscountMapForAccountProductType = DiscountClass.getAccountProductTypeValueMap(accprodIdMap,BOMChildDiscountMap);
        
        system.debug('accountproductcashtypeMap'+accountproductcashtypeMap);
        system.debug('DiscountMapForAccountProductType'+DiscountMapForAccountProductType);
        //this is for getting the products for checking the salable or non salable
        set<id> prodid= new set<id>();
        for(ivydsd__Order_Line_Item__c oli:olitemslist){
            prodid.add(oli.ivydsd__Product1__c);  
        }
        list<ivybase__Product__c> prodlist =[select id,ivybase__Non_Saleable__c from ivybase__Product__c where id IN:prodid];
        map<id,boolean> prductidsaleablemap= new map<id,boolean>();
        for(ivydsd__Order_Line_Item__c oli:olitemslist){
            prodid.add(oli.ivydsd__Product1__c);  
            if(oli.FreeProduct__c==true)
            { 
               prductidsaleablemap.put(oli.ivydsd__Product1__c,oli.FreeProduct__c); 
            }
        }
        for(ivybase__Product__c prd:prodlist){
            if(prd.ivybase__Non_Saleable__c==true){
            prductidsaleablemap.put(prd.id,prd.ivybase__Non_Saleable__c);
            }
        }
        //iterating over the  lineitem list and checking the map to get the price.
        for(ivydsd__Order_Line_Item__c oli:olitemslist){
            
            if(orderStoreMap!=null && orderStoreMap.containskey(oli.ivydsd__Order__c)){
                system.debug('BOMParentChildMap'+BOMParentChildMap);
                system.debug('oli.ivydsd__Product1__c'+oli.ivydsd__Product1__c);
                //if the product is BOM Product, 
                String Calculation='';
                if(prductidsaleablemap.containsKey(oli.ivydsd__Product1__c) && prductidsaleablemap.get(oli.ivydsd__Product1__c)==true)
                {
                   if(oli.FreeProduct__c!=true){
                    oli.ivydsd__UOM_1_Rate__c=null;
                    }
                    oli.ivydsd__DiscountAmount__c=null;
                    oli.Calculation__c='Its Non Salable Product or Promotion Free Product';
                }
                else if(BOMParentChildMap.containsKey(oli.ivydsd__Product1__c)){
                    system.debug('Its bom product');
                    RateAndDiscount t=calculateBOMRateAndDiscount(BOMParentChildMap,BOMChildPriceMap,BOMChildDiscountMap,orderStoreMap.get(oli.ivydsd__Order__c),oli.ivydsd__Product1__c,conditionmaps,PricingCodeAndPriorityMap,accountpriceidMap);
                    oli.ivydsd__UOM_1_Rate__c=t.Rate;
                    oli.ivydsd__DiscountAmount__c=t.Discount;
                    oli.Calculation__c=t.Calculation; 
                    if(t.DtypeDiscount!=0)
                    {
                        oli.ivydsd__DiscountAmount__c+=t.DtypeDiscount;
                    }
                }
                else if(accountproductcashtypeMap!=null && accountproductcashtypeMap.containskey(orderStoreMap.get(oli.ivydsd__Order__c)) && accountproductcashtypeMap.get(orderStoreMap.get(oli.ivydsd__Order__c)).containskey(oli.ivydsd__Product1__c))
                {
                    
                    Calculation+='Normal Product-{'+oli.ivydsd__Product1__c+'}';
                    system.debug('Its normal prodcut');
                    map<string,decimal> typepriceMap=accountproductcashtypeMap.get(orderStoreMap.get(oli.ivydsd__Order__c)).get(oli.ivydsd__Product1__c);        
                    boolean gotaMatch = false;
                    for(string tpe:typepriceMap.keyset()){
                        if(gotaMatch!=true){
                            if(conditionmaps.containskey(tpe)){
                                if(conditionmaps.get(tpe)=='C'){
                                    gotaMatch=true;
                                    oli.ivydsd__UOM_1_Rate__c= typepriceMap.get(tpe);
                                    system.debug('Its C rate '+oli.ivydsd__UOM_1_Rate__c);
                                    Calculation+='-[Type C Rate'+oli.ivydsd__UOM_1_Rate__c+']';
                                }
                                else if(conditionmaps.get(tpe)=='A')
                                {
                                    gotaMatch=true;
                                    Decimal Discout=null;
                                    if(DiscountMapForAccountProductType!=null && DiscountMapForAccountProductType.containskey(orderStoreMap.get(oli.ivydsd__Order__c)) && DiscountMapForAccountProductType.get(orderStoreMap.get(oli.ivydsd__Order__c)).containskey(oli.ivydsd__Product1__c)){
                                        map<string,decimal> DiscountTypeMap=DiscountMapForAccountProductType.get(orderStoreMap.get(oli.ivydsd__Order__c)).get(oli.ivydsd__Product1__c);      
                                        if(DiscountTypeMap!=null){
                                            
                                            for(string disctype:DiscountTypeMap.keyset()){
                                                if(conditionmaps.containskey(disctype)){
                                                    if(conditionmaps.get(disctype)=='D'){
                                                        system.debug('disctype'+disctype);
                                                        String codeGroup=conditionmaps.get(disctype);
                                                        if(Discout==null)
                                                        {
                                                            
                                                            Discout=DiscountTypeMap.get(disctype);
                                                            Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                        }else
                                                        {
                                                            
                                                            Discout+=DiscountTypeMap.get(disctype);
                                                            Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                        }
                                                        system.debug('Discout'+Discout);
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    if(Discout!=null){
                                        Decimal preQuantityDiscount= typepriceMap.get(tpe)*(Discout/100);
                                        preQuantityDiscount=roundingUP2DecimalPlaces(preQuantityDiscount);
                                        Decimal PerQuantityPrice=typepriceMap.get(tpe)-preQuantityDiscount;
                                        PerQuantityPrice=roundingUP2DecimalPlaces(PerQuantityPrice);
                                        oli.ivydsd__UOM_1_Rate__c=PerQuantityPrice;
                                        oli.ivydsd__DiscountAmount__c=((Discout==0)?0:(oli.ivydsd__UOM_1_Rate__c*oli.ivydsd__UOM_1_Quantity__c*Discout)/100);
                                        Calculation+='-- Price Type A Rate['+typepriceMap.get(tpe)+']';
                                        Calculation+='-- Discount Amount ['+oli.ivydsd__DiscountAmount__c+']';
                                    }
                                    else
                                    {
                                        oli.ivydsd__UOM_1_Rate__c= typepriceMap.get(tpe);  
                                        Calculation+='-- Price Type A Rate['+oli.ivydsd__UOM_1_Rate__c+']';
                                    }
                                }
                            }
                        }}
                    oli.Calculation__c=Calculation;  
                }
                //checking for assinging the standard price value to the order
                else if(productcashtypeMap!=null && productcashtypeMap.containskey(oli.ivydsd__Product1__c)){
                    Calculation+='Normal Product-{'+oli.ivydsd__Product1__c+'}';
                    map<string,decimal> typestdprce=productcashtypeMap.get(oli.ivydsd__Product1__c);
                    for(string tpe:typestdprce.keyset()){
                        if(conditionmaps.containskey(tpe)){
                            if(conditionmaps.get(tpe)=='base'){
                                Decimal NegativeDiscount=null;
                                Decimal Discout=null;
                                Decimal DtypeDiscount=null;
                                if(DiscountMapForAccountProductType!=null && DiscountMapForAccountProductType.containskey(orderStoreMap.get(oli.ivydsd__Order__c)) && DiscountMapForAccountProductType.get(orderStoreMap.get(oli.ivydsd__Order__c)).containskey(oli.ivydsd__Product1__c)){
                                    map<string,decimal> DiscountTypeMap=DiscountMapForAccountProductType.get(orderStoreMap.get(oli.ivydsd__Order__c)).get(oli.ivydsd__Product1__c);      
                                    if(DiscountTypeMap!=null){
                                        
                                        for(string disctype:DiscountTypeMap.keyset()){
                                            if(conditionmaps.containskey(disctype)){
                                                if(conditionmaps.get(disctype)=='Z'){
                                                    String codeGroup=conditionmaps.get(disctype);
                                                    if(NegativeDiscount==null)
                                                    {
                                                        
                                                        NegativeDiscount=DiscountTypeMap.get(disctype);
                                                        Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                    }else
                                                    {
                                                        NegativeDiscount+=DiscountTypeMap.get(disctype);
                                                        Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                    }
                                                    system.debug('Discout'+NegativeDiscount);
                                                    system.debug('disctype'+disctype);
                                                }
                                                if(conditionmaps.get(disctype)=='B'){
                                                    String codeGroup=conditionmaps.get(disctype);
                                                    if(Discout==null)
                                                    {
                                                        
                                                        Discout=DiscountTypeMap.get(disctype);
                                                        Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                    }else
                                                    {
                                                        Discout+=DiscountTypeMap.get(disctype);
                                                        Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                    }
                                                    system.debug('Discout'+Discout);
                                                    system.debug('disctype'+disctype);
                                                }
                                                if( conditionmaps.get(disctype)=='D'){
                                                    String codeGroup=conditionmaps.get(disctype);
                                                    if(DtypeDiscount==null)
                                                    {
                                                        
                                                        DtypeDiscount=DiscountTypeMap.get(disctype);
                                                        Calculation+='-- Discount Rate -{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                    }else
                                                    {
                                                        DtypeDiscount+=DiscountTypeMap.get(disctype);
                                                        Calculation+='+{'+codeGroup+'-'+DiscountTypeMap.get(disctype)+'-}';
                                                    }
                                                    system.debug('Discout'+DtypeDiscount);
                                                    system.debug('disctype'+disctype);
                                                }
                                            }
                                        }
                                    }
                                }
                                if(NegativeDiscount!=null)
                                {
                                    Decimal PerQuantityNegativeDiscount = typestdprce.get(tpe)*(NegativeDiscount/100);
                                    PerQuantityNegativeDiscount=roundingUP2DecimalPlaces(PerQuantityNegativeDiscount);
                                    Decimal PerQuantityPrice=typestdprce.get(tpe)+PerQuantityNegativeDiscount;
                                    Calculation+='-- Negative Amount ['+PerQuantityNegativeDiscount+']';
                                    if(Discout!=null)
                                    {
                                       Decimal preQuantityBDiscount= PerQuantityPrice*(Discout/100);
                                       preQuantityBDiscount=roundingUP2DecimalPlaces(preQuantityBDiscount);
                                       PerQuantityPrice=PerQuantityPrice-preQuantityBDiscount;
                                        Calculation+='-- Discount Amount B-['+preQuantityBDiscount+']';
                                    }
                                    if(DtypeDiscount!=null)
                                    {
                                        Decimal perQuantityDDiscount=PerQuantityPrice*(DtypeDiscount/100);
                                        
                                        perQuantityDDiscount=roundingUP2DecimalPlaces(perQuantityDDiscount);
                                        Calculation+='-- Discount Amount D-['+perQuantityDDiscount+']';
                                        PerQuantityPrice= PerQuantityPrice-perQuantityDDiscount;
                                    }
                                    PerQuantityPrice=roundingUP2DecimalPlaces(PerQuantityPrice);
                                    oli.ivydsd__UOM_1_Rate__c=PerQuantityPrice;
                                    
                                    if(Discout!=null)
                                    {
                                        oli.ivydsd__DiscountAmount__c=((Discout==0)?0:(oli.ivydsd__UOM_1_Rate__c*oli.ivydsd__UOM_1_Quantity__c*Discout)/100);
                                    }
                                    if(DtypeDiscount!=null)
                                    {
                                        oli.ivydsd__DiscountAmount__c=(((oli.ivydsd__UOM_1_Rate__c*oli.ivydsd__UOM_1_Quantity__c)-oli.ivydsd__DiscountAmount__c)*DtypeDiscount/100);
                                    }
                                    
                                    Calculation+='-- Price Type YPRO Rate['+typestdprce.get(tpe)+']';
                                    
                                }
                                else if(NegativeDiscount==null && Discout!=null){
                                    Decimal preQuantityDiscount= typestdprce.get(tpe)*(Discout/100);
                                    preQuantityDiscount=roundingUP2DecimalPlaces(preQuantityDiscount);
                                    Decimal PerQuantityPrice=typestdprce.get(tpe)-preQuantityDiscount;
                                    if(DtypeDiscount!=null){
                                        Decimal perQuantityDDiscount=PerQuantityPrice*(DtypeDiscount/100);
                                        
                                        perQuantityDDiscount=roundingUP2DecimalPlaces(perQuantityDDiscount);
                                        Decimal perQuantityFinalPrice= PerQuantityPrice-perQuantityDDiscount;
                                        
                                        perQuantityFinalPrice=roundingUP2DecimalPlaces(perQuantityFinalPrice);
                                        oli.ivydsd__UOM_1_Rate__c=perQuantityFinalPrice;
                                    }
                                    else
                                    {
                                        PerQuantityPrice=roundingUP2DecimalPlaces(PerQuantityPrice);
                                        oli.ivydsd__UOM_1_Rate__c=PerQuantityPrice;
                                        
                                    }
                                    //oli.ivydsd__UOM_1_Rate__c= typestdprce.get(tpe);
                                    oli.ivydsd__DiscountAmount__c=((Discout==0)?0:(oli.ivydsd__UOM_1_Rate__c*oli.ivydsd__UOM_1_Quantity__c*Discout)/100);
                                    system.debug('after applying B oli.ivydsd__DiscountAmount__c'+oli.ivydsd__DiscountAmount__c);
                                    if(DtypeDiscount!=null)
                                    {
                                        oli.ivydsd__DiscountAmount__c=(((oli.ivydsd__UOM_1_Rate__c*oli.ivydsd__UOM_1_Quantity__c)-oli.ivydsd__DiscountAmount__c)*DtypeDiscount/100);
                                    }
                                    system.debug('Its YPRO-B D rate '+oli.ivydsd__UOM_1_Rate__c);
                                    system.debug('Its YPRO-B D discount '+oli.ivydsd__DiscountAmount__c);
                                    Calculation+='-- Price Type YPRO Rate['+typestdprce.get(tpe)+']';
                                    Calculation+='-- Discount Amount ['+oli.ivydsd__DiscountAmount__c+']';
                                    
                                }
                                else if(Discout==null &&DtypeDiscount!=null)
                                {
                                    Decimal preQuantityDiscount= typestdprce.get(tpe)*(DtypeDiscount/100);
                                    
                                    preQuantityDiscount=roundingUP2DecimalPlaces(preQuantityDiscount);
                                    Decimal PerQuantityPrice=typestdprce.get(tpe)-preQuantityDiscount;
                                    
                                    PerQuantityPrice=roundingUP2DecimalPlaces(PerQuantityPrice);
                                    oli.ivydsd__UOM_1_Rate__c=PerQuantityPrice;
                                    
                                    oli.ivydsd__UOM_1_Rate__c= typestdprce.get(tpe);
                                    oli.ivydsd__DiscountAmount__c=((Discout==0)?0:(oli.ivydsd__UOM_1_Rate__c*oli.ivydsd__UOM_1_Quantity__c*DtypeDiscount)/100);
                                    system.debug('Its YPRO-B D rate '+oli.ivydsd__UOM_1_Rate__c);
                                    system.debug('Its YPRO-B D discount '+oli.ivydsd__DiscountAmount__c);
                                    Calculation+='-- Price Type YPRO Rate['+typestdprce.get(tpe)+']';
                                    Calculation+='-- Discount Amount ['+oli.ivydsd__DiscountAmount__c+']';
                                }
                                else
                                {
                                    oli.ivydsd__UOM_1_Rate__c= typestdprce.get(tpe); 
                                    system.debug('Its YPRO-B rate '+oli.ivydsd__UOM_1_Rate__c);
                                    Calculation+='-- Price Type YPRO Rate['+typestdprce.get(tpe)+']';
                                }
                            }//base ends 
                        }
                    }
                    oli.Calculation__c=Calculation; 
                    
                }
                // oli.ivydsd__UOM_1_Rate__c=  
            }
            
        }
        
    }
    public static Decimal roundingUP2DecimalPlaces(Decimal a)
    {
        Decimal n;        
        n=a.scale();
        if(n>10)
        {
            n=10;
        }
        Integer ns=Integer.valueOf(n);
        for(integer i=ns;i>=2;i--)
        {
            a=a.setScale(i, RoundingMode.HALF_UP);
        }
        system.debug(a);
        
        
        return a;
    }
    public static void getdiscount(list<ivydsd__Order_Line_Item__c> olitemslist){
        /*try{
            set<id> OrderId=new set<id>();
            list<ivydsd__Order__c> updateOrdrs=new list<ivydsd__Order__c>();
            
            for(ivydsd__Order_Line_Item__c o:olitemslist){
                OrderId.add(o.ivydsd__Order__c);
            }       
            list<ivydsd__Order__c> Orders=[select id,ivydsd__DiscountAmount__c,name,ivydsd__Store__c from ivydsd__Order__c where id in:OrderId];
            system.debug('Orders'+Orders);
            //This map will be used while iterating over aggregate result and order record will get updated
            map<id,ivydsd__Order__c> OrderMap=new  map<id,ivydsd__Order__c>();        
            for(ivydsd__Order__c Order:Orders){
                Order.ivydsd__DiscountAmount__c=0;
                OrderMap.put(Order.id, Order);
            }
            
            //getting aggregate of LineTotal  field from all the records with grouping by parent
            AggregateResult[] groupedResults = [select sum(ivydsd__DiscountAmount__c)Amt,ivydsd__Order__c from ivydsd__Order_Line_Item__c  where ivydsd__Order__c in:OrderMap.keyset() group by ivydsd__Order__c];        
            if(groupedResults.size()>0){
                //iterating over the aggregate result and fetching the LineTotal aggregate value and assigning it to GrandTotal  in Order record
                Decimal d= (Decimal)groupedResults[0].get('Amt');
                for(AggregateResult ar : groupedResults){          
                    if( (string)ar.get('ivydsd__Order__c')!=Null){
                        system.debug('entering');
                        OrderMap.get((string)ar.get('ivydsd__Order__c')).ivydsd__DiscountAmount__c+=  (Decimal)ar.get('Amt');
                        
                    }
                } 
                
            }
            //in delete all, records scenario, no records will come, so setting the amount paid value to zero
            else{
                for(ivydsd__Order__c order:Orders){
                    order.ivydsd__DiscountAmount__c=0;
                    updateOrdrs.add(order);
                }
                
            }  
            //end of roll up
            system.debug('OrderMap'+OrderMap);
            //updating
            Database.update(OrderMap.values(), false);
            if(updateOrdrs.size()>0)
                Database.update(updateOrdrs, false);
            //updatoing ended            
        }
        Catch(Exception e){
        }  */
    }
    
    
    public static void populatePONumber(list<ivydsd__Order_Line_Item__c> olitemslist){
        Set<Id> proIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Map<Id,String> orderNumberMap = new Map<Id,String>();
        Map<Id,String> prodNumberMap = new Map<Id,String>();
        
        for(ivydsd__Order_Line_Item__c ordLine :olitemslist){
            if(ordLine.ivydsd__Order__c != null)
                orderIds.add(ordLine.ivydsd__Order__c);
           /* if(ordLine.ivydsd__Product1__c != null)
                proIds.add(ordLine.ivydsd__Product1__c);
            */
        }
        List<ivydsd__Order__c> orders = [Select Id,Purchase_Order_Number__c,Name from ivydsd__Order__c where Id IN : orderIds];
        for(ivydsd__Order__c order : orders)
        {
            if(order.Purchase_Order_Number__c!=null)
            {
              orderNumberMap.put(order.Id, order.Purchase_Order_Number__c);  
            }else
            {
               orderNumberMap.put(order.Id, order.name);   
            }
            
        }
            
       
       /* List<ivybase__Product__c> products = [Select Id,External_Code__c from ivybase__Product__c where Id IN : proIds AND External_Code__c!=null];
        for(ivybase__Product__c prod : products)
            prodNumberMap.put(prod.Id, prod.External_Code__c);
        */
        for(ivydsd__Order_Line_Item__c ordLine :olitemslist){
            if(ordLine.ivydsd__Order__c != null && ordLine.Item_Number__c != null){
                if(orderNumberMap.containsKey(ordLine.ivydsd__Order__c) )
                    ordLine.Orderlineitem_Extcode__c = orderNumberMap.get(ordLine.ivydsd__Order__c)+ ordLine.Item_Number__c ;
            		system.debug('**ExternaID'+ordLine.Orderlineitem_Extcode__c);
            }
        }
        
    }
    
}