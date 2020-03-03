@isTest
public class TESTCompetitorTrackingTranslator {
    private static testMethod void testCompetitor(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        System.debug('ph::'+ph);
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.ivybase__Barcode__c = 1234;
        insert p1;
        
        
         List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Styling',ivybase__List_Code__c='STY',ivybase__List_Type__c = 'SUB_AXE_LEVEL', ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'New Launch',ivybase__List_Code__c='CMT_NW', ivybase__List_Type__c = 'COMPETITOR_TRACKING_TYPE', ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id)
                };
        
        insert standardmaster;
       
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__Internal_Id__c,ivybase__Is_Competitor__c FROM ivybase__Product_Hierarchy__c where ivybase__Is_Competitor__c=true][0].ivybase__Internal_Id__c);
        
        
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        
        List <LorealUploadclass.CompetitorHeaderInfo> header = new List <LorealUploadclass.CompetitorHeaderInfo>();
        List <LorealUploadclass.CompetitorDetailsInfo> details = new List <LorealUploadclass.CompetitorDetailsInfo>();
        List <LorealUploadclass.CompetitorPhotoDetailsInfo> photos = new List <LorealUploadclass.CompetitorPhotoDetailsInfo>();
        
        LorealUploadclass.CompetitorHeaderInfo compHeader = new LorealUploadclass.CompetitorHeaderInfo();
        compHeader.Date_x = tdydate;
        compHeader.Feedback='Feedback';
        compHeader.Remark = 'Test Remark';
        compHeader.RetailerId = accId;
        compHeader.Tid = '12432455235';
        header.add(compHeader);
        
        LorealUploadclass.CompetitorPhotoDetailsInfo compPhotoDetails = new LorealUploadclass.CompetitorPhotoDetailsInfo();
        compPhotoDetails.avgPrice = '1000';
        compPhotoDetails.Description = 'Test Description';
        compPhotoDetails.ImageName = 'bhjjuhhjji-15443206023.png';
        compPhotoDetails.ImagePath = 'CompetitorTrackImages/bhjjuhhjji-15443206023.png';
        compPhotoDetails.Name= 'Test';
        compPhotoDetails.qty = '10';
        compPhotoDetails.qtysize='5';
        compPhotoDetails.SellingPrice = '2000';
        compPhotoDetails.tcompetitorid = pid;
        compPhotoDetails.Tid='12432455235';
        photos.add(compPhotoDetails);
        
        LorealUploadclass.CompetitorDetailsInfo compDetail = new LorealUploadclass.CompetitorDetailsInfo();
        compDetail.avgPrice = '1000';
        compDetail.Comments = 'Test Comments';
        compDetail.contract = '12';
        compDetail.FrqOfEduVisit = '12';
        compDetail.FrqOfRepVisit='10';
        compDetail.pid = standardmaster[0].Name;
        compDetail.qty = '10';
        compDetail.qtysize='10';
        compDetail.Rebate = '10';
        compDetail.NoOfTraining = '10';
        compDetail.RetailPrice = '100';
        compDetail.tcompetitorid = pid;
        compDetail.Tid = '12432455235';
        compDetail.TypeOfTraining = 'Test'; 
        details.add(compDetail);
        
        System.debug('details::'+details);
        System.debug('photos::'+photos);
        System.debug('header::'+header);
        Test.startTest();
        CompetitorTrackingTranslator.translate(header,details,photos); 
        Test.stopTest();
    }

}