public with sharing class InvoiceLineItemService{ 
public static List<ivydsd__Invoice_Line_Item__c> getILIUsinginvoiceIdSet(Set<Id> invoiceSet){
        
        //System.debug(':::::::::getOrderLineItemById::::::::::::');
       // String[] invlnitmFields = new String[] {'Id','Name','ivydsd__Internal_Id__c','ivydsd__Invoice__c','ivydsd__Product_Master1__c','ivydsd__UOM_1_Rate__c','ivydsd__UOM_2_Rate__c','ivydsd__UOM_3_Rate__c','ivydsd__UOM_1_Quantity__c','ivydsd__UOM_2_Quantity__c','ivydsd__UOM_3_Quantity__c'}; 
       String[] invlnitmFields = new String[] {'Id','Name'}; 

            String[] invlnitm1Fields = new String[] {'ivybase__InternalId__c'};//'ivybase__Default_UOM__c','ivybase__Code__c'
        //if (SecurityUtility.checkIsAccessible('Invoice_Line_Item__c', invlnitmFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', invlnitm1Fields)) {
            List<ivydsd__Invoice_Line_Item__c> InvLineItemRecords;
            InvLineItemRecords = [SELECT 
                                        Id,
                                        Name, 
                                        ivydsd__Line_Item_Type__c, 
                                        ivydsd__Invoice__c,
                                        ivydsd__Invoice__r.ivydsd__Store__r.ivybase__Internal_Id__c,
                                        ivydsd__Invoice__r.ivydsd__Store__c,
                                        ivydsd__Invoice__r.ivydsd__Internal_Id__c,
                                        ivydsd__Invoice__r.ivydsd__Mobile_Invoice_Number__c,
                                        ivydsd__Total_Amount__c, 
                                        ivydsd__Product_Master1__c, 
                                        ivydsd__Product_Master1__r.Name, 
                                        ivydsd__Product_Master1__r.ivybase__InternalId__c,
                                        ivydsd__Product_Master1__r.ivybase__Code__c,
                                        ivydsd__UOM_1_Quantity__c, 
                                        ivydsd__UOM_1_Rate__c, 
                                        ivydsd__UOM_1_Name__c,
                                        ivydsd__Internal_Id__c
                                   FROM ivydsd__Invoice_Line_Item__c
                                   WHERE ivydsd__Invoice__c IN :invoiceSet];
            return InvLineItemRecords;
        /*}else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }*/
    }
}