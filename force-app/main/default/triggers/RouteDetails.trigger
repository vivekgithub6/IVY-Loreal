trigger RouteDetails on ivybase__Route_Details__c (After insert,after update,after delete) {
    list<ivybase__Route_Details__c> RoutedetailList=new list<ivybase__Route_Details__c>();
if(trigger.isInsert)
    RouteDetailsTriggerHandler.updateAccount(trigger.new);
    if(trigger.isUpdate){
        for(ivybase__Route_Details__c routedetail:trigger.new)
        if(trigger.oldmap.get(routedetail.id).ivybase__Store__c!=routedetail.ivybase__Store__c)
            RoutedetailList.add(routedetail);
    }
    if(RoutedetailList.size()>0)
         RouteDetailsTriggerHandler.updateAccount(RoutedetailList);
    if(trigger.isdelete){
       RouteDetailsTriggerHandler.updateAccount(trigger.old);
    }
        
}