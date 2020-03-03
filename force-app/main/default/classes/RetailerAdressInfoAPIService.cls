public class RetailerAdressInfoAPIService {
    public static list<Partner_Function__c> RetrieveRetailerAdress(set<id> AccountIds,set<id> divids){
      //map<list<Account>,map<id,id>> AccountPartnerIDsMapOfMap=new  map<list<Account>,map<id,id>>();
        set<id> PartnerIds=new set<id>();
        system.debug('AccountIds'+AccountIds);
        String country_code = UserService.getCountryCode();
        
        List<CountryCodeMarketISO__mdt> countryCodeList = [SELECT Country__c, Country_Code__c, Division_based_Partner_Function__c
                                                           FROM CountryCodeMarketISO__mdt
                                                           WHERE Country__c =: country_code  LIMIT 1];
        list<Partner_Function__c> PartnerFunctionList;
        if(countryCodeList != null && countryCodeList.isEmpty() == false && countryCodeList[0].Division_based_Partner_Function__c == true ) {                                               
            
              PartnerFunctionList=[select type__c,Active__c,Division__c,Account__r.ivybase__Internal_Id__c,
                                          Account__c,Name,partner__r.ivybase__Internal_Id__c,
                                          partner__r.ivybase__Contact_Email__c,
                                          partner__r.ivybase__Lat_and_Long__latitude__s, 
                                          partner__r.ivybase__Lat_and_Long__longitude__s,
                                          partner__r.ivybase__Lat_and_Long__c,
                                          partner__r.Fax,
                                   
                                          partner__r.ivybase__Contact_PhoneNo__c,
                                          partner__r.BillingStreet,
                                          partner__r.BillingCity,
                                          partner__r.BillingState,
                                          partner__r.BillingPostalCode,
                                          partner__r.ShippingStreet,
                                          partner__r.ShippingCity,
                                          partner__r.ShippingState,
                                          partner__r.ShippingPostalCode,
                                          partner__r.phone,partner__r.Store_Address__c,partner__r.ivybase__Area_Code__c 
                                   FROM Partner_Function__c 
                                   WHERE  Account__c in:AccountIds
                                   AND Active__c=True 
                                   ];
       
       } else {
       
           PartnerFunctionList=[select type__c,Active__c,Division__c,Account__r.ivybase__Internal_Id__c,
                                      Account__c,Name,partner__r.ivybase__Internal_Id__c,
                                      partner__r.ivybase__Contact_Email__c,
                                      partner__r.ivybase__Lat_and_Long__latitude__s, 
                                      partner__r.ivybase__Lat_and_Long__longitude__s,
                                      partner__r.ivybase__Lat_and_Long__c,
                                      partner__r.Fax,
                                      partner__r.ivybase__Contact_PhoneNo__c,
                                      partner__r.BillingStreet,
                                      partner__r.BillingCity,
                                      partner__r.BillingState,
                                      partner__r.BillingPostalCode,
                                      partner__r.ShippingStreet,
                                      partner__r.ShippingCity,
                                      partner__r.ShippingState,
                                      partner__r.ShippingPostalCode,
                                      partner__r.phone,partner__r.Store_Address__c ,partner__r.ivybase__Area_Code__c
                               FROM Partner_Function__c 
                               WHERE  Account__c in:AccountIds 
                               AND Division__c IN:divids 
                               AND Active__c=True 
                               ];
       }
       System.debug('++PartnerFunctionList++'+PartnerFunctionList.size());
       System.debug('++PartnerFunctionList++'+PartnerFunctionList);
       /* map<id,id> PartnerFunctionIdMap=new map<id,id>();
        for(Partner_Function__c partner:PartnerFunctionList){
            PartnerIds.add(partner.Account__c);
            PartnerFunctionIdMap.put(partner.Account__c,partner.Account__c);
        }
        list<Account> PartnersList=[select  ivybase__Internal_Id__c,
                                    ivybase__Contact_Email__c,
                                     ivybase__Lat_and_Long__latitude__s, 
                                                ivybase__Lat_and_Long__longitude__s,
                                               ivybase__Lat_and_Long__c,
                                    Fax,
                                    ivybase__Contact_PhoneNo__c,
                                    BillingStreet,
                                              BillingCity,
                                                BillingState,
                                                BillingPostalCode,
                                                ShippingStreet,
                                                ShippingCity,
                                                ShippingState,
                                                ShippingPostalCode,phone from Account where id in:PartnerIds];*/
        system.debug('PartnerFunctionList'+PartnerFunctionList);
        return PartnerFunctionList;
    } 
}