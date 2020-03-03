//dev code
public with sharing class AccountService {
    
    /*public static void getdivisionwiseAccountsforRep(id resid){
        Map<Id,Set<Account>> AllAccountResourceMap= AccountService.get_All_Retailer_For_All_Resource();
        set<id> accid = new set<id>();
        if(AllAccountResourceMap!=null && AllAccountResourceMap.containskey(resid) && AllAccountResourceMap.get(resid)!=null){
            for(account acc:AllAccountResourceMap.get(resid)){
                accid.add(acc.id);
            }
        }
        list<StoreDivisionMapping__c> saloonDivRecs= new list<StoreDivisionMapping__c>();
        if(accid!=null && accid.size()>0){
            saloonDivRecs= [select Account__c,Store_Hierarchy__c,Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.division__c from StoreDivisionMapping__c where Account__c IN:accid   ];
        }
        
    }*/
    
    // Method added for post for pricing
    Public static MAP<Id, Account> getAccountBasedOnInternalId(SET<Integer> accountInternalId) {
        
        MAP<Id, Account> accountIdMAP = new MAP<id,Account>();
        
        if(accountInternalId != NULL) {
            
            LIST<Account> accountList = [SELECT ID, Name, Price_List__c, ivybase__Internal_Id__c 
                                         FROM Account 
                                         WHERE ivybase__Internal_Id__c IN: accountInternalId];
            
            for(Account acc: accountList) {
                
                if(!accountIdMAP.containsKey(acc.Id)) {
                    accountIdMAP.put(acc.Id,acc);
                }
            }
        }
        
        return  accountIdMAP;
    }
    
    // T0 get accounts based on Internal Id
    Public static MAP<Id, Account> getAccountBasedOnId(SET<Id> accountIdSet) {
        
        MAP<Id, Account> accountIdMAP = new MAP<id,Account>(); // To store accounts in a MAP
        
        if(accountIdSet != NULL) {
            
            LIST<Account> accountList = new LIST<Account>();
            
            accountList = [SELECT ID, Name, Price_List__c, ivybase__Internal_Id__c 
                           FROM Account 
                           WHERE Id IN: accountIdSet];
            
            for(Account accountRecord : accountList) {
                
                if(!accountIdMAP.containskey(accountRecord.Id)) {
                    accountIdMAP.put(accountRecord.Id,accountRecord);
                }
            }
        }
        return accountIdMAP;
    }
    
    
    public static Map<String,Account> getAccountBySoldToPartyId(Set<String> retailerSoldToPartyIdSet1) {
        
        String[] accountFields = new String[] {'Sold_To_Party_Number__c','ivybase__Active__c'};
            Map<String, Account> internalIdAndSFIdMap = new Map<String, Account>();
        Set<String> retailerInternalIdSet = new Set<String>();
        
        for(String temp :retailerSoldToPartyIdSet1) {
            if (temp != null && temp.isNumeric()) {
                retailerInternalIdSet.add(temp);
            }
        }
        system.debug('retailerInternalIdSet'+retailerInternalIdSet);
        if(SecurityUtility.checkIsAccessible('Account',accountFields)) {
            
            List<Account> accountList = [SELECT Id, Name, Sold_To_Party_Number__c FROM Account WHERE Sold_To_Party_Number__c =:retailerInternalIdSet AND ivybase__Active__c = 'Yes'];
            system.debug('accountList'+accountList);
            for(Account acct :accountList) {
                if (acct.Sold_To_Party_Number__c != null) {
                    internalIdAndSFIdMap.put(String.valueOf(acct.Sold_To_Party_Number__c), acct);
                }
            }
            return internalIdAndSFIdMap;
        } else {
            system.debug('Account is not Accessible');
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        } 
        
    }
    public static List<Account> GetRelatedAccountFormCustomerCode(Set<String> CustomerCode)
    {
        List<Account> account = new List<Account>();
        account=[select id,
                 name,
                 ivybase__Store_Hierarchy__c,
                 Sold_To_Party_Number__c,
                 Price_List__c
                 From 
                 Account
                 where 
                 Sold_To_Party_Number__c=:CustomerCode];
        return Account;
    }
    public static List<Account> GetRelatedAccountFormStoreHierarchyCode(Set<String> StoreHierarchyCode)
    {
        List<Account> account = new List<Account>();
        account=[select id,
                 name,
                 Price_List__c,
                 ivybase__Store_Hierarchy__c,
                 ivybase__Store_Hierarchy__r.Store_Number__c,
                 ivybase__Store_Hierarchy__r.ivybase__Parent__c,
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.Store_Number__c,
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c,
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c,
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c
                 from 
                 Account 
                 where
                 ivybase__Store_Hierarchy__r.Store_Number__c=:StoreHierarchyCode OR
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.Store_Number__c=:StoreHierarchyCode OR
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c=:StoreHierarchyCode OR
                 ivybase__Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c=:StoreHierarchyCode
                ];
        return account;
        
    }
    public static Set<Id> getSetOfHierarchyForThisResource()
    {
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        Set<Id> userTerritoryId = new Set<Id>(); 
        for(ivybase__Location_Hierarchy__c l:userTerritory)
        {
            userTerritoryId.add(l.id);
        }
        Set<Id> divId = DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
        List<ivybase__Store_Hierarchy__c> storeHierarchiesList = new List<ivybase__Store_Hierarchy__c>();
        String[] storeDivFields = new String[]{'ivybase__Parent__c','ivybase__Level__c','ivybase__Internal_Id__c','Division__c','ivybase__Active__c'};
            
            if(SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', storeDivFields)){
                storeHierarchiesList=[select
                                      id,
                                      name,
                                      Division__c,
                                      ivybase__Parent__c,
                                      ivybase__Parent__r.ivybase__Parent__c,
                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                      from ivybase__Store_Hierarchy__c
                                      where ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Division__c IN:divId AND ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName='Channel'  
                                     ];
                system.debug('storeHierarchiesList'+storeHierarchiesList);
                Set<Id> store = new Set<Id>();
                for(ivybase__Store_Hierarchy__c s:storeHierarchiesList)
                {
                    store.add(s.id);
                    if(s.ivybase__Parent__c!=null)
                    {
                        store.add(s.ivybase__Parent__c);   
                    }
                    if(s.ivybase__Parent__r.ivybase__Parent__c !=null)
                    {
                        store.add(s.ivybase__Parent__r.ivybase__Parent__c);   
                    }
                    if(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c !=null)
                    {
                        store.add(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);   
                    }
                }
                system.debug('store'+store);
                return store;
                
                
            }
        else
        {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    public static Map<String, Set<String>> getHierarchyIdsbysellerId_Map(String conId) {
        
        Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = new Map<String, Set<String>>();
        list<account> acclist=getAllRetailerMaster_List_for_Resource();
        set<id> accid= new set<id>();
        if(acclist.size()>0){
            for(account acc:acclist){
                accid.add(acc.id);
            }
        }
        
        system.debug('accid ->'+ accid);
        if(conId != NULL) {
            
            String[] accFields = new String[] {'ivybase__Internal_Id__c','ivybase__Store_Hierarchy__c','ivybase__Location_Hierarchy__c','ivybase__Seller_Name__c','ivybase__Resource__c'}; 
                String[] storeHieFields = new String[] {'Parent__c'};
                    Integer stdLoc = 0, stdStore = 0;
            String query = 'SELECT id,Store_Hierarchy__c,';
            String parentlvl = 'ivybase__Parent__c';
            String temp = 'ivybase__Parent__c';
            
            if(SecurityUtility.checkIsAccessible('Account', accFields) && SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', storeHieFields)) {
                
                List<String> listTypes = new List<String> {'CHANNEL_HIERARCHY','LOCATION_HIERARCHY'};
                    
                    for(ivybase__Standard_List_Master__c std : StandardListMasterService.getStandardListUsingListType(listTypes)) {
                        if(std.ivybase__List_Type__c == 'CHANNEL_HIERARCHY') {
                            stdStore++;
                        } else {
                            stdLoc++;
                        }
                    }
                system.debug(':::stdStore::::'+stdStore+':::stdLoc:::::'+stdLoc);
                for(Integer i = 1; i < stdStore && i < 6; i++) {
                    query += 'Store_Hierarchy__r.'+ parentlvl + ', ';
                    parentlvl = 'ivybase__Parent__r.' + parentlvl;
                }
                parentlvl = 'ivybase__Parent__c';
                query += 'Account__c,Division__c ,Account__r.Location_Hierarchy__c, Account__r.ivybase__Internal_Id__c FROM StoreDivisionMapping__c WHERE ';
                
                ivybase__Global_Configuration__mdt  gc = GlobalConfigurationService.getGlobalConfig();
                Boolean isCustomTerritory = false;
                Boolean isStoreMultiTerritory = false;
                Set<Id> accountIds = new Set<Id>();
                
                if (gc != null) {
                    if (gc.ivybase__Active_Custom_Territory__c) {
                        isCustomTerritory = true;
                    }
                    if (gc.ivybase__Active_Store_Multi_Territory__c) {
                        isStoreMultiTerritory = true;
                    }
                }
                if (!isCustomTerritory && !isStoreMultiTerritory) {
                    query += ' Account__c IN: accid AND ';
                    
                }
                query += 'Account__r.ivybase__Active__c = \'Yes\' AND Account__r.ivybase__Internal_Id__c != NULL';
                system.debug(' query sesult'+ Database.query(query));
                
                for (StoreDivisionMapping__c acc: (Database.query(query))) {
                    if (!hierarchyNamewithSetOfIdsMap.containsKey('Account')) {
                        hierarchyNamewithSetOfIdsMap.put('Account', new Set<String>());
                    }
                    hierarchyNamewithSetOfIdsMap.get('Account').add(acc.Account__c); 
                    
                    if (!hierarchyNamewithSetOfIdsMap.containsKey('Location')) {
                            hierarchyNamewithSetOfIdsMap.put('Location', new Set<String>());
                    }
                    hierarchyNamewithSetOfIdsMap.get('Location').add(acc.Account__r.Location_Hierarchy__c);
                    system.debug('inside location if get'+hierarchyNamewithSetOfIdsMap);
                    
                    if (acc.Store_Hierarchy__c != null) {
                        if (!hierarchyNamewithSetOfIdsMap.containsKey('Store')) {
                            hierarchyNamewithSetOfIdsMap.put('Store', new Set<String>());
                        }
                        hierarchyNamewithSetOfIdsMap.get('Store').add(acc.Store_Hierarchy__c);
                        
                        if(stdStore >= 2 && acc.Store_Hierarchy__r.ivybase__Parent__c != NULL) {
                            hierarchyNamewithSetOfIdsMap.get('Store').add(acc.Store_Hierarchy__r.ivybase__Parent__c);
                            
                            if(stdStore >= 3 && acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c != NULL) {
                                hierarchyNamewithSetOfIdsMap.get('Store').add(acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c);
                                
                                if(stdStore >= 4 && acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != NULL) {
                                    hierarchyNamewithSetOfIdsMap.get('Store').add(acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                    
                                    if(stdStore >= 5 && acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != NULL) {
                                        hierarchyNamewithSetOfIdsMap.get('Store').add(acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                        
                                        if(stdStore >= 6 && acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != NULL) {
                                            hierarchyNamewithSetOfIdsMap.get('Store').add(acc.Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (!hierarchyNamewithSetOfIdsMap.containsKey(acc.Store_Hierarchy__c)) {
                            hierarchyNamewithSetOfIdsMap.put(acc.Store_Hierarchy__c, new Set<String>());
                        }
                        hierarchyNamewithSetOfIdsMap.get(acc.Store_Hierarchy__c).add(String.ValueOf(acc.Account__r.ivybase__Internal_Id__c));
                    }
               }
                
                
               //it will not enter in this loop as per the current functionality------start
       /*         if ( (isCustomTerritory || isStoreMultiTerritory) && hierarchyNamewithSetOfIdsMap != null && hierarchyNamewithSetOfIdsMap.ContainsKey('Account')) {
                    for (ivybase__Territory_Store_Mapping__c terStoreMapping : [SELECT Id, 
                                                                                ivybase__Store__c, 
                                                                                ivybase__Territory1__c, 
                                                                                ivybase__Territory1__r.ivybase__Parent__c,
                                                                                ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__c,
                                                                                ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                                                ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                                                ivybase__Location_Hierarchy__c,
                                                                                ivybase__Location_Hierarchy__r.ivybase__Parent__c,
                                                                                ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c,
                                                                                ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                                                ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                                                ivybase__From__c,
                                                                                ivybase__To__c,
                                                                                ivybase__Location_Hierarchy__r.ivybase__Current_Resource__c,
                                                                                ivybase__Territory1__r.ivybase__Current_Resource__c
                                                                                FROM
                                                                                ivybase__Territory_Store_Mapping__c
                                                                                WHERE 
                                                                                ivybase__Store__c IN:hierarchyNamewithSetOfIdsMap.get('Account')
                                                                                AND 
                                                                                (ivybase__From__c = null OR ivybase__From__c <= TODAY)
                                                                                AND 
                                                                                (ivybase__To__c = null OR ivybase__To__c >= TODAY)
                                                                                AND
                                                                                ( ivybase__Location_Hierarchy__r.ivybase__Current_Resource__c =:conId
                                                                                 OR
                                                                                 ivybase__Territory1__r.ivybase__Current_Resource__c =:conId   
                                                                                )
                                                                               ]) {
                                                                                   if (!hierarchyNamewithSetOfIdsMap.containsKey('Location')) {
                                                                                       hierarchyNamewithSetOfIdsMap.put('Location', new Set<String>());
                                                                                   }
                                                                                   if (isCustomTerritory) {
                                                                                       hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Territory1__c);
                                                                                       if (terStoreMapping.ivybase__Territory1__r.ivybase__Parent__c != null) {
                                                                                           hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Territory1__r.ivybase__Parent__c);
                                                                                           if (terStoreMapping.ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__c != null) {
                                                                                               hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                               if (terStoreMapping.ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null) {
                                                                                                   hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                   if (terStoreMapping.ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null) {
                                                                                                       hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Territory1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                   }
                                                                                               }  
                                                                                           }  
                                                                                       }    
                                                                                   } else if (isStoreMultiTerritory) {
                                                                                       hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Location_Hierarchy__c);
                                                                                       if (terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__c != null) {
                                                                                           hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__c);
                                                                                           if (terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c != null) {
                                                                                               hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                               if (terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null) {
                                                                                                   hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                   if (terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null) {
                                                                                                       hierarchyNamewithSetOfIdsMap.get('Location').add(terStoreMapping.ivybase__Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                   }
                                                                                               }  
                                                                                           }  
                                                                                       } 
                                                                                   }  
                                                                               }                                                        
                }
                */
                //--------------end of the if condition------///// 
                
                
                
                
            } else {
                system.debug('Account is not Accessible');
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            } 
        }
        system.debug('hierarchyNamewithSetOfIdsMap'+ hierarchyNamewithSetOfIdsMap);
        return hierarchyNamewithSetOfIdsMap; 
        
        
    }
    
    public static Map<String,Account> getAccountByInternalId(Set<String> retailerInternalIdSet1) {
        
        String[] accountFields = new String[] {'ivybase__Internal_Id__c','ivybase__Active__c'};
            Map<String, Account> internalIdAndSFIdMap = new Map<String, Account>();
        Set<Decimal> retailerInternalIdSet = new Set<Decimal>();
        
        for(String temp :retailerInternalIdSet1) {
            if (temp != null && temp.isNumeric()) {
                retailerInternalIdSet.add(Decimal.ValueOf(temp));
            }
        }
        system.debug('retailerInternalIdSet'+retailerInternalIdSet);
        if(SecurityUtility.checkIsAccessible('Account',accountFields)) {
            
            List<Account> accountList = [SELECT Id, Name, ivybase__Internal_Id__c FROM Account WHERE ivybase__Internal_Id__c =:retailerInternalIdSet AND ivybase__Active__c = 'Yes'];
            system.debug('accountList'+accountList);
            for(Account acct :accountList) {
                if (acct.ivybase__Internal_Id__c != null) {
                    internalIdAndSFIdMap.put(String.valueOf(acct.ivybase__Internal_Id__c), acct);
                }
            }
            return internalIdAndSFIdMap;
        } else {
            system.debug('Account is not Accessible');
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        } 
        
    }
    public static List<Account> getAllRetailerMaster_List_for_Resource() {
        List< Account > ac = AccountService.getAllRetailerMaster_List();
        System.debug('Resource Accounts::'+ac);
        List< Account > accRouteList = getAllRetailerMaster_List_from_Route();
        System.Debug('Route Accounts::: '+accRouteList);
        Set<Account> setOFAccount = new Set<Account>();
        setOFAccount.addAll(ac);
        setOFAccount.addAll(accRouteList);
        List<Account> accList= new List<Account>();
        accList.addAll(setOFAccount);
        return accList;
    }
    
    
    public static Map<Id,Set<Account>> get_All_Retailer_For_All_Resource()
    {
        Map<Id,Set<Account>> ResourceRelatedRetailersMap = new Map<Id,Set<Account>>();
        List<Account> allRelatedRetailerList = AccountService.getAllRetailerMaster_List_For_All_Resource();
        for(Account acc:allRelatedRetailerList)
        {
            if(ResourceRelatedRetailersMap.containsKey(acc.ivybase__Resource__c))
            {
                ResourceRelatedRetailersMap.get(acc.ivybase__Resource__c).add(acc);
            }
            else
            {
                Set<Account> accountSet = new Set<Account>();
                accountSet.add(acc);
                ResourceRelatedRetailersMap.put(acc.ivybase__Resource__c,accountSet);
            }
        }
        Map<Id,Set<Account>> ResourceAndAccountMap = AccountService.getAllRetailerMaster_List_from_All_Related_Route_For_All_Resource();
        for(Id res:ResourceAndAccountMap.keySet())
        {
            if(ResourceRelatedRetailersMap.containsKey(res))
            {
                ResourceRelatedRetailersMap.get(res).addAll(ResourceAndAccountMap.get(res));
            }
            else
            {
                Set<Account> accountSet = new Set<Account>();
                accountSet.addAll(ResourceAndAccountMap.get(res));
                ResourceRelatedRetailersMap.put(res,accountSet);
            }
        }
        
        return ResourceRelatedRetailersMap;
    }
    
    public static List<Account> getAllRetailerMaster_List_For_All_Resource() {
        List<ivybase__Resource__c> resourceList = new List<ivybase__Resource__c>();
        List<Id> resourceId = new List<Id>();
        List< Account > RetailerListInfo = new List< Account >();
        String[] ck2Fields = new String[] {'ivybase__Internal_Id__c', 'ivybase__StoreCode__c','BillingStreet', 'ivybase__Customer_Category__c', 'BillingCity',
            'BillingState', 'BillingPostalCode', 'ivybase__Credit_Limit__c', 'ivybase__TIN_Number__c', 'ShippingStreet', 
            'ShippingCity', 'ivybase__Store_Hierarchy__c', 'ShippingState', 'ShippingPostalCode', 'ivybase__Contact_Email__c',
            'ivybase__Contact_PhoneNo__c','Price_List__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Credit_Period__c', 'Phone', 'Fax', 'ivybase__Lat_and_Long__c',
            'ivybase__Lat_and_Long__latitude__s', 'ivybase__Lat_and_Long__longitude__s','ivybase__Visit_Plan__c','ivybase__Seller_Name__c','ivybase__Resource__c','ivybase__Image_Path__c',
            'ivybase__Image_Name__c','ivybase__Last_Visit__c','Location_Hierarchy__c','AccountNumber','ivybase__Second_LastVisit__c','Is_Dream_List__c','Converted_to_Normal_Saloon__c','Is_Conquest__c','Payer_Code__c','Phone','Kerastase_Luxury_Mag__c',
            'Salon_Person_Contact_Code__c','Due_Amount__c','Store_Address__c','Remarks__c','Last_Visit_Date__c'};
                
                if (SecurityUtility.checkIsAccessible('Account', ck2Fields)) { 
                    Id currentUserId = UserInfo.getUserId();
                    resourceList = [ SELECT Id FROM ivybase__Resource__c WHERE ivybase__Related_User__c != null];
                    for(ivybase__Resource__c res:resourceList)
                    {
                        resourceId.add(res.Id);
                    }
                    if(resourceList.size() > 0) {
                        RetailerListInfo = [ SELECT ivybase__Internal_Id__c,
                                            ivybase__StoreCode__c ,
                                            Name,
                                            ivybase__Parent_Branch__r.ivybase__Internal_Id__c,
                                            BillingStreet,
                                            ivybase__Customer_Category__c,
                                            BillingCity,
                                            BillingState,
                                            Price_List__c,
                                            BillingPostalCode,
                                            ivybase__Credit_Limit__c,
                                            ivybase__TIN_Number__c,
                                            ShippingStreet,
                                            ShippingCity,
                                            Location_Hierarchy__c,
                                            ivybase__Store_Hierarchy__c,
                                            ShippingState,
                                            ShippingPostalCode,
                                            ivybase__Contact_Email__c,
                                            ivybase__Contact_PhoneNo__c,
                                            ivybase__Location_Hierarchy__c,
                                            ivybase__Credit_Period__c,
                                            Phone,
                                            Fax,Salon_Frequency__c,
                                            ivybase__Lat_and_Long__c,
                                            ivybase__Lat_and_Long__latitude__s, 
                                            ivybase__Lat_and_Long__longitude__s,
                                            ivybase__Visit_Plan__c,ivybase__Resource__c,
                                            ivybase__Image_Name__c,
                                            ivybase__Image_Path__c,
                                            ivybase__Last_Visit__c,
                                            ivybase__Second_LastVisit__c,
                                            Is_Dream_List__c,
                                            Converted_to_Normal_Saloon__c,
                                            Is_Conquest__c,
                                            Remarks__c,
                                            AccountNumber,
                                            Average_Order_Value__c,
                                            LastInvoiceDate__c,
                                            Last_Visit_Date__c,
                                            Payer_Code__c,
                                            Kerastase_Luxury_Mag__c,
                                            AgreedActiveCustomer__c,
                                            Salon_Person_Contact_Code__c,
                                            Progress_Percentage__c,
                                            Dream_List_Status__c,
                                            Due_Amount__c,
                                            Store_Address__c,
                                            ivybase__Active__c,
                                            SecondLastInvoiceDate__c,
                                            Sold_To_Party_Number__c,
                                            ivybase__Area_Code__c,IsFocus__c,Last_Vist_Date__c,Preferred_Time__c
                                            
                                            
                                            FROM Account 
                                            WHERE 
                                            ivybase__Active__c = 'Yes'
                                            AND
                                            ivybase__Resource__c =:resourceId 
                                            AND 
                                            RecordType.DeveloperName = 'Retail_Account'
                                            
                                            
                                           ];
                    }
                    return RetailerListInfo;
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
        
    }
    
    public static List<Account> getAllRetailerMaster_List() {
        
        List< Account > RetailerListInfo = new List< Account >();
        List<ivybase__Resource__c> resourceList = new List<ivybase__Resource__c>();
        String[] ck2Fields = new String[] {'ivybase__Internal_Id__c', 'ivybase__StoreCode__c','BillingStreet', 'ivybase__Customer_Category__c', 'BillingCity',
            'BillingState', 'BillingPostalCode', 'ivybase__Credit_Limit__c', 'ivybase__TIN_Number__c', 'ShippingStreet', 
            'ShippingCity', 'ivybase__Store_Hierarchy__c', 'ShippingState', 'ShippingPostalCode', 'ivybase__Contact_Email__c',
            'ivybase__Contact_PhoneNo__c','Price_List__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Credit_Period__c', 'Phone', 'Fax', 'ivybase__Lat_and_Long__c',
            'ivybase__Lat_and_Long__latitude__s', 'ivybase__Lat_and_Long__longitude__s','ivybase__Visit_Plan__c','ivybase__Seller_Name__c','ivybase__Resource__c','ivybase__Image_Path__c',
            'ivybase__Image_Name__c','ivybase__Last_Visit__c','Location_Hierarchy__c','AccountNumber','ivybase__Second_LastVisit__c','Is_Dream_List__c','Converted_to_Normal_Saloon__c','Is_Conquest__c','Payer_Code__c','Phone','Kerastase_Luxury_Mag__c',
            'Salon_Person_Contact_Code__c','Due_Amount__c','Store_Address__c','Remarks__c','Last_Visit_Date__c','Social_Media_Id__c','Order_Email__c', 'Stock_Location__c', 'Preferred_Time__c'};
                
                if (SecurityUtility.checkIsAccessible('Account', ck2Fields)) { 
                    Id currentUserId = UserInfo.getUserId();
                    resourceList = [ SELECT Id FROM ivybase__Resource__c WHERE ivybase__Related_User__c = :currentUserId ];
                    
                    system.debug('resourceList '+ resourceList);
                    if(resourceList.size() > 0) {
                        RetailerListInfo = [ SELECT ivybase__Internal_Id__c,
                                            ivybase__StoreCode__c ,
                                            Name,
                                            ivybase__Parent_Branch__r.ivybase__Internal_Id__c,
                                            BillingStreet,
                                            ivybase__Customer_Category__c,
                                            BillingCity,
                                            BillingState,
                                            Price_List__c,
                                            BillingPostalCode,
                                            ivybase__Credit_Limit__c,
                                            ivybase__TIN_Number__c,
                                            ShippingStreet,
                                            ShippingCity,
                                            ivybase__Store_Hierarchy__c,
                                            ShippingState,
                                            ShippingPostalCode,
                                            ivybase__Contact_Email__c,
                                            ivybase__Contact_PhoneNo__c,
                                            ivybase__Location_Hierarchy__c,
                                            Location_Hierarchy__c,
                                            ivybase__Credit_Period__c,
                                            Phone,
                                            Fax,Salon_Frequency__c,
                                            ivybase__Lat_and_Long__c,
                                            ivybase__Lat_and_Long__latitude__s, 
                                            ivybase__Lat_and_Long__longitude__s,
                                            ivybase__Visit_Plan__c,ivybase__Resource__c,
                                            ivybase__Image_Name__c,
                                            ivybase__Image_Path__c,
                                            ivybase__Last_Visit__c,
                                            ivybase__Second_LastVisit__c,
                                            Is_Dream_List__c,
                                            Converted_to_Normal_Saloon__c,
                                            Is_Conquest__c,
                                            Remarks__c,
                                            AccountNumber,
                                            Average_Order_Value__c,
                                            LastInvoiceDate__c,
                                            Last_Visit_Date__c,
                                            Payer_Code__c,
                                            Kerastase_Luxury_Mag__c,
                                            AgreedActiveCustomer__c,
                                            Salon_Person_Contact_Code__c,
                                            Progress_Percentage__c,
                                            Dream_List_Status__c,
                                            Due_Amount__c,
                                            Store_Address__c,
                                            Social_Media_Id__c,
                                            Sold_To_Party_Number__c,
                                            Order_Email__c, isAgent__c,
                                            Stock_Location__c, Preferred_Time__c,
                                            ivybase__Area_Code__c,IsFocus__c,Last_Vist_Date__c
                                            
                                            FROM Account 
                                            WHERE 
                                            ivybase__Active__c = 'Yes'
                                            AND
                                            ivybase__Resource__c =:resourceList[0].Id 
                                            AND 
                                            RecordType.DeveloperName = 'Retail_Account'
                                            
                                            
                                           ];
                    }
                    system.debug('RetailerListInfo '+ RetailerListInfo);
                    return RetailerListInfo;
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
    }
    public static Map<Id,Set<Account>> getAllRetailerMaster_List_from_All_Related_Route_For_All_Resource()
    {
        Set<Id> LocationHierarchyId = new Set<Id>();
        set<Id> RouteId = new Set<Id>();
        Set<Id> accountId = new Set<Id>();
        Map<Id,Set<Id>> LocationHierarchyAndResourceMap = new Map<Id,Set<Id>>();
        List<account> accountList = new List<Account>();
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getAllUserTerritory();
        for(ivybase__Location_Hierarchy__c u:userTerritory)
        {
            LocationHierarchyId.add(u.id);
            if(LocationHierarchyAndResourceMap.containsKey(u.ivybase__Primary_Resource__c))
            {
                LocationHierarchyAndResourceMap.get(u.ivybase__Primary_Resource__c).add(u.Id);
            }
            else
            {
                Set<Id> recSet = new Set<Id>();
                recSet.add(u.Id);
                LocationHierarchyAndResourceMap.put(u.ivybase__Primary_Resource__c,recSet);
            }
            
        }
        system.debug('LocationHierarchyId'+LocationHierarchyId);
        Map<Id,Set<Id>> RouteLocationHierarchyMap = new Map<Id,Set<Id>>();
        List<Territory_Routing__c> territoryRouting = [ select Location_Hierarchy__c,Route__c from Territory_Routing__c where Location_Hierarchy__c=:LocationHierarchyId];
        for(Territory_Routing__c t:territoryRouting)
        {
            RouteId.add(t.Route__c);
            if(RouteLocationHierarchyMap.containsKey(t.Location_Hierarchy__c))
            {
                RouteLocationHierarchyMap.get(t.Location_Hierarchy__c).add(t.Route__c);
            }
            else
            {
                Set<Id> recSet = new Set<Id>();
                recSet.add(t.Route__c);
                RouteLocationHierarchyMap.put(t.Location_Hierarchy__c,recSet);
            }
            
        }
        system.debug('RouteId'+RouteId);
        Map<Id,Set<Id>> StoreRouteMap = new Map<Id,Set<Id>>();
        List<ivybase__Route_Details__c> RouteDetails = [select id,name,ivybase__Store__c,ivybase__Route__c from ivybase__Route_Details__c where ivybase__Route__c=:RouteId AND ivybase__Active__c='Yes'];
        for(ivybase__Route_Details__c r:RouteDetails)
        {
            accountId.add(r.ivybase__Store__c); 
            if(StoreRouteMap.containsKey(r.ivybase__Route__c))
            {
                StoreRouteMap.get(r.ivybase__Route__c).add(r.ivybase__Store__c);
            }
            else
            {
                Set<Id> recSet = new Set<Id>();
                recSet.add(r.ivybase__Store__c);
                StoreRouteMap.put(r.ivybase__Route__c,recSet);
            }
        }
        system.debug('StoreRouteMap'+StoreRouteMap);
        
        
        
        
        if(accountId.size()>0)
        {
            accountList=[ SELECT ivybase__Internal_Id__c,
                         ivybase__StoreCode__c ,
                         Name,
                         ivybase__Parent_Branch__r.ivybase__Internal_Id__c,
                         BillingStreet,
                         ivybase__Customer_Category__c,
                         BillingCity,
                         BillingState,
                         BillingPostalCode,
                         ivybase__Credit_Limit__c,
                         ivybase__TIN_Number__c,
                         ShippingStreet,
                         ShippingCity,
                         ivybase__Store_Hierarchy__c,
                         ShippingState,
                         ShippingPostalCode,
                         ivybase__Contact_Email__c,
                         ivybase__Contact_PhoneNo__c,
                         ivybase__Location_Hierarchy__c,
                         ivybase__Credit_Period__c,
                         Phone,
                         Price_List__c,
                         Fax,Salon_Frequency__c,
                         ivybase__Lat_and_Long__c,
                         ivybase__Lat_and_Long__latitude__s, 
                         ivybase__Lat_and_Long__longitude__s,
                         ivybase__Visit_Plan__c,ivybase__Resource__c,
                         ivybase__Image_Name__c,
                         ivybase__Image_Path__c,
                         ivybase__Last_Visit__c,
                         ivybase__Second_LastVisit__c,
                         Is_Dream_List__c,
                         Converted_to_Normal_Saloon__c,
                         Is_Conquest__c,
                         Remarks__c,
                         AccountNumber,
                         Average_Order_Value__c,
                         LastInvoiceDate__c,
                         Last_Visit_Date__c,
                         Payer_Code__c,
                         Kerastase_Luxury_Mag__c,
                         AgreedActiveCustomer__c,
                         Salon_Person_Contact_Code__c,
                         Progress_Percentage__c,
                         Due_Amount__c,
                         Dream_List_Status__c,
                         Store_Address__c,
                         ivybase__Active__c,SecondLastInvoiceDate__c, Sold_To_Party_Number__c,
                         ivybase__Area_Code__c,IsFocus__c,Last_Vist_Date__c,Preferred_Time__c
                         
                         
                         FROM Account 
                         WHERE 
                         ivybase__Active__c = 'Yes'
                         AND
                         RecordType.DeveloperName = 'Retail_Account'
                         AND
                         ID IN:accountId
                         
                        ];
        }
        Map<Id,Set<Account>> ResourceAccountMap = new Map<Id,Set<Account>>(); 
        for(Account acc:accountList)
        {
            Set<Id>accId =new Set<Id>();
            accId.add(acc.Id);
            Set<Id> Store = AccountService.getkeyfromMapwithValue(StoreRouteMap,accId);
            Set<Id> LocationHierarchy = AccountService.getkeyfromMapwithValue(RouteLocationHierarchyMap,Store);
            Set<Id> ResourceSet = AccountService.getkeyfromMapwithValue(LocationHierarchyAndResourceMap,LocationHierarchy);
            
            for(id Resource:ResourceSet){
                if(ResourceAccountMap.containsKey(Resource))
                {
                    ResourceAccountMap.get(Resource).add(acc);
                }
                else
                {
                    Set<Account> recSet = new Set<Account>();
                    recSet.add(acc);
                    ResourceAccountMap.put(Resource,recSet);
                }
            }
        }
        
        return ResourceAccountMap;
        
        
    }
    
    //Adding this method to getting Route details from the method to sned salon frequency data
   /* public static map<id,ivybase__Route_Details__c> getRoutes_Resource(){
    Set<Id> LocationHierarchyId = new Set<Id>();
        set<Id> RouteId = new Set<Id>();
        Set<Id> accountId = new Set<Id>();
        List<account> accountList = new List<Account>();
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        for(ivybase__Location_Hierarchy__c u:userTerritory)
        {
            LocationHierarchyId.add(u.id);  
        }
        system.debug('LocationHierarchyId'+LocationHierarchyId);
        List<Territory_Routing__c> territoryRouting = [ select Location_Hierarchy__c,Route__c from Territory_Routing__c where Location_Hierarchy__c IN:LocationHierarchyId];
        system.debug('territoryRouting'+territoryRouting);
        for(Territory_Routing__c t:territoryRouting)
        {
            RouteId.add(t.Route__c); 
        }
        system.debug('RouteId'+RouteId);
        List<ivybase__Route_Details__c> RouteDetails = [select id,name,ivybase__Store__c,Salon_Frequency__c, ivybase__Store__r.IsAgent__c,ivybase__Route__c from ivybase__Route_Details__c where ivybase__Route__c=:RouteId AND ivybase__Route__r.ivybase__Active__c='Yes' AND ivybase__Active__c='Yes'];
        map<id,ivybase__Route_Details__c> salonidRouteMap=  new map<id,ivybase__Route_Details__c>();
        for(ivybase__Route_Details__c rd: RouteDetails){
            if(rd.ivybase__Store__c!=null){
                salonidRouteMap.put(rd.ivybase__Store__c,rd);
            }
      
      }
        return salonidRouteMap;
    }*/
    
    public static List<account> getAllRetailerMaster_List_from_Route()
    {
        Set<Id> LocationHierarchyId = new Set<Id>();
        set<Id> RouteId = new Set<Id>();
        Set<Id> accountId = new Set<Id>();
        List<account> accountList = new List<Account>();
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        for(ivybase__Location_Hierarchy__c u:userTerritory)
        {
            LocationHierarchyId.add(u.id);  
        }
        system.debug('LocationHierarchyId'+LocationHierarchyId);
        List<Territory_Routing__c> territoryRouting = [ select Location_Hierarchy__c,Route__c from Territory_Routing__c where Location_Hierarchy__c IN:LocationHierarchyId];
        system.debug('territoryRouting'+territoryRouting);
        for(Territory_Routing__c t:territoryRouting)
        {
            RouteId.add(t.Route__c); 
        }
        system.debug('RouteId'+RouteId);
        List<ivybase__Route_Details__c> RouteDetails = [select id,name,ivybase__Store__c, ivybase__Store__r.IsAgent__c,ivybase__Route__c from ivybase__Route_Details__c where ivybase__Route__c=:RouteId AND ivybase__Route__r.ivybase__Active__c='Yes' AND ivybase__Active__c='Yes'];
      //create set of ids for agents
        
        /* This is used in JAPAN to send salons under agent salon */
        
        LIST<Id> agentSalonIdList = new LIST<Id>();
        
        Id uid = UserInfo.getUserId();
        ivybase__Resource__c  resourceRecord =  ResourceService.getSellerId(uid);
        String marketIso;
        
        if(resourceRecord != NULL) {
            marketIso = resourceRecord.Market_ISO__c;
        }
        
       for(ivybase__Route_Details__c r:RouteDetails)
        {
            accountId.add(r.ivybase__Store__c);
            /* Japan change to get all saoln under agent salon */
            if(marketIso == 'JPN' && r.ivybase__Store__r.IsAgent__c) {
            agentSalonIdList.add(r.ivybase__Store__c);
            }
        }
        system.debug('account size before agent aslons '+accountId.size());
        system.debug('agentSalonIdList '+agentSalonIdList.size());
        system.debug('agentSalonIdList '+agentSalonIdList);
        /* Japan changes to salons for agent  */
        if(agentSalonIdList.size()>0) {
            LIST<Agent_Salon_Mapping__c> agentsalonMappingLIST = [SELECT Salon__c, Agent__c
                                                                  FROM Agent_Salon_Mapping__c 
                                                                  WHERE Agent__c IN : agentSalonIdList];
            for(Agent_Salon_Mapping__c  asm: agentsalonMappingLIST) {
                //accountId.add(asm.Salon__c);
            }
            
        }
        /* Japan  changes end here */
        
        
        system.debug('accountId'+accountId);
        system.debug('account size after agent aslons '+accountId.size());
        if(accountId.size()>0)
        {
            accountList=[ SELECT ivybase__Internal_Id__c,
                         ivybase__StoreCode__c ,
                         Name,
                         ivybase__Parent_Branch__r.ivybase__Internal_Id__c,
                         BillingStreet,
                         ivybase__Customer_Category__c,
                         BillingCity,
                         BillingState,
                         BillingPostalCode,
                         Location_Hierarchy__c ,
                         ivybase__Credit_Limit__c,
                         ivybase__TIN_Number__c,
                         ShippingStreet,
                         ShippingCity,
                         ivybase__Store_Hierarchy__c,
                         ShippingState,
                         ShippingPostalCode,
                         ivybase__Contact_Email__c,
                         ivybase__Contact_PhoneNo__c,
                         ivybase__Location_Hierarchy__c,
                         ivybase__Credit_Period__c,
                         Phone,
                         Fax,Salon_Frequency__c,
                         ivybase__Lat_and_Long__c,
                         ivybase__Lat_and_Long__latitude__s, 
                         ivybase__Lat_and_Long__longitude__s,
                         ivybase__Visit_Plan__c,ivybase__Resource__c,
                         ivybase__Image_Name__c,
                         ivybase__Image_Path__c,
                         ivybase__Last_Visit__c,
                         ivybase__Second_LastVisit__c,
                         Is_Dream_List__c,
                         Converted_to_Normal_Saloon__c,
                         Is_Conquest__c,
                         Remarks__c,
                         AccountNumber,
                         Average_Order_Value__c,
                         LastInvoiceDate__c,
                         Last_Visit_Date__c,
                         Payer_Code__c,
                         Kerastase_Luxury_Mag__c,
                         AgreedActiveCustomer__c,
                         Salon_Person_Contact_Code__c,
                         Progress_Percentage__c,
                         Due_Amount__c,
                         Dream_List_Status__c,
                         Store_Address__c,
                         Price_List__c,
                         Social_Media_Id__c,
                         Sold_To_Party_Number__c,
                         Order_Email__c, isAgent__c,
                         Stock_Location__c, Preferred_Time__c,
                         ivybase__Area_Code__c,IsFocus__c,Last_Vist_Date__c
                         
                         FROM Account 
                         WHERE 
                         ivybase__Active__c = 'Yes'
                         AND
                         RecordType.DeveloperName = 'Retail_Account'
                         AND
                         ID IN:accountId
                         
                        ];
        }
        return accountList;
    }
   /* public static void UpdateAccountLastInvoiceDate(list<ivydsd__Invoice__c> Invoicelist){
        system.debug('Invoicelist'+Invoicelist);
        map<id,date> AccountDateMap=new map<id,date>();
        //  ivydsd__Invoice__c previousinvoice;
        for(ivydsd__Invoice__c invoice:Invoicelist){
            
            // system.debug('previousinvoice'+previousinvoice);
            
            if(AccountDateMap.keyset().contains(invoice.ivydsd__Store__c))     {
                if(AccountDateMap.get(invoice.ivydsd__Store__c)< invoice.ivydsd__Invoice_Date__c)
                    AccountDateMap.put(invoice.ivydsd__Store__c,invoice.ivydsd__Invoice_Date__c);
            }
            
            
            else
                AccountDateMap.put(invoice.ivydsd__Store__c,invoice.ivydsd__Invoice_Date__c);
            
        }  
        system.debug('AccountDateMap'+AccountDateMap);
        list<Account> AccountList=[select id,LastInvoiceDate__c,SecondLastInvoiceDate__c from Account where id in:AccountDateMap.keyset()];  
        for(Account A:AccountList){
            if( AccountDateMap!=null && AccountDateMap.containskey(A.id) &&AccountDateMap.get(A.id)!=null && (A.LastInvoiceDate__c<AccountDateMap.get(A.id) || A.LastInvoiceDate__c==Null )){
                system.debug('******'+AccountDateMap.get(A.id));
                Integer monthDiff;
                if(A.SecondLastInvoiceDate__c!=null){
                    monthDiff = (A.SecondLastInvoiceDate__c).monthsBetween(AccountDateMap.get(A.id));
                    system.debug('monthDiff'+monthDiff);
                }
                if(A.SecondLastInvoiceDate__c==null || (monthDiff>1 && A.SecondLastInvoiceDate__c.month()!= A.LastInvoiceDate__c.month()) ){
                    //(A.LastInvoiceDate__c.month()!=AccountDateMap.get(A.id).month() && A.LastInvoiceDate__c.month()!= A.SecondLastInvoiceDate__c.month() && A.LastInvoiceDate__c.month()> A.SecondLastInvoiceDate__c.month() )){
                    A.SecondLastInvoiceDate__c=A.LastInvoiceDate__c;  //(A.LastInvoiceDate__c.month()> A.SecondLastInvoiceDate__c.month() || AccountDateMap.get(A.id).month()< A.SecondLastInvoiceDate__c.month() )
                }
                
                A.LastInvoiceDate__c=AccountDateMap.get(A.id);
            }
        }
        update AccountList;
    }*/
    /*public static void UpdateAccountLastVisitDate(list<ivybase__Visit__c> Visitlist){
        system.debug('Visitlist'+Visitlist);
        map<id,date> AccountVisitMap=new map<id,date>();
        ivybase__Visit__c previousvisit;
        for(ivybase__Visit__c Visit:Visitlist){
            
            if(previousvisit!=Null){
                if(AccountVisitMap.keyset().contains(visit.ivybase__Store__c))     {
                    if(AccountVisitMap.get(visit.ivybase__Store__c)> visit.ivybase__Visit_Date__c)
                        AccountVisitMap.put(visit.ivybase__Store__c,visit.ivybase__Visit_Date__c);
                }
                AccountVisitMap.put(visit.ivybase__Store__c,visit.ivybase__Visit_Date__c);
            }
            else
                AccountVisitMap.put(visit.ivybase__Store__c,visit.ivybase__Visit_Date__c);
            previousvisit=visit;
        }  
        system.debug('AccountVisitMap'+AccountVisitMap);
        list<Account> AccountList=[select id,Last_Visit_Date__c from Account where id in:AccountVisitMap.keyset()];  
        for(Account A:AccountList){
            if(A.Last_Visit_Date__c<AccountVisitMap.get(A.id) || A.Last_Visit_Date__c==Null )
                A.Last_Visit_Date__c=AccountVisitMap.get(A.id);
        }
        update AccountList;
    }*/
    /*public static void UpdateAccountAVGOrderValue(list<ivydsd__Order__c> OrderList){
        try{
            set<id> AccountId=new set<id>();
            list<Account> UpdateAccounts=new list<Account>();
            for(ivydsd__Order__c O:OrderList){
                AccountId.add(O.ivydsd__Store__c);
            }       
            list<Account> Accounts=[select id,Average_Order_Value__c from Account where id in:AccountId];
            system.debug('Accounts'+Accounts);
            //This map will be used while iterating over aggregate result and using this Grand_Total__c  field in Account record will get updated
            map<id,Account> AccountMap=new  map<id,Account>();        
            for(Account Account:Accounts){
                Account.Average_Order_Value__c=0;
                AccountMap.put(Account.id, Account);
            }
            
            //getting aggregate of LineTotal  field from all the records with grouping by parent
            AggregateResult[] groupedResults = [select AVG(ivydsd__Order_Value__c)Amt,ivydsd__Store__c from ivydsd__Order__c  where ivydsd__Store__c in:AccountMap.keyset() and ivydsd__Order_Status__c='Invoiced' group by ivydsd__Store__c];        
            if(groupedResults.size()>0){
                //iterating over the aggregate result and fetching the LineTotal aggregate value and assigning it to GrandTotal  in Account record
                Decimal d=    (Decimal)groupedResults[0].get('Amt');
                for(AggregateResult ar : groupedResults){          
                    if( (string)ar.get('ivydsd__Store__c')!=Null){
                        system.debug('entering');
                        AccountMap.get((string)ar.get('ivydsd__Store__c')).Average_Order_Value__c+=  (Decimal)ar.get('Amt');
                        UpdateAccounts.add( AccountMap.get((string)ar.get('ivydsd__Store__c')));
                    }
                } 
                
            }
            //in delete all, records scenario, no records will come, so setting the amount paid value to zero
            else{
                for(Account Account:Accounts){
                    Account.Average_Order_Value__c=0;
                    UpdateAccounts.add(Account);
                }
                
            }  
            //end of roll up
            
            //updating
            //Database.update(AccountMap.values(), false);
            if(UpdateAccounts.size()>0)
                Database.update(UpdateAccounts, false);
            //updatoing ended            
        }
        Catch(Exception e){
        }   
    }*/
    
    
    public static Set<Id> getkeyfromMapwithValue(Map<Id,Set<Id>> recMap,Set<Id> Value)
    {
        Set<Id> matchedKey = new Set<Id>();
        for(Id key:recMap.keySet())
        {
            for(Id v:Value){
                if(recMap.get(key).contains(v))
                {
                    matchedKey.add(key);
                }
            }
        }
        if(matchedKey.size()>0){
            return matchedKey;
        }else{
            return null;
        }        
    }
    
        public static AccountDomain.accountIdandNameInfo getAccountIdByInternalId(Set<String> retailerInternalIdSet1) {//used
        
        AccountDomain.accountIdandNameInfo accIdNameMaps = new AccountDomain.accountIdandNameInfo();
        String[] accountFields = new String[] {'ivybase__Internal_Id__c', 'Name','ivybase__Location_Hierarchy__c','ivybase__Active__c'};
            Map<String, Id> internalIdAndSFIdMap = new Map<String, Id>();
        Map<String, String> internalIdAndNameMap = new Map<String, String>();
        Map<String, Id> internalIdwithSFLocationIdMap = new Map<String, Id>();
        Set<Decimal> retailerInternalIdSet = new Set<Decimal>();
        
        for(String temp :retailerInternalIdSet1) {
            if (temp.isNumeric()) {
                retailerInternalIdSet.add(Decimal.ValueOf(temp));
            }
        }
        
        if(SecurityUtility.checkIsAccessible('Account',accountFields)) {
            List<Account> accountList = [SELECT Id,
                                         Name,
                                         ivybase__Internal_Id__c,
                                         ivybase__Location_Hierarchy__c
                                         FROM Account
                                         WHERE ivybase__Internal_Id__c IN :retailerInternalIdSet 
                                         AND ivybase__Active__c = 'Yes'];
            List<Account> accountListconq = [SELECT Id,
                                         Name,
                                         ivybase__Internal_Id__c,
                                         ivybase__Location_Hierarchy__c,Tid__c
                                         FROM Account
                                         WHERE Tid__c IN :retailerInternalIdSet1
                                         AND ivybase__Active__c = 'Yes' AND Is_Conquest__c= true];
            for(Account acct :accountList) {
                if (acct.ivybase__Internal_Id__c != null) {
                    internalIdAndSFIdMap.put(String.valueOf(acct.ivybase__Internal_Id__c), acct.Id);
                    internalIdAndNameMap.put(String.valueOf(acct.ivybase__Internal_Id__c), acct.Name);
                    if (acct.ivybase__Location_Hierarchy__c != null) {
                        internalIdwithSFLocationIdMap.put(String.valueOf(acct.ivybase__Internal_Id__c), acct.ivybase__Location_Hierarchy__c);
                    }
                }
            }
            
            for(Account acct1 :accountListconq) {
                if (acct1.ivybase__Internal_Id__c != null) {
                    internalIdAndSFIdMap.put(acct1.Tid__c, acct1.Id);
                    internalIdAndNameMap.put(acct1.Tid__c, acct1.Name);
                    if (acct1.ivybase__Location_Hierarchy__c != null) {
                        internalIdwithSFLocationIdMap.put(acct1.Tid__c, acct1.ivybase__Location_Hierarchy__c);
                    }
                }
            }
            	
            accIdNameMaps.internalIdAndSFIdMap = internalIdAndSFIdMap;
            accIdNameMaps.internalIdAndNameMap = internalIdAndNameMap;
            accIdNameMaps.internalIdwithSFLocationIdMap = internalIdwithSFLocationIdMap;
            return accIdNameMaps;
        } else {
            system.debug('Account is not Accessible');
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        } 
        
    }
    
    public static List<Account> getAccbyId(Set<Id> accIds) {
        
        String[] accFields = new String[] {'ivybase__Internal_Id__c', 'ivybase__Active__c','ivybase__Last_Visit__c','ivybase__Second_LastVisit__c'}; 
            List<Account> accList = new List<Account>();
        
        if (SecurityUtility.checkIsAccessible('Account', accFields)) {
            if (accIds != null && accIds.size() > 0) {
                accList = [SELECT Id, ivybase__Internal_Id__c,ivybase__Last_Visit__c,ivybase__Second_LastVisit__c FROM Account WHERE Id IN :accIds AND ivybase__Active__c = 'Yes'];
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
        return accList;
    }
    
    public static map<id,Agent_Salon_Mapping__c> getAgentSalonMappings (Set<Id> agentIds) {
        /********
        Getting division id for the resource as there is no Multi Divison for Now
       
         set<id> userTerritoryId= new set<id>();
        List<ivybase__Location_Hierarchy__c> userteritorylist= LocationMasterService.getUserTerritory();
        if(userteritorylist!=null && userteritorylist.size()>0){
            for(ivybase__Location_Hierarchy__c loc:userteritorylist){ 
                userTerritoryId.add(loc.id);
            }
        }
        set<id> userdivid=DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
        ************/
        String[] agentMappingFields = new String[] {'Agent__c', 'Salon__c', 'Salon__r.ivybase__Active__c'}; 
            List<Agent_Salon_Mapping__c> agentMappingList = new List<Agent_Salon_Mapping__c>();
        //set<Agent_Salon_Mapping__c> UniqueagentMappingList = new set<Agent_Salon_Mapping__c>();
        Map<id,Agent_Salon_Mapping__c> AgentsalonMAp = new Map<id,Agent_Salon_Mapping__c>();
        if (SecurityUtility.checkIsAccessible('Account', agentMappingFields)) {
            if (agentIds != NULL && !agentIds.isEmpty()) {
                agentMappingList = [SELECT  Agent__c,Agent__r.ivybase__Internal_Id__c,Division__c, Salon__c,Salon__r.ivybase__Internal_Id__c 
                                    FROM Agent_Salon_Mapping__c 
                                    WHERE Agent__c IN :agentIds  AND  Salon__r.ivybase__Active__c = 'Yes'];//AND Division__c IN:userdivid
           // UniqueagentMappingList.addAll(agentMappingList);
                for(Agent_Salon_Mapping__c ASM : agentMappingList){
                    AgentsalonMAp.put(ASM.Salon__c,ASM);
                }
               
                
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
        return AgentsalonMAp;
    }
    
    /*********************************Survey**************************/
    public static Map<String, Id> getAccIdbyInternalIdandrectype_Map(Set<String> internalIds1, String recordTypeName) {//used
        
        String[] accFields = new String[] {'ivybase__Internal_Id__c', 'ivybase__Active__c'}; 
            Set<Decimal> internalIds = new Set<Decimal>();
        
        for (String temp :internalIds1) {
            if (temp.isNumeric()) {
                internalIds.add(Decimal.valueOf(temp));
            }
        }
        
        if (SecurityUtility.checkIsAccessible('Account', accFields)) {
            if (internalIds != null && recordTypeName != null && internalIds.size() > 0) {
                Map<String, Id> accInternalIdwithAccIdMap = new Map<String, Id>();
                for (Account acc: [SELECT Id, ivybase__Internal_Id__c FROM Account WHERE ivybase__Internal_Id__c != NULL AND ivybase__Internal_Id__c IN:internalIds AND RecordType.DeveloperName =:recordTypeName AND ivybase__Active__c = 'Yes']) {
                    accInternalIdwithAccIdMap.put(String.valueOf(acc.ivybase__Internal_Id__c), acc.Id);
                }    
                return accInternalIdwithAccIdMap;
            }
        } else {
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','Account');
            // return null;
        }
        return null;
    }
    
    
    
    /*****************************************Method end*******************************/
    /*********New Method for Update the Junction Object related to accountresource Visit**************/
    
    
    
    
    
    
    /*****************************************Method end*******************************/
    
    
}