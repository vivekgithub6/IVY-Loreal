@Restresource(UrlMapping='/v1/SchemeClassMapping')
global with sharing class RestSchemeClassMapping {
        @httpGet
    global static RExAPIResponseDomain.ResponseInfo getschemeclassmappinginfo(){
          RExAPIResponseDomain.ResponseInfo schemeclassmap = new RExAPIResponseDomain.ResponseInfo();
           try{
            List<SchemeClassMapping__c> ClassschemeList = SchemeClassMappingService.getSchemeClassMapping();
               system.debug('ClassschemeList'+ClassschemeList);
            schemeclassmap=SchemeClassMappingTranslator.objectToJson(ClassschemeList,null);
                  }Catch(Exception ex){
            system.debug('exception'+ex.getMessage());
           schemeclassmap=SchemeClassMappingTranslator.objectToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
             }
        return schemeclassmap;
    }
}