global class AverageStrikeRate_BatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
      AverageStrikeRate_Batch b = new AverageStrikeRate_Batch(); 
      database.executebatch(b);
   }
}