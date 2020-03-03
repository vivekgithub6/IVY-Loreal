@isTest
public class TESTRESTLastVisitStockManager {
    private static testMethod void testLastVisit()
    {
        Id userId = UserInfo.getUserId();
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType; 
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Resource',Market_ISO__c = 'MY',ivybase__Related_User__c=userId,ivybase__Resource_Type__c=resType.Id);
        insert resource;
        
        
        Id storeHie = [Select Id from RecordType Where DeveloperName='Node4' 
                                                  AND SobjectType='ivybase__Store_Hierarchy__c'].Id;
        ivybase__Store_Hierarchy__c storeHierarchy = new ivybase__Store_Hierarchy__c(Name='Test hierarchy',Market_ISO__c='MY',ivybase__Active__c='yes',RecordTypeId=storeHie);
        insert storeHierarchy;
        
        
        Id territory = [Select Id from RecordType Where DeveloperName='Territory' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c='MY',RecordTypeId=territory,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert location; 
        
        ivybase__Location_Hierarchy__c locHrEndmarket = new ivybase__Location_Hierarchy__c(Name='Jon Area Location2',Market_ISO__c='MY');
        locHrEndmarket.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : 'National' Limit 1].Id;
        insert locHrEndmarket;
        
        resource.ivybase__Location_Hierarchy__c = locHrEndmarket.Id;
        update resource;
        
        Id retail = [Select Id from RecordType Where DeveloperName='Retail_Account' 
                                                  AND SobjectType='Account'].Id;
        system.debug('retail'+retail);
        
        Account acc = new Account(Name='Test Store',Is_Conquest__c = true,Market_ISO__c='MY',ivybase__Resource__c=resource.Id,RecordTypeId=retail,ivybase__Location_Hierarchy__c=location.Id,ivybase__Store_Hierarchy__c=storeHierarchy.Id,ivybase__Active__c='Yes',ivybase__Status__c='Active',Active__c='Yes');
        insert acc;
        acc.Active__c='Yes';
        acc.ivybase__Active__c='Yes';
        update acc;
        System.debug('RetailAccount:::'+[select ivybase__Active_Formula__c,ivybase__Active__c from Account where id=:acc.id].ivybase__Active__c);
        
        StoreDivisionMapping__c storeDiv = new StoreDivisionMapping__c(Account__c=acc.Id,Store_Hierarchy__c=storeHierarchy.Id,Market_ISO__c='MY');
        insert storeDiv;
        
        ivybase__Product_Hierarchy__c ph2 =new ivybase__Product_Hierarchy__c(Name='store Hie2',Market_ISO__c='MY',ivybase__Is_Competitor__c=False,ivybase__Active__c='Yes' );
        ph2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Function' LIMIT 1].Id;

        insert ph2;
        
        ivybase__Product__c product = new ivybase__Product__c(Name='Test Product',ivybase__Active__c='Yes',Market_ISO__c='MY',ivybase__Parent__c=ph2.Id);
        insert product;
        
        
        
        ivybase__Visit__c vi = new ivybase__Visit__c(ivybase__Original_Date__c=system.today(), ivybase__Store__c=acc.Id , ivybase__Status__c='Completed');
        insert vi;
        
        ivybase__Location__c loc = new ivybase__Location__c(Name='Location',ivybase__Active__c='Yes',Market_ISO__c='MY');      
        loc.ivybase__Code__c ='CODE';   
        loc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : 'In_Store' Limit 1].Id;
        insert loc;
        
        ivybase__Location_Stock__c stock= new ivybase__Location_Stock__c(ivybase__VanLoad_Mobile_Uid__c=null,ivybase__Location__c=loc.Id,Market_ISO__c='MY',ivybase__Product__c= product.Id ,ivybase__Visit__c=vi.id ,ivybase__Type__c='Stock Check',ivybase__UOM1__c=3);   
        insert stock; 
        
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Piece';
        slm1.ivybase__List_Code__c = 'PIECE';
        slm1.ivybase__List_Type__c = 'PRODUCT_UOM';
        insert slm1;
        
        RESTLastVisitStockManager.getLastVisitStockrecords();
      }
    private static testmethod void testmethod2(){
        RESTLastVisitStockManager.getLastVisitStockrecords();
    }

}