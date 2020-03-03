public with sharing class ResourcePickListCls {
    @AuraEnabled
    public static List<ivybase__Resource__c> getResources(){
        List<ivybase__Resource__c> resource = [select Id, Name from ivybase__Resource__c LIMIT 1000];
        System.debug(resource);
        return resource;
    }
    @AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> account = [select Id, Name from Account LIMIT 1000];
        System.debug(account);
        return account;
    }
	
      
}