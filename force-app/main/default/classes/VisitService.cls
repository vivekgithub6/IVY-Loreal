public with sharing class VisitService {

public static Map<Id,Map<Integer,Id>> getlast4VisitsbyRetailer(Set<Id> retailerIds){
        
        List<ivybase__Visit__c> visitList;
        String[] visitFields = new String[]{'ivybase__Store__c','ivybase__Visit_Date__c'};
       // Map<Id,List<ivybase__Visit__c>> retailIdandvisitlist = new Map<Id,List<ivybase__Visit__c>>();
        Map<Id,Map<Integer,Id>> retailervisitIds = new Map<Id,Map<Integer,Id>>();
        if (SecurityUtility.checkIsAccessible('ivybase__Visit__c', visitFields )) {
             
            visitList = [SELECT Id,ivybase__Store__c,ivybase__Visit_Date__c FROM ivybase__Visit__c WHERE ivybase__Store__c IN :retailerIds AND ivybase__Visit_Date__c!=null ORDER BY ivybase__Visit_Date__c DESC];
            
            for(ivybase__Visit__c v : visitList){
                if(!retailervisitIds.containskey(v.ivybase__Store__c)){
                    retailervisitIds.put(v.ivybase__Store__c,new Map<Integer,Id>());
                }
                if(retailervisitIds.containskey(v.ivybase__Store__c) && retailervisitIds.get(v.ivybase__Store__c).keyset().size() < 4){
                    System.debug('*********');
                    Integer count = retailervisitIds.get(v.ivybase__Store__c).keyset().size();
                    System.debug('*********'+count);
                    if(retailervisitIds.get(v.ivybase__Store__c).keyset().size() == 0){
                        retailervisitIds.get(v.ivybase__Store__c).put(1,v.Id);
                    }else{
                        retailervisitIds.get(v.ivybase__Store__c).put(count+1,v.Id); 
                    }
                }
            }
                
            System.debug('****visitList'+retailervisitIds);
           // return retailIdandvisitlist;
            return retailervisitIds;
                
        }else {
            System.debug('visit exeption');
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
         } 
    }
    
    public static List<ivybase__Visit__c> getVisitsForStoreAndSeller(Set<Id> storeIdSet){
        
       // List<Contact> contactlist = ContactService.getContactsByUserId(UserInfo.getUserId());
        List<ivybase__Resource__c> contactlist = ResourceService.getResourceByUserId(UserInfo.getUserId());
        String conId = contactlist[0].Id;
        String visitQuery =  'SELECT Id,ivybase__Duration__c,ivybase__Lat_Position__c,ivybase__Original_Date__c,ivybase__Route_Id__c,'
                            + 'ivybase__Seller__c,ivybase__Status__c,ivybase__Store__c,ivybase__Time_In__c,ivybase__Time_Out__c,ivybase__Type__c,ivybase__Visit_Date__c FROM ivybase__Visit__c'
                            + '  WHERE ivybase__Store__c IN: storeIdSet '
                            + ' AND ivybase__Resource__c =: conId';
        
       String[] visitFields = new String[] {'ivybase__Duration__c','ivybase__Lat_Position__c','ivybase__Original_Date__c','ivybase__Route_Id__c',
                                            'ivybase__Seller__c', 'ivybase__Status__c','ivybase__Store__c','ivybase__Time_In__c','ivybase__Time_Out__c',
                                            'ivybase__Resource__c', 'ivybase__Type__c','ivybase__Visit_Date__c'}; 
       
       if (SecurityUtility.checkIsAccessible('ivybase__Visit__c', visitFields )) {                                
           List<ivybase__Visit__c> visitList = Database.query(visitQuery);                                 
           return visitList;
       }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                                                         'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
    }
    
    /* 
	Added method for Surveys

	*/
    public static List<ivybase__Visit__c> getVisitByIds(Set<Id> visitIds) {
        List<String> VisitFields = new List<String>{'ivybase__Store__c'};
            
            if (SecurityUtility.checkIsAccessible('ivybase__Visit__c', VisitFields )) {  
                List<ivybase__Visit__c> visits = new List<ivybase__Visit__c>();
                visits = [SELECT Id, name, ivybase__Store__c,ivybase__Visit_Date__c from ivybase__Visit__c where Id IN:visitIds];
                return visits;
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    } 
}