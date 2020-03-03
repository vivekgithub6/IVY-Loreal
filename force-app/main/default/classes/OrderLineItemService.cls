public with sharing class OrderLineItemService {

     
    public static List<ivydsd__Order_Line_Item__c> getOrderLineItemUsingOrderIdSet(Set<Id> orderSet){
       
        String[] ordlnitmFields = new String[] {'Id','Name','ivydsd__Total_Amount__c','ivydsd__Order__c','ivydsd__Product1__c','ivydsd__UOM_1_Rate__c','ivydsd__UOM_2_Rate__c','ivydsd__UOM_3_Rate__c','ivydsd__UOM_1_Quantity__c','ivydsd__UOM_2_Quantity__c','ivydsd__UOM_3_Quantity__c','ivydsd__Line_Item_Type__c','ivydsd__Internal_Id__c'}; 
        String[] ordlnitm1Fields = new String[] {'Internal_Id__c'};
        String[] produfields = new String[] {'ivybase__InternalId__c','ivybase__Default_UOM__c'};
        String[] accfields = new String[] {'ivybase__Internal_Id__c'};
        if (SecurityUtility.checkIsAccessible('ivydsd__Order_Line_Item__c', ordlnitmFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', produfields ) && SecurityUtility.checkIsAccessible('Account', accfields )) {
            List<ivydsd__Order_Line_Item__c> orderLineItemRecords;
            orderLineItemRecords = [SELECT 
                                        Id,
                                        Name, 
                                            ivydsd__Line_Item_Type__c, 
                                            ivydsd__Order__c,
                                            ivydsd__Order__r.ivydsd__Mobile_Order_Number__c,
                                            ivydsd__Order__r.ivydsd__Internal_Id__c,
                                            ivydsd__Product1__c, 
                                            ivydsd__Product1__r.Name, 
                                            ivydsd__Product1__r.ivybase__InternalId__c,
                                            ivydsd__Product1__r.ivybase__Default_UOM__c,
                                            ivydsd__Product1__r.ivybase__Active__c,
                                            ivydsd__Total_Amount__c,
                                            ivydsd__UOM_1_Quantity__c,
                                            ivydsd__UOM_2_Quantity__c,
                                            ivydsd__UOM_3_Quantity__c,
                                            ivydsd__DiscountAmount__c,
                                            ivydsd__Discount_Percentage__c,
                                            ivydsd__UOM_1_Rate__c,
                                            ivydsd__Internal_Id__c, ivydsd__Order__r.ivydsd__Seller__c, ivydsd__Order__r.ivydsd__Seller__r.Name,
                                            ivydsd__Order__r.ivydsd__Resource__c,ivydsd__Order__r.ivydsd__Resource__r.Name,
                                            ivydsd__Order__r.ivydsd__Visit__c,
                                            ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__c,
                                            ivydsd__Order__r.ivydsd__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c,
                                            ivydsd__Order__r.ivydsd__Store__c
                                   FROM ivydsd__Order_Line_Item__c
                                   WHERE ivydsd__Order__c IN : orderSet and ivydsd__Product1__r.ivybase__Active__c='Yes'];
            System.debug('orderLineItemRecords::: '+orderLineItemRecords);
            return orderLineItemRecords;
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        }
    }
}