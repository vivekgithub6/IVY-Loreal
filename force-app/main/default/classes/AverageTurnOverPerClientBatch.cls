global class AverageTurnOverPerClientBatch implements Database.Batchable<AggregateResult> ,Database.stateful {
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        system.debug('todayDate'+todayDate);
        system.debug('Monthtodate'+Monthtodate);//2018-09-01
        string query='select count(id) cnt,SUM(ivydsd__Invoice_Amount__c) invoicevalue,ivydsd__Resource__c from ivydsd__Invoice__c where ivydsd__Invoice_Date__c>= ' +mtdate+ ' AND ivydsd__Invoice_Date__c<= '+tdydate+'  group by ivydsd__Resource__c';
       //'
        return new AggregateResultIterable(query);
    } 
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<AggregateResult> visitsbyreprecs){ 
       system.debug('visitsbyreprecs'+visitsbyreprecs);
        
        
        
        date todayDate= date.today();
        date strtdate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        
        List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c,Parameter_type__c,Month__c from Target_Actual__c 
                                         where  Month__c=:date.today().month() AND year__c= :date.today().year() 
                                         AND Parameter_type__c='Average turnover per salon'];
        system.debug('targets'+targets);
        
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(visitsbyreprecs.size()>0){  
            for(AggregateResult agg:visitsbyreprecs){
                if((id)agg.get('ivydsd__Resource__c')!=null){
                    resIdValueMap.put((id)agg.get('ivydsd__Resource__c'),(decimal)agg.get('invoicevalue')); 
                }
            }
        }   
       Map<Id,Set<Account>> AllAccountResourceMap= AccountService.get_All_Retailer_For_All_Resource();
        
        //system.debug('AllAccountResourceMap'+AllAccountResourceMap);  
       
        for(Target_Actual__c targetactual:targets){
            //system.debug('accounts size'+AllAccountResourceMap.get(targetactual.Resource__c));
            //system.debug('accounts size'+AllAccountResourceMap.get(targetactual.Resource__c).size());
            System.debug('resIdValueMap::'+resIdValueMap);
            //AccountService.getAllRetailerMaster_List_for_Resource((id)agg.get('Resource__c')).size()>0
            if(resIdValueMap.keyset().contains(targetactual.Resource__c) &&  AllAccountResourceMap!=null && AllAccountResourceMap.containsKey(targetactual.Resource__c) ){ //AccountService.getAllRetailerMaster_List_for_Resource(targetactual.Resource__c).size()>0
                if(resIdValueMap.get(targetactual.Resource__c)!=null && resIdValueMap.get(targetactual.Resource__c)!=0 &&  AllAccountResourceMap.get(targetactual.Resource__c)!=null ){
                    //system.debug('accounts size'+AccountService.getAllRetailerMaster_List_for_Resource(targetactual.Resource__c).size());
                    decimal tarActual=(resIdValueMap.get(targetactual.Resource__c))/(AllAccountResourceMap.get(targetactual.Resource__c).size());
                    system.debug('tarActual'+tarActual);
                    targetactual.Actual__c=  tarActual.setScale(2);
                }
            }
        }
        system.debug('targets'+targets);
        update targets;
    }
   
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('MonthActivationRateBatch') && vMapNameCustomSett.get('MonthActivationRateBatch').SwitchOff__c==false){
             MonthActivationRateBatch batch = new MonthActivationRateBatch();
        Database.executeBatch(batch); 
        }
 
    }
}