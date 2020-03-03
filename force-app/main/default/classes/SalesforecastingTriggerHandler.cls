public class SalesforecastingTriggerHandler {
    
    public static Map<String, Decimal> MarketMonthMap = new Map<String, Decimal>();
    
    public static Map<String, Decimal> generateMarketMonthMap() {
    
        if(MarketMonthMap == null || MarketMonthMap.isEmpty() == true) {
             
            List<CountryCodeMarketISO__mdt> countryCodeList = [SELECT Country_Code__c, Country__c, Salesforecast_Upload_Month__c 
                                                           FROM CountryCodeMarketISO__mdt];
            
            for(CountryCodeMarketISO__mdt SalesforecastMonth : countryCodeList){
                               
                if(SalesforecastMonth.Country__c != null && SalesforecastMonth.Salesforecast_Upload_Month__c != null) {
                
                    MarketMonthMap.put(SalesforecastMonth.Country__c, SalesforecastMonth.Salesforecast_Upload_Month__c );
                }
            }
        }
        return MarketMonthMap;
    }
    
    public static void salesforecastValidation(List<Sales_Forecast__c> salesforcastList, Map<Id,Sales_Forecast__c> oldMap) {
        
        Set<String> uniqueFormulaSet = new Set<String>();
        Set<String> resourceISet = new Set<String>();
        
        for(Sales_Forecast__c salesforecast : salesforcastList) {
        
            if(uniqueFormulaSet.contains(salesforecast.Unique_Formula__c) == false) {
                uniqueFormulaSet.add(salesforecast.Unique_Formula__c);
            } else {
                salesforecast.Unique_Formula__c.addError('The Same combination already exist');            
            }
            
            if(salesforecast.Resource__c != null){
                
                resourceISet.add(salesforecast.Resource__c);
            }
        }
        
        List<Sales_Forecast__c> extSalesforecastList = [SELECT Id, Resource__c, Unique_Formula__c 
                                                     FROM Sales_Forecast__c 
                                                     WHERE Resource__c IN: resourceISet 
                                                     AND Unique_Formula__c IN :uniqueFormulaSet];
        
        Set<String> resourceUniqueSet = new Set<String>();
                                                    
        for(Sales_Forecast__c extSalesforecast : extSalesforecastList) {
            
            if(extSalesforecast.Unique_Formula__c != null) {
                
                resourceUniqueSet.add(extSalesforecast.Unique_Formula__c);
            }
        }
        
        Map<String,Decimal> SalesforecastMarketMonthMap = generateMarketMonthMap();
        
        
        for(Sales_Forecast__c salesforecast : salesforcastList) {
            
            if(trigger.isinsert == true || (trigger.isupdate == true && salesforecast.Unique_Formula__c != oldMap.get(salesforecast.Id).Unique_Formula__c)) {
                if(resourceUniqueSet.size()>0 && resourceUniqueSet.contains(salesforecast.Unique_Formula__c) == true ) {
                    
                    salesforecast.Unique_Formula__c.addError('The Same combination already exist');
                }  
            }          
            
            if(trigger.isinsert == true || (trigger.isupdate == true && (salesforecast.Month__c != oldMap.get(salesforecast.Id).Month__c ||
                                                                         salesforecast.Year__c != oldMap.get(salesforecast.Id).Year__c ))) {    
            
                if(SalesforecastMarketMonthMap.size()>0 
                   && SalesforecastMarketMonthMap.containskey(salesforecast.Market_ISO__c) == true) {
                    
                    Integer month = integer.valueOf(SalesforecastMarketMonthMap.get(salesforecast.Market_ISO__c));
                    System.debug('month===>'+month);
                    
                  	Map<String, Batch_SwitchOff__c> switchOffCustomSettingMap = Batch_SwitchOff__c.getAll();
                       
                    system.debug('switchOffCustomSettingMap'+ switchOffCustomSettingMap);
                    system.debug('>0 '+ switchOffCustomSettingMap.get('SalesForecast_Trigger_month_MoreThan_0').SwitchOff__c);
   					system.debug('=0 '+switchOffCustomSettingMap.get('SalesForecast_Trigger_month_equals_0').SwitchOff__c);
                       
                       
                    if(month == 0 && switchOffCustomSettingMap.get('SalesForecast_Trigger_month_equals_0').SwitchOff__c==false) {
                        
                        system.debug('month 0');
                        if(!(Integer.valueOf(salesforecast.Month__c) == system.today().month() 
                           && Integer.valueOf(salesforecast.Year__c) == system.today().year())) {
                            
                            salesforecast.addError('Salesforecast should be in current month');
                        } 
                    } else if(month > 0 && switchOffCustomSettingMap.get('SalesForecast_Trigger_month_MoreThan_0').SwitchOff__c==false) {
                           system.debug('month >0');                 
                        Integer startMonth = system.today().addmonths(1).month();
                        Integer startyear = system.today().addmonths(1).year();
                  
                        Integer EndMonth = system.today().addmonths(month).month();
                        Integer Endyear = system.today().addmonths(month).year();
                        
                        System.debug('startMonth===>'+startMonth);
                        System.debug('startyear===>'+startyear);
                        System.debug('EndMonth===>'+EndMonth);
                        System.debug('Endyear===>'+Endyear);
                        System.debug('salesforecast.Year__c===>'+salesforecast.Year__c);
                        System.debug('salesforecast.Month__c===>'+salesforecast.Month__c);
                                           
                        if(!((Integer.valueOf(salesforecast.Year__c) > startyear && Integer.valueOf(salesforecast.Year__c) <= Endyear && Integer.valueOf(salesforecast.Month__c) <= EndMonth) 
                             || (Integer.valueOf(salesforecast.Year__c) == startyear && Integer.valueOf(salesforecast.Year__c) == Endyear && Integer.valueOf(salesforecast.Month__c) >= startMonth
                                 && Integer.valueOf(salesforecast.Month__c) <= EndMonth)
                             || (Integer.valueOf(salesforecast.Year__c) == startyear && Integer.valueOf(salesforecast.Year__c) < Endyear && Integer.valueOf(salesforecast.Month__c) >= startMonth)
                                 )) {
                            
                            salesforecast.addError('Salesforecast should be in next '+month+' month');
                        }
                        System.debug('salesforecast===>'+salesforecast);
                    }
                }
            }
        }
    }   
   
    public static void populateResource(List<Sales_Forecast__c> salesforcast)
    {
        Set<Id> locationHierarchyId = new Set<Id>();
        set<Id> resourceId = new Set<Id>();
        for(Sales_Forecast__c sf:salesforcast)
        {
            if(sf.Territory__c!=null)
            {
                locationHierarchyId.add(sf.Territory__c);
            }
            if(sf.Resource__c!=null)
            {
                resourceId.add(sf.Resource__c); 
            }
        }
        //Map<resourceId,LocationId>
        Map<Id,Id> resourceLHMap = new Map<Id,Id>();
        //Map<LocationId,ResourceId>
        Map<Id,Id> LHResourceMap = new Map<Id,Id>();
        List<ivybase__Location_Hierarchy__c> locHierarchy =[SELECT id,name,ivybase__Primary_Resource__c from ivybase__Location_Hierarchy__c where (id=:locationHierarchyId or ivybase__Primary_Resource__c=:resourceId) ] ;
        
        for(ivybase__Location_Hierarchy__c loc:locHierarchy)
        {
            if(loc.ivybase__Primary_Resource__c!=null)
            {
                LHResourceMap.put(loc.Id,loc.ivybase__Primary_Resource__c);
                resourceLHMap.put(loc.ivybase__Primary_Resource__c,loc.Id);
            }
            
        }
        for(Sales_Forecast__c sf:salesforcast)
        {    
            //only resource provided , territory not provided , populate the location hierarchy which has this resource as primary user
            if(sf.Territory__c==null && sf.Resource__c!=null)
            {
                if(resourceLHMap.containsKey(sf.Resource__c))
                {
                    sf.Territory__c = resourceLHMap.get(sf.Resource__c);      
                }
            }
            if(sf.Resource__c==null && sf.Territory__c!=null)
            {
                if(LHResourceMap.containsKey(sf.Territory__c))
                {
                    sf.Resource__c=LHResourceMap.get(sf.Territory__c);
                }
            }
            //auto populate month and year based on date 
            System.debug('sf.Date__c===>'+sf.Date__c);
            
            if(sf.Date__c != null && sf.Month__c == null)
            {
                sf.Month__c = String.valueOf(sf.Date__c.month());
                sf.Year__c = String.valueOf(sf.Date__c.Year());
            } else if(sf.Month__c != null && sf.Year__c != null) {
                sf.Date__c = Date.newInstance(Integer.valueOf(sf.Year__c), Integer.valueOf(sf.Month__c), 1);
            }
            system.debug('sf'+sf);
            
            if(String.isNotBlank(sf.Status__c) == true && sf.Status__c == 'Submitted') {
                
                sf.Submitted_Date__c = system.today();
            }
        }
        
    }
    public static void SubmitForApproval(Set<id> SalesforeCastIds){
        map<string,string> JourneyplanIdOwnerIdMap=new map<string,string>();
        List<String> resourceTypeNameList = new List<String>{'Area','Regional','National'};
            Id submitterId = UserInfo.getUserId();
        Map<String,Id> ApproverIdSet=new Map<String,Id>(); 
        ApproverIdSet=   ApproverIds.getAllLevelApproverIds(submitterId);
        system.debug('ApproverIds'+ApproverIdSet);
        
        string Approverid;
        for(Integer i = 0; i < resourceTypeNameList.size(); i++){
            if(Approverid==Null){
                if(ApproverIdSet.get(resourceTypeNameList[i])!=Null)
                    Approverid=ApproverIdSet.get(resourceTypeNameList[i]);
            }
        }
        for(id s:SalesforeCastIds){
            // Create an approval request for the Opportunity
            if(Approverid!=Null){
                if(Approval.isLocked(s)==false){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval');
                    req1.setObjectId(s);
                    req1.setNextApproverIds(new Id[] {Approverid});
                    // Submit the approval request for the Opportunity
                    Approval.ProcessResult result = Approval.process(req1); 
                    system.debug('result'+result);
                }
            }
        }
        List<Id> IdList = new List<Id>(SalesforeCastIds);
        if(IdList.size()>0){
            Approval.unlock(IdList,false);
        }
    }
    public static void UpdateApproverComments(list<Sales_Forecast__c> SalesforecastList){
        system.debug('SalesforecastList'+SalesforecastList);
        set<id> SalesforecastIds=new set<id>();
        map<id,string> CommentsMap=new map<id,string>();
        set<id> processInstanceIds=new set<id>();
        for(Sales_Forecast__c j:SalesforecastList)
            SalesforecastIds.add(j.id);
        list<Sales_Forecast__c> SalesforecatlistToUpdate=[SELECT id,SupervisorComments__c,DummyUpdate__c from Sales_Forecast__c where id in:SalesforecastIds];
        for (Sales_Forecast__c a : [SELECT Id,(SELECT ID FROM ProcessInstances ORDER BY LastModifiedDate DESC) FROM Sales_Forecast__c WHERE ID in:SalesforecastIds])
        {
            for(ProcessInstance pi :a.ProcessInstances)
                processInstanceIds.add(pi.Id);
        }
        for (ProcessInstance pi : [SELECT TargetObjectId,(SELECT Id, StepStatus, Comments  FROM Steps  ORDER BY CreatedDate DESC )
                                   FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC limit 1]){
                                       
                                       system.debug('com'+pi.steps);
                                       system.debug('pi.Steps[0]'+pi.Steps[0]);
                                       if(pi.Steps[0].Comments!=Null)
                                           CommentsMap.put(pi.TargetObjectId,pi.Steps[0].Comments);
                                   }
        system.debug('CommentsMap'+CommentsMap);  
        for(Sales_Forecast__c s:SalesforecatlistToUpdate){
            if(CommentsMap.keyset().contains(s.id))
                s.SupervisorComments__c=CommentsMap.get(s.id);
            s.DummyUpdate__c='';
        }
        update SalesforecatlistToUpdate;
    } 
}