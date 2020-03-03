@isTest
public class TestScheduleSalesKPITargetActual {
    public static testmethod void test1()
    {
        test.startTest();
        ScheduleBatchCreateSalesKPITargetActual sc = new ScheduleBatchCreateSalesKPITargetActual();
        String cronexpression = '0 0 6 1 * ? *';        
            String jobId = System.schedule('testing target actual', cronexpression,sc);
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                              FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(cronexpression, 
                                ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
        test.stopTest();
        
    }
}