@isTest
public class TESTVisitsPerRepPerDayBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        VisitsPerRepPerDayBatchSchedulable schedule = new VisitsPerRepPerDayBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}