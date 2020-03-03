public class HairDresserEmailTemplate{
public string contactId{get;set;}
public list<Contact> contactList = new list<Contact>();

public list<Contact> getContactDetails()
{
    contactList = [select id,name,Signature_Link__c,Phone,Email,Level__c,Account.name,Account.ivybase__Contact_PhoneNo__c,Account.ivybase__Contact_Email__c from Contact where id=:contactId];
    return contactList;
}
}