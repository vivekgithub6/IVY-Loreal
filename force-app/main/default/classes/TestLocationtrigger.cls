@isTest
public class TestLocationtrigger {
    
    @istest
    public static void insertMethod() {
        
        id userId = userInfo.getUserId();
                
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=userId,Market_ISO__c = 'MY');
        resource.ivybase__Resource_Type__c = restype.Id;
        insert resource;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',resource.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'yes';
        update acc;
        
        ivybase__Visit__c visit = new ivybase__Visit__c(ivybase__Resource__c=resource.Id,ivybase__Status__c='Completed',ivybase__Store__c=acc.Id,Name='Test',ivybase__Visit_Date__c=System.today());
        insert visit;
        
        Id InStore = [Select Id from RecordType Where DeveloperName='In_Store' 
                      AND SobjectType='ivybase__Location__c'].Id;
                      
        ivybase__Location__c loc = new ivybase__Location__c(RecordTypeId=InStore,Market_ISO__c = 'MY',ivybase__Active__c='Yes',ivybase__UOM1__c=12,ivybase__Visit__c=visit.Id);
        
        
        insert loc;
            
        loc.ivybase__UOM1__c = 10;
        update loc;
        
    }
}