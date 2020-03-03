public with sharing class SchemeTranslator {

    public static RExAPIResponseDomain.ResponseInfo getSchemeInfo(List<ivydsd__Scheme_Slab__c> schemaSlablist,String errorcode ){
        
        RExAPIResponseDomain.ResponseInfo schemaMaster = new RExAPIResponseDomain.ResponseInfo();
        schemaMaster.Master = 'SchemeMaster';
        schemaMaster.Field = new List<String> {'Description','Type','ShortName','parentid','buyType','SchemeID','IsOnInvoice','SchemeValue','GetTypeLogic','StartDate','EndDate'};
       
        
        List<List<String>> schmeListRec = new List<List<String>>();
        
        if(schmeListRec != null && errorCode == null) {
        
            for (ivydsd__Scheme_Slab__c schemeSlab: schemaSlablist) {
                                    
                List<String> stdRec = new List<String>();
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__Description__c != null )? schemeSlab.ivydsd__Scheme__r.ivydsd__Description__c:'');
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__Scheme_Buy_Logic__c != null) ? schemeSlab.ivydsd__Scheme__r.ivydsd__Scheme_Buy_Logic__c:'');
                stdRec.add((schemeSlab.ivydsd__Scheme__r.Name != null) ? schemeSlab.ivydsd__Scheme__r.Name:'' );
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__Internal_Id__c != null ) ? schemeSlab.ivydsd__Scheme__r.ivydsd__Internal_Id__c:'0');
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__Scheme_Type__c != null ) ? schemeSlab.ivydsd__Scheme__r.ivydsd__Scheme_Type__c:'');
                stdRec.add((schemeSlab.ivydsd__Internal_Id__c != null) ? schemeSlab.ivydsd__Internal_Id__c:'0');
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__IsOnInvoice__c != null && schemeSlab.ivydsd__Scheme__r.ivydsd__IsOnInvoice__c == true) ? '1' : '0'); //IsOnInvoice
                stdRec.add((schemeSlab.ivydsd__Scheme__r.Scheme_Value__c != null ) ? string.valueof(schemeSlab.ivydsd__Scheme__r.Scheme_Value__c):'');
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__Scheme_Get_Logic__c != null) ? schemeSlab.ivydsd__Scheme__r.ivydsd__Scheme_Get_Logic__c:'');
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__From__c != null) ? string.valueOf(schemeSlab.ivydsd__Scheme__r.ivydsd__From__c):''); //StartDate
                stdRec.add((schemeSlab.ivydsd__Scheme__r.ivydsd__To__c != null) ? string.valueOf(schemeSlab.ivydsd__Scheme__r.ivydsd__To__c):''); //EndDate
                schmeListRec.add(stdRec);
            }
        }
        
        schemaMaster.Data = schmeListRec;
        schemaMaster.ErrorCode = errorCode == null ? '0' : errorCode;
        schemaMaster.Next = '0';
        return schemaMaster;
    }
    
    public static RExAPIResponseDomain.ResponseInfo getSchemeBuyInfo(Map<Id, List<ivydsd__Scheme_Slab_Target__c>> sGroupIdAndSSTargetListMap,List<ivydsd__Scheme_Group_Product__c> schemeGroupProductList,Map<String,String> UOMAndInternalIdMap,List<ivybase__Standard_List_Master__c> stdList,list<ivydsd__Scheme_Group__c> schemegrouplist, String errorcode ){
       
        List<ivybase__Standard_List_Master__c> stdList1 = new List<ivybase__Standard_List_Master__c>();
        List<String> ListType = new List<String>();
            ListType.add('PRODUCT_HIERARCHY');
        ListType.add('PRODUCT_UOM');
            stdList1 = StandardListMasterService.getStandardListUsingListType(ListType);
        system.debug('stdList1'+ stdList1);
        map<string,string> stndListMap= new  map<string,string>();
        for(ivybase__Standard_List_Master__c std:stdList1){
        stndListMap.put(std.ivybase__List_Code__c,std.Name);
        }
        system.debug('stndListMap-->'+stndListMap);
        RExAPIResponseDomain.ResponseInfo schemaBuyMaster = new RExAPIResponseDomain.ResponseInfo();
        schemaBuyMaster.Master = 'SchemeBuyMaster';
        schemaBuyMaster.Field = new List<String> {'SchemeID','ProductID','BuyQty','GroupName','GroupType','UomId','ToBuyQty','GroupId','BuyType','ProductLevelId'};
        Map<String, String> UOMNameWithIdMap = stdMap(stdList);
        map<id,set<id>> prdgrpprdidset= new map<id,set<id>>();
        List<List<String>> schemeBuyListRec = new List<List<String>>();
        
        if( sGroupIdAndSSTargetListMap != null && sGroupIdAndSSTargetListMap.size() > 0 && errorCode == null) {
                if(schemeGroupProductList.size()>0){
            for (ivydsd__Scheme_Group_Product__c sgp: schemeGroupProductList) {
                system.debug(':::::sgp:::'+sgp);
                
                if (sGroupIdAndSSTargetListMap.containsKey(sgp.ivydsd__Scheme_Group__c)) {
                    for( ivydsd__Scheme_Slab_Target__c sstarget :sGroupIdAndSSTargetListMap.get(sgp.ivydsd__Scheme_Group__c)){
                        
                        if((prdgrpprdidset.containsKey(sgp.id)==false || prdgrpprdidset.get(sgp.id).contains(sgp.ivydsd__Product1__c)==false) && (sgp.ivydsd__Product1__c==sstarget.Product_Master__c||sstarget.Product_Master__c==null  )){
                            if(prdgrpprdidset.containsKey(sgp.id)==false){
                            Set<id> prod = new Set<Id>();
                            prod.add(sgp.ivydsd__Product1__c);
                            prdgrpprdidset.put(sgp.id,prod);
                            }
                            else
                            {
                                prdgrpprdidset.get(sgp.id).add(sgp.ivydsd__Product1__c);
                            }
                        
                        
                        //if(sgp.ivydsd__Product1__c==sstarget.Product_Master__c||sstarget.Product_Master__c==null  ){
                        List<String> sgpRec = new List<String>();
                        system.debug(':::::sstarget:::'+sstarget);
                        sgpRec.add( (sstarget.ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c != null) ? sstarget.ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c:'0');
                        if(sgp.Product_Hierarchy__c!=null){
                            sgpRec.add( (sgp.Product_Hierarchy__r.ivybase__Internal_Id__c != null) ? String.valueOf(sgp.Product_Hierarchy__r.ivybase__Internal_Id__c):'0');
                        }else{
                        sgpRec.add( (sgp.ivydsd__Product1__r.ivybase__InternalId__c != null) ? String.valueOf(sgp.ivydsd__Product1__r.ivybase__InternalId__c):'0');
                        }
                        //adding the new changes checking the same product with slab trget and prodcut grp prod
                        if(sgp.ivydsd__Product1__c==sstarget.Product_Master__c){
                           sgpRec.add( (sstarget.ivydsd__Minimum_Value__c != null) ? String.valueOf(sstarget.ivydsd__Minimum_Value__c):'0');  
                        }
                        else if(sstarget.Product_Master__c==null){
                            sgpRec.add( (sstarget.ivydsd__Minimum_Value__c != null) ? String.valueOf(sstarget.ivydsd__Minimum_Value__c):'0');
                        }
                        sgpRec.add( (sgp.ivydsd__Scheme_Group__r.Name != null ) ? sgp.ivydsd__Scheme_Group__r.Name:'');
                        sgpRec.add( (sgp.ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c != null ) ?sgp.ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c:'');
                        /*if( UOMAndInternalIdMap != null && UOMAndInternalIdMap.containsKey(String.valueOf(sgp.ivydsd__Product1__r.ivybase__InternalId__c)) == true) {
                            if(UOMNameWithIdMap.containsKey(UOMAndInternalIdMap.get(String.valueOf(sgp.ivydsd__Product1__r.ivybase__InternalId__c))))
                            {
                             sgpRec.add(UOMNameWithIdMap.get(UOMAndInternalIdMap.get(String.valueOf(sgp.ivydsd__Product1__r.ivybase__InternalId__c))));   
                            }
                            else
                            {
                            sgpRec.add('');
                            }
                            
                        } else {
                            sgpRec.add('');
                        }*/
                            if(stndListMap!= null ) {
                            if(stndListMap.containsKey('Piece'))
                            {
                                system.debug('inside piece'+ stndListMap.get('Piece'));
                             sgpRec.add(stndListMap.get('Piece'));   
                            }
                            else
                            {
                            sgpRec.add('');
                            }
                            
                        } else {
                            sgpRec.add('');
                        }
                        if(sstarget.ivydsd__Minimum_Value__c!=null){
                            sgpRec.add(String.valueOf(sstarget.ivydsd__Minimum_Value__c));
                        }
                        else{
                        sgpRec.add('');
                        }
                        //  sgpRec.add(String.valueOf(sstarget.ivydsd__Maximum_Value__c));
                        sgpRec.add( (sgp.ivydsd__Scheme_Group__r.Internal_Id__c != null ) ? String.valueOf(sgp.ivydsd__Scheme_Group__r.Internal_Id__c):'');
                        sgpRec.add((sstarget.Type__c!=null)? sstarget.Type__c:'');
                        if(sgp.Product_Hierarchy__c!=null && stndListMap!=null && stndListMap.containsKey(sgp.Product_Hierarchy__r.RecordType.name)){
                        sgpRec.add(String.valueOf(stndListMap.get(sgp.Product_Hierarchy__r.RecordType.name)));
                        }
                        
                       else if(sgp.ivydsd__Product1__c!=null && stndListMap!=null && stndListMap.containsKey(sgp.ivydsd__Product1__r.RecordType.name)){
                           system.debug('STD CHECK '+stndListMap.containsKey(sgp.ivydsd__Product1__r.RecordType.name) + stndListMap.get(sgp.ivydsd__Product1__r.RecordType.name) );
                            sgpRec.add(String.valueOf(stndListMap.get(sgp.ivydsd__Product1__r.RecordType.name)));
                        }else{
                            sgpRec.add('');
                        }
                        
                        schemeBuyListRec.add(sgpRec);
                    }
                    }
                }                
                
            }
                } 
            /*if(schemegrouplist.size()>0){
                
                for (ivydsd__Scheme_Group__c sgp: schemegrouplist) {
                system.debug(':::::sgp:::'+sgp);
                
                if (sGroupIdAndSSTargetListMap.containsKey(sgp.id)) {
                    for( ivydsd__Scheme_Slab_Target__c sstarget :sGroupIdAndSSTargetListMap.get(sgp.id)){
                        List<String> sgpRec = new List<String>();
                        system.debug(':::::sstarget:::'+sstarget);
                        sgpRec.add( (sstarget.ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c != null) ? sstarget.ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c:'0');
                        if(sgp.Product_Hierarchy__c!=null){
                            sgpRec.add( (sgp.Product_Hierarchy__r.ivybase__Internal_Id__c != null) ? String.valueOf(sgp.Product_Hierarchy__r.ivybase__Internal_Id__c):'0');
                        }else{
                        sgpRec.add( '');
                        }
                            sgpRec.add( (sstarget.ivydsd__Minimum_Value__c != null) ? String.valueOf(sstarget.ivydsd__Minimum_Value__c):'0');
                        sgpRec.add( (sgp.Name != null ) ? sgp.Name:'');
                        sgpRec.add( (sgp.ivydsd__Group_Logic__c != null ) ?sgp.ivydsd__Group_Logic__c:'');
                        if( stndListMap != null ) {
                            if(stndListMap.containsKey('PIECE'))
                            {
                             sgpRec.add(stndListMap.get('PIECE'));   
                            }
                            else
                            {
                            sgpRec.add('');
                            }
                            
                        } //else {
                            //sgpRec.add('');
                        //}
                        if(sstarget.ivydsd__Minimum_Value__c!=null){
                            sgpRec.add(String.valueOf(sstarget.ivydsd__Minimum_Value__c));
                        }
                        else{
                        sgpRec.add('');
                        }
                        //  sgpRec.add(String.valueOf(sstarget.ivydsd__Maximum_Value__c));
                        sgpRec.add( (sgp.Internal_Id__c != null ) ? String.valueOf(sgp.Internal_Id__c):'');
                        sgpRec.add((sstarget.Type__c!=null)? sstarget.Type__c:'');
                        if(sgp.Product_Hierarchy__c!=null && stndListMap!=null && stndListMap.containsKey(sgp.Product_Hierarchy__r.RecordType.name)){
                        sgpRec.add(String.valueOf(stndListMap.get(sgp.Product_Hierarchy__r.RecordType.name)));
                        }
                        
                        else{
                            sgpRec.add('');
                        }
                        
                        schemeBuyListRec.add(sgpRec);
                    }
                }                
                
            }
                
                
                
                }*/
        }
        schemaBuyMaster.Data = schemeBuyListRec;
        schemaBuyMaster.ErrorCode = errorCode == null ? '0' : errorCode;
        schemaBuyMaster.Next = '0';
        return schemaBuyMaster;
    }
    public static RExAPIResponseDomain.ResponseInfo getSchemeFreeDetailInfo(Map<Id, ivydsd__Scheme_Free_Detail__c> schemeFreeDetailMap, String errorcode ){
        
        RExAPIResponseDomain.ResponseInfo schemaFreeMaster = new RExAPIResponseDomain.ResponseInfo();
        schemaFreeMaster.Master = 'SchemeFreeMaster';
        schemaFreeMaster.Field = new List<String> { 'SchemeID', 'Rate', 'MaxRate', 'amount', 'percent', 'maxPercent', 'maxAmount', 'Type','GroupId'};       
        
        List<List<String>> schemeFreeDetails = new List<List<String>>();
        
        if(schemeFreeDetailMap != null && schemeFreeDetailMap.size() > 0 && schemeFreeDetailMap.values().size() > 0 && errorCode == null) {
        
            for (ivydsd__Scheme_Free_Detail__c schemefreeDetail: schemeFreeDetailMap.values()) {
                                    
                List<String> schemeFreeDetailRec = new List<String>();
                schemeFreeDetailRec.add(schemefreeDetail.ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c);
                if (schemefreeDetail.ivydsd__Rate_Discount__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Rate_Discount__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                if (schemefreeDetail.ivydsd__Maximum_Rate_Discount__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Maximum_Rate_Discount__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                if (schemefreeDetail.ivydsd__Price_Discount__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Price_Discount__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                if (schemefreeDetail.ivydsd__Percentage_Discount__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Percentage_Discount__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                if (schemefreeDetail.ivydsd__Maximum_Percentage_Discount__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Maximum_Percentage_Discount__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                if (schemefreeDetail.ivydsd__Maximum_Price_Discount__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Maximum_Price_Discount__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                
                schemeFreeDetailRec.add(String.isNotBlank(schemefreeDetail.ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c) ? schemefreeDetail.ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c : '');
                if (schemefreeDetail.ivydsd__Scheme_Group__r.Internal_Id__c != null) {
                    schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Scheme_Group__r.Internal_Id__c));
                } else {
                    schemeFreeDetailRec.add('');
                }
                schemeFreeDetails.add(schemeFreeDetailRec);
            }
        }        
        schemaFreeMaster.Data = schemeFreeDetails;
        schemaFreeMaster.ErrorCode = errorCode == null ? '0' : errorCode;
        schemaFreeMaster.Next = '0';
        return schemaFreeMaster;
    }
    
    public static RExAPIResponseDomain.ResponseInfo getSchemeFreeProductsInfo(List<ivydsd__Scheme_Group_Product__c> schemeFreeProductsList, Map<Id, List<ivydsd__Scheme_Free_Detail__c>> schemegroupIdwithSchemeFreeDetailMap, List<ivybase__Standard_List_Master__c> stdList, String errorcode) {
         List<ivybase__Standard_List_Master__c> stdList1 = new List<ivybase__Standard_List_Master__c>();
        List<String> ListType = new List<String>();
            ListType.add('PRODUCT_HIERARCHY');
            ListType.add('PRODUCT_UOM');
            stdList1 = StandardListMasterService.getStandardListUsingListType(ListType);
        map<string,string> stndListMap= new  map<string,string>();
        for(ivybase__Standard_List_Master__c std:stdList1){
        stndListMap.put(std.ivybase__List_Code__c,std.Name);
        }
        
        RExAPIResponseDomain.ResponseInfo schemeFreeProduct = new RExAPIResponseDomain.ResponseInfo();
        schemeFreeProduct.Master = 'SchemeFreeProducts';
        schemeFreeProduct.Field = new List<String> { 'SchemeID', 'ProductID', 'FreeQty', 'UomId','maxQty', 'GroupType', 'GroupName','GroupId','GetType','ProductLevelId','Worth','MaxWorth'};       
        
        List<List<String>> schemeFreeProducts  = new List<List<String>>();
        Map<String, String> UOMNameWithIdMap = stdMap(stdList);
       map<id,set<id>> prdgrpprdidset= new map<id,set<id>>();
        
        if(schemeFreeProductsList != null && schemeFreeProductsList.size() > 0 && errorCode == null && schemegroupIdwithSchemeFreeDetailMap != null && schemegroupIdwithSchemeFreeDetailMap.size() > 0) {
        
            for (ivydsd__Scheme_Group_Product__c schemefreeDetail: schemeFreeProductsList) {
                system.debug('schemefreeDetail '+schemefreeDetail);
                if (schemegroupIdwithSchemeFreeDetailMap.containsKey(schemefreeDetail.ivydsd__Scheme_Group__c)) {
                    
                    for (ivydsd__Scheme_Free_Detail__c sfd : schemegroupIdwithSchemeFreeDetailMap.get(schemefreeDetail.ivydsd__Scheme_Group__c) ) {
                        
                        if((prdgrpprdidset.containsKey(schemefreeDetail.id)==false || prdgrpprdidset.get(schemefreeDetail.id).contains(schemefreeDetail.ivydsd__Product1__c)==false) && (schemefreeDetail.ivydsd__Product1__c==sfd.Product_Master__c||sfd.Product_Master__c==null  )){
                            if(prdgrpprdidset.containsKey(schemefreeDetail.id)==false){
                            Set<id> prod = new Set<Id>();
                            prod.add(schemefreeDetail.ivydsd__Product1__c);
                            prdgrpprdidset.put(schemefreeDetail.id,prod);
                            }
                            else
                            {
                                prdgrpprdidset.get(schemefreeDetail.id).add(schemefreeDetail.ivydsd__Product1__c);
                            }
                            List<String> schemeFreeDetailRec = new List<String>();                    
                        schemeFreeDetailRec.add(sfd.ivydsd__Scheme_slab__r.ivydsd__Internal_Id__c);
                        if(schemefreeDetail.Product_Hierarchy__c!=null){
                            schemeFreeDetailRec.add( (schemefreeDetail.Product_Hierarchy__r.ivybase__Internal_Id__c != null) ? String.valueOf(schemefreeDetail.Product_Hierarchy__r.ivybase__Internal_Id__c):'0');
                        }else{
                            schemeFreeDetailRec.add(String.valueOf(schemefreeDetail.ivydsd__Product1__r.ivybase__InternalId__c));
                        }
                        
                        if (sfd.ivydsd__Free_Quantity__c != null) {
                            schemeFreeDetailRec.add(String.valueof(sfd.ivydsd__Free_Quantity__c));//freeQty
                        } else {
                            schemeFreeDetailRec.add('');
                        }
                        
                        if(stndListMap!= null ) {
                            if(stndListMap.containsKey('Piece'))
                            {
                                system.debug('inside piece'+ stndListMap.get('Piece'));
                             schemeFreeDetailRec.add(stndListMap.get('Piece'));   
                            }
                            else
                            {
                            schemeFreeDetailRec.add('');
                            }
                            
                        } else {
                            schemeFreeDetailRec.add('');
                        }
                        if(sfd.ivydsd__Maximum_Free_Quantity__c!=null){
                         schemeFreeDetailRec.add(String.valueof(sfd.ivydsd__Maximum_Free_Quantity__c));   
                        }else{
                        schemeFreeDetailRec.add(''); //maxQty
                        }
                        
                        schemeFreeDetailRec.add(String.isNotBlank(sfd.ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c) ? sfd.ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c : ''); //GroupType
                        schemeFreeDetailRec.add(String.isNotBlank(sfd.ivydsd__Scheme_Group__r.Name) ? sfd.ivydsd__Scheme_Group__r.Name : ''); //GroupName
                        if(sfd.ivydsd__Scheme_Group__r.Internal_Id__c!=null){
                            schemeFreeDetailRec.add(String.valueof(sfd.ivydsd__Scheme_Group__r.Internal_Id__c));
                        }else{
                            schemeFreeDetailRec.add('');
                        } //GroupId
                        //schemeFreeDetailRec.add(String.valueof(sfd.ivydsd__Scheme_Group__r.Internal_Id__c));
                       // schemeFreeDetailRec.add(' '); //GetType
                        schemeFreeDetailRec.add((sfd.Scheme_Type__c!=null)? sfd.Scheme_Type__c:'');
                        if(schemefreeDetail.Product_Hierarchy__c!=null && stndListMap!=null && stndListMap.containsKey(schemefreeDetail.Product_Hierarchy__r.RecordType.name)){
                        schemeFreeDetailRec.add(String.valueOf(stndListMap.get(schemefreeDetail.Product_Hierarchy__r.RecordType.name)));
                        }
                       else if(schemefreeDetail.ivydsd__Product1__c!=null && stndListMap!=null && stndListMap.containsKey(schemefreeDetail.ivydsd__Product1__r.RecordType.name)){
                           system.debug('STD CHECK '+stndListMap.containsKey(schemefreeDetail.ivydsd__Product1__r.RecordType.name) + stndListMap.get(schemefreeDetail.ivydsd__Product1__r.RecordType.name) );
                            schemeFreeDetailRec.add(String.valueOf(stndListMap.get(schemefreeDetail.ivydsd__Product1__r.RecordType.name)));
                        }else{
                            schemeFreeDetailRec.add('');
                        }//ProductLevelId
                        
                        if(sfd.Product_Value_Worth__c!=null){
                          schemeFreeDetailRec.add(String.valueof(sfd.Product_Value_Worth__c));  
                        }else{
                          schemeFreeDetailRec.add(''); 
                        } //Worth
                        if(sfd.Product_Value_Worth__c!=null){
                          schemeFreeDetailRec.add(String.valueof(sfd.Product_Value_Worth__c));  
                        }else{
                          schemeFreeDetailRec.add(''); //MaxWorth  
                        }
                        
                        schemeFreeProducts.add(schemeFreeDetailRec);
                    }
                    }  
                }
            }
        }        
        schemeFreeProduct.Data = schemeFreeProducts;
        schemeFreeProduct.ErrorCode = errorCode == null ? '0' : errorCode;
        schemeFreeProduct.Next = '0';
        return schemeFreeProduct;
    }
    public static RExAPIResponseDomain.ResponseInfo getSchemeMappingInfo(List<ivydsd__Scheme_Mapping__c> schemeMappingList, String errorcode) {
        RExAPIResponseDomain.ResponseInfo schemeMapping = new RExAPIResponseDomain.ResponseInfo();
        schemeMapping.Master = 'SchemeCriteriaMapping';
        schemeMapping.Field = new List<String> {'SchemeId', 'RetailerId', 'LocationId', 'ChannelId', 'AccountId', 'DistributorId', 'GroupID', 'AttributeId', 'PriorityProductId', 'CounterID'};
        List<List<String>> schemeMappingRecords = new List<List<String>>();
        if (errorcode == null) {
            for (ivydsd__Scheme_Mapping__c sm : schemeMappingList) {
                List<String> schemeMappingRec = new List<String>();
                schemeMappingRec.add(sm.ivydsd__Scheme__r.ivydsd__Internal_Id__c);//schemeId
                schemeMappingRec.add('0');//RetailerId
                schemeMappingRec.add('0');//LocationId
                if (sm.ivydsd__Store_Hierarchy__c != null) {
                    schemeMappingRec.add(sm.ivydsd__Store_Hierarchy__r.ivybase__internal_Id__c);//channelId
                } else {
                    schemeMappingRec.add('0');                
                }
                schemeMappingRec.add('0');//AccountId
                schemeMappingRec.add('0');//DistributorId
                schemeMappingRec.add(sm.ivydsd__Internal_Id__c);//GroupId
                schemeMappingRec.add('0');//AttributeId
                schemeMappingRec.add('0');//PriorityProductId
                schemeMappingRec.add('0');//CounterID
                schemeMappingRecords.add(schemeMappingRec);
            }
        }
        schemeMapping.Data = schemeMappingRecords;
        schemeMapping.ErrorCode = errorCode == null ? '0' : errorCode;
        schemeMapping.Next = '0';
        return schemeMapping;
    }
    
    //SchemePackageCappingMaster
    public static RExAPIResponseDomain.ResponseInfo getSchemePackageCappingInfo(List<Promotion_Package_Capping__c> schemePackageCappingList, 
                                                                                Map<String,String> StdLovidDivisionmap,
                                                                                String errorcode) {
        
        RExAPIResponseDomain.ResponseInfo schemePackageCapping = new RExAPIResponseDomain.ResponseInfo();
        schemePackageCapping.Master = 'SchemePackageCappingMaster';
        schemePackageCapping.Field = new List<String> {'SchemeId', 'PackageCount', 'Rid', 'Divid', 'ispackage'};
        
        List<List<String>> SchemePackageCappingRecords = new List<List<String>>();
        
        if (errorcode == null) {
        
            for (Promotion_Package_Capping__c schemePack : schemePackageCappingList) {
            
                List<String> schemePackageCappingRec = new List<String>();
                
                schemePackageCappingRec.add(schemePack.Promotion__r.ivydsd__Internal_Id__c);//schemeId                
                
                if(schemePack.Package_Count__c != null) {
                    
                    schemePackageCappingRec.add(String.valueOf(schemePack.Package_Count__c));//PackageCount
                }else {
                
                    schemePackageCappingRec.add('0');                
                }
                
                if(schemePack.Store__c != null) {
                    
                    schemePackageCappingRec.add(String.valueOf(schemePack.Store__r.ivybase__Internal_Id__c));//Rid
                }else {
                
                    schemePackageCappingRec.add('0');                
                }
                
                if (schemePack.Division__c != null && StdLovidDivisionmap.size() > 0 &&
                    StdLovidDivisionmap.containskey(schemePack.Division__r.Name) == true) {
                
                    schemePackageCappingRec.add(StdLovidDivisionmap.get(schemePack.Division__r.Name));//Divid
                } else {
                
                    schemePackageCappingRec.add('0');                
                }
                
                if (schemePack.Is_Package__c == true) {
                
                    schemePackageCappingRec.add('1');//ispackage
                } else {
                
                    schemePackageCappingRec.add('0');                
                }
                SchemePackageCappingRecords.add(schemePackageCappingRec);
            }
        }
        schemePackageCapping.Data = SchemePackageCappingRecords;
        schemePackageCapping.ErrorCode = errorCode == null ? '0' : errorCode;
        schemePackageCapping.Next = '0';
        return schemePackageCapping;
    }
    
    public static Map<String, String> stdMap(List<ivybase__Standard_List_Master__c> stdList) {
        Map<String, String> stdMap = new Map<String, String>();
        if (stdList != null && stdList.size() > 0) {
            for (ivybase__Standard_List_Master__c std : stdList) {
                stdMap.put(std.ivybase__List_Name__c, std.Name);
            }
        }
        return stdMap;
    }
}