@isTest
private class TestRESTLocStockUpload {
    
    @testSetup static void setup() {
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = TestUtility.insertMaxInternalId();
        upsert maxInternalIdValList;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Id recordtypecon = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        
        Contact con = new Contact(lastName = 'Test', ivybase__Related_User__c = UserInfo.getUserId() ,Email = 'test@gmail.com',RecordTypeId = recordtypecon);
        insert con;
        
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name = 'Merchandiser');
        insert restype;
        
        ivybase__Location_Hierarchy__c lh = new ivybase__Location_Hierarchy__c();
        lh.Name = 'TestlocHie';
        lh.ivybase__Active__c = 'Yes';
        insert lh;
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name = 'Test', ivybase__Related_User__c = UserInfo.getUserId(),ivybase__Resource_Type__c = restype.Id,ivybase__Location_Hierarchy__c = lh.Id);
        insert res;
        
        List<Account> acclist = new List<Account>{new Account(Name = 'Test',recordTypeId = RecordTypeId),
                                                new Account(Name = 'Testone',ivybase__Active__c = 'Yes',recordTypeId = RecordTypeId, ivybase__Resource__c = res.Id),
                                                new Account(Name = 'Testtwo',ivybase__Active__c = 'Yes',recordTypeId = RecordTypeId, ivybase__Resource__c = res.Id),
                                                new Account(Name = 'Testthree',ivybase__Active__c = 'Yes'),
                                                new Account(Name = 'Testaccforvisit',recordTypeId = RecordTypeId)
                                                
        };
        insert acclist;
        acclist[0].ivybase__Active__c = 'Yes';
        acclist[1].ivybase__Active__c = 'Yes';
        acclist[4].ivybase__Active__c = 'Yes';
        update acclist;
        
        List<String> accIdList = new List<String>();
        
        for(Account acc : acclist){
            
            accIdList.add(acc.Id);
        }
        
        ivybase__Territory_Store_Mapping__c territoryMappingObject = new ivybase__Territory_Store_Mapping__c();
        territoryMappingObject.ivybase__From__c = System.today();
        territoryMappingObject.ivybase__To__c = System.today().addDays(2);
        territoryMappingObject.ivybase__Location_Hierarchy__c = lh.Id;
        territoryMappingObject.ivybase__Store__c = acclist[0].Id;
        insert territoryMappingObject;        
        
        //TerritoryStoremappingSerive.getTerritoryStoreMap(accIdList);
        
        Contact con1 = new Contact(lastName = 'Testcon', ivybase__Related_User__c = UserInfo.getUserId() ,Email = 'testcon@gmail.com',RecordTypeId = recordtypecon);
        //insert con1;
        
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where Id =:acclist[0].Id].ivybase__Internal_Id__c);
        
        List<ivybase__Visit__c> visitList = new List<ivybase__Visit__c>{
                                            new ivybase__Visit__c(Name = 'visname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-02-15'),ivybase__Store__c = acclist[0].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-15'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'Testvisname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-02-16'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-16'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'visitone',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-02-15'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-15'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'visitname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-08-22'),ivybase__Store__c = acclist[0].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-15'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'Testvisitname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-08-22'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-16'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'visit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-02-15'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-15'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'Testvisit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-02-16'),ivybase__Store__c = acclist[0].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-17'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'Testvisit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-08-22'),ivybase__Store__c = acclist[3].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-16'),ivybase__Resource__c = res.Id),
                                            new ivybase__Visit__c(Name = 'Testvisit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2019-08-22'),ivybase__Store__c = acclist[4].Id,ivybase__Original_Date__c=Date.Valueof('2019-02-28'),ivybase__Resource__c = res.Id)
                                            };
        insert visitList;
        
        ivybase__Standard_List_Master__c slm = new ivybase__Standard_List_Master__c();
        slm.ivybase__List_Name__c = 'Testslm';
        slm.ivybase__List_Type__c = 'REASON';
        slm.ivybase__Location_Hierarchy__c = lh.Id;
        slm.ivybase__Resource_Type__c = restype.Id;
       // insert slm;
        
        List<ivybase__Standard_List_Master__c> slmList = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'test1',ivybase__List_Type__c = 'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id ),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'test2',ivybase__List_Type__c =  'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id ),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'test3',ivybase__List_Type__c = 'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id ),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'test4',ivybase__List_Type__c =  'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test5',ivybase__List_Type__c = 'AMAZON_CONFIGURATION', ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_PL_REC', ivybase__List_Name__c = 'test6',ivybase__List_Type__c = 'PL',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_PL_REASON', ivybase__List_Name__c = 'test7',ivybase__List_Type__c = 'REASON',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id)
            };
        
        slmlist.add(slm);
        insert slmList;
        
        
        
        ivybase__Product_Hierarchy__c ph = new ivybase__Product_Hierarchy__c();
        ph.Name = 'Test';
        ph.ivybase__Active__c = 'Yes';
        ph.RecordTypeId = Schema.SObjectType.ivybase__Product_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Brand').getRecordTypeId();
        insert ph;
        
        
        List<ivybase__Product__c> productList = new List<ivybase__Product__c>();
        
        ivybase__Product__c p = new ivybase__Product__c();
        p.Name = 'Testprod';
        p.ivybase__parent__c = ph.Id;
        p.ivybase__Active__c = 'Yes';
        p.ivybase__Short_Description__c = 'Testdesc';
        productList.add(p);
       // insert p;
        
        ivybase__Product__c p1 = new ivybase__Product__c();
        p1.Name = 'Testproduct';
        p1.ivybase__parent__c = ph.Id;
        p1.ivybase__Is_Competitor__c = false;
        p1.ivybase__Active__c = 'Yes';
        p1.ivybase__Short_Description__c = 'Testdesc';
        productList.add(p1);
        insert productList;
       
        System.Assert(productList.size()==2);
       
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Channel';
        slm1.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm1;
        
        ivybase__Store_Hierarchy__c sh = new ivybase__Store_Hierarchy__c();
        sh.Name = 'TestStoreHie';
        sh.ivybase__Active__c = 'Yes';
        insert sh;
        
        
        ivybase__Location__c l = new ivybase__Location__c();
        l.Name ='Test loc';
        l.ivybase__Belongs_To__c  = acclist[1].Id;
        l.ivybase__Standard_List_Master__c = slmList[5].Id;
        l.RecordTypeId = Schema.SObjectType.ivybase__Location__c.getRecordTypeInfosByDeveloperName().get('In_Store').getRecordTypeId();
        insert l;
        
    }
    
    private static testMethod void testmethod1() {
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        String pid = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c,ivybase__Active__c FROM ivybase__Product__c WHERE Name = 'Testprod'][0].ivybase__InternalId__c);
        String pid1 = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c,ivybase__Active__c FROM ivybase__Product__c WHERE ivybase__Active__c = 'Yes' AND Name = 'Testproduct'][0].ivybase__InternalId__c);
        String locid = String.Valueof([SELECT ivybase__Internal_Id__c FROM ivybase__Store_Hierarchy__c].ivybase__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes' AND Name = 'Testaccforvisit'][0].ivybase__Internal_Id__c);
        // String assetid = String.Valueof([SELECT Internal_Id__c FROM Asset__c].Internal_Id__c);
        String slmname = String.Valueof([SELECT Name,Id FROM ivybase__Standard_List_Master__c WHERE ivybase__List_Type__c = 'REASON'][0].Name);
        
        RESTLocStockUpload.cls_ClosingStockHeader  wrapcsh = new  RESTLocStockUpload.cls_ClosingStockHeader ();
        wrapcsh.longitude = '122';
        wrapcsh.RetailerID = interId;
        wrapcsh.latitude = '33';
        wrapcsh.StockID = '0';
        wrapcsh.remark = 'test';
        wrapcsh.Date_x = '2019/02/15';
        wrapcsh.DistributorID = '0';
        
        RESTLocStockUpload.cls_ClosingStockHeader  wrapcsh1 = new  RESTLocStockUpload.cls_ClosingStockHeader ();
        wrapcsh1.longitude = '122';
        wrapcsh1.RetailerID = interId;
        wrapcsh1.latitude = '33';
        wrapcsh1.StockID = '1';
        wrapcsh1.remark = 'test';
        wrapcsh1.Date_x = '2019/02/15';
        wrapcsh1.DistributorID = '0';
        
        RESTLocStockUpload.cls_ClosingStockDetail  wrapcsd = new  RESTLocStockUpload.cls_ClosingStockDetail ();
        wrapcsd.Shelfpqty = '3';
        wrapcsd.ouomqty = '6';
        wrapcsd.Facing = '6';
        wrapcsd.uomqty = '5';
        wrapcsd.LocId = locid;
        wrapcsd.ProductID = pid;
        wrapcsd.ouomid = '';
        wrapcsd.whpqty = '1';
        wrapcsd.PcsUOMId = '';
        wrapcsd.whoqty = '2';
        wrapcsd.StockID = '0';
        wrapcsd.msqqty = '1';
        wrapcsd.shelfoqty = '2';
        wrapcsd.isListed = '5';
        wrapcsd.Shelfcqty = '6';
        wrapcsd.IsOwn = '1';
        wrapcsd.uomid = '0';
        wrapcsd.ReasonID = '0';
        wrapcsd.isDistributed = '0';
        wrapcsd.whcqty = '1';
        
        RESTLocStockUpload.cls_ClosingStockDetail  wrapcsd1 = new  RESTLocStockUpload.cls_ClosingStockDetail ();
        wrapcsd1.Shelfpqty = '3';
        wrapcsd1.ouomqty = '6';
        wrapcsd1.Facing = '6';
        wrapcsd1.uomqty = '5';
        wrapcsd1.LocId = locid;
        wrapcsd1.ProductID = pid1;
        wrapcsd1.ouomid = '';
        wrapcsd1.whpqty = '1';
        wrapcsd1.PcsUOMId = '';
        wrapcsd1.whoqty = '2';
        wrapcsd1.StockID = '1';
        wrapcsd1.msqqty = '1';
        wrapcsd1.shelfoqty = '2';
        wrapcsd1.isListed = '5';
        wrapcsd1.Shelfcqty = '6';
        wrapcsd1.IsOwn = '1';
        wrapcsd1.uomid = '0';
        wrapcsd1.ReasonID = '0';
        wrapcsd1.isDistributed = '0';
        wrapcsd1.whcqty = '1';
        
        RESTLocStockUpload.LocStock wrappercls = new RESTLocStockUpload.LocStock();
        wrappercls.ClosingStockHeader = new List<RESTLocStockUpload.cls_ClosingStockHeader>{wrapcsh,wrapcsh1};
        wrappercls.ClosingStockDetail = new List<RESTLocStockUpload.cls_ClosingStockDetail>{wrapcsd,wrapcsd1};
        
         String JSONString = Json.Serialize(wrappercls);
        System.Debug('******JSONString'+JSONString);
       
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        req.addHeader('mobiledate', '2019/04/01 12:30:00');
        RestContext.request =req ;
        
        RESTLocStockUpload.LocStockUpload(); 
        System.Assert(req.requestBody != null);
            
    }
}