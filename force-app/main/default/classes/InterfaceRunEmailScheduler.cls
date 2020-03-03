global class InterfaceRunEmailScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
      InterfaceEmailBatch ieb = new InterfaceEmailBatch();
      database.executebatch(ieb);
   }
}