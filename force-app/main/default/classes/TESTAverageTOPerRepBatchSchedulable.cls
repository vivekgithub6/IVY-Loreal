@isTest
public class TESTAverageTOPerRepBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        AverageTurnoverPerRepBatchSchedulable schedule = new AverageTurnoverPerRepBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}