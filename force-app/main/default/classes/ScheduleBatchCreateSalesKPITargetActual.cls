public class ScheduleBatchCreateSalesKPITargetActual implements Schedulable{
    public void execute(SchedulableContext ctx) 
    {
        BatchCreateSalesKPITargetActual saleskpi = new BatchCreateSalesKPITargetActual();
        database.executeBatch(saleskpi);
}
}