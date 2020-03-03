@isTest
public class TESTCoverageBatchClassSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        CoverageBatchClassSchedulable schedule = new CoverageBatchClassSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}