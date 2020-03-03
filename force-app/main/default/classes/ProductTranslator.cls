public with sharing class ProductTranslator {
    
    public static String productMasterResponse(List<ivybase__Product_Hierarchy__c> prodHierarchyRecList, 
                                               List<ivybase__Product__c> productList, Map<String, String> SLMMap, 
                                               Map<Id, String> prodidwithuomMap, map<string,string> SubAxeLevelLovids, 
                                               List< ivybase__Standard_List_Master__c > prodRecList, 
                                               List<ivybase__Product_UOM__c> productUOMList, String errorCode) 
    {
        
        JSONGenerator jsongen = JSON.createGenerator(true);
        jsongen.writeStartObject();
        jsongen.writeFieldName('Tables');
        jsongen.writeStartArray();
        
        jsongen.writeStartObject(); 
        jsongen.writeStringField('Next', '0');       
        jsongen.writeStringField('Master', 'temp_productuommaster');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('PID');
        jsongen.WriteString('UomId');
        jsongen.WriteString('UomQty');
        jsongen.WriteString('UomBarCode');
        jsongen.WriteString('UomName');
        jsongen.writeEndArray();
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();
        
        objectToProductUOMInfo(jsongen, productUOMList, errorCode); //Need to map data
        
        jsongen.writeEndArray();
        jsongen.writeStringField('Next', '0');
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);
        jsongen.writeEndObject();
       productUOMList.clear();
        
        jsongen.writeStartObject();            
        jsongen.writeStringField('Master', 'temp_productmaster');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('PID');
        jsongen.WriteString('PName');
        jsongen.WriteString('pCode');
        jsongen.WriteString('psname');
        jsongen.WriteString('barcode');
        jsongen.WriteString('TypeID');
        jsongen.WriteString('PLid');
        jsongen.WriteString('ParentId');
        jsongen.WriteString('PTypeId');
        jsongen.WriteString('isReturnable');
        jsongen.WriteString('isBom');
        jsongen.WriteString('issalable');
        jsongen.WriteString('isfocus');
        jsongen.WriteString('msqQty');
        jsongen.WriteString('isMust');
        jsongen.WriteString('maxQty');
        jsongen.WriteString('Sih');
        jsongen.WriteString('suggestqty');
        jsongen.WriteString('IsAlloc');
        jsongen.WriteString('Weight');
        jsongen.WriteString('Hasserial');
        jsongen.WriteString('tagDescription');
        jsongen.WriteString('defaultUOM');
        jsongen.WriteString('RField1');
        jsongen.WriteString('ParentHierarchy');
        jsongen.WriteString('CustomHierarchy');
        jsongen.WriteString('RField2');
        jsongen.WriteString('RField3');
        
        jsongen.writeEndArray();        
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();
        
        
        objectToProductInfo(jsongen, prodHierarchyRecList, productList, SLMMap, prodidwithuomMap, SubAxeLevelLovids, errorCode);
        
        jsongen.writeEndArray(); 
        
        jsongen.writeStringField('Next', '0');
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);                 
        jsongen.writeEndObject();
        
        //system.debug('jsongen====='+jsongen);  
        
        // Product Level
        
        jsongen.writeStartObject(); 
        jsongen.writeStringField('Next', '0');       
        jsongen.writeStringField('Master', 'ProductLevel');
        
        jsongen.writeFieldName('Field');
        jsongen.writeStartArray();
        jsongen.WriteString('LevelId');
        jsongen.WriteString('LevelName');
        jsongen.WriteString('ParentId');
        jsongen.WriteString('Sequence');
        jsongen.writeEndArray();
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);
        jsongen.writeFieldName('Data');
        jsongen.writeStartArray();
        
        objectToProductLevelInfo(jsongen, prodRecList, errorCode);        
        
        jsongen.writeEndArray();
        jsongen.writeStringField('Next', '0');
        jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);
        jsongen.writeEndObject();
        
        
        /*jsongen.writeStartObject(); 
jsongen.writeStringField('Next', '0');       
jsongen.writeStringField('Master', 'temp_productuommaster');

jsongen.writeFieldName('Field');
jsongen.writeStartArray();
jsongen.WriteString('PID');
jsongen.WriteString('UomId');
jsongen.WriteString('UomQty');
jsongen.WriteString('UomBarCode');
jsongen.WriteString('UomName');
jsongen.writeEndArray();
jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);
jsongen.writeFieldName('Data');
jsongen.writeStartArray();

objectToProductUOMInfo(jsongen, productUOMList, errorCode); //Need to map data

jsongen.writeEndArray();
jsongen.writeStringField('Next', '0');
jsongen.writeStringField('ErrorCode', errorCode == null ? '0' : errorCode);
jsongen.writeEndObject();*/
        
        jsongen.writeEndArray();
        jsongen.writeEndObject();
        
        return jsongen.getAsString();
    }
    
    public static void objectToProductInfo(JSONGenerator jsongen, List<ivybase__Product_Hierarchy__c> prodHierarchyRecList, 
                                           List<ivybase__Product__c> productList, 
                                           Map<String, String> SLMMap, 
                                           Map<Id, String> prodidwithuomMap,
                                           map<string,string> SubAxeLevelLovids,
                                           String errorCode) 
    {
        
        
        Map<String,String> productHierarchyMapInternalId = new Map<String,String>();
        Map<String,String> productMapInternalId = new Map<String,String>();
        
        if(prodHierarchyRecList != null) {
            for(ivybase__Product_Hierarchy__c ph:prodHierarchyRecList)
            {
                productHierarchyMapInternalId.put(ph.ivybase__Internal_Id__c,ph.ivybase__Parent__r.ivybase__Internal_Id__c==null?null:ph.ivybase__Parent__r.ivybase__Internal_Id__c);
            }
        }
        if(productList != null) {
            for(ivybase__Product__c p:productList)
            {
                productMapInternalId.put(String.valueOf(p.ivybase__InternalId__c),p.ivybase__Parent__r.ivybase__Internal_Id__c==null?null: String.valueOf(p.ivybase__Parent__r.ivybase__Internal_Id__c));
            }
        }
        Set<Id> WarehouseId = new Set<Id>();
        Map<String,String> productQuantityMap = new Map<String,String>();
        if(errorCode == null) {
            WarehouseId = LocationService.getAllWarehouseId();
            productQuantityMap = LocationStockService.getProductAndQuantityMapFromWarehouse(WarehouseId);
            //system.debug('productQuantityMap'+productQuantityMap);
        }
        if(prodHierarchyRecList != null && errorCode == null) {
            for (ivybase__Product_Hierarchy__c prod: prodHierarchyRecList) {
                string recordtypename=prod.RecordType.Name;
                if(recordtypename=='Bill Of Material SKU'){
                    recordtypename='Product SKU'; 
                }
                if(prod.RecordTypeid != null && SLMMap.containsKey(recordtypename)) {
                    translateProdHierarchyObj(jsongen, prod, SLMMap.get(recordtypename),productHierarchyMapInternalId);                   
                } else {
                    translateProdHierarchyObj(jsongen, prod, NULL,productHierarchyMapInternalId);                    
                }
            }
        }
        
        prodHierarchyRecList.clear();
        
        if(productList != null && errorCode == null) {
            for (ivybase__Product__c prod: productList) {
                string subaxelovid;
                if(SubAxeLevelLovids.keyset().contains(prod.id))
                    subaxelovid=SubAxeLevelLovids.get(prod.id);
                else
                    subaxelovid=Null;
                String defaultuom = '';
                String Uoms = prodidwithuomMap != NULL ? prodidwithuomMap.get(prod.Id) : '';
                
                if(prod.ivybase__Default_UOM__c != null && SLMMap.containsKey(prod.ivybase__Default_UOM__c)){
                    defaultuom = SLMMap.get(prod.ivybase__Default_UOM__c);
                }
                //system.debug('prod.RecordType.Name'+prod.RecordType.Name);
                string recordtypename=prod.RecordType.Name;
                if(recordtypename=='Bill Of Material SKU'){
                    recordtypename='Product SKU'; 
                }
                if(prod.RecordTypeid != null && SLMMap.containsKey(recordtypename)) {
                    translateProdObj(jsongen, prod, SLMMap.get(recordtypename),defaultuom,Uoms,productHierarchyMapInternalId,productMapInternalId,productQuantityMap,subaxelovid);
                    
                } else {
                    translateProdObj(jsongen, prod, NULL,defaultuom,Uoms,productHierarchyMapInternalId,productMapInternalId,productQuantityMap,subaxelovid);
                    
                }
            }
        }                
    }
    
    public static void translateProdHierarchyObj(JSONGenerator jsongen, ivybase__Product_Hierarchy__c prod, String prodLevelId,Map<String,String> productHierarchyMapInternalId) {
        
        jsongen.writeStartArray();
        
        jsongen.writeString(prod.ivybase__Internal_Id__c);//prodId
        string prodname= prod.name;
        prodname=prodname.replace('\"', '');
        jsongen.writeString(prodname);//prodName
        jsongen.writeString('');//prodCode
        if (prod.ivybase__Description__c != null) {
            string descrp= prod.ivybase__Description__c;
            descrp=descrp.replace('\"', '');
            jsongen.writeString(descrp);//psname
        } else if (prod.Name != null) {
            jsongen.writeString(prodname);//psname
        } else {
            jsongen.writeString('');//psname
        }
        jsongen.writeString('');//barcode
        jsongen.writeString('');//TypeID
        if (!String.isBlank(prodLevelId)) {
            jsongen.writeString(prodLevelId);//PLid
        } else {
            jsongen.writeString('');//PLid
        }
        if (prod.ivybase__Parent__c != null && prod.ivybase__Parent__r.ivybase__Internal_Id__c != null && prod.ivybase__Parent__r.ivybase__Internal_Id__c != '') {
            jsongen.writeString(prod.ivybase__Parent__r.ivybase__Internal_Id__c);//prodParentId
        } else {
            jsongen.writeString('0');//prodParentId Blank
        }
        jsongen.writeString('');//PTypeId
        jsongen.writeString('');//isReturnable
        jsongen.writeString('');//isBom    
        jsongen.writeString('');//issalable
        jsongen.writeString('');//isfocus
        jsongen.writeString('');//msqQty
        jsongen.writeString('');//isMust
        jsongen.writeString('');//maxQty
        jsongen.writeString('');//Sih
        jsongen.writeString('');//suggestqty
        jsongen.writeString('1');//IsAlloc
        jsongen.writeString('');//Weight
        jsongen.writeString('');//Hasserial
        jsongen.writeString('');//tagDescription
        jsongen.writeString('');//defaultUOM
        jsongen.writeString('');//RField1
        
        if(productHierarchyMapInternalId.containsKey(String.valueOf(prod.ivybase__Internal_Id__c)) && productHierarchyMapInternalId.get(String.valueOf(prod.ivybase__Internal_Id__c))!=null)
        {
            String hierarchy='/'+productHierarchyMapInternalId.get(String.valueOf(prod.ivybase__Internal_Id__c))+'/';
            String temp = productHierarchyMapInternalId.get(String.valueOf(prod.ivybase__Internal_Id__c));
            if(productHierarchyMapInternalId.containsKey(temp) && productHierarchyMapInternalId.get(temp)!=null)
            {
                //system.debug('temp'+temp);
                String level=productHierarchyMapInternalId.get(temp);
                //system.debug('level'+level);
                while(level!=null){
                    hierarchy=hierarchy+''+level+'/';
                    if(productHierarchyMapInternalId.containsKey(level))
                    {
                        level=productHierarchyMapInternalId.get(level);
                    }
                }
            }
            hierarchy=hierarchy+'0/';
            jsongen.writeString(hierarchy);//ParentHierarchy
        }
        else{
            jsongen.writeString('/0/');//ParentHierarchy
        }
        jsongen.writeString('');
        jsongen.writeString('');
        jsongen.writeString('');
        jsongen.writeEndArray();
    }
    
    public static void translateProdObj(JSONGenerator jsongen, ivybase__Product__c prod, String prodLevelId,String defaultUOM,
                                        String Uoms,Map<String,String> productHierarchyMapInternalId,Map<String,
                                        String> productMapInternalId,Map<String,String> productQuantityMap,string subaxelovId) 
    {
        
        jsongen.writeStartArray();
        
        jsongen.writeString(String.valueOf(prod.ivybase__InternalId__c));//prodId
        jsongen.writeString(prod.Name);//prodName
        if (prod.ivybase__Code__c != null) {
            jsongen.writeString(prod.ivybase__Code__c.endsWith('300') ||prod.ivybase__Code__c.endsWith('200') ? prod.ivybase__Code__c.subString(0, prod.ivybase__Code__c.length()-4) : prod.ivybase__Code__c);
        } else {
            jsongen.writeString('');
        }
        if (prod.ivybase__Short_Description__c != null) {
            jsongen.writeString(prod.ivybase__Short_Description__c);
        } else if (prod.ivybase__Full_Description__c != null) {
            jsongen.writeString(prod.ivybase__Full_Description__c);
        } else if (prod.Name != null ) {
            jsongen.writeString(prod.Name);
        } else {
            jsongen.writeString('');
        }
        jsongen.writeString(prod.ivybase__Barcode__c != null ? String.valueOf(prod.ivybase__Barcode__c) : '');//barcode
        jsongen.writeString('');//TypeID
        if (!String.isBlank(prodLevelId)) {
            jsongen.writeString(prodLevelId);//PLid
        } else {
            jsongen.writeString('');//PLid
        }
        if (prod.ivybase__Parent__c != null && prod.ivybase__Parent__r.ivybase__Internal_Id__c != null && prod.ivybase__Parent__r.ivybase__Internal_Id__c != '') {
            jsongen.writeString(prod.ivybase__Parent__r.ivybase__Internal_Id__c);//prodParentId
        } else {
            jsongen.writeString('0');//prodParentId Blank
        }
        jsongen.writeString('');//PTypeId
        jsongen.writeString(prod.ivybase__Returnable__c != null && prod.ivybase__Returnable__c ? '1'  : '0');//isReturnable
        if (prod.Recordtype.Name == 'Bill Of Material SKU') {
            jsongen.writeString('1');//isBom    
        } else {
            jsongen.writeString('0');//isBom
        }
        jsongen.writeString(prod.ivybase__Non_Saleable__c ? '0': '1');//issalable
        jsongen.writeString('');//isfocus
        jsongen.writeString('');//msqQty
        jsongen.writeString('');//isMust
        jsongen.writeString('');//maxQty
        if(productQuantityMap.containsKey(String.valueOf(prod.ivybase__InternalId__c)))
        {
            if(productQuantityMap.get(String.valueOf(prod.ivybase__InternalId__c))!=null){
                jsongen.writeString(productQuantityMap.get(String.valueOf(prod.ivybase__InternalId__c)));//sih
            }
            else
            {
                jsongen.writeString('');//Sih                
            }
            
        }
        else{
            jsongen.writeString('');//Sih
        }
        jsongen.writeString('');//suggestqty
        jsongen.writeString('1');//IsAlloc
        jsongen.writeString('');//Weight
        jsongen.writeString('');//Hasserial
        jsongen.writeString(prod.ivybase__Full_Description__c != null ? prod.ivybase__Full_Description__c : '');//tagDescription
        jsongen.writeString(defaultUOM != null ? defaultUOM : '');//defaultUOM
        jsongen.writeString(Uoms != null ? Uoms : '');//RField1
        
        if(productMapInternalId.containsKey(String.valueOf(prod.ivybase__InternalId__c)) && productMapInternalId.get(String.valueOf(prod.ivybase__InternalId__c))!=null)
        {
            String hierarchy='/'+productMapInternalId.get(String.valueOf(prod.ivybase__InternalId__c))+'/';
            if(productHierarchyMapInternalId.containsKey(productMapInternalId.get(String.valueOf(prod.ivybase__InternalId__c))) && productHierarchyMapInternalId.get(productMapInternalId.get(String.valueOf(prod.ivybase__InternalId__c)))!=null)
            {
                String level=productHierarchyMapInternalId.get(productMapInternalId.get(String.valueOf(prod.ivybase__InternalId__c)));
                while(level!=null){
                    hierarchy=hierarchy+''+level+'/';
                    if(productHierarchyMapInternalId.containsKey(level))
                    {
                        level=productHierarchyMapInternalId.get(level);
                    }
                }
            }
            hierarchy =hierarchy+'0/';
            jsongen.writeString(hierarchy);//ParentHierarchy
        }
        else{
            jsongen.writeString('');//ParentHierarchy
        }
        if(subaxelovId != null) {
            jsongen.writeString(subaxelovId);//CustomHirarichy
        } else {
            jsongen.writeString('');
        }
        if(prod.IsPackage__c){
            jsongen.writeString('1');
        }else{
            jsongen.writeString('0');// if it is package then sending as 1 on rfield2 
        }
        if(prod.Promotion_Item_Type__c!=null){
            jsongen.writeString(prod.Promotion_Item_Type__c);
        }else{
            jsongen.writeString('0');// if promotion pacakage is no  null then sending as 1 on rfield3 
        }
        jsongen.writeEndArray();
    }
    
    public static void objectToProductLevelInfo(JSONGenerator jsongen, List< ivybase__Standard_List_Master__c > prodRecList,  String errorCode) {
        
        
        if(prodRecList != null) {
            
            Map<String, Integer> prodSequence = StandardListMasterTranslator.getRecordIdwithSeqNumber(prodRecList);
            objectToProdInfo(jsongen, prodRecList, prodSequence, errorCode );
        } 
    }
    
    public static void objectToProdInfo(JSONGenerator jsongen, List<ivybase__Standard_List_Master__c> prodList, Map<String, Integer> prodSequence, String errorCode) {
        
        Map<integer, ivybase__Standard_List_Master__c> squenceWithProductOrder = new Map<integer, ivybase__Standard_List_Master__c>();
        List<List<String>> prodTempList = new List<List<String>>();
        
        List<List<String>> productLevelList = new List<List<String>>();
        
        if(prodList != null && errorCode == null) {
            for (ivybase__Standard_List_Master__c prod :prodList) {
                
                if (prodSequence  != null && prodSequence.size() > 0 && prodSequence.containsKey(prod.Id)) {
                    
                    squenceWithProductOrder.put(prodSequence.get(prod.Id), prod);
                }
            }
        }
        
        if (squenceWithProductOrder.size() > 0) {
            
            List<Integer> sequenceNumber = new List<Integer>();
            sequenceNumber.addAll(squenceWithProductOrder.keySet());
            sequenceNumber.sort();
            prodList = new List<ivybase__Standard_List_Master__c>();
            for (Integer keyV :sequenceNumber) {
                prodList.add(squenceWithProductOrder.get(keyV));
            }
        }
        
        for (ivybase__Standard_List_Master__c prod :prodList) {
            
            jsongen.writeStartArray();
            jsongen.writeString(prod.Name);//id
            jsongen.writeString(prod.ivybase__List_Name__c);//name
            if(prod.ivybase__Parent_Id__c != NULL) {
                jsongen.writeString(prod.ivybase__Parent_Id__r.Name);//Parentid
            } else {
                jsongen.writeString('0');//Parentid blank
            }
            if (prodSequence  != null && prodSequence.size() > 0 && prodSequence.containsKey(prod.Id)) {
                jsongen.writeString(String.valueOf(prodSequence.get(prod.Id)));//Sequence
            } else {
                jsongen.writeString('');//Sequence
            }
            jsongen.writeEndArray();
        }        
    }
    
    public static void objectToProductUOMInfo(JSONGenerator jsongen, List<ivybase__Product_UOM__c> productUOMList, String errorCode ) {
        
        
        Map<String,ivybase__Standard_List_Master__c> listTypeStdMasterMap = new Map<String,ivybase__Standard_List_Master__c>();
        List<String> slm = new List<String>();
        slm.add('PRODUCT_UOM');
        
        if(productUOMList != null && errorCode == null ) {
            
            for(ivybase__Standard_List_Master__c stdMtr: StandardListMasterService.getStandardListUsingListType(slm)){
                listTypeStdMasterMap.put(stdMtr.ivybase__List_Name__c,stdMtr);
            }
            //system.debug('listTypeStdMasterMap'+listTypeStdMasterMap);        
            
            for (ivybase__Product_UOM__c prodUOM: productUOMList) {
                
                jsongen.writeStartArray();
                
                jsongen.writeString( prodUOM.ivybase__Product__c != null ? String.valueOf(prodUOM.ivybase__Product__r.ivybase__InternalId__c):'');
                jsongen.writeString( listTypeStdMasterMap.containsKey(prodUOM.ivybase__UOM__c) ? listTypeStdMasterMap.get(prodUOM.ivybase__UOM__c).Name:'0');
                jsongen.writeString(prodUOM.ivybase__Conversion_Factor__c != null ? String.valueOf(prodUOM.ivybase__Conversion_Factor__c):'0');
                jsongen.writeString( prodUOM.ivybase__Product__r.ivybase__Barcode__c!= null ? string.valueof(prodUOM.ivybase__Product__r.ivybase__Barcode__c).replaceAll(',', '') :''); 
                jsongen.writeString( listTypeStdMasterMap.containsKey(prodUOM.ivybase__UOM__c) ? listTypeStdMasterMap.get(prodUOM.ivybase__UOM__c).ivybase__List_Code__c.toUpperCase():'0');
                
                jsongen.writeEndArray();
            }
        }                
    }
}