@isTest
public class TESTOrdersInSFABatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        OrdersInSFABatchSchedulable schedule = new OrdersInSFABatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}