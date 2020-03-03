@isTest
public class TESTScheduleJobAfterInterfaceRun {
    public static testMethod void testActiveListOfCustomers(){
        Test.startTest();
         Set<string> countryCode=new Set<string>() ;
    		countryCode.add('PH');
        ScheduleJobAfterInterfaceRun schedule = new ScheduleJobAfterInterfaceRun(countryCode);
        String schedule1 = '0 0 0 1 * ?';
        System.schedule('test', schedule1, schedule);
        Test.stopTest();
    }

}