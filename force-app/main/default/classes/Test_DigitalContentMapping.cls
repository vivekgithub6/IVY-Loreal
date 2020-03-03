@isTest
public class Test_DigitalContentMapping{
    static testmethod void method1(){
        //Id sellerId = userinfo.getUserId();
       // Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
           User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
      List<ivybase__Resource__c> resourceList = new List<ivybase__Resource__c>{
            new ivybase__Resource__c(Name = 'Test', Market_ISO__c = 'JPN', ivybase__Related_User__c = UserInfo.getUserId())
        };
        insert resourceList;
       ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = usr.Market_ISO__c, ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=resourceList[0].Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByName().get('Country').getRecordTypeId());
           
      insert i1;
           ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = usr.Market_ISO__c, ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=resourceList[0].Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByName().get('Province').getRecordTypeId(),ivybase__Parent__c=i1.id);
           
      insert i2;
        
            List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'PRODUCT_TAGGING'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Matrix', ivybase__List_Name__c = 'Matrix', ivybase__List_Type__c = 'DIVISION_TYPE')    
        }; 
        insert stdMasterList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retail Account').getRecordTypeId();
        Account acc = new Account(Name='aaa', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id);
        acc.Is_Conquest__c = true;
        insert acc;
        
        Contact con = new Contact(Lastname = 'Testcon',Email = 'Test@gmail.com',ivybase__Related_User__c = UserInfo.getuserId());
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Merchandiser').getRecordTypeId();
        insert con;    
        
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = usr.Market_ISO__c);
        insert div;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Market_ISO__c = usr.Market_ISO__c,Division__c = div.Id);
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',Market_ISO__c = usr.Market_ISO__c);
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByName().get('Sub Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',Market_ISO__c = usr.Market_ISO__c);
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',Market_ISO__c = usr.Market_ISO__c);//ivybase__Parent__c=node3.Id
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByName().get('Node4').getRecordTypeId();
        insert node4;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = resourceList[0].Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Is_Conquest__c = true;
        update acc;
         
        StoreDivisionMapping__c divMap = new StoreDivisionMapping__c(Account__c = acc.Id,Store_Hierarchy__c=node4.Id,Market_ISO__c = usr.Market_ISO__c);
        insert divMap; 
        
        string q='SELECT Id, ivybase__Location_Hierarchy__c, ivybase__Store_Hierarchy__c, ivybase__Store_Hierarchy__r.ivybase__Parent__c, ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Location_Hierarchy__r.ivybase__Parent__c, ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, ivybase__Internal_Id__c FROM Account WHERE   ivybase__Active__c = \'Yes\' AND ivybase__Internal_Id__c != NULL';            
        system.debug('DQ'+  Database.query(q));
        string q1='SELECT Id, ivybase__Store__c,ivybase__Territory1__c,ivybase__Location_Hierarchy__c,ivybase__From__c,ivybase__To__c,ivybase__Location_Hierarchy__r.ivybase__Current_Resource__c, ivybase__Territory1__r.ivybase__Current_Resource__c FROM ivybase__Territory_Store_Mapping__c  WHERE (ivybase__From__c = null OR ivybase__From__c <= TODAY) AND (ivybase__To__c = null OR ivybase__To__c >= TODAY) AND ivybase__Store__c != NULL';
        system.debug('resourceList[0].Id'+resourceList[0].Id);
         ivybase__Digital_Content__c dc = new ivybase__Digital_Content__c();
        dc.Name = 'Testdc';
        dc.ivybase__Description__c = 'TestDescription';
        dc.ivybase__Image_Url__c = 'www.google.com';
        dc.ivybase__Image_Path__c= 'this is a path';
        dc.ivybase__Image_Name__c='Name of image';
        dc.Market_ISO__c = usr.Market_ISO__c;
        insert dc;
        ivybase__Product_Hierarchy__c ph = new ivybase__Product_Hierarchy__c();
        ph.Name = 'testprohie';
        ph.ivybase__Code__c = 'testcodehie';
        ph.ivybase__Is_Competitor__c = true;
        ph.ivybase__Active__c = 'Yes';
        ph.Market_ISO__c = usr.Market_ISO__c;
        insert ph;
      
      ivybase__Product__c productmaster=new ivybase__Product__c();
        productmaster.Name='test';
        productmaster.Market_ISO__c = usr.Market_ISO__c;
        productmaster.ivybase__Active__c = 'yes';
        insert productmaster;
        
        ivydsd__Scheme__c sch = new ivydsd__Scheme__c();
        sch.Name = 'Testscheme';
        sch.ivydsd__Active__c = 'Yes';
        sch.ivydsd__Code__c = 'Test code';
        sch.ivydsd__Description__c = 'test desc';
        sch.ivydsd__From__c = System.Today().addDays(-1);
        sch.ivydsd__To__c = System.Today().addDays(1);
        sch.ivydsd__Scheme_Buy_Logic__c = 'Any'; 
        sch.ivydsd__Scheme_Get_Logic__c = 'Any';
        sch.ivydsd__Scheme_Type__c = 'QTY';
        sch.Market_ISO__c = usr.Market_ISO__c;
        insert sch;
        
        ivybase__Digital_Content_Mapping__c dcm = new ivybase__Digital_Content_Mapping__c();
        dcm.ivybase__Digital_Content__c = dc.Id;
       dcm.ivybase__Product_Hierarchy__c = ph.Id;
        dcm.ivybase__Retailer__c = acc.Id;
        dcm.ivybase__Store_Hierarchy__c = node4.Id;
        dcm.ivybase__User__c = UserInfo.getuserId();
         dcm.Standard_List_Master__c=stdMasterList[0].id;
        dcm.Product_Master__c=productmaster.id;
        dcm.Scheme__c = sch.Id;
       // dcm.ivybase__Resource_Type__c=restyp.id;
        insert dcm;
        
        ivybase__Digital_Content_Mapping__c dcm1 = new ivybase__Digital_Content_Mapping__c();
        dcm1.ivybase__Digital_Content__c = dc.Id;
        dcm1.ivybase__Product_Hierarchy__c = ph.Id;
        dcm.ivybase__Retailer__c = acc.Id;
        dcm1.ivybase__Store_Hierarchy__c = node4.Id;
        dcm1.ivybase__User__c = UserInfo.getuserId();
        dcm1.Standard_List_Master__c=stdMasterList[0].id;
        dcm1.Scheme__c = sch.Id;
        insert dcm1;
        
        RExAPIResponseDomain.MultipleResponseInfo DigitalContentMaster  = RestDigitalContentMapping.getDigitalContentMasters();
        system.assert(DigitalContentMaster != null);
      
        AccountService.getAllRetailerMaster_List();
        AccountService.getAllRetailerMaster_List_from_Route();
            
            try{
                 RestDigitalContentMapping.getDigitalContentMasters();
               RestDigitalContentScheme.getDigitalContentSchemeinfo();
            }catch(Exception e){}
            
          
           
        
    }
    static testmethod void method2(){
     RestDigitalContentMapping.getDigitalContentMasters();   
        DigitalContentMappingService.getAllContentData(null);
    } 
       
}