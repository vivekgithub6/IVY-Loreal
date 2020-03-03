public class OrderLineitemTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToorderlineitem(List<ivydsd__Order_Line_Item__c> OrderitemList,string errorcode){
        RExAPIResponseDomain.ResponseInfo OrderDetailResponse = new RExAPIResponseDomain.ResponseInfo();
        OrderDetailResponse.Master='OrderDetail';
        OrderDetailResponse.Field = new List<String>{'OrderID','ProductId','Qty','Rate','uomcount','pieceQty','caseqty',
            'uomid','totalamount','d1','d2','d3','DA','outerQty','douomQty','douomid',
            'OrderType','casePrice','outerPrice','PcsUomId','isFreeProduct','BatchId'};
                OrderDetailResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        OrderDetailResponse.Next = '0';
        Map<String,String> internalIdAndSMasterMap = new Map<String,string>();
         for(ivybase__Standard_List_Master__c stdMaster:  StandardListMasterService.getAllStandard_List()){
            internalIdAndSMasterMap.put(stdMaster.ivybase__List_Name__c,stdMaster.Name);
        }
        List<List<String>> OrderDetailRecords = new List<List<String>>();
        Set<String> productIdSet = new Set<String>();
         if(OrderitemList !=Null){
            for(ivydsd__Order_Line_Item__c OrderLineItemList :OrderitemList ){
               
                List<String> orderitemInfo = new List<String>();
                
                //OrderID
                if(OrderLineItemList.ivydsd__Order__c != null){
                     orderitemInfo.add(String.isblank(OrderLineItemList.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c) ? OrderLineItemList.ivydsd__Order__r.ivydsd__Internal_Id__c : OrderLineItemList.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c);
                    
                 }else{
                    orderitemInfo.add(''); 
                 }
                //ProductId 
                if(OrderLineItemList.ivydsd__Product1__c != null){
                     orderitemInfo.add(String.valueOf((OrderLineItemList.ivydsd__Product1__r.ivybase__InternalId__c)));
                 }else{
                    orderitemInfo.add(''); 
                 }
                //Qty  
                if(OrderLineItemList.ivydsd__UOM_1_Quantity__c != null){
                     orderitemInfo.add(String.valueOf((OrderLineItemList.ivydsd__UOM_1_Quantity__c)));
                 }else{
                    orderitemInfo.add(''); 
                 }
                //Rate  
                if(OrderLineItemList.ivydsd__UOM_1_Rate__c != null){
                     orderitemInfo.add(String.valueOf((OrderLineItemList.ivydsd__UOM_1_Rate__c)));
                 }else{
                    orderitemInfo.add(''); 
                 }
                orderitemInfo.add('');//uomcount 
                //pieceQty   
                if(OrderLineItemList.ivydsd__UOM_1_Quantity__c != null){
                     orderitemInfo.add(String.valueOf((OrderLineItemList.ivydsd__UOM_1_Quantity__c)));
                 }else{
                    orderitemInfo.add(''); 
                 }
                orderitemInfo.add('');//caseqty 
                orderitemInfo.add('');//uomid
                //totalamount    
                if(OrderLineItemList.ivydsd__Total_Amount__c != null){
                     orderitemInfo.add(String.valueOf((OrderLineItemList.ivydsd__Total_Amount__c)));
                 }else{
                    orderitemInfo.add(''); 
                 }
                orderitemInfo.add('');//d1 
                orderitemInfo.add('');//d2 
                orderitemInfo.add('');//d3 
                orderitemInfo.add('');//DA 
                orderitemInfo.add('');//outerQty 
                orderitemInfo.add('');//douomQty 
                orderitemInfo.add('');//douomid 
                //OrderType     
                if(OrderLineItemList.ivydsd__Order__r.ivydsd__Order_Type__c != null){
                     orderitemInfo.add(OrderLineItemList.ivydsd__Order__r.ivydsd__Order_Type__c);
                 }else{
                    orderitemInfo.add(''); 
                 }
                 orderitemInfo.add('');//casePrice 
                 orderitemInfo.add('');//casePrice 
                //PcsUomId    internalIdAndSMasterMap 
                system.debug('Piece '+OrderLineItemList.ivydsd__UOM_1_Name__c);
                system.debug('map'+internalIdAndSMasterMap);
                if(OrderLineItemList.ivydsd__UOM_1_Name__c != null && internalIdAndSMasterMap.containskey(OrderLineItemList.ivydsd__UOM_1_Name__c)){
                     orderitemInfo.add(internalIdAndSMasterMap.get(OrderLineItemList.ivydsd__UOM_1_Name__c));
                 }else{
                    orderitemInfo.add(''); 
                 }
                //isFreeProduct       
                if(OrderLineItemList.ivydsd__Line_Item_Type__c != null){
                    if(OrderLineItemList.ivydsd__Line_Item_Type__c =='Normal'){
                        orderitemInfo.add('0');
                    }else if(OrderLineItemList.ivydsd__Line_Item_Type__c =='Free of Cost'){
                        orderitemInfo.add('1');
                    }
                     
                 }else{
                    orderitemInfo.add(''); 
                 }
                orderitemInfo.add('');//BatchId 
                OrderDetailRecords.add(orderitemInfo);
            }
         
         }
        OrderDetailResponse.Data=OrderDetailRecords;
        return OrderDetailResponse;
    }
    //Method used to generate the response for the Scheme Apply details
    public static RExAPIResponseDomain.ResponseInfo objectToSchemeApplyDetail(List<ivydsd__Scheme_Apply_Detail__c> schemeApplyDetail,String errorCode)
    {
        RExAPIResponseDomain.ResponseInfo schemeApplyResponse = new RExAPIResponseDomain.ResponseInfo();
        schemeApplyResponse.Master='SchemeDetail';
        schemeApplyResponse.Field = new List<String>{'OrderID','InvoiceID','SchemeID','ProductID','SchemeType','Value','parentid','SchemeDetail','RetailerId','distributorid','Amount','noOfPromo'};
        schemeApplyResponse.Next = '0';
        schemeApplyResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivydsd__Scheme_Apply_Detail__c.getRecordTypeInfosByDeveloperName();
        Id buyProductRecordTypeId = RT.get('Buy_Product').getRecordTypeId();
        List<List<String>> schemeDetailRecords = new List<List<String>>();
        for(ivydsd__Scheme_Apply_Detail__c scheme:schemeApplyDetail)
        {
            if(scheme.RecordTypeId==buyProductRecordTypeId)
            {
                List<String> schemeInfo = new List<String>();
                //OrderID
                if(scheme.ivydsd__Order__c!=null && scheme.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c != null || scheme.ivydsd__Order__r.ivydsd__Internal_Id__c != null){
                     schemeInfo.add(String.isblank(scheme.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c) ? scheme.ivydsd__Order__r.ivydsd__Internal_Id__c : scheme.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c);
                 }else{
                    schemeInfo.add(''); 
                 }
                //InvoiceID
                schemeInfo.add(''); 
                //SchemeID (slabID)
                if(scheme.ivydsd__Scheme__c!=null && scheme.ivydsd__Scheme__r.ivydsd__Internal_Id__c != null){
                     schemeInfo.add(scheme.ivydsd__Scheme__r.ivydsd__Internal_Id__c);
                 }else{
                    schemeInfo.add(''); 
                 }
                //ProductID
                System.debug('scheme.ivydsd__Order_Line_Item__c===>'+scheme.ivydsd__Order_Line_Item__c);
                System.debug('scheme.ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c===>'+scheme.ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c);
                if(scheme.ivydsd__Order_Line_Item__c!=null && scheme.ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c!=null)
                {
                    schemeInfo.add(string.valueOf(scheme.ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c)); 
                }else
                {
                    schemeInfo.add(''); 
                }
                //SchemeType
                schemeInfo.add(''); 
                //Value
                schemeInfo.add(scheme.Value__c != null ? String.valueOf(scheme.Value__c) : '0');
                //parentid
                if(scheme.ivydsd__Scheme__c!=null && scheme.ivydsd__Scheme__r.ivydsd__Scheme__r.ivydsd__Internal_Id__c!=null)
                {
                    schemeInfo.add(scheme.ivydsd__Scheme__r.ivydsd__Scheme__r.ivydsd__Internal_Id__c); 
                }else
                {
                    schemeInfo.add(''); 
                }
                //SchemeDetail
                schemeInfo.add(String.isNotBlank(scheme.Scheme_Description__c) == true ? scheme.Scheme_Description__c : ''); 
                //RetailerId
                if(scheme.ivydsd__Order__c!=null && scheme.ivydsd__Order__r.ivydsd__Store__r.ivybase__Internal_Id__c!=null)
                {
                   schemeInfo.add(string.valueOf(scheme.ivydsd__Order__r.ivydsd__Store__r.ivybase__Internal_Id__c));    
                }
                else
                {
                  schemeInfo.add('');   
                }
                //distributorid
                schemeInfo.add(''); 
                //Amount
                schemeInfo.add(scheme.Amount__c != null ? String.valueOf(scheme.Amount__c) : '0');
                //noOfPromo
                schemeInfo.add(scheme.No_of_Promotions_Applied__c != null ? String.valueOf(scheme.No_of_Promotions_Applied__c) : '0');
                schemeDetailRecords.add(schemeInfo);
                
            }
            
        }
        schemeApplyResponse.Data=schemeDetailRecords;
        return schemeApplyResponse;
    }
    //Method used to generate the response for the Scheme Free Product detail
    public static RExAPIResponseDomain.ResponseInfo objectToSchemeFreeProductDetail(List<ivydsd__Scheme_Apply_Detail__c> schemeApplyDetail,String errorCode)
    {
        RExAPIResponseDomain.ResponseInfo schemeApplyResponse = new RExAPIResponseDomain.ResponseInfo();
        schemeApplyResponse.Master='SchemeFreeProductDetail';
        schemeApplyResponse.Field = new List<String>{'OrderID','InvoiceID','SchemeID','FreeProductID','FreeQty','UomID','UomCount','BatchId','parentid','RetailerId','Price','TaxAmount'};
            schemeApplyResponse.Next = '0';
        schemeApplyResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivydsd__Scheme_Apply_Detail__c.getRecordTypeInfosByDeveloperName();
        Id buyProductRecordTypeId = RT.get('Free_Product').getRecordTypeId();
        List<List<String>> schemeDetailRecords = new List<List<String>>();
        for(ivydsd__Scheme_Apply_Detail__c scheme:schemeApplyDetail)
        {
            if(scheme.RecordTypeId==buyProductRecordTypeId)
            {
                List<String> schemeInfo = new List<String>();
                //OrderID
                if(scheme.ivydsd__Order__c!=null && scheme.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c != null || scheme.ivydsd__Order__r.ivydsd__Internal_Id__c != null){
                     schemeInfo.add(String.isblank(scheme.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c) ? scheme.ivydsd__Order__r.ivydsd__Internal_Id__c : scheme.ivydsd__Order__r.ivydsd__Mobile_Order_Number__c);
                 }else{
                    schemeInfo.add(''); 
                 }
                //InvoiceID
                schemeInfo.add(''); 
                //SchemeID (slabID)
                if(scheme.ivydsd__Scheme__c!=null && scheme.ivydsd__Scheme__r.ivydsd__Internal_Id__c != null){
                     schemeInfo.add(scheme.ivydsd__Scheme__r.ivydsd__Internal_Id__c);
                 }else{
                    schemeInfo.add(''); 
                 }
                //FreeProductID
                if(scheme.ivydsd__Order_Line_Item__c!=null && scheme.ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c!=null)
                {
                    schemeInfo.add(string.valueOf(scheme.ivydsd__Order_Line_Item__r.ivydsd__Product1__r.ivybase__InternalId__c)); 
                }else
                {
                    schemeInfo.add(''); 
                }
                //FreeQty
                schemeInfo.add(scheme.Value__c != null ? String.valueOf(scheme.Value__c) : '0'); 
                //UomID
                schemeInfo.add(''); 
                //UomCount
                schemeInfo.add(''); 
                //BatchId
                schemeInfo.add(''); 
                //parentid
                if(scheme.ivydsd__Scheme__c!=null && scheme.ivydsd__Scheme__r.ivydsd__Scheme__r.ivydsd__Internal_Id__c!=null)
                {
                    schemeInfo.add(scheme.ivydsd__Scheme__r.ivydsd__Scheme__r.ivydsd__Internal_Id__c); 
                }else
                {
                    schemeInfo.add(''); 
                }
                //RetailerId
                if(scheme.ivydsd__Order__c!=null && scheme.ivydsd__Order__r.ivydsd__Store__r.ivybase__Internal_Id__c!=null)
                {
                   schemeInfo.add(string.valueOf(scheme.ivydsd__Order__r.ivydsd__Store__r.ivybase__Internal_Id__c));    
                }
                else
                {
                  schemeInfo.add('');   
                }
                //Price
                schemeInfo.add(scheme.Amount__c != null ? String.valueOf(scheme.Amount__c) : '0'); 
                //TaxAmount
                schemeInfo.add(String.isNotBlank(scheme.Scheme_Description__c) ? scheme.Scheme_Description__c : '0'); 
                
                schemeDetailRecords.add(schemeInfo);
                
            }
            
        }
        schemeApplyResponse.Data=schemeDetailRecords;
        return schemeApplyResponse;
    }
}