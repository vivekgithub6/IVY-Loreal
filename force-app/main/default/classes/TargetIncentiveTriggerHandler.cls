public class TargetIncentiveTriggerHandler {
    public static void updateAchievement(List<Target_Actual__c> targets){
        Set<Id> IncGrpIds = new Set<Id>();
        Map<String,Double> achievement = new Map<string,Double>();
        Map<String,Decimal> actualValue = new Map<String, Decimal>();
                 System.debug('targets::'+targets);
        for(Target_Actual__c target : targets){
            system.debug('target.Recordtype.developername'+target.Recordtypeid);
            //system.debug('Schema.SObjectType.Target_A'+Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByName().get('Quantity').getRecordTypeId());
            if(target.Incentive_Group__c!=null){
            IncGrpIds.add(target.Incentive_Group__c);
            }
            system.debug('IncGrpIds'+IncGrpIds);
             if(target.Sales_Target_Acheivement__c != null && target.Sales_Target_Acheivement__c!=0 && target.Market_ISO__c=='PH' && target.Recordtypeid!=Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByName().get('Incentive_Quantity').getRecordTypeId()){
                 actualValue.put(target.Incentive_Group__c,target.Sales_Target_Acheivement__c);
             }
            
             if(target.Recordtypeid==Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByName().get('Incentive_Quantity').getRecordTypeId() && target.Actual__c!=null && target.Actual__c!=0)
                actualValue.put(target.Incentive_Group__c,target.Actual__c);
              
            /*if(target.ActualCoverage__c != null && target.ActualCoverage__c!=0 && target.recordtype.developername.equalsignorecase('Conquest'))
                  actualValue.put(target.Incentive_Group__c,target.ActualCoverage__c);
                  system.debug('actualValue+++'+actualValue);*/
              }
        List<Incentive_Slab__c> IncentiveSlabs = [Select Id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c 
                                                  from Incentive_Slab__c
                                                  where Incentive_Group__c IN : IncGrpIds];
        system.debug('IncentiveSlabs'+IncentiveSlabs);
      system.debug('actualValue'+actualValue);
        for(Incentive_Slab__c slab : IncentiveSlabs){
            system.debug('max'+slab.Maximum__c);
            system.debug('min'+slab.Minimum__c);
            //checking for below condiitons 
            /* max       min
             * value    Value
             * Null      Value
             * Value     Null**/
            if((slab.Maximum__c != null) && (slab.Minimum__c != null) ){
                system.debug('nonenull');
                if((actualValue.get(slab.Incentive_Group__c)<slab.Maximum__c || actualValue.get(slab.Incentive_Group__c)==slab.Maximum__c) && (actualValue.get(slab.Incentive_Group__c) > slab.Minimum__c || actualValue.get(slab.Incentive_Group__c) == slab.Minimum__c)){
                   system.debug('slab.Maximum__c'+slab.Maximum__c);
                    if(slab.Incentive__c != null) 
                        achievement.put(slab.Incentive_Group__c,slab.Incentive__c);
           }
            }
            else if((slab.Maximum__c == null) && (slab.Minimum__c != null) && achievement.get(slab.Incentive_Group__c)==Null){
                system.debug('maxnull');
                //|| actualValue.get(slab.Incentive_Group__c) <= slab.Minimum__c)
                if((actualValue.get(slab.Incentive_Group__c) >= slab.Minimum__c )){
                      system.debug('slab.Maximum__c'+slab.Maximum__c);
                    system.debug('actualValue.get(slab.Incentive_Group__c)'+actualValue.get(slab.Incentive_Group__c));
                    if(slab.Incentive__c != null) 
                        achievement.put(slab.Incentive_Group__c,slab.Incentive__c);
           }
            }
        
            else if((slab.Maximum__c != null) && (slab.Minimum__c == null)  && achievement.get(slab.Incentive_Group__c)==Null){
               system.debug('minnull');
                if(actualValue.get(slab.Incentive_Group__c)<slab.Maximum__c || actualValue.get(slab.Incentive_Group__c)==slab.Maximum__c){
                      system.debug('slab.Maximum__c'+slab.Maximum__c);
                    if(slab.Incentive__c != null) 
                        achievement.put(slab.Incentive_Group__c,slab.Incentive__c);
           }
            }
           
        }
        for(Target_Actual__c target : targets){
            system.debug('name'+target.name);
            system.debug('value'+achievement.get(target.Incentive_Group__c));
            target.Achievement__c =0;
            target.Achievement__c = achievement.get(target.Incentive_Group__c);
        }
     }
     public static void UpdateAcheievementForConquest(List<Target_Actual__c> targets){
        set<id> IncentivegroupIds=new set<id>();
        map<string,string> targetIncentivegroupmap=new map<string,string>();
         map<string,decimal> IncentivegroupIncentivevaluemap=new map<string,decimal>();

        for(Target_Actual__c target:targets){
            IncentivegroupIds.add(target.Incentive_Group__c);
        targetIncentivegroupmap.put(target.Resource__c,target.Incentive_Group__c);
            }
        system.debug('targetIncentivegroupmap'+targetIncentivegroupmap);
        system.debug('IncentivegroupIds'+IncentivegroupIds);
         list<Incentive_Slab__c> IncentiveslabList=[select Incentive__c,Incentive_Group__c from Incentive_Slab__c where Incentive_Group__c in:IncentivegroupIds];
       
        system.debug('IncentiveslabList'+IncentiveslabList);
        for(Incentive_Slab__c incentiveslab:IncentiveslabList){
            IncentivegroupIncentivevaluemap.put(incentiveslab.Incentive_Group__c,incentiveslab.Incentive__c);
        }
        system.debug('IncentivegroupIncentivevaluemap'+IncentivegroupIncentivevaluemap);
        for(Target_Actual__c target:targets){
            string incentivegroupid=target.Incentive_Group__c;
            if(IncentivegroupIncentivevaluemap.containsKey(incentivegroupid)==true && target.Account_Coverage__c!=null && IncentivegroupIncentivevaluemap.get(incentivegroupid)!=null){
          target.Achievement__c= IncentivegroupIncentivevaluemap.get(incentivegroupid) * target.Account_Coverage__c;
            }
            system.debug('target.Achievement__c'+target.Achievement__c);
        }
    }
}