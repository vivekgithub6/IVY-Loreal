/**
 * This test class is used to cover the codes of the BatchDeleteDiscountMaster, BatchDeletePricingStage2, BatchDeletePricingStage3, DeletePricingStageScheduler
     Class codes
*/
@isTest
public class TESTDeletePricingStageScheduler {
    
    public static testMethod void deletePricingStages() {
    
        inserPricingStages('PH');
        inserPricingStages('MY');
        inserPricingStages('SG');
        
        Test.startTest();
        System.schedule('Test Scheduler', '0 0 0 * * ?', new DeletePricingStageScheduler(new Set<String>{'PH', 'SG', 'MY'}));
        Test.stopTest();
    }
    
    public static void inserPricingStages(String CountryCode) {
    
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/UPMAT/PMATN',Variable_Key__c='232/2323/32/1/123456789B/123456789BD');
        insert pricing;
        
        Pricing_Stage_2__c p = new Pricing_Stage_2__c();
        p.Parent_stage_record__c = pricing.Id;
        p.Market_ISO__c=countryCode;
        insert p;
        
        Pricing_Stage_3__c p1 = new Pricing_Stage_3__c();
        p1.Pricing_Stage_2__c = p.Id;
        p1.Market_ISO__c=countryCode;
        insert p1;
    }
}