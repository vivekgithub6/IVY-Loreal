/*
 * Block comments with details of changes
 * last Modified by pranav on 2/12/2018 on dev org
 */
global class LossOfClientsBatch implements Database.Batchable<sObject> 
{
      global Database.QueryLocator start(Database.BatchableContext bc){
          
      Integer month = date.Today().month();
        string query='Select id,Resource__c,Actual__c,Achievement__c,Parameter_type__c,Month__c from Target_Actual__c where Resource__c != null AND Parameter_type__c=\'Loss of Clients\' AND Month__c ='+month+'';
          return Database.getQueryLocator(query);
    } 
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> targets){ 
         system.debug('targets'+targets);
        Date todayDate = date.Today();
        date past_12Mth_Date= todayDate.addMonths(-12);
     Aggregateresult [] saloninvoice_Loss=[select count(Account__c) cnt,Resource__c from SaloonInvoice__c where LastInvoiceDate__c < :past_12Mth_Date group by Resource__c];
        Map<Id,Set<Account>> AllAccountResourceMap= AccountService.get_All_Retailer_For_All_Resource();
            
       System.debug('targets:: '+targets);
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(saloninvoice_Loss.size()>0){  
            for(AggregateResult agg:saloninvoice_Loss){
                if((id)agg.get('Resource__c')!=null){
                    if((decimal)agg.get('cnt')!=0 &&(decimal)agg.get('cnt')!=null ){
                        if(AllAccountResourceMap!=null && AllAccountResourceMap.containskey((id)agg.get('Resource__c')) && AllAccountResourceMap.get((id)agg.get('Resource__c'))!=null){
                            system.debug('invoice count'+(decimal)agg.get('cnt'));
                            system.debug('accounts size'+AllAccountResourceMap.get((id)agg.get('Resource__c')).size());
                        decimal actverate=(decimal)agg.get('cnt');//(AllAccountResourceMap.get((id)agg.get('Resource__c')).size());
                            resIdValueMap.put((id)agg.get('Resource__c'),actverate); 
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
        if(vMapNameCustomSett.containsKey('AverageStrikeRate_Batch') && vMapNameCustomSett.get('AverageStrikeRate_Batch').SwitchOff__c==false){
          AverageStrikeRate_Batch batch = new AverageStrikeRate_Batch();
        Database.executeBatch(batch); 
        }
        
    }
}