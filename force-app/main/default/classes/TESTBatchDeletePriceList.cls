@isTest
public class TESTBatchDeletePriceList {
    private static testMethod void testDelPriceList(){
        
        String CountryCode='PH';
        ivybase__Price_List__c priceListTrue = TestUtility.createTestPriceList('Yes','Test PriceList True',Date.today(),Date.today().addDays(2));   
        priceListTrue.Market_ISO__c=CountryCode;
        insert priceListTrue;
        ivybase__Price_List__c priceListTrue2 = TestUtility.createTestPriceList('Yes','Test PriceList True1',Date.today(),Date.today().addDays(2));   
        priceListTrue2.Market_ISO__c=CountryCode;
        insert priceListTrue2;
        
        
       	
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(2));   
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        ivybase__Price_List__c priceList2 = TestUtility.createTestPriceList('Yes','Test PriceList2',Date.today(),Date.today().addDays(2));   
        priceList2.Market_ISO__c=CountryCode;
        insert priceList2;
        
        Test.startTest();
        Set<String> s= new set<String>();
        s.add(CountryCode);
        BatchDeletePriceList batch = new BatchDeletePriceList(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }

}