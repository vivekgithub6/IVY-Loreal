@isTest
public class TESTAverageTOPerClientBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        AverageTurnOverPerClientBatchSchedulable schedule = new AverageTurnOverPerClientBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}