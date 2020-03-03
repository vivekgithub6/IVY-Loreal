global class BatchCreatePricingAndDiscount implements Database.Batchable<sObject>{
    public Set<string> countryCode=new Set<string>() ;
    public BatchCreatePricingAndDiscount(set<String> code)
    {
        countryCode.addAll(code);
    }

   global Database.QueryLocator start(Database.BatchableContext BC){
      string query='Select Id,Name,Price_List__c,Sold_To_Party_Number__c,Market_ISO__c,CurrencyIsoCode from Account where Sold_To_Party_Number__c!=null and Market_ISO__c IN :countryCode';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        
        set<Id> accountIds = new Set<Id>();
        Account accountRecord=null;
        for(Account sc:scope){
            if(sc.Id != null)
                accountIds.add(sc.Id);
            accountRecord=sc;
        }
        try{
        //neglet the records with price as zero 
        List<Pricing_Stage_3__c> stage3List = [Select Name,Account__c,Division__c,Child_Product__c,Price__c,Pricing_Condition_Type__c,
                                               Product_Hierarchy__c,RelatedCustomerCode__c,Product__c,Valid_From_Date__c,Valid_To_Date__c,Market_ISO__c
                                               from Pricing_Stage_3__c where Account__c IN : accountIds and Price__c>0 ];
        system.debug('AllRecords '+stage3List.size());
        
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
        Map<String,Pricing_Stage_3__c> PricingrecordsOfHigherPriority = new Map<String,Pricing_Stage_3__c>();
        List<Pricing_Stage_3__c> Discountrecords = new List<Pricing_Stage_3__c>();
        for(Pricing_Stage_3__c p:stage3List)
        {
            if(codeAndDescMap.containsKey(p.Pricing_Condition_Type__c)==true && codeAndDescMap.get(p.Pricing_Condition_Type__c)=='Price')
            {
                if(PricingrecordsOfHigherPriority.containsKey(p.Division__c+'-'+p.Product_Hierarchy__c+'-'+p.Child_Product__c+'-'+p.Product__c))
                {
                    Pricing_Stage_3__c exisiting = PricingrecordsOfHigherPriority.get(p.Division__c+'-'+p.Product_Hierarchy__c+'-'+p.Child_Product__c+'-'+p.Product__c);
                    Decimal exisitingPriority = PricingCodeAndPriorityMap.get(exisiting.Pricing_Condition_Type__c);
                    Decimal CurrentPriority = PricingCodeAndPriorityMap.get(p.Pricing_Condition_Type__c);
                    system.debug('exisitingPriority'+exisitingPriority);
                    system.debug('CurrentPriority'+CurrentPriority);
                    if(CurrentPriority<=exisitingPriority)
                    {
                        PricingrecordsOfHigherPriority.put(p.Division__c+'-'+p.Product_Hierarchy__c+'-'+p.Child_Product__c+'-'+p.Product__c,p);  
                    }
                }
                else
                {
                    PricingrecordsOfHigherPriority.put(p.Division__c+'-'+p.Product_Hierarchy__c+'-'+p.Child_Product__c+'-'+p.Product__c,p); 
                }
            }
            if(codeAndDescMap.containsKey(p.Pricing_Condition_Type__c)==true && codeAndDescMap.get(p.Pricing_Condition_Type__c)=='Discount')
            {
                Discountrecords.add(p);
            }
            
        }
        
        List<Pricing_Stage_3__c> higherPriorityRecords = PricingrecordsOfHigherPriority.values();
        for(Pricing_Stage_3__c s:higherPriorityRecords)
        {
            system.debug('Prici'+s);
        }
        for(Pricing_Stage_3__c s:Discountrecords)
        {
            system.debug('Disc'+s);
        }
        
        
        CreatePricingAndDiscount.processStage3Records(higherPriorityRecords,Discountrecords,accountRecord);
        }
        catch(Exception e)
        {
           accountRecord.Remarks__c='Error:'+e.getCause()+''+e.getLineNumber()+'-'+e.getMessage()+'-'+e.getStackTraceString() ;
           update accountRecord;
        }
    }
    global void finish(Database.BatchableContext bc){
        
        /*LIST<String> templist = new LIST<String>{'TERYN SAK','YEO ALISIA'};
        BatchTempDiscount bc1= new BatchTempDiscount(new LIST<String>{'TERYN SAK','YEO ALISIA'});
		database.executebatch(bc1,2000);*/
        
        BatchTempDiscount bc1= new BatchTempDiscount('TERYN SAK');
		database.executebatch(bc1,2000);
        
        BatchTempDiscount bc2= new BatchTempDiscount('YEO ALISIA');
		database.executebatch(bc2,2000);
    }
    
    
}