public class DigitialContentMappingTranslator {

    public static RExAPIResponseDomain.ResponseInfo objectToMappingInfo(List< ivybase__Digital_Content_Mapping__c> DigitalContentMappingList,map<string,string> Divisionlovidmap, String errorCode) {
        system.debug('inside method');
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;

        RExAPIResponseDomain.ResponseInfo DContentInfo = new RExAPIResponseDomain.ResponseInfo ();
        DContentInfo.Master = 'DigitalContentMapping';
        DContentInfo.Field = new List<String>{'imgid', 'mappingid', 'mappingtype','GroupId','DivisionId'}; 
        List<List<String>> dContentMapList = new List<List<String>>();

        System.debug('DigitalContentMapping'+DigitalContentMappingList);
        if (DigitalContentMappingList != null && errorCode == null ) {
            for (ivybase__Digital_Content_Mapping__c digital :DigitalContentMappingList) {

                List<String> digitalRec = new List<String>();
                if(digital.ivybase__Digital_Content__r.recordType.DeveloperName!='Training'){
                    digitalRec.add( (digital.ivybase__Digital_Content__c != null) ? digital.ivybase__Digital_Content__r.ivybase__Internal_Id__c :'' );
                    system.debug('digital='+digital);
                    //  if (digital.ivybase__Resource_Type__c != null && digital.ivybase__Resource_Type__c == resourcetypeId) {
                    // digitalRec.add('0');
                    // digitalRec.add('SELLER' );
                    //dContentMapList.add(digitalRec);
                    //} else 
                    if(digital.ivybase__Retailer__c != null){
                        digitalRec.add( String.valueOf(digital.ivybase__Retailer__r.ivybase__Internal_Id__c ) );
                        digitalRec.add( 'RETAILER' );
                        dContentMapList.add(digitalRec);
                    } else if(digital.ivybase__Store_Hierarchy__c != null){
                        digitalRec.add( digital.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c  );
                        digitalRec.add( 'STORE HIERARCHY' );
                        dContentMapList.add(digitalRec);
                    }
                    else{
                        digitalRec.add('0');
                        digitalRec.add('SELLER' );
                        dContentMapList.add(digitalRec);

                    }
                    digitalRec.add( (digital.Standard_List_Master__c != null) ? digital.Standard_List_Master__r.Name :'' );
                    if(Divisionlovidmap!=null && Divisionlovidmap.containskey(digital.Division__r.name) && Divisionlovidmap.get(digital.Division__r.name)!=null){
                        digitalRec.add(Divisionlovidmap.get(digital.Division__r.name));
                    }else{
                        digitalRec.add('0');
                    }

                }	

            }
            System.debug('dContentMapList'+dContentMapList);

        }

        DContentInfo.Data = dContentMapList;
        DContentInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        DContentInfo.Next = '0';
        return DContentInfo;
    }
    public static RExAPIResponseDomain.ResponseInfo objectToInfo(List< ivybase__Digital_Content__c> DigitalContentList, String errorCode) {

        RExAPIResponseDomain.ResponseInfo DContentInfo = new RExAPIResponseDomain.ResponseInfo ();
        DContentInfo.Master = 'DigitalContentMaster';
        DContentInfo.Field = new List<String>{'imageid', 'imagename', 'imagedesc', 'imageurl', 'imagedate'}; 
        List<List<String>> dContentList = new List<List<String>>();
        if (DigitalContentList != null && errorCode == null ) {
            for (ivybase__Digital_Content__c digital :DigitalContentList) {

                List<String> digitalRec = new List<String>();

                digitalRec.add( (digital.ivybase__Internal_Id__c != null) ? digital.ivybase__Internal_Id__c:'' );
                digitalRec.add( (digital.ivybase__image_Name__c != null) ? digital.ivybase__image_Name__c :'' );
                digitalRec.add( (digital.ivybase__Description__c != null) ? digital.ivybase__Description__c :'' );
                digitalRec.add( (digital.ivybase__Image_Url__c != null) ? digital.ivybase__Image_Url__c :'' );
                digitalRec.add( (digital.CreatedDate != null) ? digital.CreatedDate.format('yyyy/MM/dd'):'' );
                dContentList.add(digitalRec);
            }
        }
        DContentInfo.Data = dContentList;
        DContentInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        DContentInfo.Next = '0';
        return DContentInfo;
    }
    public static RExAPIResponseDomain.ResponseInfo objectToProductInfo(List< ivybase__Digital_Content_Mapping__c> DigitalContentMappingList, String errorCode) {
        RExAPIResponseDomain.ResponseInfo DContentInfo = new RExAPIResponseDomain.ResponseInfo ();
        DContentInfo.Master = 'DigitalContentProductMapping';
        DContentInfo.Field = new List<String>{'imgid', 'Pid'}; 
        List<List<String>> dContentMapList = new List<List<String>>();
        if (DigitalContentMappingList != null && errorCode == null ) {
            for (ivybase__Digital_Content_Mapping__c digital :DigitalContentMappingList) {

                List<String> digitalRec = new List<String>();

                digitalRec.add( (digital.ivybase__Digital_Content__c != null) ? digital.ivybase__Digital_Content__r.ivybase__Internal_Id__c :'' );
                digitalRec.add( (digital.Product_Master__c != null) ? string.valueof(digital.Product_Master__r.ivybase__InternalId__c) :(digital.ivybase__Product_Hierarchy__c != null) ? string.valueof(digital.ivybase__Product_Hierarchy__r.ivybase__Internal_Id__c) :'' );
                dContentMapList.add(digitalRec);
            }
        }
        DContentInfo.Data = dContentMapList;
        DContentInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        DContentInfo.Next = '0';
        return DContentInfo;
    }
    
     public static RExAPIResponseDomain.ResponseInfo objectToTrainingInfo(List< ivybase__Digital_Content_Mapping__c> DigitalContentMappingList,map<string,string> Divisionlovidmap, String errorCode) {
        system.debug('inside method');
         system.debug('DigitalContentMappingList Training '+DigitalContentMappingList);
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;

        RExAPIResponseDomain.ResponseInfo DContentInfo = new RExAPIResponseDomain.ResponseInfo ();
        DContentInfo.Master = 'DigitalContentTrainingMapping';
        DContentInfo.Field = new List<String>{'imgid', 'mappingid', 'mappingtype','GroupId','DivisionId'}; 
        List<List<String>> dContentMapList = new List<List<String>>();

        System.debug('DigitalContentMapping'+DigitalContentMappingList);
        if (DigitalContentMappingList != null && errorCode == null ) {
            for (ivybase__Digital_Content_Mapping__c digital :DigitalContentMappingList) {

                List<String> digitalRec = new List<String>();
                if(digital.ivybase__Digital_Content__r.recordType.DeveloperName=='Training'){
                    digitalRec.add( (digital.ivybase__Digital_Content__c != null) ? digital.ivybase__Digital_Content__r.ivybase__Internal_Id__c :'' );//imgid
                    system.debug('digital='+digital);
                    digitalRec.add('0');//groupId
                   digitalRec.add( (digital.Standard_List_Master__c != null) ? digital.Standard_List_Master__r.ivybase__List_Code__c :'' );//groupId
                    digitalRec.add( (digital.Standard_List_Master__c != null) ? digital.Standard_List_Master__r.Name :'' );//groupId
                    if(Divisionlovidmap!=null && Divisionlovidmap.containskey(digital.Division__r.name) && Divisionlovidmap.get(digital.Division__r.name)!=null){
                        digitalRec.add(Divisionlovidmap.get(digital.Division__r.name));
                    }else{
                        digitalRec.add('0');
                    }//divisionID
					dContentMapList.add(digitalRec);
                }	

            }
            System.debug('dContentMapList'+dContentMapList);

        }

        DContentInfo.Data = dContentMapList;
        DContentInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        DContentInfo.Next = '0';
        return DContentInfo;
    
    }
}