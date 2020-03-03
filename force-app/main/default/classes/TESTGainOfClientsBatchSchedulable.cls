@isTest
public class TESTGainOfClientsBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        GainOfClientsBatchSchedulable schedule = new GainOfClientsBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}