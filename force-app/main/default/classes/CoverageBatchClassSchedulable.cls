global class CoverageBatchClassSchedulable implements Schedulable {
   global void execute(SchedulableContext sc) {
      CoverageBatchClass b = new CoverageBatchClass(); 
      database.executebatch(b);
   }
}