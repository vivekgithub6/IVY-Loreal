/*
 * Block comments with details of changes
 */


//Process one record at a timeeee.
global class SGCoverageBatch implements Database.Batchable<sObject>{
    Date todayDate = date.Today();
    global Database.QueryLocator start(Database.BatchableContext bc){

        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Product_Group__c,Product_Group__r.ivybase__Grouping_Type__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Market_ISO__c=\'SG\' AND recordType.DeveloperName=\'SG_Coverage\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){

        if(scope.size()>0){

            System.debug('twotarget');

            if(scope[0].Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Fusio Dose') || scope[0].Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('SCALP')){
               pillerIncentive.ProcessTargetActualAndCreateUniqueAccountCovered(scope);
            }//end of fuiso and scalp clacualtion

            //starts the new launch calculation

            else if(scope[0].Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('New Launch')){
                Coverage_CalculationFromLastYear.NewLaunchCalculation(scope);
            }
            //starts Top 20 Calculation
            else if(scope[0].Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Top 20 SKUs')){
               Coverage_CalculationFromLastYear.Top20calculationforSG(scope);
            }
        }//end of scope check
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('ReActivationCoverageBatch_SG') && vMapNameCustomSett.get('ReActivationCoverageBatch_SG').SwitchOff__c==false){
            ReActivationCoverageBatch_SG RASG= new ReActivationCoverageBatch_SG();
        database.executeBatch(RASG,1); 
        }
      
    }

}