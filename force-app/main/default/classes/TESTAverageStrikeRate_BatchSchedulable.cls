@isTest
public class TESTAverageStrikeRate_BatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        AverageStrikeRate_BatchSchedulable schedule = new AverageStrikeRate_BatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}