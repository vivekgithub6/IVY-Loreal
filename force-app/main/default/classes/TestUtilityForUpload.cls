@isTest
public class TestUtilityForUpload {
    
    //Function Call: ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId);
    public static ivybase__Resource__c createTestResource(String resourceName, Id curUserId) {
        List<ivybase__Resource__c> resorce =[select Id,Name,ivybase__Related_User__c 
                    from ivybase__Resource__c Where ivybase__Related_User__c =:curUserId];
        
        if(!resorce.isEmpty()){
            
                return resorce[0];
        }else{
             ivybase__Resource__c res = new ivybase__Resource__c(Name = resourceName,ivybase__Related_User__c = curUserId);
              return res;
        }
    }
    
     //Function Call:  ivybase__Resource_Type__c restyp = TestUtility.createTestResourceType('Merchandiser');
    
    public static ivybase__Resource_Type__c createTestResourceType(string resourceTypeName){
        ivybase__Resource_Type__c restyp = new ivybase__Resource_Type__c();
        restyp.Name = resourceTypeName;
        return restyp;
        
    }

    //Function Call: ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,resType.id);     
    
    public static ivybase__Resource__c createTestResource(String resourceName, Id curUserId,Id resourceTypeId){
       ivybase__Resource__c res = createTestResource(resourceName,curUserId);           
       res.ivybase__Resource_Type__c = resourceTypeId;    
       return res;
    }
    
    //Function Call: ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',primaryRes.Id);   
    public static ivybase__Location_Hierarchy__c createTestLocationHierarchy(String locHrName, Id primaryResId){
       ivybase__Location_Hierarchy__c locHr = new ivybase__Location_Hierarchy__c();
       locHr.Name = locHrName;
       locHr.ivybase__Primary_Resource__c = primaryResId;
       locHr.ivybase__Active__c = 'Yes';
       return locHr;
    }
    
    //Function Call: Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Outlet' , 'Yes' );
    
    public static Account createTestAccount(String storeCode, String accName ,String payer, 
                                     String phone ,id resID , String recordTypeName , String isActive) {
                                        
        Account acc = new Account();
        acc.ivybase__StoreCode__c =storeCode;
        acc.Name = accName;
        acc.Phone = phone;
        acc.Payer_Code__c =  payer;                                
        acc.ivybase__Status__c='Active';
        acc.ivybase__Resource__c = resID;
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : recordTypeName Limit 1].Id;
        acc.ivybase__Active__c = isActive;
        return acc;
    }
    
     //Function Call:  ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        
    public static ivybase__Product_Hierarchy__c  createTestProductHierarchy(String phName , String recordTypeName , 
                                                                     boolean competitor , String isActive) {
        ivybase__Product_Hierarchy__c ph2 = new ivybase__Product_Hierarchy__c();    
        ph2.Name = phName;
        ph2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : recordTypeName LIMIT 1].Id;
        ph2.ivybase__Is_Competitor__c = competitor;
        ph2.ivybase__Active__c = isActive;
        return ph2;
    }
    
    //Function Call:  ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
    
    public static ivybase__Product__c  createTestProduct(String pdName , Id productHierachyId, String shortDescription , 
                                                                     boolean isCompetitor , String isActive) {
        ivybase__Product__c pd = new ivybase__Product__c(); 
        pd.Name = pdName;
        pd.ivybase__Parent__c = productHierachyId;
        pd.ivybase__Short_Description__c = shortDescription;
        pd.ivybase__Is_Competitor__c = isCompetitor;
        pd.ivybase__Default_UOM__c  = 'Piece';                                                               
        pd.ivybase__Active__c = isActive;
        return pd;
    }
    
    
    
    //Function Call: ivybase__Visit__c vi = TestUtility.createTestVisit('02/19/2018' , a.Id ,'');       
    public static ivybase__Visit__c  createTestVisit(String visitedDate , Id storeId , String status ) {
        ivybase__Visit__c vi = new ivybase__Visit__c();
        vi.ivybase__Visit_Date__c = date.parse(visitedDate);
        vi.ivybase__Store__c = storeId;
        vi.ivybase__Status__c = status;
        return vi;
    }
    
    
    //Function Call: ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Price_Check');
    public static  ivybase__Product_Group__c createTestProductGroup(string productGroupName, String isActive, String recordTypeName){
        ivybase__Product_Group__c pg1 = new ivybase__Product_Group__c();
        pg1.Name = productGroupName ;
        pg1.ivybase__Active__c = isActive ;
        pg1.RecordTypeID=[SELECT id FROM RecordType where DeveloperName = : recordTypeName LIMIT 1].id;        
        return pg1 ;   
    }
   
    //Function Call:  Contact c = TestUtility.createTestContact('Test','Contact', u.id , 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
      
    public static Contact createTestContact(String firstName,String LastName, Id curUserId ,
                                           String currencyIsoCode, String emailId, String sellerType,
                                           String recordTypeName ) {
        Contact c = new Contact();
        c.FirstName = firstName;
        c.LastName = LastName;
        c.ivybase__Related_User__c = curUserId;
        c.Email = emailId;
        c.ivybase__Seller_Type__c = sellerType;
        Id rTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =:recordTypeName Limit 1].Id;
        c.RecordTypeId = rTypeId;
        return c;
    }
    
     //Function Call:  List<ivybase__Standard_List_Master__c> slmlist = TestUtility.createTestStandardListMaster();    
    
    public static List<ivybase__Standard_List_Master__c>  createTestStandardListMaster(){
         List<ivybase__Standard_List_Master__c> slmlist = new List<ivybase__Standard_List_Master__c>();
       
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Case';
        slm1.ivybase__List_Code__c = 'Case';
        slm1.ivybase__List_Type__c = 'PRODUCT_UOM';
        slmlist.add(slm1);
        
        ivybase__Standard_List_Master__c slm2 = new ivybase__Standard_List_Master__c();
        slm2.ivybase__List_Name__c = 'Piece';
        slm2.ivybase__List_Code__c = 'Piece';
        slm2.ivybase__List_Type__c = 'PRODUCT_UOM';
        slmlist.add(slm2);
        
        ivybase__Standard_List_Master__c slm3 = new ivybase__Standard_List_Master__c();
        slm3.ivybase__List_Name__c = 'Outer';
        slm3.ivybase__List_Code__c = 'Outer';
        slm3.ivybase__List_Type__c = 'PRODUCT_UOM';
        slmlist.add(slm3);
       
        
        return slmlist;
    }
    
    //Function Call: List<ivybase__Product_UOM__c> pulist = TestUtility.createTestProductUOM(p.id);
    
    public static List<ivybase__Product_UOM__c> createTestProductUOM(id productId) {
        
        List<ivybase__Product_UOM__c> pulist = new List<ivybase__Product_UOM__c>();
        
        ivybase__Product_UOM__c pu1 = new ivybase__Product_UOM__c();
        pu1.ivybase__Product__c = productId;
        pu1.ivybase__UOM__c = 'BX';
        pu1.ivybase__UOM_Number__c = 'UOM 1';
        pulist.add(pu1);
     
        insert pulist;
        return pulist;
      
    }
    
    //Function Call: ivydsd__Order__c o = TestUtility.createTestOrder(acc1.id,'Ordered',con.id,'1');       
    
    public static ivydsd__Order__c  createTestOrder(id accId , string status , id contactId , string mobileOrderNumber) {
        ivydsd__Order__c o = new ivydsd__Order__c();
        o.ivydsd__Store__c = accId;
        o.ivydsd__Order_Status__c = status;
        o.ivydsd__Seller__c = contactId;
        o.ivydsd__Mobile_Order_Number__c = mobileOrderNumber;
        return o;
    }
    
    //Function Call:  ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , p.id, 0 , 0 , 0 , 0 , 0 , 0 );
    
    public static ivydsd__Order_Line_item__c createTestOrderLineItem(id orderId , id productId ,Integer uomRate1 ,
                                                Integer uomRate2 , Integer uomRate3, Integer uomQuantity1 ,
                                                 Integer uomQuantity2 , Integer uomQuantity3 ){
        ivydsd__Order_Line_item__c oli = new ivydsd__Order_Line_item__c();
        oli.ivydsd__Order__c = orderId;
        oli.ivydsd__Product1__c = productId;
        oli.ivydsd__UOM_1_Rate__c = uomRate1;
        oli.ivydsd__UOM_2_Rate__c = uomRate2;
        oli.ivydsd__UOM_3_Rate__c = uomRate3;
        oli.ivydsd__UOM_1_Quantity__c = uomQuantity1;
        oli.ivydsd__UOM_2_Quantity__c = uomQuantity2;
        oli.ivydsd__UOM_3_Quantity__c = uomQuantity3;
        return oli;
    }
    
    //Function Call: ivydsd__Invoice__c inv = TestUtility.createTestInvoice(acc1.id ,'1', 00 , o.id , con.id);    
        
    public static ivydsd__Invoice__c createTestInvoice(id accountId , String mobileInvoiceNumber ,
                                                       Integer invoiceAmount, id orderId, id contactId ){
        ivydsd__Invoice__c inv = new ivydsd__Invoice__c();
        inv.ivydsd__Store__c = accountId;
        inv.ivydsd__Mobile_Invoice_Number__c = mobileInvoiceNumber;
        inv.ivydsd__Invoice_Amount__c = invoiceAmount;
        inv.ivydsd__Order__c = orderId;
        inv.ivydsd__Seller__c = contactId;
        return inv;
    }
    
    //Function Call: ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,product.Id);    
        
    public static ivydsd__Invoice_Line_Item__c createTestInvoiceLineItem(Id invoiceId , Id prodId){
        ivydsd__Invoice_Line_Item__c invLineItem = new ivydsd__Invoice_Line_Item__c();
        invLineItem.ivydsd__Invoice__c = invoiceId;
        invLineItem.ivydsd__Product_Master1__c = prodId;
        return invLineItem;
    }
    
    //Function call:  ivybase__Location__c l = TestUtility.createTestLocation('testloc','Yes',acc.Id);
    
    public static ivybase__Location__c createTestLocation(string locationName, String isActive,String accId){
        ivybase__Location__c l = new ivybase__Location__c();
        l.Name = locationName;
        l.ivybase__Active__c = isActive;
        l.ivybase__Belongs_To__c  = accId;
        l.RecordTypeId = Schema.SObjectType.ivybase__Location__c.getRecordTypeInfosByName().get('In Store').getRecordTypeId();
        return l;
    }
    
    //Function call:  ivybase__Location_Stock__c ls = BATTestUtility.createTestlocationStock('1', l.id , p.id );
    
    public static ivybase__Location_Stock__c createTestlocationStock(string vanLoadMobileUid , id locationId , id productId){
        ivybase__Location_Stock__c ls = new ivybase__Location_Stock__c();
        ls.ivybase__VanLoad_Mobile_Uid__c = vanLoadMobileUid;
        ls.ivybase__Location__c = locationId;
        ls.ivybase__Product__c = productId;
        return ls;
    }
    
    
    
    
    //Function Call: Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
    public static Incentive_Group__c createTestIncentiveDroup(String Name){
        Incentive_Group__c incentiveGrp = new Incentive_Group__c();
        incentiveGrp.Name = Name;
        return incentiveGrp;
    }
    
    //Function Call: Target_Actual__c targetActual = TestUtility.createTestTargetActual('TestTarget',1000,incentive.Id,resId,'');   
    public static Target_Actual__c createTestTargetActual(String Name, Integer actual,String incId,String resId,String phId){
        Target_Actual__c target = new Target_Actual__c();
        target.Name = Name;
        target.Actual__c = actual;
        target.Incentive_Group__c = incId;
        target.Resource__c = resId;
        //target.Product_Hierarchy__c = phId;
        return target;
    }

    //Function Call: Incentive_Slab__c incentiveSlab = TestUtility.createTestIncentiveSlab('TestTarget',1000,2000,1500,ph.Id);   
    public static Incentive_Slab__c createTestIncentiveSlab(String Name, Integer maximum,Integer minimum,Integer incentive,String incGrpId){
        Incentive_Slab__c slab = new Incentive_Slab__c();
        slab.Name = Name;
        slab.Maximum__c = maximum;
        slab.Minimum__c = minimum;
        slab.Incentive__c = incentive;
        slab.Incentive_Group__c = incGrpId;
        
        return slab;
    }
    
   //Function Call: ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
    public static ivybase__Route__c createTestRoute(String resId, String status){
        ivybase__Route__c route = new ivybase__Route__c();
        route.ivybase__Resource__c = resId;
        route.ivybase__Active__c = status;
        return route;
    }
    
    //Function Call: ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
    public static ivybase__Route_Details__c createTestRouteDetail(String name,String routeId, String status, String accId){
        ivybase__Route_Details__c routedetail = new ivybase__Route_Details__c();
        routedetail.Name = name;
        routedetail.ivybase__Route__c = routeId;
        routedetail.ivybase__Active__c = status;
        routedetail.ivybase__Store__c = accId;
        return routedetail;
    }
    
    //Function Call: Territory_Routing__c routeDetail = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
    public static Territory_Routing__c createTestTerrRouting(String name,String routeId, String locId){
        Territory_Routing__c terrRouting = new Territory_Routing__c();
        terrRouting.Name = name;
        terrRouting.Route__c = routeId;
        terrRouting.Location_Hierarchy__c = locId;
        return terrRouting;
    }
    
     //Function Call:  User u =TestUtility.createTestUser('UserA','standtd',p.id);  
          
    public static user createTestUser(string userLastName,string alias,Id profileId){
    id userId = userInfo.getUserId();
     User u = new User();
        u.Alias = alias;
        u.Email = alias+'123@testorg123.com';
        u.EmailEncodingKey ='UTF-8';
        u.LastName = userLastName;
        u.LanguageLocaleKey ='en_US';                             
        u.LocaleSidKey ='en_US';
        u.ProfileId = profileId;                           
        u.TimeZoneSidKey ='America/Los_Angeles';
        u.UserName = u.Email;
        return u;
    }
    
    public static void createAllHierarchyLevels(){
            //createTestResource
            //createTestUser
            //createTestLocationHierarchy---does not set record type
            // Levels -Territory, Area, Regional, National
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            
            ivybase__Resource_Type__c restype = createTestResourceType('Terr ResType');
            insert restype;
            
            List<User> users = new List<User>();
            user uTerr = createTestUser('Terr User','Terr',p.id);
            users.add(uTerr);
            user uArea = createTestUser('Area User','Area',p.id);
            users.add(uArea);
            user uReg = createTestUser('Reg User','Reg',p.id);
            users.add(uReg);
            user uNat = createTestUser('Nat User','Nat',p.id);
            users.add(uNat);
            
            insert users;
            
            List<ivybase__Resource__c> resList = new List<ivybase__Resource__c>();
            ivybase__Resource__c resTerr = createTestResource('Terr Res',userinfo.getuserId());
            resTerr.ivybase__Resource_Type__c = restype.id;
            resList.add(resTerr);
            ivybase__Resource__c resArea = createTestResource('Area Res',uArea.id);
            resList.add(resArea);
            ivybase__Resource__c resReg = createTestResource('Reg Res',uReg.id);
            resList.add(resReg);
            ivybase__Resource__c resNat = createTestResource('Nat Res',uNat.id);
            resList.add(resNat);
            
            if(!resList.isEmpty()){
                try{
                insert resList;
                }catch(Exception e){
                    system.debug('Insert Failed:::'+e.getMessage());
                }
            }
            System.debug('resList::: ' +resList);
            
            Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByName();
            system.debug(RT);
                       
            List<ivybase__Location_Hierarchy__c> locList = new List<ivybase__Location_Hierarchy__c>();
            
            
            ivybase__Location_Hierarchy__c locNat = new ivybase__Location_Hierarchy__c();
           
            locNat = createTestLocationHierarchy('Loc Nat',resNat.Id);
            locNat.RecordTypeId = RT.get('National').getRecordTypeId();
            insert locNat;
          
           ivybase__Location_Hierarchy__c locReg = new ivybase__Location_Hierarchy__c();
          
            locReg = createTestLocationHierarchy('Loc Reg',resReg.id);
            locReg.RecordTypeId = RT.get('Regional').getRecordTypeId();
            locReg.ivybase__Parent__c = locNat.id;
            insert locReg;
           
            ivybase__Location_Hierarchy__c locArea = new ivybase__Location_Hierarchy__c();
           
            locArea = createTestLocationHierarchy('Loc Area',resArea.id);
            locArea.RecordTypeId = RT.get('Area').getRecordTypeId();
            locArea.ivybase__Parent__c = locReg.id;
            insert locArea;
       
           
         ivybase__Location_Hierarchy__c locTerr = new ivybase__Location_Hierarchy__c();
        
            locTerr = createTestLocationHierarchy('Loc Terr',resTerr.id);
            locTerr.RecordTypeId = RT.get('Territory').getRecordTypeId();
            locTerr.ivybase__Parent__c = locArea.id;
            locTerr.ivybase__Resource_Type__c = restype.id;
            insert locTerr;
          
            system.debug('locTerr'+locTerr);
            system.debug('resTerr'+resTerr);
            
            
            
            for(ivybase__Resource__c resource : resList){
                resource.ivybase__Location_Hierarchy__c = locNat.id;
            } 
            update resList;

        }
    
public class UserRelatedInfo{
public List<Account> acc;

}

    
}