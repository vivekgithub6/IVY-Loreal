@isTest
public class TestBatchOrderEmail {

    @testSetup public static void createData()
    {

     ivybase__Max_Internal_Id_Value__c cs = new ivybase__Max_Internal_Id_Value__c();
        cs.Name='Contact';
        cs.ivybase__Max_Internal_Id__c=20;
     insert cs;        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        Trigger_Logic_Configuration__c tl= new Trigger_Logic_Configuration__c();
        tl.name='Integartionuserid';
        tl.UserName__c='xyzyto9pert';
        insert tl;
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',null,restype.id);  
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource',userId,restype.id);  
        res1.SAP_Id__c = '12346';
        res1.ivybase__Location_Hierarchy__c  = i1.Id;
        insert res1;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res1.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'MY');
       insert divLoc;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res1.id , 'Retail_Account' , 'Yes' );
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Contact_Email__c='test@gmail.com';
        acc.Order_Email__c = true;
        insert acc;
        update acc;
        
        Contact con = TestUtility.createTestContact('Test','Contact', userId , 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        ivydsd__Order__c o = TestUtility.createTestOrder(acc.id,'Sent to SAP',con.id,'1');       
        Datetime d = dateTime.now();
        system.debug('d'+d);
        Datetime toDate = d.addMinutes(-55);
        //o.CreatedDate=toDate;
        o.ivydsd__Resource__c=res1.id;
        o.Resource_Email__c='test@gmail.com';
        o.Saloon_Email__c='test@gmail.com';
        o.Signature_Image_Path__c='http://s3.amazon.com/imagefolder/imagefile.png';
        o.Division__c = division.id;
        o.Argo_Order__c = true;
        o.Email_Sent__c = false;
       
        insert o;
        Test.setCreatedDate(o.Id, toDate);
        system.debug(JSON.serialize(o));
        ivybase__Product__c  product1 =TestUtility.createTestProduct('Product 1',null,'main product',false,'Yes');
        insert product1;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id,product1.id ,50,0,0,10, 0, 0 );
        insert oli;
        
        String modOrder = '{"attributes":{"type":"ivydsd__Order__c"},"Id":"'+String.valueOf(o.id)+'","url":"/services/data/v44.0/sobjects/ivydsd__Order__c/'+String.valueOf(o.id)+'"},"ivydsd__Store__c":"'+string.valueOf(acc.id)+'","ivydsd__Order_Status__c":"Approved","ivydsd__Seller__c":"'+string.valueOf(con.id)+'","ivydsd__Mobile_Order_Number__c":"1","CreatedDate":"2018-12-04T08:37:44.436+0000","ivydsd__Resource__c":"'+string.valueOf(res.id)+'","Resource_Email__c":"test@gmail.com","Saloon_Email__c":"test@gmail.com","LastModifiedDate":"'+toDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+'","Signature_Image_Path__c":"http://s3.amazon.com/imagefolder/imagefile"}';
        o=(ivydsd__Order__c) JSON.deserialize(modOrder, ivydsd__Order__c.class );
        update o;
             
    }
    
    @isTest static void testCallout() {
    
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Datetime d = dateTime.now();
        system.debug('d'+d);
        Datetime toDate = d.addMinutes(-30);
        Datetime formDate = d.addMinutes(-90);
        system.debug('d'+toDate);
        system.debug('d'+formDate);
        List<ivydsd__Order__c> order = [select id,name,LastModifiedDate,Saloon_Email__c, Resource_Email__c ,Signature_Link1__c,ivydsd__Order_Status__c from ivydsd__Order__c];   
        system.debug('order'+order);
        List<ivydsd__Order__c> up = database.query('select id,name,ivydsd__Order_Date__c,ivydsd__Order_Value__c,Resource_Email__c,Signature_Image_Path__c,Signature_Link1__c,Saloon_Email__c from ivydsd__Order__c where Saloon_Email__c!=null and Resource_Email__c!=null and Signature_Link1__c=null and LastModifiedDate>:formDate and LastModifiedDate<:toDate and ivydsd__Order_Status__c!=\'Pending For Approval\' and  ivydsd__Order_Status__c!=\'Draft\'');
        system.debug('up.size'+up.size());
        
        List<Contact> contactList = [SELECT Id, Name FROM Contact];
        List<Id> contactIdList = new List<Id>();
        for(Contact con :contactList) {
            
            contactIdList.add(con.Id);
        }
        
        List<Id> orderIdList = new List<Id>();
        for(ivydsd__Order__c ord :order) {
            
            orderIdList.add(ord.Id);
        }
        
        List<String> imageStringList = new List<String>();
        imageStringList.add('imagefile.png');
        
        BatchOrderEmail o = new BatchOrderEmail();
        database.executeBatch(o);
        
        System.enqueueJob(new S3ImageDownload(imageStringList,contactIdList,orderIdList,1));
    }
}