/*
 * Block comments with details of changes
 */

//process one record at a time
global class SalesTargetMidMonthCal implements Database.Batchable<sObject>{
    Map<String,Decimal> invoiceMap = new Map<String,Decimal>();
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Target_Actual__c,Resource__c,Mid_Month_Achievement__c,Actual__c,Sales_Recovery_Value__c,Sales_Recovery__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Parameter_type__c=\'Mid Month\' AND recordType.DeveloperName=\'Sales_Target\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){ 
		 id targetactualid;
         id incentivegroupid;
        List<Target_Actual__c> updatedTargets = new List<Target_Actual__c>();
        list<AggregateResult> groupedResults = new list<AggregateResult>();
        if(scope.size()>0){
            incentivegroupid=scope[0].Incentive_Group__c;
            groupedResults = [Select SUM(Total_Amount__c) sum,ivydsd__Resource__c from ivydsd__Invoice__c 
                              where ivydsd__Resource__c != null AND ivydsd__Resource__c =:scope[0].Resource__c
                              AND ivydsd__Invoice_Date__c >=: scope[0].Start_Date1__c AND ivydsd__Invoice_Date__c <=:scope[0].End_Date1__c
                              Group By ivydsd__Resource__c];
       //querying incentive slab based on the target actual incentive group assigned to resource.
        list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
        
        for(AggregateResult result : groupedResults){
            invoiceMap.put((String)result.get('ivydsd__Resource__c'), (Decimal)result.get('sum'));
            System.debug('invoiceMap::: '+invoiceMap);
        }
            if(scope[0].Target_Actual__c!=null){
            targetactualid=scope[0].Target_Actual__c;
            }
            
           List<Target_Actual__c> Parentincentive= [select id,name,Achievement__c from Target_Actual__c where id=:targetactualid ];
            if(Parentincentive.size()>0 && Parentincentive[0].Achievement__c!=null && Parentincentive[0].Achievement__c >0){
            for(Target_Actual__c target:scope){
                target.Actual__c = invoiceMap.get(target.Resource__c); 
                decimal achievepercent=(invoiceMap.get(target.Resource__c)/target.Target__c)*100;
                target.Achievement__c=getincnetive(incentiveslab,achievepercent);
                updatedTargets.add(target);
            }
            }
            if(updatedTargets.size()>0){
                update updatedTargets;
            } 
        }
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ConquestBatch_MY') && vMapNameCustomSett.get('ConquestBatch_MY').SwitchOff__c==false){
         ConquestBatch_MY CBMY= new ConquestBatch_MY();
        database.executeBatch(CBMY,1);  
        }
		
    }
   public static decimal getincnetive(list<Incentive_Slab__c> incntveslab, decimal ordersum){
        
        System.debug('incntveslab====>'+incntveslab);
        System.debug('ordersum====>'+ordersum);
        decimal incentive=0;
        for(Incentive_Slab__c slab : incntveslab){
            if(slab.Minimum__c<=ordersum){
                if(slab.Incentive__c!=null && slab.Incentive__c>incentive){
                    incentive= slab.Incentive__c; 
                }
            }   
        }
        system.debug('incentive'+incentive);
        return incentive;
    }
   
}