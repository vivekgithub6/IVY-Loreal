@isTest
public class TESTLossOfClientsBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        LossOfClientsBatchSchedulable schedule = new LossOfClientsBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}