public with sharing class PricingMapToSFAccount {
    public static Pricing_Stage_3__c getEntityMappedRecord(Pricing_Stage_2__c record,Id accountId){
        Pricing_Stage_3__c stage3 = new Pricing_Stage_3__c();
        stage3.Account__c=accountId;
        stage3.Child_Product__c = record.Child_Product_Master__c;
        stage3.Price__c = record.Price__c;
        stage3.Pricing_Condition_Type__c = record.Pricing_Condition_Type__c;
        stage3.Product__c = record.Product_Master__c;
        stage3.Product_Hierarchy__c = record.Product_Hierarchy__c;
        stage3.Valid_From_Date__c = record.Valid_From_Date__c;
        stage3.Valid_To_Date__c = record.Valid_To_Date__c;
        stage3.Pricing_Stage_2__c=record.id;
        stage3.Division__c=record.Division__c;
        stage3.RelatedCustomerCode__c=record.RelatedCustomerCode__c;
        stage3.Market_ISO__c =record.Market_ISO__c;
        return stage3;
    } 
    
}