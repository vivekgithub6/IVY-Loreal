public class InvoiceService {
    public static List<ivydsd__Invoice__c> getLast4invoiceByRetailerIds(Set<Id> retailIds){
        
        String[] invFields = new String[]{'ivydsd__Invoice_Date__c','ivydsd__Store__c','ivydsd__Invoice_Amount__c','ivydsd__Number_of_Line_Items__c','ivydsd__Internal_Id__c', 'ivydsd__Invoice_Status__c','ivydsd__PaidAmount__c','ivydsd__Due_Date__c','ivydsd__Mobile_Invoice_Number__c'};
            String[] accFields = new String[]{'ivybase__Internal_Id__c'};
                String[] ordFields = new String[]{'ivydsd__Internal_Id__c','ivydsd__Purchase_Order_Number__c'};
                    List <ivydsd__Invoice__c> invoiceList = new List <ivydsd__Invoice__c>();
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Invoice__c', invFields) && SecurityUtility.checkIsAccessible('Account',accFields) &&  SecurityUtility.checkIsAccessible('ivydsd__Order__c',ordFields)){
            if((retailIds != null && retailIds.size() >0)){
                
                for(Account acc : [SELECT Id, (SELECT Id, Name, ivydsd__Invoice_Date__c, ivydsd__Store__c,
                                               ivydsd__Store__r.ivybase__Internal_Id__c, ivydsd__Invoice_Amount__c, 
                                               ivydsd__Number_of_Line_Items__c, ivydsd__Internal_Id__c, ivydsd__Invoice_Status__c,
                                               ivydsd__Order__r.ivydsd__Internal_Id__c, ivydsd__Order__r.ivydsd__Purchase_Order_Number__c,
                                               ivydsd__PaidAmount__c, ivydsd__Due_Date__c, ivydsd__Mobile_Invoice_Number__c
                                               FROM ivydsd__Invoice__r ORDER BY ivydsd__Invoice_Date__c DESC LIMIT 4)
                                   FROM Account WHERE Id IN :retailIds]) {
                                       invoiceList.addAll(acc.ivydsd__Invoice__r);
                                   }
            }
            return invoiceList;
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    public static List<ivydsd__Invoice__c> getinvoiceByRetailerIds(Set<Id> retailIds,Set<Id> invoiceIds){//Set<Id> retailIds,Set<Id> invoiceIds
        
        String[] invFields = new String[]{'ivydsd__Invoice_Date__c','ivydsd__Store__c','ivydsd__Invoice_Amount__c','ivydsd__Number_of_Line_Items__c','ivydsd__Internal_Id__c', 'ivydsd__Invoice_Status__c','ivydsd__PaidAmount__c','ivydsd__Due_Date__c','ivydsd__Mobile_Invoice_Number__c'};
            String[] accFields = new String[]{'ivybase__Internal_Id__c'};
                String[] ordFields = new String[]{'ivydsd__Internal_Id__c','ivydsd__Purchase_Order_Number__c'};
                    List <ivydsd__Invoice__c> invoiceList = new List <ivydsd__Invoice__c>();
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Invoice__c', invFields) && SecurityUtility.checkIsAccessible('Account',accFields) &&  SecurityUtility.checkIsAccessible('ivydsd__Order__c',ordFields)){
            if((retailIds != null && retailIds.size() >0) || (invoiceIds != null && invoiceIds.size() >0)){
                invoiceList = [SELECT 
                               Id,Name,ivydsd__Invoice_Date__c,ivydsd__Store__c,ivydsd__Store__r.ivybase__Internal_Id__c,ivydsd__Invoice_Amount__c,ivydsd__Number_of_Line_Items__c,ivydsd__Internal_Id__c,ivydsd__Invoice_Status__c,
                               ivydsd__Order__r.ivydsd__Internal_Id__c,ivydsd__Order__r.ivydsd__Purchase_Order_Number__c,ivydsd__PaidAmount__c,ivydsd__Due_Date__c,ivydsd__Mobile_Invoice_Number__c,Billing_Doc_Number__c
                               FROM 
                               ivydsd__Invoice__c
                               WHERE ivydsd__Invoice_Status__c = 'Pending'
                               AND (ivydsd__Store__c IN :retailIds OR Id IN :invoiceIds)];
            }
            return invoiceList;
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    public static map<id,list<ivydsd__Invoice__c>> getinvoicebyinvDate(){
        
        String[] InvFields = new String[]{'ivydsd__Invoice_Date__c','ivydsd__Store__c','ivydsd__Invoice_Amount__c','ivydsd__Number_of_Line_Items__c','ivydsd__Internal_Id__c','ivydsd__Seller__c','Billing_Doc_Number__c'};
            String[] accFields = new String[]{'ivybase__Internal_Id__c'};
                
                Id sellerId = ResourceService.getLoginSellerId();
        //system.debug('sellerId'+sellerId);
        if(SecurityUtility.checkIsAccessible('ivydsd__Invoice__c', InvFields) && SecurityUtility.checkIsAccessible('Account',accFields)){
            set<id> accid = new set<id>();
            list<account> acclist= AccountService.getAllRetailerMaster_List_for_Resource();//getAllRetailerMaster_List_for_Resource
            //system.debug('acclist'+acclist);
            for(account acc:acclist){
                accid.add(acc.id);
            }
            list<account> AccInvLst= new list<account>();
            AccInvLst=[select id,ivybase__Internal_Id__c,(select Id,Name,ivydsd__Invoice_Date__c,ivydsd__PaidAmount__c,ivydsd__Invoice_Status__c ,ivydsd__Store__r.ivybase__StoreCode__c,ivydsd__Store__r.ivybase__Internal_Id__c,ivydsd__Store__c,ivydsd__Invoice_Amount__c,ivydsd__Number_of_Line_Items__c,ivydsd__Internal_Id__c, ivydsd__Resource__c,Billing_Doc_Number__c from ivydsd__Invoice__r where ivydsd__Invoice_Date__c != null AND ivydsd__Resource__c=:sellerId ORDER BY ivydsd__Invoice_Date__c DESC LIMIT 4) 
                       from account 
                       where id IN:accid AND id IN (select ivydsd__Store__c from ivydsd__Invoice__c )];
            map<id,list<ivydsd__Invoice__c>> accInvMap= new map<id,list<ivydsd__Invoice__c>>();
            for(account acc:AccInvLst){
                for(ivydsd__Invoice__c inv:acc.ivydsd__Invoice__r){
                    if(accInvMap.containskey(acc.id)){
                        accInvMap.get(acc.id).add(inv);  
                    }else{
                        list<ivydsd__Invoice__c> invlist= new list<ivydsd__Invoice__c>();
                        invlist.add(inv);
                        accInvMap.put(acc.id,invlist);
                    }
                }
            }
            
            //system.debug('InvList'+accInvMap);
            return accInvMap;
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            // return null;
        }
    }
    
    public static Map<string,string> getinvoiceByinternalId(set<string> invoiceInternalIds){
        //ivydsd__Internal_Id__c
        List <ivydsd__Invoice__c> invoiceList = new List <ivydsd__Invoice__c>();
        if(invoiceInternalIds.size()>0){
            invoiceList=[select id, ivydsd__Internal_Id__c from ivydsd__Invoice__c where ID IN:invoiceInternalIds];    
        }
        Map<string,string> invoiceIdInternalIdMap = new map<string,string>();
        if(invoiceList.size() > 0){
            for(ivydsd__Invoice__c inv:invoiceList){
                invoiceIdInternalIdMap.put(inv.ivydsd__Internal_Id__c,inv.Id);  
            }   
        }
        return invoiceIdInternalIdMap;   
    }    
    
    
    
    /* Method to send Invoice detail records */
    public static LIST<ivydsd__Invoice_Line_Item__c> getInvoiceDetails(List<ivydsd__Invoice__c> Invoicelist){
        
        LIST<ivydsd__Invoice_Line_Item__c> InvoiceDetalsLIST = new LIST<ivydsd__Invoice_Line_Item__c>();
        
        
        if(Invoicelist.size()>0) {
            InvoiceDetalsLIST = [SELECT ID,ivydsd__Base_UOM__c,ivydsd__Base_UOM_Quantity__c,ivydsd__Internal_Id__c,
                                 ivydsd__UOM_1_Quantity__c,ivydsd__UOM_1_Rate__c,ivydsd__Invoice__c,
                                 ivydsd__Invoice__r.ivydsd__Internal_Id__c,
                                 ivydsd__Invoice__r.ivydsd__Store__r.ivybase__Internal_Id__c,
                                 ivydsd__Product_Master1__r.ivybase__InternalId__c,
                                 ivydsd__Invoice__r.ivydsd__Order__r.ivydsd__Final_Order_Value__c,
                                 ivydsd__Invoice__r.ivydsd__Invoice_Amount__c
                                 FROM ivydsd__Invoice_Line_Item__c
                                 WHERE ivydsd__Invoice__c IN : Invoicelist];
        }
        return InvoiceDetalsLIST;
    }
}