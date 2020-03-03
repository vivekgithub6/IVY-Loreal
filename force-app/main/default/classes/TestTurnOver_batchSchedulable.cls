@isTest
public class TestTurnOver_batchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        TurnOver_BatchSchedulable schedule = new TurnOver_BatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}