public class AverageTurnoverPerRep_Service {
    /*public static AggregateResult[] planedvistsVSunplnedvists (){
        id resid=ResourceService.getLoginSellerId();
        system.debug('resid'+resid);
         Date todayDate = date.Today();
        date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
         Integer Monthrec = todayDate.month();
        //ivybase__Visit_Date__c >=: Monthtodate AND ivybase__Visit_Date__c<=:todayDate 
        AggregateResult[] jplan = [select count(id) plnd
                                              from JourneyPlanActivity__c
                                             where JourneyPlan__r.Territory__r.ivybase__Primary_Resource__c =:resid AND Store__c !=null AND JourneyPlan__r.month__c=:Monthrec AND date__c >=: Monthtodate AND  date__c <=:todayDate
                                              ];
        
        AggregateResult[] groupedResultsVisted =[select count(id) vstd
                                                   from ivybase__Visit__c 
                                                   where ivybase__Resource__c!=null AND ivybase__Resource__c=:resid AND ivybase__Visit_Date__c >=: Monthtodate AND ivybase__Visit_Date__c<=:todayDate 
                                                   
                                                   ];
        system.debug('jplan'+jplan);
        system.debug('groupedResultsVisted'+groupedResultsVisted);
        return null;
    }*/
}