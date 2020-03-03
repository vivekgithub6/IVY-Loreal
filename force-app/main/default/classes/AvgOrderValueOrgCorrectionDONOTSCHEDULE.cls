global with sharing class AvgOrderValueOrgCorrectionDONOTSCHEDULE implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
    	string query='select id from Account';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> accList){
    	
    	Set<id> accidSet = new Set<id>();
    	for(Account acc : accList){
    		accidSet.add(acc.id);
    	}
    	//find 1 inovice each for the accounts in context
    	
    	List<Account> AccWithInvoices = [select id,
    	(select id from ivydsd__invoice__r limit 1)
    	from account where id IN : accidSet];
    	
    	Set<id> invIdSet = new Set<id>();
    	List<ivydsd__invoice__c> invList = new List<ivydsd__invoice__c>();
    	//if the salon has an invoice, insert its id into set
    	for(Account acc : AccWithInvoices){
    		if(acc.ivydsd__invoice__r.size() > 0){
    			invIdSet.add(acc.ivydsd__invoice__r[0].id);
    		}
    	}
    	
    	invList = [select id, ivydsd__Resource__c, ivydsd__Order__c, 
    	ivydsd__Store__c, ivydsd__Invoice_Date__c 
    	from ivydsd__Invoice__c 
    	where id IN :invIdSet];
    	
    	//pass the queried invoices into the Service method
    	//AccountService.UpdateAccountResourceLastInvoiceDate(invList);
    	
    }
    global void finish(Database.BatchableContext bc){}
}