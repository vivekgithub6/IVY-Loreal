/*
 * Block comments with details of changes
 */


//Process one record at a timeeee.
global class KeyBetsCalculation_batch implements Database.Batchable<sObject>{
    Date todayDate = date.Today();
    global Database.QueryLocator start(Database.BatchableContext bc){

        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Product_Group__c,Product_Group__r.ivybase__Grouping_Type__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Market_ISO__c=\'MY\' AND recordType.DeveloperName=\'Keybets_Coverage\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        
       Coverage_CalculationFromLastYear.NewLaunchCalculation(scope);   
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('SalesTargetMidMonthCal') && vMapNameCustomSett.get('SalesTargetMidMonthCal').SwitchOff__c==false){
           SalesTargetMidMonthCal STM= new SalesTargetMidMonthCal();
        database.executeBatch(STM,1);
        }
	
    }

}