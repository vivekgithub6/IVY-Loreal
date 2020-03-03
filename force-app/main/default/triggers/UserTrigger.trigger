/***************************************************************************
Trigger to assign users to public group based on User's MarkerISO selection
By Mani
created date:22-feb-2019
***************************************************************************
*/
trigger UserTrigger on User (after insert,after update) {
    
    if(trigger.isAfter == true && (trigger.isInsert || trigger.isUpdate)) {
        //Create or Update CustomSetting
        Map<Id,String> userCurrencyMap = new Map<Id,String>();
        Map<Id,String> userCountryMap = new Map<Id,String>();
        for(User u: trigger.new)
        {
            if(trigger.isUpdate)
            {
               if((trigger.oldMap.get(u.Id).Market_Iso__c!=trigger.newMap.get(u.Id).Market_Iso__c)|| trigger.oldMap.get(u.Id).DefaultCurrencyIsoCode!=trigger.newMap.get(u.Id).DefaultCurrencyIsoCode)
               {
                  userCountryMap.put(u.id,trigger.newMap.get(u.Id).Market_Iso__c);
                  userCurrencyMap.put(u.id,trigger.newMap.get(u.Id).DefaultCurrencyIsoCode);
               }
            }
            if(trigger.isInsert)
            {
                if(u.Market_ISO__c!=null && u.DefaultCurrencyIsoCode!=null)
                {
                    userCurrencyMap.put(u.id,trigger.newMap.get(u.Id).DefaultCurrencyIsoCode);
                    userCountryMap.put(u.id,trigger.newMap.get(u.Id).Market_Iso__c);
                } 
            }
        }
        UserTriggerHandler.updateCustomSetting_UserwiseCountryValues(userCountryMap,userCurrencyMap);
        Set<Id> userIdSet = new Set<Id>();
        set<Id> oldUSerIdSet = new Set<Id>();
        Set<String> marketISOSet = new Set<String>();
        Map<String, String> isoGpNameMap = new Map<String, String>();
        Map<String, String> gpnameIdMap = new Map<String, String>();
        for(User u : trigger.new) {
            User oldUser = trigger.isUpdate ? trigger.oldMap.get(u.Id) : null;
            if(String.isNotBlank(u.Market_Iso__c) == true && (trigger.isInsert || 
                                                              (trigger.isUpdate && u.Market_ISO__c != oldUser.Market_ISO__c))) {
                                                                  userIdSet.add(u.Id);
                                                                  marketISOSet.add(u.Market_ISO__c);
                                                                  
                                                                  if(trigger.isUpdate) {
                                                                      oldUserIdSet.add(u.Id);
                                                                  }
                                                              }
        }
        
        
        
        if(marketISOSet.isEmpty() == false && marketISOSet.isEmpty() == false) {
            system.debug('metadata value'+marketISOSet);
            for(CountryCodeMarketISO__mdt ssmiso : [SELECT id, Country_Code__c, PublicGroupName__c,Country__c
                                                    FROM CountryCodeMarketISO__mdt WHERE Country__c IN :marketISOSet]) {
                                                        isoGpNameMap.put(ssmiso.Country__c, ssmiso.PublicGroupName__c);                                        
                                                        
                                                        system.debug('metadata value'+isoGpNameMap);
                                                    }
        }
        if(isoGpNameMap.isEmpty() == false) {
            for(Group gup : [SELECT Id,name, DeveloperName FROM Group WHERE name IN : isoGpNameMap.values()]) {
            //for(Group gup : [SELECT Id,name, DeveloperName FROM Group WHERE DeveloperName IN : isoGpNameMap.values()]) {
               // gpnameIdMap.put(gup.DeveloperName, gup.Id);
                gpnameIdMap.put(gup.name, gup.Id);
                
                system.debug('metadata value Mapped'+gpnameIdMap);
            }
        }
        
        if(userIdSet.isEmpty() == false) {
            List<GroupMember> gpmList = new List<GroupMember>();
            for(USer u : trigger.new) {
                User oldUser = trigger.isUpdate ? trigger.oldMap.get(u.Id) : null;
                
                
                oldUserIdSet.add(u.id);
                // delete [SELECT Id FROM GroupMember WHERE Id IN :oldUserIdSet];
                
                
                
                if(String.isNotBlank(u.Market_Iso__c) == true && (trigger.isInsert || 
                                                                  (trigger.isUpdate && u.Market_ISO__c != oldUser.Market_ISO__c))) {
                                                                      if(isoGpNameMap.containskey(u.Market_ISO__c)&&gpNameIdMap.containskey(isoGpNameMap.get(u.Market_ISO__c))){
                                                                          gpmList.add(new GroupMember(UserOrGroupId = u.Id, GroupId = gpNameIdMap.get(isoGpNameMap.get(u.Market_ISO__c))));
                                                                      }
                                                                      
                                                                  }
            }
            if(oldUserIdSet.isEmpty() == false) {
                delete [select id from GroupMember where UserOrGroupId  IN : oldUserIdSet];
                
            }
            
            if(!Test.isRunningTest() && gpmList.size()>0){
                insert gpmList;
            }
            system.debug('inserted value for the list'+gpmList);
        }
        
    }
    
    /*    
List<Group> Grp = [select id,name,DeveloperName from Group where DeveloperName = 'Malaysia'OR DeveloperName= 'Singapore' or DeveloperName= 'Philippines'];
Map<String, Group> mapOfcode = new Map<String, Group>();

for(Group gp:Grp){

// setOfGroupIds.add(grp.Id);
if(gp.DeveloperName == 'Philippines'){
mapOfcode.put('PH', gp);
}
if(gp.DeveloperName == 'Malaysia'){
mapOfcode.put('MY',gp);
}
if(gp.DeveloperName == 'Singapore'){
mapOfcode.put('SG',gp);
}


}  
set<id> idremove = new set<id>();
list<GroupMember> gmlistFalse = new list<GroupMember> ();
List<GroupMember>listGroupMember =new List<GroupMember>();

for(user u: trigger.new){
group gr = Mapofcode.get(u.Market_Iso__C);

GroupMember objGrp = new GroupMember();
objGrp.GroupId = gr.Id;
objGrp.userorGroupId = u.Id;
listGroupMember.add(objGrp);

if(trigger.oldmap != null && trigger.oldmap.isEmpty() == false && u.Market_Iso__C != trigger.oldmap.get(u.id).Market_Iso__C) {
idremove .add(u.id);
}


}
If(idremove.size()>0)
{
gmlistFalse = [select id from GroupMember where UserOrGroupId  IN : idremove];
delete gmlistFalse ;
}
if( !Test.isRunningTest() && listGroupMember.size() > 0)
insert listGroupMember;
*/   
    
}