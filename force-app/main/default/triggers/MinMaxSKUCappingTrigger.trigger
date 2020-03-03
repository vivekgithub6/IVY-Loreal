/**
* Created By : Ivy Mobility
* Created Date : 2019-April-27
* Purpose : To avoid the duplicate records
* Test Class :TESTRESTSKULevelMinMaxClass
*/
trigger MinMaxSKUCappingTrigger on Min_Max_Product_Capping__c (before insert, before update) {
    //MinMaxSKUCappingTrigger
    Map<String, Trigger_Logic_Configuration__c> vMapNameCustomSett = Trigger_Logic_Configuration__c.getAll();
    if(vMapNameCustomSett!=null && vMapNameCustomSett.containsKey('MinMaxSKUCappingTrigger') && vMapNameCustomSett.get('MinMaxSKUCappingTrigger').Deactive_Logic__c==false){
        List<String> uniqueFormulaList = new List<String>();
        for(Min_Max_Product_Capping__c mmpc : trigger.new) {
            uniqueFormulaList.add(mmpc.Unique_Formula__c);
        }
        List<Min_Max_Product_Capping__c> mmpcList = [SELECT Id FROM Min_Max_Product_Capping__c WHERE Unique_Formula__c IN :uniqueFormulaList];
        if(mmpcList != null && mmpcList.isEmpty() == false) {
            trigger.new[0].Unique_Formula__c.addError('The Same combination already exist');
        }
    }
}