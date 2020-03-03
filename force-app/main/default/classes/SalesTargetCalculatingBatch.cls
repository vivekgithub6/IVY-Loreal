//This methods will work for Non SG with Monthly Achievemnt and Quarter / creating sales recovery
//process one record at a time
global class SalesTargetCalculatingBatch implements Database.Batchable<sObject>{
    Map<String,Decimal> invoiceMap = new Map<String,Decimal>();
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);	
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);//Sales Recovery
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Target_Actual__c,RecordTypeId,Resource__c,Mid_Month_Achievement__c,Actual__c,Sales_Recovery_Value__c,Sales_Recovery__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Market_ISO__c!=\'SG\' AND Parameter_type__c!=\'Mid Month\' AND Parameter_type__c!=\'Sales Recovery\' AND recordType.DeveloperName=\'Sales_Target\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){ 
        System.debug('execute targets:: '+scope);
        List<Target_Actual__c> updatedTargets = new List<Target_Actual__c>();
        List<Target_Actual__c> InsertsalesRecovery = new List<Target_Actual__c>();
        Date todayDate = Date.today();
        date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        // date PreviousMonthtodate=Date.newInstance(todayDate.year(),todayDate.Month()-1,1);
        // date midmonthdate=Date.newInstance(todayDate.year(),todayDate.Month(),15);
        //Integer numberOfDays = Date.daysInMonth(PreviousMonthtodate.year(), PreviousMonthtodate.month());
        //  Date lastDayOfMonth = Date.newInstance(PreviousMonthtodate.year(), PreviousMonthtodate.month(), numberOfDays);
        id incentivegroupid;
        decimal lastmonthincentive=0;
        id lastmonthincentivegroupid;
        list<AggregateResult> groupedResults = new list<AggregateResult>();
        list<Target_Actual__c> lastmonthdata= new list<Target_Actual__c>();
        //list<AggregateResult> MidMonthresults = new list<AggregateResult>();
        // map<id,decimal> midmonthachievedMap= new map<id,decimal>();
        decimal lastmonthreaminingcoverage=0;
        Incentive_Slab__c lastINslabMax = new Incentive_Slab__c();
        Incentive_Slab__c ThisINslabMax = new Incentive_Slab__c();
        decimal lastmonthsalestargetvalue=0;
        decimal diffenceofExecess= 0;
        decimal salesrecovertarget=0;
        decimal salesrecoveryActual=0;
        decimal finalpercentTogetincentive=0;
        decimal incentivesalesrecovery=0;
        decimal salesrecoveryincentivetoGive=0;
        id sellerid;
        string MarketIso;
        list<id> deleteids= new list<id>();
        //ivydsd__Invoice_Date__c
        if(scope.size()>0){
            List<Target_Actual__c> deletesalesrecovery=[select id,Resource__c,Parameter_type__c,(select id from Target_Division__r) from Target_Actual__c where Parameter_type__c='Sales Recovery' AND Resource__c=:scope[0].Resource__c ];
           system.debug('deletesalesrecovery'+deletesalesrecovery);
            if(deletesalesrecovery.size()>0){
                deleteids.add(deletesalesrecovery[0].id);
                if(deletesalesrecovery[0].Target_Division__r.size()>0)
                deleteids.add(deletesalesrecovery[0].Target_Division__r[0].id);
                if(Scope[0].Parameter_type__c.equalsignorecase('Target achievement') && deleteids.size()>0){
                  database.delete(deleteids);
                }
                //database.delete(deletesalesrecovery[0].Target_Division__r);
            }
            sellerid=scope[0].Resource__c;
            
            incentivegroupid=scope[0].Incentive_Group__c;
            MarketIso=scope[0].Market_ISO__c;	
            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
            if(incentiveslab.size()>0){
                ThisINslabMax=getMaxIncentiveSlabExcept50(incentiveslab);
            }
            groupedResults = [Select SUM(Total_Amount__c) sum,ivydsd__Resource__c from ivydsd__Invoice__c 
                              where ivydsd__Resource__c != null AND ivydsd__Resource__c =:scope[0].Resource__c
                              AND ivydsd__Invoice_Date__c >=: scope[0].Start_Date1__c AND ivydsd__Invoice_Date__c <=:scope[0].End_Date1__c
                              Group By ivydsd__Resource__c];

            for(AggregateResult result : groupedResults){
                invoiceMap.put((String)result.get('ivydsd__Resource__c'), (Decimal)result.get('sum'));
                System.debug('invoiceMap::: '+invoiceMap);
            }

            lastmonthdata=[select id,Resource__c,Actual__c,Target__c,Achievement__c,Sales_Target_Acheivement__c,Incentive_Group__c 
                           from Target_Actual__c
                           where Resource__c=:scope[0].Resource__c AND End_Date1__c= LAST_MONTH AND Parameter_type__c=:scope[0].Parameter_type__c];


            if(lastmonthdata.size()>0){
                lastmonthsalestargetvalue=lastmonthdata[0].Sales_Target_Acheivement__c;
                lastmonthreaminingcoverage=lastmonthdata[0].Target__c;
                lastmonthincentivegroupid=lastmonthdata[0].Incentive_Group__c;
                if(lastmonthdata[0].Achievement__c!=null && lastmonthdata[0].Achievement__c>0 )
                lastmonthincentive=lastmonthdata[0].Achievement__c;//it will hold lastmonth fall value
            }

            //querying past month incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> pastMonthSlab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:lastmonthincentivegroupid ];

            if(pastMonthSlab.size()>0){
                lastINslabMax= getMaxIncentiveSlabExcept50(pastMonthSlab);
            }
            decimal percentageRecoveryToAchieve=0;
            if(lastINslabMax!=null && lastINslabMax.Minimum__c!=null && lastINslabMax.Minimum__c >lastmonthsalestargetvalue ){
                percentageRecoveryToAchieve=lastINslabMax.Minimum__c-lastmonthsalestargetvalue; //holds the percent value to reach max in current month to get incentive
            }

            //////////////////////////llopppping starts on target actual for assigning the actula and incentive//////////////////////////
            for(Target_Actual__c target : scope){
                               
                if(target.Actual__c != null && target.Market_ISO__c=='PH' &&invoiceMap.get(target.Resource__c)!=Null){
                    target.Actual__c = invoiceMap.get(target.Resource__c); 
                    updatedTargets.add(target);
                }//end of PH calculation

                //calculation begins for quaterly Incentive for MY   &&&&&&&&&&  target achievement//
                if(target.Target__c>0 && target.Actual__c != null && target.Sales_Recovery__c==False && target.Parameter_type__c!=null && (target.Parameter_type__c.equalsignorecase('Quarter incentive') || target.Parameter_type__c.equalsignorecase('Target achievement')) && invoiceMap.containskey(target.Resource__c) && invoiceMap.get(target.Resource__c)!=Null){
                    if(target.Market_ISO__c=='MY'){
                    target.Actual__c = invoiceMap.get(target.Resource__c); 
                    decimal achievepercent=(invoiceMap.get(target.Resource__c)/target.Target__c)*100;
                    target.Achievement__c=getincnetive(incentiveslab,achievepercent);
                    updatedTargets.add(target);
                    }
                }
                system.debug('updatedTargets'+updatedTargets);
                ////////////////////////////// target achievement Sales recovery Starts///////////////////////////////////////////////////
                if(target.Target__c>0 && target.Actual__c != null && target.Sales_Recovery__c==True && target.Parameter_type__c.equalsignorecase('Target achievement') && invoiceMap.containskey(target.Resource__c) && invoiceMap.get(target.Resource__c)!=Null){
                    //updateing this month Target Actual Here
                            target.Actual__c = invoiceMap.get(target.Resource__c); 
                            decimal achievepercent=(invoiceMap.get(target.Resource__c)/target.Target__c)*100;
                            target.Achievement__c=getincnetive(incentiveslab,achievepercent);
                            updatedTargets.add(target); 
                    
                    //Check frst whether the previous month related  sales target achievement is greater than sales recovery percentage.  
                    if(lastmonthdata.size()>0 && scope[0].Sales_Recovery_Value__c!=0 && lastmonthdata[0].Sales_Target_Acheivement__c >=scope[0].Sales_Recovery_Value__c){
                        system.debug('satisfied sales recovery percentage');
                        if(lastINslabMax!=null && lastINslabMax.Minimum__c!=null && lastINslabMax.Minimum__c >lastmonthsalestargetvalue){//90>80
                            system.debug('entered into the last month max slab is greater than lastmonthsales target value');
                            decimal thisMonthAchievemnt=invoiceMap.get(target.Resource__c); 
                            decimal thisMonthachievepercent=(invoiceMap.get(target.Resource__c)/target.Target__c)*100;
                         	//checking whether reached this month max or not
                            if(ThisINslabMax!=null && ThisINslabMax.Minimum__c!=null && ThisINslabMax.Minimum__c < thisMonthachievepercent){
                                // differnce the excess
                                diffenceofExecess= thisMonthachievepercent-ThisINslabMax.Minimum__c;
                                salesrecovertarget=(lastmonthreaminingcoverage*percentageRecoveryToAchieve)/100;
                                salesrecoveryActual=(target.Target__c*diffenceofExecess)/100;
                                finalpercentTogetincentive=lastmonthsalestargetvalue+diffenceofExecess;
                                salesrecoveryincentivetoGive=(salesrecoveryActual/salesrecovertarget)*100;
                                incentivesalesrecovery=getincnetive(pastMonthSlab,salesrecoveryincentivetoGive);//finalpercentTogetincentive
                               system.debug('incentivesalesrecovery'+incentivesalesrecovery);
 system.debug('lastmonthincentive'+lastmonthincentive);
                                if(incentivesalesrecovery!=lastmonthincentive && incentivesalesrecovery>lastmonthincentive){
                                    incentivesalesrecovery=incentivesalesrecovery-lastmonthincentive;
                                    system.debug(incentivesalesrecovery);
                                }
                                Target_Actual__c salesrecovery= new Target_Actual__c();
                                salesrecovery.Name='Sales Recovery';
                                salesrecovery.Target__c=salesrecovertarget;
                                salesrecovery.Actual__c=salesrecoveryActual;
                                salesrecovery.Parameter_type__c='Sales Recovery';
                                salesrecovery.Start_Date1__c=target.Start_Date1__c;
                                salesrecovery.RecordTypeId=target.RecordTypeId;
                                salesrecovery.End_Date1__c=target.End_Date1__c;
                                salesrecovery.Achievement__c=incentivesalesrecovery;
                                salesrecovery.Market_ISO__c=target.Market_ISO__c;
                                salesrecovery.Resource__c=target.Resource__c;
                                salesrecovery.Incentive_Group__c=lastmonthincentivegroupid;
                                system.debug('salesrecovery'+salesrecovery);
                                InsertsalesRecovery.add(salesrecovery);
                                
                            }
                        }
                    }
                    //else{

                    //}

                }

            }
              
             update updatedTargets;
              //-----Assiging division to partner function started
       // Id sellerId = ;
       List<ivybase__Location_Hierarchy__c> userterritorylist= LocationMasterService.getCurrentUserTerritory(sellerid);
        set<id> teritoryid= new set<id>();
        for(ivybase__Location_Hierarchy__c loct:userterritorylist){
            teritoryid.add(loct.id);
        }
        Set<Id> divids=DivisionSerivce.getDivisionForUserTerritory(teritoryid);
        list<id> divid_list=new list<id>();
        divid_list.addAll(divids);
        //------
          
            list<Target_Division__c> tdiv= new list<Target_Division__c>();
            if(InsertsalesRecovery.size()>0){
                database.insert(InsertsalesRecovery);
                system.debug('InsertsalesRecovery'+InsertsalesRecovery);
                Target_Division__c td= new Target_Division__c();
                td.Target_Actual__c=InsertsalesRecovery[0].id;
                td.Division__c=divid_list[0];
                td.Market_ISO__c=MarketIso;
                tdiv.add(td);
            }
           if(tdiv.size()>0){
               database.insert(tdiv);
            }
          
            system.debug('updatedTargets'+updatedTargets);
            
        }
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ActivationCoverageBatch') && vMapNameCustomSett.get('ActivationCoverageBatch').SwitchOff__c==false){
         ActivationCoverageBatch ACB= new ActivationCoverageBatch();
        database.executeBatch(ACB,1);  
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
    public static Incentive_Slab__c getMinimumIncentiveSlabExcept50(list<Incentive_Slab__c> incntveslab)
    {
        Decimal minimum=0;
        boolean first=True;
        Map<Decimal,Incentive_Slab__c> incentiveMap = new Map<Decimal,Incentive_Slab__c>();
        for(Incentive_Slab__c slab:incntveslab)
        {
            if(slab.Minimum__c>50 && first){
                first=false;
                minimum=slab.Minimum__c;
            }
            incentiveMap.put(slab.Minimum__c, slab);
            if(slab.Minimum__c!=null && slab.Minimum__c>50 && slab.Minimum__c<=minimum)
            {
                minimum=slab.Minimum__c;
            }
        }
        if(incentiveMap.containsKey(minimum))
        {
            return incentiveMap.get(minimum);
        }
        return null;
    }

    public static Incentive_Slab__c getMaxIncentiveSlabExcept50(list<Incentive_Slab__c> incntveslab)
    {
        Decimal minimum=0;
        boolean first=True;
        Map<Decimal,Incentive_Slab__c> incentiveMap = new Map<Decimal,Incentive_Slab__c>();
        for(Incentive_Slab__c slab:incntveslab)
        {
            if(slab.Minimum__c>50 && first){
                first=false;
                minimum=slab.Minimum__c;
            }
            incentiveMap.put(slab.Minimum__c, slab);
            if(slab.Minimum__c!=null && slab.Minimum__c>50 && slab.Minimum__c>=minimum)
            {
                minimum=slab.Minimum__c;
            }
        }
        if(incentiveMap.containsKey(minimum))
        {
            return incentiveMap.get(minimum);
        }
        return null;
    }

}