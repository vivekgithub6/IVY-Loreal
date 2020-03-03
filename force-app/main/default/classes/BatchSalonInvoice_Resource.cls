global class BatchSalonInvoice_Resource implements Database.Batchable<sobject> 
{
    // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator('Select id,CurrencyIsoCode from Account where ivybase__Active__c=\'Yes\'' );//id=\'001f400000R9jGlAAJ\' AND id=\'0019D00000361fgQAA\' AND
        
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<Account> Accountlist) {
        Map<String,Decimal> ResDivAccAvgOrderMap = new Map<String,Decimal>();
        Map<String,Date> ResDivAccLastVisitDateMap = new Map<String,Date>();
        Map<String,List<Date>> ResDivAccInvoiceDateMap = new Map<String,List<Date>>();
        Map<id,string> AccountCurrencyMap=new map<id,String>();
        for(Account acclis:Accountlist){
           AccountCurrencyMap.put(acclis.id,acclis.CurrencyIsoCode); 
        }
        list<AggregateResult> AggregateResults = [select avg(ivydsd__Order_Value__c)Amt,ivydsd__Resource__c from ivydsd__Order__c where ivydsd__Order_Date__c = THIS_YEAR and ivydsd__Store__c=:Accountlist[0].id AND ivydsd__Order_Status__c='Invoiced' group by ivydsd__Resource__c];
        for(AggregateResult ar:AggregateResults)
        {
            system.debug('AR'+ar);
            Decimal Value = (Decimal)ar.get('Amt');
            Id ResourceId = Id.valueOf((string)ar.get('ivydsd__Resource__c'));
            //Id divisionId = Id.valueOf((string)ar.get('Division__c'));
            Id AccountId = Accountlist[0].id;
            ResDivAccAvgOrderMap.put(ResourceId+'-'+AccountId,Value);
        }
        System.debug('PopulateResDivAccAvgOrderMap'+ResDivAccAvgOrderMap);  
        list<ivybase__Resource__c> ResourceInvoiceList = [select id,name,(select ivydsd__Invoice_Date__c,ivydsd__Resource__c,ivydsd__Order__c,ivydsd__Store__c,Division__c  from ivydsd__Invoice__r where ivydsd__Store__c=:Accountlist[0].id  and createddate=today order by ivydsd__Invoice_Date__c desc ),(select ivybase__Visit_Date__c,ivybase__Resource__c,ivybase__Store__c from ivybase__Visits__r where ivybase__Store__c=:Accountlist[0].id and ivybase__Visit_Date__c=LAST_N_DAYS:365 order by ivybase__Visit_Date__c desc) from ivybase__Resource__c];
        for(ivybase__Resource__c r:ResourceInvoiceList)
        {
            system.debug('TOtal Visit list '+r.ivybase__Visits__r.size());
            if(r.ivybase__Visits__r.size()>0)
            {
                for(ivybase__Visit__c visit:r.ivybase__Visits__r){
                    Id resourceId = visit.ivybase__Resource__c;
                    Id StoreId = visit.ivybase__Store__c;
                   // Id divisionId = visit.Division__c ;
                    Date lastVisitDate =visit.ivybase__Visit_Date__c;
                    if(resourceId!=null && StoreId!=null )
                    {
                        
                        String Key=resourceId+'-'+StoreId;
                        if(ResDivAccLastVisitDateMap.containsKey(Key)==false)
                        {
                            ResDivAccLastVisitDateMap.put(Key,lastVisitDate);        
                        }
                        
                    }
                }
                
            }
            if(r.ivydsd__Invoice__r.size()>0)
            {
                
                for(ivydsd__Invoice__c inv:r.ivydsd__Invoice__r)
                {
                    system.debug('Date'+inv.ivydsd__Invoice_Date__c);
                    Id resourceId = inv.ivydsd__Resource__c;
                    Id StoreId = inv.ivydsd__Store__c;
                    //Id divisionId = inv.Division__c ;
                    Date invoiceDate =inv.ivydsd__Invoice_Date__c;
                    if(resourceId!=null && StoreId!=null )
                    {
                        String key=resourceId+'-'+StoreId;
                        if(ResDivAccInvoiceDateMap.containsKey(key))
                        {
                            if(ResDivAccInvoiceDateMap.get(key).size()<2)
                            {
                                List<Date> invoiceDateList =  ResDivAccInvoiceDateMap.get(key);
                                Date lastInvDate = invoiceDateList[0];
                                Integer monthsBetween = lastInvDate.monthsBetween(invoiceDate);
                                if(monthsBetween<0){
                                monthsBetween=(-1)*monthsBetween;
                                }
                                if(monthsBetween>0){
                                    ResDivAccInvoiceDateMap.get(key).add(invoiceDate);             
                                }
                            }
                            
                        }
                        else
                        {
                            List<Date> invoiceDateList = new List<Date>();
                            invoiceDateList.add(invoiceDate);
                            ResDivAccInvoiceDateMap.put(key,invoiceDateList);         
                        }
                        
                    }
                }
            }
            
        }
        system.debug('ResDivAccLastVisitDateMap'+ResDivAccLastVisitDateMap);
        system.debug('ResDivAccInvoiceDateMap'+ResDivAccInvoiceDateMap);
        Map<String,Id> resAccDivComboSalonInvoiceId = new Map<String,Id>();
        Map<Id,SaloonInvoice__c> ExisitngsalonInvoiceMap = new Map<Id,SaloonInvoice__c>();
        list<SaloonInvoice__c> ExistingSaloonInvoiceList =[select Average_Order_Value__c,CurrencyIsoCode,LastInvoiceDate__c,Last_Visit_Date__c,Resource__c,Account__c,SecondLastInvoiceDate__c from SaloonInvoice__c where Account__c=:Accountlist[0].id];
        for(SaloonInvoice__c s:ExistingSaloonInvoiceList)
        {
            ExisitngsalonInvoiceMap.put(s.id,s);
            Id resourceId = s.Resource__c;
            Id accountId = s.Account__c;
            //Id divisionId = s.Division__c;
            if(resourceId!=null && accountId!=null)
            {
                String key=resourceId+'-'+accountId;
                if(resAccDivComboSalonInvoiceId.containsKey(key)==false)
                {
                    resAccDivComboSalonInvoiceId.put(key,s.Id);
                }
            }
        }
        List<SaloonInvoice__c> upsertSaloonInvoice = new List<SaloonInvoice__c>();
        //creating or updating saloonInvoiceRecords
        Set<String> allKey =new Set<String>();
        allKey.addAll(ResDivAccInvoiceDateMap.keyset());
        allKey.addAll(ResDivAccLastVisitDateMap.keyset());
        for(String key:allKey)
        {
            //if exisiting record is there
            if(resAccDivComboSalonInvoiceId.containsKey(key))
            {
                Id existingRecId = resAccDivComboSalonInvoiceId.get(key);
                if(ExisitngsalonInvoiceMap.containsKey(existingRecId))
                {
                    SaloonInvoice__c exisitingRec = ExisitngsalonInvoiceMap.get(existingRecId);
                    if(ResDivAccLastVisitDateMap.containsKey(key))
                    {
                        if(exisitingRec.Last_Visit_Date__c<ResDivAccLastVisitDateMap.get(key)){
                            exisitingRec.Last_Visit_Date__c=ResDivAccLastVisitDateMap.get(key);
                        }
                    }
                    if(ResDivAccAvgOrderMap.containsKey(key))
                    {
                        exisitingRec.Average_Order_Value__c=ResDivAccAvgOrderMap.get(key);
                    }else{
                        exisitingRec.Average_Order_Value__c=0;
                    }
                    //if last invoice date is null , populate only last invoice
                    if(exisitingRec.LastInvoiceDate__c==null)
                    {
                        if(ResDivAccInvoiceDateMap.containsKey(key))
                        {
                            List<Date> invoiceDate = ResDivAccInvoiceDateMap.get(key);
                            if(invoiceDate.size()>0)
                            {
                                exisitingRec.LastInvoiceDate__c=invoiceDate[0];  
                            }
                            if(invoiceDate.size()>1)
                            {
                                exisitingRec.SecondLastInvoiceDate__c=invoiceDate[1];  
                            }
                            
                        }
                    }
                    if(exisitingRec.LastInvoiceDate__c!=null && exisitingRec.SecondLastInvoiceDate__c==null)
                    {
                        
                        if(ResDivAccInvoiceDateMap.containsKey(key))
                        {
                            Date LastInvoiceDate = exisitingRec.LastInvoiceDate__c;
                            List<Date> invoiceDate=ResDivAccInvoiceDateMap.get(key);
                            if(invoiceDate.size()>0){
                                if(exisitingRec.LastInvoiceDate__c<invoiceDate[0]){
                                    exisitingRec.LastInvoiceDate__c=invoiceDate[0];
                                }
                                
                                if(invoiceDate.size()>1 && LastInvoiceDate<invoiceDate[1])
                                {
                                    LastInvoiceDate=invoiceDate[1];
                                }
                                Integer monthsBetween = LastInvoiceDate.monthsBetween(invoiceDate[0]);
                                if(monthsBetween<0)
                                {
                                    monthsBetween=monthsBetween*(-1);
                                }
                                if(monthsBetween>=1){
                                    exisitingRec.SecondLastInvoiceDate__c=LastInvoiceDate;
                                }
                            }
                        }
                    }
                    if(exisitingRec.LastInvoiceDate__c!=null && exisitingRec.SecondLastInvoiceDate__c!=null)
                    {
                        
                        if(ResDivAccInvoiceDateMap.containsKey(key))
                        {
                            Date LastInvoiceDate = exisitingRec.LastInvoiceDate__c;
                            List<Date> invoiceDate=ResDivAccInvoiceDateMap.get(key);
                            if(invoiceDate.size()>0){
                                if(exisitingRec.LastInvoiceDate__c<invoiceDate[0]){
                                    exisitingRec.LastInvoiceDate__c=invoiceDate[0];
                                }
                                if(invoiceDate.size()>1 && LastInvoiceDate<invoiceDate[1])
                                {
                                    LastInvoiceDate=invoiceDate[1];
                                }
                                Integer monthsBetween = LastInvoiceDate.monthsBetween(invoiceDate[0]);
                                
                                if(monthsBetween<0)
                                {
                                    monthsBetween=monthsBetween*(-1);
                                }
                                if(monthsBetween>=1){
                                    exisitingRec.SecondLastInvoiceDate__c=LastInvoiceDate;
                                }
                                
                            }
                        }
                        
                    }
                    upsertSaloonInvoice.add(exisitingRec); 
                }
                
            }
            //no exisiting record is there
            else
            {
                SaloonInvoice__c newRec = new SaloonInvoice__c();
                List<String> allId = key.split('-');
                Id resourceId = Id.valueOf(allId[0]);
                //Id divisionId = Id.valueOf(allId[1]);
                Id accountId = Id.valueOf(allId[1]);
                newRec.Account__c=accountId;
                newRec.Resource__c=resourceId;
                newRec.CurrencyIsoCode=AccountCurrencyMap.get(accountId);
               // newRec.Division__c=divisionId;
                if(ResDivAccLastVisitDateMap.containsKey(key))
                {
                    newRec.Last_Visit_Date__c=ResDivAccLastVisitDateMap.get(key);
                }
                if(ResDivAccAvgOrderMap.containsKey(key))
                {
                    newRec.Average_Order_Value__c=ResDivAccAvgOrderMap.get(key);
                }
                if(ResDivAccInvoiceDateMap.containsKey(key))
                {
                    List<Date> invoiceDate=ResDivAccInvoiceDateMap.get(key);
                    if(invoiceDate.size()>0){
                        newRec.LastInvoiceDate__c=invoiceDate[0];
                    }
                    if(invoiceDate.size()>1){
                        newRec.SecondLastInvoiceDate__c=invoiceDate[1];   
                    }
                }
                upsertSaloonInvoice.add(newRec);
            }
        }
        upsert upsertSaloonInvoice;
        for(SaloonInvoice__c i:upsertSaloonInvoice)
        {
            system.debug('i'+i);
        }
        
    }
    
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('CoverageBatchClass') && vMapNameCustomSett.get('CoverageBatchClass').SwitchOff__c==false){
           CoverageBatchClass cb= new CoverageBatchClass();
      database.executeBatch(cb);
        }
        
    }
}