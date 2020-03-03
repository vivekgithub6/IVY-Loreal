@isTest
public class TestProductHierarchyTrigger {

    static testmethod void insertProductHierarchy(){
        
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');
        function.ivybase__Code__c = '12322M300';
        insert function;
        
        List<ivybase__Product_Hierarchy__c> productHierarchyList = [SELECT Id, ivybase__Code__c, ProductHierarchyCode__c 
                                                                     FROM ivybase__Product_Hierarchy__c];
        System.assertEquals(productHierarchyList[0].ProductHierarchyCode__c, 
                            function.ivybase__Code__c.substring(0,function.ivybase__Code__c.length()-4));
    }
    
    static testmethod void updateProductHierarchy(){
        
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');
        function.ivybase__Code__c = '12322M300';
        insert function;
        
        function.ivybase__Code__c = '12325M300';
        update function;
        
        function.ProductHierarchyCode__c = '1232566M300';
        update function;
        
        List<ivybase__Product_Hierarchy__c> productHierarchyList = [SELECT Id, ivybase__Code__c, ProductHierarchyCode__c 
                                                                     FROM ivybase__Product_Hierarchy__c];
       // System.assertEquals(productHierarchyList[0].ProductHierarchyCode__c, 
        //                    function.ivybase__Code__c.substring(0,function.ivybase__Code__c.length()-4));
    }
    
    static testmethod void updateProductHierarchyNull(){
        
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');
        function.ivybase__Code__c = '12322M300';
        insert function;
        
        function.ivybase__Code__c = '';
        update function;
        
        List<ivybase__Product_Hierarchy__c> productHierarchyList = [SELECT Id, ivybase__Code__c, ProductHierarchyCode__c 
                                                                     FROM ivybase__Product_Hierarchy__c];
        //System.assertEquals(productHierarchyList[0].ProductHierarchyCode__c, 
         //                   null);
    }
}