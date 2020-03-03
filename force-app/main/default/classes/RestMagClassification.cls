@RestResource(urlMapping='/v1/MagClassification/Masters/*')
global with sharing class RestMagClassification {
    
    @HttpGet
    global static RExAPIResponseDomain.ResponseInfo getSaloonMagClassification() {
        
        RExAPIResponseDomain.ResponseInfo response = new RExAPIResponseDomain.ResponseInfo();
        
        
        try {
            
            List<Salon_Catagory__c> saloonCatagoryList = SaloonCatagoryService.get_All_Saloon_Catagory_records();
            response = SaloonCatagoryTranslator.objectToSaloonCatagory(saloonCatagoryList,null);
            
            
            
         } catch (SecurityUtility.SFDCAccessControlException ex) {
            
            
            response = SaloonCatagoryTranslator.objectToSaloonCatagory(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
        }
      
        return response;
    }
}