@isTest
public class TestBatchPopulateFieldInObject {
    private static testMethod void testDelDiscount(){
        
        
        Map<List<String>,List<String>> a = new Map<List<String>,List<String>>();
        List<String> aStr = new List<String>();
        aStr.add('234');        
        List<String> bStr = new List<String>();
        bStr.add('3434');        
        a.put(aStr,bStr);
        Map<string,String> sd = new Map<String,String>();
        Map<string,String> gh = new Map<String,String>();
        List<Map<string,String>> aMap = new List<Map<String,String>>();
        sd.put('d','e');
        sd.put('e','f');
        sd.put('g','j');
        gh.put('d','e');
        gh.put('e','f');
        gh.put('g','j');
        aMap.add(sd);
        aMap.add(gh);
        system.debug('aMap'+aMap);
        
        
        List<Division__c> div = new List<Division__c>();
        for(Integer i=0;i<10;i++)
        {
            Division__c dtemp=TestUtility.createdivision(''+i);
            dtemp.Market_ISO__c=null;
            div.add(dtemp);
        }
        insert div;
        Test.startTest();
        
        BatchPopulateFieldInObject batch = new BatchPopulateFieldInObject('Division__c','Market_ISO__c','PH');
        Database.executeBatch(batch);
        Test.stopTest();
        List<Division__c> divs = [select id,name,Market_ISO__c from Division__c];
        for(Division__c d:divs)
        {
            system.debug('d'+d);
        }
        
    }
    
}