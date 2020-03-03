@isTest
public class TESTRESTCustomerInfo {
    private static testMethod void testCustomer(){
        Id userId = UserInfo.getUserId();
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Resource',Market_ISO__c = 'JPN',ivybase__Related_User__c=userId,ivybase__Resource_Type__c=resType.Id);
        insert resource;
        
         Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'JPN');
        insert div;
        
        Id territory = [Select Id from RecordType Where DeveloperName='Territory' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = 'MY',RecordTypeId=territory,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert location; 
         DivisionLocation__c divLoc = new DivisionLocation__c(Location_Hierarchy__c=location.Id,Market_ISO__c = 'MY',Division__c = div.Id);
        insert divLoc;
        ivybase__Location_Hierarchy__c locHrEndmarket = new ivybase__Location_Hierarchy__c(Name='Jon Area Location2',Market_ISO__c = 'MY');
        locHrEndmarket.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : 'National' Limit 1].Id;
        insert locHrEndmarket;
        
        resource.ivybase__Location_Hierarchy__c = locHrEndmarket.Id;
        update resource;
        
        Id retail = [Select Id from RecordType Where DeveloperName='Retail_Account' 
                                                  AND SobjectType='Account'].Id;
        system.debug('retail'+retail);
        
        Account acc = new Account(Name='Test Store',ivybase__Resource__c=resource.Id,
                                 RecordTypeId=retail,ivybase__Location_Hierarchy__c=location.Id,
                                 ivybase__Internal_Id__c =12,Payer_Code__c='TestPayer',Kerastase_Luxury_Mag__c='HH',
                                 ivybase__Active__c='Yes',Last_Visit_Date__c=System.today(),LastInvoiceDate__c=System.today(),
                                  ivybase__Status__c='Active',Average_Order_Value__c=1000,Due_Amount__c=500,
                                  Active__c='Yes',Is_Conquest__c=true,
                                 AccountNumber='123456',Sold_To_Party_Number__c='GAF345',Market_ISO__c = 'MY');
        insert acc;
        acc.ivybase__Active__c='Yes';
        update acc;
        System.debug('acc:: '+acc);
        
        ivybase__Standard_List_Master__c standard = new ivybase__Standard_List_Master__c(ivybase__List_Name__c='Hair Color',ivybase__List_Type__c='SUB_AXE_LEVEL',
                                                                                        ivybase__List_Code__c='HCLR-1',ivybase__Location_Hierarchy__c=locHrEndmarket.Id,ivybase__Resource_Type__c=resType.Id);
        insert standard;
        ivybase__Standard_List_Master__c standard1 = new ivybase__Standard_List_Master__c(ivybase__List_Name__c='LL',ivybase__List_Type__c='LUXURY_MAG',
                                                                                        ivybase__List_Code__c='LL',ivybase__Location_Hierarchy__c=locHrEndmarket.Id,ivybase__Resource_Type__c=resType.Id);
        insert standard1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Hair Color','Sub_Axe', true ,'Yes'); 
        insert ph;
        
        Turnover__c turnOver = new Turnover__c(Account__c=acc.Id, Market_ISO__c = 'MY', Product_Hierarchy__c=ph.Id,Sales_Value__c=12,Month__c=Date.today().month(),Year__c=date.today().year(),Resource__c=resource.Id);
        insert turnOver;
        
        Contract__c contract = new Contract__c(Name='Test contract 1',Account__c=acc.Id,Start_Date__c=date.today(),End_Date__c=date.today().addDays(+5));
        insert contract;
        
        Document__c doc = new Document__c(Name='Test 01',Available__c=true,Retailer__c=acc.Id,Document_Name__c='Test Document');
        insert doc;
        System.debug('doc:: '+doc);
        Partner_Function__c p=new Partner_Function__c(Account__c=acc.id,Type__c='Payer',Partner__c=acc.id,Market_ISO__c = 'MY');
        insert p;
        Test.startTest();
        RESTCustomerInfo.getCustomerInfo();
        Test.stopTest();
                
    }
    
  /*  @isTest
    private static void  testCustomerInfoException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            RESTCustomerInfo.getCustomerInfo();
        }
        Test.stoptest();
    }
*/
}