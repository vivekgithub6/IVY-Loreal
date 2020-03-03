@isTest
public class TESTScheduleBatchContactEmail {
    public static testMethod void testBatchContactEmailSchedule(){
        Test.startTest();
        ScheduleBatchContactEmail schedule = new ScheduleBatchContactEmail();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}