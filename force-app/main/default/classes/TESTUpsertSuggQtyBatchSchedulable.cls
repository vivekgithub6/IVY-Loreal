@isTest
public class TESTUpsertSuggQtyBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        UpsertSuggestedQuantityBatchSchedulable schedule = new UpsertSuggestedQuantityBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}