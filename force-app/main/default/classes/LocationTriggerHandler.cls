public class LocationTriggerHandler {
    
    public static List<ivybase__Resource__c> resourceList = new List<ivybase__Resource__c>();
    
    public static List<ivybase__Resource__c> queryResource() {
    
        if(resourceList == null || resourceList.isEmpty() == true) {
                    
            List<ivybase__Resource__c> resourceList = [SELECT Id FROM ivybase__Resource__c WHERE ivybase__Related_User__c =: UserInfo.getUserId()];
            System.debug('resourceList==>'+resourceList);
            
            return resourceList;
        }
        return resourceList;
    }
    
    public static void populateResource(List<ivybase__Location__c> locationList) {
        
        List<ivybase__Resource__c> resource = queryResource();
        System.debug('resource==>'+resource);
        
        for(ivybase__Location__c loc : locationList) {
            
            if(loc.ivybase__Resource__c == null) {
                
                if(resource!= null && resource.isEmpty() == false) {
                    loc.ivybase__Resource__c = resource[0].Id;
                }
            }
        }  
    }
}