/**
 * Created By : Ivy Mobility
 * Purpose : Used to assign the Value for the Product Code and Customer Material Codes
 * Referred In : ProductTrigger
 * Test Class Covered : TestProductTrigger
*/
public class ProductTriggerHandler {
    public static void createUOMProduct(List<ivybase__Product__c> products){
        List<ivybase__Product_UOM__c> UOMListToInsert = new List<ivybase__Product_UOM__c>();
        for(ivybase__Product__c product : products){
            ivybase__Product_UOM__c UOM = new ivybase__Product_UOM__c();
            UOM.ivybase__UOM__c = 'Piece';
            UOM.ivybase__Product__c = product.Id;
            if(product.ivybase__Barcode__c != null)
                UOM.ivybase__Bar_Code__c = String.valueOf(product.ivybase__Barcode__c);
            UOM.ivybase__UOM_Number__c='UOM 1';
            UOM.ivybase__Conversion_Factor__c = 1;
            UOMListToInsert.add(UOM);
        }
        insert UOMListToInsert;
        
    }
    public static void updateUOMProduct(Set<Id> prodIds){
        List<ivybase__Product_UOM__c> UOMListToUpdate = new List<ivybase__Product_UOM__c>();
        List<ivybase__Product_UOM__c> UOMList = [Select Id,ivybase__Bar_Code__c,ivybase__Product__c,ivybase__Product__r.ivybase__Barcode__c from ivybase__Product_UOM__c Where ivybase__Product__c IN : prodIds];
        for(ivybase__Product_UOM__c UOM : UOMList){
            UOM.ivybase__Bar_Code__c = String.valueOf(UOM.ivybase__Product__r.ivybase__Barcode__c);
            UOMListToUpdate.add(UOM);
        }
        update UOMListToUpdate;
        
    }
       
    public static void populateProductCode(List<ivybase__Product__c> products){
        
        Map<String, String> countryCodeMap = ProductHierarchyTriggerHandler.generateCCMap();
        
        for(ivybase__Product__c product : products){
            product.Customer_Material_Code__c = String.isNotBlank(product.Customer_Material__c) == true && 
                    product.Customer_Material__c.endsWith(countryCodeMap.get(product.Market_ISO__c)) == true ? 
                    product.Customer_Material__c.removeEnd(countryCodeMap.get(product.Market_ISO__c)) : product.Customer_Material__c;
            
            if(String.isNotBlank(product.ivybase__Code__c) == true) {
                
                if(countryCodeMap.containskey(product.Market_ISO__c) &&
                   product.ivybase__Code__c.endsWith(countryCodeMap.get(product.Market_ISO__c)) == true) {
                    
                    product.Product_Code__c = product.ivybase__Code__c.removeEnd(countryCodeMap.get(product.Market_ISO__c));
                }
                else {
                    
                    product.Product_Code__c = String.isNotBlank(product.Product_Code__c) == true ? 
                                              product.Product_Code__c : product.ivybase__Code__c;
                }
            }
            else if(String.isNotBlank(product.ivybase__Code__c) == true) {
                                                
                product.ivybase__Code__c = product.Product_Code__c;                            
            }
        }
    }
    
    public static void updateProductCode(List<ivybase__Product__c> products, Map<Id,ivybase__Product__c> oldProductMap ){
        
        Map<String, String> countryCodeMap = ProductHierarchyTriggerHandler.generateCCMap();
        
        for(ivybase__Product__c product : products){
            
            if(product.ivybase__Code__c != oldProductMap.get(product.id).ivybase__Code__c) {
                
                if(product.ivybase__Code__c != null && countryCodeMap.containskey(product.Market_ISO__c) &&
                   product.ivybase__Code__c.endsWith(countryCodeMap.get(product.Market_ISO__c)) == true) {
                    
                    product.Product_Code__c = product.ivybase__Code__c.removeEnd(countryCodeMap.get(product.Market_ISO__c));
                }
                else {
                    
                    product.Product_Code__c = String.isNotBlank(product.Product_Code__c) == true ? 
                                              product.Product_Code__c : product.ivybase__Code__c;
                }
            }
            else if(product.Product_Code__c != oldProductMap.get(product.id).Product_Code__c
                    && String.isNotBlank(product.Product_Code__c) == true) {
                                                
                product.ivybase__Code__c = product.Product_Code__c;
            }
        }
    }    
}