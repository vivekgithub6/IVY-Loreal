/*
* Block comments with details of changes
*/
global class ConquestCalculationBatch_SG implements Database.Batchable<sObject>{
    Date todayDate = date.Today();
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Mid_Month_Achievement__c,Product_Group__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null  AND Parameter_type__c=\'Conquest monthly\' AND recordType.DeveloperName=\'Conquest\' ';//AND Market_ISO__c=\'SG\'
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        id incentivegroupid;
        List<Target_Actual__c> updatetalist= new List<Target_Actual__c>();
        list<AggregateResult> groupedResults = new list<AggregateResult>();
        //Coverage_CalculationFromLastYear.makeCalculationForCoverage(scope);  
        if(scope.size()>0){
            incentivegroupid=scope[0].Incentive_Group__c;
            //querying conquest accounts and related to resource (select id,ivydsd__Order_Date__c, from ivydsd__orders__r ORDER by ivydsd__Order_Date__c ASC Limit 1 )
            list<account>  Accountlist=[select id,ivybase__Resource__c,Converted_Date__c,(select id,ivydsd__Invoice_Amount__c,ivydsd__Invoice_Date__c from ivydsd__Invoice__r ORDER by ivydsd__Invoice_Date__c ASC Limit 1 ) from Account where Converted_Date__c!=Null and Converted_to_Normal_Saloon__c=true and ivybase__Resource__c =:scope[0].Resource__c];
            system.debug('Accountlist'+Accountlist);
            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
            /*********************
1) Check the account related 1st order placed the is lies between the target actual strt and end date.take all saloons satiesfied this conditions.
2)And take invoices realated to that saloon, take all the invoices lies between the target actual strt and end date

********************************/
            date AcccriteriaDate;
            set<id> satisfiedAccidsforThisMonth= new set<id>();
            /* for(Account acc:Accountlist){
AcccriteriaDate=acc.Converted_Date__c.adddays(30);
if(scope[0].Start_Date1__c <= AcccriteriaDate && scope[0].End_Date1__c>=AcccriteriaDate){
satisfiedAccidsforThisMonth.add(acc.id);
}
}*/
       List<Account_Target__c>   exisitingAccount= new  List<Account_Target__c> ();    
      List<Account_Target__c> AccountCaptured = [select id,Account__c,Target_Actual__c from Account_Target__c where Target_Actual__c=:scope[0].id];
            for(Account_Target__c acc:AccountCaptured)
            {
                exisitingAccount.add(acc);  
               // accountoftotalcounttilldate.add(acc.Account__c);
            }
            delete exisitingAccount;
            
            Map<id,decimal> accountFirstInvoiceValue = new Map<id,decimal>();
            if(Accountlist.size()>0){
                for(Account acc:Accountlist){
                    if(acc.ivydsd__Invoice__r.size()>0){
                        for(ivydsd__Invoice__c ord:acc.ivydsd__Invoice__r){
                            if(ord.ivydsd__Invoice_Date__c >= scope[0].Start_Date1__c && ord.ivydsd__Invoice_Date__c<=scope[0].End_Date1__c){
                                satisfiedAccidsforThisMonth.add(acc.id);
                                    accountFirstInvoiceValue.put(acc.id,ord.ivydsd__Invoice_Amount__c);
                            }
                        }    
                    }
                }
            }
            system.debug('satisfiedAccidsforThisMonth'+satisfiedAccidsforThisMonth);
            system.debug('accountFirstInvoiceValue'+accountFirstInvoiceValue);
            list<account> Accountwithinvoices= new list<account>();
            if(satisfiedAccidsforThisMonth.size()>0){
            Accountwithinvoices=[select id,Converted_Date__c,
                                               (select id,ivydsd__Invoice_Amount__c,ivydsd__Invoice_Date__c,ivydsd__Resource__c from ivydsd__Invoice__r where ivydsd__Invoice_Date__c >=: scope[0].Start_Date1__c AND ivydsd__Invoice_Date__c<=:scope[0].End_Date1__c)
                                               from account where id iN:satisfiedAccidsforThisMonth];
            }
            date Accconvdate30days;
            map<id,decimal> accountinvsum= new map<id,decimal>();
            if( Accountwithinvoices.size()>0){
                for(account ac:Accountwithinvoices){
                    system.debug('Acccid'+ac.id+' ac '+ac);
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
            system.debug('accountinvsum'+accountinvsum);
            //updatin the target actual records
            List<Account_Target__c> Accountcoveredupdate= new list<Account_Target__c>();
            for(Target_Actual__c Talist:scope){
                talist.Actual__c=0;
                talist.Achievement__c=0;
                
                if(accountinvsum!=null ){//&& accountFirstInvoiceValue!=null
                    for(Id account:accountinvsum.keyset()){
                        decimal firstinvoiceincentive=0;
                        //if(satisfiedAccidsforThisMonth.size()>0)  talist.Target__c=satisfiedAccidsforThisMonth.size();
                        //else talist.Target__c=0;
                        //if(accountFirstInvoiceValue.containskey(account) && accountFirstInvoiceValue.get(account)!=null){
                          /* firstinvoiceincentive=getincnetive(incentiveslab,accountFirstInvoiceValue.get(account));
                           if(firstinvoiceincentive!=null && firstinvoiceincentive>0){
                           talist.Actual__c+=accountinvsum.get(account);
                            talist.Achievement__c+=getincnetive(incentiveslab,accountFirstInvoiceValue.get(account));   
                              Account_Target__c Accounttarget1=new Account_Target__c();
                            Accounttarget1.Account__c=account;
                            Accounttarget1.Target_Actual__c=Talist.id;
                            Accounttarget1.Name='Incentive earned ='+getincnetive(incentiveslab,accountFirstInvoiceValue.get(account));
                           Accountcoveredupdate.add(Accounttarget1);
                           }*/
                        //}
                       // else{
                        talist.Actual__c+=accountinvsum.get(account);
                        talist.Achievement__c+=getincnetive(incentiveslab,accountinvsum.get(account));
                            Account_Target__c Accounttarget1=new Account_Target__c();
                            Accounttarget1.Account__c=account;
                            Accounttarget1.Target_Actual__c=Talist.id;
                            Accounttarget1.Name='Incentive earned ='+getincnetive(incentiveslab,accountinvsum.get(account));
                        Accountcoveredupdate.add(Accounttarget1);
                        //}
                    }
                    updatetalist.add(talist);
                }
            }
            if(Accountcoveredupdate.size()>0){
               insert Accountcoveredupdate;
            }
            if(updatetalist.size()>0) {
                
                update updatetalist;
            }
            /*groupedResults = [Select SUM(ivydsd__Invoice_Amount__c) sum,ivydsd__Resource__c,ivydsd__Store__c from ivydsd__Invoice__c 
where ivydsd__Resource__c != null AND ivydsd__Resource__c =:scope[0].Resource__c
AND ivydsd__Invoice_Date__c >=: 	ivydsd__Store__r.Converted_Date__c AND ivydsd__Invoice_Date__c <=:ivydsd__Store__r.Converted_Date__c.adddays(30) AND ivydsd__Store__c IN:satisfiedAccidsforThisMonth
Group By ivydsd__Resource__c,ivydsd__Store__c];*/
        }//scope ends
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('KeyBetsCalculation_batch') && vMapNameCustomSett.get('KeyBetsCalculation_batch').SwitchOff__c==false){
          KeyBetsCalculation_batch keyb= new KeyBetsCalculation_batch();
        database.executebatch(keyb,1);  
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