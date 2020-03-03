@isTest
public class TestImportDataFromCSVController {

    static testmethod void testfileupload(){
        
        String str = 'M300,02,30,0000010001,PE,000,00000027,Loreal DEG\n'+
                     'M300,02,30,0000010002,SH,000,00000027,LOREAL SINGAPORE PTE LTD';   
         
        String str2 = 'M300,02,30,PE,00000027,000,Loreal DEG, 0000010001\n'+
                     'M300,02,30,SH,00000027,000,LOREAL SINGAPORE PTE LTD, 0000010002 ';
        String[] csvFileLines;
        Blob csvFileBody;
        Blob csvFileBody2;
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Supervisor');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '00000027';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Account> accList = new List<Account>();
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Sold_To_Party_Number__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Sold_To_Party_Number__c = '0000010001';
        accList.add(acc);
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456781' , '111222332' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Sold_To_Party_Number__c = '0000010002';
        accList.add(acc1);
        
        insert accList;
        
        accList[0].ivybase__Active__c = 'Yes';
        accList[1].ivybase__Active__c = 'Yes';
        update accList;
        
        List<Account> accountList = [SELECT Id, Name, RecordType.Name, ivybase__Active__c  FROM Account];
        System.debug('accountList====>'+accountList);
        
        Test.startTest();      
        csvFileBody = Blob.valueOf(str);
        importDataFromCSVController importData = new importDataFromCSVController();
        importData.csvFileBody = csvFileBody;
        importData.readFromFile();
        
        csvFileBody2 = Blob.valueOf(str2);
        MultiRepAssignmentFileUpload importDataTwo = new MultiRepAssignmentFileUpload();
        importDataTwo.csvFileBody = csvFileBody2;
        importDataTwo.readFromFile();
        Test.stopTest();
        
        List<ivybase__Route__c> RouteList = [SELECT Id, Name, Market_ISO__c, ivybase__Resource__c, 
                                                            ivybase__Resource__r.SAP_Id__c,
                                                            Location_Hierarchy_Territory__c, 
                                                            ivybase__Description__c 
                                                     FROM ivybase__Route__c ];
        System.debug('RouteList===>'+RouteList);
       // System.assertEquals(1,RouteList.size());
        
        List<ivybase__Route_Details__c> routeDetailList = [SELECT Id, Name, Market_ISO__c FROM ivybase__Route_Details__c];
        System.debug('routeDetailList===>'+routeDetailList);
        System.assertEquals(2,routeDetailList.size());
        
        List<Territory_Routing__c> territoryRouteList = [SELECT Id, Name, Market_ISO__c FROM Territory_Routing__c];
        System.debug('territoryRouteList===>'+territoryRouteList);
        System.assertEquals(1,territoryRouteList.size());
    }
}