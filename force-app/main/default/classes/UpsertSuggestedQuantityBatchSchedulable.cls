global class UpsertSuggestedQuantityBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
      upsertSuggestedQuantityBatch batch = new upsertSuggestedQuantityBatch(); 
      database.executebatch(batch,10);
   }

}