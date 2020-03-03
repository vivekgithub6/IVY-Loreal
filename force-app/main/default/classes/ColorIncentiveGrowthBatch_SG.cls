/*
 * Block comments with details of changes
 */
global class ColorIncentiveGrowthBatch_SG implements Database.Batchable<sObject>{
    Date todayDate = date.Today();
    global Database.QueryLocator start(Database.BatchableContext bc){

        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Product_Group__c,Product_Group__r.ivybase__Grouping_Type__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Product_Group__r.ivybase__Grouping_Type__c=\'Color Incentive\' AND Resource__c != null AND Market_ISO__c=\'SG\' AND recordType.DeveloperName=\'SG_Coverage\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        id incentivegroupid;
        List<Target_Actual__c> updateTargetList= new List<Target_Actual__c>();
        set<id> SkuId= new set<id>();
        date lastyearcurrentstatrtdate;
        date lastyearcurrentenddate;
        decimal CurrentMonthSaleValue =0;
        decimal LastYearSaleValue = 0;
        // Coverage_CalculationFromLastYear.makeCalculationForCoverage(scope);  
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
          //  lastyearstartdate=date.newInstance(scope[0].Start_Date1__c.year(),scope[0].Start_Date1__c.Month(),scope[0].Start_Date1__c.day());
            
                list<ivybase__Product_Group_Detail__c> prdgrpdetails=[select id,Product_Hierarchy__c,ivybase__Product__c,ivybase__Product_Group__r.Buy_Logic_Value__c,ivybase__Product_Group__r.Buy_Logic__c,ivybase__Product_Group__c 
                                                                      from ivybase__Product_Group_Detail__c 
                                                                      where  ivybase__Product_Group__c=:scope[0].Product_Group__c ];
            for(ivybase__Product_Group_Detail__c pgd:prdgrpdetails){
                if(pgd.ivybase__Product__c!=null){
                    SkuId.add(pgd.ivybase__Product__c);
                }
            }
            
            
            
         //querying last year invlinenitems based on start date and end date.Gross_Value__c  ivydsd__Total_Amount__c
         AggregateResult [] LastYearSalesValue= [select sum(ivydsd__Total_Amount__c) salesValue,ivydsd__Invoice__r.ivydsd__Resource__c res
                                                             from ivydsd__Invoice_Line_Item__c 
                                                             where ivydsd__Product_Master1__c IN:SkuId AND ivydsd__Invoice__r.ivydsd__Invoice_Date__c>=:lastyearcurrentstatrtdate AND ivydsd__Invoice__r.ivydsd__Invoice_Date__c<=:lastyearcurrentenddate
                                                             Group by ivydsd__Invoice__r.ivydsd__Resource__c ];
            //querying inv line items on current start date and end date
AggregateResult [] CurrentMonthSalesValue= [select sum(ivydsd__Total_Amount__c) salesValue,ivydsd__Invoice__r.ivydsd__Resource__c res
                                                             from ivydsd__Invoice_Line_Item__c 
                                                             where ivydsd__Product_Master1__c IN:SkuId AND ivydsd__Invoice__r.ivydsd__Invoice_Date__c>=:scope[0].Start_Date1__c AND ivydsd__Invoice__r.ivydsd__Invoice_Date__c<=:scope[0].End_Date1__c
                                                            Group by ivydsd__Invoice__r.ivydsd__Resource__c ];
            
            
            
            
         if(CurrentMonthSalesValue.size() > 0){
         	CurrentMonthSaleValue = (decimal)CurrentMonthSalesValue[0].get('salesValue') != null ? (decimal)CurrentMonthSalesValue[0].get('salesValue') : 0;
         }
         system.debug('-CurrentMonthSalesValue----->'+CurrentMonthSalesValue);
     
         if(LastYearSalesValue.size() >0){
             LastYearSaleValue = (decimal)LastYearSalesValue[0].get('salesValue') != null ? (decimal)LastYearSalesValue[0].get('salesValue') :0; 
         }
         system.debug('-LastYearSaleValue----->'+LastYearSalesValue);
            
            decimal percenatgegrowth=0;
            decimal finalpercent=0;
            if(LastYearSaleValue!=0 && LastYearSaleValue!=null){
                percenatgegrowth=CurrentMonthSaleValue/LastYearSaleValue;
                if(percenatgegrowth!=null)
                finalpercent=100-percenatgegrowth;
            }
            for(Target_Actual__c targt:scope){
               // targt.Target__c =LastYearSaleValue;
                targt.Actual__c=CurrentMonthSaleValue;
                targt.Achievement__c=ConquestBatch_MY.getincnetive(incentiveslab,finalpercent);
            updateTargetList.add(targt);
            }
            if(updateTargetList.size()>0){
                update  updateTargetList;
            }
           
        }//end of scope
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ConquestCalculationSemister_SG') && vMapNameCustomSett.get('ConquestCalculationSemister_SG').SwitchOff__c==false){
           ConquestCalculationSemister_SG Conqsem= new ConquestCalculationSemister_SG();
        database.executebatch(Conqsem,1);
        }
       
    }

}