public with sharing class JunctionRecordCreatorClass {
    
    
    /* Get Configuration data from custom metadata
*/
    @AuraEnabled
    public static JunctionCreatorWrapperClass getConfiguration()
    { 
        
        SObjectType sObjectType = Schema.getGlobalDescribe().get('Scheme_Product_creator__mdt');
        Boolean isMyObjectAccessible = sObjectType.getDescribe().isAccessible();
        system.debug(isMyObjectAccessible);
        if(isMyObjectAccessible){
            String [] MetadataFields = new String [] {'Product_Object_API_Name__c','Search_Field__c',
                'Product_Table_search_field__c','Product_Column_Name__c','Product_Hierarchy_Level_1_Name__c','Product_Hierarchy_Level_2_Name__c'};
                    for (String fieldToCheck : MetadataFields) {
                        // Check if the user has create access on the each field
                        Map<String,Schema.SObjectField> m = Schema.SObjectType.Scheme_Product_creator__mdt.fields.getMap();
                        
                        if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                            
                            return null;
                        }
                    }
            
            
            
            
            Scheme_Product_creator__mdt configdata=[Select DeveloperName,MasterLabel,Product_Object_API_Name__c,Product_Hierarchy_Level_2_Name__c,Product_Hierarchy_Level_1_Name__c,
                                                      Search_Field__c,Product_Table_search_field__c,Product_Column_Name__c
                                                     from Scheme_Product_creator__mdt LIMIT 1];
            system.debug(configdata);
            
            Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
         //   Schema.SObjectType ObjectSchema = schemaMap.get(configdata.jBuilder__Parent_2_API_Name__c);
            
            
            JunctionCreatorWrapperClass wrp = new JunctionCreatorWrapperClass();
            //wrp.Parent2LabelName = ObjectSchema.getDescribe().getLabel();
            wrp.config = configdata;
            return wrp;
        }
        else{
            return null;
        }
    }
    /*  @AuraEnabled
   public static list<sObject> getSKUS(String searchKey,String fieldNames,String condition, String junctionObj,string Signatureid ,string brandid, Boolean bool){
        
        String query;
    
         list<sObject> recordList = new list<sObject>();
        SObjectType sObjectType = Schema.getGlobalDescribe().get(junctionObj);
        Map<String,Schema.SObjectField> m =sObjectType.getDescribe().fields.getMap();
        system.debug('brandid'+brandid);
        system.debug('signatureid'+Signatureid);
        Boolean isMyObjectAccessible = sObjectType.getDescribe().isAccessible();
        system.debug(isMyObjectAccessible);
        list<string> fieldslist = new list<string>();
        
        if(isMyObjectAccessible){
            if(fieldNames.contains(',')){
                fieldslist = fieldNames.split(',');
                for(string field:fieldslist){
                    if (!m.get(field).getDescribe().isAccessible()){
                        return null;
                    }
                }
            }    
            if(brandid!='' &&Signatureid!='')
            query = 'Select '+fieldNames+' from '+junctionObj +' where Brand_Id__c=\''+brandid +'\' AND Signature_Id__c=\''+Signatureid+'\'';
             if(brandid=='' &&Signatureid=='')
            query = 'Select '+fieldNames+' from '+junctionObj;
           
            System.debug('query '+query);
          
            
            SObjectType objType = Schema.getGlobalDescribe().get(junctionObj);
            list<string> parentrecordslist = new list<string>();
                System.debug(condition);
            System.debug('searchKey '+searchKey);
            if( bool== true && condition!=null){
                query += ' AND '+ condition;
            }
            else if(condition==null && !string.isblank(searchKey)){
                query += ' and name'+' LIKE \'' + searchKey+'%\'';  
            }
           
            else if(condition!=null){
                query += ' and '+condition;
            }
            System.debug('searchKey '+ searchKey);
            System.debug(query);
            recordList = Database.query(query);
              for(sObject parent:recordList){
                parentrecordslist.add(string.valueof(parent.get('name')));
              }
            System.debug(recordList);
            
            return recordList;
        }
        else{
            return null;
        }
    }*/
    @AuraEnabled
    public static list<JunctionCreatorWrapperClass.wrapperClass> getParentFieldDetails(String parentObjName, String parentColumnName){
        SObjectType sObjectType = Schema.getGlobalDescribe().get(parentObjName);
        Map<String,Schema.SObjectField> m =sObjectType.getDescribe().fields.getMap();
         Boolean isMyObjectAccessible = sObjectType.getDescribe().isAccessible();
        system.debug(isMyObjectAccessible);
        list<string> fieldslist = new list<string>();
        system.debug('parentObjName'+parentObjName);
        system.debug('parentColumnName'+parentColumnName);
        if(isMyObjectAccessible){
            if(parentColumnName.contains(',')){
                fieldslist = parentColumnName.split(',');
                for(string field:fieldslist){
                    if (!m.get(field).getDescribe().isAccessible()){
                        return null;
                    }
                }
            } 
            list<JunctionCreatorWrapperClass.wrapperClass> wrpList = new List<JunctionCreatorWrapperClass.wrapperClass>();
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType objSchema = schemaMap.get(parentObjName);
            Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
            
            //List<String> fieldvalList=new List<String>();
            //fieldvalList= fieldName.split(',');
            System.debug('fieldName '+parentColumnName);
            list<string> parentColumnNamelist = new   list<string>(); 
            if(parentColumnName.contains(',')){
                parentColumnNamelist = parentColumnName.split(',');
            }
            else{
                parentColumnNamelist.add(parentColumnName);  
            }
            for(Integer i=0;i<parentColumnNamelist.size();i++)
            {
                Schema.SObjectField field = fieldMap.get(parentColumnNamelist[i]);
                JunctionCreatorWrapperClass.wrapperClass wrapcls= new JunctionCreatorWrapperClass.wrapperClass();
                wrapcls.label = field.getDescribe().getLabel();
                wrapcls.fieldName = field.getDescribe().getName();
                if(string.valueOf(field.getDescribe().getType()).toLowercase() == 'double')
                    wrapcls.type = 'number';
                else
                    wrapcls.type = string.valueOf(field.getDescribe().getType()).toLowercase();
                wrpList.add(wrapcls);             
            }
            
            return wrpList;
        }
        else{
            return null;
        }
    }   
    @AuraEnabled
    public static void insertjunctionrecords(list<string> secondParentlist, string Parent1,string parentfields,string junctionObjname){
       system.debug('secondParentlist'+secondParentlist);
        system.debug('Parent1'+Parent1);
        system.debug('parentfields'+parentfields);
        system.debug('junctionObjname'+junctionObjname);
        list<ivydsd__Scheme_Group_Product__c> schemegrouplist=new list<ivydsd__Scheme_Group_Product__c>();
        for(string recid:secondParentlist){
        ivydsd__Scheme_Group_Product__c s=new ivydsd__Scheme_Group_Product__c();
        s.ivydsd__Product1__c=recid;
            s.ivydsd__Scheme_Group__c=Parent1;
            schemegrouplist.add(s);
            }
        insert schemegrouplist;
    }
    
       @AuraEnabled        
    public static List<ivybase__Product_Hierarchy__c> getProductHierarchyLevel1(string levelName){
         return [SELECT Name,ivybase__Internal_Id__c 
                 FROM ivybase__Product_Hierarchy__c 
                 WHERE recordtype.developername=:levelName AND ivybase__Is_Competitor__c = false];
    }
        @AuraEnabled        
    public static List<ivybase__Product_Hierarchy__c> getProductHierarchyLevel2(string level1Id,string levelName,string level1name){
        list<string> s=new list<string>{'Function','Class','Sub_Axe','Axe','Nuance','Reference','Sub_Brand','Brand','Signature'};
            string query='select id,ivybase__Internal_Id__c,name,recordtype.name from ivybase__Product_Hierarchy__c where recordtype.developername=:levelName ';
   
        system.debug('levelName'+levelName+'level1name'+level1name);
        
        if(s.indexof(level1name)-s.indexof(levelName)<=5){
           system.debug('enetr');
             query+='And ';
        for(integer i=s.indexof(levelName);i<s.indexof(level1name);i++)
            query+='ivybase__Parent__r.';
            query+='ivybase__Internal_Id__c=';
           
        query+='\''+level1Id+'\'';
        }
        else{
       list<ivybase__Product_Hierarchy__c>   prodhierarchylist= [SELECT Id,ivybase__Internal_Id__c,name,recordtype.developername 
                                                                 FROM ivybase__Product_Hierarchy__c 
                                                                 WHERE recordtype.name=:s[3] 
                                                                    AND ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Internal_Id__c=:level1Id
                                                                    AND ivybase__Is_Competitor__c = false
                                                                ];
  set<string> prodids=new set<string>();
            for(ivybase__Product_Hierarchy__c p:prodhierarchylist)
                prodids.add(p.ivybase__Internal_Id__c);
            system.debug('prodids'+prodids);
            if(prodids.size()>0){
                system.debug('query'+query);
                query+='And ';
                system.debug('query'+query);
            for(integer i=s.indexof(levelName);i<s.indexof(s[3]);i++)
            query+='ivybase__Parent__r.';
            query+='ivybase__Internal_Id__c ';
        query+='in :prodids';
            }
           
        }
        
          system.debug('query'+query);  
         return Database.query(query);
    }
       @AuraEnabled
    public static list<sObject> getSKURecord(String searchKey,String fieldNames,String condition, String junctionObj,string level2id,string levelName, Boolean bool,string Parent1){
         String query;
       list<sObject> recordList = new list<sObject>();
      
               SObjectType sObjectType = Schema.getGlobalDescribe().get(junctionObj);
        Map<String,Schema.SObjectField> m =sObjectType.getDescribe().fields.getMap();
         Boolean isMyObjectAccessible = sObjectType.getDescribe().isAccessible();
        system.debug(isMyObjectAccessible);
        list<string> fieldslist = new list<string>();
        if(isMyObjectAccessible){
            if(fieldNames.contains(',')){
                fieldNames+=',ivybase__Non_Saleable__c';
                fieldslist = fieldNames.split(',');
                for(string field:fieldslist){
                    if (!m.get(field).getDescribe().isAccessible()){
                        return null;
                    }
                }
            }    
            if(level2id!=''){
            query = 'Select '+fieldNames+' from '+junctionObj +' where ivybase__Active__c=\'Yes\' and ivybase__Is_Competitor__c=False and ';
               list<string> s=new list<string>{'SKU','Function','Class','Sub_Axe','Axe','Nuance','Reference','Sub_Brand','Brand','Signature'};
          system.debug('levelName'+levelName);
        
        if(s.indexof(levelname)<=4){
           system.debug('enetr');
        for(integer i=0;i<s.indexof(levelname);i++)
            query+='ivybase__Parent__r.';
            query+='ivybase__Internal_Id__c=';
            
        query+='\''+level2Id+'\'';
        }
        else{
            
            string basequery='select ivybase__Internal_Id__c from ivybase__Product_Hierarchy__c where recordtype.developername=\''+s.get(s.indexof(levelname)-5)+'\' and ';
            for(integer i=s.indexof(levelname)-5;i<s.indexof(levelname);i++)
            basequery+='ivybase__Parent__r.';
            basequery+='ivybase__Internal_Id__c=\''+level2Id+'\'';
           system.debug('basequery'+basequery);
    list<ivybase__Product_Hierarchy__c>   prodhierarchylist=Database.query(basequery);
            set<string> prodids=new set<string>();
            for(ivybase__Product_Hierarchy__c p:prodhierarchylist)
                prodids.add(p.ivybase__Internal_Id__c);
            system.debug('prodids'+prodids);
            for(integer i=0;i<s.indexof(levelname)-5;i++)
            query+='ivybase__Parent__r.';
            query+='ivybase__Internal_Id__c';
        query+=' in:prodids';
           
        }
        
          system.debug('query'+query);  
        // return Database.query(query);
       
            }
             if(level2id=='')
            query = 'Select '+fieldNames+' from '+junctionObj +' where ivybase__Active__c=\'Yes\' and ivybase__Is_Competitor__c=False';
           
            System.debug('query '+query);
          
            
            SObjectType objType = Schema.getGlobalDescribe().get(junctionObj);
            list<string> SKUrecordslist = new list<string>();
            
          
                 
            System.debug(condition);
            System.debug('searchKey '+searchKey);
            if( bool== true && condition!=null){
                query += ' and '+ condition;
            }
            else if(condition==null && !string.isblank(searchKey)){
               
                   query += ' and name'+' LIKE \'' + searchKey+'%\'';  
            }
           
            else if(condition!=null){
                query += ' and '+condition;
            }
            System.debug('searchKey '+ searchKey);
            System.debug(query);
            recordList = Database.query(query);
            system.debug('record id'+Parent1);
            list<ivydsd__Scheme_Group__c> scg= [select id,ivydsd__Group_Type__c from ivydsd__Scheme_Group__c where Id=:Parent1 ];
            system.debug('scg'+scg);
            system.debug('*****junctionObj'+junctionObj);
            if(junctionObj=='ivybase__Product__c' && scg.size()>0 && scg[0].ivydsd__Group_Type__c=='Buy'){
                list<sobject> SaleablerecordList=new list<sobject>();
                for(sobject record:recordList)
                    if(record.get('ivybase__Non_Saleable__c')==false)
                    SaleablerecordList.add(record);
                    return SaleablerecordList;
            }
            else
                
            return recordList;
        }
        else{
            return null;
        }
    }
  
   }