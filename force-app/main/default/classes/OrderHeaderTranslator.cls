/**
 * Created By : Ivy Mobility
 * Purpose : This class is used to generate the JSON value for the /v1/Order/Master API
 * Referred In : RESTOrderDetails
 * Test Class : TestRestOrderDetails
*/
public class OrderHeaderTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToorder(List<ivydsd__Order__c> OrderDeatilList,string errorcode){
    RExAPIResponseDomain.ResponseInfo OrderHeaderResponse = new RExAPIResponseDomain.ResponseInfo();
    OrderHeaderResponse.Master='OrderHeader';
    OrderHeaderResponse.Field = new List<String>{'OrderID', 'OrderDate', 'RetailerId', 'RouteId', 'OrderValue', 'LinesPerCall', 'discount',
                                    'deliveryDate', 'downloadDate', 'po', 'remark', 'latitude', 'longitude', 'timestampid', 'JFlag', 'ReturnValue',
                                    'sid', 'stype', 'totalTaxValue', 'ImageName', 'totalWeight', 'BIllTo', 'ShipTo', 'PayerCode', 'Tax',
                                    'HandlingCharges', 'Notes', 'SignatureImagePath', 'Status', 'SFPONumber'};
    OrderHeaderResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    OrderHeaderResponse.Next = '0';
        
        List<List<String>> OrderHeaderRecords = new List<List<String>>();
        if(OrderDeatilList !=Null){
            for(ivydsd__Order__c OrderHeaderRecordList :OrderDeatilList ){
                List<String> orderHedInfo = new List<String>();
                //OrderID
                if(OrderHeaderRecordList.ivydsd__Mobile_Order_Number__c != null || OrderHeaderRecordList.ivydsd__Internal_Id__c != null){
                     orderHedInfo.add(String.isblank(OrderHeaderRecordList.ivydsd__Mobile_Order_Number__c) ? OrderHeaderRecordList.ivydsd__Internal_Id__c : OrderHeaderRecordList.ivydsd__Mobile_Order_Number__c);
                 }else{
                    orderHedInfo.add(''); 
                 }
                //OrderDate
                if(OrderHeaderRecordList.ivydsd__Order_Date__c != null){
                    integer d=OrderHeaderRecordList.ivydsd__Order_Date__c.day();
                     integer mo=OrderHeaderRecordList.ivydsd__Order_Date__c.month();
                     integer yr=OrderHeaderRecordList.ivydsd__Order_Date__c.year();
                     DateTime DT = DateTime.newInstance(yr, mo, d);
                     orderHedInfo.add(DT.format('yyyy/MM/dd'));
                 }else{
                    orderHedInfo.add(''); 
                 }
                //RetailerId
                if(OrderHeaderRecordList.ivydsd__Store__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.ivydsd__Store__r.ivybase__Internal_Id__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                orderHedInfo.add('');//RouteId
                //OrderValue
                if(OrderHeaderRecordList.ivydsd__Order_Value__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.ivydsd__Order_Value__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                //LinesPerCall
                if(OrderHeaderRecordList.ivydsd__Number_of_Line_Items__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.ivydsd__Number_of_Line_Items__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                orderHedInfo.add('');//discount
                
                //DeliveryDate
                if(OrderHeaderRecordList.ivydsd__Delivery_Date__c != null){
                    integer d=OrderHeaderRecordList.ivydsd__Delivery_Date__c.day();
                     integer mo=OrderHeaderRecordList.ivydsd__Delivery_Date__c.month();
                     integer yr=OrderHeaderRecordList.ivydsd__Delivery_Date__c.year();
                     DateTime DT = DateTime.newInstance(yr, mo, d);
                     orderHedInfo.add(DT.format('yyyy/MM/dd'));
                 }else{
                    orderHedInfo.add(''); 
                 }
                 orderHedInfo.add('');//downloadDate
                //po
                if(String.isNotBlank(OrderHeaderRecordList.Customer_PO__c) == true) {
                     orderHedInfo.add(OrderHeaderRecordList.Customer_PO__c);
                 } else {
                     orderHedInfo.add('');
                 }
                //remark
                if(OrderHeaderRecordList.ivydsd__Remarks__c != null){
                     orderHedInfo.add(OrderHeaderRecordList.ivydsd__Remarks__c);
                 }else{
                    orderHedInfo.add(''); 
                 }
                //latitude
                if(OrderHeaderRecordList.ivydsd__Geolocation__latitude__s != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.ivydsd__Geolocation__latitude__s)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                //longitude
                if(OrderHeaderRecordList.ivydsd__Geolocation__longitude__s != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.ivydsd__Geolocation__longitude__s)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                orderHedInfo.add('');//timestampid
                orderHedInfo.add('');//JFlag
                orderHedInfo.add('');//ReturnValue
                orderHedInfo.add('');//sid
                orderHedInfo.add('');//stype
                
                //totalTaxValue
                if(OrderHeaderRecordList.Total_Tax_Value__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.Total_Tax_Value__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                orderHedInfo.add('');//ImageName
                orderHedInfo.add('');//totalWeight
                //BIllTo
                if(OrderHeaderRecordList.Bill_To__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.Bill_To__r.ivybase__Internal_Id__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                
                //ShipTo
                if(OrderHeaderRecordList.Ship_To__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.Ship_To__r.ivybase__Internal_Id__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                //PayerCode
                if(OrderHeaderRecordList.Payer_Code__c != null){
                     orderHedInfo.add(OrderHeaderRecordList.Payer_Code__c);
                 }else{
                    orderHedInfo.add(''); 
                 }
                //Tax
                if(OrderHeaderRecordList.Tax_Details__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.Tax_Details__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                //HandlingCharges
                if(OrderHeaderRecordList.Handling_Charges__c != null){
                     orderHedInfo.add(String.valueOf((OrderHeaderRecordList.Handling_Charges__c)));
                 }else{
                    orderHedInfo.add(''); 
                 }
                //Notes
                if(OrderHeaderRecordList.Order_Notes__c != null){
                     orderHedInfo.add(OrderHeaderRecordList.Order_Notes__c);
                 }else{
                    orderHedInfo.add(''); 
                 }
                //SignatureImagePath
                if(OrderHeaderRecordList.Signature_Image_Path__c != null){
                     orderHedInfo.add(OrderHeaderRecordList.Signature_Image_Path__c);
                 }else{
                    orderHedInfo.add(''); 
                 }
                //Status
                if(OrderHeaderRecordList.ivydsd__Order_Status__c != null){
                     orderHedInfo.add(OrderHeaderRecordList.ivydsd__Order_Status__c);
                 }else{
                    orderHedInfo.add(''); 
                 }
                 orderHedInfo.add(OrderHeaderRecordList.Name);//SFPONumber
                OrderHeaderRecords.add(orderHedInfo); 
            }
        }
        OrderHeaderResponse.Data=OrderHeaderRecords;
        return OrderHeaderResponse;
    }
}