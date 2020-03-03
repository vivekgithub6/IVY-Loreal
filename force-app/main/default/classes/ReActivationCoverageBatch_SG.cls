/*
 * Block comments with details of changes
 */
//Process one record at a timeeee.
global class ReActivationCoverageBatch_SG implements Database.Batchable<sObject>{
    Date todayDate = date.Today();
    global Database.QueryLocator start(Database.BatchableContext bc){

        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        Integer month = date.Today().month();
        integer Year = date.today().Year();
            string query='Select id,Resource__c,Actual__c,Achievement__c,Target__c,Incentive_Group__c,Start_Date1__c,End_Date1__c,Parameter_type__c,Month__c,Year__c from Target_Actual__c where Resource__c != null AND Market_ISO__c=\'SG\' AND recordType.DeveloperName=\'Reactivation\' AND Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+'';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        List<Target_Actual__c> UpdateTargetActualList= new List<Target_Actual__c>();
        date lastyearcurrentstatrtdate;
        date lastyearcurrentenddate;
        Integer month = date.Today().month();
        integer lastYear = date.today().Year()-1; 
        Integer currentmonth = date.Today().month();
        integer currentyear = date.today().Year(); 
        
       
        
        set<id> lastyearcurrentmonthcoveredaccountId= new set<id>();
        set<id> currentmonthcoveredaccountId= new set<id>();
        decimal lastyearaccountcoveredsize=0;
        decimal Currentyearaccountcoveredsize=0;
        id incentivegroupid;
        if(scope.size()>0){
            integer startdateyear=scope[0].Start_Date1__c.year();
            integer enddateyear=scope[0].End_Date1__c.year();
            integer startdateMonth=scope[0].Start_Date1__c.Month();
            integer enddateMonth=scope[0].End_Date1__c.month();
            integer startdateday=scope[0].Start_Date1__c.day();
            integer enddatedateday=scope[0].End_Date1__c.day();
            
            incentivegroupid=scope[0].Incentive_Group__c;
            
             lastyearcurrentstatrtdate= date.newInstance(startdateyear-1, startdateMonth, startdateday);
            lastyearcurrentenddate=date.newInstance(enddateyear-1, enddateMonth, enddatedateday);
            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
            //querying last year current month invoices
           // list<ivydsd__Invoice__c> lastyearcurrentmontinvlist= [select id,ivydsd__Store__c from ivydsd__Invoice__c where CALENDAR_MONTH(ivydsd__Invoice_Date__c)=:month AND CALENDAR_YEAR(ivydsd__Invoice_Date__c)=:lastYear AND ivydsd__Resource__c =:scope[0].Resource__c];
           list<ivydsd__Invoice__c> lastyearcurrentmontinvlist= [select id,ivydsd__Store__c from ivydsd__Invoice__c where ivydsd__Invoice_Date__c >=:lastyearcurrentstatrtdate AND ivydsd__Invoice_Date__c <=:lastyearcurrentenddate  AND ivydsd__Resource__c =:scope[0].Resource__c];

            if(lastyearcurrentmontinvlist.size()>0){
                for(ivydsd__Invoice__c inv:lastyearcurrentmontinvlist){
                    lastyearcurrentmonthcoveredaccountId.add(inv.ivydsd__Store__c);
                }
            }
            lastyearaccountcoveredsize=lastyearcurrentmonthcoveredaccountId.size();

            //Querying Cuurent cuurent year current month data  InvoiceDate__c >=:PgroupStartdate AND InvoiceDate__c <=:PgroupEnddate
           //list<ivydsd__Invoice__c> currentmontinvlist= [select id,ivydsd__Store__c from ivydsd__Invoice__c where CALENDAR_MONTH(ivydsd__Invoice_Date__c)=:currentmonth    AND CALENDAR_YEAR(ivydsd__Invoice_Date__c)=:currentyear AND ivydsd__Resource__c =:scope[0].Resource__c];
           list<ivydsd__Invoice__c> currentmontinvlist= [select id,ivydsd__Store__c from ivydsd__Invoice__c where ivydsd__Invoice_Date__c >=:scope[0].Start_Date1__c AND ivydsd__Invoice_Date__c <=:scope[0].End_Date1__c  AND ivydsd__Resource__c =:scope[0].Resource__c];

            if(currentmontinvlist.size()>0){
                for(ivydsd__Invoice__c inv1:currentmontinvlist){
                    currentmonthcoveredaccountId.add(inv1.ivydsd__Store__c);
                }
                
            }
            if(currentmonthcoveredaccountId.size()>0){
                Currentyearaccountcoveredsize=currentmonthcoveredaccountId.size();
            }
            system.debug('Currentyearaccountcoveredsize'+Currentyearaccountcoveredsize);
            for(Target_Actual__c TActual:scope){
               // TActual.Target__c=lastyearaccountcoveredsize;
                TActual.Actual__c=Currentyearaccountcoveredsize;
                decimal achievmntincentive=0;
                if(TActual.Target__c!=0 && TActual.Target__c!=null && Currentyearaccountcoveredsize!=null){
                achievmntincentive=(Currentyearaccountcoveredsize/TActual.Target__c)*100;
                }
                TActual.Achievement__c=ConquestBatch_MY.getincnetive(incentiveslab,achievmntincentive);
                UpdateTargetActualList.add(TActual);
            }
            if(UpdateTargetActualList.size()>0)
                update UpdateTargetActualList;
        }
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ColorIncentiveGrowthBatch_SG') && vMapNameCustomSett.get('ColorIncentiveGrowthBatch_SG').SwitchOff__c==false){
            ColorIncentiveGrowthBatch_SG CISG= new ColorIncentiveGrowthBatch_SG();
      database.executeBatch(CISG,1);
        }
   
    }

}