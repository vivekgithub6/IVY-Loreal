public class CustomerInfoService {
   public static List<Document__c> getRetailerCheck(Set<Id> retailerIds){
        List<Document__c> documents = new List<Document__c>();
        String[] documentFields = new String[] {'Name','Available__c','Retailer__c','Document_Name__c'};
            String[] storeFields = new String[] {'ivybase__Internal_Id__c'};
                if(SecurityUtility.checkIsAccessible('Document__c', documentFields)
                   && SecurityUtility.checkIsAccessible('Account', storeFields)){
                       documents   = [Select Name,Available__c,Retailer__c,Document_Name__c,Retailer__r.ivybase__Internal_Id__c from Document__c where Retailer__c !=null AND Retailer__c IN : retailerIds];
                   }
        
        return documents;
    }
    public static Map<string,Date> getLastInvoiceDate(Set<Id> retailerIds){
        List<SaloonInvoice__c> salonInvoice = new List<SaloonInvoice__c>();
        Map<string,Date> salonLastInvMap = new Map<string,Date>();
        Id resId = ResourceService.getLoginSellerId();
        String[] SalInvFields = new String[] {'Account__c','Last_Visit_Date__c','LastInvoiceDate__c','Resource__c'};
            if(SecurityUtility.checkIsAccessible('SaloonInvoice__c', SalInvFields)){
                        System.debug('retailerIds in salonInv::'+retailerIds);
                       salonInvoice   = [Select Account__c,Last_Visit_Date__c,LastInvoiceDate__c,Resource__c,Division__c from SaloonInvoice__c where Account__c !=null AND Account__c IN : retailerIds AND Resource__c=:resId];
                }
        System.debug('salonInvoice::'+salonInvoice);
        for(SaloonInvoice__c salon :salonInvoice){
            salonLastInvMap.put(salon.Account__c,salon.LastInvoiceDate__c);
        }
        System.debug('salonLastInvMap::'+salonLastInvMap);
        return salonLastInvMap;
        
    }
    public static Map<string,Decimal> getAvgOrderValue(Set<Id> retailerIds){
        List<SaloonInvoice__c> salonInvoice = new List<SaloonInvoice__c>();
        Map<string,Decimal> salonLastInvMap = new Map<string,Decimal>();
        Id resId = ResourceService.getLoginSellerId();
        String[] SalInvFields = new String[] {'Account__c','Average_Order_Value__c','LastInvoiceDate__c','Resource__c'};
            if(SecurityUtility.checkIsAccessible('SaloonInvoice__c', SalInvFields)){
                        System.debug('retailerIds in salonInv::'+retailerIds);
                       salonInvoice   = [Select Account__c,Average_Order_Value__c,LastInvoiceDate__c,Resource__c,division__c from SaloonInvoice__c where Account__c !=null AND Account__c IN : retailerIds AND Resource__c=:resId];
                }
        System.debug('salonInvoice::'+salonInvoice);
        for(SaloonInvoice__c salon :salonInvoice){
            salonLastInvMap.put(salon.Account__c,salon.Average_Order_Value__c);
        }
        System.debug('salonLastInvMap::'+salonLastInvMap);
        return salonLastInvMap;
        
    }
    public static Map<string,Date> getLastVisitDate(Set<Id> retailerIds){
        List<SaloonInvoice__c> salonInvoice = new List<SaloonInvoice__c>();
        Map<string,Date> salonLastVisitMap = new Map<string,Date>();
        Id resId = ResourceService.getLoginSellerId();
        String[] SalInvFields = new String[] {'Account__c','Last_Visit_Date__c','LastInvoiceDate__c','Resource__c'};
           if(SecurityUtility.checkIsAccessible('SaloonInvoice__c', SalInvFields)){
                       salonInvoice   = [Select Account__c,Last_Visit_Date__c,division__c,LastInvoiceDate__c,Resource__c from SaloonInvoice__c where Account__c !=null AND Account__c IN : retailerIds AND Resource__c=:resId];
                }
        for(SaloonInvoice__c salon :salonInvoice){
            salonLastVisitMap.put(salon.Account__c,salon.Last_Visit_Date__c);
        }
        return salonLastVisitMap;
        
    }
    public static Map<Id,Decimal> getYTDValue(Set<Id> retailerIds){
        Map<Id,Decimal> YTDMap = new Map<Id,Decimal>();
        Id resId = ResourceService.getLoginSellerId();
        AggregateResult[] groupedResults = [select SUM(Total_Amount__c)Amt,ivydsd__Store__c,ivydsd__Resource__c from ivydsd__Invoice__c  where ivydsd__Store__c in:retailerIds
                                            AND ivydsd__Invoice_Date__c = THIS_YEAR AND ivydsd__Resource__c =:resId
                                            group by ivydsd__Store__c,ivydsd__Resource__c];        
        System.debug('groupedResults:::' +groupedResults);    
        if(groupedResults.size()>0){
            Decimal d=    (Decimal)groupedResults[0].get('Amt');
            for(AggregateResult ar : groupedResults){ 
                if( (string)ar.get('ivydsd__Store__c')!=Null){
                    //Decimal totalMonths = (Decimal)Date.today().month();
                    YTDMap.put((Id)ar.get('ivydsd__Store__c'),(Decimal)ar.get('Amt'));
                }
            }
        }
        
        return YTDMap;
    }
    public static map<string,Decimal> getRetailerSalesContribution(){
        list<string> SubAxeNames=new list<string>();
        map<string,string> AccountIDmap=new  map<string,string>();
        map<string,string> SubaxenameLovIdMap=new  map<string,string>();
        String[] TurnoverFields = new String[] {'Sales_Value__c','Account__c','Product_Hierarchy__c'};
            String[] ProducthierarchyFields = new String[] {'name','Recordtype.developername','ivybase__Internal_Id__c'};
          String[] AccountFields = new String[] {'id','ivybase__Internal_Id__c'};
          
               if(SecurityUtility.checkIsAccessible('Turnover__c', TurnoverFields) && SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c', ProducthierarchyFields) && SecurityUtility.checkIsAccessible('Account', AccountFields))
                {
        try{
                  system.debug('StandardListMasterservice123'+StandardListMasterservice.getStandardListUsingListType(new List<String>{('SUB_AXE_LEVEL')}));
           
        for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('SUB_AXE_LEVEL')})){
       system.debug('devdwwhjdbj'+stdListMaster.ivybase__List_Name__c);
            SubAxeNames.add(stdListMaster.ivybase__List_Name__c);
           SubaxenameLovIdMap.put(stdListMaster.ivybase__List_Name__c.toLowerCase(), stdListMaster.Name); 
        }
            system.debug('SubaxenameLovIdMap'+SubaxenameLovIdMap);
            Id resId = ResourceService.getLoginSellerId();
             list<Turnover__c> TurnoverList=[select name,Resource__c,Account__r.ivybase__Internal_Id__c,Product_Hierarchy__r.ivybase__Internal_Id__c,Product_Hierarchy__r.name,Sales_Value__c from Turnover__c where Product_Hierarchy__r.Recordtype.developername='Sub_Axe' and Account__c!=Null  and  month__c <=:date.today().month()  AND Year__c=:date.today().year() and Resource__c=:resId];//date.today().month()
           System.debug('TurnoverList::'+TurnoverList);
            map<string,Decimal> AccprodSalesValueMap=new map<string,Decimal>();
                    for(Turnover__c t:TurnoverList){
                        //system.debug('enter if');
                        //system.debug('Condiiton check'+AccprodSalesValueMap.containskey(SubaxenameLovIdMap.containskey(t.Product_Hierarchy__r.name.tolowercase())+'.'+t.Product_Hierarchy__r.ivybase__Internal_Id__c+'.'+t.Account__r.ivybase__Internal_Id__c));
                       system.debug('ph name'+t.Product_Hierarchy__r.name);
                       // if(AccprodSalesValueMap.containskey(SubaxenameLovIdMap.get(t.Product_Hierarchy__r.name.tolowercase())) && AccprodSalesValueMap.containskey(SubaxenameLovIdMap.get(t.Product_Hierarchy__r.name.tolowercase())+'.'+t.Product_Hierarchy__r.ivybase__Internal_Id__c+'.'+t.Account__r.ivybase__Internal_Id__c)){
                         //system.debug(t.Name+'ttttt'+t.Product_Hierarchy__r.name);
                           // decimal val= AccprodSalesValueMap.get(SubaxenameLovIdMap.containskey(t.Product_Hierarchy__r.name.tolowercase())+'.'+t.Product_Hierarchy__r.ivybase__Internal_Id__c+'.'+t.Account__r.ivybase__Internal_Id__c)+t.Sales_Value__c;
                            //AccprodSalesValueMap.put(SubaxenameLovIdMap.get(t.Product_Hierarchy__r.name.tolowercase())+'.'+t.Product_Hierarchy__r.ivybase__Internal_Id__c+'.'+t.Account__r.ivybase__Internal_Id__c, val);
                        //}else{
                            //system.debug('else'+AccprodSalesValueMap);
                           
                            AccprodSalesValueMap.put(SubaxenameLovIdMap.get(t.Product_Hierarchy__r.name.tolowercase())+'.'+t.Product_Hierarchy__r.ivybase__Internal_Id__c+'.'+t.Account__r.ivybase__Internal_Id__c+'.'+t.id, t.Sales_Value__c);
                        //}
                    }
          system.debug('AccprodSalesValueMap'+AccprodSalesValueMap.values());      
        return AccprodSalesValueMap;
        }
        Catch(Exception e){
        system.debug('error123'+e.getMessage());
            return null;
        }
                }
        else{
                 throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
   
        }
        
    }
       public static list<Contract__c> getContractList(){
         String[] ContractFields = new String[] {'Account__c','Internal_Id__c','Description__c','Contract_Value__c','Start_Date__c','End_Date__c','Status__c','Contract_Type__c'};
             String[] AccountFields =new string[] {'ivybase__Internal_Id__c'};
                if(SecurityUtility.checkIsAccessible('Contract__c', ContractFields) && SecurityUtility.checkIsAccessible('Account', AccountFields)){
            
    list<Contract__c> ContractList=[select Account__r.ivybase__Internal_Id__c,Internal_Id__c,Description__c,Contract_Value__c,Start_Date__c,End_Date__c,Status__c,Contract_Type__c from Contract__c where ( (Start_Date__c<=:date.today() AND End_Date__c>=:date.today()) OR ((Start_Date__c=Null OR Start_Date__c<=:date.today()) AND (End_Date__c=Null OR End_Date__c>=:date.today())))];
        system.debug('ContractList'+ContractList);
                    return ContractList;
                } 
                     else{
                 throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
   
        }
    }
    
    //get retailer mag details
    public static list<Account> getAccounts(Set<Id> retailerIds)
    {
        system.debug('retailerIds'+retailerIds);
        list<Account> accounts=new list<Account>();
        for(Account a:[select id,ivybase__Internal_Id__c,No_of_Stylist__c,No_of_Chairs__c,No_of_Backwash_Units__c,Color_Price__c,Treatment_Price__c,Cutting_Price__c,Blow_Dry_Price__c,Texture_Price__c,Key_Competitor__c,Customer_Attribute1__c,
                       Customer_Attribute2__c,Customer_Attribute3__c,Customer_Attribute4__c,Customer_Attribute5__c from Account where id in :retailerIds])
        {
			accounts.add(a);            
        }
        return accounts;
    }
}