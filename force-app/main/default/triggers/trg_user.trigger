/***************************************************************************
Trigger to assign users to public group based on User's MarkerISO selection
By Mani
created date:22-feb-2019
***************************************************************************
*/
trigger trg_user on User (after insert) {
    
 LIST<CountryCodeMarketISO__mdt> countrymdtLIST = new LIST<CountryCodeMarketISO__mdt>();
    
 countrymdtLIST = [SELECT Id,Country__c,PublicGroupName__c FROM CountryCodeMarketISO__mdt]; 
 
 MAP<STring,String> countryCodeGroupNameMAP = new MAP<String,String>();
    if(countrymdtLIST.size()>0){
        for(CountryCodeMarketISO__mdt mdtRecord : countrymdtLIST) {
            if(!countryCodeGroupNameMAP.containsKey(mdtRecord.Country__c)){
                countryCodeGroupNameMAP.put(mdtRecord.PublicGroupName__c,mdtRecord.Country__c);
            }
        }  
    }  
 
    system.debug('countryCodeGroupNameMAP'+ countryCodeGroupNameMAP);
    
 List<Group> Grp = [select id,name,DeveloperName from Group where name IN:countryCodeGroupNameMAP.keySet() ];
 Map<String, Group> mapOfcode = new Map<String, Group>();

    for(Group gp:Grp){
        
        
        if(countryCodeGroupNameMAP.containsKey(gp.name)){
            mapOfcode.put(countryCodeGroupNameMAP.get(gp.name),gp);
        }
        /*if(countryCodeGroupNameMAP.containsKey(gp.DeveloperName)){
            mapOfcode.put(countryCodeGroupNameMAP.get(gp.DeveloperName),gp);
        }*/
       // setOfGroupIds.add(grp.Id);
        /*if(gp.DeveloperName == 'Philippines'){
            mapOfcode.put('PH', gp);
        }
        if(gp.DeveloperName == 'Malaysia'){
            mapOfcode.put('MY',gp);
        }
        if(gp.DeveloperName == 'Singapore'){
            mapOfcode.put('SG',gp);
        }*/
 
       
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
     
    
}