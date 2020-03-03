/*
* Block comments with details of changes
*/
@RestResource(UrlMapping='/v1/FinalResponse1/')
global with sharing class  RestSaloonDataBasedOnRequest
{
    @HttpPost
    global static RExAPIResponseDomain.MultipleResponseInfo getRetailerInfo(){
        
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        
        //Retailer address respone
        RExAPIResponseDomain.ResponseInfo AccountAddressinfo = new RExAPIResponseDomain.ResponseInfo();
        //customer Info
        RExAPIResponseDomain.ResponseInfo RetailerCustomerInfo = new RExAPIResponseDomain.ResponseInfo();
        //ContractInfo
        RExAPIResponseDomain.ResponseInfo retailerContractInfoResponce = new RExAPIResponseDomain.ResponseInfo();
         //Retailer Master
        RExAPIResponseDomain.ResponseInfo retailerMasterInfoResponse = new RExAPIResponseDomain.ResponseInfo();
        
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        try{
            
            RestRequest req = RestContext.request;
            Blob requestBody = req.requestBody;
            String requestString = requestBody.toString();
            
            system.debug('requestString'+ requestString);
            
            RetailerMasterSearchClass.PostIds responseBody = (RetailerMasterSearchClass.PostIds)JSON.deserialize(requestString, RetailerMasterSearchClass.PostIds.class);
            system.debug(responseBody.RETAILERID);
           /* LIST<String> retailerIdList = new LIST<String>(); // NOTE LIST of Ids send from Mobile.
            retailerIdList = responseBody.RETAILERID;*/
            
            SET<Decimal> internalIdList = new SET<Decimal>(); 
            
            for(String a : responseBody.RETAILERID) {
                internalIdList.add(Decimal.valueOf(a));
                
            }
            system.debug('internalIdList'+internalIdList);
            //getting all the accounts based on Accids data
            List< Account > accList = SalonDataservice.getAllRetailerMaster_List_For_All_Ids(internalIdList);
            system.debug(accList +'accList');
            Map<String, String> listNamewithListIdMap=new Map<String, String>();//LuxaryMag
            List<ivybase__Standard_List_Master__c> StandardListMasterrecords= new List<ivybase__Standard_List_Master__c>();//stld records
            map<string,string> Divisionlovidmap= new map<string,string>();//for holding divisionData
            //querying stld master for Adrestype data
            list<string> Listypes=new list<string>{'ADDRESS_TYPE','LUXURY_MAG','DIVISION_TYPE'};
                List<ivybase__Standard_List_Master__c> StandardListMasterrecords1= StandardListMasterservice.getStandardListUsingListType(Listypes);
            for(ivybase__Standard_List_Master__c stdmaster: StandardListMasterrecords1){
                if(stdmaster.ivybase__List_Type__c.equalsIgnoreCase('LUXURY_MAG'))
                    listNamewithListIdMap.put(stdmaster.ivybase__List_Code__c,stdmaster.Name);
                if(stdmaster.ivybase__List_Type__c.equalsIgnoreCase('ADDRESS_TYPE'))
                    StandardListMasterrecords.add(stdmaster);
                if(stdmaster.ivybase__List_Type__c.equalsIgnoreCase('DIVISION_TYPE'))
                    Divisionlovidmap.put(stdmaster.ivybase__List_Name__c, stdmaster.Name);
                
            }
            AccountAddressinfo = RetailerAdressInfoAPITranslator.TranslateAddressToJson(null,StandardListMasterrecords,accList,null);
           response.Tables.add(AccountAddressinfo);/////Retailer address response
            
            //////////////////////////////Customer info table begins//////////////////////////////////////////
            Set<Id> accIds = new Set<Id>();
            set<string> accidDividSet= new set<string>();
            Set<Id> locationHierarcyIdSet = new Set<Id>();
            for(Account acc: accList){
                accIds.add(acc.Id);
                if(acc.Location_Hierarchy__c != null) {
                    locationHierarcyIdSet.add(acc.Location_Hierarchy__c);
                }
            }
            map<string,string> resourceDivMap= ResourceService.GetAllResourceDivisionmap();
            system.debug('resourceDivMap ->'+ resourceDivMap);
            if(accIds.size()>0 && resourceDivMap!=null){
                for( Id accid :accIds){
                    for(string Divid:resourceDivMap.keyset()){
                        accidDividSet.add(accid+'.'+Divid);
                    }
                } 
            }
            System.debug('AccountIds::: '+accIds);
            Map<Id,Decimal> YTDValue = SalonDataservice.getYTDValue(accIds);
            
            for(ivybase__Standard_List_Master__c stdmaster: StandardListMasterrecords){
                if(stdmaster.ivybase__List_Type__c.equalsIgnoreCase('LUXURY_MAG'))
                    listNamewithListIdMap.put(stdmaster.ivybase__List_Code__c,stdmaster.Name);
            }
            System.debug('YTDValue:: '+YTDValue);
            System.debug('listNamewithListIdMap:: '+listNamewithListIdMap);
            RetailerCustomerInfo = CustomerInfoTranslator.objectToRetailerCustomerInfo(accList,YTDValue,listNamewithListIdMap,null);
            response.Tables.add(RetailerCustomerInfo);
            /////////////////////////////////////////////////////Contract Info/////////////////////////////
            list<Contract__c> getContractList=SalonDataservice.getContractList(internalIdList);
            retailerContractInfoResponce = CustomerInfoTranslator.objectToRetailerContract(getContractList,Divisionlovidmap,null);
            
           response.Tables.add(retailerContractInfoResponce); 
            /////////////////////////////Retailer Master////////////////////////////////////
            Map<Id,ivybase__Location_Hierarchy__c > locationIdMap = new Map<Id,ivybase__Location_Hierarchy__c>();
            locationIdMap = LocationMasterService.getAllLocationMasterMapByLocId(locationHierarcyIdSet);
            retailerMasterInfoResponse =SalonDataTranslator.objectToRetailerInfo(accList,locationIdMap,null);
             response.Tables.add(retailerMasterInfoResponse); 
        }
        catch(Exception ex){
            AccountAddressinfo = RetailerAdressInfoAPITranslator.TranslateAddressToJson(null,null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));  
            response.Tables.add(AccountAddressinfo);
            RetailerCustomerInfo = CustomerInfoTranslator.objectToRetailerCustomerInfo(null,null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(RetailerCustomerInfo);
            retailerContractInfoResponce = CustomerInfoTranslator.objectToRetailerContract(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(retailerContractInfoResponce); 
        }
        return response; 
    }
}