/**
 * Modified By : Ivy Mobility
 * Purpose : This class is used to assign value for the Order object from the mobile uploaded data
 * Refered In : LOrealUpload class
 * Test Class : testLorealUploadTranslator, TestOrderUploadTranslator
*/
public class OrderUploadTranslator {
    public static void translateOrderHeader(List<LorealUploadclass.OrderHeader> OrderHeader,List<LorealUploadclass.OrderDetail> OrderDetail){
        
        List<ivydsd__Order__c > orderList = new List<ivydsd__Order__c >();
        List<ivydsd__Order__c > orderListtoUpdate = new List<ivydsd__Order__c >();
        ivybase__Visit__c visit = new ivybase__Visit__c();
        Set<String> productIdSet = new Set<String>();
        Map<String,Boolean> OrderPOSMMap=new Map<String,Boolean>();
        Set<String> orderNumberSet = new Set<String>();
        if(OrderHeader != null){
            
            if(OrderDetail!=null)
            {
                for(LorealUploadclass.OrderDetail detail : OrderDetail ){                    
                    if(String.isEmpty(detail.ProductId) == false) productIdSet.add(detail.ProductId);
                }
                System.debug('productIdSet====>'+productIdSet);
                Map<String,ivybase__Product__c> prodInternalIdWithSFIdMap =  ProductService.getSFRecordByInternalId(productIdSet);
                System.debug('prodInternalIdWithSFIdMap====>'+prodInternalIdWithSFIdMap);
                for(LorealUploadclass.OrderDetail detail : OrderDetail ){                    
                    if(String.isEmpty(detail.ProductId) == false)
                    {
                        if(prodInternalIdWithSFIdMap.containsKey(detail.ProductId))
                        {
                            if(prodInternalIdWithSFIdMap.get(detail.ProductId).ivybase__Non_Saleable__c!=null){
                                if(OrderPOSMMap.containsKey(detail.OrderID))
                                {
                                    if(OrderPOSMMap.get(detail.OrderID)!=false)
                                    {
                                        OrderPOSMMap.put(detail.OrderID,prodInternalIdWithSFIdMap.get(detail.ProductId).ivybase__Non_Saleable__c);
                                    }
                                }else{
                                    OrderPOSMMap.put(detail.OrderID,prodInternalIdWithSFIdMap.get(detail.ProductId).ivybase__Non_Saleable__c);
                                }
                            }
                        }
                    }
                }
            }
            Set<String> retailerIdSet = new Set<String>();
            for(LorealUploadclass.OrderHeader orderHead : OrderHeader ){
                if(String.isEmpty(orderHead.OrderID) == false) orderNumberSet.add(orderHead.OrderID);
                if(String.isEmpty(orderHead.RetailerId) == false){ 
                    retailerIdSet.add(String.valueOf(orderHead.RetailerId));
                }
                if(String.isEmpty(orderHead.ShipTo) == false){
                    retailerIdSet.add(String.valueOf(orderHead.ShipTo));
                }
                if(String.isEmpty(orderHead.BIllTo) == false){
                    retailerIdSet.add(String.valueOf(orderHead.BIllTo));
                }
            }
            Id normalOrder;
            Id POSMOrder;
            for(RecordType recType: RecordTypeService.getObjectBasedRecordTypesCustomOne('ivydsd__Order__c')){
                
                if(recType.DeveloperName == 'Order'){
                    normalOrder = recType.Id;
                }
                if(recType.DeveloperName == 'POSM_Order'){
                    POSMOrder = recType.Id;
                }
            }
            system.debug('orderNumberSet===>'+orderNumberSet);
            Map<String,ivydsd__Order__c> orderNumberAndOrderMap = OrderService.getOrders(orderNumberSet);
            system.debug('orderNumberAndOrderMap'+orderNumberAndOrderMap);
            Map<String,Account> internalIdWithAccountMap = AccountService.getAccountByInternalId(retailerIdSet);
            List<String> accSFIdList = new List<String>();
            for(Account acc : internalIdWithAccountMap.values()){
                accSFIdList.add(acc.Id);
            }
            String sellerId = ResourceService.getLoginSellerId();
            List<ivybase__Visit__c> visitList = ivype.VisitFacade.getVisitList(accSFIdList,sellerId);
            list<string> typename= new list<string>();
            typename.add('ORDER_STATUS');
            typename.add('Amazon_Configuration');
            String hostUrl;
            list<ivybase__Standard_List_Master__c> statusMapListCode= StandardListMasterservice.getStandardListUsingListType(typename);
            map<string,string> statuscode = new map<string,string>();
            if(statusMapListCode!=null){
                for(ivybase__Standard_List_Master__c std:statusMapListCode){
                    if(std.ivybase__List_Code__c=='AS_HOST'){
                        hostUrl=std.ivybase__List_Name__c;
                    }
                    
                    statuscode.put(std.ivybase__List_Name__c,std.ivybase__List_Code__c);
                }
            }
            UserwiseCountryValues__c ucv = UserwiseCountryValues__c.getValues(UserInfo.getUserId());
            System.debug('u=====>'+ucv);

            //for Update
            for(LorealUploadclass.OrderHeader orderHead : OrderHeader ){
                if(orderNumberAndOrderMap.containsKey(orderHead.OrderID))
                {
                    if(orderNumberAndOrderMap.get(orderHead.OrderID).ivydsd__Order_Status__c!='Approved' && orderNumberAndOrderMap.get(orderHead.OrderID).ivydsd__Order_Status__c!='Pending For Approval'){
                        Date orddate;
                        if(String.isEmpty(orderHead.OrderDate) == false){
                            orddate = (orderHead.OrderDate.trim() != '') ? ConversionUtility.StringToDateConversion(orderHead.OrderDate):null;
                        }
                        String retailerId = (String.isEmpty(orderHead.RetailerId) == false) ? String.valueOf(orderHead.RetailerId):'';
                        if(String.isEmpty(orderHead.RetailerId) == false && orddate != null){
                            
                            // Date orderDate = (orderHead.OrderDate.trim() != '') ? convertStringToDate(orderHead.OrderDate):null;
                            Id storeId = internalIdWithAccountMap.containskey(orderHead.RetailerId)?internalIdWithAccountMap.get(orderHead.RetailerId).Id : null;
                            visit = (storeId != null) ? LOrealUploadTranslator.getVisit(visitList,storeId,orddate): new ivybase__Visit__c();
                        }
                        
                        ivydsd__Order__c order= orderNumberAndOrderMap.get(orderHead.OrderID);
                        ivydsd__Order__c originalOrder=order;
                        order.ivydsd__Visit__c = (visit!=null)?visit.Id:order.ivydsd__Visit__c;
                        order.Customer_PO__c = ((orderHead.po != null && orderHead.po != '') ? orderHead.po : order.Customer_PO__c); //po  
                        order.ivydsd__Delivery_Date__c = orderHead.deliveryDate != null ? ConversionUtility.StringToDateConversion(orderHead.deliveryDate):order.ivydsd__Delivery_Date__c;
                        order.ivydsd__Order_Date__c = orddate != null ? orddate : order.ivydsd__Order_Date__c;
                        if (sellerId != null) {
                            order.ivydsd__Resource__c  = sellerId;
                        } 
                        if(OrderPOSMMap.containsKey(orderHead.OrderID))
                        {
                            order.POSM_Order__c=OrderPOSMMap.get(orderHead.OrderID);
                            if(order.POSM_Order__c)
                            {
                               order.RecordTypeId=POSMOrder;
                            }
                            else
                            {
                                order.RecordTypeId=normalOrder; 
                            }
                        }
                        order.ivydsd__Remarks__c = String.isEmpty(orderHead.remark) == false ? orderHead.remark:order.ivydsd__Remarks__c;
                        order.ivydsd__Geolocation__latitude__s = (orderHead.latitude!=null && String.isEmpty(orderHead.latitude) == false) ? Decimal.valueOf(orderHead.latitude):order.ivydsd__Geolocation__latitude__s;
                        order.ivydsd__Geolocation__longitude__s = (orderHead.longitude!=null && String.isEmpty(orderHead.longitude) == false) ? Decimal.valueOf(orderHead.longitude):order.ivydsd__Geolocation__longitude__s;
                        order.ivydsd__Order_Status__c = orderHead.Status!=null ? orderHead.Status: null;
                        order.Signature_Image_Path__c=(orderHead.SignatureImagePath!=null && String.isEmpty(orderHead.SignatureImagePath)==false)?orderHead.SignatureImagePath:null;
                        
                        order.Order_Notes__c=orderHead.Notes!=null?orderHead.Notes:order.Order_Notes__c;
                        order.Payer_Code__c=orderHead.PayerCode!=null?orderHead.PayerCode:order.Payer_Code__c;
                        order.Total_Tax_Value__c=orderHead.totalTaxValue!=null?ConversionUtility.StringToDecimal(orderHead.totalTaxValue):order.Total_Tax_Value__c;
                        order.Tax_Details__c=orderHead.Tax!=null?ConversionUtility.StringToDecimal(orderHead.Tax):order.Tax_Details__c;
                        order.Handling_Charges__c=orderHead.HandlingCharges!=null?ConversionUtility.StringToDecimal(orderHead.HandlingCharges):order.Handling_Charges__c;
                        order.ivydsd__Store__c = (internalIdWithAccountMap.containsKey(retailerId ) ? internalIdWithAccountMap.get(retailerId).Id : order.ivydsd__Store__c);
                        order.Bill_To__c = (orderHead.BIllTo!=null)?(internalIdWithAccountMap.containsKey(orderHead.BIllTo) ? internalIdWithAccountMap.get(orderHead.BIllTo).Id:order.Bill_To__c):order.Bill_To__c;
                        order.Ship_To__c = (orderHead.ShipTo!=null)?(internalIdWithAccountMap.containsKey(orderHead.ShipTo ) ? internalIdWithAccountMap.get(orderHead.ShipTo).Id:order.Ship_To__c):order.Ship_To__c ;
                        //if(order!=originalOrder){
                        order.Argo_Order__c = true;
                        orderListtoUpdate.add(order);
                        //}
                    }
                }
            }
            system.debug('orderListtoUpdate'+orderListtoUpdate);
            //for insert 
            for(LorealUploadclass.OrderHeader orderHead : OrderHeader ){
                if(!orderNumberAndOrderMap.containsKey(orderHead.OrderID)){
                    Date orddate;
                    if(String.isEmpty(orderHead.OrderDate) == false){
                        orddate = (orderHead.OrderDate.trim() != '') ? ConversionUtility.StringToDateConversion(orderHead.OrderDate):null;
                    }
                    String retailerId = (String.isEmpty(orderHead.RetailerId) == false) ? String.valueOf(orderHead.RetailerId):'';
                    if(String.isEmpty(orderHead.RetailerId) == false && orddate != null){
                        
                        // Date orderDate = (orderHead.OrderDate.trim() != '') ? convertStringToDate(orderHead.OrderDate):null;
                        Id storeId = internalIdWithAccountMap.containskey(orderHead.RetailerId)?internalIdWithAccountMap.get(orderHead.RetailerId).Id : null;
                        visit = (storeId != null) ? LOrealUploadTranslator.getVisit(visitList,storeId,orddate): new ivybase__Visit__c();
                    }
                    ivydsd__Order__c order = new ivydsd__Order__c();
                    order.ivydsd__Visit__c = (visit!=null? visit.Id:null);
                    order.ivydsd__Mobile_Order_Number__c = orderHead.OrderID;
                    order.Customer_PO__c = ((orderHead.po != null && orderHead.po != '') ? orderHead.po : ''); //po 
                    //  order.Delivery_Date__c = (orderHead.deliveryDate != null ? Date.valueOf(orderHead.deliveryDate):null);
                    order.ivydsd__Delivery_Date__c = orderHead.deliveryDate != null ? ConversionUtility.StringToDateConversion(orderHead.deliveryDate):null;
                    order.ivydsd__Order_Date__c = orddate != null ? Date.valueOf(orddate) : null;
                    if (sellerId != null) {
                        order.ivydsd__Resource__c  = sellerId;
                    }
                    if(OrderPOSMMap.containsKey(orderHead.OrderID))
                    {
                        order.POSM_Order__c=OrderPOSMMap.get(orderHead.OrderID);
                        if(order.POSM_Order__c)
                            {
                               order.RecordTypeId=POSMOrder;
                            }
                            else
                            {
                                order.RecordTypeId=normalOrder; 
                            }
                    }
                    order.ivydsd__Remarks__c = String.isEmpty(orderHead.remark) == false ? orderHead.remark:null;
                    order.ivydsd__Geolocation__latitude__s = (orderHead.latitude!=null && String.isEmpty(orderHead.latitude) == false) ? Decimal.valueOf(orderHead.latitude):null;
                    order.ivydsd__Geolocation__longitude__s = (orderHead.longitude!=null && String.isEmpty(orderHead.longitude) == false) ? Decimal.valueOf(orderHead.longitude):null;
                   
                    order.ivydsd__Order_Status__c = orderHead.Status!=null ? orderHead.Status: null;
                    order.Signature_Image_Path__c=(orderHead.SignatureImagePath!=null && String.isEmpty(orderHead.SignatureImagePath)==false)?hostUrl+'/'+orderHead.SignatureImagePath:null;
                    
                    order.Order_Notes__c=orderHead.Notes!=null?orderHead.Notes:null;
                    order.Payer_Code__c=orderHead.PayerCode!=null?orderHead.PayerCode:null;
                    order.Total_Tax_Value__c=orderHead.totalTaxValue!=null?ConversionUtility.StringToDecimal(orderHead.totalTaxValue):null;
                    order.Tax_Details__c=orderHead.Tax!=null?ConversionUtility.StringToDecimal(orderHead.Tax):null;
                    order.Handling_Charges__c=orderHead.HandlingCharges!=null?ConversionUtility.StringToDecimal(orderHead.HandlingCharges):null;
                    order.ivydsd__Store__c = (internalIdWithAccountMap.containsKey(retailerId ) ? internalIdWithAccountMap.get(retailerId).Id : null);
                    order.Bill_To__c = (orderHead.BIllTo!=null)?(internalIdWithAccountMap.containsKey(orderHead.BIllTo) ? internalIdWithAccountMap.get(orderHead.BIllTo).Id:null):null;
                    order.Ship_To__c = (orderHead.ShipTo!=null)?(internalIdWithAccountMap.containsKey(orderHead.ShipTo ) ? internalIdWithAccountMap.get(orderHead.ShipTo).Id:null):null ;
                    order.Market_ISO__c = ucv.Market_ISO__c;
                    order.Argo_Order__c = true;
                    orderList.add(order);
                }
            }  
        }
        system.debug('orderList'+orderList);
        if(orderList.size() > 0) {
            List<String> orderfields = new List<String> {'ivydsd__Visit__c', 'ivydsd__Mobile_Order_Number__c','ivydsd__Delivery_Date__c','ivydsd__Order_Date__c','ivydsd__Seller__c','ivydsd__Remarks__c','ivydsd__Geolocation__latitude__s','ivydsd__Geolocation__longitude__s','ivydsd__Order_Status__c','ivydsd__Store__c'};
            if (SecurityUtility.checkIsCreateable('ivydsd__Order__c', orderfields)) {
                System.debug('Query:Main Order Insert');
                insert orderList;
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
        }
        if(orderListtoUpdate.size() > 0) {
            List<String> orderfields = new List<String> {'ivydsd__Visit__c', 'ivydsd__Mobile_Order_Number__c','ivydsd__Delivery_Date__c','ivydsd__Order_Date__c','ivydsd__Seller__c','ivydsd__Remarks__c','ivydsd__Geolocation__latitude__s','ivydsd__Geolocation__longitude__s','ivydsd__Order_Status__c','ivydsd__Store__c'};
            if (SecurityUtility.checkIsCreateable('ivydsd__Order__c', orderfields)) {
                System.debug('Query:Main Order update');
                update orderListtoUpdate;
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
        }
    }
    
    public static void translateOrderDetails(List<LorealUploadclass.OrderDetail> OrderDetail,List<LorealUploadclass.SchemeDetail> SchemeDetail,List<LorealUploadclass.SchemeFreeProductDetail> schemeFreeProductDetail) {
        
        Set<String> orderNumberSet = new Set<String>();
        Set<String> productIdSet = new Set<String>();
        Set<String> uomIdSet = new Set<String>();
        Set<Id> OLIOrderIdSet = new Set<Id>();
        List<ivydsd__Order_Line_Item__c> lineItemList = new List<ivydsd__Order_Line_Item__c>();
        Map<String,ivybase__Standard_List_Master__c> internalIdAndSMasterMap = new Map<String,ivybase__Standard_List_Master__c>();
        
        Map<String,decimal> NoOfOrderLineItemMap = new map<String,decimal>();
        Map<String,Map<String,decimal>> orderlineitemItemNumberMap = new map<String,Map<String,decimal>>();
        Map<String,String> OrderbuyProductMap = new Map<String,String>();
        Map<String,Decimal> orderBuyLineNumberMap = new Map<String,Decimal>();
        Map<String,Set<String>> OrderGetProductMap = new Map<String,Set<String>>();
        
        //get all buy product 
        if(SchemeDetail!=null && SchemeDetail.size()>0) {
        for(LorealUploadclass.SchemeDetail scheme : SchemeDetail ) {
            if(scheme.OrderId!=null && String.isEmpty(scheme.OrderId) == false && scheme.ProductId!=null && String.isEmpty(scheme.ProductId) == false){
                OrderbuyProductMap.put(scheme.OrderId,scheme.ProductId);
            }
        }
        }
        //get all free products
        if(schemeFreeProductDetail!=null && schemeFreeProductDetail.size()>0) {
        for(LorealUploadclass.SchemeFreeProductDetail schemeFree : schemeFreeProductDetail ) {
            if(schemeFree.OrderId!=null && String.isEmpty(schemeFree.OrderId) == false && schemeFree.FreeProductID!=null && String.isEmpty(schemeFree.FreeProductID) == false) {
                //OrderGetProductMap.put(schemeFree.OrderId,schemeFree.FreeProductID);
                if(OrderGetProductMap.containsKey(schemeFree.OrderId)) {
                   OrderGetProductMap.get(schemeFree.OrderId).add(schemeFree.FreeProductID); 
                }
                else {
                    Set<String> prodCode = new Set<String>();
                    prodCode.add(schemeFree.FreeProductID);
                    OrderGetProductMap.put(schemeFree.OrderId,prodCode);
                }
            }
        }
        }
        //calculate line item number
        if(OrderDetail!=null && OrderDetail.size()>0) {
            for(LorealUploadclass.OrderDetail detail : OrderDetail ) {
                
                if(String.isEmpty(detail.OrderID) == false) orderNumberSet.add(detail.OrderID);
                if(String.isEmpty(detail.ProductId) == false) productIdSet.add(detail.ProductId);
                if(String.isEmpty(detail.uomid) == false) uomIdSet.add(detail.uomid);
                if(detail.OrderID!=null && String.isEmpty(detail.OrderID) == false && detail.ProductId!=null && String.isEmpty(detail.ProductId) == false) {
                    if(NoOfOrderLineItemMap.containsKey(detail.OrderID)) {
                        Decimal no = NoOfOrderLineItemMap.get(detail.OrderID);
                        no=no+10;
                        NoOfOrderLineItemMap.put(detail.OrderID,no);
                        detail.lineItemNumber=String.valueof(no);
                        if(detail.isFreeProduct==null || (detail.isFreeProduct!=null && detail.isFreeProduct!='1')) {
                            if(orderlineitemItemNumberMap.containsKey(detail.OrderID)) {
                            orderlineitemItemNumberMap.get(detail.OrderID).put(detail.ProductId,no); 
                            }
                        }
                        
                    } else {
                        NoOfOrderLineItemMap.put(detail.OrderID,10);
                        if(detail.isFreeProduct==null || (detail.isFreeProduct!=null && detail.isFreeProduct!='1')) {
                            Map<string,Decimal> productNo = new Map<String,decimal>();
                            productNo.put(detail.ProductId,10);
                            detail.lineItemNumber=String.valueof(10);
                            orderlineitemItemNumberMap.put(detail.OrderID,productNo);
                        }
                    }
                }
            }
        }
        //get the buy line item number for higher level number
        if(OrderDetail!=null && OrderDetail.size()>0) {
            for(LorealUploadclass.OrderDetail detail : OrderDetail ) {
                if(detail.OrderID!=null && String.isEmpty(detail.OrderID) == false && detail.ProductId!=null && String.isEmpty(detail.ProductId) == false) {
                    if(OrderbuyProductMap.containsKey(detail.OrderID)==true && OrderbuyProductMap.get(detail.OrderID)!=null && OrderbuyProductMap.get(detail.OrderID)==detail.ProductId) {
                        if(orderlineitemItemNumberMap.containsKey(detail.OrderID)==true && orderlineitemItemNumberMap.get(detail.OrderID).containsKey(detail.ProductId)==true && orderlineitemItemNumberMap.get(detail.OrderID).get(detail.ProductId)!=null) {
                            orderBuyLineNumberMap.put(detail.OrderID,orderlineitemItemNumberMap.get(detail.OrderID).get(detail.ProductId));
                        }
                    }
                }
            }
        }
        system.debug('****orderlineitemItemNumberMap'+orderlineitemItemNumberMap);
        system.debug('****orderBuyLineNumberMap'+orderBuyLineNumberMap);
        system.debug('****OrderGetProductMap'+OrderGetProductMap);
        system.debug('****OrderbuyProductMap'+OrderbuyProductMap);
        
        Map<String,ivydsd__Order__c> orderNumberAndOrderMap = OrderService.getOrders(orderNumberSet);
        Set<Id> orderIdSet = new Set<Id>();
        //delete the exisiting records:
        for(String key:orderNumberAndOrderMap.keySet()) {
            orderIdSet.add(orderNumberAndOrderMap.get(key).id);
        }
        system.debug('orderIdSet'+orderIdSet);
        List<ivydsd__Order_Line_Item__c> deleteExisitng = [select id,name from ivydsd__Order_Line_Item__c where ivydsd__Order__c=:orderIdSet];
        set<Id> orderLineItemIdSet = new Set<Id>();
        for(ivydsd__Order_Line_Item__c rec:deleteExisitng) {
            orderLineItemIdSet.add(rec.id);
        }
        system.debug('orderLineItemIdSet'+orderLineItemIdSet);
        
        delete deleteExisitng;
        
        Map<String,ivybase__Product__c> prodInternalIdWithSFIdMap =  ProductService.getSFRecordByInternalId(productIdSet);
        Map<Id,List<ivybase__Product_UOM__c>> productIdAndProductUOMListMap = new Map<Id,List<ivybase__Product_UOM__c>>();
        
        for( ivybase__Product_UOM__c  uom:  ivybase.ProductUOMFacade.getProductUOMListByProdInternalIds(productIdSet)){
            
            if(!productIdAndProductUOMListMap.containsKey(uom.ivybase__Product__c))
                productIdAndProductUOMListMap.put(uom.ivybase__Product__c, new List<ivybase__Product_UOM__c>());
            productIdAndProductUOMListMap.get(uom.ivybase__Product__c).add(uom);
        }

        for(ivybase__Standard_List_Master__c stdMaster:   StandardListMasterservice.getAllStandard_List()){
            internalIdAndSMasterMap.put(stdMaster.Name,stdMaster);
        }
        Map<id,map<id,Decimal>> accountidprodqtyMap=new Map<id,map<id,Decimal>>();
        Map<ivydsd__Order__c,List<ivybase__Product__c>> OrderIdwithSetOfProductIdMap = new Map<ivydsd__Order__c,List<ivybase__Product__c>>();
        for(LorealUploadclass.OrderDetail detail : OrderDetail) {
            
            //---added for Quota---------------------
            if(orderNumberAndOrderMap!=null && orderNumberAndOrderMap.containskey(detail.OrderId) && orderNumberAndOrderMap.get(detail.OrderId)!=null) {
                system.debug('orderNumberAndOrderMap123'+orderNumberAndOrderMap);
                system.debug('IF condition'+accountidprodqtyMap.containskey(orderNumberAndOrderMap.get(detail.OrderId).ivydsd__Store__c));
                if(accountidprodqtyMap.containskey(orderNumberAndOrderMap.get(detail.OrderId).ivydsd__Store__c) == true) {
                    system.debug('accountidprodqtyMap123'+accountidprodqtyMap);
                    system.debug('prodInternalIdWithSFIdMap123'+prodInternalIdWithSFIdMap);
                    system.debug('detailorderid'+detail.OrderId);
                    system.debug('detailprodcut'+detail.ProductId);
                    system.debug('qtydetail'+detail.pieceQty);
                    if(prodInternalIdWithSFIdMap.containskey(detail.ProductId)){
                        if(detail.pieceQty!=null){
                            accountidprodqtyMap.get(orderNumberAndOrderMap.get(detail.OrderId).ivydsd__Store__c).put(prodInternalIdWithSFIdMap.get(detail.ProductId).Id,ConversionUtility.StringToDecimal(detail.pieceQty));  
                        }
                    }
                } else {
                    Map<id,Decimal> productWithQty = new Map<id,Decimal>();
                    if(prodInternalIdWithSFIdMap.containsKey(detail.ProductId)){
                        if(detail.pieceQty!=null){
                            productWithQty.put(prodInternalIdWithSFIdMap.get(detail.ProductId).Id,ConversionUtility.StringToDecimal(detail.pieceQty));
                            accountidprodqtyMap.put(orderNumberAndOrderMap.get(detail.OrderId).ivydsd__Store__c,productWithQty);
                        }
                    }
                }
            }
            if(detail.OrderID != null && orderNumberAndOrderMap != null && orderNumberAndOrderMap.containsKey(detail.OrderId)) {
                
                ivydsd__Order_Line_Item__c lineitem = new ivydsd__Order_Line_Item__c();
                lineitem.ivydsd__Order__c = orderNumberAndOrderMap.get(detail.OrderId).Id;
                
                if(detail.ProductId!=null) {
                    //higher line item population
                    if(detail.isFreeProduct=='1' && OrderGetProductMap.containsKey(detail.OrderId)==true && OrderGetProductMap.get(detail.OrderId).contains(detail.ProductId)==true) {
                        if(orderBuyLineNumberMap.containsKey(detail.OrderId)==true && orderBuyLineNumberMap.get(detail.OrderId)!=null) {
                            lineitem.Higher_Level_Item__c=orderBuyLineNumberMap.get(detail.OrderId);
                        }
                    }
                    //populate line item number 
                    if(detail.lineItemNumber!=null && string.isEmpty(detail.lineItemNumber)==false) {
                        lineitem.Item_Number__c=ConversionUtility.StringToInteger(detail.lineItemNumber);
                    }
                }

                if(detail.isFreeProduct != null && ConversionUtility.StringToInteger(detail.isFreeProduct)!=null && ConversionUtility.StringToInteger(detail.isFreeProduct)== 0) {
                    lineitem.ivydsd__Line_Item_Type__c = 'Normal';
                } else if(detail.isFreeProduct != null && ConversionUtility.StringToInteger(detail.isFreeProduct)!=null && ConversionUtility.StringToInteger(detail.isFreeProduct) == 1) {
                    lineitem.ivydsd__Line_Item_Type__c = 'Free of Cost';
                }
                system.debug('lineitem.ivydsd__Line_Item_Type__c'+lineitem.ivydsd__Line_Item_Type__c);
                lineitem.ivydsd__Batch_Id__c = String.isNotBlank(detail.BatchId) == TRUE ? detail.BatchId : '';
                if(detail.ProductId != null && prodInternalIdWithSFIdMap != null && prodInternalIdWithSFIdMap.containsKey(detail.ProductId)) {
                    
                    lineitem.ivydsd__Product1__c = prodInternalIdWithSFIdMap.get(detail.ProductId).Id;
                    
                    if(OrderIdwithSetOfProductIdMap.containsKey(orderNumberAndOrderMap.get(detail.OrderId))) {
                        OrderIdwithSetOfProductIdMap.get(orderNumberAndOrderMap.get(detail.OrderId)).add(prodInternalIdWithSFIdMap.get(detail.ProductId));
                    } else {
                        List<ivybase__Product__c> ProductList = new List<ivybase__Product__c>();
                        ProductList.add(prodInternalIdWithSFIdMap.get(detail.ProductId));
                        OrderIdwithSetOfProductIdMap.put(orderNumberAndOrderMap.get(detail.OrderId),ProductList);
                    }
                    
                    system.debug('***** '+detail.ProductId+'-QTY'+detail.pieceQty);
                    System.debug('internalIdAndSMasterMap===>'+internalIdAndSMasterMap);
                    System.debug('detail.PcsUomId===>'+detail.PcsUomId);
                    System.debug('detail.uomid===>'+detail.uomid);
                    System.debug('detail.douomid===>'+detail.douomid);
                    String listcodePcs = internalIdAndSMasterMap.containsKey(detail.PcsUomId) ? internalIdAndSMasterMap.get(detail.PcsUomId).ivybase__List_Code__c:'';
                    String listcodeCase = internalIdAndSMasterMap.containsKey(detail.uomid) ? internalIdAndSMasterMap.get(detail.uomid).ivybase__List_Code__c:'';
                    String listcodeOuter = internalIdAndSMasterMap.containsKey(detail.douomid) ? internalIdAndSMasterMap.get(detail.douomid).ivybase__List_Code__c:'';
                    system.debug('listcodePcs'+listcodePcs);
                    if(productIdAndProductUOMListMap.containsKey(lineitem.ivydsd__Product1__c)){
                        
                        for(ivybase__Product_UOM__c puom : productIdAndProductUOMListMap.get(lineitem.ivydsd__Product1__c)) {
                            
                            System.debug('puom.ivybase__UOM__c====>'+puom.ivybase__UOM__c);
                            System.debug('listcodePcs====>'+listcodePcs);
                            if( listcodePcs == puom.ivybase__UOM__c){
                                system.debug('**Match Piece');
                                lineitem.ivydsd__UOM_1_Name__c=listcodePcs;
                                system.debug('puom.ivybase__UOM_Number__c'+puom.ivybase__UOM_Number__c);
                                if( puom.ivybase__UOM_Number__c == 'UOM 1' ) {
                                    system.debug('***** detail.pieceQty'+detail.pieceQty);
                                    lineitem.ivydsd__UOM_1_Quantity__c = (String.isEmpty(detail.pieceQty) == false ? ConversionUtility.StringToInteger(detail.pieceQty):0);
                                    system.debug('***** '+detail.ProductId+'-QTY'+lineitem.ivydsd__UOM_1_Quantity__c);
                                    if(lineitem.ivydsd__Line_Item_Type__c != 'Free of Cost'){
                                        lineitem.ivydsd__UOM_1_Rate__c = (String.isEmpty(detail.Rate) == false ? ConversionUtility.StringToDecimal(detail.Rate):0);
                                    }
                                }/*else if( puom.ivybase__UOM_Number__c == 'UOM 2' ) {
                                    lineitem.ivydsd__UOM_2_Quantity__c = (String.isEmpty(detail.pieceQty) == false ? ConversionUtility.StringToInteger(detail.pieceQty):0);
                                    lineitem.ivydsd__UOM_2_Rate__c = (String.isEmpty(detail.Rate) == false ? ConversionUtility.StringToDecimal(detail.Rate):0);
                                }else if( puom.ivybase__UOM_Number__c == 'UOM 3' ) {
                                    lineitem.ivydsd__UOM_3_Quantity__c = (String.isEmpty(detail.pieceQty) == false ? ConversionUtility.StringToInteger(detail.pieceQty):0);
                                    lineitem.ivydsd__UOM_3_Rate__c = (String.isEmpty(detail.Rate) == false ? ConversionUtility.StringToDecimal(detail.Rate):0);
                                }*/
                            } else if( listcodeCase == puom.ivybase__UOM__c){
                                system.debug('**Match Case');
                                lineitem.ivydsd__UOM_2_Name__c=listcodeCase;
                                if( puom.ivybase__UOM_Number__c == 'UOM 1' ) {
                                    lineitem.ivydsd__UOM_1_Quantity__c = (String.isEmpty(detail.caseqty) == false ? ConversionUtility.StringToInteger(detail.caseqty):0);
                                    lineitem.ivydsd__UOM_1_Rate__c = (String.isEmpty(detail.casePrice) == false ? ConversionUtility.StringToDecimal(detail.casePrice):0);
                                }/*else if( puom.ivybase__UOM_Number__c == 'UOM 2' ) {
                                    lineitem.ivydsd__UOM_2_Quantity__c = (String.isEmpty(detail.caseqty) == false ? ConversionUtility.StringToInteger(detail.caseqty):0); 
                                    lineitem.ivydsd__UOM_2_Rate__c = (String.isEmpty(detail.casePrice) == false ? ConversionUtility.StringToDecimal(detail.casePrice):0);                                  // lineitem.UOM_2_Rate__c = Decimal.valueOf(detail.casePrice);
                                }else if( puom.ivybase__UOM_Number__c == 'UOM 3' ) {
                                    lineitem.ivydsd__UOM_3_Quantity__c = (String.isEmpty(detail.caseqty) == false ? ConversionUtility.StringToInteger(detail.caseqty):0);
                                    lineitem.ivydsd__UOM_3_Rate__c = (String.isEmpty(detail.casePrice) == false? ConversionUtility.StringToDecimal(detail.casePrice):0);
                                }*/
                            } else if( listcodeOuter == puom.ivybase__UOM__c){
                                system.debug('**Match Outer');
                                lineitem.ivydsd__UOM_3_Name__c=listcodeOuter;
                                if( puom.ivybase__UOM_Number__c == 'UOM 1' ) {
                                    lineitem.ivydsd__UOM_1_Quantity__c = (String.isEmpty(detail.outerQty) == false ? ConversionUtility.StringToInteger(detail.outerQty):0);
                                    lineitem.ivydsd__UOM_1_Rate__c = (String.isEmpty(detail.outerPrice) == false ? ConversionUtility.StringToDecimal(detail.outerPrice) :0);
                                }/*else if( puom.ivybase__UOM_Number__c == 'UOM 2' ) {
                                    lineitem.ivydsd__UOM_2_Quantity__c = (String.isEmpty(detail.outerQty) == false ? ConversionUtility.StringToInteger(detail.outerQty):0);
                                    lineitem.ivydsd__UOM_2_Rate__c = (String.isEmpty(detail.outerPrice) == false ? ConversionUtility.StringToDecimal(detail.outerPrice) :0);
                                }else if( puom.ivybase__UOM_Number__c == 'UOM 3' ) {
                                    lineitem.ivydsd__UOM_3_Quantity__c = (String.isEmpty(detail.outerQty) == false ? ConversionUtility.StringToInteger(detail.outerQty):0);
                                    lineitem.ivydsd__UOM_3_Rate__c = (String.isEmpty(detail.outerPrice) == false ? ConversionUtility.StringToDecimal(detail.outerPrice) :0);
                                }*/
                            }
                        }
                    }                 
                }
                OLIOrderIdSet.add(lineitem.ivydsd__Order__c);
                lineItemList.add(lineitem);
            }
        }
        //----calling the method to update the qty.
        if(accountidprodqtyMap.size()>0 && accountidprodqtyMap!=null ){
            RetailerProductAllocation_update.Update_product_Allocation(accountidprodqtyMap);
        }
        if(lineItemList.size() > 0) {
            List<String> orderLineItemFields = new List<String> {'ivydsd__Order__c', 'ivydsd__Line_Item_Type__c', 'ivydsd__Product1__c', 'ivydsd__UOM_1_Quantity__c', 'ivydsd__UOM_1_Rate__c', 'ivydsd__UOM_2_Quantity__c', 'ivydsd__UOM_2_Rate__c', 'ivydsd__UOM_3_Quantity__c', 'ivydsd__UOM_3_Rate__c'};
            if (SecurityUtility.checkIsCreateable('ivydsd__Order_Line_Item__c',orderLineItemFields)) {
                insert lineItemList;
                UserwiseCountryValues__c ucv = UserwiseCountryValues__c.getValues(UserInfo.getUserId());
                CountryCodeMarketISO__mdt ccm = [SELECT Id, Order_Auto_Approval__c FROM CountryCodeMarketISO__mdt WHERE Country__c =:ucv.Market_ISO__c];
                if(ccm != null && ccm.Order_Auto_Approval__c == true) {
                    System.debug('++++Inside the Auto Approval condition++++');
                    List<ivydsd__Order__c> orderList = [SELECT Id, ivydsd__Order_Status__c, ivydsd__Order_Value__c
                                                        FROM ivydsd__Order__c WHERE Id IN :OLIOrderIdSet AND ivydsd__Order_Status__c = 'Ordered'];
                    System.debug('+++OrderList+++'+orderList);
                    for(ivydsd__Order__c ord : orderList) {
                        if(ord.ivydsd__Order_Status__c == 'Ordered' && ord.ivydsd__Order_Value__c > 0) {
                            ord.ivydsd__Order_Status__c = 'Approved';
                        }
                    }
                    update orderList;
                }
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
        }
    }
    public static void translateSchemeApplyDetails(List<LorealUploadclass.SchemeDetail> SchemeDetail,List<LorealUploadclass.SchemeFreeProductDetail> schemeFreeProductDetail)
    {
        Set<String> schemeIdSet = new Set<String>();
        Set<String> productIdSet = new Set<String>();
        Set<String> orderNameSet = new Set<String>();
        Set<Id> orderIdSet = new Set<Id>();
        Map<String,Map<String,ivydsd__Order_Line_Item__c>> orderIdAndItemInternalIdAndItemMap = new Map<String,Map<String,ivydsd__Order_Line_Item__c>>();
        List<ivydsd__Scheme_Apply_Detail__c > schemeApplyDetailList = new List<ivydsd__Scheme_Apply_Detail__c >();
        if(SchemeDetail!=null){
            for(LorealUploadclass.SchemeDetail  scheme :SchemeDetail){
                
                if(String.isEmpty(scheme.SchemeId) == false){
                    schemeIdSet.add(scheme.SchemeId);
                }
                if(String.isEmpty(scheme.ProductId) == false){
                    productIdSet.add(scheme.ProductId);
                }
                if(String.isEmpty(scheme.OrderId) == false){
                    orderNameSet.add(scheme.OrderId);
                }
            }
        }
        if(schemeFreeProductDetail!=null){
            for(LorealUploadclass.SchemeFreeProductDetail  schemeFreePro :schemeFreeProductDetail){
                if(String.isEmpty(schemeFreePro.SchemeId) == false){
                    schemeIdSet.add(schemeFreePro.SchemeId);
                }
                if(String.isEmpty(schemeFreePro.FreeProductID) == false){
                    productIdSet.add(schemeFreePro.FreeProductID);
                }
                if(String.isEmpty(schemeFreePro.OrderId) == false){
                    orderNameSet.add(schemeFreePro.OrderId);
                }
            }
        }
        Id buyProductRecTypeId;
        Id freeProductRecTypeId;
        for(RecordType recType: RecordTypeService.getObjectBasedRecordTypesCustomOne('ivydsd__Scheme_Apply_Detail__c')){
            
            if(recType.DeveloperName == 'Buy_Product'){
                buyProductRecTypeId = recType.Id;
            }
            if(recType.DeveloperName == 'Free_Product'){
                freeProductRecTypeId = recType.Id;
            }
        }
        
        Map<String,ivydsd__Order__c> orderNameAndObjectMap = OrderService.getOrders(orderNameSet);
        
        system.debug('orderNameAndObjectMap'+orderNameAndObjectMap);
        
        for(String str : orderNameAndObjectMap.keyset()){
            orderIdSet.add(orderNameAndObjectMap.get(str).Id);
        }
        
        List<ivydsd__Scheme_Apply_Detail__c> deleteSchemeRecords = [select id,name from ivydsd__Scheme_Apply_Detail__c  where ivydsd__Order__c=:orderIdSet];
        if(deleteSchemeRecords.size()>0)
        {
            delete deleteSchemeRecords;
        }
        for( ivydsd__Order_Line_Item__c orderitem : OrderLineItemService.getOrderLineItemUsingOrderIdSet(orderIdSet)){
            if(orderitem.ivydsd__Product1__c != null){
                if(orderIdAndItemInternalIdAndItemMap.containsKey(String.valueOf(orderitem.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c)))
                {
                    if(!orderIdAndItemInternalIdAndItemMap.get(String.valueOf(orderitem.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c)).containskey(String.valueOf(orderitem.ivydsd__Product1__r.ivybase__InternalId__c)))
                    {
                        orderIdAndItemInternalIdAndItemMap.get(String.valueOf(orderitem.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c)).put(String.valueOf(orderitem.ivydsd__Product1__r.ivybase__InternalId__c),orderitem);   
                    }
                    
                }
                else
                {
                    Map<String,ivydsd__Order_Line_Item__c> item = new Map<String,ivydsd__Order_Line_Item__c>();
                    item.put(String.valueOf(orderitem.ivydsd__Product1__r.ivybase__InternalId__c),orderitem);
                    orderIdAndItemInternalIdAndItemMap.put(String.valueOf(orderitem.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c),item) ;
                }
            }
        }
        
        Map<String,ivydsd__Scheme_Slab__c> schemeSlabInternalIdAndObjectMap = SchemeService.getSchemeSlabMapUsingInternalIds(schemeIdSet);
        if(SchemeDetail!=null){
            for(LorealUploadclass.SchemeDetail  scheme :SchemeDetail){
                
                if(schemeSlabInternalIdAndObjectMap.containsKey(scheme.SchemeId)) {
                    
                    System.debug('scheme.SchemeDetailNew===>'+scheme.SchemeDetailNew);
                    ivydsd__Scheme_Apply_Detail__c  schemeApply = new ivydsd__Scheme_Apply_Detail__c();
                    schemeApply.ivydsd__Scheme__c = schemeSlabInternalIdAndObjectMap.get(scheme.SchemeId).Id;
                    schemeApply.Amount__c = String.isNotBlank(scheme.Amount) == true ? Decimal.valueOf(scheme.Amount) : 0.0;
                    schemeApply.Value__c = String.isNotBlank(scheme.Value) == true ? Integer.valueOf(scheme.Value) : 0;
                    schemeApply.Scheme_Description__c = String.isNotBlank(scheme.SchemeDetailNew) == true ? scheme.SchemeDetailNew : '';
                    schemeApply.No_Of_Promotions_Applied__c = String.isNotBlank(scheme.noOfPromo) ? Integer.valueOf(scheme.noOfPromo) : 0;
                    if(buyProductRecTypeId != null){
                        schemeApply.RecordTypeId = buyProductRecTypeId;
                    }
                    System.debug('orderNameAndObjectMap.containsKey(scheme.OrderId)'+orderNameAndObjectMap.containsKey(scheme.OrderId));
                    if(orderNameAndObjectMap.containsKey(scheme.OrderId))
                    {
                        schemeApply.ivydsd__Order__c=orderNameAndObjectMap.get(scheme.OrderId).id;
                    }
                    if(orderNameAndObjectMap.containsKey(scheme.OrderId) && String.isEmpty(scheme.ProductId) == false){
                        
                        
                        system.debug('comboString'+orderIdAndItemInternalIdAndItemMap);
                        system.debug('contains'+orderIdAndItemInternalIdAndItemMap.containsKey(String.valueOf(scheme.OrderId)));
                        if(orderIdAndItemInternalIdAndItemMap.containsKey(String.valueOf(scheme.OrderId))) {
                            system.debug('came inside'+String.valueOf(Scheme.ProductId));
                            system.debug('contains'+orderIdAndItemInternalIdAndItemMap.get(String.valueOf(scheme.OrderId)).containsKey(String.valueOf(Scheme.ProductId)));
                            if(orderIdAndItemInternalIdAndItemMap.get(String.valueOf(scheme.OrderId)).containsKey(String.valueOf(Scheme.ProductId)))
                            {
                                schemeApply.ivydsd__Order_Line_Item__c = orderIdAndItemInternalIdAndItemMap.get(String.valueOf(scheme.OrderId)).get(String.valueOf(Scheme.ProductId)).id;
                            }
                            
                            
                        }
                    }
                    schemeApplyDetailList.add(schemeApply);
                }
            }
        }
        if(schemeFreeProductDetail!=null){
            for(LorealUploadclass.SchemeFreeProductDetail  schemeFreePro :schemeFreeProductDetail){
                
                if(schemeSlabInternalIdAndObjectMap.containsKey(schemeFreePro.SchemeId)) {
                    
                    ivydsd__Scheme_Apply_Detail__c  schemeApply = new ivydsd__Scheme_Apply_Detail__c();
                    schemeApply.ivydsd__Scheme__c = schemeSlabInternalIdAndObjectMap.get(schemeFreePro.SchemeId).Id;
                    schemeApply.Value__c = String.isNotBlank(schemeFreePro.FreeQty) == true ? Integer.valueOf(schemeFreePro.FreeQty) : 0;
                    schemeApply.Amount__c = String.isNotBlank(schemeFreePro.Price) == true ? Decimal.valueOf(schemeFreePro.Price) : 0;
                    schemeApply.Scheme_Description__c = String.isNotBlank(schemeFreePro.TaxAmount) == true ? schemeFreePro.TaxAmount : '';
                    if(freeProductRecTypeId != null){
                        schemeApply.RecordTypeId = freeProductRecTypeId;
                    }
                    if(orderNameAndObjectMap.containsKey(schemeFreePro.OrderId) ){
                        schemeApply.ivydsd__Order__c = orderNameAndObjectMap.get(schemeFreePro.OrderId).Id;
                    }
                    if(orderNameAndObjectMap.containsKey(schemeFreePro.OrderId) && String.isEmpty(schemeFreePro.FreeProductID) == false){
                        
                        system.debug('comboString'+orderIdAndItemInternalIdAndItemMap);
                        system.debug('contains'+orderIdAndItemInternalIdAndItemMap.containsKey(String.valueOf(schemeFreePro.OrderId)));
                        if(orderIdAndItemInternalIdAndItemMap.containsKey(String.valueOf(schemeFreePro.OrderId))) {
                            system.debug('came inside'+String.valueOf(schemeFreePro.FreeProductID));
                            system.debug('contains'+orderIdAndItemInternalIdAndItemMap.get(String.valueOf(schemeFreePro.OrderId)).containsKey(String.valueOf(schemeFreePro.FreeProductID)));
                            if(orderIdAndItemInternalIdAndItemMap.get(String.valueOf(schemeFreePro.OrderId)).containsKey(String.valueOf(schemeFreePro.FreeProductID)))
                            {
                                schemeApply.ivydsd__Order_Line_Item__c = orderIdAndItemInternalIdAndItemMap.get(String.valueOf(schemeFreePro.OrderId)).get(String.valueOf(schemeFreePro.FreeProductID)).id;
                            }
                        }
                    }
                    system.debug('schemeApply'+schemeApply);
                    schemeApplyDetailList.add(schemeApply);
                }
            }
        }
        if(schemeApplyDetailList.size() > 0) {
            List<String> schemeapplydetailfields = new List<String> {'ivydsd__Scheme__c', 'RecordTypeId', 'ivydsd__Order_Line_Item__c'};
            if (SecurityUtility.checkIsCreateable('ivydsd__Scheme_Apply_Detail__c',schemeapplydetailfields)){
                insert schemeApplyDetailList;
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
        }
    }
}