global class CoverageBatchClass  implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='select id,name,Is_Conquest__c,Is_Dream_List__c,Converted_to_Normal_Saloon__c, Converted_Date__c,AgreedActiveCustomer__c from account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accountlist){
        system.debug('Hi');
        try{
            DateTime TDate = System.now();
            Date todayDate = Date.newinstance(TDate.year(), TDate.month(), TDate.day());
            date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
            set<id> accid = new set<id>();  
            set<id> ProductgroupIds=new set<id>();
            set<id> prdids=new set<id>();
            set<id> AccountId=new set<id>();
            set<string> AccountProductset=new set<string>();
            set<id> AgreedActiveCustomerIds=new set<id>();
            set<id> ConquestSaloonIds=new set<id>();
            map<id,date> ConquestSaloonIdsMap=new map<id,date>();//added by pranav
            set<id> OrderedAccountIds=new set<id>();
            set<id> SKUIds=new set<id>();
            set<string> StoresWithInventoryCovered=new set<string>();
            set<string> StoresWithActivation=new set<string>();
            set<string> LocationSaloonIdsAdded=new set<string>();
            set<id> ActivatedSaloonIdsAdded=new set<id>();
            map<string,string>  targetmap=new map<string,string>();
            map<string,set<id>> AccountResourceProductMap =new map<string,set<id>>();
            map<string,set<id>> AccountResourceSKUMap =new map<string,set<id>>();
            map<ivybase__Product_Group__c,list<ivybase__Product_Group_Detail__c>> ProductGroupdetailMap=new map<ivybase__Product_Group__c,list<ivybase__Product_Group_Detail__c>>();
            map<string,string> TargetResourceMap=new map<string,string>();
            map<string,ivybase__Product_Group__c> productgroupmap=new map<string,ivybase__Product_Group__c>();
            map<string,Decimal> OrderAmountMap=new map<string,Decimal>();
            map<string,string> ResourceRecordtypemap=new  map<string,string>();
            map<string,string> AccountIdNameMap=new  map<string,string>();
            list<Account_Target__c> AccountTargetList=new list<Account_Target__c>();
            list<Target_Actual__c> TargetListTobeUpdated=new list<Target_Actual__c>();
            
            
            
            //execution starts
            for(Account s : accountlist){
                
                if(s.Is_Conquest__c==True && s.Converted_to_Normal_Saloon__c==True)//need to change this line check with nagasai because in account only checkbox need to be checked
                    ConquestSaloonIds.add(s.id);
                if(s.Converted_to_Normal_Saloon__c==True && s.Converted_Date__c!=null){//added by pranav
                    ConquestSaloonIdsMap.put(s.id,s.Converted_Date__c);
                }
                if(!s.Is_Conquest__c==True && !s.Is_Dream_List__c==True)
                    AgreedActiveCustomerIds.add(s.id);
                accid.add(s.id);
                AccountIdNameMap.put(s.id, s.name);
            }
            system.debug('accid'+accid);
            system.debug('ConquestSaloonIds'+ConquestSaloonIds);
            
            
            
            
            //Querying orders to calcualte conquest target
            map<id,list<ivydsd__Order__c>> resourceorderMap =  new map<id,list<ivydsd__Order__c>>();//added by pranav
            list<ivydsd__Order__c> orderList=[select ivydsd__Final_Order_Value__c,ivydsd__Resource__c,ivydsd__Store__c,ivydsd__Store__r.name,ivydsd__Store__r.Converted_Date__c from ivydsd__Order__c where ivydsd__Store__c in:ConquestSaloonIdsMap.keyset() AND CreatedDate =today];
            system.debug('orderList'+orderList);
            for(ivydsd__Order__c order:orderList){
                
                if(order.ivydsd__Resource__c!=null && order.ivydsd__Final_Order_Value__c>0 ){
                    if(resourceorderMap!=null && resourceorderMap.containskey(order.ivydsd__Resource__c)){
                        resourceorderMap.get(order.ivydsd__Resource__c).add(order);
                    }else{
                        list<ivydsd__Order__c> ord= new list<ivydsd__Order__c>();
                        ord.add(order);
                        resourceorderMap.put(order.ivydsd__Resource__c,ord);
                    }
                } //addded by pranav
                if(order.ivydsd__Final_Order_Value__c>0){
                    OrderedAccountIds.add(order.ivydsd__Store__c);
                    if(!OrderAmountMap.keyset().contains(order.ivydsd__Store__c))
                        OrderAmountMap.put(order.ivydsd__Store__c,order.ivydsd__Final_Order_Value__c); 
                    else{
                        Decimal finalval=OrderAmountMap.get(order.ivydsd__Store__c) +order.ivydsd__Final_Order_Value__c;
                        OrderAmountMap.put(order.ivydsd__Store__c,finalval); 
                    }
                    
                }
            }
            system.debug('OrderAmountMap'+OrderAmountMap);
            
            
            
            
            
            //querying location stock for inventory chechk CALCULATION
            list<ivybase__Location_Stock__c> InventoryList=[select id,ivybase__Visit__r.ivybase__Store__c,ivybase__Visit__r.ivybase__Store__r.name,ivybase__Visit__r.ivybase__Resource__c from ivybase__Location_Stock__c where ivybase__Visit__r.ivybase__Store__c in:accid AND CreatedDate =today];
            
            Date todayDate1 = date.Today();
            string tdydate1=string.valueOf(todayDate);//'2018-10-31';
            Date Monthtodate1=Date.newInstance(todayDate.year(),todayDate.Month(),1);
            
            
            //Querying Invoices for activation calculation
            system.debug('AgreedActiveCustomerIds'+AgreedActiveCustomerIds);
            list<ivydsd__Invoice__c> InvoiceList=[select id,ivydsd__Store__c,ivydsd__Resource__c,ivydsd__Store__r.name from ivydsd__Invoice__c where ivydsd__Store__c in:AgreedActiveCustomerIds AND ivydsd__Invoice_Date__c >=:Monthtodate1 AND ivydsd__Invoice_Date__c<=:todayDate1 ]; 
            system.debug('InvoiceList'+InvoiceList);
            
            
            //Querying sku saloons created today ,this is for coverage  calculations 
            list<SKU_SaloonSale__c> SKUSaloonSaleList=[select Product_Master__c,Account__c,InvoiceDate__c,Resource__c from SKU_SaloonSale__c where Account__c in:accid   AND createddate=today AND InvoiceDate__c >=:Monthtodate1 AND InvoiceDate__c <=:todayDate1 ];//yesterday//SKU_SaloonSale__c
            system.debug('SKUSaloonSaleList'+SKUSaloonSaleList);
            
            //querying this month target records and collecting produc groupids so that we can query only those product groups and also forming a map of resourceproductgroup and target
            // list<Target_Actual__c> TargetList=[select Product_Group__c,Target__c,Actual__c,Resource__c,Account__c,RecordType.DeveloperName,End_Date1__c,Start_Date1__c from Target_Actual__c where Start_Date1__c<=:todayDate and End_Date1__c>=:todayDate];
            list<Target_Actual__c> TargetList=[select Product_Group__c,Target__c,Actual__c,Resource__c,Account__c,RecordType.DeveloperName,End_Date1__c,Start_Date1__c from Target_Actual__c where Month__c=:todayDate.Month() AND Year__c=:todayDate.year()];
            system.debug('TargetList'+TargetList);
            
            
            for(Target_Actual__c target:TargetList){
                if(target.RecordType.DeveloperName=='Conquest'&& resourceorderMap!=null && resourceorderMap.containskey(target.Resource__c) && resourceorderMap.get(target.Resource__c)!=null){
                    system.debug('inside target if' );
                    decimal finalval=0;
                    for(ivydsd__Order__c ord:resourceorderMap.get(target.Resource__c)){//added by pranav
                        if(ord.ivydsd__Store__r.Converted_Date__c>=target.Start_Date1__c && ord.ivydsd__Store__r.Converted_Date__c<=target.End_Date1__c){
                            system.debug('inside caluclkatipn part');
                            system.debug(ord.ivydsd__Final_Order_Value__c+' finalval 0 '+finalval);
                            finalval=finalval+ord.ivydsd__Final_Order_Value__c;
                            system.debug('finalval 111'+finalval);
                            
                        }
                    }
                    target.Actual__c= target.Actual__c+finalval;      
                    system.debug('TargetListTobeUpdated'+TargetListTobeUpdated);
                    TargetListTobeUpdated.add(target );  
                }
                //Calcuating Conquest targets and adding them to target list
                System.debug('OrderedAccountIds::: '+OrderedAccountIds);
                /**if(target.Account__c!=Null && OrderedAccountIds.contains(target.Account__c) && target.RecordType.DeveloperName=='Conquest' && target.Account__r.Converted_Date__c>=target.Start_Date1__c && target.Account__r.Converted_Date__c<=target.End_Date1__c)
{
target.Actual__c=OrderAmountMap.get(target.Account__c);
TargetListTobeUpdated.add(target ); 
}**/
                
                // conquest target calcualtion ends
                
                
                ProductgroupIds.add(target.Product_Group__c);
                TargetResourceMap.put(target.Resource__c+'.'+target.Product_Group__c,target.id);
                ResourceRecordtypemap.put(target.Resource__c+'.'+target.RecordType.DeveloperName,target.id);
            }
            system.debug('TargetResourceMap'+TargetResourceMap);
            system.debug('ResourceRecordtypemap'+ResourceRecordtypemap);
            
            
            
            
            //querying account targets and forming AccountProductgroup id set
            for(Account_Target__c AccountTarget:[select Account__c,Product_Group__c,Target_Actual__r.Recordtype.developername,Target_Actual__r.Resource__c from Account_Target__c where Month__c=:todayDate.Month()]){
                System.debug('AccountTarget::'+AccountTarget);
                if(AccountTarget.Target_Actual__r.Recordtype.developername=='Coverage')
                    AccountProductset.add(AccountTarget.Account__c+'.'+AccountTarget.Product_Group__c);
                if(AccountTarget.Target_Actual__r.Recordtype.developername=='Inventory_Check')
                    StoresWithInventoryCovered.add(AccountTarget.Account__c+'.'+AccountTarget.Target_Actual__r.Resource__c);
                if(AccountTarget.Target_Actual__r.Recordtype.developername=='Activation')
                    StoresWithActivation.add(AccountTarget.Account__c+'.'+AccountTarget.Target_Actual__r.Resource__c);
                
            }
            system.debug('AccountProductset'+AccountProductset);
            system.debug('ProductgroupIds'+ProductgroupIds);
            
            
            
            //querying proudct group
            list<ivybase__Product_Group__c> productgrouplist=[select id,name,Buy_Logic_Value__c,Buy_Logic__c,(select id,Is_Mandatory__c,Product_Hierarchy__c,recordtype.developername,ivybase__Product__c from ivybase__Product_Group_Details__r) from ivybase__Product_Group__c where id in:ProductgroupIds];
            system.debug('productgrouplist'+productgrouplist);
            
            
            
            //Coecting SKU IDs  from skusaloon sale
            for(SKU_SaloonSale__c skusaloonsale:SKUSaloonSaleList){
                SKUIds.add(skusaloonsale.Product_Master__c);
            }
            map<string,string> SKUProducthiearchymap=ProductHierarchyService.getAllProductHierarchy_MAP_For_The_SKU(SKUIds, 'brand');
            system.debug('SKUProducthiearchymap'+SKUProducthiearchymap);
            
            
            //itertaing over sku saloons and forming a map of Account and itsrespective productskusIds
            for(SKU_SaloonSale__c skusaloonsale:SKUSaloonSaleList){
                set<id> prdid=new set<id>();
                if(!AccountResourceProductMap.keyset().contains(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c)){
                    
                    prdid.add(SKUProducthiearchymap.get(skusaloonsale.Product_Master__c));
                    AccountResourceProductMap.put(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c,prdid);
                }
                else{
                    prdid.addall(AccountResourceProductMap.get(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c));
                    prdid.add(SKUProducthiearchymap.get(skusaloonsale.Product_Master__c));
                    AccountResourceProductMap.put(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c,prdid);
                }
            }
            system.debug('AccountResourceProductMap'+AccountResourceProductMap);
            
            
            
            //sku AccountResourceSKUMap SKUIDset
            for(SKU_SaloonSale__c skusaloonsale:SKUSaloonSaleList){
                set<id> SKUIDset=new set<id>();
                if(!AccountResourceSKUMap.keyset().contains(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c)){
                    
                    SKUIDset.add(skusaloonsale.Product_Master__c);
                    AccountResourceSKUMap.put(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c,SKUIDset);
                }
                else{
                    SKUIDset.addall(AccountResourceSKUMap.get(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c));
                    SKUIDset.add(skusaloonsale.Product_Master__c);
                    AccountResourceSKUMap.put(skusaloonsale.Account__c+'.'+skusaloonsale.Resource__c,SKUIDset);
                }
            }
            
            
            
            //iterating over productgroup list and forming a map of productgroup and respective productgroupdteails
            for(ivybase__Product_Group__c p:productgrouplist){
                ProductGroupdetailMap.put(p, p.ivybase__Product_Group_Details__r);
                productgroupmap.put(p.id,p);
            }
            system.debug('ProductGroupdetailMap'+ProductGroupdetailMap);
            
            
            
            
            
            //(coverage calculations)Iterating over accounts and passing Account,its respective productskuids, productgroup and its respecive productgroupdetais
            for(string Accountresourceid:AccountResourceProductMap.keyset()){
                id AccounId=Accountresourceid.split('\\.')[0];
                id resourceId=Accountresourceid.split('\\.')[1];
                System.debug('AccounId::'+AccounId);
                System.debug('resourceId::'+resourceId);
                map<id,set<id>> AccountProductMap =new map<id,set<id>>();
                map<id,set<id>> AccountSkuMap =new map<id,set<id>>();
                AccountProductMap.put(AccounId,AccountResourceProductMap.get(Accountresourceid));
                AccountSkuMap.put(AccounId,AccountResourceSKUMap.get(Accountresourceid));
                for(ivybase__Product_Group__c p:productgrouplist){
                    
                    map<ivybase__Product_Group__c,list<ivybase__Product_Group_Detail__c>> ProductGroupdetailMap1=new map<ivybase__Product_Group__c,list<ivybase__Product_Group_Detail__c>>();
                    ProductGroupdetailMap1.put(p,ProductGroupdetailMap.get(p));
                    system.debug('AccountProducthierarchyMap.values'+AccountProductMap.values());
                    system.debug('AccountSkuMap.values'+AccountSkuMap.values());
                    system.debug('ProductGroupdetailMap1'+ProductGroupdetailMap1.values());
                    system.debug('p.name'+p.name);
                    Boolean IsExisted;
                    IsExisted=  ProductGroupService.CheckbrandInProductGroup(AccountProductMap, AccountSkuMap,ProductGroupdetailMap1);
                    system.debug('IsExisted'+IsExisted);
                    if(IsExisted){
                        targetmap.put(resourceId+'.'+p.id,AccounId);
                        string resourceproductid=resourceId+'.'+p.id;
                        system.debug('resourceproductid'+resourceproductid);
                        if(TargetResourceMap.keyset().contains(resourceproductid) && !AccountProductset.contains(targetmap.get(resourceproductid)+'.'+resourceproductid.split('\\.')[1])){
                            system.debug('enter');
                            Account_Target__c Accounttarget=new Account_Target__c();
                            Accounttarget.Account__c=targetmap.get(resourceproductid);
                            Accounttarget.name= AccountIdNameMap.get(targetmap.get(resourceproductid));
                            Accounttarget.Target_Actual__c=TargetResourceMap.get(resourceproductid);
                            Accounttarget.Product_Group__c=resourceproductid.split('\\.')[1];
                            Accounttarget.month__c= todayDate.Month();
                            AccountTargetList.add(Accounttarget);
                            // AccountProductset.add(targetmap.get(resourceproductid));
                        }
                    }
                }
            }
            
            
            
            
            
            
            //iterating over invoices and creating activation targets
            
            
            /*for(ivydsd__Invoice__c Invoice:InvoiceList){
//checking for respective resorce target record for Activation and also checking for previous Accounts if any
system.debug('enterActivation');
if(ResourceRecordtypemap.keySet().contains(Invoice.ivydsd__Resource__c+'.'+'Activation') && !StoresWithActivation.contains(Invoice.ivydsd__Store__c+'.'+Invoice.ivydsd__Resource__c) && !ActivatedSaloonIdsAdded.contains(Invoice.ivydsd__Store__c)){
system.debug('Activation');
ActivatedSaloonIdsAdded.add(Invoice.ivydsd__Store__c);
Account_Target__c Accounttarget=new Account_Target__c();
Accounttarget.Account__c=Invoice.ivydsd__Store__c;
Accounttarget.name=  Invoice.ivydsd__Store__r.name;
Accounttarget.month__c= todayDate.Month();
Accounttarget.Target_Actual__c=ResourceRecordtypemap.get(Invoice.ivydsd__Resource__c+'.'+'Activation');
AccountTargetList.add(Accounttarget); 
System.debug('AccountTargetList::'+AccountTargetList);
}
} */
            
            
            
            
            
            // iterating over inventory and creating inventory target records
            
            
            for(ivybase__Location_Stock__c inventory:InventoryList){
                //checking for respective resorce target record for inventory check and also checking for previous Accounts if any
                if(ResourceRecordtypemap.keySet().contains(inventory.ivybase__Visit__r.ivybase__Resource__c +'.'+'Inventory_Check') && !StoresWithInventoryCovered.contains(inventory.ivybase__Visit__r.ivybase__Store__c+'.'+inventory.ivybase__Visit__r.ivybase__Resource__c) && !LocationSaloonIdsAdded.contains(inventory.ivybase__Visit__r.ivybase__Store__c)){
                    LocationSaloonIdsAdded.add(inventory.ivybase__Visit__r.ivybase__Store__c);
                    Account_Target__c Accounttarget=new Account_Target__c();
                    Accounttarget.Account__c=inventory.ivybase__Visit__r.ivybase__Store__c;
                    Accounttarget.name=inventory.ivybase__Visit__r.ivybase__Store__r.name;                       
                    Accounttarget.month__c= todayDate.Month();
                    Accounttarget.Target_Actual__c=    ResourceRecordtypemap.get(inventory.ivybase__Visit__r.ivybase__Resource__c   +'.'+'Inventory_Check');
                    AccountTargetList.add(Accounttarget); 
                }
            } 
            
            system.debug('AccountTargetList'+AccountTargetList);
            if(AccountTargetList.size()>0)
                insert  AccountTargetList;
            if(TargetListTobeUpdated.size()>0)
                update TargetListTobeUpdated;
        }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('QuantityBatchClass') && vMapNameCustomSett.get('QuantityBatchClass').SwitchOff__c==false){
            QuantityBatchClass batch = new QuantityBatchClass();
            Database.executeBatch(batch);
        }
    }
}