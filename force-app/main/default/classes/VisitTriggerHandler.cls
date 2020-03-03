public class VisitTriggerHandler 
{
public static void UpdateSaloonType(list<ivybase__Visit__c> VisitList)
    {		
        set<id> AccId = new set<id>();
        for(ivybase__Visit__c v : VisitList)
        {
            AccId.add(v.ivybase__Store__c);
        }
        AggregateResult[] groupedResults = [SELECT COUNT(Id),ivybase__Store__c from ivybase__Visit__c where ivybase__Store__c=:AccId AND ivybase__Store__r.Is_Conquest__c=true GROUP BY ivybase__Store__c];
        map<id,decimal> VisitCountConquestSalonMap = new map<id,decimal>();
        decimal VisitCount;
        id StoreId;
        for(AggregateResult ar:groupedResults)
        {
            system.debug('ar.expr0'+ar.get('expr0'));
            system.debug('ar.ivybase__Store__c'+ar.get('ivybase__Store__c'));
            VisitCount = Decimal.valueOf(String.valueOf(ar.get('expr0')));
            StoreId = Id.valueof(String.valueOf(ar.get('ivybase__Store__c')));
            if(VisitCountConquestSalonMap.containsKey(StoreId) == false)
            {
                VisitCountConquestSalonMap.put(StoreId,VisitCount);
            }
            
        }
        List<Account> ACC = [select id,name,Is_Conquest__c from Account where id=:AccId];
        Map<Id,Boolean> AccountIsConquestMap = new Map<Id,Boolean>();
        for(Account a:ACC)
        {
            AccountIsConquestMap.put(a.id,a.Is_Conquest__c);
        }
        set<id> VisitedAccount = new set<id>();
        
         map<string,string> resourceDivisionMap = ResourceService.GetAllResourceDivisionmap();
        system.debug('resourceDivisionMap' + resourceDivisionMap);
        
        
        for (ivybase__Visit__c Visit : VisitList)
        {	
            if((VisitCountConquestSalonMap.containsKey(Visit.ivybase__Store__c) == false) && (AccountIsConquestMap.containsKey(Visit.ivybase__Store__c)==true) 
               && (AccountIsConquestMap.get(Visit.ivybase__Store__c)==true) && VisitedAccount.contains(Visit.ivybase__Store__c)==false)
            {	
                VisitedAccount.add(Visit.ivybase__Store__c);
                visit.ivybase__Type__c = 'New';  
            }
            
            /* Code added for signature to get in reports*/
            if(resourceDivisionMap.Values().size()>0){
                
                visit.Signature__c = resourceDivisionMap.Values()[0];
                system.debug('signature '+ visit.Signature__c);
            }
            
            
        }     
    }
}