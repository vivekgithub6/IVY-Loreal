global class ActivationCoverageBatch implements Database.Batchable<AggregateResult> ,Database.stateful {
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        System.debug('query start');
        string query='select count(Account__c) cnt,Resource__c from SaloonInvoice__c where  LastInvoiceDate__c>= '+mtdate+' AND LastInvoiceDate__c<= '+tdydate +' group by Resource__c';
        //string query='select count(id) cnt,ivydsd__Resource__c from ivydsd__Invoice__c where  ivydsd__Store__r.LastInvoiceDate__c>= '+mtdate+' AND ivydsd__Store__r.LastInvoiceDate__c<= '+tdydate +' group by ivydsd__Resource__c';
        System.debug('query:'+query);
        return new AggregateResultIterable(query);
    } 
    global void execute(Database.BatchableContext bc, List<AggregateResult> InvoiceList){ 
        system.debug('OrdersSFA'+InvoiceList);
      List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c,Year__c,Month__c,Parameter_type__c from Target_Actual__c 
                                         where  Month__c=:date.today().month() AND Year__c=:date.today().year()
                                         AND recordtype.developername='Activation' AND Market_ISO__c='PH'];
        
        Map<Id,Set<Account>> AllAccountResourceMap= AccountService.get_All_Retailer_For_All_Resource();
      //  AccountService.getAllRetailerMaster_List_for_Resource
            
       System.debug('targets:: '+targets);
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(InvoiceList.size()>0){  
            for(AggregateResult agg:InvoiceList){
                if((id)agg.get('Resource__c')!=null){
                    if((decimal)agg.get('cnt')!=0 &&(decimal)agg.get('cnt')!=null ){
                        if(AllAccountResourceMap.containskey((id)agg.get('Resource__c')) && AllAccountResourceMap.get((id)agg.get('Resource__c'))!=null && AllAccountResourceMap.get((id)agg.get('Resource__c')).size()>0){
                            system.debug('invoice count'+(decimal)agg.get('cnt'));
                            //system.debug('accounts size'+AccountService.getAllRetailerMaster_List_for_Resource((id)agg.get('Resource__c')).size());
                        decimal actverate=((decimal)agg.get('cnt')/AllAccountResourceMap.get((id)agg.get('Resource__c')).size())*100;
                        resIdValueMap.put((id)agg.get('Resource__c'),actverate.setScale(2)); 
                        }
                    } 
                }
            }
        }
        system.debug('resIdValueMap'+resIdValueMap);
        for(Target_Actual__c targetactual:targets){
            if(resIdValueMap.keyset().contains(targetactual.Resource__c)){
                if(resIdValueMap.get(targetactual.Resource__c)!=null){
                 targetactual.Actual__c=resIdValueMap.get(targetactual.Resource__c);   
                }  
            }else{
                targetactual.Actual__c=0;
            }
        }
        system.debug('targets'+targets);
        update targets;
        
    }
    global void finish(Database.BatchableContext bc){ 
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('Conquest_Target_Batch') && vMapNameCustomSett.get('Conquest_Target_Batch').SwitchOff__c==false){
           Conquest_Target_Batch batch = new Conquest_Target_Batch();
        database.executeBatch(batch); 
        }
       
    }
}