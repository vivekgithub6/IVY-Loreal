@isTest
public class TESTReactivationRateBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        ReactivationRateBatchSchedulable schedule = new ReactivationRateBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}