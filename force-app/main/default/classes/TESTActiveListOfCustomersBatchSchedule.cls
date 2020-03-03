@isTest
public class TESTActiveListOfCustomersBatchSchedule {
    public static testMethod void testActiveListOfCustomers(){
        Test.startTest();
        ActiveListOfCustomersBatchSchedule schedule = new ActiveListOfCustomersBatchSchedule();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}