@isTest
public class TESTQuantityBatchClassSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        QuantityBatchClassSchedulable schedule = new QuantityBatchClassSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}