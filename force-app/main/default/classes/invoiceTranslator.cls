public class invoiceTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToInvoiceLineItemPast4Invoice(Map<Id,Map<Integer,Id>> retailerLast4Invoice,List<ivydsd__Invoice_Line_Item__c> invLineItem,String errorcode){
        
        RExAPIResponseDomain.ResponseInfo invLine = new RExAPIResponseDomain.ResponseInfo();
        
        invLine.Master = 'RtrWiseP4OrderAndStockMaster';
        invLine.Next ='0';
        invLine.ErrorCode = errorCode == null ? '0' : errorCode; 
        invLine.Field = new List<String>{'rid','pid','ordp4','stkp4'};
            List<List<String>> lineRec = new List<List<String>>();
        Map<Id,Map<Id,Decimal>> olidprodqtyMap = new Map<Id,Map<Id,Decimal>>();
        Map<Id,Map<Id,Decimal>> invIdprodqtyMap = new Map<Id,Map<Id,Decimal>>();
        Map<Id,Map<String,ivybase__Product_UOM__c>> uomandcfMap = new Map<Id,Map<String,ivybase__Product_UOM__c>>();
        Map<Id,Map<String,Decimal>> uomvalandcfMap = new Map<Id,Map<String,Decimal>>();
        Set<String> chkdup = new Set<String>();
        Set<Id> proIds = new Set<Id>();
        Map<Id,Set<Id>> RetailerproductWithPastQuantity = new Map<Id,Set<Id>>();
        if(invLineItem != null && errorcode == null){
            
            for(ivydsd__Invoice_Line_Item__c invli : invLineItem){
                if(invli.ivydsd__UOM_1_Quantity__c !=null){
                    if(invli.ivydsd__UOM_1_Quantity__c>0){
                   // productWithPastQuantity.add(invli.ivydsd__Product_Master1__c);
                   if(RetailerproductWithPastQuantity.containsKey(invli.ivydsd__Invoice__r.ivydsd__Store__c))
                   {
                       RetailerproductWithPastQuantity.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).add(invli.ivydsd__Product_Master1__c);
                   }else
                   {
                       Set<Id> productId = new Set<Id>();
                       productId.add(invli.ivydsd__Product_Master1__c);
                      RetailerproductWithPastQuantity.put(invli.ivydsd__Invoice__r.ivydsd__Store__c,productId); 
                   }
                    }
                    if(invIdprodqtyMap.containsKey(invli.ivydsd__Invoice__c))
                    {
                        if(invIdprodqtyMap.get(invli.ivydsd__Invoice__c).containsKey(invli.ivydsd__Product_Master1__c))
                        {
                            Decimal exisitngQty = invIdprodqtyMap.get(invli.ivydsd__Invoice__c).get(invli.ivydsd__Product_Master1__c);
                            invIdprodqtyMap.get(invli.ivydsd__Invoice__c).put(invli.ivydsd__Product_Master1__c,exisitngQty+invli.ivydsd__UOM_1_Quantity__c);
                        }else
                        {
                            invIdprodqtyMap.get(invli.ivydsd__Invoice__c).put(invli.ivydsd__Product_Master1__c,invli.ivydsd__UOM_1_Quantity__c);       
                        }
                        
                    }else
                    {   Map<Id,Decimal> prodQty = new Map<Id,Decimal>();
                     prodQty.put(invli.ivydsd__Product_Master1__c,invli.ivydsd__UOM_1_Quantity__c);
                     invIdprodqtyMap.put(invli.ivydsd__Invoice__c,prodQty);
                    }
                } 
            }             
            system.debug('****invIdprodqtyMap'+invIdprodqtyMap);
            for(ivydsd__Invoice_Line_Item__c invli : invLineItem){
                
                if(!chkdup.contains(String.Valueof(invli.ivydsd__Invoice__r.ivydsd__Store__c)+String.Valueof(invli.ivydsd__Product_Master1__c))){
                   if(RetailerproductWithPastQuantity.containskey(invli.ivydsd__Invoice__r.ivydsd__Store__c)==true && RetailerproductWithPastQuantity.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).contains(invli.ivydsd__Product_Master1__c)){
                    List<String> templist = new List<String>();
                    String quantity ='';
                    templist.add(String.Valueof(invli.ivydsd__Invoice__r.ivydsd__Store__r.ivybase__Internal_Id__c));//rid
                    templist.add(String.valueOf(invli.ivydsd__Product_Master1__r.ivybase__InternalId__c));//pid
                    
                    if(retailerLast4Invoice.containskey(invli.ivydsd__Invoice__r.ivydsd__Store__c)){
                        
                        List<Integer> tempcountlist = new List<Integer>{1,2,3,4};
                            
                            for(Integer int1 : tempcountlist){
                                
                                if(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).containskey(int1) && invIdprodqtyMap.Containskey(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).get(int1)) &&
                                   
                                   invIdprodqtyMap.get(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).get(int1)).get(invli.ivydsd__Product_Master1__c) != null){
                                       
                                       
                                       Decimal tempqty = invIdprodqtyMap.get(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).get(int1)).get(invli.ivydsd__Product_Master1__c);
                                       
                                       quantity += String.ValueOf(tempqty);
                                   } else {
                                       quantity += '0';
                                   }
                                
                                if(int1 != tempcountlist.size()){
                                    quantity += ',';
                                }
                            }
                        
                        chkdup.add(String.Valueof(invli.ivydsd__Invoice__r.ivydsd__Store__c)+String.Valueof(invli.ivydsd__Product_Master1__c));
                        templist.add(quantity);//ordp4
                        templist.add('');//stkp4
                        lineRec.add(templist);
                    }
                }
                }
            }
        }
        
        
        
        
        invLine.Data = lineRec; 
        return invLine;
    }    
    public static RExAPIResponseDomain.ResponseInfo objectToINVInfo(List<ivydsd__Invoice__c> InvoiceList,String errorcode){
        
         RExAPIResponseDomain.ResponseInfo INVdetlist = new RExAPIResponseDomain.ResponseInfo();
        
         INVdetlist.Master = 'InvoiceMaster';
         INVdetlist.Next ='0';
         INVdetlist.ErrorCode = errorCode == null ? '0' : errorCode; 
         INVdetlist.Field = new List<String>{'invoiceno','invoicedate','retailerId','invNetamount','LinesPerCall','orderid','paidamount','RField1','RField2'};
         List<List<String>> INVRec = new List<List<String>>();
         
         if(InvoiceList != null && errorcode == null){
            
             for(ivydsd__Invoice__c inv : InvoiceList){
                 
                 List<String> templist = new List<String>();
                 templist.add(inv.ivydsd__Mobile_Invoice_Number__c != null ? inv.ivydsd__Internal_Id__c : '');//invoiceno
                 templist.add(inv.ivydsd__Invoice_Date__c != null ? (inv.ivydsd__Invoice_Date__c.year()+'/'+CommonUtility.convertTwodigit(inv.ivydsd__Invoice_Date__c.Month())+'/'+CommonUtility.convertTwodigit(inv.ivydsd__Invoice_Date__c.Day())) : '');//invoicedate
                 templist.add(inv.ivydsd__Store__c != null ? String.Valueof(inv.ivydsd__Store__r.ivybase__Internal_Id__c) :'');//retailerId
                 templist.add(inv.ivydsd__Invoice_Amount__c != null ? String.Valueof(inv.ivydsd__Invoice_Amount__c) : '');//invNetamount
                 templist.add(String.Valueof(inv.ivydsd__Number_of_Line_Items__c));//LinesPerCall
                 // templist.add(inv.Order__c != null ? inv.Order__r.Internal_Id__c : '');//orderid
                 templist.add(inv.ivydsd__Order__c != null ? (inv.ivydsd__Order__r.ivydsd__Purchase_Order_Number__c != null ? inv.ivydsd__Order__r.ivydsd__Purchase_Order_Number__c : '') : '');
                 if (inv.ivydsd__PaidAmount__c != null) {
                     templist.add(String.valueOf(inv.ivydsd__PaidAmount__c));
                 } else {
                     templist.add('0');
                 }
                 templist.add(inv.ivydsd__Due_Date__c != null ? (inv.ivydsd__Due_Date__c.year()+'/'+CommonUtility.convertTwodigit(inv.ivydsd__Due_Date__c.Month())+'/'+CommonUtility.convertTwodigit(inv.ivydsd__Due_Date__c.Day())) : '');//RField1
                templist.add(inv.Billing_Doc_Number__c != null ? inv.Billing_Doc_Number__c : '');//RField2
                 INVRec.add(templist);
             }
         }
         
         INVdetlist.Data =INVRec;
         return INVdetlist;
     }
    public static RExAPIResponseDomain.ResponseInfo objectToinvoiceInfo(map<id,list<ivydsd__Invoice__c>> accountinvoicemap,String errorcode){
        //system.debug('invoiceList'+invoiceList);
        RExAPIResponseDomain.ResponseInfo invdetlist = new RExAPIResponseDomain.ResponseInfo();
        
        invdetlist.Master = 'P4InvoiceHistoryMaster';
        invdetlist.Next ='0';
        invdetlist.ErrorCode = errorCode == null ? '0' : errorCode; 
        invdetlist.Field = new List<String>{'retailerId','retailerCode','invoiceid','invoicedate','invoicevalue','lpc','Flag','PaidAmount','DeliveryStatus','reasonid','refid','RField1','RField2','RField3','RField4'};
            List<List<String>> invRec = new List<List<String>>();
        
        if(accountinvoicemap!= null && errorcode == null){
            
            for(id accid : accountinvoicemap.keyset()){
                if(accountinvoicemap.get(accid)!=null && accountinvoicemap.get(accid).size()>0){
                    for(ivydsd__Invoice__c inv:accountinvoicemap.get(accid)){
                        List<String> tempdet = new List<String>();
                        if(accountinvoicemap.containskey(inv.ivydsd__Store__c) && inv.ivydsd__Store__r.ivybase__Internal_Id__c!=null ){
                            tempdet.add(String.Valueof(inv.ivydsd__Store__r.ivybase__Internal_Id__c));
                        }else{
                            tempdet.add('');
                        }//retailerId 
                        if(accountinvoicemap.containskey(inv.ivydsd__Store__c) && inv.ivydsd__Store__r.ivybase__StoreCode__c!=null){
                            tempdet.add(String.Valueof(inv.ivydsd__Store__r.ivybase__StoreCode__c));
                        }else{
                            tempdet.add('');
                        }//retailerCode 
                       tempdet.add(inv.Billing_Doc_Number__c != null ? inv.Billing_Doc_Number__c : ''); //invoiceid
                       tempdet.add(inv.ivydsd__Invoice_Date__c != null ? (inv.ivydsd__Invoice_Date__c.year()+'/'+CommonUtility.convertTwodigit(inv.ivydsd__Invoice_Date__c.Month())+'/'+CommonUtility.convertTwodigit(inv.ivydsd__Invoice_Date__c.Day()))  : ''); //invoicedate
                       if(inv.ivydsd__Invoice_Amount__c!=null){
                            tempdet.add(String.Valueof(inv.ivydsd__Invoice_Amount__c));
                        }else{
                            tempdet.add('');
                        }//invoicevalue
                        if(inv.ivydsd__Number_of_Line_Items__c != null){
                            tempdet.add(String.Valueof(inv.ivydsd__Number_of_Line_Items__c));
                        }else{
                            tempdet.add('');
                        }//lpc 
                        tempdet.add('');//Flag
                        if(inv.ivydsd__PaidAmount__c != null){
                            tempdet.add(String.Valueof(inv.ivydsd__PaidAmount__c));
                        }else{
                            tempdet.add('');//PaidAmount
                        }
                        tempdet.add(inv.ivydsd__Invoice_Status__c != null ? inv.ivydsd__Invoice_Status__c : '');//status
                        tempdet.add('');//reasonid
                        if(inv.ivydsd__Internal_Id__c != null){
                            tempdet.add(String.Valueof(inv.ivydsd__Internal_Id__c));
                        }else{
                            tempdet.add('');//refid
                        }
                        tempdet.add('');//RField1
                        tempdet.add('');//RField2
                        tempdet.add('');//RField3
                        tempdet.add('');//RField4
                    invRec.add(tempdet);
                    }
                     
                }
            }
        }
        
        invdetlist.Data = invRec;
        return invdetlist;
    }
    
public static RExAPIResponseDomain.ResponseInfo objectToInvoiceLineInfo(List<ivydsd__Invoice_Line_Item__c> invoiceLineItemList,
                                                                        String errorcode)
{
    RExAPIResponseDomain.ResponseInfo invrdetlist = new RExAPIResponseDomain.ResponseInfo();   
    invrdetlist.Master = 'P4InvoiceHistoryDetail';
    invrdetlist.Next ='0';
    invrdetlist.ErrorCode = errorCode == null ? '0' : errorCode; 
    invrdetlist.Field = new List<String>{'refid','productid','UomId','qty','volume'};  
        Map<String,String> internalIdAndSMasterMap = new Map<String,string>();
    for(ivybase__Standard_List_Master__c stdMaster:  StandardListMasterService.getAllStandard_List()){
        internalIdAndSMasterMap.put(stdMaster.ivybase__List_Name__c,stdMaster.Name);
    }
    List<List<String>> invDetailRecords = new List<List<String>>();
    if(invoiceLineItemList!=null){
        for(ivydsd__Invoice_Line_Item__c invoiceItemList :invoiceLineItemList ){
            List<String> invitemInfo = new List<String>();
            
            //refid
            if(invoiceItemList.ivydsd__Invoice__c != null){
                invitemInfo.add(invoiceItemList.ivydsd__Invoice__r.ivydsd__Internal_Id__c);
                
            }else{
                invitemInfo.add(''); 
            }
            //productid
            if(invoiceItemList.ivydsd__Product_Master1__c != null){
                invitemInfo.add(string.valueof(invoiceItemList.ivydsd__Product_Master1__r.ivybase__InternalId__c));
                
            }else{
                invitemInfo.add(''); 
            }
            //UomId
            if(invoiceItemList.ivydsd__UOM_1_Name__c != null && internalIdAndSMasterMap.containskey(invoiceItemList.ivydsd__UOM_1_Name__c)){
                //invitemInfo.add(invoiceItemList.ivydsd__Product_Master1__r.ivybase__InternalId__c);
                invitemInfo.add(internalIdAndSMasterMap.get(invoiceItemList.ivydsd__UOM_1_Name__c));
            }else{
                invitemInfo.add(''); 
            }
            //qty
            if(invoiceItemList.ivydsd__UOM_1_Quantity__c != null){
                invitemInfo.add(string.valueof(invoiceItemList.ivydsd__UOM_1_Quantity__c));
                
            }else{
                invitemInfo.add(''); 
            }
            invitemInfo.add('');
            invDetailRecords.add(invitemInfo);
        }
        
    }
    system.debug('invDetailRecords'+invDetailRecords);
    invrdetlist.Data=invDetailRecords;
    return invrdetlist;
}
}