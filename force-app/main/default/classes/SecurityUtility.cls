public class SecurityUtility {
    
    public static Boolean checkIsAccessible(string objName, list<String> fieldNames) {
        Boolean accessible = true;
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.sObjectType objType = gd.get(objName);
        if (objType == null || objType.getDescribe() == null || !objType.getDescribe().isAccessible()) {
            accessible = false;
            system.debug('+++Object Permission Missing+++'+objType);
            return accessible;
        }
        Map<String,Schema.SObjectField> m = objType.getDescribe().fields.getMap();
        
        for(String fieldName : fieldNames) {
        
            if(m.get(fieldName)!=null){
                if(!m.get(fieldName).getDescribe().isAccessible()) {
                    accessible = false;
                    system.debug('+++Missing Field permissions for '+fieldName+' in Object '+objType);
                    return accessible;
                }
            }
        }
        system.debug('accessible'+ accessible);
        return accessible;
    }
    
    public static Boolean checkIsCreateable(string objName, list<String> fieldNames) {
        Boolean creatable = true;
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.sObjectType objType = gd.get(objName);
        if (objType == null || objType.getDescribe() == null || !objType.getDescribe().isCreateable()) {
            creatable = false;
            system.debug('objType thrown Error'+objType);
            return creatable ;
        }
        Map<String,Schema.SObjectField> m = objType.getDescribe().fields.getMap();
        
        for(String fieldName : fieldNames) {
            if(!m.get(fieldName).getDescribe().isCreateable()) {
                system.debug('fieldName thrown Error'+fieldName);
                creatable = false;
                return creatable;
            }
        }
        return creatable;
    }
    
    public static Boolean checkIsEditable(string objName, list<String> fieldNames) {
        Boolean editable = true;
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.sObjectType objType = gd.get(objName);
        if (objType == null || objType.getDescribe() == null || !objType.getDescribe().isUpdateable()) {
            editable = false;
            return editable ;
        }
        Map<String,Schema.SObjectField> m = objType.getDescribe().fields.getMap();
        
        for(String fieldName : fieldNames) {
            if(!m.get(fieldName).getDescribe().isUpdateable()) {
                editable = false;
                return editable;
            }
        }
        return editable;
    }
    
    /*
	Method added for surveys 
	*/
     public static String check_Is_Accessible(string objName, list<String> fieldNames) {
        String errorMessage = '';
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if (objName != null && !objName.startsWithIgnoreCase('ivybase__') 
                && (objName.endsWithIgnoreCase('__c') || objName.endsWithIgnoreCase('__mdt'))) {
           // objName = 'ivybase__'+objName;      
        }
        Schema.sObjectType objType = gd.get(objName);
        if (objType == null || objType.getDescribe() == null || !objType.getDescribe().isAccessible()) {
            errorMessage += 'This "'+objName+'" do not have access permission\n';
        }
        Map<String,Schema.SObjectField> m = objType.getDescribe().fields.getMap();
        
        for(String fieldName : fieldNames) {
            if (fieldName != null && !fieldName.startsWithIgnoreCase('ivybase__') 
                    && (fieldName.endsWithIgnoreCase('__c') || fieldName.endsWithIgnoreCase('__s'))) {
   
                //fieldName = 'ivybase__'+fieldName;
            }
            if(!m.get(fieldName).getDescribe().isAccessible()) {  
                errorMessage += ' The "'+objName+'.'+fieldName+'" do not have access permission\n';
            }
        }
        return errorMessage;
    }
    
    public static Boolean checkIsDeletable(string objName) {
        Boolean deletable = true;
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.sObjectType objType = gd.get(objName);
        if (objType == null || objType.getDescribe() == null || !objType.getDescribe().isDeletable()) {
            deletable = false;
            return deletable ;
        }
        return deletable;
    }
    
    public class SFDCAccessControlException extends Exception {
        public String type;
        public SFDCAccessControlException(String errorMsg, String type) {
            this.setMessage(errorMsg);
            this.type = type;
       }
    }
    
    public class ExtSFDCAccessControlException extends Exception {
        public String type;
        public String objectName;
        public ExtSFDCAccessControlException(String errorMsg, String type, String objectName) {
            this.setMessage(errorMsg);
            this.type = type;
            this.objectName = objectName;
       }
    }
}