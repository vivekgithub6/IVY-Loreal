global class BatchUpdatStoreINVDateOrdrValSched implements Schedulable{
global void execute(SchedulableContext sc) {
      BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource(); 
      database.executebatch(b,1);
   }
}