@isTest
public class TestHHTService {

    
    public static testMethod void methodOne(){
        
        HHTService.getHHTMenu();
        HHTService.getHHTModule();
        HHTService.getHHTMenuMethods();
        HHTService.getSurveyHHTMenu();
        
        
        List<ivybase__HHTMenu_Master__c> hhtMenuList = new List<ivybase__HHTMenu_Master__c>();
        
         ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
         Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();

        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        ivybase__HHTMenu_Master__c hhtmenu11 = new ivybase__HHTMenu_Master__c();
        hhtmenu11.Name = 'PROFILE_LO_05';
        hhtmenu11.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu11.ivybase__Flex__c = 'Document__c';
        hhtmenu11.ivybase__Flag__c = 1;
        hhtmenu11.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu11);
        
        ivybase__HHTMenu_Master__c hhtmenu12 = new ivybase__HHTMenu_Master__c();
        hhtmenu12.Name = 'PROFILE_LO_06';
        hhtmenu12.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu12.ivybase__Flex__c = 'Document__c';
        hhtmenu12.ivybase__Flag__c = 1;
        hhtmenu12.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu12);
        
        insert hhtMenuList;
        
       	HHTService.getHHTMenu(restype.Id, locNational.Id, res.Id);
        HHTService.getHHTModule(restype.Id, locNational.Id, res.Id);
    }
}