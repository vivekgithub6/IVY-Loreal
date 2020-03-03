/**
 * Created By : Ivy Mobility
 * Purpose : This class is used to query the Orders and Order Line Item records
 * Referred In :RESTOrderDetails, RESTOrderManager, OrderUpload
 * Test Class : TestRestOrderDetails
*/
public with sharing class OrderService {
    
    public static Map<String,ivydsd__Order__c> getOrders(Set<String> orderNumberSet){
        
        Map<String,ivydsd__Order__c> orderNumberAndOrderMap = new Map<String,ivydsd__Order__c>();
        String[] ordFields = new String[] {'ivydsd__Mobile_Order_Number__c'}; 
            
            if (SecurityUtility.checkIsAccessible('ivydsd__Order__c', ordFields)) {
                for(ivydsd__Order__c order : [SELECT Id, Name, ivydsd__Store__c, POSM_Order__c, Handling_Charges__c, Tax_Details__c,
                    Total_Tax_Value__c, Payer_Code__c, Order_Notes__c, Signature_Image_Path__c, ivydsd__Order_Status__c, 
                    ivydsd__Geolocation__longitude__s, ivydsd__Geolocation__latitude__s, ivydsd__Remarks__c, ivydsd__Resource__c, 
                    ivydsd__Order_Date__c, ivydsd__Delivery_Date__c, ivydsd__Purchase_Order_Number__c, ivydsd__Mobile_Order_Number__c,
                    ivydsd__Visit__c, Customer_PO__c 
                    FROM ivydsd__Order__c 
                    WHERE ivydsd__Mobile_Order_Number__c IN:orderNumberSet]){
                    orderNumberAndOrderMap.put(order.ivydsd__Mobile_Order_Number__c, order);
                }
                return orderNumberAndOrderMap;
            }else {
                throw new SecurityUtility.SFDCAccessControlException(
                    CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    }
    
    //ORDER HEADER VALUES RETURNING
    public static List<ivydsd__Order__c> getorderheader(){
        
        List<Account> AccountsList= AccountService.getAllRetailerMaster_List_for_Resource();
        List<Account> AccountVisitList = new  List<Account>();
        Set<Id> visitIdSet = new Set<Id>();
        Set<Id> draftOrderIdSet = new Set<Id>();
        List<ivydsd__order__c> draftOrderList = new List<ivydsd__Order__c>();
        system.debug('AccountsList'+AccountsList);
        String[] ordFields = new String[] {'Id','Name','ivydsd__Order_Date__c','ivydsd__Store__c','ivydsd__Order_Value__c',
            'ivydsd__Number_of_Line_Items__c','ivydsd__Delivery_Date__c','ivydsd__Purchase_Order_Number__c','ivydsd__Remarks__c',
            'ivydsd__Geolocation__c','Total_Tax_Value__c','Payer_Code__c','Tax_Details__c','Handling_Charges__c','Order_Notes__c',
            'Signature_Image_Path__c','ivydsd__Order_Status__c'};
            
        if(SecurityUtility.checkIsAccessible('ivydsd__Order__c', ordFields)) {
            List<ivydsd__Order__c> orderList= new List<ivydsd__Order__c>();
            
            //query for the latest visit of every store and the latest draft order of every store limited to the last 30 days
            AccountVisitList = [SELECT Id, Name, 
                                (SELECT Id, Name FROM ivybase__visits__r WHERE ivybase__Visit_Date__c = LAST_N_DAYS:30 
                                ORDER BY ivybase__Visit_Date__c DESC LIMIT 1),
                                (SELECT Id, Name, Customer_PO__c, ivydsd__Order_Status__c, ivydsd__Order_Date__c, ivydsd__Resource__c 
                                FROM ivydsd__orders__r WHERE 
                                (ivydsd__Order_Date__c = LAST_N_DAYS:30) AND ivydsd__Resource__c != null AND 
                                ivydsd__Resource__r.ivybase__Related_User__c=:UserInfo.getUserId() AND ivydsd__Order_Status__c = 'Draft'
                                ORDER BY ivydsd__Order_Date__c DESC, Name DESC LIMIT 1)
                                FROM Account WHERE Id IN :AccountsList];
            for(Account acc : AccountVisitList){
                system.debug('acc'+acc.name+' - '+acc.ivydsd__orders__r);
                //check for visit before moving forward
                if(acc.ivybase__visits__r.size()>0){
                    visitIdSet.add(acc.ivybase__visits__r[0].Id);
                } if(acc.ivydsd__orders__r.size() > 0){
                    if(acc.ivydsd__orders__r[0].ivydsd__Order_Status__c=='Draft'){
                        //if there haven't been any visits, check if there is a latest order in draft
                        draftOrderIdSet.add(acc.ivydsd__orders__r[0].Id);
                    }
                }
                // if there is neither a visit nor a draft order, ignore
            }
            //query for all the draft orders from the visits found and the draft orders
            orderList = [SELECT Id, Name, ivydsd__Internal_Id__c, ivydsd__Order_Date__c, ivydsd__Store__c, ivydsd__Store__r.ivybase__Internal_Id__c,
                    ivydsd__Order_Value__c, ivydsd__Number_of_Line_Items__c, ivydsd__Delivery_Date__c, ivydsd__Purchase_Order_Number__c,
                    ivydsd__Mobile_Order_Number__c, ivydsd__Remarks__c, Bill_To__c, Bill_To__r.ivybase__Internal_Id__c, Ship_To__c, Customer_PO__c,
                    Ship_To__r.ivybase__Internal_Id__c, ivydsd__Geolocation__c, ivydsd__Geolocation__latitude__s, ivydsd__Geolocation__longitude__s,
                    Total_Tax_Value__c, Payer_Code__c, Tax_Details__c, Handling_Charges__c, Order_Notes__c, Signature_Image_Path__c, ivydsd__Order_Status__c 
                    FROM ivydsd__Order__c WHERE (Id IN :draftOrderIdSet) ];
            return orderList;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(
                CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    //lineitems
    public static List<ivydsd__Order_Line_Item__c> getorderlineitem(Set<Id> ordId) {
        String[] ordlynitemFields = new String[] {'Id', 'ivydsd__Order__c', 'ivydsd__Product1__c', 'ivydsd__UOM_1_Quantity__c',
                'ivydsd__UOM_1_Rate__c', 'ivydsd__Total_Amount__c', 'ivydsd__Line_Item_Type__c'};
            List<ivydsd__Order_Line_Item__c> orderlineitemList= new List<ivydsd__Order_Line_Item__c>();
            
        if (SecurityUtility.checkIsAccessible('ivydsd__Order_Line_Item__c', ordlynitemFields)) {
        
            orderlineitemList=[SELECT Id, ivydsd__Order__c, ivydsd__UOM_1_Name__c, ivydsd__Order__r.Name, ivydsd__Order__r.ivydsd__Internal_Id__c,
                        ivydsd__Order__r.ivydsd__Mobile_Order_Number__c, ivydsd__Order__r.ivydsd__Order_Type__c, ivydsd__Product1__c, 
                        ivydsd__Product1__r.ivybase__InternalId__c, ivydsd__UOM_1_Quantity__c, ivydsd__UOM_1_Rate__c, ivydsd__Total_Amount__c,
                        ivydsd__Line_Item_Type__c, ivydsd__Product1__r.ivybase__Active__c 
                        FROM ivydsd__Order_Line_Item__c 
                        WHERE ivydsd__Order__c IN :ordId AND ivydsd__Product1__r.ivybase__Active__c = 'Yes'];
        }
        
        return orderlineitemList;
    }
    
    //Method is used to get last 4 orders for a store under a resource
    public static Map<Id,List<ivydsd__Order__c>> getOrderbyordDate(){
        
        String[] ordFields = new String[]{'ivydsd__Order_Date__c','ivydsd__Store__c','ivydsd__Order_Value__c','ivydsd__Number_of_Line_Items__c',
                'ivydsd__Internal_Id__c','ivydsd__Seller__c','ivydsd__Purchase_Order_Number__c'};
        String[] accFields = new String[]{'ivybase__Internal_Id__c'};
        Id sellerId = ResourceService.getLoginSellerId();
        Set<String> ignoredOrderStatus = new Set<String>{'Deleted', 'Draft', null};
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Order__c', ordFields) && SecurityUtility.checkIsAccessible('Account',accFields)) {
            Set<Id> accIdSet = new Set<Id>();
            List<Account> accList= AccountService.getAllRetailerMaster_List_for_Resource();
            system.debug('accList'+accList);
            for(Account acc : accList){
                accIdSet.add(acc.Id);
            }
            /*List<Account> AccInvLst= new List<Account>([SELECT Id, ivybase__Internal_Id__c, 
                        (SELECT Id, Name, ivydsd__Order_Date__c,ivydsd__Store__r.ivybase__StoreCode__c, ivydsd__Order_Status__c, ivydsd__Store__c,
                                ivydsd__Store__r.ivybase__Internal_Id__c, ivydsd__Order_Value__c, ivydsd__Number_of_Line_Items__c, 
                                ivydsd__Internal_Id__c, ivydsd__Resource__c, ivydsd__Purchase_Order_Number__c 
                            FROM  ivydsd__Orders__r 
                            WHERE ivydsd__Order_Date__c != null AND ivydsd__Order_Date__c = TODAY AND ivydsd__Resource__c =:sellerId 
                            ORDER BY CreatedDate DESC LIMIT 4) 
                       FROM Account
                       WHERE Id IN:accId AND Id IN (SELECT ivydsd__Store__c FROM ivydsd__Order__c )]);*/
            List<ivydsd__Order__c> orderList = [SELECT Id, Name, ivydsd__Order_Date__c, ivydsd__Store__r.ivybase__StoreCode__c, Customer_PO__c,
                                ivydsd__Order_Status__c, ivydsd__Store__c, ivydsd__Store__r.ivybase__Internal_Id__c, ivydsd__Order_Value__c, 
                                ivydsd__Number_of_Line_Items__c, ivydsd__Internal_Id__c,Argo_Order__c, Purchase_Order_Number__c,ivydsd__Resource__c, ivydsd__Purchase_Order_Number__c 
                            FROM  ivydsd__Order__c 
                            WHERE ivydsd__Order_Date__c != null AND ivydsd__Resource__c =:sellerId
                                AND ivydsd__Store__c =:accIdSet AND ivydsd__Order_Date__c = LAST_N_DAYS:60
                                AND ivydsd__Order_Status__c NOT IN:ignoredOrderStatus
                            ORDER BY CreatedDate DESC];
            
            System.debug('orderList====>'+orderList);
            Map<Id, List<ivydsd__Order__c>> accOrdMap= new Map<Id, List<ivydsd__Order__c>>();//storing accId and respective last 4 orders
            //for(Account acc : AccInvLst){
                for(ivydsd__Order__c ord : orderList) {
                    if(accOrdMap.containskey(ord.ivydsd__Store__c)){
                        accOrdMap.get(ord.ivydsd__Store__c).add(ord);  
                    } else {
                        accOrdMap.put(ord.ivydsd__Store__c, new List<ivydsd__Order__c>{ord});
                    }
                }
            //}
            return accOrdMap;
        } else { 
            throw new SecurityUtility.SFDCAccessControlException(
                CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static Map<Id,String> getOrderByvisits(Set<Id> visitId) {
        
        String[] ordFields = new String[]{'ivydsd__Order_Date__c','ivydsd__Store__c','ivydsd__Seller__c'};
        String[] accFields = new String[]{'ivybase__Internal_Id__c'};
        Map<Id,String> ordIdandStoreMap = new Map<Id,String>();
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Order__c', ordFields) && SecurityUtility.checkIsAccessible('Account',accFields)){
            List<ivydsd__Order__c> ordList = [SELECT 
                                              Id,Name,ivydsd__Order_Date__c,ivydsd__Store__c,ivydsd__Store__r.ivybase__Internal_Id__c,
                                              ivydsd__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c
                                              FROM
                                              ivydsd__Order__c
                                              WHERE 
                                              ivydsd__Visit__c IN :visitId
                                             ];
            System.debug('ordList:: '+ordList);
            for(ivydsd__Order__c ord : ordList){
                if(!ordIdandStoreMap.containskey(ord.Id)){
                    ordIdandStoreMap.put(ord.Id,String.Valueof(ord.ivydsd__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c));
                }
            }
            System.debug('ordIdandStoreMap:: '+ordIdandStoreMap);
            return ordIdandStoreMap;
            
        } else {
            throw new SecurityUtility.SFDCAccessControlException(
            CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    //This method is used to return the Scheme Apply details
    public static list<ivydsd__Scheme_Apply_Detail__c> getschemeApplyDetail(set<id> ordid){
   
        System.debug('ordid==>'+ordid);
 
        String[] schemeApplyFields = new String[] {'Id','RecordTypeId','ivydsd__Scheme__c','ivydsd__Order_Line_Item__c','ivydsd__Order__c'};
            list<ivydsd__Scheme_Apply_Detail__c> orderlineitemlist= new list<ivydsd__Scheme_Apply_Detail__c>();
        if (SecurityUtility.checkIsAccessible('ivydsd__Scheme_Apply_Detail__c', schemeApplyFields)) {
            orderlineitemlist=[select Id,RecordTypeId,ivydsd__Scheme__c,
                                ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c,
                                ivydsd__Scheme__r.ivydsd__Internal_Id__c,ivydsd__Scheme__r.ivydsd__Scheme__r.ivydsd__Internal_Id__c,
                                ivydsd__Order_Line_Item__c,ivydsd__Order__c,ivydsd__Order__r.ivydsd__Store__r.ivybase__Internal_Id__c,
                                ivydsd__Order__r.ivydsd__Internal_Id__c,ivydsd__Order__r.ivydsd__Mobile_Order_Number__c, Amount__c,
                                Value__c, Scheme_Description__c, No_of_Promotions_Applied__c
                                FROM ivydsd__Scheme_Apply_Detail__c Where ivydsd__Order__c IN:ordid ];
        }
        System.debug('orderlineitemlist==>'+orderlineitemlist.size());
        return orderlineitemlist;
    }
}