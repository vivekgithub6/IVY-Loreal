global class BatchCreateSalesKPITargetActual implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        //get sales rep resource type id
        List<ivybase__Resource_Type__c> resourcetype = [select id,name from ivybase__Resource_Type__c where name='Sales Rep'];
        Id resourceTypeId;
        for(ivybase__Resource_Type__c rt:resourcetype)
        {
            resourceTypeId=rt.id; 
        }    
        //get all resource under the sales rep resource id
        String Query = 'select id,name,ivybase__Resource_Type__c from ivybase__Resource__c  where ivybase__Resource_Type__c=:resourceTypeId';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ivybase__Resource__c> resourceList){
        system.debug('resourceList'+resourceList);
        set<Id> resourceId = new set<Id>();
        for(ivybase__Resource__c res:resourceList)
        {
            resourceId.add(res.id);
        }
        //get all records type info in Target_Actual__c
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT.get('Sales_KPI').getRecordTypeId());
        //sales kpi record type
        Id salesKPIRecordTypeId = RT.get('Sales_KPI').getRecordTypeId();
        Date todayDate = system.today();
        //this month in integer
        Integer thisMonth=todayDate.month();
        system.debug('d.month'+thisMonth);
        
        Set<Id> resourceForWhichWeHaveRecords = new Set<Id>();
        //search for exsiting records for resource with sales kpi record type this month
        List<Target_Actual__c> exisitingTargetActual = [select id,name, Resource__c,RecordType.DeveloperName,Month__c  from Target_Actual__c where Resource__c=:resourceId and RecordTypeId=:salesKPIRecordTypeId and Month__c=:thisMonth];
        system.debug('exisitingTargetActual'+exisitingTargetActual);
        List<Target_Actual__c> targetActualToupdate = new List<Target_Actual__c>();
        //if there is an exisiting record make the target as zero and update
        for(Target_Actual__c ta:exisitingTargetActual)
        {
            ta.Target__c=0;
            targetActualToupdate.add(ta);
            resourceForWhichWeHaveRecords.add(ta.Resource__c); 
        }
        system.debug('resourceForWhichWeHaveRecords'+resourceForWhichWeHaveRecords);
        resourceId.removeAll(resourceForWhichWeHaveRecords);
        system.debug('resourceId'+resourceId);
        List<Target_Actual__c> targetActualToInsert = new List<Target_Actual__c>();
        for(Id resId :resourceId)
        {
            //if we found a valid record type only proceed
            if(salesKPIRecordTypeId!=null){
                Target_Actual__c ta = new Target_Actual__c();
                ta.Month__c=thisMonth;
                ta.RecordTypeId=salesKPIRecordTypeId;
                ta.Resource__c=resId;
                ta.Target__c=0;
                targetActualToInsert.add(ta);
            }
        }
        system.debug('targetActualToInsert'+targetActualToInsert);
        if(targetActualToInsert.size()>0)
        {
        insert targetActualToInsert;    
        }
        if(targetActualToupdate.size()>0)
        {
            update targetActualToupdate;
        }
        
    }
    global void finish(Database.BatchableContext bc){ 
    }
    
}