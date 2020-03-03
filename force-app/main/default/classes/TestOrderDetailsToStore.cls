@isTest
public class TestOrderDetailsToStore {
    public static testmethod void test1()
    {
            ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
            insert restype;
        
            Id userId = UserInfo.getUserId();
            ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
            res.SAP_Id__c='12121212';
            insert res;
            
            Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
            system.debug(RT);
            
            Division__c  division = new Division__c ();
            division.name='matrix';
            division.Market_ISO__c='MY';
            insert division;
            
            
            ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
            locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
            locHr.ivybase__Resource_Type__c = restype.id;
            insert locHr;
            
            DivisionLocation__c  divLoc = new DivisionLocation__c();
            divLoc.Location_Hierarchy__c=locHr.id;
            divLoc.Division__c=division.id;
            divLoc.Market_ISO__c='MY';
            insert divLoc;
            
            List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'TAX_TYPE',ivybase__Flex1__c='12',ivybase__Location_Hierarchy__c=locHr.id,ivybase__Resource_Type__c=restype.id)
                    }; 
                        insert stdMasterList;
            
            Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
            acc.ivybase__Location_Hierarchy__c = locHr.Id;
            acc.Converted_to_Normal_Saloon__c = true;
            acc.Dream_List_Status__c ='Test';
            acc.ivybase__Contact_Email__c='gokul.rajan@absyz.com';
            acc.Progress_Percentage__c = 100;
            insert acc;
            acc.ivybase__Active__c = 'Yes';
            update acc;
            
            Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '1234567892' , '1112223332' , res.id , 'Retail_Account' , 'Yes' );
            acc2.ivybase__Location_Hierarchy__c = locHr.Id;
            acc2.Converted_to_Normal_Saloon__c = true;
            acc2.Dream_List_Status__c ='Test';
            acc2.Progress_Percentage__c = 100;
            insert acc2;
            acc2.ivybase__Active__c = 'Yes';
            update acc2;
            
            ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
            insert route;
            Territory_Routing__c territoryRoute = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
            insert territoryRoute;
            ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
            insert routeDetail;
            ivybase__Route_Details__c routeDetail2 = TestUtility.createTestRouteDetail('TestRouteDetail2',route.Id,'Yes',acc2.Id);   
            insert routeDetail2;
            
            
            ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
            insert ph;
            
            ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
            insert p1;
            
            
            Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
            insert con;
            
            ivybase__Visit__c v1 = TestUtility.createTestVisit(Date.today(), acc.Id ,'');  
            insert v1;
            
            List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
            for(integer i=0;i<20;i++)
            {
                ivydsd__Order__c order;
                if(i>10){
                 order = TestUtility.createTestOrder(acc.id,'Draft',con.id,'1');
                }
                else
                {
                   order = TestUtility.createTestOrder(acc2.id,'Draft',con.id,'1'); 
                }
                order.ivydsd__Purchase_Order_Number__c=''+i*342;
                order.Division__c=division.id;
                order.ivydsd__Resource__c=res.id;
                orderList.add(order);
            }
            insert orderList;
            
            List<ivydsd__Order_Line_item__c> orderlineItemList = new List<ivydsd__Order_Line_item__c>();
            for(integer i=0;i<20;i++)
            {
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[i].id, p1.id, 100 , 100 , 100 , 20 , 30 , 20 );
                oli.ivydsd__UOM_1_Rate__c=500;
                orderlineItemList.add(oli);
            }
            insert orderlineItemList;
        
        
        List<ivydsd__Order__c> ord = [select id,name,ivydsd__Order_Value__c,ivydsd__Final_Order_Value__c from ivydsd__Order__c where id=:orderList[0].id];
        system.debug('****ord'+ord);
        map<string,ivybase__Standard_List_Master__c> standardlistTaxvalue=new map<string,ivybase__Standard_List_Master__c>();
                for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('TAX_TYPE')})){
                    if(stdListMaster!=null){
                        standardlistTaxvalue.put(stdListMaster.ivybase__List_Type__c,stdListMaster);                
                    }
                }
        system.debug('standardlistTaxvalue'+standardlistTaxvalue);
        OrderDetailsToStore order = new OrderDetailsToStore();
        order.OrderId=orderList[0].id;
        order.getOrderDetails();
        order.getOrderLineItemDetails();
       
    }
}