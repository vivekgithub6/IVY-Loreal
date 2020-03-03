@isTest
public without sharing class TestUtility {
    
    //function call : TestUtility.createSaloonInvoice (Date secondLastInvoiceDate,Date LastvisitDate,Date LastInvoiceDate,Id resource,Id Account,Id Division,Decimal AverageOrderValue)
    public static SaloonInvoice__c   createSaloonInvoice (Date secondLastInvoiceDate,Date LastvisitDate,Date LastInvoiceDate,Id resource,Id Account,Id Division,Decimal AverageOrderValue){
        SaloonInvoice__c     saloonInvoice = new SaloonInvoice__c();
        saloonInvoice.SecondLastInvoiceDate__c=secondLastInvoiceDate;
        saloonInvoice.Last_Visit_Date__c=LastvisitDate;
        saloonInvoice.LastInvoiceDate__c=LastInvoiceDate;
        saloonInvoice.Account__c=Account;
        //saloonInvoice.Division__c=Division;
        saloonInvoice.Average_Order_Value__c=AverageOrderValue;
        saloonInvoice.Resource__c=resource;
        saloonInvoice.Market_ISO__c = 'MY';
        return saloonInvoice;
    }
    
    //function call : TestUtility.createdivisionLocation (Id division,Id locationHierarchy)
    public static DivisionLocation__c    createdivisionLocation (Id division,Id locationHierarchy){
        DivisionLocation__c    div = new DivisionLocation__c   ();
        div.Location_Hierarchy__c=locationHierarchy;
        div.Division__c =division;
        div.Market_ISO__c = 'MY';
        return div;
    }
    
    //function call : TestUtility.createdivision (String code)
    public static Division__c    createdivision (String code){
        Division__c   div = new Division__c  ();
        div.Division_Code__c =code;
        div.Market_ISO__c = 'MY';
        return div;
    }
    
    //function call : TestUtility.createSchemeSlabTarget(Integer MinimumValue,Integer MaximumValue,Id ProductMasterId,Id PromotionSlabId,String PromotionSlabTargetName,String Type,String UOM)
    public static ivydsd__Scheme_Slab_Target__c createSchemeSlabTarget(Integer MinimumValue,Integer MaximumValue,Id ProductMasterId,Id PromotionSlabId,String PromotionSlabTargetName,String Type,String UOM,Id SchemeGroupId){
        ivydsd__Scheme_Slab_Target__c schemeSlabTarget = new ivydsd__Scheme_Slab_Target__c();
        schemeSlabTarget.ivydsd__Minimum_Value__c = MinimumValue;
        schemeSlabTarget.ivydsd__Maximum_Value__c = MaximumValue;
        schemeSlabTarget.Product_Master__c = ProductMasterId;
        schemeSlabTarget.ivydsd__Scheme_Slab__c = PromotionSlabId;
        schemeSlabTarget.Name = PromotionSlabTargetName;
        schemeSlabTarget.Type__c = Type;
        schemeSlabTarget.ivydsd__UOM__c = UOM;
        schemeSlabTarget.ivydsd__Scheme_Group__c=SchemeGroupId;
        return schemeSlabTarget;
    }
    //function call : TestUtility.createTestSchemeGroup(string GroupLogic,string GroupType,Id ProductHierarchyId,Id PromotionId,String SchemeGroupName)
    public static ivydsd__Scheme_Group__c createTestSchemeGroup(string GroupLogic,string GroupType,Id ProductHierarchyId,Id PromotionId,String SchemeGroupName){
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c();
        schemeGroup.ivydsd__Group_Logic__c = GroupLogic;
        schemeGroup.ivydsd__Group_Type__c = GroupType;
        schemeGroup.Product_Hierarchy__c = ProductHierarchyId;
        schemeGroup.ivydsd__Scheme__c = PromotionId;
        schemeGroup.Name = SchemeGroupName;
        return schemeGroup;
    }
    
    //function call : TestUtility.createTestSchemeGroupProduct(Id ProductId,Id ProductHierarchyId,decimal ProductValueWorth,Id PromotionGroupId,Integer Quantity)
    public static ivydsd__Scheme_Group_Product__c createTestSchemeGroupProduct(Id ProductId,Id ProductHierarchyId,decimal ProductValueWorth,Id PromotionGroupId,Integer Quantity){
        ivydsd__Scheme_Group_Product__c schemeGroupProduct = new ivydsd__Scheme_Group_Product__c();
        schemeGroupProduct.ivydsd__Product1__c = ProductId;
        schemeGroupProduct.Product_Hierarchy__c = ProductHierarchyId;
        schemeGroupProduct.Product_Value_Worth__c = ProductValueWorth;
        schemeGroupProduct.ivydsd__Scheme_Group__c = PromotionGroupId;
        schemeGroupProduct.Qty__c = Quantity;
        return schemeGroupProduct;
    }
    //function call : TestUtility.createSchemeSlabTarget(Integer MinimumValue,Integer MaximumValue,Id ProductMasterId,Id PromotionSlabId,String PromotionSlabTargetName,String Type,String UOM)
    public static ivydsd__Scheme_Slab_Target__c createSchemeSlabTarget(Integer MinimumValue,Integer MaximumValue,Id ProductMasterId,Id PromotionSlabId,String PromotionSlabTargetName,String Type,String UOM){
        ivydsd__Scheme_Slab_Target__c schemeSlabTarget = new ivydsd__Scheme_Slab_Target__c();
        schemeSlabTarget.ivydsd__Minimum_Value__c = MinimumValue;
        schemeSlabTarget.ivydsd__Maximum_Value__c = MaximumValue;
        schemeSlabTarget.Product_Master__c = ProductMasterId;
        schemeSlabTarget.ivydsd__Scheme_Slab__c = PromotionSlabId;
        schemeSlabTarget.Name = PromotionSlabTargetName;
        schemeSlabTarget.Type__c = Type;
        schemeSlabTarget.ivydsd__UOM__c = UOM;
        return schemeSlabTarget;
    }
    //function call : TestUtility.createSchemeFreeDetail(Integer FreeQuantity,string FreeQuantityUOM,Integer MaxFreeQuantity,Id ProductMasterId,decimal ProductValueWorth,Id PromotionGroupId,Id PromotionSlabId,String SchemeType)
    public static ivydsd__Scheme_Free_Detail__c createSchemeFreeDetail(Integer FreeQuantity,string FreeQuantityUOM,Integer MaxFreeQuantity,Id ProductMasterId,decimal ProductValueWorth,Id PromotionGroupId,Id PromotionSlabId,String SchemeType){
        ivydsd__Scheme_Free_Detail__c schemeFreeDetail = new ivydsd__Scheme_Free_Detail__c();
        schemeFreeDetail.ivydsd__Free_Quantity__c = FreeQuantity;
        schemeFreeDetail.ivydsd__Free_Quantity_UOM__c = FreeQuantityUOM;
        schemeFreeDetail.ivydsd__Maximum_Free_Quantity__c = MaxFreeQuantity;
        schemeFreeDetail.Product_Master__c = ProductMasterId;
        schemeFreeDetail.Product_Value_Worth__c = ProductValueWorth;
        schemeFreeDetail.ivydsd__Scheme_Group__c = PromotionGroupId;
        schemeFreeDetail.ivydsd__Scheme_Slab__c = PromotionSlabId;
        schemeFreeDetail.Scheme_Type__c = SchemeType;
        return schemeFreeDetail;
    }
    
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
    
    public static user userRecord(){
        //Id userId = UserInfo.getUserId();
        User userRecord = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        userRecord.Market_ISO__c = 'AU';
        update userRecord;
        return userRecord;
    }
    
    //Function Call: ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,resType.id);     
    
    public static ivybase__Resource__c createTestResource(String resourceName, Id curUserId,Id resourceTypeId){
        ivybase__Resource__c res = createTestResource(resourceName,curUserId);           
        res.ivybase__Resource_Type__c = resourceTypeId;
        res.Market_ISO__c = 'MY';    
        return res;
    }
    
    //Function Call: ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',primaryRes.Id);   
    public static ivybase__Location_Hierarchy__c createTestLocationHierarchy(String locHrName, Id primaryResId){
        ivybase__Location_Hierarchy__c locHr = new ivybase__Location_Hierarchy__c();
        locHr.Name = locHrName;
        locHr.ivybase__Primary_Resource__c = primaryResId;
        locHr.ivybase__Active__c = 'Yes';
        locHr.Market_ISO__c = 'MY';
        return locHr; 
    }
    //Function Call: ivybase__Store_Hierarchy__c store = TestUtility.createTestStoreHierarchy('Green Trends' , 'Yes' ,ParentStoreId , DivisionId ,'Node4| Sub Channel | Node3 | Channel');
    public static ivybase__Store_Hierarchy__c createTestStoreHierarchy(String StoreHierarchyName,String Active,Id Parent,Id Division,String RecordType){
        List<RecordType> rec=RecordTypeService.getObjectBasedRecordTypes('ivybase__Store_Hierarchy__c');
        system.debug('rec'+rec);
        Map<String,Id> recMap = new Map<String,Id>();
        for(RecordType r:rec)
        {
            recMap.put(r.Name,r.Id);
        }
        system.debug('recMap'+recMap);
        ivybase__Store_Hierarchy__c StoreHierarchy = new ivybase__Store_Hierarchy__c();
        StoreHierarchy.Name = StoreHierarchyName;
        StoreHierarchy.ivybase__Parent__c= Parent;
        StoreHierarchy.ivybase__Active__c = Active;
        StoreHierarchy.Division__c =Division;
        StoreHierarchy.Market_ISO__c = 'MY';
        if(recMap.containsKey(RecordType)){
            StoreHierarchy.RecordTypeId=recMap.get(RecordType);
        }
        return StoreHierarchy;
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
                                                acc.Market_ISO__c = 'MY';
                                                return acc;
                                            }
    
    //Function Call:  ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
    
    public static ivybase__Product_Hierarchy__c  createTestProductHierarchy(String phName , String recordTypeName , 
                                                                            boolean competitor , String isActive) 
    {
        ivybase__Product_Hierarchy__c ph2 = new ivybase__Product_Hierarchy__c();    
         ph2.Name = phName;
 ph2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : recordTypeName AND sobjecttype='ivybase__Product_Hierarchy__c' LIMIT 1].Id;
                                                        ph2.ivybase__Is_Competitor__c = competitor;
                                                                ph2.ivybase__Active__c = isActive;
                                                              ph2.Market_ISO__c = 'MY';
                                                             return ph2;                                                                       
                                                                                
                                                                            }
    
    //Function Call ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',Date.valueOf('8/1/2018'),456,'ZSA1')
    public static ivydsd__Discount__c  createTestDiscount(String dName, String ModuleType,String ApplyType,String DiscountType,Date EffectiveFrom,Decimal Value,String TypeCode) {
        ivydsd__Discount__c d = new ivydsd__Discount__c();  
        d.Name = dName;
        d.ivydsd__Module_Type__c = ModuleType;
        d.ivydsd__Apply_Type__c  = ApplyType;
        d.ivydsd__Discount_Type__c =DiscountType;
        d.ivydsd__Effective_From__c =EffectiveFrom;
        d.ivydsd__Value__c=Value;
        d.Market_ISO__c = 'MY';
        d.Type__c=TypeCode;
        return d;
    }
    //Function Call ivydsd__Discount_Mapping__c d = TestUtility.createTestDiscountMapping(StoreHierarchyId,AccountId,Id discount)
    public static ivydsd__Discount_Mapping__c createTestDiscountMapping(Id StoreHierarchy,Id Account,Id discount)
    {
        ivydsd__Discount_Mapping__c  discountMapping = new ivydsd__Discount_Mapping__c ();
        discountMapping.ivydsd__Store_Hierarchy__c =StoreHierarchy;
        discountMapping.ivydsd__Account__c =Account;
        discountMapping.ivydsd__Discount__c=discount;
        discountMapping.Market_ISO__c = 'MY';
        return discountMapping;
    }
    //Function Call ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(Id Product,Id ProductHierarchy,Id Discount,500)
    public static ivydsd__Discount_Detail__c createTestDiscountDetail(Id Product,Id ProductHierarchy,Id Discount,Decimal Value)
    {
        ivydsd__Discount_Detail__c  discountdetail = new ivydsd__Discount_Detail__c ();
        discountdetail.ivydsd__Product__c =Product;
        discountdetail.ivydsd__Product_Hierarchy__c =ProductHierarchy;
        discountdetail.ivydsd__Discounts__c=discount;
        discountdetail.ivydsd__Value__c=Value;
        discountdetail.Market_ISO__c = 'MY';
        return discountdetail;
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
                                                             pd.Market_ISO__c = 'MY';
                                                             return pd;
                                                         }
    
    
    
    //Function Call: ivybase__Visit__c vi = TestUtility.createTestVisit(02/19/2018 , a.Id ,'');       
    public static ivybase__Visit__c  createTestVisit(Date visitedDate , Id storeId , String status ) {
        ivybase__Visit__c vi = new ivybase__Visit__c();
        vi.ivybase__Visit_Date__c = visitedDate;
        vi.ivybase__Store__c = storeId;
        vi.ivybase__Status__c = status;
        return vi;
    }
    
    
    //Function Call: ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Price_Check');
    public static  ivybase__Product_Group__c createTestProductGroup(string productGroupName, String isActive, String recordTypeName){
        ivybase__Product_Group__c pg1 = new ivybase__Product_Group__c();
        pg1.Name = productGroupName ;
        pg1.ivybase__Active__c = isActive ;
        pg1.Market_ISO__c = 'MY';
        pg1.RecordTypeID=[SELECT id FROM RecordType where DeveloperName = : recordTypeName AND  sobjecttype='ivybase__Product_Group__c' LIMIT 1].id;        
        return pg1 ;   
    }
    
    public static ivybase__Product_Group_Detail__c createTestProductGroupDetails(String recordTypeName){
        ivybase__Product_Group_Detail__c groupdetails = new ivybase__Product_Group_Detail__c();
        groupdetails.ivybase__Sequence__c = '1';
        groupdetails.RecordTypeID=[SELECT id FROM RecordType where DeveloperName = : recordTypeName AND  sobjecttype='ivybase__Product_Group_Detail__c' LIMIT 1].id;        
        groupdetails.Market_ISO__c = 'MY';
        return groupdetails;     
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
        //slm1.Market_ISO__c = 'MY';
        slmlist.add(slm1);
        
        ivybase__Standard_List_Master__c slm2 = new ivybase__Standard_List_Master__c();
        slm2.ivybase__List_Name__c = 'Piece';
        slm2.ivybase__List_Code__c = 'Piece';
        slm2.ivybase__List_Type__c = 'PRODUCT_UOM';
        //slm2.Market_ISO__c = 'MY';
        slmlist.add(slm2);
        
        ivybase__Standard_List_Master__c slm3 = new ivybase__Standard_List_Master__c();
        slm3.ivybase__List_Name__c = 'Outer';
        slm3.ivybase__List_Code__c = 'Outer';
        slm3.ivybase__List_Type__c = 'PRODUCT_UOM';
        //slm3.Market_ISO__c = 'MY';
        slmlist.add(slm3);
        
        
        return slmlist;
    }
    
    //Function Call: List<ivybase__Product_UOM__c> pulist = TestUtility.createTestProductUOM(p.id);
    
    public static List<ivybase__Product_UOM__c> createTestProductUOM(id productId) {
        
        List<ivybase__Product_UOM__c> pulist = new List<ivybase__Product_UOM__c>();
        ivybase__Product_UOM__c pu1 = new ivybase__Product_UOM__c();
        pu1.ivybase__Product__c = productId;
        pu1.ivybase__UOM__c = 'Case';
        pu1.ivybase__UOM_Number__c = 'UOM 1';
        //pu1.Market_ISO__c = 'MY';
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
        o.Market_ISO__c = 'MY';
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
                                                                         //oli.Market_ISO__c = 'MY';
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
                                                           inv.Market_ISO__c = 'MY';
                                                           return inv;
                                                       }
    
    //Function Call: ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,product.Id);    
    
    public static ivydsd__Invoice_Line_Item__c createTestInvoiceLineItem(Id invoiceId , Id prodId){
        ivydsd__Invoice_Line_Item__c invLineItem = new ivydsd__Invoice_Line_Item__c();
        invLineItem.ivydsd__Invoice__c = invoiceId;
        invLineItem.ivydsd__Product_Master1__c = prodId;
        invLineItem.Market_ISO__c = 'MY';
        return invLineItem;
    }
    
    //Function call:  ivybase__Location__c l = TestUtility.createTestLocation('testloc','Yes',acc.Id);
    
    public static ivybase__Location__c createTestLocation(string locationName, String isActive,String accId){
        ivybase__Location__c l = new ivybase__Location__c();
        l.Name = locationName;
        l.ivybase__Active__c = isActive;
        l.ivybase__Belongs_To__c  = accId;
        l.Market_ISO__c = 'MY';
        l.RecordTypeId = Schema.SObjectType.ivybase__Location__c.getRecordTypeInfosByDeveloperName().get('In_Store').getRecordTypeId();
        return l;
    }
    
    //Function call:  ivybase__Location_Stock__c ls = BATTestUtility.createTestlocationStock('1', l.id , p.id );
    
    public static ivybase__Location_Stock__c createTestlocationStock(string vanLoadMobileUid , id locationId , id productId){
        ivybase__Location_Stock__c ls = new ivybase__Location_Stock__c();
        ls.ivybase__VanLoad_Mobile_Uid__c = vanLoadMobileUid;
        ls.ivybase__Location__c = locationId;
        ls.ivybase__Product__c = productId;
        ls.Market_ISO__c = 'MY';
        return ls;
    }
    
    
    
    
    //Function Call: Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
    public static Incentive_Group__c createTestIncentiveDroup(String Name){
        Incentive_Group__c incentiveGrp = new Incentive_Group__c();
        incentiveGrp.Name = Name;
        //incentiveGrp.Market_ISO__c = 'MY';
        return incentiveGrp;
    }
    
    //Function Call: Target_Actual__c targetActual = TestUtility.createTestTargetActual('TestTarget',1000,incentive.Id,resId,'');   
    public static Target_Actual__c createTestTargetActual(String Name, Integer actual,String incId,String resId,String phId){
        Target_Actual__c target = new Target_Actual__c();
        target.Name = Name;
        target.Actual__c = actual;
        target.Incentive_Group__c = incId;
        target.Resource__c = resId;
        target.Market_ISO__c = 'MY';
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
        //slab.Market_ISO__c = 'MY';
        return slab;
    }
    
    //Function Call: ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
    public static ivybase__Route__c createTestRoute(String resId, String status){
        ivybase__Route__c route = new ivybase__Route__c();
        route.ivybase__Resource__c = resId;
        route.ivybase__Active__c = status;
        //route.Market_ISO__c = 'MY';
        return route;
    }
    
    //Function Call: ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
    public static ivybase__Route_Details__c createTestRouteDetail(String name,String routeId, String status, String accId){
        ivybase__Route_Details__c routedetail = new ivybase__Route_Details__c();
        routedetail.Name = name;
        routedetail.ivybase__Route__c = routeId;
        routedetail.ivybase__Active__c = status;
        routedetail.ivybase__Store__c = accId;
        routedetail.Market_ISO__c = 'MY';
        return routedetail;
    }
    
    //Function Call: Territory_Routing__c routeDetail = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
    public static Territory_Routing__c createTestTerrRouting(String name,String routeId, String locId){
        Territory_Routing__c terrRouting = new Territory_Routing__c();
        terrRouting.Name = name;
        terrRouting.Route__c = routeId;
        terrRouting.Location_Hierarchy__c = locId;
        terrRouting.Market_ISO__c = 'MY';
        return terrRouting;
    }
    
    //Function Call: ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(1));   
    public static ivybase__Price_List__c createTestPriceList(String isActive,String name, Date fromDate,Date toDate){
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.ivybase__Active__c = isActive;
        priceList.Name = name;
        priceList.ivybase__Valid_From__c = fromDate;
        priceList.ivybase__Valid_To__c = toDate;
        priceList.Market_ISO__c = 'MY';
        return priceList;
    }
    //Function Call: ivybase__Price_List_Mapping__c priceListMap = TestUtility.createTestPriceListMapping(priceList.Id,'Test PriceListMap',node4.Id);   
    public static ivybase__Price_List_Mapping__c createTestPriceListMapping(String priceList,String name, String storeHie){
        ivybase__Price_List_Mapping__c priceListMap = new ivybase__Price_List_Mapping__c();
        priceListMap.ivybase__Price_List__c = priceList;
        priceListMap.Name = name;
        priceListMap.ivybase__Store_Hierarchy__c = storeHie;
        priceListMap.Market_ISO__c = 'MY';
        return priceListMap;
    }
    
    //Function Call: ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceList.Id,'YPR0',200.30);   
    public static ivybase__Price_List_Entrie__c createTestPriceListEntry(String isActive,String product, String priceList,String type,Decimal price){
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Active__c = isActive;
        priceListEntry.ivybase__Product__c = product;
        priceListEntry.ivybase__Price_List__c = priceList;
        priceListEntry.Type__c = type;
        priceListEntry.ivybase__UOM_1_Price__c = price;
        priceListEntry.Market_ISO__c = 'MY';
        return priceListEntry;
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
        u.Market_ISO__c = 'MY';
        return u;
    }
    
    public static List<ivybase__Max_Internal_Id_Value__c> insertMaxInternalId() {
        List<ivybase__Max_Internal_Id_Value__c> listOfMaxInternalIds = new List<ivybase__Max_Internal_Id_Value__c> ();
        
        ivybase__Max_Internal_Id_Value__c maxInternalIdVal = ivybase__Max_Internal_Id_Value__c.getValues('User');
        integer randomNumb = Integer.ValueOf(Math.random() * 1000000);
        Decimal maxIntVal = Decimal.ValueOf(randomNumb);
        if (maxInternalIdVal == null) {
            maxInternalIdVal = new ivybase__Max_Internal_Id_Value__c( Name = 'User');
        }
        maxInternalIdVal.ivybase__Max_Internal_Id__c = maxIntVal;        
        listOfMaxInternalIds.add(maxInternalIdVal);
        
        ivybase__Max_Internal_Id_Value__c maxInternalIdVal2 = ivybase__Max_Internal_Id_Value__c.getValues('Account');
        if (maxInternalIdVal2 == null) {
            maxInternalIdVal2 = new ivybase__Max_Internal_Id_Value__c( Name = 'Account');
        }
        maxInternalIdVal2.ivybase__Max_Internal_Id__c = maxIntVal;
        listOfMaxInternalIds.add(maxInternalIdVal2);
        system.assert(listOfMaxInternalIds.size() == 2);
        
        return listOfMaxInternalIds;
    }
    
    public static User getCustomerArgoUser(){
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = insertMaxInternalId();
        upsert maxInternalIdValList;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Customer Service_ARGO'];
        System.debug('****'+pf);
        
        User u = new User(Alias = 'Testuser', Email='TestuserChatter@testorg.com', ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c,
                          EmailEncodingKey='UTF-8', LastName='Testuser', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pf.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestuserChatter@testorg.com', Market_ISO__c = 'MY');
        return u;
        
    }
    
    public static User getBAUser(){
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = insertMaxInternalId();
        upsert maxInternalIdValList;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Sales_Admin_ARGO'];
        System.debug('****'+pf);
        
        User u = new User(Alias = 'Testuser', Email='TestuserChatter122@testorg.com', ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c,
                          EmailEncodingKey='UTF-8', LastName='Testuser', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pf.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestuserChatter122@testorg.com', Market_ISO__c = 'MY');
        return u;
        
    }
    
    public static User getCharterFreeUser(){
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = insertMaxInternalId();
        upsert maxInternalIdValList;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User'];
        System.debug('****'+pf);
        
        User u = new User(Alias = 'Testuser', Email='TestuserChatter@testorg.com', ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c,
                          EmailEncodingKey='UTF-8', LastName='Testuser', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pf.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestuserChatter@testorg.com', Market_ISO__c = 'MY');
        
        // insert u;
        return u;
    }
    
    public static User getSGBAUser(){
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = insertMaxInternalId();
        upsert maxInternalIdValList;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Sales_Admin_ARGO'];
        System.debug('****'+pf);
        
        User u = new User(Alias = 'Testusr1', Email='TestuserChatter122@testorg.com', ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c,
                          EmailEncodingKey='UTF-8', LastName='Testuser1', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pf.Id, CurrencyIsoCode = 'SGD',
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestuserChatter1221@testorg.com', Market_ISO__c = 'SG');
        return u;
    }
    
    public static User getSRUser(){
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = insertMaxInternalId();
        upsert maxInternalIdValList;
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'Sales_Rep_ARGO'];
        System.debug('****'+pf);
        
        User u = new User(Alias = 'Testuser', Email='TestuserChatter@testorg.com', ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c,
                          EmailEncodingKey='UTF-8', LastName='Testuser', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pf.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestuserChatter@testorg.com', Market_ISO__c = 'SG');
        return u;
        
    }
    
    //function call :  TestUtility.createTestScheme(String name,String buyLogic,String getLogic,String Code,String Description,Date fromDate,Date toDate,String schemeType) 
    public static ivydsd__Scheme__c  createTestScheme(String name,String buyLogic,String getLogic,String Code,String Description,Date fromDate,Date toDate,String schemeType) {
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c();
        scheme.Name=name;
        scheme.ivydsd__Scheme_Buy_Logic__c=buyLogic;
        scheme.ivydsd__Scheme_Get_Logic__c=getLogic;
        scheme.ivydsd__Code__c=Code;
        scheme.ivydsd__Description__c=Description;
        scheme.ivydsd__From__c=fromDate;
        scheme.ivydsd__To__c=toDate;
        scheme.ivydsd__Scheme_Type__c=schemeType; 
        //scheme.Market_ISO__c = 'MY';
        return scheme;
    }
    public static ivydsd__Scheme__c  createTestScheme(String name,String buyLogic,String getLogic,String Code,String Description,Date fromDate,Date toDate,String schemeType,string IsActive) {
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c();
        scheme.Name=name;
        scheme.ivydsd__Scheme_Buy_Logic__c=buyLogic;
        scheme.ivydsd__Scheme_Get_Logic__c=getLogic;
        scheme.ivydsd__Code__c=Code;
        scheme.ivydsd__Description__c=Description;
        scheme.ivydsd__From__c=fromDate;
        scheme.ivydsd__To__c=toDate;
        scheme.ivydsd__Scheme_Type__c=schemeType; 
        scheme.ivydsd__Active__c = IsActive;
        //scheme.Market_ISO__c = 'MY';
        return scheme;
    }
    //function call :  TestUtility.createTestSchemeApplyDetail(Id RecordTypeID,Id SchemeSlab,Id OrderLineItemId,Id OrderId)
    public static ivydsd__Scheme_Apply_Detail__c  createTestSchemeApplyDetail(Id RecordTypeID,Id SchemeSlab,Id OrderLineItemId,Id OrderId) {
        ivydsd__Scheme_Apply_Detail__c schemeApplyDetail = new ivydsd__Scheme_Apply_Detail__c();
        schemeApplyDetail.RecordTypeId  =RecordTypeID;
        schemeApplyDetail.ivydsd__Scheme__c=SchemeSlab;
        schemeApplyDetail.ivydsd__Order_Line_Item__c =OrderLineItemId;
        schemeApplyDetail.ivydsd__Order__c=OrderId;
        //schemeApplyDetail.Market_ISO__c = 'MY';
        return schemeApplyDetail;
    }
    //function call :  TestUtility.createTestSchemeSlab(Id schemeId)
    public static ivydsd__Scheme_Slab__c createTestSchemeSlab(Id schemeId) {
        ivydsd__Scheme_Slab__c  schemeSlab = new ivydsd__Scheme_Slab__c ();
        schemeSlab.ivydsd__Scheme__c=schemeId;
        //schemeSlab.Market_ISO__c = 'MY';
        return schemeSlab;
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
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
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
    
    //function call : TestUtility.createReturnType (String ReturnTypeCode, String description ,Id locationHierarchy, String MarketISO, String currency)
   /* public static Return_Type__c createReturnType (String ReturnTypeCode, String description ,Id locationHierarchy, String marketISO, String currencyIsoCode){
        Return_Type__c returnType = new Return_Type__c();
        returnType.Name = ReturnTypeCode;
        returnType.Description__c = description;
        returnType.Location_Hierarchy__c = locationHierarchy;
        returnType.Market_ISO__c = marketISO;
        returnType.currencyIsoCode = currencyIsoCode;
        
        return returnType;
    }
    */
    //commneted for japn deploymnts
    //function call : TestUtility.createReturnReason (String ReturnTypeCode, String description ,Id returnType, Decimal minValue, Decimal maxValue, Boolean isInvoiced, Decimal invoiceDuration, String currencyIsoCode)
  /*  public static Return_Reason__c createReturnReason (String ReturnTypeCode, String description ,Id returnType, Decimal minValue, Decimal maxValue, Boolean isInvoiced, Decimal invoiceDuration, String currencyIsoCode){
        Return_Reason__c returnReason = new Return_Reason__c();
        returnReason.Name = ReturnTypeCode;
        returnReason.Description__c = description;
        returnReason.Return_Type__c = returnType;
        returnReason.Minimum_Value__c = minValue;
        returnReason.Maximum_Value__c = maxValue;
        returnReason.IsInvoiced__c = isInvoiced;
        returnReason.Invoice_Duration__c = invoiceDuration;
        returnReason.currencyIsoCode = currencyIsoCode;
        
        return returnReason;
    }*/
    //function call : TestUtility.createPackageDetail (Id orderId, Id SKUProductId, Id BOMProductId, Id retailerId, Id divisionId)
  /*  public static Package_Apply_Detail__c createPackageDetail (Id orderId, Id SKUProductId, Id BOMProductId, Id retailerId, Id divisionId){
        
        Package_Apply_Detail__c packageDetail = new Package_Apply_Detail__c();
        
        packageDetail.Order__c = orderId;
        packageDetail.SKU_Product__c = SKUProductId;
        packageDetail.BOM_Product__c = BOMProductId;
        packageDetail.Division__c = divisionId; 
        packageDetail.Account__c = retailerId;
        packageDetail.Product_Quantity__c = 2;
        packageDetail.No_Of_Packages__c = 2;
        packageDetail.Package_Type__c = '1';
        packageDetail.Market_ISO__c = 'AU';
        
        return packageDetail;
    }
    */
    public static Rintin_Plan__c createRintinPlan (Id jPlanId ) {
        Rintin_Plan__c rp = new Rintin_Plan__c();
        
        rp.Name = 'Test Rintin Plan';
        rp.CurrencyIsoCode = 'AUD';
        rp.TId__c = '1234';
        rp.Journey_Plan__c = jPlanId; 
        rp.Location__c = 'Your Loaction';
        rp.Date__c = system.today().addDays(-4); //Date.newInstance(system.today().year(), system.today().month(), 15);
        rp.StartTime__c = '7:40';
        rp.EndTime__c = '10:30';
        
        return rp;
    }
    
    public static Rintin_Plan_Details__c createRintinPlanDetail (Id agentId, Id hairDresserId, Id rintinplanId,
                                                                 Boolean isDoko, Id retailerId) 
    {
        Rintin_Plan_Details__c rpd = new Rintin_Plan_Details__c();
        
        rpd.Agent__c = agentId;
        rpd.isActive__c = TRUE;
        rpd.Hair_Dresser__c = hairDresserId;
        rpd.IsDoko__c = isDoko;
        rpd.Retailer_Id__c = retailerId;
        rpd.Rintin_Plan__c = rintinplanId;
        
        return rpd;
    }
    
    public static ivybase__HHTMenu_Master__c createHHTMenuMaster (String name, Integer flag, String rField1,
                                                                 String menuType, String mName, Id locHr, Id resourceTypeId, String flex) 
    {
        ivybase__HHTMenu_Master__c hht = new ivybase__HHTMenu_Master__c();
        
        hht.Name = name;
        hht.ivybase__Flag__c = flag;
        hht.ivybase__RField1__c = rField1;
        hht.ivybase__RField__c = '0';
        hht.ivybase__MenuType__c = menuType;
        hht.ivybase__MName__c = mName;
        hht.ivybase__Location_Hierarchy__c = locHr;
        hht.ivybase__Resource_Type__c = resourceTypeId;
        hht.ivybase__Flex__c = flex;
        
        return hht;
    }
    
}