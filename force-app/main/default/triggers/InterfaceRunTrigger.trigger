/**
 * This trigger is used to sent an email whenever the Interface Run was scheduled
*/
trigger InterfaceRunTrigger on Interface_Run__c (After insert) {
    if (Trigger.isAfter) {
        if(Trigger.isInsert) {
        
            InterfaceRunMail.SendMail(trigger.new);//Used to sent an email
        }
    }
}