@isTest
private class TestContactTrigger{
    private static testmethod void testDuplicateCheck(){
        ivybase__Max_Internal_Id_Value__c maxIntern = new ivybase__Max_Internal_Id_Value__c(Name='Contact');
        maxIntern.ivybase__Max_Internal_Id__c = 1;
        insert maxIntern;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  UserInfo.getUserId(), 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
       
        con.Signature__c = 'https://www.google.com/image.png';
        insert con;
        con.LastName = 'Test Contact';
        update con;
    }
}