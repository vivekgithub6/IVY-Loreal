public class ContactService {
public static list<contact> getAllContacts(set<id> AccIds){
    return[select id,Internal_Id__c from contact where Accountid in:AccIds];
}
}