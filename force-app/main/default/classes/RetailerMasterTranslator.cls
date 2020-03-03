public with sharing class RetailerMasterTranslator {
  public static ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
    public static RExAPIResponseDomain.ResponseInfo objectToRetailerInfo(List<Account> accRecList, Map<Id,ivybase__Store_Hierarchy__c> storeHierarchyMap, Map<Id,List<String>> storeAndRouteListMap, Map<Id,ivybase__Location_Hierarchy__c > locationMap,Set<String> userRelatedRoute, String errorCode) {
       SYSTEM.DEBUG('ACCREClIST  '+accRecList);
        system.debug('storeHierarchyMap '+storeHierarchyMap);
        system.debug('storeAndRouteListMap '+storeAndRouteListMap);
        RExAPIResponseDomain.ResponseInfo accList = new RExAPIResponseDomain.ResponseInfo();
        accList.Master = 'RetailerMaster';
       /* accList.Field = new List<String> {'RetailerId','RetailerCode','RetailerName','RetailerType','BeatId','CreditLimit','TinNumber','ChannelId','SubChannelId','ClassId',
                                          'IsAttended','RPTypeId','WalkingSequence','RField2','RField3','VisitDays','radius','RetCreditLimit','AccountId',
                                           'RField1','TaxTypeId','RField4','locationid','IsDeadStore','NfcTagId','ContractStatusLovId',
                                           'CreditPeriod','RField5','RField6','RField7','ProfileImagePath','PreferredTime','LastMonthVisits'};*/
        if(loggedInResource.Market_ISO__c == 'JPN'){
         accList.Field = new List<String> {'RetailerId','RetailerCode','RetailerName','RetailerType','BeatId','CreditLimit','TinNumber','ChannelId','SubChannelId','ClassId',
                                          'IsAttended','RPTypeId','WalkingSequence','RField2','RField3','VisitDays','radius','RetCreditLimit','AccountId',
                                           'RField1','TaxTypeId','RField4','locationid','IsDeadStore','NfcTagId','ContractStatusLovId',
                                           'CreditPeriod','RField5','RField6','RField7','PreferredTime','LastMonthVisits'};
        
        }else{
         accList.Field = new List<String> {'RetailerId','RetailerCode','RetailerName','RetailerType','BeatId','CreditLimit','TinNumber','ChannelId','SubChannelId','ClassId',
                                          'IsAttended','RPTypeId','WalkingSequence','RField2','RField3','VisitDays','radius','RetCreditLimit','AccountId',
                                           'RField1','TaxTypeId','RField4','locationid','IsDeadStore','NfcTagId','ContractStatusLovId',
                                           'CreditPeriod','RField5','RField6','RField7'};
        }                                    
        List<List<String>> accListRec = new List<List<String>>();
        
        List<ivybase__Standard_List_Master__c> classtypeList = StandardListMasterService.getAllClassTypeList();
        ivybase__Global_Configuration__mdt  gc = ivybase.GlobalConfigurationService.getGlobalConfig();
        Boolean isCustomTerritory = false;
        Boolean isStoreMultiTerritory = false;
       /* if (gc != null) {
            if (gc.ivybase__Active_Custom_Territory__c) {
                         //isCustomTerritory = true;
            }
            if (gc.ivybase__Active_Store_Multi_Territory__c) {
                isStoreMultiTerritory = true;
            }
        }*/
        
        // To get the count of visits for each salons
        SET<Id> idSet = new SET<Id>();
        
        for(Account a : accRecList) {
        idSet.add(a.Id);
        }
        
        MAP<Id,Integer> visitsCountList = new MAP<Id,Integer>();
        
        AggregateResult[] aggregateResultList = [SELECT count(Id), ivybase__Store__c  
                                                 FROM ivybase__Visit__c 
                                                 WHERE ivybase__Store__c IN: idSet group By ivybase__Store__c];
        
        for(AggregateResult ag : aggregateResultList) {
            visitsCountList.put((Id)ag.get('ivybase__Store__c'),(Integer)ag.get('expr0'));
        
        }
        
        
        
        if(accRecList != null &&  storeAndRouteListMap != null && errorCode == null 
            && (storeHierarchyMap != null || locationMap != null) ) {
            Map<String,String> classNameAndCodeMap = new Map<String,String>();      
            for(ivybase__Standard_List_Master__c listMaster : classtypeList ){
                classNameAndCodeMap.put(listMaster.ivybase__List_Code__c,listMaster.Name);
            }
                List<ivybase__Standard_List_Master__c> RetailerTypeList = StandardListMasterService.getStandardListUsingListType(new List<String>{'RETAILER_TYPE'});
             Map<String,String> RetailerTypeNameAndCodeMap = new Map<String,String>();      
            for(ivybase__Standard_List_Master__c listMaster : RetailerTypeList ){
                RetailerTypeNameAndCodeMap.put(listMaster.ivybase__List_Code__c,listMaster.Name);
            }   
            
                system.debug('classNameAndCodeMap'+classNameAndCodeMap);
            Set<Id> accIdSet = new Set<Id>();
            
            for (Account acc: accRecList) {
                system.debug('I');
                string RetailerType ='';
                String channelId = '';
                String subchannelId = '';
                String classId = '';
                String locationId = '';
                
                if(acc.Is_Conquest__c){
                    RetailerType='2';
                }
                else if(acc.Is_Dream_List__c){
                    RetailerType='1';
                } else if(acc.IsAgent__c){
                RetailerType='3';
                }
                else{
                    RetailerType='0';
                }
                List<String> accRec = new List<String>();
                
                if (storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c) != null && storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).RecordTypeId != null) {
                    if (storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).RecordType.Name == 'Channel') {
                        channelId  =  storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).ivybase__Internal_Id__c;  
                    } else if (storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).RecordType.Name == 'Sub Channel') {       
                        subchannelId = storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).ivybase__Internal_Id__c;  
                        if (storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).ivybase__Parent__c != null && storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).ivybase__Parent__r.ivybase__Active__c == 'Yes') {
                            channelId = storeHierarchyMap.get(acc.ivybase__Store_Hierarchy__c).ivybase__Parent__r.ivybase__Internal_Id__c;  
                        }
                    } 
                } 
                
                classId   = (classNameAndCodeMap.get(acc.ivybase__Customer_Category__c) != null) ? classNameAndCodeMap.get(acc.ivybase__Customer_Category__c) :'';
               system.debug('classId'+classId);
                system.debug('locationMap'+locationMap);
                locationId  = ( locationMap.get(acc.Location_Hierarchy__c) != null ) ? locationMap.get(acc.Location_Hierarchy__c).ivybase__Internal_Id__c : '';
system.debug('locationId'+locationId);
                //if (!string.isBlank(locationId) &&  !string.isBlank(channelId) && !string.isBlank(subchannelId) ) {
                    if(storeAndRouteListMap.get(acc.Id) != null){
                        system.debug('storeAndRouteListMap.get(acc.Id)'+storeAndRouteListMap.get(acc.Id));
                        for( String beatId: storeAndRouteListMap.get(acc.Id) ){
                            //if (!isCustomTerritory && !isStoreMultiTerritory) { 
                            if(userRelatedRoute.contains(beatId)){
                            if( !accIdSet.contains(acc.Id)) {
                                    accRec  = objectToaccInfo(acc,RetailerType,channelId, subchannelId ,beatId,classId,locationId,'',RetailerTypeNameAndCodeMap,visitsCountList.get(acc.Id));
                                    system.debug('Insode if accRec'+accRec);
                                    accListRec.add(accRec);
                                    accIdSet.add(acc.Id);
                                }
                            }
                            //} 
                      /*  else if( accIdwithSetOfTerritoryInternalIdMap != null && accIdwithSetOfTerritoryInternalIdMap.containsKey(acc.Id)) {
                             system.debug('accIdwithSetOfTerritoryInternalIdMap'+accIdwithSetOfTerritoryInternalIdMap);

                            for (String territoryId: accIdwithSetOfTerritoryInternalIdMap.get(acc.Id).KeySet()) {
                                    if( !accIdSet.contains(acc.Id)) {
                                        String isTemporaryRetail = accIdwithSetOfTerritoryInternalIdMap.get(acc.Id).get(territoryId) == true ? '1' : '';  
                                        accRec  = objectToaccInfo(acc,RetailerType,channelId, subchannelId ,beatId,classId,territoryId, isTemporaryRetail,RetailerTypeNameAndCodeMap);
                                        system.debug('Insode else accRec'+accRec);
                                        accListRec.add(accRec);
                                        accIdSet.add(acc.Id);
                                    }
                                }
                            } */
                           /* else {
                                system.debug('***entered'+acc.Id);
                               accRec  = objectToaccInfo(acc,RetailerType,channelId,subchannelId,'',classId,locationId,'',RetailerTypeNameAndCodeMap);
                            accListRec.add(accRec);
                            }*/
                        }
                    } else {
                        if (!isCustomTerritory && !isStoreMultiTerritory) {
                            if( !accIdSet.contains(acc.Id)) {
                                accRec  = objectToaccInfo(acc,RetailerType,channelId,subchannelId,'',classId,locationId,'',RetailerTypeNameAndCodeMap,visitsCountList.get(acc.Id));
                                accListRec.add(accRec);
                                accIdSet.add(acc.Id);
                            }
                        }/* else if (accIdwithSetOfTerritoryInternalIdMap != null && accIdwithSetOfTerritoryInternalIdMap.containsKey(acc.Id) && accIdwithSetOfTerritoryInternalIdMap.get(acc.Id).size() > 0) {
                            for (String territoryId: accIdwithSetOfTerritoryInternalIdMap.get(acc.Id).KeySet()) {
                                if( !accIdSet.contains(acc.Id)) {
                                    String isTemporaryRetail = accIdwithSetOfTerritoryInternalIdMap.get(acc.Id).get(territoryId) == true ? '1' : '';
                                    accRec  = objectToaccInfo(acc,RetailerType,channelId, subchannelId ,'',classId,territoryId, isTemporaryRetail,RetailerTypeNameAndCodeMap);
                                    accListRec.add(accRec);
                                    accIdSet.add(acc.Id);
                                }
                            }
                        }*/ else {
                            accRec  = objectToaccInfo(acc,RetailerType,channelId,subchannelId,'',classId,locationId,'',RetailerTypeNameAndCodeMap,visitsCountList.get(acc.Id));
                            accListRec.add(accRec);
                        }
                    }
                //}
                
            }
        }
        accList.Data = accListRec;
        accList.ErrorCode = errorCode == null ? '0' : errorCode; 
        accList.Next = '0';
        return accList;
    }
    
    public static List<String> objectToaccInfo(Account acc,string RetailerType,String channelId, String subchannelId, String beatId,String classId,String locationId, String isTemporaryRetail,Map<String,String> RetailerTypeNameAndCodeMap, Integer countOfVisits) {
    system.debug('accccccccccccccccc '+acc);
        List<String> accTemp = new List<String>();
        if (acc.ivybase__Internal_Id__c != null) {
            accTemp.add(String.valueOf(acc.ivybase__Internal_Id__c));//'RetailerId'
        } else {
            accTemp.add('');
        }
        accTemp.add(acc.AccountNumber != null ? acc.AccountNumber : '');//RetailerCode
        accTemp.add(acc.Name);//RetailerName
        accTemp.add(RetailerType != null ? RetailerType : '');//RetailerType
        accTemp.add(beatId != null ? beatId : '');//BeatId
        accTemp.add(acc.ivybase__Credit_Limit__c != null ?String.valueOf(acc.ivybase__Credit_Limit__c) :'');//CreditLimit
        accTemp.add(acc.ivybase__TIN_Number__c != null ? acc.ivybase__TIN_Number__c : '');//TinNumber
       
        accTemp.add(channelId != null ? channelId : '');//ChannelId
        accTemp.add(subchannelId != null ? subchannelId : '');//SubChannelId
        accTemp.add(classId != null ? classId : '');//ClassId
        accTemp.add('');//IsAttended
        if(RetailerTypeNameAndCodeMap.containsKey('CASH'))
        {
         accTemp.add(RetailerTypeNameAndCodeMap.get('CASH'));//RPTypeId   
        }else
        {
          accTemp.add('');//RPTypeId  
        }
        
        accTemp.add('');//WalkingSequence
        accTemp.add('');//RField2
        accTemp.add(isTemporaryRetail);//RField3
        accTemp.add('');//VisitDays
        accTemp.add('');//radius
        accTemp.add('');//RetCreditLimit
        if (acc.ivybase__Parent_Branch__r.ivybase__Internal_Id__c != null) {
            accTemp.add(String.valueOf(acc.ivybase__Parent_Branch__r.ivybase__Internal_Id__c));//AccountId
        } else {
            accTemp.add('');
        }
        accTemp.add('0');//RField1
        accTemp.add('');//TaxTypeId
        accTemp.add(String.isNotBlank(acc.Stock_Location__c) ? acc.Stock_Location__c : '');//RField4
        accTemp.add(locationId != null ? locationId : '');//locationid
        accTemp.add('');//IsDeadStore
        accTemp.add('');//NfcTagId
        accTemp.add('');//ContractStatusLovId
        accTemp.add(acc.ivybase__Credit_Period__c != null ? String.valueOf(acc.ivybase__Credit_Period__c) : '');//CreditPeriod
        accTemp.add(acc.Salon_Frequency__c != null ? acc.Salon_Frequency__c : '');//RField5 //Salon_Frequency__c
       if(acc.IsFocus__c){
           accTemp.add('1');
       }
        else{
            accTemp.add('0');
        }//RField6 IsFocus__c
        //accTemp.add(acc.Salon_Frequency__c != null ? acc.Salon_Frequency__c : '');
        accTemp.add('1');//RField7
        // Commented for japan deployment
        /*if(acc.ivybase__Image_Path__c != null && acc.ivybase__Image_Name__c != null){
            accTemp.add(acc.ivybase__Image_Path__c + acc.ivybase__Image_Name__c ); //ProfileImagePath
        } else{
            accTemp.add(''); //ProfileImagePath
        }*/
        
      
        
        if(loggedInResource.Market_ISO__c == 'JPN') {
            // PreferredTime
            accTemp.add(acc.Preferred_Time__c != NULL  && acc.Preferred_Time__c != '' ? acc.Preferred_Time__c : '' );
            // To add visit count
            accTemp.add(String.valueOf(countOfVisits) != NULL && String.valueOf(countOfVisits) != '' ?  String.valueOf(countOfVisits) : '');
        }
        
        return accTemp;
    }
   /* public static RExAPIResponseDomain.ResponseInfo objectToRetailerAddressInfo(List<Account> acList, Map<String, String> listNamewithListIdMap, String errorCode) {
        RExAPIResponseDomain.ResponseInfo accList = new RExAPIResponseDomain.ResponseInfo();
        accList.Master = 'RetailerAddress';
        accList.Field = new List<String> {'RetailerId','Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','pincode','City','State','FaxNo'};
        if(acList != null && errorCode == null) {
            accList.Data = objectToAddressList(acList, listNamewithListIdMap);
        }
        accList.ErrorCode = errorCode == null ? '0' : errorCode; 
        accList.Next = '0';
        return accList;
    }
   
    public static List<List<String>> objectToAddressList(List<Account> accList, Map<String, String> listNamewithListIdMap) {
        
        if (accList != null && accList.size() > 0) {
            
            List<List<String>> retailerAddresses = new List<List<String>>();
            
            for (Account acc:accList) {
                
                List<String> retaileraddress1 = new List<String>();
                
                if (acc.ivybase__Internal_Id__c != null) {
                    retaileraddress1.add(String.valueOf(acc.ivybase__Internal_Id__c));//RetailerId
                } else {
                    retaileraddress1.add('');//RetailerId
                }
                retaileraddress1.add(acc.BillingStreet != null ? acc.BillingStreet : '');//Address1
                retaileraddress1.add('');//Address2
                retaileraddress1.add('');//Address3
                retaileraddress1.add(acc.ivybase__Contact_Email__c != null ? acc.ivybase__Contact_Email__c : '');//Email
                retaileraddress1.add(acc.Phone != null ? acc.Phone : '');//'Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','pincode','City','State','FaxNo'
                String latit = acc.ivybase__Lat_and_Long__latitude__s != null ? String.valueOf(acc.ivybase__Lat_and_Long__latitude__s) :'';
                String longi = acc.ivybase__Lat_and_Long__longitude__s!= null ? String.valueOf(acc.ivybase__Lat_and_Long__longitude__s) :'';
                retaileraddress1.add(latit);//Latitude
                retaileraddress1.add(longi);////Longitude
                if (listNamewithListIdMap != null && listNamewithListIdMap.size() > 0 
                    && listNamewithListIdMap.containsKey('Primary Address')) {
                    retaileraddress1.add(listNamewithListIdMap.get('Primary Address'));
                } else {
                    retaileraddress1.add('');//AddressId
                }
                retaileraddress1.add(acc.BillingPostalCode != null ? acc.BillingPostalCode : '');//pincode
                retaileraddress1.add(acc.BillingCity != null ? acc.BillingCity : '');//City
                retaileraddress1.add(acc.BillingState != null ? acc.BillingState : '');//State
                retaileraddress1.add(acc.Fax != null ? acc.Fax : '');//FaxNo
                retailerAddresses.add(retailerAddress1);
                
                List<String> retaileraddress2 = new List<String>();
                if (acc.ivybase__Internal_Id__c != null) {
                    retaileraddress2.add(String.valueOf(acc.ivybase__Internal_Id__c));//RetailerId
                } else {
                    retaileraddress2.add('');
                }
                retaileraddress2.add(acc.ShippingStreet != NULL ? acc.ShippingStreet : ''); //Address1
                retaileraddress2.add('');//Address2
                retaileraddress2.add('');//Address3, //'Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','pincode','City','State','FaxNo'
                retaileraddress2.add(acc.ivybase__Contact_Email__c != null ? acc.ivybase__Contact_Email__c : '');//Email
                retaileraddress2.add(acc.ivybase__Contact_PhoneNo__c != null ? acc.ivybase__Contact_PhoneNo__c : '');//ContactNumber
                String latit2 = acc.ivybase__Lat_and_Long__latitude__s != null ? String.valueOf(acc.ivybase__Lat_and_Long__latitude__s) :'';
                String longi2 = acc.ivybase__Lat_and_Long__longitude__s!= null ? String.valueOf(acc.ivybase__Lat_and_Long__longitude__s) :'';
                retaileraddress2.add(latit2);//Latitude
                retaileraddress2.add(longi2);//Longitude
                if (listNamewithListIdMap != null && listNamewithListIdMap.size() > 0 
                        && listNamewithListIdMap.containsKey('Secondary Address')) {
                    retaileraddress2.add(listNamewithListIdMap.get('Secondary Address'));
                } else {
                    retaileraddress2.add('');//AddressId
                }
                retaileraddress2.add(acc.ShippingPostalCode != null ? acc.ShippingPostalCode : '');//pincode
                retaileraddress2.add(acc.ShippingCity != null ? acc.ShippingCity : '');//city
                retaileraddress2.add(acc.ShippingState != null ? acc.ShippingState : '');//state
                retaileraddress2.add(acc.Fax != null ? acc.Fax : '');//fax
                retailerAddresses.add(retailerAddress2);
                
            }
            return retailerAddresses;
        }
        return null;
    }*/
   public static RExAPIResponseDomain.ResponseInfo objectToRetailerAgent ( List<Account> accList, String errorCode )
   {
   return NULL;    
   }
}