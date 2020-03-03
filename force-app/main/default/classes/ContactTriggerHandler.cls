public class ContactTriggerHandler {
    public  static void FillInternalId(list<contact> ContactList){
        System.debug('Contact outside::'+ContactList);
        try{
            ivybase__Max_Internal_Id_Value__c maxInternalIdVal = ivybase__Max_Internal_Id_Value__c.getValues('Contact');
            System.debug('maxInternalIdVal:::'+maxInternalIdVal);
            Decimal maxIntVal = 0;
            maxIntVal = maxInternalIdVal.ivybase__Max_Internal_Id__c-1;
            System.debug('Contact::'+ContactList);
            for(contact c:ContactList){
                maxIntVal++;
                c.Internal_Id__c=maxIntVal;
                
            }
            system.debug('ContactList'+ContactList);
            
            maxInternalIdVal.ivybase__Max_Internal_Id__c=maxIntVal+1;
            
            update maxInternalIdVal;
        }catch(Exception e){
            System.debug('Error::'+e.getMessage()); 
        }
        
    }
}