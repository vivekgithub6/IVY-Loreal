@isTest
private class TestBatchSalonInvoice_Resource {

    private static testMethod void VisitAndInvoiceExisitingRecordsLastDateSecondLastPopulatedOlderTHanMonthone(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
                        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order1.ivydsd__Order_Date__c=date.today();
        order1.ivydsd__Resource__c=res.id;
        order1.Division__c=div[0].id;
        orderList.add(order1);
        
        ivydsd__Order__c order2 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order2.ivydsd__Order_Date__c=date.today().addDays(-1);
        order2.ivydsd__Resource__c=res.id;
        order2.Division__c=div[1].id;
        orderList.add(order2);        
        
        ivydsd__Order__c order3 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order3.ivydsd__Order_Date__c=date.today();
        order3.ivydsd__Resource__c=res.id;
        order3.Division__c=div[2].id;
        orderList.add(order3);  
        
        ivydsd__Order__c order4 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order4.ivydsd__Order_Date__c=date.today().addDays(-1);
        order4.ivydsd__Resource__c=res.id;
        order4.Division__c=div[3].id;
        orderList.add(order4);
        
        ivydsd__Order__c order5 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order5.ivydsd__Order_Date__c=date.today().addDays(-40);
        order5.ivydsd__Resource__c=res.id;
        order5.Division__c=div[3].id;
        orderList.add(order5);  
        
        ivydsd__Order__c order6 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order6.ivydsd__Order_Date__c=date.today().addDays(-90);
        order6.ivydsd__Resource__c=res.id;
        order6.Division__c=div[3].id;
        orderList.add(order6);        
        
        //User u = TestUtility.getCustomerArgoUser();
        //system.runAs(u){
             
            //try{
                insert orderList;
             
        
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                   // vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
                
                Date todayDate = system.today();
                List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
         
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[3].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[4].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-40);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[5].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-90);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                insert invoiceList;
                
                List<ivydsd__Invoice_Line_Item__c> invoiceItemList = new List<ivydsd__Invoice_Line_Item__c>();
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[0].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[1].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[2].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                
                insert invoiceItemList;
                
                List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
                Date sampleDate = date.today();
                sampleDate=sampleDate.addDays(-48);
                Date secondOldDate = sampleDate.addDays(-90);
                /*saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));*/
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                /*saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,sampleDate,sampleDate,res.id,acc.id,null,null));*/
                insert saloonInvoiceList;
            //}catch(Exception e){}
        // }
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
    }
    private static testMethod void VisitAndInvoiceExisitingRecordsLastDateSecondLastPopulatedOlderTHanMonth(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        
        
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[0].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[1].id;
        orderList.add(order);        
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[2].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-2);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-3);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);        
        
        //User u = TestUtility.getCustomerArgoUser();
        //system.runAs(u){
             
           // try{
                insert orderList;
                
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
                
                Date todayDate = system.today();
                List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[0].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[0].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[1].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[1].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[2].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[2].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[3].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[4].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-2);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[5].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-3);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                insert invoiceList;
                
                List<ivydsd__Invoice_Line_Item__c> invoiceItemList = new List<ivydsd__Invoice_Line_Item__c>();
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[0].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[1].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[2].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[3].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[4].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[5].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                insert invoiceItemList;
                
                /*List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
                Date sampleDate = date.today();
                
                Date secondOldDate = Date.newInstance(sampleDate.year(), (sampleDate.month()-4), sampleDate.day());
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                insert saloonInvoiceList;*/
           //}catch(Exception e){}
        //} 
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
    }
    private static testMethod void VisitAndInvoiceExisitingRecordsAllEmpty(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        
        
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[0].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[1].id;
        orderList.add(order);        
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[2].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-2);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-3);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);        
        
       // User u = TestUtility.getCustomerArgoUser();
       // system.runAs(u){
             
          //  try{
                insert orderList;
                
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                   // vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
                
                Date todayDate = system.today();
                List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[0].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[0].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[1].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[1].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[2].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[2].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[3].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[4].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-2);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[5].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-3);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                insert invoiceList;
                
                List<ivydsd__Invoice_Line_Item__c> invoiceItemList = new List<ivydsd__Invoice_Line_Item__c>();
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[0].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[1].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[2].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[3].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[4].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[5].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                insert invoiceItemList;
                
                /*List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
                Date sampleDate = date.today();
                Date secondOldDate = sampleDate.addDays(-3242);
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,null,res.id,acc.id,null,null));
                insert saloonInvoiceList;*/
            //}catch(Exception e){}
        //} 
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
    }
    private static testMethod void VisitAndInvoiceExisitingRecordsLastDateOnlyPopulated(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[0].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[1].id;
        orderList.add(order);        
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[2].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-2);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-3);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);        
        
       // User u = TestUtility.getCustomerArgoUser();
       // system.runAs(u){
             
        //    try{
                insert orderList;
                
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                   // vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
                
                Date todayDate = system.today();
                List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[0].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[0].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[1].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[1].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[2].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[2].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[3].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[4].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-2);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[5].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-3);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                insert invoiceList;
                
                List<ivydsd__Invoice_Line_Item__c> invoiceItemList = new List<ivydsd__Invoice_Line_Item__c>();
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[0].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[1].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[2].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[3].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[4].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[5].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                insert invoiceItemList;
                
                /*List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
                Date sampleDate = date.today();
                Date secondOldDate = sampleDate.addDays(-3242);
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(null,null,sampleDate,res.id,acc.id,null,null));
                insert saloonInvoiceList;*/
           // }catch(Exception e){}
       // } 
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
    }
    private static testMethod void VisitAndInvoiceExisitingRecordsLastDateSecondLastPopulated(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[0].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[1].id;
        orderList.add(order);        
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[2].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-2);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-3);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);        
        
        //User u = TestUtility.getCustomerArgoUser();
       // system.runAs(u){
             
           // try{
                insert orderList;
                
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                   // vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                   // vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
                
                Date todayDate = system.today();
                List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[0].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[0].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[1].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[1].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[2].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[2].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[3].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[4].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-2);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[5].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-3);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                insert invoiceList;
                
                List<ivydsd__Invoice_Line_Item__c> invoiceItemList = new List<ivydsd__Invoice_Line_Item__c>();
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[0].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[1].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[2].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[3].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[4].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[5].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                insert invoiceItemList;
                
                /*List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
                Date sampleDate = date.today();
                
                Date secondOldDate = Date.newInstance(sampleDate.year(), (sampleDate.month()-1), sampleDate.day());
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res1.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
                insert saloonInvoiceList;*/
           // }catch(Exception e){}
        //} 
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
    }
    
    private static testMethod void VisitAndInvoice(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();        
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[0].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[1].id;
        orderList.add(order);        
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[2].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-2);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-3);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);        
        
        //User u = TestUtility.getCustomerArgoUser();
        //system.runAs(u){
             
          //  try{
                insert orderList;
                
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                   // vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
                
                Date todayDate = system.today();
                List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[0].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[0].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[1].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[1].id;
                invoice.ivydsd__Resource__c=res1.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[2].id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                invoice.Division__c=div[2].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[3].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-1);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[4].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-2);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[5].id , con.id);
                invoice.ivydsd__Invoice_Date__c = todayDate.addDays(-3);
                invoice.Division__c=div[3].id;
                invoice.ivydsd__Resource__c=res.id;
                invoiceList.add(invoice);
                
                insert invoiceList;
                
                List<ivydsd__Invoice_Line_Item__c> invoiceItemList = new List<ivydsd__Invoice_Line_Item__c>();
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[0].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[1].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[2].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[3].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[4].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[5].Id,p1.Id); 
                
                invoiceItemList.add(invLineItem);
                
                insert invoiceItemList;
           // }catch(Exception e){}
        //} 
        
        List<Account> accList = [SELECT Id, Name FROM Account];
        System.debug('accList.size()===>'+accList);
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
                
    }
    private static testMethod void onlyVisit(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        insert res1;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        List<Division__c> div = new List<Division__c>();
        for(integer i=0;i<5;i++)
        {
            div.add(TestUtility.createdivision(''+i*30));
        }
        insert div;
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        
        
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res1.id;
        order.Division__c=div[0].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res1.id;
        order.Division__c=div[1].id;
        orderList.add(order);        
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today();
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[2].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-1);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-2);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);  
        
        order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c=date.today().addDays(-3);
        order.ivydsd__Resource__c=res.id;
        order.Division__c=div[3].id;
        orderList.add(order);        
        
        //User u = TestUtility.getCustomerArgoUser();
       // system.runAs(u){
             
         //   try{
                insert orderList;
                
                List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[1].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[2].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[3].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                oli = TestUtility.createTestOrderLineItem(orderList[4].id , p1.id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
                
                insert oliList;
                
                List<ivybase__Visit__c> visitListA = new List<ivybase__Visit__c>();
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                  //  vi.Division__c=div[0].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res1.id;
                    //vi.Division__c=div[1].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                   // vi.Division__c=div[2].id;
                    visitListA.add(vi);
                }
                for(integer i=0;i<50;i++)
                {
                    Date d = Date.today();            
                    ivybase__Visit__c vi= TestUtility.createTestVisit(d.addDays(i*(-1)) ,acc.Id ,'');  
                    vi.ivybase__Resource__c=res.id;
                    //vi.Division__c=div[3].id;
                    visitListA.add(vi);
                }
                
                insert visitListA;
         //   }catch(Exception e){}
       // } 
        
        BatchSalonInvoice_Resource b = new BatchSalonInvoice_Resource();
        database.executeBatch(b,1);
        
    }  
}