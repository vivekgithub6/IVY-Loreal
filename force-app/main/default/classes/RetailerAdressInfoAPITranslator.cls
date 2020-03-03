public class RetailerAdressInfoAPITranslator {
    public static RExAPIResponseDomain.ResponseInfo TranslateAddressToJson(list<Partner_Function__c> Partnerlist,List<ivybase__Standard_List_Master__c> StandardListMasterrecords,List<Account> selfAccounts,string errorcode){
        RExAPIResponseDomain.ResponseInfo RetailerCustomerInfoResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerCustomerInfoResponce.Master = 'RetailerAddress';
        RetailerCustomerInfoResponce.Field = new List<String> {'RetailerId','Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','Type','pincode','City','State','FaxNo'};
            RetailerCustomerInfoResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerCustomerInfoResponce.Next = '0'; 
        List<List<String>> retailerAddresses = new List<List<String>>();
        Map<String, String> listNamewithListIdMap=new Map<String, String>();
        
        system.debug('Partnerlist'+Partnerlist);
        try{
            for(ivybase__Standard_List_Master__c stdmaster: StandardListMasterrecords){
                listNamewithListIdMap.put(stdmaster.ivybase__List_Name__c,stdmaster.Name);
            }
            //street = street.replace('\r\n', ' '); street = street.replace('\n', ' '); street = street.replace('\r', ' ');
          if(Partnerlist!=null && Partnerlist.size()>0){
            for (Partner_Function__c acc:Partnerlist) {
                List<String> retaileraddress = new List<String>();
                if(acc.Type__c=='Bill To') {
                    if (acc.account__r.ivybase__Internal_Id__c != null) {
                        retaileraddress.add(String.valueOf(acc.account__r.ivybase__Internal_Id__c));//RetailerId
                    } else {
                        retaileraddress.add('');//RetailerId
                    }
                    system.debug('acc.partner__r.Store_Address__c===>'+acc.partner__r.Store_Address__c);
                    string addrs1= String.isNotBlank(acc.partner__r.Store_Address__c) == true ? acc.partner__r.Store_Address__c.replace('"','') : '';
                    addrs1 = addrs1.replace('\r\n', ' '); addrs1 = addrs1.replace('\n', ' '); addrs1 = addrs1.replace('\r', ' ');
                    retaileraddress.add(addrs1);//Address1
                    retaileraddress.add('');//Address2
                    retaileraddress.add('');//Address3
                    retaileraddress.add(acc.partner__r.ivybase__Contact_Email__c != null ? acc.partner__r.ivybase__Contact_Email__c : '');//Email
                    system.debug('retaileraddress'+retaileraddress);
                    retaileraddress.add(acc.partner__r.ivybase__Contact_PhoneNo__c != null ? acc.partner__r.ivybase__Contact_PhoneNo__c : '');//'Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','pincode','City','State','FaxNo'
                    system.debug('retaileraddress'+retaileraddress);  
                    Double lat;
                    Double lon ;
                    if( acc.partner__r.ivybase__Lat_and_Long__c!=Null){
                        Location loc = acc.partner__r.ivybase__Lat_and_Long__c;
                        lat = loc.latitude;
                        lon = loc.longitude;
                    }
                    
                    String latit2 = lat != null ? String.valueOf(lat) :'';
                    String longi2 = lon!= null ? String.valueOf(lon) :'';
                    retaileraddress.add(latit2);//Latitude
                    retaileraddress.add(longi2);////Longitude
                    system.debug('listNamewithListIdMap'+listNamewithListIdMap);
                    retaileraddress.add(String.valueOf(acc.partner__r.ivybase__Internal_Id__c));//AddressId
                    if (listNamewithListIdMap != null && listNamewithListIdMap.size() > 0 
                        && listNamewithListIdMap.containsKey('Billing Address')) {
                            retaileraddress.add(listNamewithListIdMap.get('Billing Address'));//Type
                        } else {
                            retaileraddress.add('');
                        }
                    retaileraddress.add(acc.partner__r.ivybase__Area_Code__c != null ? acc.partner__r.ivybase__Area_Code__c: '');//pincodeBillingPostalCode
                    retaileraddress.add(acc.partner__r.BillingCity != null ? acc.partner__r.BillingCity : '');//City
                    retaileraddress.add(acc.partner__r.BillingState != null ? acc.partner__r.BillingState : '');//State
                    retaileraddress.add(acc.partner__r.Fax != null ? acc.partner__r.Fax : '');//FaxNo
                    retailerAddresses.add(retaileraddress);
                }
                if(acc.Type__c=='Ship To') {
                    if (acc.account__r.ivybase__Internal_Id__c != null) {
                        retaileraddress.add(String.valueOf(acc.account__r.ivybase__Internal_Id__c));//RetailerId
                    } else {
                        retaileraddress.add('');
                    }
                    string addrs2= String.isNotBlank(acc.partner__r.Store_Address__c) == true ? acc.partner__r.Store_Address__c.replace('"','') : '';
                    addrs2 = addrs2.replace('\r\n', ' '); addrs2 = addrs2.replace('\n', ' '); addrs2 = addrs2.replace('\r', ' ');
                    retaileraddress.add(addrs2  ); //Address1
                    //'Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','pincode','City','State','FaxNo'
                    retaileraddress.add('');//Address2
                    retaileraddress.add('');//Address3
                    
                    retaileraddress.add(acc.partner__r.ivybase__Contact_Email__c != null ? acc.partner__r.ivybase__Contact_Email__c : '');//Email
                    retaileraddress.add(acc.partner__r.ivybase__Contact_PhoneNo__c != null ? acc.partner__r.ivybase__Contact_PhoneNo__c : '');//ContactNumber
                    Double lat;
                    Double lon;
                    if(acc.partner__r.ivybase__Lat_and_Long__c!=Null){
                        Location loc = acc.partner__r.ivybase__Lat_and_Long__c;
                        lat = loc.latitude;
                        lon = loc.longitude;
                    }
                    
                    String latit2 = lat != null ? String.valueOf(lat) :'';
                    String longi2 = lon!= null ? String.valueOf(lon) :'';
                    retaileraddress.add(latit2);//Latitude
                    retaileraddress.add(longi2);//Longitude
                    system.debug('listNamewithListIdMap'+listNamewithListIdMap);
                    retaileraddress.add(String.valueOf(acc.partner__r.ivybase__Internal_Id__c));
                    if(listNamewithListIdMap != null && listNamewithListIdMap.size() > 0 
                       && listNamewithListIdMap.containsKey('Shipping Adress')) {
                           retaileraddress.add(listNamewithListIdMap.get('Shipping Adress'));
                       } else {
                           retaileraddress.add('');//AddressId
                       }
                    retaileraddress.add(acc.partner__r.ivybase__Area_Code__c != null ? acc.partner__r.ivybase__Area_Code__c : '');//pincode.//ivybase__Area_Code__cShippingPostalCode
                    retaileraddress.add(acc.partner__r.ShippingCity != null ? acc.partner__r.ShippingCity : '');//city
                    retaileraddress.add(acc.partner__r.ShippingState != null ? acc.partner__r.ShippingState : '');//state
                    retaileraddress.add(acc.partner__r.Fax != null ? acc.partner__r.Fax : '');//fax
                   // retaileraddress.add('');
                    retailerAddresses.add(retaileraddress);
                }
                
            }
          }
            for(Account acc : selfAccounts){
                List<String> retaileraddress = new List<String>();
                if (acc.ivybase__Internal_Id__c != null) {
                    retaileraddress.add(String.valueOf(acc.ivybase__Internal_Id__c));//RetailerId
                } else {
                    retaileraddress.add('');//RetailerId
                }
                string addrs3= String.isNotBlank(acc.Store_Address__c) == true ? acc.Store_Address__c.replace('"','') : '';
                addrs3 = addrs3.replace('\r\n', ' '); addrs3 = addrs3.replace('\n', ' '); addrs3 = addrs3.replace('\r', ' ');
                retaileraddress.add(addrs3  );
                
                //retaileraddress.add(acc.Store_Address__c != null ? acc.Store_Address__c : '');//Address1
                retaileraddress.add('');//Address2
                retaileraddress.add('');//Address3
                retaileraddress.add(acc.ivybase__Contact_Email__c != null ? acc.ivybase__Contact_Email__c : '');//Email
                system.debug('retaileraddress'+retaileraddress);
                retaileraddress.add(acc.ivybase__Contact_PhoneNo__c != null ? acc.ivybase__Contact_PhoneNo__c : '');//'Address1','Address2','Address3','Email','ContactNumber','Latitude','Longitude','AddressId','pincode','City','State','FaxNo'
                system.debug('retaileraddress'+retaileraddress);  
                Double lat;
                Double lon ;
                if( acc.ivybase__Lat_and_Long__c!=Null){
                    Location loc = acc.ivybase__Lat_and_Long__c;
                    lat = loc.latitude;
                    lon = loc.longitude;
                }
                
                String latit2 = lat != null ? String.valueOf(lat) :'';
                String longi2 = lon!= null ? String.valueOf(lon) :'';
                retaileraddress.add(latit2);//Latitude
                retaileraddress.add(longi2);////Longitude
                system.debug('listNamewithListIdMap'+listNamewithListIdMap);
                retaileraddress.add(String.valueOf(acc.ivybase__Internal_Id__c));//AddressId
                if (listNamewithListIdMap != null && listNamewithListIdMap.size() > 0 
                    && listNamewithListIdMap.containsKey('SoldTo Address')) {
                        retaileraddress.add(listNamewithListIdMap.get('SoldTo Address'));//Type
                    } else {
                        retaileraddress.add('');
                    }
                retaileraddress.add(acc.ivybase__Area_Code__c!= null ? acc.ivybase__Area_Code__c : '');//pincodeBillingPostalCode
                retaileraddress.add(acc.BillingCity != null ? acc.BillingCity : '');//City
                retaileraddress.add(acc.BillingState != null ? acc.BillingState : '');//State
                retaileraddress.add(acc.Fax != null ? acc.Fax : '');//FaxNo
                
                retailerAddresses.add(retaileraddress);
                
            }
            
            RetailerCustomerInfoResponce.data=retailerAddresses;
        }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
        return RetailerCustomerInfoResponce;
        
    }
    public static RExAPIResponseDomain.ResponseInfo objectToAgentMap(map<id,Agent_Salon_Mapping__c> agentMappings, List<Account> salonList, String errorCode){
        
        RExAPIResponseDomain.ResponseInfo agentMapList = new RExAPIResponseDomain.ResponseInfo();
        
        agentMapList.Master = 'RetailerAgentMapping';
        agentMapList.Next ='0';
        agentMapList.ErrorCode = errorCode == NULL ? '0' : errorCode; 
        agentMapList.Field = new List<String> {'Rid', 'AgentId'};
            
            List<List<String>> agentdata = new List<List<String>>();
        //List<String> subData;
        
    /*    if(salonList != NULL && errorCode == NULL) {
            for(Account  salon : salonList) {
                subData = new List<String>();
                
                //Rid :
                subData.add(String.valueOf(salon.ivybase__Internal_Id__c));
                
                //AgentId :
                subData.add('');
                
                data.add(subData);
            }
        }*/
        
        if(salonList != NULL && errorCode == NULL) {
            
          
            List<String> subData ;
            for(Agent_Salon_Mapping__c  agentMap : agentMappings.values()) {
                 subData = new List<String>();
                //Rid :
                if(agentMap.Salon__c != NULL)
                    subData.add(String.valueOf(agentMap.Salon__r.ivybase__Internal_Id__c));
                else
                    subData.add('');
                
                //AgentId :
                if(agentMap.Agent__c != NULL)
                    subData.add(String.valueOf(agentMap.Agent__r.ivybase__Internal_Id__c));
                else
                    subData.add('');
                
                agentdata.add(subData);
            }
        }
        agentMapList.Data = agentdata;
        return agentMapList;
        
    }
}