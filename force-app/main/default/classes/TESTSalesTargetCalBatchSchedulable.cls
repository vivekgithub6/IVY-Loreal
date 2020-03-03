@isTest
public class TESTSalesTargetCalBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        SalesTargetCalculatingBatchSchedulable schedule = new SalesTargetCalculatingBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}