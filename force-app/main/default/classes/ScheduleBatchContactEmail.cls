public with sharing class ScheduleBatchContactEmail implements Schedulable
{
    public void execute(SchedulableContext ctx) 
    {
        BatchContactEmail tb= new BatchContactEmail();
        database.executeBatch(tb);
    }
}