/*
 * Block comments with details of changes
 */
global class ConquestCalculationSemister_SG implements Database.Batchable<sObject>{
    Date todayDate = date.Today();
    global Database.QueryLocator start(Database.BatchableContext bc){

        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Mid_Month_Achievement__c,Account__c,Product_Group__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Market_ISO__c=\'SG\' AND Parameter_type__c=\'Conquest Semester\' AND recordType.DeveloperName=\'Conquest\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        id incentivegroupid;
        List<Target_Actual__c> updatetalist= new List<Target_Actual__c>();
        list<AggregateResult> groupedResults = new list<AggregateResult>();
        id accid;
        //Coverage_CalculationFromLastYear.makeCalculationForCoverage(scope);  
        if(scope.size()>0){
            if(scope[0].Account__c!=null){
               accid= scope[0].Account__c;
            }
            incentivegroupid=scope[0].Incentive_Group__c;
            
            //querying conquest accounts and related to resource
           // list<account>  Accountlist=[select id,ivybase__Resource__c,Converted_Date__c from Account where Converted_Date__c!=Null and Converted_to_Normal_Saloon__c=true and ivybase__Resource__c =:scope[0].Resource__c];

            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
            /*********************
            1) Check the account connverted date is lies between the target actual strt and end date.take all saloons satiesfied this conditions.
            2)And take invoices realated to that saloon, take all the invoices lies between start date and end date.

            ********************************/
            date AcccriteriaDate;
            set<id> satisfiedAccidsforThisMonth= new set<id>();
            /* for(Account acc:Accountlist){
                AcccriteriaDate=acc.Converted_Date__c.adddays(30);
                if(scope[0].Start_Date1__c <= AcccriteriaDate && scope[0].End_Date1__c>=AcccriteriaDate){
                    satisfiedAccidsforThisMonth.add(acc.id);
                }
            }*/
            date startdate=scope[0].Start_Date1__c;
            date enddate=scope[0].End_Date1__c;
           /* for(Account acc:Accountlist){
                if(scope[0].Start_Date1__c <= acc.Converted_Date__c && scope[0].End_Date1__c>=acc.Converted_Date__c){
                    satisfiedAccidsforThisMonth.add(acc.id);
                }
            }*/
			
            list<account> Accountwithinvoices=[select id,Converted_Date__c,
                                               (select id,ivydsd__Invoice_Amount__c,ivydsd__Invoice_Date__c,ivydsd__Resource__c from ivydsd__Invoice__r where ivydsd__Invoice_Date__c >=:startdate AND ivydsd__Invoice_Date__c<=:enddate)
                                               from account where id =:accid];
            date Accconvdate30days;
            map<id,decimal> accountinvsum= new map<id,decimal>();
            if( Accountwithinvoices.size()>0){
                for(account ac:Accountwithinvoices){
                    // Accconvdate30days=ac.Converted_Date__c.adddays(30);
                    decimal Sum=0;
                    if(ac.ivydsd__Invoice__r.size()>0){
                        for(ivydsd__Invoice__c inv:ac.ivydsd__Invoice__r){
                            if(inv.ivydsd__Invoice_Date__c >= scope[0].Start_Date1__c && inv.ivydsd__Invoice_Date__c<=scope[0].End_Date1__c){
                                Sum=sum+inv.ivydsd__Invoice_Amount__c;
                            }
                        }
                    }
                    accountinvsum.put(ac.id,Sum); 
                }
            }

            //updatin the target actual records
            for(Target_Actual__c Talist:scope){
                talist.Actual__c=0;
                talist.Achievement__c=0;
                if(accountinvsum!=null){
                    for(Id account:accountinvsum.keyset()){
                       // if(satisfiedAccidsforThisMonth.size()>0)  talist.Target__c=satisfiedAccidsforThisMonth.size();
                       // else talist.Target__c=0;
                        talist.Actual__c+=accountinvsum.get(account);
                        talist.Achievement__c+=getincnetive(incentiveslab,accountinvsum.get(account));
                    }
                    updatetalist.add(talist);
                }
            }
            if(updatetalist.size()>0) {

                update updatetalist;
            }
            /*groupedResults = [Select SUM(ivydsd__Invoice_Amount__c) sum,ivydsd__Resource__c,ivydsd__Store__c from ivydsd__Invoice__c 
                                  where ivydsd__Resource__c != null AND ivydsd__Resource__c =:scope[0].Resource__c
                                  AND ivydsd__Invoice_Date__c >=: ivydsd__Store__r.Converted_Date__c AND ivydsd__Invoice_Date__c <=:ivydsd__Store__r.Converted_Date__c.adddays(30) AND ivydsd__Store__c IN:satisfiedAccidsforThisMonth
                                  Group By ivydsd__Resource__c,ivydsd__Store__c];*/
        }//scope ends
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ConquestCalculationBatch_SG') && vMapNameCustomSett.get('ConquestCalculationBatch_SG').SwitchOff__c==false){
            ConquestCalculationBatch_SG CCM= new ConquestCalculationBatch_SG();
        database.executeBatch(CCM,1);
        }
   
    }

    public static decimal getincnetive(list<Incentive_Slab__c> incntveslab, decimal ordersum){

        System.debug('incntveslab====>'+incntveslab);
        System.debug('ordersum====>'+ordersum);
        decimal incentive=0;
        for(Incentive_Slab__c slab : incntveslab){
            if(slab.Minimum__c<=ordersum){
                if(slab.Incentive__c!=null && slab.Incentive__c>incentive){
                    system.debug(incentive+'inside if condition'+slab.Incentive__c);
                    incentive= slab.Incentive__c; 
                    system.debug(incentive+'inside if condition'+slab.Incentive__c);
                }
            }   
        }
        system.debug('incentive'+incentive);
        return incentive;
    }

}