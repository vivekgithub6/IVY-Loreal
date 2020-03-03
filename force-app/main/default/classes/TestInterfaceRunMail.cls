@isTest
public class TestInterfaceRunMail {
    private static testMethod void testSendMail() {
        
        List<Interface_Run__c> interfaceRunList = new List<Interface_Run__c> {
            new Interface_Run__c (Name = 'PartnerFunction', Total_Rows__c = 3, File_Path__c = '', 
                                  Error_Message__c = 'test error', Market_ISO__c = 'PH'),
            new Interface_Run__c(Name = 'CustomerMaster', Total_Rows__c = 5, Error_Rows__c = 1, Processed_Rows__c = 5,
                                Rejected_Rows__c = 2, Market_ISO__c = 'SG')
        };
        insert interfaceRunList;
        /*InterfaceRunMail interrun=new InterfaceRunMail();
        interrun.IntefaceRunid=inter.Id;
        interrun.getInterfaceDetails();*/
        Test.startTest();
        System.schedule('Interface Run Email Schedule', '0 0 * * * ?', new InterfaceRunEmailScheduler());
        Test.stopTest();
    }
}