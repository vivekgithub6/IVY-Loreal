@isTest
public class TESTStoreDivisionMappingService {

    private static testMethod void StoreDivisionMapping(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Market_ISO__c = 'MY',Division__c = div.Id);
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',Market_ISO__c = 'MY',ivybase__Parent__c=channel.Id);
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',Market_ISO__c = 'MY',ivybase__Parent__c=subChannel.Id);
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',Market_ISO__c = 'MY',ivybase__Parent__c=node3.Id);
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        insert node4;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Is_Conquest__c = true, Market_ISO__c = 'MY',recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=node4.Id);
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Is_Conquest__c = true;
        update acc; 
        
        List<Account> accList = new List<Account>{acc};
        
        StoreDivisionMapping__c divMap = new StoreDivisionMapping__c(Account__c = acc.Id,Market_ISO__c = 'MY',Store_Hierarchy__c=node4.Id);
        insert divMap;
        
        Set<Id> shIdSet = new Set<Id>{node4.id};
        Test.startTest();
        Set<Id> returnedShIdSet = StoreDivisionMappingService.getAllAccountIdForStoreHierarchy(shIdSet);
        Map<Id,Id> returnedShIdMap = StoreDivisionMappingService.getOneMatchingStoreHierarchyForAccount(accList);
        Test.stopTest();
        
        System.assert(returnedShIdSet.size()>0);
        System.assert(returnedShIdSet.contains(acc.Id));
    }
}