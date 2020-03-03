public with sharing class ResourceService {
    public static ivybase__Resource__c res;
    
    public static Id getLoginSellerId() {
        
        Id uid = UserInfo.getUserId();
        String[] ckFields = new String[] {'ivybase__Related_User__c'}; 
        
        if (SecurityUtility.checkIsAccessible('ivybase__Resource__c', ckFields)) { 
            List<ivybase__Resource__c> resourceList = [ SELECT ID, 
                                             ivybase__Related_User__c 
                                      FROM  ivybase__Resource__c
                                      WHERE 
                                      ivybase__Related_User__c =:uid];
            if (resourceList != null && resourceList.size() > 0) {
                return resourceList[0].Id;            
            }  
            return null;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    public static ivybase__Resource__c getSellerId(Id userId) {
        system.debug('userId'+userId);
        String[] resourceFields = new String[] {'ivybase__Related_User__c','ivybase__Resource_Type__c','ivybase__Reports_To__c','ivybase__Location_Hierarchy__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Resource__c', resourceFields)) { 
            
            if (res == null) {
                system.debug(':::inside query::');
                List<ivybase__Resource__c> resourceList = [SELECT Id, ivybase__Related_User__c, ivybase__Reports_To__c,ivybase__Resource_Type__c, ivybase__Location_Hierarchy__c,Market_ISO__c FROM ivybase__Resource__c WHERE ivybase__Related_User__c =:userId LIMIT 1];
                res = new ivybase__Resource__c();
                system.debug('resourceList '+resourceList);
                if (resourceList != null && resourceList.size() > 0) {
                    res = resourceList[0];
                }
            }
            return res;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    public static map<string,string> GetAllResources(){
    
        user u=[select ivybase__Internal_Id__c from user where id=:userinfo.getUserId()];
        set<id> TerritoryIds=new set<id>();
        map<string,string> UserDivisionmap=new map<string,string>();
        List<ivybase__Location_Hierarchy__c> UserTerritories=  LocationMasterService.getUserTerritory();
        system.debug('UserTerritories'+UserTerritories);
        for(ivybase__Location_Hierarchy__c i:UserTerritories)
            TerritoryIds.add(i.id);
        list<DivisionLocation__c> DivisionLocation=[select id,Division__r.Internal_Id__c,Division__r.name,IsDefaultDivision__c from DivisionLocation__c where Location_Hierarchy__c in:TerritoryIds];
        system.debug('DivisionLocation'+DivisionLocation);
        for(DivisionLocation__c d:DivisionLocation){
            if(d.Division__c!=null && u!=null && u.ivybase__Internal_Id__c!=null){
            //system.debug('d.Division__r.Internal_Id__c'+d.Division__r.Internal_Id__c);
                UserDivisionmap.put(d.Division__r.name+'.'+d.id+'.'+d.IsDefaultDivision__c, u.ivybase__Internal_Id__c.format());  
            }
        }
        
        return UserDivisionmap;
    }
    public static map<string,string> GetAllResourceDivisionmap(){
    
        user u=[select ivybase__Internal_Id__c from user where id=:userinfo.getUserId()];
        set<id> TerritoryIds=new set<id>();
        map<string,string> UserDivisionmap=new map<string,string>();
        List<ivybase__Location_Hierarchy__c> UserTerritories=  LocationMasterService.getUserTerritory();
        system.debug('UserTerritories'+UserTerritories);
        for(ivybase__Location_Hierarchy__c i:UserTerritories)
            TerritoryIds.add(i.id);
        system.debug('TerritoryIds '+ TerritoryIds);
        list<DivisionLocation__c> DivisionLocation=[select id,Division__r.id,Division__r.name from DivisionLocation__c where Location_Hierarchy__c in:TerritoryIds];
        system.debug('DivisionLocation'+DivisionLocation);
        for(DivisionLocation__c d:DivisionLocation){
          //  system.debug('d.Division__r.Internal_Id__c'+d.Division__r.Internal_Id__c);
          UserDivisionmap.put(d.Division__r.id,d.Division__r.name);  
        }
       
        return UserDivisionmap;
    }
    
    public static map<string,string> GetAllResourceDivisionNameIdmap(){
    
        user u=[select ivybase__Internal_Id__c from user where id=:userinfo.getUserId()];
        set<id> TerritoryIds=new set<id>();
        map<string,string> UserDivisionmap=new map<string,string>();
        List<ivybase__Location_Hierarchy__c> UserTerritories=  LocationMasterService.getUserTerritory();
        system.debug('UserTerritories'+UserTerritories);
        for(ivybase__Location_Hierarchy__c i:UserTerritories)
            TerritoryIds.add(i.id);
        list<DivisionLocation__c> DivisionLocation=[select id,Division__r.id,Division__r.name from DivisionLocation__c where Location_Hierarchy__c in:TerritoryIds];
        system.debug('DivisionLocation'+DivisionLocation);
        for(DivisionLocation__c d:DivisionLocation){
          //  system.debug('d.Division__r.Internal_Id__c'+d.Division__r.Internal_Id__c);
          UserDivisionmap.put(d.Division__r.name,d.Division__r.id);  
        }
       
        return UserDivisionmap;
    }
    
    public static List<ivybase__Resource__c> getResourceByUserId(Id userId) {
        
        String[] resourceFields = new String[] {'ivybase__Related_User__c','ivybase__Uplift_Factor__c', 'ivybase__Scheme_Factor__c'};
        system.debug('++++UID'+userId);
        String[] accountFields = new String[] {'ivybase__Internal_Id__c', 'ivybase__TIN_Number__c', 'Phone'};
        String[] userFields = new String[] {'ivybase__Internal_Id__c'};
       
        if (SecurityUtility.checkIsAccessible('ivybase__Resource__c', resourceFields) && SecurityUtility.checkIsAccessible('Account', accountFields)
                                                 && SecurityUtility.checkIsAccessible('User', userFields)) { 
            return [
                    SELECT Id,
                        ivybase__Account__r.Parent.Parent.ivybase__Internal_Id__c,//Principal or Organization Id
                        Name,
                        ivybase__Related_User__c,
                        ivybase__Related_User__r.ivybase__Internal_Id__c,
                        ivybase__Related_User__r.Name,
                        ivybase__Related_User__r.TimeZoneSidKey,
                        ivybase__Related_User__r.UserRole.Name,
                        ivybase__Related_User__r.UserName,
                        ivybase__Account__c,ivybase__Resource_Type__c,ivybase__Resource_Type__r.Name,
                        ivybase__Account__r.ParentId,
                        ivybase__Account__r.Parent.Name,                                            
                        ivybase__Account__r.ivybase__Internal_Id__c,
                        ivybase__Account__r.Parent.ivybase__Internal_Id__c,
                        ivybase__Account__r.Parent.ivybase__TIN_Number__c,
                        ivybase__Account__r.Parent.Phone,
                        ivybase__Uplift_Factor__c,
                        ivybase__Scheme_Factor__c,
                        ivybase__Reports_To__c,
                        ivybase__Reports_To__r.ivybase__Account__r.Parent.Parent.ivybase__Internal_Id__c,//Principal or Organization Id
                        ivybase__Reports_To__r.Name,
                        ivybase__Reports_To__r.ivybase__Related_User__c,
                        ivybase__Reports_To__r.ivybase__Related_User__r.ivybase__Internal_Id__c,
                        ivybase__Reports_To__r.ivybase__Related_User__r.Name,
                        ivybase__Reports_To__r.ivybase__Related_User__r.TimeZoneSidKey,
                        ivybase__Reports_To__r.ivybase__Related_User__r.UserRole.Name,
                        ivybase__Reports_To__r.ivybase__Related_User__r.UserName,
                        ivybase__Reports_To__r.ivybase__Account__c,ivybase__Reports_To__r.ivybase__Resource_Type__c,ivybase__Reports_To__r.ivybase__Resource_Type__r.Name,
                        ivybase__Reports_To__r.ivybase__Account__r.ParentId,
                        ivybase__Reports_To__r.ivybase__Account__r.Parent.Name,                                            
                        ivybase__Reports_To__r.ivybase__Account__r.ivybase__Internal_Id__c,
                        ivybase__Reports_To__r.ivybase__Account__r.Parent.ivybase__Internal_Id__c,
                        ivybase__Reports_To__r.ivybase__Account__r.Parent.ivybase__TIN_Number__c,
                        ivybase__Reports_To__r.ivybase__Account__r.Parent.Phone,
                        ivybase__Reports_To__r.ivybase__Uplift_Factor__c,
                        ivybase__Reports_To__r.ivybase__Scheme_Factor__c
                    FROM
                        ivybase__Resource__c
                    WHERE
                        ivybase__Related_User__c != NULL
                        AND ivybase__Related_User__c = :userId
            ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
}