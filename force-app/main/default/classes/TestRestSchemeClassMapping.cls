@isTest
public class TestRestSchemeClassMapping {
    private static testMethod void testsalestarget(){
        id currentUserId= userinfo.getUserId();
        ivybase__Resource_Type__c restyp = TestUtility.createTestResourceType('Merchandiser');
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,restyp.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.id);
        lochr.RecordTypeId = RT.get('National').getRecordTypeId();
        lochr.ivybase__Resource_Type__c=restyp.id;
        insert locHr;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',Name='Test',ivydsd__Code__c='TE01',ivydsd__Description__c='Scheme Desc',ivydsd__From__c=Date.today(),
                                                         ivydsd__Scheme_Buy_Logic__c='AND',Market_ISO__c='MY',ivydsd__Scheme_Type__c='QTY',ivydsd__To__c=Date.today().addDays(15));
        insert scheme;
        Class_Frequency__c c=new Class_Frequency__c(Name='A',Frequency__c=4,FrequencyForLocation__c=locHr.id,Color_Code__c='2#3AN',Market_ISO__c = 'MY');
        insert c;
        
        SchemeClassMapping__c scmp=new SchemeClassMapping__c(Class_Frequency__c=c.id,Scheme__c=scheme.Id,Market_ISO__c='MY');
        insert scmp;
        
        test.startTest();
        RestSchemeClassMapping.getschemeclassmappinginfo();
        test.stopTest();
        
    }
    
    @isTest
    private static void  testRestSchemeClassMappingException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            RestSchemeClassMapping.getschemeclassmappinginfo();
        }
        Test.stoptest();
    }
}