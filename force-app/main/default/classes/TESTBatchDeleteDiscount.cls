/**
 * Covered Classes : BatchDeleteDiscount, BatchDeleteDiscountMaster, InvoiceLineItemService, PricingMasterStageBatch, AccounTrigger,
  	ContactTrigger, TriggerLogicService
*/
@isTest
public class TESTBatchDeleteDiscount {
    private static testMethod void testDelDiscount(){
        String countryCode='PH';
        Set<string> countryCodeSet=new Set<string>();
        countryCodeSet.add(countryCode);
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c=CountryCode;
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
        
        
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c=countryCode, ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c=countryCode, ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c=countryCode),
                new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c=countryCode),
                new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c=countryCode) 
                };
                    insert shyList;
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DT', ivybase__List_Name__c = 'Bill', ivybase__List_Type__c = 'DISCOUNT_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DAT', ivybase__List_Name__c = 'Item', ivybase__List_Type__c = 'DISCOUNT_APPLY_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'INVOICE', ivybase__List_Name__c = 'Invoice', ivybase__List_Type__c = 'DISCOUNT_MODULE_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
               
                }; 
                    insert stdMasterList;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id);
        acc.Is_Conquest__c = true;
        insert acc;
        
        Contact con = new Contact();
        con.Lastname = 'Testcon';
        con.Email = 'Test@gmail.com' ;
        con.ivybase__Related_User__c = UserInfo.getuserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;    
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c=countryCode);
        insert div;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Market_ISO__c=countryCode,Division__c = div.Id,ivybase__Active__c='Yes');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        channel.Market_ISO__c=countryCode;
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',Market_ISO__c=countryCode,ivybase__Parent__c=channel.Id,ivybase__Active__c='Yes');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        subChannel.Market_ISO__c=countryCode;
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',Market_ISO__c=countryCode,ivybase__Parent__c=subChannel.Id,ivybase__Active__c='Yes');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        node3.Market_ISO__c=countryCode;
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',Market_ISO__c=countryCode,ivybase__Parent__c=node3.Id,ivybase__Active__c='Yes');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Market_ISO__c=countryCode;
        insert node4;
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        update acc; 
        
        DateTime TDate = System.now();
        Date todayDate = Date.newinstance(TDate.year(), TDate.month(), TDate.day());
    
        
        ivydsd__Discount__c discount = new ivydsd__Discount__c(Name='Test Discount',Market_ISO__c=countryCode,ivydsd__Apply_Type__c='Item & Bill',ivydsd__Discount_Type__c='Bill',ivydsd__Effective_From__c=todayDate,ivydsd__Module_Type__c='Invoice');
        discount.Market_ISO__c=countryCode;
        insert discount;
        
        ivydsd__Discount_Mapping__c disMapping = new ivydsd__Discount_Mapping__c(ivydsd__Location_Hierarchy__c=locHr.Id,Market_ISO__c=countryCode,ivydsd__Account__c=acc.Id,ivydsd__Discount__c=discount.Id,ivydsd__Store_Hierarchy__c=node4.Id);
        disMapping.Market_ISO__c=countryCode;
        insert disMapping;
        
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/UPMAT/PMATN',Variable_Key__c='232/2323/32/1/123456789B/123456789BD');
        insert pricing;
        
        Pricing_Stage_2__c p = new Pricing_Stage_2__c();
        p.Parent_stage_record__c = pricing.Id;
        p.Market_ISO__c=countryCode;
        insert p;
        
        Pricing_Stage_3__c p1 = new Pricing_Stage_3__c();
        p1.Pricing_Stage_2__c = p.Id;
        p1.Market_ISO__c=countryCode;
        insert p1;
        
        Test.startTest();
        BatchDeleteDiscount batch = new BatchDeleteDiscount(countryCodeSet);
        Database.executeBatch(batch);
        Test.stopTest();
                
    }
}