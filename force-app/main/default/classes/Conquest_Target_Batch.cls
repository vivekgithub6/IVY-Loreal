// Batch Job for Processing the Records
global class Conquest_Target_Batch implements Database.Batchable<sobject> {
  // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        integer month=date.today().month();
        return Database.getQueryLocator('select id,Actual__c,Resource__c,Target__c,RecordType.DeveloperName,End_Date1__c,Start_Date1__c,Incentive_Group__c from Target_Actual__c  where Month__c=:month AND Market_ISO__c=\'PH\' and RecordType.DeveloperName=\'Conquest\'');
        // return Database.getQueryLocator('select id,(select ivydsd__Final_Order_Value__c,ivydsd__Store__c,ivydsd__Resource__c from ivydsd__Orders__c  order by ivydsd__Order_Date__c limit 2) from Account where Converted_Date__c!=Null and Converted_to_Normal_Saloon__c=true');
        // Query which will be determine the scope of Records fetching the same
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, list<Target_Actual__c> TargetActualList) {
        
        list<ivydsd__Order__c> OrderList=new list<ivydsd__Order__c>();
        map<string,decimal> ConquestIDOrdervalueMap=new map<string,decimal>();//holds conquestid.resourceid,ordervalue 
        map<string,date> ConquestIDOrderDateMap=new map<string,date>();//holds conquestid.resourceid,orderdate 
        set<id> ResourceIdset=new set<id>();
        set<id> IncentivegroupIdset=new set<id>();
        map<id,decimal> IncentivegroupIncentivevaluemap=new  map<id,decimal>();//holds incentive group,incentive value ... Each incentive group will have only 1 incentove slab in case of conquest incentives
        map<id,Target_Actual__c> TargetresourceMap=new map<id,Target_Actual__c>();//
        map<id,id> ResourceIncentiveMap=new map<id,id>();//holds resource,incentivegroup 
        map<id,set<id>> TargetAccountsCoveredIdMap=new map<id,set<id>>();//Holds Targetid,set of AccountsCovered ids
        list<Account_Target__c> AccounttargetList=new  list<Account_Target__c>();
        map<id,list<Account>> ResourceaccountMap=new map<id,list<Account>>();
        
        for(Target_Actual__c targetactual:TargetActualList){
            ResourceIdset.add(targetactual.Resource__c);
            targetactual.Actual__c=0;
        }
        
        list<Account_Target__c> OldAccountTargetList=[select Account__c,Target_Actual__r.Recordtype.developername,Target_Actual__r.Resource__c from Account_Target__c where Month__c=:date.today().Month() and Target_Actual__r.Recordtype.developername='Conquest' and Target_Actual__r.Resource__c in: ResourceIdset];
       
        delete OldAccountTargetList;
        list<Account> Accountlist=[select id,ivybase__Resource__c,(select ivydsd__Order_Value__c,ivydsd__Store__c,ivydsd__Resource__c,ivydsd__Order_Date__c from ivydsd__Orders__r where ivydsd__Order_Status__c!='Draft' order by ivydsd__Order_Date__c desc limit 2) from Account where Converted_Date__c!=Null and Converted_to_Normal_Saloon__c=true and ivybase__Resource__c in:ResourceIdset];
        System.debug('Accountlist==='+Accountlist);
        /*fetching order list from account and adding it to a list*/
        for(Account A:Accountlist){
            OrderList.addall(a.ivydsd__Orders__r);
            System.debug('OrderList==='+OrderList);
            if(ResourceaccountMap.containskey(A.ivybase__Resource__c)){
                list<Account> Acclist=ResourceaccountMap.get(A.ivybase__Resource__c);
                Acclist.add(a);
                ResourceaccountMap.put(A.ivybase__Resource__c,Acclist);
                
            }
            else{
                list<Account> Acclist=new list<Account>();
                Acclist.add(a);
                ResourceaccountMap.put(A.ivybase__Resource__c,Acclist);
            }
        }
        
        /*Iterating over order list and forming maps of conquest id with order value and conquest id woth order date ,also collecteing resource ids*/
       /* for(ivydsd__Order__c order: OrderList){
            if(ConquestIDOrdervalueMap.containskey(order.ivydsd__Store__c+'.'+order.ivydsd__Resource__c)){
                decimal totalvalue=ConquestIDOrdervalueMap.get(order.ivydsd__Store__c)+order.ivydsd__Final_Order_Value__c;
                ConquestIDOrdervalueMap.put(order.ivydsd__Store__c+'.'+order.ivydsd__Resource__c, totalvalue);  
                ConquestIDOrderDateMap.put(order.ivydsd__Store__c+'.'+order.ivydsd__Resource__c,order.ivydsd__Order_Date__c);
            }
            else{
                //   ResourceIdset.add(order.ivydsd__Resource__c);
                ConquestIDOrdervalueMap.put(order.ivydsd__Store__c+'.'+order.ivydsd__Resource__c, order.ivydsd__Final_Order_Value__c);
                ConquestIDOrderDateMap.put(order.ivydsd__Store__c+'.'+order.ivydsd__Resource__c,order.ivydsd__Order_Date__c);
                
            }
        }*/
        
        //   list<Target_Actual__c> TargetActualList=[select id,Actual__c,Resource__c,RecordType.DeveloperName,End_Date1__c,Start_Date1__c,Incentive_Group__c from Target_Actual__c  where Month__c=:date.today().Month() and Resource__c in: ResourceIdset and RecordType.DeveloperName='Conquest']; 
        
        
        for(Target_Actual__c targetactual:TargetActualList){
            if(ResourceaccountMap.containskey(targetactual.Resource__c) && ResourceaccountMap.get(targetactual.Resource__c)!=null){
            list<Account> Acclist= ResourceaccountMap.get(targetactual.Resource__c);
            system.debug('Acclist'+Acclist);
            for(Account Acc:Acclist){
                //check 1. if no of orders is > 1
                //2. check if both odf these orders are within start and end dates
                //3. chekc whther sum of order value is equal to targetactuals target
                System.debug('acc.ivydsd__Orders__r.size()====>'+acc.ivydsd__Orders__r.size());
                if(acc.ivydsd__Orders__r.size() > 1){
                    ivydsd__Order__c order1=acc.ivydsd__Orders__r[0];
                    ivydsd__Order__c order2=acc.ivydsd__Orders__r[1];
                    if(order1.ivydsd__Order_Date__c>= targetactual.Start_Date1__c && order2.ivydsd__Order_Date__c>= targetactual.Start_Date1__c && order1.ivydsd__Order_Date__c <= targetactual.End_Date1__c && order2.ivydsd__Order_Date__c <= targetactual.End_Date1__c){
                       system.debug('order1.ivydsd__Order_Date__c'+order1.ivydsd__Order_Date__c);
                        system.debug('order2.ivydsd__Order_Date__c'+order2.ivydsd__Order_Date__c);
                        system.debug('targetactual.Start_Date1__c'+targetactual.Start_Date1__c);
                        system.debug('targetactual.end'+targetactual.End_Date1__c);
                        system.debug('order1value'+order1.ivydsd__Order_Value__c);
                        system.debug('order2vae'+order2.ivydsd__Order_Value__c);
                        system.debug('targetactual'+targetactual.Target__c);
                        if(order1.ivydsd__Order_Value__c + order2.ivydsd__Order_Value__c >= targetactual.Target__c){
                            Account_Target__c AccountTarget=new Account_Target__c();
                            AccountTarget.Target_Actual__c=targetactual.id;
                            AccountTarget.Account__c=acc.id;
                            AccountTarget.Month__c=date.today().month();
                            AccounttargetList.add(AccountTarget);
                            targetactual.Actual__c=targetactual.Actual__c+order1.ivydsd__Order_Value__c + order2.ivydsd__Order_Value__c;
                        }
                    }
                }
                
                
            }
            }  
            /* IncentivegroupIdset.add(targetactual.Incentive_Group__c);
TargetresourceMap.put(targetactual.Resource__c, targetactual);
ResourceIncentiveMap.put(targetactual.Resource__c, targetactual.Incentive_Group__c);*/
        }
      /*   for(Account_Target__c Accounttarget:OldAccountTargetList){
            if(!TargetAccountsCoveredIdMap.containsKey(Accounttarget.Target_Actual__c)){
                set<id> Accountids=new set<id>();
                Accountids.add(Accounttarget.Account__c);
                TargetAccountsCoveredIdMap.put(Accounttarget.Target_Actual__c, Accountids);
            }
            else{
                set<id> Accountids=  TargetAccountsCoveredIdMap.get(Accounttarget.Target_Actual__c);
                Accountids.add(Accounttarget.Account__c);
                TargetAccountsCoveredIdMap.put(Accounttarget.Target_Actual__c, Accountids);
            }
        }
        
        list<Incentive_Slab__c> IncentiveslabList=[select Incentive__c,Incentive_Group__c from Incentive_Slab__c where Incentive_Group__c in:IncentivegroupIdset];
        for(Incentive_Slab__c incentiveslab:IncentiveslabList)
            IncentivegroupIncentivevaluemap.put(incentiveslab.Incentive_Group__c,incentiveslab.Incentive__c);
        
        for(string conquestresourceid:ConquestIDOrdervalueMap.keyset()){
            string conquestid=conquestresourceid.split('//.')[0];
            string resourceid=conquestresourceid.split('//.')[1];
            id incentivegroupid=ResourceIncentiveMap.get(resourceid);
            if(ConquestIDOrdervalueMap.get(conquestresourceid)>=IncentivegroupIncentivevaluemap.get(incentivegroupid) && !TargetAccountsCoveredIdMap.get(resourceid).contains(conquestid) && ConquestIDOrderDateMap.get(conquestresourceid) > TargetresourceMap.get(resourceid).Start_Date1__c && ConquestIDOrderDateMap.get(conquestresourceid) < TargetresourceMap.get(resourceid).End_Date1__c){
                Account_Target__c AccountTarget=new Account_Target__c();
                AccountTarget.Target_Actual__c=TargetresourceMap.get(resourceid).id;
                AccountTarget.Account__c=conquestid;
                AccountTarget.Month__c=date.today().month();
                AccounttargetList.add(AccountTarget);
            }
            
}*/
        insert AccounttargetList;
        update TargetActualList;
    }
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('OrdersInSFABatch') && vMapNameCustomSett.get('OrdersInSFABatch').SwitchOff__c==false){
          OrdersInSFABatch batch = new OrdersInSFABatch();
        database.executeBatch(batch);    
    }
    }
}