@RestResource(UrlMapping='/v1/RetailerAddress/Masters/')
global with sharing class RestRetailerAddressInfo {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRetailerAdressInfo(){
        RExAPIResponseDomain.ResponseInfo AccountResp = new RExAPIResponseDomain.ResponseInfo();
        
        try{
             Id sellerId = ResourceService.getLoginSellerId();
           List<ivybase__Location_Hierarchy__c> userterritorylist= LocationMasterService.getUserTerritory();
            set<id> teritoryid= new set<id>();
            for(ivybase__Location_Hierarchy__c loct:userterritorylist){
                teritoryid.add(loct.id);
            }
            Set<Id> divids=DivisionSerivce.getDivisionForUserTerritory(teritoryid);
            Set<Id> accIds = new Set<Id>();
            
            System.debug('teritoryid===>'+teritoryid);
            System.debug('divids===>'+divids);
            
            list<string> Listypes=new list<string>{'ADDRESS_TYPE'};
             List<ivybase__Standard_List_Master__c> StandardListMasterrecords= StandardListMasterservice.getStandardListUsingListType(Listypes);
             system.debug('StandardListMasterrecords'+StandardListMasterrecords);
                
            List< Account > accList = AccountService.getAllRetailerMaster_List_for_Resource();
            Set<Account> setOFAccount = new Set<Account>();
            
            
            System.debug('accList:: '+accList);
            for(Account acc: accList){
                accIds.add(acc.Id);
            }
            List<Partner_Function__c> PartnerFunctionList = RetailerAdressInfoAPIService.RetrieveRetailerAdress(accIds,divids);
            List<Account> selfAccounts = accList;
            
            //RetailerAdressInfoAPIService.retrieveSelfAccounts(accIds);
            
            system.debug('PartnerFunctionList'+PartnerFunctionList);
            
            
              AccountResp = RetailerAdressInfoAPITranslator.TranslateAddressToJson(PartnerFunctionList,StandardListMasterrecords,selfAccounts,null);
            
        }
        catch(Exception ex){
            AccountResp = RetailerAdressInfoAPITranslator.TranslateAddressToJson(null,null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));  
        }
            
        return AccountResp; 
        
    }

}