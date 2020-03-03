@RestResource(UrlMapping='/v1/CustomerInfo/Masters/')
global  class RESTCustomerInfo {
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getCustomerInfo() {
        
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        RExAPIResponseDomain.ResponseInfo RetailerCustomerInfo = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo retailerCheckResponce = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo retailerMagClassifictionResponce = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo retailerSalesContributionResponce = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo retailerContractInfoResponce = new RExAPIResponseDomain.ResponseInfo();
        //MAG CLASSIFICATION
        RExAPIResponseDomain.ResponseInfo RetailerMagDetails;
        
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        Map<String, String> listNamewithListIdMap=new Map<String, String>();
        ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
        try{
            Set<Id> accIds = new Set<Id>();
            set<string> accidDividSet= new set<string>();
            List<Account> accList= AccountService.getAllRetailerMaster_List_for_Resource();
            for(Account acc: accList){
                accIds.add(acc.Id);
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
            Map<Id,Decimal> YTDValue = CustomerInfoService.getYTDValue(accIds);
            
            list<string> Listypes=new list<string>{'LUXURY_MAG'};
                List<ivybase__Standard_List_Master__c> StandardListMasterrecords= StandardListMasterservice.getStandardListUsingListType(Listypes);
            for(ivybase__Standard_List_Master__c stdmaster: StandardListMasterrecords){
                listNamewithListIdMap.put(stdmaster.ivybase__List_Code__c,stdmaster.Name);
            }
            System.debug('YTDValue:: '+YTDValue);
            System.debug('listNamewithListIdMap:: '+listNamewithListIdMap);
            RetailerCustomerInfo = CustomerInfoTranslator.objectToRetailerCustomerInfo(accList,YTDValue,listNamewithListIdMap,null);
            response.Tables.add(RetailerCustomerInfo);
            
            system.debug('accIds->'+ accIds);
            List<Document__c> documentRecords = CustomerInfoService.getRetailerCheck(accIds);
            system.debug('documentRecords ->'+ documentRecords);
            retailerCheckResponce = CustomerInfoTranslator.objectToRetailerCheck(documentRecords,null);
            response.Tables.add(retailerCheckResponce); 
            
            map<string,string> Divisionlovidmap= new map<string,string>();
            
            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')}))
            {
                Divisionlovidmap.put(stdListMaster.ivybase__List_Name__c, stdListMaster.Name);
            }
            Map<string,Date> salonInvDateMap = CustomerInfoService.getLastInvoiceDate(accIds);
            Map<string,Date> salonLastVisitdateMap = CustomerInfoService.getLastVisitDate(accIds);
            Map<string,Decimal> salonAvgOrderValue = CustomerInfoService.getAvgOrderValue(accIds);
            system.debug('Divisionlovidmap'+ Divisionlovidmap);
            system.debug('resourceDivMap'+ resourceDivMap);
            system.debug('salonAvgOrderValue ->'+ salonAvgOrderValue);
            System.debug('salonLastVisitdateMap in rest:'+salonLastVisitdateMap);
            System.debug('salonInvDateMap::'+salonInvDateMap);
            System.debug('Accounts in rest::'+accList);
            retailerMagClassifictionResponce = CustomerInfoTranslator.objectToRetailerMagClassifiction(accList,salonInvDateMap,salonLastVisitdateMap,salonAvgOrderValue,resourceDivMap,Divisionlovidmap,null);
            response.Tables.add(retailerMagClassifictionResponce); 
            map<string,Decimal> RetailerSalesContribution=CustomerInfoService.getRetailerSalesContribution();
            retailerSalesContributionResponce = CustomerInfoTranslator.objectToRetailersalesContribution(RetailerSalesContribution,null);
            //retailerSalesContributionResponce = CustomerInfoTranslator.objectToRetailersalesContribution(RetailerSalesContribution,Divisionlovidmap,null);
            
            response.Tables.add(retailerSalesContributionResponce); 
            list<Contract__c> getContractList=CustomerInfoService.getContractList();
            retailerContractInfoResponce = CustomerInfoTranslator.objectToRetailerContract(getContractList,Divisionlovidmap,null);
            
            response.Tables.add(retailerContractInfoResponce); 
            
            //MAG CLASSIFICATION
            list<Account> accounts=CustomerInfoService.getAccounts(accIds);
            system.debug('accounts'+accounts);
           
           // Added for japan
           
            
           if(loggedInResource.Market_ISO__c == 'JPN') {
                RetailerMagDetails=CustomerInfoTranslator.objectToRetailerMagDetails(accounts,null);
                response.Tables.add(RetailerMagDetails);
            }
            
        } catch(Exception ex){
            RetailerCustomerInfo = CustomerInfoTranslator.objectToRetailerCustomerInfo(null,null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(RetailerCustomerInfo);
            retailerCheckResponce = CustomerInfoTranslator.objectToRetailerCheck(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));    
            response.Tables.add(retailerCheckResponce); 
            retailerMagClassifictionResponce = CustomerInfoTranslator.objectToRetailerMagClassifiction(null,null,null,null,null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));   
            response.Tables.add(retailerMagClassifictionResponce); 
            retailerSalesContributionResponce = CustomerInfoTranslator.objectToRetailersalesContribution(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(retailerSalesContributionResponce); 
            retailerContractInfoResponce = CustomerInfoTranslator.objectToRetailerContract(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(retailerContractInfoResponce); 
            
            //MAG CLASSIFICATION
            if(loggedInResource.Market_ISO__c == 'JPN') {
                RetailerMagDetails=CustomerInfoTranslator.objectToRetailerMagDetails(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
                response.Tables.add(RetailerMagDetails);
            }
            
        }
        return response; 
        
    }
}