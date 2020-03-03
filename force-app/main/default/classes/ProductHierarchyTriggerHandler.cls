public class ProductHierarchyTriggerHandler {

    public static Map<String, String> ccMap = new Map<String, String>();
    
    public static Map<String, String> generateCCMap() {
    
        if(ccMap == null || ccMap.isEmpty() == true) {
        
            List<CountryCodeMarketISO__mdt> countryCodeList = [SELECT Country_Code__c, Country__c 
                                                           FROM CountryCodeMarketISO__mdt];
            
            for(CountryCodeMarketISO__mdt countryCode : countryCodeList){
                
                if(countryCode.Country_Code__c != null && countryCode.Country__c != null) {
                
                    ccMap.put(countryCode.Country__c, countryCode.Country_Code__c);
                }
            }
        }
        return ccMap;
    }
    public static void populateProductCode(List<ivybase__Product_Hierarchy__c> productHierarchyList){
        
        Map<String, String> countryCodeMap = generateCCMap();
        
        for(ivybase__Product_Hierarchy__c productHierarchy : productHierarchyList){
            
            if(String.isNotBlank(productHierarchy.ivybase__Code__c) == true) {
                
                if(countryCodeMap.containskey(productHierarchy.Market_ISO__c) &&
                   productHierarchy.ivybase__Code__c.endsWith(countryCodeMap.get(productHierarchy.Market_ISO__c)) == true) {
                    
                    productHierarchy.ProductHierarchyCode__c = productHierarchy.ivybase__Code__c.removeEnd(countryCodeMap.get(productHierarchy.Market_ISO__c));
                } else {
                    
                    productHierarchy.ProductHierarchyCode__c = String.isNotBlank(productHierarchy.ProductHierarchyCode__c) == true ? 
                                                    productHierarchy.ProductHierarchyCode__c : productHierarchy.ivybase__Code__c;
                }
            } else if(String.isNotBlank(productHierarchy.ProductHierarchyCode__c) == true) {
                                                
                productHierarchy.ivybase__Code__c = productHierarchy.ProductHierarchyCode__c;
            }
        }
    }
    
    public static void updateProductCode(List<ivybase__Product_Hierarchy__c> productHierarchyList, 
                                         Map<Id,ivybase__Product_Hierarchy__c> oldProductHierarchyMap){
        
        
        Map<String, String> countryCodeMap = generateCCMap();
                       
        for(ivybase__Product_Hierarchy__c productHierarchy : productHierarchyList){
            
            if(productHierarchy.ivybase__Code__c != oldProductHierarchyMap.get(productHierarchy.id).ivybase__Code__c) {
                
                if(productHierarchy.ivybase__Code__c != null && countryCodeMap.containskey(productHierarchy.Market_ISO__c) &&
                   productHierarchy.ivybase__Code__c.endsWith(countryCodeMap.get(productHierarchy.Market_ISO__c)) == true) {
                    
                    productHierarchy.ProductHierarchyCode__c = productHierarchy.ivybase__Code__c.removeEnd(countryCodeMap.get(productHierarchy.Market_ISO__c));
                }
                else {
                    
                    productHierarchy.ProductHierarchyCode__c = String.isNotBlank(productHierarchy.ProductHierarchyCode__c) == true ? 
                                                    productHierarchy.ProductHierarchyCode__c : productHierarchy.ivybase__Code__c;
                }
            }
            else if(productHierarchy.ProductHierarchyCode__c != oldProductHierarchyMap.get(productHierarchy.id).ProductHierarchyCode__c
                    && String.isNotBlank(productHierarchy.ProductHierarchyCode__c) == true) {
                                                
                productHierarchy.ivybase__Code__c = productHierarchy.ProductHierarchyCode__c;
            }
        }
    }
}