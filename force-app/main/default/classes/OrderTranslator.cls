/**
* Created By : Ivy Mobility
* Purpose : To generate the JSON for the P4OrderHistory API
* Referred In : OrderManager class
* Test Class : TESTRESTOrderManager
*/
public class OrderTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToOrderInfo(map<id,list<ivydsd__Order__c>> accidOrderMap,String errorcode){
        
        RExAPIResponseDomain.ResponseInfo ordrdetlist = new RExAPIResponseDomain.ResponseInfo();
        
        ordrdetlist.Master = 'P4OrderHistoryMaster';
        ordrdetlist.Next ='0';
        ordrdetlist.ErrorCode = errorCode == null ? '0' : errorCode;
        UserwiseCountryValues__c uwcv = UserwiseCountryValues__c.getInstance(UserInfo.getUserId());
        if(uwcv != null && (uwcv.Market_ISO__c == 'SG' || uwcv.Market_ISO__c == 'MY')) {
            ordrdetlist.Field = new List<String>{'retailerid', 'retailerCode', 'orderId', 'orderdate', 'ordervalue', 'lpc', 'Flag', 'PaidAmount',
                'Delivery', 'Status', 'reasonid', 'refid', 'volume', 'InvoiceNo', 'InvoiceDate', 'InvoiceValue', 'PurchasePointId',
                'SFPONumber', 'PONumber'};
                    } else {
                        ordrdetlist.Field = new List<String>{'retailerid', 'retailerCode', 'orderId', 'orderdate', 'ordervalue', 'lpc', 'Flag', 'PaidAmount',
                            'Delivery', 'Status', 'reasonid', 'refid', 'volume', 'InvoiceNo', 'InvoiceDate', 'InvoiceValue', 'PurchasePointId'};
                                }
        List<List<String>> ordRec = new List<List<String>>();
        
        if(accidOrderMap != null && errorcode == null){
            for(id accid:accidOrderMap.keyset()){
                if(accidOrderMap.get(accid)!=null){
                    for(ivydsd__Order__c ord : accidOrderMap.get(accid)){
                        
                        List<String> tempdet = new List<String>();
                        
                        if(ord.ivydsd__Store__c != null){
                            tempdet.add(String.Valueof(ord.ivydsd__Store__r.ivybase__Internal_Id__c));
                        }else{
                            tempdet.add('');
                        }//retailerId
                        if(accidOrderMap.containskey(ord.ivydsd__Store__c) && ord.ivydsd__Store__r.ivybase__StoreCode__c!=null){
                            tempdet.add(String.Valueof(ord.ivydsd__Store__r.ivybase__StoreCode__c));
                        }else{
                            tempdet.add('');
                        }//retailer code
                        tempdet.add(ord.ivydsd__Purchase_Order_Number__c != null ? ord.ivydsd__Purchase_Order_Number__c : '');//orderId
                        
                        // tempdet.add(String.Valueof(ord.Order_Date__c));
                        tempdet.add(ord.ivydsd__Order_Date__c != null ? (ord.ivydsd__Order_Date__c.year()+'/'+CommonUtility.convertTwodigit(ord.ivydsd__Order_Date__c.Month())+'/'+CommonUtility.convertTwodigit(ord.ivydsd__Order_Date__c.Day())) : '');//orderdate
                        
                        if(ord.ivydsd__Order_Value__c != null){
                            tempdet.add(String.Valueof(ord.ivydsd__Order_Value__c));
                        }else{
                            tempdet.add('');
                        }//ordervalue
                        
                        if(ord.ivydsd__Number_of_Line_Items__c != null){
                            tempdet.add(String.Valueof(ord.ivydsd__Number_of_Line_Items__c));
                        }else{
                            tempdet.add('');
                        }//lpc
                        tempdet.add('');//Flag
                        tempdet.add('');//paid amount
                        tempdet.add('');//Delivery
                        if(ord.ivydsd__Order_Status__c == 'Ordered') {
                            tempdet.add('Submitted');
                        } else if(ord.ivydsd__Order_Status__c == 'Invoiced') {
                            tempdet.add('SAP Invoice');
                        } else if(ord.ivydsd__Order_Status__c == 'Sent to SAP') {
                            tempdet.add('SAP Order');
                        } else if(ord.ivydsd__Order_Status__c != null) {
                            tempdet.add(ord.ivydsd__Order_Status__c);
                        } else {
                            tempdet.add('');
                        }//Status
                        tempdet.add('');//reason id
                        tempdet.add(ord.ivydsd__Internal_Id__c);//refid
                        tempdet.add('');//Volume
                        tempdet.add('');//InvoiceNo
                        tempdet.add('');//InvoiceDate
                        tempdet.add('');//InvoiceValue
                        tempdet.add('');//PurchasePointId
                        if(uwcv != null && (uwcv.Market_ISO__c == 'SG' || uwcv.Market_ISO__c == 'MY')) {
                            if(ord.Argo_Order__c){
                                tempdet.add(ord.Name);//SFPONumber
                            }
                            else{
                                tempdet.add(ord.Purchase_Order_Number__c);//SFPONumber  
                            }
                            tempdet.add(String.isNotBlank(ord.Customer_PO__c) == true ? ord.Customer_PO__c : '');//PONumber
                        }
                        ordRec.add(tempdet);
                    }
                }
            }
        }
        
        ordrdetlist.Data = ordRec;
        return ordrdetlist;
    }
    
    public static RExAPIResponseDomain.ResponseInfo objectToOLIInfo(List<ivydsd__Order_Line_Item__c> OLIList,Map<String,Map<String,String>> intreIdanduomMap,String errorcode){
        
        RExAPIResponseDomain.ResponseInfo OLIdetlist = new RExAPIResponseDomain.ResponseInfo();
        
        OLIdetlist.Master = 'P4OrderHistoryDetail';
        OLIdetlist.Next ='0';
        OLIdetlist.ErrorCode = errorCode == null ? '0' : errorCode; 
        OLIdetlist.Field = new List<String>{'refid','productid','uomid','Qty','LineValue','DiscountValue','DiscountPercent'};
            List<List<String>> oliRec = new List<List<String>>();
        Map<String,String> listTypeStdMasterMap = new Map<String,String>();
        
        for(ivybase__Standard_List_Master__c stdMtr: StandardListMasterService.getStandardListUsingListType(new List<String>{('PRODUCT_UOM')})){
            listTypeStdMasterMap.put(stdMtr.ivybase__List_Name__c,stdMtr.Name);
        }
        
        if(OLIList != null && errorcode == null){
            
            for(ivydsd__Order_Line_Item__c oli : OLIList){
                
                List<String> tempdet = new List<String>();
                
                tempdet.add(oli.ivydsd__Order__r.ivydsd__Internal_Id__c);//refid
                
                tempdet.add(String.valueOf(oli.ivydsd__Product1__r.ivybase__InternalId__c));//productid
                
                //system.debug('::::oli.UOM_1_Quantity__c::::'+oli.UOM_1_Quantity__c);
                // system.debug('::::oli.Product__r.Internal_Id__c::::'+oli.Product__r.Internal_Id__c);
                if(oli.ivydsd__UOM_1_Quantity__c != null && oli.ivydsd__UOM_1_Quantity__c > 0){
                    List<String> templist1 = new List<String>();
                    templist1.addAll(tempdet);
                    
                    if(intreIdanduomMap.containskey(String.valueOf(oli.ivydsd__Product1__r.ivybase__InternalId__c))&& intreIdanduomMap.get(String.valueOf(oli.ivydsd__Product1__r.ivybase__InternalId__c)).containskey('UOM 1')){
                        Map<String,String> tempMap = intreIdanduomMap.get(String.valueOf(oli.ivydsd__Product1__r.ivybase__InternalId__c));
                        templist1.add(listTypeStdMasterMap.get(tempMap.get('UOM 1')) != null ? listTypeStdMasterMap.get(tempMap.get('UOM 1')):'');
                    }else{
                        templist1.add('');
                    }//uomid
                    //(ord.ivydsd__Order_Status__c != null ? ord.ivydsd__Order_Status__c : '');
                    if(oli.ivydsd__UOM_1_Quantity__c != null){
                        templist1.add(String.Valueof(oli.ivydsd__UOM_1_Quantity__c));
                    }else{
                        templist1.add('');
                    }////Qty
                    if(oli.ivydsd__Total_Amount__c!= null){
                        templist1.add(String.Valueof(oli.ivydsd__Total_Amount__c));
                    }else{
                        templist1.add('');
                    }//LineValue
                    if(oli.ivydsd__DiscountAmount__c!= null){
                        templist1.add(String.Valueof(oli.ivydsd__DiscountAmount__c));
                    }else{
                        templist1.add('');
                    }//DiscountValue
                    if(oli.ivydsd__Discount_Percentage__c!= null){
                        templist1.add(String.Valueof(oli.ivydsd__Discount_Percentage__c));
                    }else{
                        templist1.add('');
                    }//DiscountPercent
                    
                    oliRec.add(templist1);
                }
                
            }
        }
        OLIdetlist.Data = oliRec;
        return OLIdetlist;
        
    }
    
    /* public static RExAPIResponseDomain.ResponseInfo objectToOLIByVisitInfo(Map<Id,Map<Integer,Id>> retilwithvisitidsMap,List<ivydsd__Order_Line_Item__c> OLIList,String errorcode){

RExAPIResponseDomain.ResponseInfo OLIdetlist = new RExAPIResponseDomain.ResponseInfo();

OLIdetlist.Master = 'RtrWiseP4OrderAndStockMaster';
OLIdetlist.Next ='0';
OLIdetlist.ErrorCode = errorCode == null ? '0' : errorCode; 
OLIdetlist.Field = new List<String>{'rid','pid','ordp4','stkp4'};
List<List<String>> oliRec = new List<List<String>>();
Map<Id,Map<Id,Decimal>> olidprodqtyMap = new Map<Id,Map<Id,Decimal>>();
Map<Id,Map<String,ivybase__Product_UOM__c>> uomandcfMap = new Map<Id,Map<String,ivybase__Product_UOM__c>>();
Map<Id,Map<String,Decimal>> uomvalandcfMap = new Map<Id,Map<String,Decimal>>();
Set<String> chkdup = new Set<String>();
Set<Id> proIds = new Set<Id>();
if(OLIList != null && errorcode == null){

for(ivydsd__Order_Line_Item__c oli : OLIList){
proIds.add(oli.ivydsd__Product1__c);

}

for(ivybase__Product_UOM__c uom : ProductUOMService.getProductUOMListByProdIds(proIds)){


if(!uomandcfMap.containskey(uom.ivybase__Product__c)){
uomandcfMap.put(uom.ivybase__Product__c,new Map<String,ivybase__Product_UOM__c>());
}
uomandcfMap.get(uom.ivybase__Product__c).put(uom.ivybase__UOM_Number__c,uom);

if(!uomvalandcfMap.containskey(uom.ivybase__Product__c)){
uomvalandcfMap.put(uom.ivybase__Product__c,new Map<String,Decimal>());
}
if(uom.ivybase__UOM__c != NULL){
uomvalandcfMap.get(uom.ivybase__Product__c).put(uom.ivybase__UOM__c,uom.ivybase__Conversion_Factor__c);
}
}


for(ivydsd__Order_Line_Item__c oli : OLIList){

Decimal tempqty = 0;

if(uomandcfMap.get(oli.ivydsd__Product1__c) != NULL){

if(oli.ivydsd__UOM_1_Quantity__c != NULL && oli.ivydsd__UOM_1_Quantity__c > 0 && uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 1') != NULL && uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 1').ivybase__Conversion_Factor__c != NULL){
tempqty += (oli.ivydsd__UOM_1_Quantity__c * uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 1').ivybase__Conversion_Factor__c);
}

if(oli.ivydsd__UOM_2_Quantity__c != NULL && oli.ivydsd__UOM_2_Quantity__c > 0 && uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 2') != NULL && uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 2').ivybase__Conversion_Factor__c != NULL){
tempqty += (oli.ivydsd__UOM_2_Quantity__c * uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 2').ivybase__Conversion_Factor__c);
}

if(oli.ivydsd__UOM_3_Quantity__c != NULL && oli.ivydsd__UOM_3_Quantity__c > 0 && uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 3') != NULL && uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 3').ivybase__Conversion_Factor__c != NULL){
tempqty += (oli.ivydsd__UOM_3_Quantity__c * uomandcfMap.get(oli.ivydsd__Product1__c).get('UOM 3').ivybase__Conversion_Factor__c);
}

if(!olidprodqtyMap.containskey(oli.ivydsd__Order__r.ivydsd__Visit__c)){
olidprodqtyMap.put(oli.ivydsd__Order__r.ivydsd__Visit__c,new Map<Id,Decimal>());
}
if(!olidprodqtyMap.get(oli.ivydsd__Order__r.ivydsd__Visit__c).containskey(oli.ivydsd__Product1__c)){
olidprodqtyMap.get(oli.ivydsd__Order__r.ivydsd__Visit__c).put(oli.ivydsd__Product1__c,0);
}
olidprodqtyMap.get(oli.ivydsd__Order__r.ivydsd__Visit__c).put(oli.ivydsd__Product1__c, olidprodqtyMap.get(oli.ivydsd__Order__r.ivydsd__Visit__c).get(oli.ivydsd__Product1__c) + tempqty);
}
}

system.debug('uomvalandcfMap'+uomvalandcfMap);
system.debug('olidprodqtyMap'+olidprodqtyMap);

for(ivydsd__Order_Line_Item__c oli : OLIList){

if(!chkdup.contains(String.Valueof(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c)+String.Valueof(oli.ivydsd__Product1__c))){

List<String> templist = new List<String>();
String quantity ='';
templist.add(String.Valueof(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c));//rid
templist.add(String.valueOf(oli.ivydsd__Product1__r.ivybase__InternalId__c));//pid

if(retilwithvisitidsMap.containskey(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c)){

List<Integer> tempcountlist = new List<Integer>{1,2,3,4};

for(Integer int1 : tempcountlist){

if(retilwithvisitidsMap.get(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c).containskey(int1) && olidprodqtyMap.Containskey(retilwithvisitidsMap.get(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c).get(int1)) &&

olidprodqtyMap.get(retilwithvisitidsMap.get(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c).get(int1)).get(oli.ivydsd__Product1__c) != null){

Decimal conqty = uomvalandcfMap.get(oli.ivydsd__Product1__c).get(oli.ivydsd__Product1__r.ivybase__Default_UOM__c) != NULL ? uomvalandcfMap.get(oli.ivydsd__Product1__c).get(oli.ivydsd__Product1__r.ivybase__Default_UOM__c) : 1 ;
Decimal tempqty = Math.floor(olidprodqtyMap.get(retilwithvisitidsMap.get(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c).get(int1)).get(oli.ivydsd__Product1__c) / conqty);

quantity += String.ValueOf(tempqty);
} else {
quantity += '0';
}

if(int1 != tempcountlist.size()){
quantity += ',';
}
}

chkdup.add(String.Valueof(oli.ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c)+String.Valueof(oli.ivydsd__Product1__c));
templist.add(quantity);//ordp4
templist.add('');//stkp4
oliRec.add(templist);
}
}
}
}

OLIdetlist.Data = oliRec; 
return OLIdetlist;
}*/
    
    
    
    
}