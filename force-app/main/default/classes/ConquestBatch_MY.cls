//process one record at a time
global class ConquestBatch_MY implements  Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='Select id,Resource__c,Mid_Month_Achievement__c,Product_Group__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c where  Start_Date1__c <='+tdydate+' AND End_Date1__c >='+tdydate+' AND Resource__c != null AND Parameter_type__c=\'Conquest Purchase\' AND Market_ISO__c=\'MY\' AND recordType.DeveloperName=\'Conquest\' ';
        system.debug('queru'+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        if(scope.size()>0){
           List<Account_Target__c>   exisitingAccount= new  List<Account_Target__c> ();    
      List<Account_Target__c> AccountCaptured = [select id,Account__c,Target_Actual__c from Account_Target__c where Target_Actual__c=:scope[0].id];
            for(Account_Target__c acc:AccountCaptured)
            {
                exisitingAccount.add(acc);  
               // accountoftotalcounttilldate.add(acc.Account__c);
            }
            delete exisitingAccount;
        }
        //----------deleteing end----------------
        Id incentivegroupid=scope[0].Incentive_Group__c;
        list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
        Set<Id> ProductGroupId = new Set<Id>();
        List<TargetActualProductGroupMapping__c> allPGRecords = [select Product_Group__c from TargetActualProductGroupMapping__c where Target_Actual__c=:scope[0].ID];
        For(TargetActualProductGroupMapping__c pg:allPGRecords)
        {
            if(pg.Product_Group__c!=null){
                ProductGroupId.add(pg.Product_Group__c);
            }
        }
        Map<Id,ivybase__Product_Group__c> ProductGroupMap = new Map<Id,ivybase__Product_Group__c>();
        Map<Id,Set<Id>> ProductGroupwithProductGroupDetail = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> ProductGroupDetailwithProducts = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> ProductGroupDetailwithProductHierarchy = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> ProductGroupWithProducts = new Map<Id,Set<Id>>();
        Set<Id> PHId = new Set<Id>();
        List<ivybase__Product_Group__c> productGroup = [select id, Buy_Logic_Value__c ,Buy_Logic__c,(select id,Product_Hierarchy__c ,ivybase__Product__c from ivybase__Product_Group_Details__r)  from ivybase__Product_Group__c where id=:ProductGroupId];
        for(ivybase__Product_Group__c pg:productGroup)
        {
            ProductGroupWithProducts.put(pg.id,new Set<Id>());
            ProductGroupMap.put(pg.id, pg);
            for(ivybase__Product_Group_Detail__c detail : pg.ivybase__Product_Group_Details__r){
                populateMap(ProductGroupwithProductGroupDetail,pg.id,detail.id);
                if(detail.Product_Hierarchy__c!=null)
                {
                    PHId.add(detail.Product_Hierarchy__c);
                    populateMap(ProductGroupDetailwithProductHierarchy,detail.id,detail.Product_Hierarchy__c);
                }
                ProductGroupDetailwithProducts.put(detail.id,new Set<ID>());
                if(detail.ivybase__Product__c!=null)
                {
                    populateMap(ProductGroupDetailwithProducts,detail.id,detail.ivybase__Product__c);
                }
            }
        }
        system.debug('ProductGroupDetailwithProducts'+ProductGroupDetailwithProducts);
        system.debug('ProductGroupDetailwithProductHierarchy'+ProductGroupDetailwithProductHierarchy);
        system.debug('ProductGroupwithProductGroupDetail'+ProductGroupwithProductGroupDetail);
        Map<Id,Set<Id>> ProductWithProductHierarchy=ProductHierarchyService.getAlltheProductUnderProductHierarchywithSetOfPHId(PHId);
        
        for(Id PGdetail : ProductGroupDetailwithProducts.keySet())
        {
            if(ProductGroupDetailwithProductHierarchy.containsKey(PGdetail))
            {
                Set<Id> SetOfHierarchy = ProductGroupDetailwithProductHierarchy.get(PGdetail);
                system.debug('SetOfHierarchy'+SetOfHierarchy);
                for(Id PH:SetOfHierarchy)
                {
                    Set<Id> prodId = MapClass.getSetOfKey_From_Map_With_Matching_Value(ProductWithProductHierarchy,PH);
                    system.debug('Inside prodId'+prodId);
                    if(prodId!=null)
                    {
                        ProductGroupDetailwithProducts.get(PGdetail).addAll(prodId);
                    }
                }
                
            }
        }
        system.debug('ProductGroupDetailwithProducts'+ProductGroupDetailwithProducts);
        for(Id PG:ProductGroupwithProductGroupDetail.keyset())
        {
            Set<Id> details = ProductGroupwithProductGroupDetail.get(PG);
            for(Id det:details)
            {
                if(ProductGroupDetailwithProducts.containsKey(det))
                {
                    ProductGroupWithProducts.get(PG).addAll(ProductGroupDetailwithProducts.get(det));
                }
            }
        }
        Set<Id> allProducts = new Set<Id>();
        for(Id PG:ProductGroupWithProducts.keyset())
        {
            system.debug('PG PG->'+ProductGroupWithProducts.get(PG));
            allProducts.addAll(ProductGroupWithProducts.get(PG));
        }
        list<account>  Accountlist=[select id,ivybase__Resource__c,Converted_Date__c,(select id,ivydsd__Invoice_Amount__c,ivydsd__Invoice_Date__c from ivydsd__Invoice__r ORDER by ivydsd__Invoice_Date__c ASC Limit 1 ) from Account where Converted_Date__c!=Null and Converted_to_Normal_Saloon__c=true and ivybase__Resource__c =:scope[0].Resource__c];
        set<id> satisfiedAccidsforThisMonth= new set<id>();
        if(Accountlist.size()>0){
            for(Account acc:Accountlist){
                if(acc.ivydsd__Invoice__r.size()>0){
                    for(ivydsd__Invoice__c ord:acc.ivydsd__Invoice__r){
                        if(ord.ivydsd__Invoice_Date__c >= scope[0].Start_Date1__c && ord.ivydsd__Invoice_Date__c<=scope[0].End_Date1__c){
                            satisfiedAccidsforThisMonth.add(acc.id);
                        }
                    }    
                }
            }
        }
        Map<Id,Map<Id,Decimal>> accountWithMatchedPG = new Map<Id,Map<Id,Decimal>>();
        Map<Id,Decimal> accountInvoiceLineItem = new Map<Id,Decimal>();
        List<ivydsd__Invoice_Line_Item__c> matchedInvoiceLineItem = [select id,Gross_Value__c, ivydsd__Total_Amount__c ,ivydsd__Product_Master1__c,ivydsd__Invoice__c, ivydsd__Invoice__r.ivydsd__Store__c from ivydsd__Invoice_Line_Item__c where ivydsd__Invoice__r.ivydsd__Store__c=:satisfiedAccidsforThisMonth and ivydsd__Product_Master1__c=:allProducts ];
        for(ivydsd__Invoice_Line_Item__c item : matchedInvoiceLineItem)
        {
            if(accountInvoiceLineItem.containsKey(item.ivydsd__Invoice__r.ivydsd__Store__c))
            {
                Decimal Value  =  accountInvoiceLineItem.get(item.ivydsd__Invoice__r.ivydsd__Store__c);
                Value=Value+item.ivydsd__Total_Amount__c ;
                accountInvoiceLineItem.put(item.ivydsd__Invoice__r.ivydsd__Store__c,Value);
            }else
            {
                accountInvoiceLineItem.put(item.ivydsd__Invoice__r.ivydsd__Store__c,item.ivydsd__Total_Amount__c );
            }
            for(Id PG:ProductGroupWithProducts.keyset())
            {
                if(ProductGroupWithProducts.get(PG).contains(item.ivydsd__Product_Master1__c))
                {
                    populateMap(accountWithMatchedPG,item.ivydsd__Invoice__r.ivydsd__Store__c,PG); 
                }
            }
            
        }
        system.debug('accountWithMatchedPG '+accountWithMatchedPG);
        Map<Id,Boolean> accountMatched = new Map<Id,Boolean>();
        for(Id account: accountWithMatchedPG.keyset())
        {
            Boolean matched=true;
            for(Id PG:ProductGroupWithProducts.keyset())
        {
                if(ProductGroupMap.containsKey(PG))
                {
                    if((ProductGroupMap.get(PG).Buy_Logic_Value__c!=null && accountWithMatchedPG.get(account).get(PG)==ProductGroupMap.get(PG).Buy_Logic_Value__c) || (accountWithMatchedPG.get(account).get(PG)>=1) )
                    {
                        matched=matched && true;
                        accountMatched.put(account,matched);
                    }
                    else
                    {
                        matched=matched && false;
                        accountMatched.put(account,matched);
                    }
                }
            }
        }
        set<Id> finalAccountToPopulateActual = new Set<Id>();
        for(Id account:accountMatched.keyset())
        {
            if(accountMatched.get(account))
            {
                finalAccountToPopulateActual.add(account);
            }
        }
        system.debug('finalAccountToPopulateActual'+ finalAccountToPopulateActual);
        system.debug('accountInvoiceLineItem'+ accountInvoiceLineItem);
       List<Target_Actual__c> updatetalist = new List<Target_Actual__c>();
        List<Account_Target__c> Accountcoveredupdate= new list<Account_Target__c>();
        for(Target_Actual__c Talist:scope){
            talist.Actual__c=0;
            talist.Achievement__c=0;
            for(Id account:finalAccountToPopulateActual){
                if(accountInvoiceLineItem.containsKey(account)){
                    talist.Actual__c+=accountInvoiceLineItem.get(account);
                    talist.Achievement__c+=getincnetive(incentiveslab,accountInvoiceLineItem.get(account));
                    Account_Target__c Accounttarget1=new Account_Target__c();
                            Accounttarget1.Account__c=account;
                            Accounttarget1.Target_Actual__c=Talist.id;
                            Accounttarget1.Name='Incentive earned';
                     Accountcoveredupdate.add(Accounttarget1);
                    
                }
                
            }
            updatetalist.add(talist);
        }
        update updatetalist;
        
        if(Accountcoveredupdate.size()>0){
               insert Accountcoveredupdate;
            }
        
        /*Set<Id> ProductId = new Set<Id>();
Set<Id> PHId = new Set<Id>();
Map<Integer,Id> PhMap = new Map<Integer,Id>();
Map<Integer,Set<Id>> CounterWithSetOfProductMap = new Map<Integer,set<Id>>();
Integer counter=1;
List<ivybase__Product_Group_Detail__c> detail = [select id,ivybase__Product__c,Product_Hierarchy__c,ivybase__Category__c from ivybase__Product_Group_Detail__c where ivybase__Product_Group__c=:scope[0].Product_Group__c];
for(ivybase__Product_Group_Detail__c det:detail)
{
if(det.ivybase__Product__c!=null)
{
ProductId.add(det.ivybase__Product__c);
}
if(det.Product_Hierarchy__c!=null)
{
PhMap.put(counter,det.Product_Hierarchy__c);
PHId.add(det.Product_Hierarchy__c);
}
}

Map<Id,Set<Id>> ProductWithProductHierarchy=ProductHierarchyService.getAlltheProductUnderProductHierarchywithSetOfPHId(PHId);
counter=0;
for(Integer c:PhMap.keySet())
{
if(PhMap.containsKey(c))
{
Id ProductHierarchyId = PhMap.get(c);
Set<Id> prodId = MapClass.getSetOfKey_From_Map_With_Matching_Value(ProductWithProductHierarchy,ProductHierarchyId);
if(prodId!=null)
{
CounterWithSetOfProductMap.put(c,prodId);
counter=c;
}
}
}
counter++;
CounterWithSetOfProductMap.put(counter,ProductId);


List<ivydsd__Invoice__c> relatedInvoice = [select id,ivydsd__Resource__c,ivydsd__Store__c,ivydsd__Invoice_Amount__c from ivydsd__Invoice__c where ivydsd__Resource__c != null AND ivydsd__Resource__c =:scope[0].Resource__c
AND ivydsd__Invoice_Date__c >=: scope[0].Start_Date1__c AND ivydsd__Invoice_Date__c <=:scope[0].End_Date1__c AND ivydsd__Store__c IN:Accountidset];
Map<Id,ivydsd__Invoice__c> InvoiceMap = new Map<Id,ivydsd__Invoice__c>();
Map<Id,Set<ID>> accountInvoiceId = new Map<Id,Set<Id>>();
set<Id> ALLinvoiceId = new set<Id>();
for(ivydsd__Invoice__c inv:relatedInvoice)
{
ALLinvoiceId.add(inv.id);
InvoiceMap.put(inv.id,inv);
populateMap(accountInvoiceId,inv.ivydsd__Store__c,inv.id);
}
Map<Id,Set<Id>> invoiceProductSetMap = new Map<Id,Set<Id>>();
List<ivydsd__Invoice_Line_Item__c> invoiceLineItemList = [select id,name, ivydsd__Product_Master1__c , ivydsd__Invoice__c from ivydsd__Invoice_Line_Item__c where ivydsd__Invoice__c=:ALLinvoiceId];
for(ivydsd__Invoice_Line_Item__c line:invoiceLineItemList)
{
populateMap(invoiceProductSetMap,line.ivydsd__Invoice__c,line.ivydsd__Product_Master1__c);
}
Map<Id,Set<Id>> accountwithSelectedInvoice  = new Map<Id,Set<Id>>();
for(Id account:accountInvoiceId.keyset())
{
Set<Id> invoiceId = accountInvoiceId.get(account);
for(Id invoice:invoiceId)
{
if(invoiceProductSetMap.containsKey(invoice))
{
boolean allMatch = true;
set<Id> ProductUnderInvoice = invoiceProductSetMap.get(invoice);
for(Integer i:CounterWithSetOfProductMap.keySet())
{
boolean temp = matchTwoSet(CounterWithSetOfProductMap.get(i),ProductUnderInvoice);
allMatch=(allMatch&&temp);
}
if(allMatch==true)
{
populateMap(accountwithSelectedInvoice,account,invoice);
}
}
}
}
Map<Id,Decimal> accountWithSumInvoiceValue = new Map<Id,Decimal>();
for(Id account:accountwithSelectedInvoice.keyset())
{
Decimal sumValue = 0;
Set<Id> invoice = accountwithSelectedInvoice.get(account);
for(Id invId:invoice)
{
if(InvoiceMap.containsKey(invId))
{
if(InvoiceMap.get(invId).ivydsd__Invoice_Amount__c!=null)
{
sumValue=sumValue+InvoiceMap.get(invId).ivydsd__Invoice_Amount__c;  
}
}
}
if(sumValue!=null){
accountWithSumInvoiceValue.put(account,sumValue);
}
}

for(Target_Actual__c Talist:scope){
talist.Actual__c=0;
talist.Achievement__c=0;
for(Id account:accountWithSumInvoiceValue.keyset()){
if(accountWithSumInvoiceValue.get(account)>=Talist.Target__c){
talist.Actual__c+=accountWithSumInvoiceValue.get(account);
talist.Achievement__c+=getincnetive(incentiveslab,accountWithSumInvoiceValue.get(account));
updatetalist.add(talist);
}

}
}
update updatetalist;   */
        //end of prdgroupnotnull check
        
        //end of scope check
    }
    global void finish(Database.BatchableContext bc){
        
    }
    /*public set<Id> checkproductswithproductgroupProducts(Map<Id,List<Id>> FunctionRelatedSetOfHierarchy,id prdparentid,set<id> prdgrphirId,set<id> prodgrpprdid){

if(FunctionRelatedSetOfHierarchy.containskey(prdparentid) &&  FunctionRelatedSetOfHierarchy.get(prdparentid)!=null){
//    for(id prdgrphirchyid:prdgrphirId){
//  if( FunctionRelatedSetOfHierarchy.get(prdparentid).contains(prdgrphirchyid))

// }
for(Id MatchedValue: FunctionRelatedSetOfHierarchy.get(prdparentid)){
if(prdgrphirId.contains(MatchedValue))prdgrphirId.remove(MatchedValue);
}
}
system.debug('prdgrphirId'+prdgrphirId);
return prdgrphirId;
}*/
    public static void populateMap(Map<Id,Set<Id>> givenMap,Id key,Id value)
    {
        if(givenMap.containsKey(key))
        {
            givenMap.get(key).add(value);
        }
        else
        {
            Set<Id> newSet = new Set<Id>();
            newSet.add(value);
            givenMap.put(key, newSet);
        }
    }
    public static void populateMap(Map<Id,Map<Id,Decimal>> givenMap,Id accountId,Id PG)
    {
        if(givenMap.containsKey(accountId))
        {
            if(givenMap.get(accountId).containsKey(PG))
            {
                Decimal val=givenMap.get(accountId).get(PG);
                val=val+1;
                givenMap.get(accountId).put(PG,val);
            }else
            {
                givenMap.get(accountId).put(PG,1);
            }
        }
        else
        {
            Map<Id,Decimal> PGmap = new Map<Id,Decimal>();
            PGmap.put(PG,1);
            givenMap.put(accountId,PGmap);
        }
    }
    
    public static boolean matchTwoSet(set<Id> CounterWithSetOfProductMap,Set<Id> ProductUnderInvoice)
    {
        for(Id prod:CounterWithSetOfProductMap)
        {
            if(ProductUnderInvoice.contains(prod))
            {
                return true;
            }
        }
        return false;
    }
    public static decimal getincnetive(list<Incentive_Slab__c> incntveslab, decimal ordersum){
        
        System.debug('incntveslab====>'+incntveslab);
        System.debug('ordersum====>'+ordersum);
        decimal incentive=0;
        for(Incentive_Slab__c slab : incntveslab){
            if(slab.Minimum__c<=ordersum){
                if(slab.Incentive__c!=null && slab.Incentive__c>incentive){
                    incentive= slab.Incentive__c; 
                }
            }   
        }
        system.debug('incentive'+incentive);
        return incentive;
    }
}