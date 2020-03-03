@isTest
public class TestInterfaceRunTrigger {
    private static testMethod void testOrdersInSAP(){
        Contact c=new Contact();
        c.lastName='Loreal';
        c.Email='loreal@gmail.com';
        insert c;
        Interface_Run__c i=new Interface_Run__c();
        i.Processed_Rows__c=10;
        i.Name='Context';
        i.Error_Rows__c=20;
        i.Rejected_Rows__c=30;
        i.Market_ISO__c = 'MY';
        Interface_Run__c i2=new Interface_Run__c();
        i2.Processed_Rows__c=10;
        i2.Name='Context';
        i2.Error_Rows__c=20;
        i2.Rejected_Rows__c=30;
        i2.Market_ISO__c = 'MY';
        list<Interface_Run__c> runs = new list<Interface_Run__c>();
        runs.add(i);runs.add(i2);
        insert runs;
        
        
    }
}