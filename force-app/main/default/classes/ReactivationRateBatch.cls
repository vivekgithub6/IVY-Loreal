/*
 * Block comments with details of changes
 * last Modified by pranav on 2/12/2018 in  dev org
 */
global class ReactivationRateBatch implements Database.Batchable<sObject> 
{
      global Database.QueryLocator start(Database.BatchableContext bc){
          
      Integer month = date.Today().month();
        string query='Select id,Resource__c,Actual__c,Achievement__c,Parameter_type__c,Month__c from Target_Actual__c where Resource__c != null AND Parameter_type__c=\'Reactivation-rate\' AND Month__c ='+month+'';
          return Database.getQueryLocator(query);
    } 
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> targets){ 
         system.debug('targets'+targets);
        Date todayDate = date.Today();
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        date PreviousMonthtodate=Date.newInstance(todayDate.year(),todayDate.Month()-1,1);
        Integer numberOfDays = Date.daysInMonth(PreviousMonthtodate.year(), PreviousMonthtodate.month());
        Date lastDayOfMonth = Date.newInstance(PreviousMonthtodate.year(), PreviousMonthtodate.month(), numberOfDays);
  
         aggregateresult[] saloninvoice_MonthlyREActivation=[select count(Account__c) cnt,Resource__c from SaloonInvoice__c where  SecondLastInvoiceDate__c>=:PreviousMonthtodate AND SecondLastInvoiceDate__c<= :lastDayOfMonth AND LastInvoiceDate__c>=:Monthtodate AND LastInvoiceDate__c<=:todayDate group by Resource__c];
        Map<Id,Set<Account>> AllAccountResourceMap= AccountService.get_All_Retailer_For_All_Resource();
            
       System.debug('targets:: '+targets);
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(saloninvoice_MonthlyREActivation.size()>0){  
            for(AggregateResult agg:saloninvoice_MonthlyREActivation){
                if((id)agg.get('Resource__c')!=null){
                    if((decimal)agg.get('cnt')!=0 &&(decimal)agg.get('cnt')!=null ){
                        if(AllAccountResourceMap!=null && AllAccountResourceMap.containskey((id)agg.get('Resource__c')) && AllAccountResourceMap.get((id)agg.get('Resource__c'))!=null){
                            system.debug('invoice count'+(decimal)agg.get('cnt'));
                            system.debug('accounts size'+AllAccountResourceMap.get((id)agg.get('Resource__c')).size());
                        decimal actverate=((decimal)agg.get('cnt')/(AllAccountResourceMap.get((id)agg.get('Resource__c')).size()))*100;
                        resIdValueMap.put((id)agg.get('Resource__c'),actverate.setScale(2)); 
                        }
                    } 
                }
            }
        }
        for(Target_Actual__c targetactual:targets){
            if(resIdValueMap.keyset().contains(targetactual.Resource__c)){
                if(resIdValueMap.get(targetactual.Resource__c)!=null){
                 targetactual.Actual__c=resIdValueMap.get(targetactual.Resource__c);   
                }  
            }else{
                targetactual.Actual__c=0;
            }
        }
        update targets;
        
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ActiveListOfCustomersBatch') && vMapNameCustomSett.get('ActiveListOfCustomersBatch').SwitchOff__c==false){
         ActiveListOfCustomersBatch batch = new ActiveListOfCustomersBatch();
        Database.executeBatch(batch,1);  
        }  
    }
}