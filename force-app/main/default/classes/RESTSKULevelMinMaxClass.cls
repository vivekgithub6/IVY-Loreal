@RestResource(urlMapping='/v1/SKULevelMinMaxMaster/*')

global with sharing class RESTSKULevelMinMaxClass {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getMinmaxInfo(){
        RExAPIResponseDomain.ResponseInfo Minmaxplan = new RExAPIResponseDomain.ResponseInfo();
        try {
            Minmaxplan = MinMaxTranslator.objectToMinMax(null);
        } catch(Exception ex){
            Minmaxplan = MinMaxTranslator.objectToMinMax(CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
        }
        return Minmaxplan ;
    }
}