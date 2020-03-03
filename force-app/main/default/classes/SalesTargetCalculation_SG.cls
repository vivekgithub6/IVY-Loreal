/*
 * Block comments with details of changes
 */

global class SalesTargetCalculation_SG implements Database.Batchable<sObject>{
    Map<String,Decimal> invoiceMap = new Map<String,Decimal>();
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Mid_Month_Achievement__c,Actual__c,Actual_Currency__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Market_ISO__c=\'SG\' AND Parameter_type__c=\'TurnOver Incentive\' AND recordType.DeveloperName=\'Sales_Target\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){ 
        System.debug('execute targets:: '+scope);
        List<Target_Actual__c> updatedTargets = new List<Target_Actual__c>();
        Date todayDate = Date.today();
        date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        date PreviousMonthtodate=Date.newInstance(todayDate.year(),todayDate.Month()-1,1);
        Integer numberOfDays = Date.daysInMonth(PreviousMonthtodate.year(), PreviousMonthtodate.month());
        Date lastDayOfMonth = Date.newInstance(PreviousMonthtodate.year(), PreviousMonthtodate.month(), numberOfDays);
        id incentivegroupid;
        list<AggregateResult> groupedResults = new list<AggregateResult>();
        map<id,decimal> invoiceMap= new map<id,decimal>();
        //ivydsd__Invoice_Date__c
        if(scope.size()>0){
            incentivegroupid=scope[0].Incentive_Group__c;
            groupedResults = [Select SUM(Total_Amount__c) sum, ivydsd__Resource__c from ivydsd__Invoice__c 
                              where ivydsd__Resource__c != null AND ivydsd__Resource__c =:scope[0].Resource__c
                              AND ivydsd__Invoice_Date__c >=: scope[0].Start_Date1__c AND ivydsd__Invoice_Date__c <=:scope[0].End_Date1__c
                              Group By ivydsd__Resource__c];
        }
        System.debug('groupedResults::: '+groupedResults);
        for(AggregateResult agg:groupedResults){
            if((decimal)agg.get('sum')!=null){
            invoiceMap.put((id)agg.get('ivydsd__Resource__c'),(decimal)agg.get('sum'));
                }
        }

        //querying incentive slab based on the target actual incentive group assigned to resource.
        list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c,IsPercentage__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];

         for(Target_Actual__c target : scope){
            if(target.Actual__c != null && target.Market_ISO__c.equalsignorecase('SG') && invoiceMap.containskey(target.Resource__c) && invoiceMap.get(target.Resource__c)!=Null){
                decimal actual=invoiceMap.get(target.Resource__c); 
                target.Actual__c = invoiceMap.get(target.Resource__c); 
                target.Actual_Currency__c=invoiceMap.get(target.Resource__c);
                target.CurrencyIsoCode = 'SGD';
                decimal achievepercent=(invoiceMap.get(target.Resource__c)/target.Target__c)*100;
                system.debug('incentiveslab'+incentiveslab);
                system.debug('achievepercent'+achievepercent);
                system.debug('target'+target.Target__c);
                system.debug('actual'+actual);
                target.Achievement__c=getincnetive(incentiveslab,achievepercent,target.Target__c,actual);
                updatedTargets.add(target);
            }
         }
        if(updatedTargets.size()>0){
        update updatedTargets;
        }
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('SGCoverageBatch') && vMapNameCustomSett.get('SGCoverageBatch').SwitchOff__c==false){
          SGCoverageBatch sgc= new SGCoverageBatch();
      database.executeBatch(sgc,1);  
        }
        
    }
    
    //sending the incentiveslab parameters and order sum for a particular saloon getting the incentive if any.
    public static decimal getincnetive(list<Incentive_Slab__c> incntveslab, decimal achievepercentagevalue,decimal target, decimal achieve){
        map<decimal,decimal> incentiveVsIncentiveslab= new map<decimal,decimal>();
        list<decimal> incentivemaxslab= new list<decimal>();
        
        decimal incentive=0;
        decimal maxslab=0;
        decimal getmaxvaluebefore100=0;
       for(Incentive_Slab__c slab1 : incntveslab){
           if(slab1.Minimum__c<=100 && getmaxvaluebefore100 < slab1.Minimum__c){
               getmaxvaluebefore100=slab1.Minimum__c;
           }
            incentiveVsIncentiveslab.put(slab1.Maximum__c,slab1.Incentive__c);
           incentiveVsIncentiveslab.put(slab1.Minimum__c,slab1.Incentive__c);
            incentivemaxslab.add(slab1.Maximum__c);
       }
        //incentivemaxslab.sort();
        // maxslab = incentivemaxslab.get(incentivemaxslab.size()-1);
        /***Incentive_Slab__c slab : incntveslab){
            if(slab.Minimum__c<ordersum){
                if(slab.Incentive__c!=null && slab.Incentive__c>incentive){
                    incentive= slab.Incentive__c; 
                }
            }   
        }***/
        for(Incentive_Slab__c slab : incntveslab){ 
            if(slab.IsPercentage__c==false && slab.Minimum__c <= achievepercentagevalue){
                if(slab.Incentive__c!=null && slab.Incentive__c>incentive ){   
               incentive= slab.Incentive__c; 
               //minslab  =slab.Minimum__c;
                }
            }
               if( slab.IsPercentage__c==True && slab.Minimum__c <= achievepercentagevalue ){
                     system.debug('Is inside if');
                   system.debug('inside ispercent');
                   system.debug(achieve>target);
                   system.debug('slab incentive '+ slab.Incentive__c);
                   system.debug(slab.Incentive__c>incentive);
                     if(achieve>target && slab.Incentive__c!=null && slab.Incentive__c>incentive ){
                     decimal differenceofTargetActual=achieve-target;
                         system.debug('differenceofTargetActual'+differenceofTargetActual);
                     decimal excessvalueIncentive= (differenceofTargetActual*slab.Incentive__c)/100;
                         system.debug('excessvalueIncentive'+excessvalueIncentive);
                         if(incentiveVsIncentiveslab.containskey(getmaxvaluebefore100) && incentiveVsIncentiveslab.get(getmaxvaluebefore100)!=null){
                         incentive= incentiveVsIncentiveslab.get(getmaxvaluebefore100)+excessvalueIncentive;
                         }
                     }
                 }
            }   
        
        system.debug('incentive'+incentive);
        return incentive;
    }
}