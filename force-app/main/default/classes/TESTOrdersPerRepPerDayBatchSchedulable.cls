@isTest
public class TESTOrdersPerRepPerDayBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        OrdersPerRepPerDayBatchSchedulable schedule = new OrdersPerRepPerDayBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}