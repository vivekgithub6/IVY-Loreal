/*******************************************************************************************************
* 
* @ Name : BatchUpdatingStoreINVDateOrdrValue
* @ Purpose : Class 
* @ Author: Naga Sai
*
*   Date        |  Developer Name                       |  Version      |  Changes
* ======================================================================================================
*   02-11-2018  |  nagasai.chalamalasetti@absyz.com     |  1.0          |  Initial Version

*******************************************************************************************************/


// Batch Job for Processing the Records
global class BatchUpdatingStoreINVDateOrdrValue implements Database.Batchable<sobject> {
    
    
    // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Market_ISO__c FROM Account WHERE ivybase__Active__c=\'Yes\'');
        
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<Account> Accountlist) {
        map<String,Decimal> ResourceIDAVGOrderValueMap = new map<String,Decimal>();
        list<SaloonInvoice__c> SaloonInvoiceList = new list<SaloonInvoice__c>();
        map<string,SaloonInvoice__c> SaloonInvoiceResourcemap = new map<string,SaloonInvoice__c>();
        list<SaloonInvoice__c> ExistingSaloonInvoiceList =[select Average_Order_Value__c,LastInvoiceDate__c,Last_Visit_Date__c,Resource__c,Account__c,SecondLastInvoiceDate__c from SaloonInvoice__c where Account__c=:Accountlist[0].id];
        list<ivybase__Resource__c> ResourceInvoiceList = [select id,(select ivydsd__Invoice_Date__c,ivydsd__Resource__c,ivydsd__Order__c,ivydsd__Store__c from ivydsd__Invoice__r where ivydsd__Store__c=:Accountlist[0].id  and createddate=today order by ivydsd__Invoice_Date__c desc ),(select ivybase__Visit_Date__c,ivybase__Resource__c from ivybase__Visits__r where ivybase__Store__c=:Accountlist[0].id order by ivybase__Visit_Date__c desc limit 1) from ivybase__Resource__c];
        list<AggregateResult> AggregateResults = [select avg(ivydsd__Order_Value__c)Amt,ivydsd__Resource__c from ivydsd__Order__c where ivydsd__Order_Date__c = THIS_YEAR and ivydsd__Store__c=:Accountlist[0].id group by ivydsd__Resource__c];
        for(AggregateResult ar:AggregateResults)
            ResourceIDAVGOrderValueMap.put((string)ar.get('ivydsd__Resource__c'),(Decimal)ar.get('Amt'));
        
        for(SaloonInvoice__c salooninvoice : ExistingSaloonInvoiceList)
            SaloonInvoiceResourcemap.put(salooninvoice.Resource__c, salooninvoice);
        
        for(ivybase__Resource__c Resource: ResourceInvoiceList){
            date lastinvoicedate;
            date secondlastinvoicedate;
            date secondlastinvoicedatePreviousMonth;
            if(Resource.ivydsd__Invoice__r.size() > 0){
                lastinvoicedate = Resource.ivydsd__Invoice__r[0].ivydsd__Invoice_Date__c;
            
                for(ivydsd__Invoice__c Invoice :Resource.ivydsd__Invoice__r){
                    if(Invoice.ivydsd__Invoice_Date__c!=Null)
                       if(lastinvoicedate.month() >  Invoice.ivydsd__Invoice_Date__c.month() && secondlastinvoicedatePreviousMonth==Null)
                           secondlastinvoicedatePreviousMonth =  Invoice.ivydsd__Invoice_Date__c;
                }
            }
            if(ResourceIDAVGOrderValueMap.get(Resource.id)!=Null ||  lastinvoicedate!=Null || Resource.ivybase__Visits__r.size() > 0){
                if(!SaloonInvoiceResourcemap.keyset().contains(Resource.id)){
                    SaloonInvoice__c sinv= new SaloonInvoice__c();
                    sinv.Account__c=Accountlist[0].id;
                    sinv.Resource__c=Resource.id;
                    sinv.Market_ISO__c = Accountlist[0].Market_ISO__c;
                    sinv.LastInvoiceDate__c=lastinvoicedate;
                    sinv.SecondLastInvoiceDate__c = secondlastinvoicedatePreviousMonth;
                    sinv.Average_Order_Value__c =   ResourceIDAVGOrderValueMap.get(Resource.id);
                    if(Resource.ivybase__Visits__r.size() > 0)
                        sinv.Last_Visit_Date__c = Resource.ivybase__Visits__r[0].ivybase__Visit_Date__c;
                    SaloonInvoiceList.add(sinv);
                }
                else{
                    SaloonInvoice__c sinv =  SaloonInvoiceResourcemap.get(Resource.id) ;
                    if(lastinvoicedate > sinv.LastInvoiceDate__c){
                      
                        sinv.LastInvoiceDate__c=lastinvoicedate;
                        
                    }
                    if(secondlastinvoicedatePreviousMonth > sinv.SecondLastInvoiceDate__c && secondlastinvoicedatePreviousMonth.month() < sinv.LastInvoiceDate__c.month())
                        sinv.SecondLastInvoiceDate__c = secondlastinvoicedate;
                    sinv.Average_Order_Value__c =   ResourceIDAVGOrderValueMap.get(Resource.id);
                    if(Resource.ivybase__Visits__r.size() > 0)
                        sinv.Last_Visit_Date__c = Resource.ivybase__Visits__r[0].ivybase__Visit_Date__c;
                    SaloonInvoiceList.add(sinv);
                }
            }
        }
        
        upsert SaloonInvoiceList;
        
    }
    
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        
    }
}