global class PricingMasterStage3Batch implements Database.Batchable<sObject>{
    public Set<string> countryCode=new Set<string>() ;
    public PricingMasterStage3Batch(set<String> code) {
        countryCode.addAll(code);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query='SELECT Id,Market_ISO__c,CurrencyIsoCode FROM Account WHERE  Sold_To_Party_Number__c!=null and Market_ISO__c IN :countryCode';
        return Database.getQueryLocator(query);
    }

    global voId execute(Database.BatchableContext bc, List<Account> scope) {
        List<Pricing_Stage_3__c> stage3List = new List<Pricing_Stage_3__c>();
        Id accountId = null;
        set<Id> accountIds = new Set<Id>();
        Set<Id> storeIds = new Set<Id>();
        for(Account sc:scope) {
            if(sc.Id != null) {
                accountIds.add(sc.Id);
            }
            accountId=sc.Id;
        }
        //get all the parent store hierarchy relate to this account 
        List<StoreDivisionMapping__c> storeMap = [SELECT Account__c,Store_Hierarchy__c,Store_Hierarchy__r.ivybase__Parent__c,
                                                  Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c,
                                                  Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                                  FROM StoreDivisionMapping__c WHERE  Account__c IN : accountIds
                                                 ];
        for(StoreDivisionMapping__c store : storeMap){
            if(store.Store_Hierarchy__c != null)
                storeIds.add(store.Store_Hierarchy__c);
            if(store.Store_Hierarchy__r.ivybase__Parent__c != null)
                storeIds.add(store.Store_Hierarchy__r.ivybase__Parent__c);
            if(store.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c != null)
                storeIds.add(store.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c);
            if(store.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null)
                storeIds.add(store.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
        }
        //get all stage 2 records related to this account and parent store hierarchy
        List<Pricing_Stage_2__c> stage2List = [SELECT Name, Account__c, Child_Product_Master__c, Price__c, Pricing_Condition_Type__c,
                                               Product_Hierarchy__c, Division__c, RelatedCustomerCode__c, Product_Master__c,
                                               Store_Hierarchy__c, ValId_From_Date__c, ValId_To_Date__c, Market_ISO__c, CurrencyIsoCode
                                               FROM Pricing_Stage_2__c WHERE  (Account__c IN : accountIds OR Store_Hierarchy__c IN : storeIds 
                                               OR (Account__c = null AND Store_Hierarchy__c = null AND Pricing_Condition_Type__c!='YPR0'))
                                               AND ((Product_Hierarchy__c != null AND Product_Hierarchy__r.ivybase__Active__c = 'Yes')
                                                OR (Product_Master__c != null AND Product_Master__r.ivybase__Active__c = 'Yes' AND 
                                                Product_Master__r.ivybase__Non_Saleable__c = false AND Product_Master__r.ivybase__Is_Competitor__c = false)
                                                OR (Child_Product_Master__c != null AND Child_Product_Master__r.ivybase__Active__c = 'Yes' AND 
                                                Child_Product_Master__r.ivybase__Non_Saleable__c = false AND Child_Product_Master__r.ivybase__Is_Competitor__c = false))
                                               ORDER BY Pricing_Condition_Type__c ASC ];
        //custom meta data to get code priority
        List<Variable_key_Priority__mdt> CodePriority =[SELECT Variable_Key__c,Priority__c,Pricing_Code__c FROM Variable_key_Priority__mdt];
        Map<String,Map<String,Decimal>> CustomerCodeAndPriorityMap = new Map<String,Map<String,Decimal>>();
        for(Variable_key_Priority__mdt pdc:CodePriority) {
            String pricingCode=pdc.Pricing_Code__c.trim();
            String VariableKey=pdc.Variable_Key__c.trim();
            //if its marked as Ignore
            
            if(pdc.Priority__c!=null) {
                if(CustomerCodeAndPriorityMap.containsKey(pricingCode)) {
                    CustomerCodeAndPriorityMap.get(pricingCode).put(VariableKey,pdc.Priority__c);
                }
                else {
                    Map<String,Decimal> KeyPriority = new Map<String,Decimal>();
                    KeyPriority.put(VariableKey,pdc.Priority__c);
                    CustomerCodeAndPriorityMap.put(pricingCode,KeyPriority);
                }   
            }   
        }
        Map<String,Pricing_Stage_2__c> recordsOfHigherCustomerPriority = new Map<String,Pricing_Stage_2__c>();
        for(Pricing_Stage_2__c p:stage2List) {

            if(recordsOfHigherCustomerPriority.containsKey(p.Product_Hierarchy__c+'-'+p.Division__c+'-'+p.Child_Product_Master__c+'-'+p.Product_Master__c+'-'+p.Pricing_Condition_Type__c)) {
                Pricing_Stage_2__c exisiting = recordsOfHigherCustomerPriority.get(p.Product_Hierarchy__c+'-'+p.Division__c+'-'+p.Child_Product_Master__c+'-'+p.Product_Master__c+'-'+p.Pricing_Condition_Type__c);
                if(CustomerCodeAndPriorityMap.containsKey(p.Pricing_Condition_Type__c)) {
                    Decimal exisitingPriority = CustomerCodeAndPriorityMap.get(p.Pricing_Condition_Type__c).get(exisiting.RelatedCustomerCode__c);
                    Decimal CurrentPriority = CustomerCodeAndPriorityMap.get(p.Pricing_Condition_Type__c).get(p.RelatedCustomerCode__c);
                    system.debug('exisitingPriority'+exisitingPriority);
                    system.debug('CurrentPriority'+CurrentPriority);
                    if(CurrentPriority!=null && exisitingPriority!=null && CurrentPriority<=exisitingPriority) {
                        recordsOfHigherCustomerPriority.put(p.Product_Hierarchy__c+'-'+p.Division__c+'-'+p.Child_Product_Master__c+'-'+p.Product_Master__c+'-'+p.Pricing_Condition_Type__c,p);  
                    }
                }
            }
            else{
                recordsOfHigherCustomerPriority.put(p.Product_Hierarchy__c+'-'+p.Division__c+'-'+p.Child_Product_Master__c+'-'+p.Product_Master__c+'-'+p.Pricing_Condition_Type__c,p); 
            }
        }
        List<Pricing_Stage_2__c> higherPriorityRecords = recordsOfHigherCustomerPriority.values();
        
        for(Pricing_Stage_2__c stage2 : higherPriorityRecords){
            stage3List.add(PricingMapToSFAccount.getEntityMappedRecord(stage2,accountId));
        }
        insert stage3List;
    }
    global voId finish(Database.BatchableContext bc) { 
        BatchCreatePricingAndDiscount batch = new BatchCreatePricingAndDiscount(CountryCode);
        Database.executeBatch(batch,1);
    }
}