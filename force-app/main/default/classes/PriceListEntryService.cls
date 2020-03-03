public with sharing class PriceListEntryService {
    public static Map<String,ivybase__Price_List_Entrie__c> CheckIfTheCombinationExist(List<Id> ProdutId,List<Id> PriceList)
    {
    	Map<String,ivybase__Price_List_Entrie__c> EntryCombination = new Map<String,ivybase__Price_List_Entrie__c>();
    	List<ivybase__Price_List_Entrie__c> priceListEntry = new List<ivybase__Price_List_Entrie__c>();
    	priceListEntry=[select id,name,ivybase__Price_List__c,ivybase__Product__c,ivybase__UOM_1_Price__c,RelatedCustomerCode__c  from ivybase__Price_List_Entrie__c where ivybase__Product__c=:ProdutId and ivybase__Price_List__c=:PriceList];
    	if(priceListEntry.size()>0)
    	{
    		for(ivybase__Price_List_Entrie__c p:priceListEntry)
    		{
    			EntryCombination.put(p.ivybase__Product__c+''+p.ivybase__Price_List__c,p);
    		}
    	}
    	return EntryCombination;
    }
}