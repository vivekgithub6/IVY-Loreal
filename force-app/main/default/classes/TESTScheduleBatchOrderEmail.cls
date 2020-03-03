@isTest
public class TESTScheduleBatchOrderEmail {
    public static testMethod void testBatchOrderEmailSchedule(){
        Test.startTest();
        ScheduleBatchOrderEmail schedule = new ScheduleBatchOrderEmail();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}