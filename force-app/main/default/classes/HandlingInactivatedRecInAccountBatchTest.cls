@isTest
public class HandlingInactivatedRecInAccountBatchTest {

    Static testmethod void HandlingInactivatedRecInAccBtchTest(){
        DateTime dt = System.now();
        Interface_Run__c runinfo = new Interface_Run__c(Name='CustomerMaster',Interface_Run_Date_Time__c = dt,Market_ISO__c = 'MY');
        insert runinfo;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Last_Updated_Date_Time__c= dt, Name='test account',Market_ISO__c = 'MY',ivybase__Status__c='Active', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes');
        insert acc;
        
        test.startTest();
        Set<string> countryCode=new Set<string>() ;
        countryCode.add('MY');
        HandlingInactivatedRecordsInAccountBatch btc = new HandlingInactivatedRecordsInAccountBatch(countryCode);
        database.executeBatch(btc);
        test.stopTest();
    } 
    
    Static testmethod void HandlingInactivatedRecInAccBtchTest1(){
    
        DateTime dt = System.now();
        
        Interface_Run__c runinfo1 = new Interface_Run__c(Name='CustomerMaster',Interface_Run_Date_Time__c = dt,Market_ISO__c = 'MY');
        insert runinfo1;
        
        Interface_Run__c runinfo = new Interface_Run__c(Name='Araging',Interface_Run_Date_Time__c = dt,Market_ISO__c = 'MY');
        insert runinfo;
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
         
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = division.Id,Market_ISO__c = 'MY');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Store_Number__c = 'NODE4';
        insert node4;
                            
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Last_Updated_Date_Time__c=dt,Is_Conquest__c = true, recordTypeId=accrecordTypeId, Market_ISO__c = 'MY', ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id);
        insert acc;
        
        Contact con = new Contact();
        con.Lastname = 'Testcon';
        con.Email = 'Test@gmail.com' ;
        con.ivybase__Related_User__c = UserInfo.getuserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;    
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.Sold_To_Party_Number__c = 'SOLD12';
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Converted_to_Normal_Saloon__c =true;
        update acc; 
              
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        insert order;
         
        list<ivydsd__Invoice__c> invoiceList = new list<ivydsd__Invoice__c>();
        ivydsd__Invoice__c invoice1 =  TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice1.Last_Updated_Date_Time__c = dt;
        invoiceList.add(invoice1);
        insert invoiceList;
        
        test.startTest();
        Set<string> countryCode=new Set<string>() ;
        countryCode.add('MY');
        HandlingInactivatedRecordsInAccountBatch btc = new HandlingInactivatedRecordsInAccountBatch(countryCode);
        database.executeBatch(btc);
        test.stopTest();
    } 
   
}