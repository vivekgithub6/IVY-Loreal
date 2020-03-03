public class HairDresserUploadTranslator {
   public static void translateHairDresser(List<LorealUploadclass.HairDresserInfo> HairdresserList, Map<String,String> storeIdTidMap){
       try{
           List<Folder> folders = [select id,name from Folder limit 1];
        Id folderId = null;
        for(Folder f:folders)
        {
           folderId=f.Id;
        }
       system.debug('HairdresserList'+HairdresserList);   
           system.debug('storeIdTidMap'+storeIdTidMap);
       map<String,id> AccountInternalIdmap=new  map<string,id>();
       map<String,id> ContactInternalIdmap=new  map<string,id>();
            map<String,Contact> ContactIdmap=new  map<string,Contact>();
            String hostUrl;
       set<id> AcciDs=new set<id>();
         list<contact> NewContactList=new   list<contact>();
            list<contact> DeleteContactList=new   list<contact>();
        list<Account> AccountList=AccountService.getAllRetailerMaster_List_for_Resource();
       SYSTEM.debug('AccountList'+AccountList);
           for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('COMPETITOR_TRACKING_TYPE'),('Amazon_Configuration')})){
                       if(stdListMaster.ivybase__List_Code__c=='AS_HOST')
              hostUrl=  stdListMaster.ivybase__List_Name__c;
        }
       for(Account A:AccountList){
            AccountInternalIdmap.put(string.valueof(A.ivybase__Internal_Id__c),A.id);
           AcciDs.add(A.id);
       }
           system.debug('AccountInternalIdmap'+AccountInternalIdmap);
     list<contact> ContactList=RetailerContactService.getAllContacts(AcciDs);
          system.debug('ContactList'+ContactList);
           for(contact c:ContactList){
          ContactInternalIdmap.put(c.Internal_Id__c.format(),c.id);
               ContactIdmap.put(c.id,c);
           }
            if(HairdresserList!=null)
        {
            for(LorealUploadclass.HairDresserInfo res:HairdresserList)
            {
                
                if(!String.isBlank(res.RetailerId)){
                    contact contactrec=new contact();
                    if(!ContactInternalIdmap.containskey(res.HairdresserId)){
                    contactrec.HairdresserId__c=res.HairdresserId;
                }
                    if(res.HairdresserId!=Null && ContactInternalIdmap.containskey(res.HairdresserId))
                       contactrec.id= ContactInternalIdmap.get(res.HairdresserId);
                    contactrec.Actual_Created_Date__c=ConversionUtility.StringToDateConversion(res.Date_x);
                    if(res.RetailerId!=Null && storeIdTidMap.keyset().contains(res.RetailerId))
                     contactrec.AccountId=storeIdTidMap.get(res.RetailerId);
                    else if(res.RetailerId!=Null)
                          contactrec.AccountId=AccountInternalIdmap.get(res.RetailerId); 
                    else
                           contactrec.AccountId=Null;
                    contactrec.MobilePhone=res.MobileNo;
                    contactrec.lastname=res.HairdresserName;
                    if(!string.isBlank(res.Signature))
                    contactrec.Signature__c=hostUrl+'/'+res.Signature;
                    
                    contactrec.Privacy__c=Boolean.valueOf(res.Privacy);
                    contactrec.Social_Media_Id__c=res.SocialMediaId;
                    contactrec.Contact_Code__c=res.Hairdressercode;
                    contactrec.Email=res.EmailId;
                    //contactrec.
                   NewContactList.add(contactrec);
                }
              
                    
                }
                system.debug('NewContactList'+NewContactList);
                if(NewContactList.size()>0)
                 Upsert  NewContactList;
                
                //update AccountInternalIdmap.values();
            }
            
    }
       
       Catch(Exception e){
           system.debug('erromessage'+e.getMessage());
       }
}

}