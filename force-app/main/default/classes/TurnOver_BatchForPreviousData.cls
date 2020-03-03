// Batch Job for Processing the Records
global class TurnOver_BatchForPreviousData implements Database.Batchable<sobject> {
  global integer year;
    global integer month;
    global TurnOver_BatchForPreviousData(integer year,integer month){
       this.year= year;
        this.month=month;
    }
  
   // Start Method
   global Database.Querylocator start (Database.BatchableContext BC) {
      return Database.getQueryLocator('Select id from Account');
      
   }
   
   // Execute method
   global void execute (Database.BatchableContext BC, List<sobject> scope) {
       system.debug('year'+year);
    // CreateTurnOverRecords.createTurnOversFOrPreviousData(scope,month,year);
   }
   
   // Finish Method
   global void finish(Database.BatchableContext BC) {
     
}
}