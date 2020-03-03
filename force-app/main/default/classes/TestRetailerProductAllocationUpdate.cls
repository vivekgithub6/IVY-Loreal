@isTest
public class TestRetailerProductAllocationUpdate {
    @isTest
    public static void testUpdate_product_Allocation()
    {
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        date d1=System.today();
        date d2=System.today(); 
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        ivybase__Product__c pro=new ivybase__Product__c(name='testpro1');
        insert pro;
        ivybase__Product__c pro2=new ivybase__Product__c(name='testpro2');
        insert pro2;
        RetailerProductAllocation__c ret=new RetailerProductAllocation__c(From__c=d1,To__c=d2,Quantity__c=5,Market_ISO__c='MY',Account__c=acc.Id,Product_Master__c=pro.Id);
        insert ret;
        Map<id,map<id,decimal>> m=new Map<id,map<id,decimal>>();
        map<id,decimal> imap=new map<id,decimal>();
        imap.put(pro.Id,5);
        imap.put(pro2.Id,6);
        m.put(acc.Id,imap);
        RetailerProductAllocation_update.Update_product_Allocation(m);
    }
}