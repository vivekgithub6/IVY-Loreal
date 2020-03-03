@isTest
public class TestProductTrigger {

    static testmethod void insertProduct(){
        
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');   
        insert function;
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.ivybase__Barcode__c = 1234567;
        proSKU.ivybase__Code__c = '12322M300';
        insert proSKU;
        
        List<ivybase__Product__c> productList = [SELECT Id,  ivybase__Barcode__c, ivybase__Code__c, Product_Code__c 
                                                 FROM ivybase__Product__c];
        System.assertEquals(productList[0].Product_Code__c , proSKU.ivybase__Code__c.substring(0,proSKU.ivybase__Code__c.length()-4));
    }
    static testmethod void updateProduct(){
        
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');   
        insert function;
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.ivybase__Barcode__c = 1234567;
        proSKU.ivybase__Code__c = '12322M300';
        insert proSKU;
        
        proSKU.ivybase__Barcode__c = 1234568;
        proSKU.ivybase__Code__c = '12325M300';
        update proSKU;
        
        List<ivybase__Product__c> productList = [SELECT Id,  ivybase__Barcode__c, ivybase__Code__c, Product_Code__c 
                                                 FROM ivybase__Product__c];
        System.assertEquals(productList[0].Product_Code__c , proSKU.ivybase__Code__c.substring(0,proSKU.ivybase__Code__c.length()-4));
    }
}