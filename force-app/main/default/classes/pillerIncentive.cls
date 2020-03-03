public class pillerIncentive {
    public static void ProcessTargetActualAndCreateUniqueAccountCovered(List<Target_Actual__c> tarActRec)
    {
        Set<Id> ProductId = new Set<Id>();
        Set<Id> PHId = new Set<Id>();
        Set<Id> ResourceId = new Set<Id>();
        Date startDate;
        set<Id> targetId = new Set<Id>();
        Date EndDate;
        Map<Integer,Id> PhMap = new Map<Integer,Id>();
        Map<Integer,Set<Id>> CounterWithSetOfProductMap = new Map<Integer,set<Id>>();
        Integer counter=1;   
        set<Id> ProductGroupId = new Set<Id>();
        list<Target_Actual__c> targetupdate= new list<Target_Actual__c>();
        for(Target_Actual__c tar:tarActRec)
        {
            targetId.add(tar.Id);
            startDate=startDate==null?tar.Start_Date1__c:tar.Start_Date1__c<startDate?tar.Start_Date1__c:startDate;
            EndDate=EndDate==null?tar.End_Date1__c:tar.End_Date1__c>EndDate?tar.End_Date1__c:EndDate;
            
            if(tar.Product_Group__c!=null){
                ProductGroupId.add(tar.Product_Group__c);
            }
            if(tar.Resource__c!=null)
            {
                ResourceId.add(tar.Resource__c);
            }
        }
        //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:tarActRec[0].Incentive_Group__c ];
        
        List<ivybase__Product_Group_Detail__c> detail = [select id,ivybase__Product__c,Product_Hierarchy__c,ivybase__Category__c from ivybase__Product_Group_Detail__c where ivybase__Product_Group__c=:ProductGroupId];
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
        if(ProductId.size()>0){
            CounterWithSetOfProductMap.put(counter,ProductId);
        }
        List<ivydsd__Invoice__c> relatedInvoice = [select id,ivydsd__Resource__c,ivydsd__Store__c,ivydsd__Store__r.Name,ivydsd__Invoice_Amount__c,(select id,name,ivydsd__Product_Master1__c,ivydsd__Invoice__c from ivydsd__Invoice_Line_Items__r) from ivydsd__Invoice__c where ivydsd__Resource__c != null AND ivydsd__Resource__c =:ResourceId
                                                   AND ivydsd__Invoice_Date__c >=: startDate AND ivydsd__Invoice_Date__c <=:EndDate];
        Map<Id,ivydsd__Invoice__c> InvoiceMap = new Map<Id,ivydsd__Invoice__c>();
        Map<Id,Set<ID>> accountInvoiceId = new Map<Id,Set<Id>>();
        Map<Id,String> AccountIdNameMap = new Map<Id,String>();
        set<Id> ALLinvoiceId = new set<Id>();
        Map<Id,Set<Id>> invoiceProductSetMap = new Map<Id,Set<Id>>();
        set<id> totalaccidcovered= new set<id>();
        for(ivydsd__Invoice__c inv:relatedInvoice)
        {
            AccountIdNameMap.put(inv.ivydsd__Store__c,inv.ivydsd__Store__r.Name);
            ConquestBatch_MY.populateMap(accountInvoiceId,inv.ivydsd__Store__c,inv.id);
            for(ivydsd__Invoice_Line_Item__c lineItem:inv.ivydsd__Invoice_Line_Items__r)
            {
                ConquestBatch_MY.populateMap(invoiceProductSetMap,lineItem.ivydsd__Invoice__c,lineItem.ivydsd__Product_Master1__c);
            }
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
                        boolean temp = ConquestBatch_MY.matchTwoSet(CounterWithSetOfProductMap.get(i),ProductUnderInvoice);
                        allMatch=(allMatch&&temp);
                    }
                    if(allMatch==true)
                    {
                        ConquestBatch_MY.populateMap(accountwithSelectedInvoice,account,invoice);
                    }
                }
            }
        }
        Set<Id> AccountWithAtleast2Invoice = new Set<Id>();
        for(Id account:accountwithSelectedInvoice.keyset())
        {
            if(accountwithSelectedInvoice.get(account).size()>=2)
            {
                AccountWithAtleast2Invoice.add(account); 
            }
        }
        set<Id> exisitingAccount = new Set<Id>();
        List<Account_Target__c> AccountCaptured = [select id,Account__c,Target_Actual__c from Account_Target__c where Target_Actual__c=:targetId];
        for(Account_Target__c acc:AccountCaptured)
        {
            exisitingAccount.add(acc.Account__c); 
             totalaccidcovered.add(acc.Account__c);
        }
        AccountWithAtleast2Invoice.removeALl(exisitingAccount);
        totalaccidcovered.addall(AccountWithAtleast2Invoice);
        List<Account_Target__c> toInsert = new List<Account_Target__c>();
        for(Target_Actual__c tar:tarActRec)
        {
            if(tar.Target__c!=0){
              decimal finalpercent=(totalaccidcovered.size()/tar.Target__c)*100;
            tar.Achievement__c=ConquestBatch_MY.getincnetive(incentiveslab,finalpercent);
            }
            for(Id Acc : AccountWithAtleast2Invoice)
            {
                Account_Target__c accTar = new Account_Target__c();
                accTar.Account__c=acc;
                accTar.Target_Actual__c=tar.id;
                if(AccountIdNameMap.containskey(acc))
                {
                    accTar.Name=AccountIdNameMap.get(acc);
                }
                toInsert.add(accTar);
            }
           targetupdate.add(tar); 
        }
        if(toInsert.size()>0){
        insert toInsert;
        }
        
        if(targetupdate.size()>0){
          update  targetupdate; 
        }
    }
}