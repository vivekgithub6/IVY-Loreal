trigger digitalContentMappingTrigger on ivybase__Digital_Content_Mapping__c (before insert,before update) {
    
    //Note : default record type for digital content will be sales presenter
    //store All digital content
    Set<Id> DigitalContentId = new Set<Id>();
    //Map<Listtype,<listcode,id>>
    Map<String,Map<String,Id>> SLMMap = new Map<String,Map<String,Id>>();
    //Map<DigitalContentId,RecordTypeName>
    Map<id,String> DigitalContentMap = new Map<Id,String>();
    for(ivybase__Digital_Content_Mapping__c mapping : trigger.new)
    {
        DigitalContentId.add(mapping.ivybase__Digital_Content__c);
        
    }
    //get digital content record type
    List<ivybase__Digital_Content__c> digitalContent = [select id,name,RecordType.DeveloperName from ivybase__Digital_Content__c where id=:DigitalContentId];
    for(ivybase__Digital_Content__c d:digitalContent)
    {
        system.debug('mapping record type '+d.RecordType.DeveloperName);
        if(d.RecordType.DeveloperName!=null){
            DigitalContentMap.put(d.id,d.RecordType.DeveloperName);
        }
    }
    List<String> ListTypeString = new List<String>();
    ListTypeString.add('PRODUCT_TAGGING');
    ListTypeString.add('DIGITAL_CONTENT_TYPE');
    ListTypeString.add('DIGITAL_CONTENT_TRAINING_TYPE');
    
    Id resourceTypeId;
    List<ivybase__Resource_Type__c> resourcetype = [select id,name from ivybase__Resource_Type__c where name='Sales Rep'];
    for(ivybase__Resource_Type__c rt:resourcetype)
    {
       resourceTypeId=rt.id; 
    }
    ivybase__Resource__c myResource = ResourceService.getSellerId(userinfo.getUserId()); 
    list<ivybase__Standard_List_Master__c> statusMapListCode= [select id,name,ivybase__List_Code__c,ivybase__List_Name__c,ivybase__Encrypted_List_Name__c,ivybase__List_Type__c,ivybase__Parent_Id__c,ivybase__Parent_Id__r.Name,ivybase__Parent_Id__r.ivybase__List_Name__c,ivybase__Flex1__c,ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c,ivybase__Resource_Type__c,ivybase__Location_Hierarchy__c from ivybase__Standard_List_Master__c where ivybase__List_Type__c != null and ivybase__List_Type__c in :ListTypeString and ivybase__Resource_Type__c =:resourceTypeId and ivybase__Location_Hierarchy__c=:myResource.ivybase__Location_Hierarchy__c];
    system.debug('statusMapListCode '+statusMapListCode);
    for(ivybase__Standard_List_Master__c s:statusMapListCode)
    {
        if(s.ivybase__List_Type__c=='DIGITAL_CONTENT_TYPE')
        {
            s.ivybase__List_Type__c='SalesPresenter';
        }
        if(s.ivybase__List_Type__c=='PRODUCT_TAGGING')
        {
            s.ivybase__List_Type__c='ProductCatalogue';
        }
        if(s.ivybase__List_Type__c=='DIGITAL_CONTENT_TRAINING_TYPE')
        {
            s.ivybase__List_Type__c='Training';
        }
        if(SLMMap.containsKey(s.ivybase__List_Type__c))
        {
            if(SLMMap.get(s.ivybase__List_Type__c).containsKey(s.ivybase__List_Code__c)==false)
            {
                SLMMap.get(s.ivybase__List_Type__c).put(s.ivybase__List_Code__c,s.id);
            }
        }
        else
        {
            Map<String,Id> COdeId = new Map<String,Id>();
            COdeId.put(s.ivybase__List_Code__c,s.id);
            SLMMap.put(s.ivybase__List_Type__c,COdeId);  
        }
    }
    system.debug('SLMMap'+SLMMap);
    for(ivybase__Digital_Content_Mapping__c mapping : trigger.new)
    {
        if(mapping.ivybase__Digital_Content__c!=null)
        {
            if(DigitalContentMap.containsKey(mapping.ivybase__Digital_Content__c))
            {
                String ListType = DigitalContentMap.get(mapping.ivybase__Digital_Content__c);
                system.debug('ListType'+ListType);
                if(SLMMap.containsKey(ListType))
                {
                    if(mapping.Content_Type__c!=null)
                    {
                        system.debug('mapping.Content_Type__c'+mapping.Content_Type__c);
                        if(SLMMap.get(ListType).containsKey(mapping.Content_Type__c))
                        {
                            
                            mapping.Standard_List_Master__c=SLMMap.get(ListType).get(mapping.Content_Type__c);
                            system.debug('mapping.Standard_List_Master__c'+mapping.Standard_List_Master__c);
                        }
                    }
                }
            }
        }
        
    }
}