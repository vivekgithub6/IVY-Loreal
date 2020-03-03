@RestResource(UrlMapping='/v1/UserDivisionMapping/Masters/')
global with sharing class RESTDivisionMapping {
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getDivisionMappingInfo() {
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        RExAPIResponseDomain.ResponseInfo RetailerDivisionMapping = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo UserDivisionMapping;
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        try{
            list<account> accountslist= AccountService.getAllRetailerMaster_List_for_Resource();
            set<id> accid= new set<id>();
            for(account acc:accountslist){
                accid.add(acc.id);
            }
            List<StoreDivisionMapping__c> storeDivRecords = DivisionMappingService.getRetailerCheck(accid);
            System.debug('storeDivRecords::: '+storeDivRecords);
            System.debug('storeDivRecords*** '+storeDivRecords);
            RetailerDivisionMapping =  DivisionMappingTranslator.TranslateStoreDivToJson(storeDivRecords,null);
            response.Tables.add(RetailerDivisionMapping);
            
            map<string,string> UserDivisionmap=new map<string,string>();
            UserDivisionmap=ResourceService.GetAllResources();
            system.debug('UserDivisionmap***'+UserDivisionmap);
            UserDivisionMapping = DivisionMappingTranslator.TranslateCUsersToJson(UserDivisionmap,null);
            response.Tables.add(UserDivisionMapping);
        }
        catch(Exception ex){
            RetailerDivisionMapping =  DivisionMappingTranslator.TranslateStoreDivToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(RetailerDivisionMapping);
            
            UserDivisionMapping = DivisionMappingTranslator.TranslateCUsersToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));   
            response.Tables.add(UserDivisionMapping);
         }
        
         return response;
    }
    
    
    
}