/**
 * Created By : Ivy Mobility
 * Created Date :
 * Purpose : To handled the Approvel/PO# changes during the DML on the Order
 * Test Class : TestOrderTrigger
 * 
 * Last Modified By : Karthikeyan
 * Last Modified Date : 2019-Aug-29
 * Purpose : Added Assign_Order_SO_to_PO__c field in the updatePONo methods to make the change as country specific change
*/
trigger OrderTrigger on ivydsd__Order__c(before insert, before update, after insert, after update) {//, after delete, after undelete) {
    public static boolean ranorderapproval = false;
    List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
    Set<id> orderIdSet = new Set<id>();
    //UserwiseCountryValues__c ucv = UserwiseCountryValues__c.getValues(UserInfo.getUserId());
    CountryCodeMarketISO__mdt ccm = [SELECT Id, Order_Auto_Approval__c, Assign_Order_SO_to_PO__c
                                     FROM CountryCodeMarketISO__mdt WHERE Country__c =:trigger.new[0].Market_ISO__c];
    if(trigger.isInsert && trigger.isAfter){
        
        List<Id> getSignatureLink = new List<Id>();
        List<String> imageUrlSet = new List<String>();
        for(ivydsd__Order__c order : trigger.new) { 
            if(order.ivydsd__Order_Status__c == 'Ordered') {
                orderIdSet.add(order.id);
            }
            String imageURL = order.Signature_Image_Path__c;
            System.debug('***ImageURL' + imageURL);
            if(imageURL != null && order.Signature_Link1__c == null) {
                imageUrlSet.add(Order.Signature_Image_Path__c);
                getSignatureLink.add(order.Id);
            }   
        }
        if(orderIdSet.size() > 0) {
            if((ccm == null || ccm.Order_Auto_Approval__c == false) && Ranorderapproval == false) {
                ranorderapproval = true;
            	OrderTriggerHandler.submitForApproval(orderIdSet);
            }
        }
    }
    if(trigger.isInsert && trigger.isBefore) {
        if(ccm.Assign_Order_SO_to_PO__c == true) {
            OrderTriggerHandler.updatePONo(trigger.new, new Map<Id, ivydsd__Order__c>());
        }
        OrderTriggerHandler.updatestatus(trigger.new);
        list<ivybase__Resource__c> res = [SELECT Id, Name, ivybase__Related_User__c, ivybase__Resource_Type__c,
                                        ivybase__Resource_Type__r.Name FROM ivybase__Resource__c 
                                          WHERE ivybase__Related_User__c =:userinfo.getUserId()];
        String resorcetypename = Label.ResourceType_Name; 
        if(res.size() > 0 && resorcetypename != null && res[0].ivybase__Resource_Type__r.Name != resorcetypename) {
            //OrderTriggerHandler.updateResourceDivisionInOrder(trigger.new, new Map<Id, ivydsd__Order__c>());
            OrderTriggerHandler.updateEmail(trigger.new);
            OrderTriggerHandler.mapToNormalSalon(Trigger.new);
        }
        system.debug('end of before insert');
    }
    if( trigger.isUpdate && trigger.isBefore) {
        if(ccm.Assign_Order_SO_to_PO__c == true) {
            OrderTriggerHandler.updatePONo(trigger.new, trigger.oldMap);
        }
        //OrderTriggerHandler.updateResourceDivisionInOrder(trigger.new, trigger.oldMap);
        OrderTriggerHandler.TaxCalculation(trigger.new);
        OrderTriggerHandler.updateEmail(trigger.new);
        OrderTriggerHandler.mapToNormalSalon(Trigger.new);
        list<ivydsd__Order__c> ordlist = new list<ivydsd__Order__c>();
        for(ivydsd__Order__c ord : trigger.new) {
            if(trigger.oldmap.get(ord.id).ivydsd__Order_Status__c != 'Ordered' && ord.ivydsd__Order_Status__c == 'Ordered') {
                ordlist.add(ord);
            }
        }
        OrderTriggerHandler.updatestatusOrdered(ordlist);
        //AccountService.UpdateAccountAVGOrderValue(trigger.new);
    }
    if(trigger.isInsert  && trigger.isAfter) {
        OrderTriggerHandler.updatePONumber(trigger.new);
    }
    /*if(trigger.isInsert  && trigger.isAfter){
       // OrderTriggerHandler.updatePONumber(trigger.new);
    }*/
    
    if(trigger.isUpdate  && trigger.isAfter) {
        system.debug('Query: After Update');
        List<Id> getSignatureLink = new List<Id>();
        List<String> imageUrlSet = new List<String>();
        
        for(ivydsd__Order__c order : trigger.new) {
            //only if service is changed
            if(order.ivydsd__Order_Value__c != trigger.oldMap.get(order.id).ivydsd__Order_Value__c)
                OrderList.add(Order);
            if(order.ivydsd__Order_Status__c != trigger.oldMap.get(order.id).ivydsd__Order_Status__c 
               && order.ivydsd__Order_Status__c == 'Ordered')
                orderIdSet.add(order.id);
        }
        system.debug('OrderIdSet' + orderIdSet);
        if(orderList.size() > 0) {
           // AccountService.UpdateAccountAVGOrderValue(OrderList);
        }
        if(orderIdSet.size() > 0) {
            if((ccm == null || ccm.Order_Auto_Approval__c == false) && ranorderapproval == false) {
                Ranorderapproval = true;
            	OrderTriggerHandler.SubmitForApproval(orderIdSet);
            }
        }
    }
    if( trigger.IsDelete && trigger.isAfter) {
        
       // AccountService.UpdateAccountAVGOrderValue(trigger.old);   
    }
    if( trigger.IsUnDelete){
      //  AccountService.UpdateAccountAVGOrderValue(trigger.new);   
        
    }
    
}