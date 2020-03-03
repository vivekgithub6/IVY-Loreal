@isTest
public class TestBatchUpdatStoreINVDateOrdrValSched {
 public static testMethod void testCoverageSchedule(){
        Test.startTest();
        BatchUpdatStoreINVDateOrdrValSched schedule = new BatchUpdatStoreINVDateOrdrValSched();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }
}