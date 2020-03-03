/**
 * This batch class was created by Ivy for the PoC to send the discount data to Teryn SAK. 
 	Because we have received more then 50,000 discount details for Teryn.
	The first workaround API need to read the content of the file which generated from this batch - This throws heap size error so this was dropped
	Second workaround to create the Standard List Master record based on that mobile needs to hit the file and process the JSON
 * Test Class : TESTRESTDiscountManager
*/
global class BatchTempDiscount implements Database.Batchable<sObject>, Database.stateful {
    
    public String res_name;
    public String file_content;
    public String territory_id;
    public String jsonstring = '';
    public string errorCode=null;
   // String responseJSON 
    
    public BatchTempDiscount(String resname ) {
        res_name = resname;
        
    }
    

    global Database.QueryLocator start(Database.BatchableContext bc) {
        JSONGenerator jsongen = JSON.createGenerator(true);
        List<ivybase__Location_Hierarchy__c> territoryList = [SELECT Id, Name FROM ivybase__Location_Hierarchy__c 
                                                WHERE ivybase__Primary_Resource__r.Name =:res_name];
       if(territoryList.size()>0) 
        territory_id = territoryList[0].Id;
        List<DivisionLocation__c> divisionList = [SELECT Id, Division__c, Name 
                                                  FROM DivisionLocation__c WHERE Location_Hierarchy__c =:territory_id];
        Map<Id, ivybase__Store_Hierarchy__c> shMap;
        if(divisionList.size()>0)
         shMap = new Map<Id, ivybase__Store_Hierarchy__c>([SELECT Id, Name, Division__c, 
                                      ivybase__Parent__c, ivybase__Parent__r.ivybase__Parent__c,
                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c FROM ivybase__Store_Hierarchy__c
                                      WHERE ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Division__c =:divisionList[0].Division__c 
                                      AND ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName='Channel']);
        Set<String> routeIdSet = new Set<String>();
        for(Territory_Routing__c tr : [SELECT Id, Route__c FROM Territory_Routing__c WHERE Location_Hierarchy__c =:territory_id]) {
            routeIdSet.add(tr.Route__c);
        }
        Set<Id> accIdSet = new Set<Id>();
        for(ivybase__Route_Details__c rd : [SELECT Id, ivybase__Store__c FROM ivybase__Route_Details__c WHERE 
                                           ivybase__Route__r.ivybase__Active__c = 'Yes' AND ivybase__Active__c = 'Yes' 
                                           AND ivybase__Route__c IN :routeIdSet]) {
            accIdSet.add(rd.ivybase__Store__c);
        }
        for(Account acc : [SELECT Id, Name FROM Account WHERE ivybase__Resource__r.Name =:res_name]) {
            accIdSet.add(acc.Id);
        }
        Set<Id> discountIdSet = new Set<Id>();
        List<ivydsd__Discount_Mapping__c> discmaplist;
        if(shMap!=null)
        discmaplist = DiscountService.getDiscountFromDiscountMapping(shMap.keySet(),accIdSet);
        if(discmaplist!=null && discmaplist.size()>0)
        for(ivydsd__Discount_Mapping__c d:discmaplist) {
            discountIdSet.add(d.ivydsd__Discount__c); 
        }
        ///Json Formation sTARTED
        jsongen.writeStartObject();    
        jsongen.writeStringField('Next', '0');          
        jsongen.writeStringField('Master', 'DiscountProductMapping');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('DiscountId');
        jsongen.WriteString('ProductId');
        jsongen.WriteString('Value');
        jsongen.WriteString('IsPercentage');
        jsongen.WriteString('MinValue');
        jsongen.WriteString('MaxValue');
        jsongen.WriteString('toValue');
        jsongen.WriteString('IsBOM');
        jsongen.writeEndArray();      
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);   
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();
        jsongen.writeEndArray(); 
                                              
        jsongen.writeEndObject();
        jsonstring = jsongen.getAsString();
        //------ json END
        return Database.getQueryLocator('SELECT Id, ivydsd__Discounts__c, ivydsd__Discounts__r.Type__c, '
                    +'ivydsd__Discounts__r.ivydsd__Internal_Id__c,ivydsd__Product_Hierarchy__c, '
                    +'ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c, ivydsd__Product__c,'
                    +'Division__c, Division__r.Internal_Id__c, Division__r.Name, RelatedCustomerCode__c,'
                    +'ivydsd__Product__r.ivybase__InternalId__c, ivydsd__Value__c, Parent__c, ivydsd__Is_Percentage__c,'
                    +'ivydsd__Min_Slab__c, ivydsd__Max_Slab__c, ToValue__c FROM ivydsd__Discount_Detail__c WHERE '
                    +'ivydsd__Discounts__c =:discountIdSet AND (ivydsd__Product_Hierarchy__r.ivybase__Active__c = \'Yes\' OR '
                    +'ivydsd__Product__r.ivybase__Active__c = \'Yes\' )');
    }
    
    global void execute(Database.BatchableContext bc, List<ivydsd__Discount_Detail__c> disDetailList) {
        Set<Id> BOMDiscountDetail = new Set<Id>();
        Set<Id> BOMDiscountProduct = new Set<Id>();
        for(ivydsd__Discount_Detail__c dd : disDetailList) {
            if(dd.ivydsd__Value__c == null) {
                BOMDiscountDetail.add(dd.id);
                BOMDiscountProduct.add(dd.ivydsd__Product__c);
            }
        }
        Map<Id,Map<Id,Decimal>> BOMChildQuantity = new Map<Id,Map<Id,Decimal>> ();
        PricingConditions.getQuantityIfItsBOMProduct(BOMDiscountProduct,BOMChildQuantity);
        Map<Id,Map<Id,Decimal>> BOMFinalPrice = new Map<Id,Map<Id,Decimal>>();
        List<ivydsd__Discount_Detail__c> grandChildDiscountDetailEntry = new List<ivydsd__Discount_Detail__c>(
            DiscountService.getAllDiscountDetail_List_GrandChild(BOMDiscountDetail));
        grandChildDiscountDetailEntry.addAll(disDetailList);
        JSONParser obj = JSON.createParser(jsonstring);
        Map<String, Object> metadata_Map = new Map<String, Object>();
        metadata_Map = (Map<String, object>) JSON.deserializeUntyped(jsonstring);
        List<Object> lstObj = new List<Object>();
        list<Object> lst =  (list<object>)metadata_Map.get('Data');
        List<Object> ss = new List<Object>();
        ss.add(lst);
        
        if(grandChildDiscountDetailEntry.size() > 0){
            for(ivydsd__Discount_Detail__c  discdet: grandChildDiscountDetailEntry){
                LIST<STRING> SLIST= NEW LIST<StrING>();
                String s=''; 
                s='{"';
                if(discdet.Parent__c!=null)
                {
                    SLIST.add(string.valueof(Integer.valueOf(discdet.Parent__r.ivydsd__Discounts__r.ivydsd__Internal_Id__c)));
                } else if(discdet.ivydsd__Discounts__r.ivydsd__Internal_Id__c != null){
                   SLIST.add(string.valueof(Integer.valueOf(discdet.ivydsd__Discounts__r.ivydsd__Internal_Id__c)));
                }else{
                    SLIST.add('');
                }//DiscountId
                if(discdet.ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c != null){
                    SLIST.add(String.valueOf(Integer.valueOf(discdet.ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c)));
                }
                else if(discdet.ivydsd__Product__r.ivybase__InternalId__c != null){
                     SLIST.add(String.valueOf(Integer.valueOf(discdet.ivydsd__Product__r.ivybase__InternalId__c)));
                }
                else if(discdet.Division__r.Internal_Id__c != null)
                {
                    SLIST.add(String.valueOf(Integer.valueOf(discdet.Division__r.Internal_Id__c)));
                }
                else{
                    SLIST.add('');
                }//ProductId
                
                if(discdet.ivydsd__Value__c != null){
                   SLIST.add(String.valueOf(discdet.ivydsd__Value__c));
                }
                else{
                     SLIST.add('');
                }//Value
                
                if(discdet.ivydsd__Is_Percentage__c){
                   SLIST.add(string.valueof(1));
                    //jsongen.writeString('1');
                }else{
                   SLIST.add(string.valueof(1));
                }//IsPercentage
                
                if(discdet.ivydsd__Min_Slab__c != null){
                     SLIST.add(String.valueOf(discdet.ivydsd__Min_Slab__c));
                }else{
                     SLIST.add('');
                }//MinValue
                
                if(discdet.ivydsd__Max_Slab__c != null){
                   SLIST.add(String.valueOf(discdet.ivydsd__Max_Slab__c));
                }else{
                      SLIST.add('');
                }//MaxValue
                if(discdet.ToValue__c  != null){
                  SLIST.add(String.valueOf(discdet.ToValue__c ));
                }else{
                    SLIST.add('');
                }
                //toValue
                if(discdet.Parent__c!=null)
                {
                    SLIST.add(string.valueof(1)); 
                }
                else 
                {
                    SLIST.add(string.valueof(0)); 
                }
                //IsBom
                object s1=SLIST; 
                lst.add(s1);
            }
        }
        jsonstring = JSON.serialize(metadata_Map);
    }
    
    global void finish(Database.BatchableContext bc) {
        
        Folder f = [SELECT Id FROM Folder WHERE Name = 'Pricing Files' LIMIT 1];
        delete [SELECT Id FROM Document WHERE Name =:territory_id + '.json' AND FolderId =:f.Id];
        List<ivybase__Resource__c> resourceList = [SELECT Id, ivybase__Related_User__r.ivybase__Internal_Id__c, ivybase__Location_Hierarchy__c,
                                                   ivybase__Resource_Type__c FROM ivybase__Resource__c WHERE Name =:res_name LIMIT 1];
        List<ivybase__Standard_List_Master__c> oldslm;
        ivybase__Standard_List_Master__c slm;
        if(resourceList.size()>0)
         oldslm = new List<ivybase__Standard_List_Master__c>([SELECT Id FROM ivybase__Standard_List_Master__c 
                                                   WHERE ivybase__Flex1__c =:String.valueOf(resourceList[0].ivybase__Related_User__r.ivybase__Internal_Id__c)
                                                   AND ivybase__List_Code__c = 'PRICINGFILE' AND ivybase__List_Type__c = 'PRICINGFILE']);
        Document doc = generateDocument(territory_id + '.json', jsonstring, 'application/json', f.Id, 'json',res_name);
        insert doc;
        
        if(resourceList.size()>0)
         slm = new ivybase__Standard_List_Master__c(ivybase__List_Type__c = 'PRICINGFILE',
                                                ivybase__List_Code__c = 'PRICINGFILE',
                                                ivybase__Location_Hierarchy__c = resourceList[0].ivybase__Location_Hierarchy__c,
                                                ivybase__List_Name__c = '/services/data/v45.0/sobjects/Document/' + doc.Id + '/Body',
                                                ivybase__Resource_Type__c = resourceList[0].ivybase__Resource_Type__c,
                                                ivybase__Flex1__c = String.valueOf(
                                                    resourceList[0].ivybase__Related_User__r.ivybase__Internal_Id__c));
        if(slm!=null )
        slm.Id = oldslm != null && oldslm.isEmpty() == false ? oldslm[0].Id : null;
        if(oldslm != null && oldslm.size() > 1) { //This method is used to delete the SLM record if the user has created anything from backend and it won't be much
            for(ivybase__Standard_List_Master__c sl : oldslm) {
                delete sl;
            }
        }
        if(slm!=null)
        upsert slm;
        
        if(res_name != 'YEO ALISIA') {
            upsertSuggestedQuantityBatch batch = new upsertSuggestedQuantityBatch(); 
            database.executebatch(batch,10);
        }
        
    }
    //This method is used to assigning values for the document
    public static Document generateDocument(String file_name, String file_content, String content_type, Id folderId, String file_type,String recourceName) {
        
        Document doc = new Document();
        doc.Name = file_name;
        doc.ContentType = content_type;
        if(file_content.startsWith('base64,')) {
            file_content = file_content.replace('base64,','');
        }
        doc.Body = Blob.valueOf(file_content);
        doc.FolderId = folderId;
        doc.Type = file_type;
        doc.Description  = 'Resource Name:'+recourceName;
        
        return doc;
    }
}