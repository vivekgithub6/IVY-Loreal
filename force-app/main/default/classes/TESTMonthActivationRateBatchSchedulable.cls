@isTest
public class TESTMonthActivationRateBatchSchedulable {
    public static testMethod void testCoverageSchedule(){
        Test.startTest();
        MonthActivationRateBatchSchedulable schedule = new MonthActivationRateBatchSchedulable();
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }


}