public class importDataFromCSVController {

    public Blob csvFileBody{get;set;}
    public boolean readSuccess {get;set;}
    String contactDataAsString;
    
    public importDataFromCSVController() {
    
        readSuccess = FALSE;
    }
    public void readFromFile(){
        try{
            contactDataAsString = csvFileBody.toString();
            System.debug('contactDataAsString===>'+contactDataAsString);
            routeCreation();
        }
        catch(exception e){
            readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file');
            ApexPages.addMessage(errorMessage);
        }
    }    
    public void routeCreation() {
        
        String[] rowsList = contactDataAsString.split('\n');
        
        Map<String,Set<String>> sellerAndAccountMap = new Map<String,Set<String>>();
        Set<String> accountSAPIdSet = new Set<String>();
        Set<String> countryCodeSet = new Set<String>();
        Map<String,String> sellerAndCountryCodeMap = new Map<String,String>();
        Map<String,String> CountryCodeAndMarketISOMap = new Map<String,String>();
        
        System.debug('rowsList====>'+rowsList);
        for(String row :rowsList) {
            
            System.debug('row====>'+row);
            row = row.replace('^', ',');
            row = row.replace('|', ',');
            List<String> columnList = row.split(',');
            System.debug('columnList====>'+columnList);
            
            if(columnList.size()>0) {
            
                if(sellerAndAccountMap.containskey(columnList[6])) {
                    
                    sellerAndAccountMap.get(columnList[6]).add(String.valueOf(columnList[3]));
                } 
                else {
                    Set<String> accountSet = new Set<String>();
                    accountSet.add(String.valueOf(columnList[3]));
                    sellerAndAccountMap.put(String.valueOf(columnList[6]),accountSet);
                }
                accountSAPIdSet.add(String.valueOf(columnList[3]));
                sellerAndCountryCodeMap.put(String.valueOf(columnList[6]),String.valueOf(columnList[0]));
                countryCodeSet.add(String.valueOf(columnList[0]));
            }
        }
        
        System.debug('sellerAndAccountMap====>'+sellerAndAccountMap);
        System.debug('sellerAndAccountMap.size()====>'+sellerAndAccountMap.size());
        System.debug('accountSAPIdSet====>'+accountSAPIdSet);
        System.debug('countryCodeSet====>'+countryCodeSet);
               
        List<CountryCodeMarketISO__mdt> countryCodeList;
        if(countryCodeSet.size()>0) { 
            countryCodeList = [SELECT Country__c, Country_Code__c, Division_based_Partner_Function__c
                               FROM CountryCodeMarketISO__mdt
                               WHERE Country_Code__c IN: countryCodeSet];
        }
        System.debug('countryCodeList====>'+countryCodeList);
 
        Set<String> countryStringSet = new Set<String>();
        if(countryCodeList.size()>0) {
            
            for(CountryCodeMarketISO__mdt countycode : countryCodeList ) {
                
                CountryCodeAndMarketISOMap.put(countycode.Country_Code__c, countycode.Country__c);
                countryStringSet.add(countycode.Country__c);
            }
        }
        System.debug('CountryCodeAndMarketISOMap====>'+CountryCodeAndMarketISOMap);
        
        List<Account> accountList;
        if(accountSAPIdSet.size()> 0) {
            accountList = [SELECT Id, Name, Sold_To_Party_Number__c 
                           FROM Account
                           WHERE Sold_To_Party_Number__c IN : accountSAPIdSet];
        }
        System.debug('accountList====>'+accountList);
        
        Map<String,Id> accsAPIdMap = new Map<String,Id>();
        
        if(accountList.size()>0) {
        
            for(Account acc :accountList) {
                
                accsAPIdMap.put(String.valueOf(acc.Sold_To_Party_Number__c), acc.Id);
            }
        }
        System.debug('accsAPIdMap====>'+accsAPIdMap);
        System.debug('countryStringSet====>'+countryStringSet);
        
        List<ivybase__Resource__c> resourceList = [SELECT Id, Name, SAP_Id__c
                                                   FROM ivybase__Resource__c
                                                   WHERE SAP_Id__c IN :sellerAndAccountMap.keySet()
                                                   AND Market_ISO__c IN : countryStringSet];
        
        System.debug('resourceList====>'+resourceList);
        
        Map<String,String> resIdNameMap = new Map<String,String>();
        Map<String,String> resSAPIdMap = new Map<String,String>();
        Set<String> resIdSet = new Set<String>();
        
        if(resourceList.size()>0) {
            for(ivybase__Resource__c res : resourceList) {
                
                resIdNameMap.put(String.valueOf(res.SAP_Id__c),res.Name);
                resSAPIdMap.put(String.valueOf(res.SAP_Id__c),res.Id);
                resIdSet.add(res.id);
            }
        }
        
        System.debug('resIdNameMap====>'+resIdNameMap);
        System.debug('resSAPIdMap====>'+resSAPIdMap);
        
        List<ivybase__Route__c> existingRouteList = [SELECT Id, Name, Market_ISO__c, ivybase__Resource__c, 
                                                            ivybase__Resource__r.SAP_Id__c,
                                                            Location_Hierarchy_Territory__c, 
                                                            ivybase__Description__c 
                                                     FROM ivybase__Route__c 
                                                     WHERE ivybase__Resource__c IN :resIdSet];
                                                     
        Map<String,String> extRouteMap = new Map<String,String>();
        
        if(existingRouteList.size()>0) {
            for(ivybase__Route__c existRoute :existingRouteList) {
                
                extRouteMap.put(String.valueOf(existRoute.ivybase__Resource__r.SAP_Id__c), existRoute.Id);
            }
        }
        System.debug('extRouteMap====>'+extRouteMap);
                                                 
        List<ivybase__Location_Hierarchy__c> lhList = [SELECT Id, Name, ivybase__Primary_Resource__c, 
                                                              ivybase__Primary_Resource__r.SAP_Id__c, Market_ISO__c
                                                       FROM ivybase__Location_Hierarchy__c
                                                       WHERE ivybase__Primary_Resource__c IN : resIdSet
                                                       AND RecordType.DeveloperName='Territory'];
        
        System.debug('lhList====>'+lhList);
        
        Map<String,String> lhMap = new Map<String,String>();
        
        if(lhList.size()>0) {
            for(ivybase__Location_Hierarchy__c lh :lhList) {
                
                lhMap.put(String.valueOf(lh.ivybase__Primary_Resource__r.SAP_Id__c), lh.Id);
            }
        }
        System.debug('lhMap====>'+lhMap);
        
        List<ivybase__Route__c> insertRouteList = new List<ivybase__Route__c>();
        
        if(sellerAndAccountMap.size()>0) {
            for(String seller : sellerAndAccountMap.keySet()) {
                
                if(resSAPIdMap.containskey(seller) && (extRouteMap.size() == 0 || (extRouteMap.size() > 0 && extRouteMap.containskey(seller) == false))) {   

                    ivybase__Route__c route = new ivybase__Route__c();
                    if(resSAPIdMap.containsKey(seller)){
                        route.ivybase__Resource__c = resSAPIdMap.get(seller);
                    }
                    if(sellerAndCountryCodeMap.containsKey(seller)){
                        route.Market_ISO__c = CountryCodeAndMarketISOMap.get(sellerAndCountryCodeMap.get(seller));
                    }
                    if(lhMap.containsKey(seller)){
                        route.Location_Hierarchy_Territory__c = lhMap.get(seller);
                    }
                    if(resIdNameMap.containsKey(seller)){
                        route.ivybase__Description__c = resIdNameMap.get(seller);
                    }
                    route.ivybase__Active__c = 'Yes';
                    insertRouteList.add(route);
                 }   
            }
        }   
        System.debug('insertRouteList====>'+insertRouteList);
        System.debug('insertRouteList.size()====>'+insertRouteList.size());
        Map<Id, ivybase__Route__c > resRouteIdMap = new Map<Id, ivybase__Route__c >();
        Set<Id> routeIdSet = new Set<Id>();
        if(insertRouteList.size()>0) {
            
            Database.insert(insertRouteList);
            System.debug('insertRouteList====>'+insertRouteList);
            
            for(ivybase__Route__c route :insertRouteList) {
                
                //resRouteIdMap.put(route.ivybase__Resource__c,route);
                routeIdSet.add(route.Id);
            }
        }
        
        List<ivybase__Route__c> routeList = [SELECT Id, Name, Market_ISO__c, ivybase__Resource__c, Location_Hierarchy_Territory__c, 
                                                        ivybase__Description__c 
                                                 FROM ivybase__Route__c ];
        for(ivybase__Route__c route :routeList) {
            
            resRouteIdMap.put(route.ivybase__Resource__c,route);
        }
        
        System.debug('resRouteIdMap====>'+resRouteIdMap);
        List<ivybase__Route_Details__c> insertRouteDetailList = new List<ivybase__Route_Details__c>();
        
        if(sellerAndAccountMap.size()>0) {
            for(String seller : sellerAndAccountMap.keySet()) {
                
                for(String accId : sellerAndAccountMap.get(seller)) {
                    
                    if(resSAPIdMap.containskey(seller)) {
                        
                        ivybase__Route_Details__c routeDetail = new ivybase__Route_Details__c();
                        
                        if(extRouteMap.containsKey(seller)) {
                            system.debug('extRouteMap.get(resSAPIdMap.get(seller))==>'+extRouteMap.get(seller));
                            routeDetail.ivybase__Route__c = extRouteMap.get(seller);
                        }
                        else if(resSAPIdMap.containsKey(seller)) {
                            routeDetail.ivybase__Route__c = resRouteIdMap.get(resSAPIdMap.get(seller)).Id;
                        }
                        if(sellerAndCountryCodeMap.containsKey(seller)){
                            routeDetail.Market_ISO__c = CountryCodeAndMarketISOMap.get(sellerAndCountryCodeMap.get(seller));
                        }
                        if(accsAPIdMap.containsKey(accId)) {
                            routeDetail.ivybase__Store__c = accsAPIdMap.get(accId);
                        }
                        routeDetail.ivybase__Active__c = 'Yes';
                        insertRouteDetailList.add(routeDetail);
                    }
                }
               
            }
        }
        System.debug('insertRouteDetailList====>'+insertRouteDetailList);
        if(insertRouteDetailList.size()>0) {
            Database.insert(insertRouteDetailList,false);
        }
        
        List<Territory_Routing__c> insertTerritoryRouteList = new List<Territory_Routing__c>();
        for(ivybase__Location_Hierarchy__c  lh : lhList) {
        
            System.debug('lh====>'+lh);
            
             
            if(resRouteIdMap.containsKey(lh.ivybase__Primary_Resource__c)) {
            System.debug('lh====>'+lh);
                Territory_Routing__c territoryRoute = new Territory_Routing__c();
                territoryRoute.Route__c = resRouteIdMap.get(lh.ivybase__Primary_Resource__c).Id;
                territoryRoute.Market_ISO__c = resRouteIdMap.get(lh.ivybase__Primary_Resource__c).Market_ISO__c;
                territoryRoute.Name = lh.Name +'-'+ resRouteIdMap.get(lh.ivybase__Primary_Resource__c).Name;  
                territoryRoute.Location_Hierarchy__c = lh.Id;
                insertTerritoryRouteList.add(territoryRoute);
            }
            
            System.debug('lh====>'+lh);
        }
        System.debug('insertTerritoryRouteList====>'+insertTerritoryRouteList);
        if(insertTerritoryRouteList.size()>0) {
            
            Database.insert(insertTerritoryRouteList,false);
        }
    }
}