public class RetailerEditUploadTranslator {

    public static void translate(List<LorealUploadclass.NewRetailerEditHeaderInfo> retailerEditHeader, List<LorealUploadclass.NewRetailerEditDetailInfo> retailerEditDetail,List<LorealUploadclass.HairDresserInfo> HairdresserList) {
        system.debug('retailerEditHeader'+retailerEditHeader);
        system.debug('retailerEditDetail'+retailerEditDetail);
        Set<String> retailerInterIdSet = new Set<String>();
        Set<String> storehieInterIdSet = new Set<String>();
        Set<String> lochieInterIdSet = new Set<String>();
        Map<String,String> codeandflexMap = new Map<String,String>();
        Map<String,LorealUploadclass.NewRetailerEditHeaderInfo> TidAndretailerHeaderMap = new Map<String,LorealUploadclass.NewRetailerEditHeaderInfo>();
        Map<String,LorealUploadclass.NewRetailerEditHeaderInfo> TidAndNewHeaderMap = new Map<String,LorealUploadclass.NewRetailerEditHeaderInfo>();
        Map<String,List<LorealUploadclass.NewRetailerEditDetailInfo>> TidAndretailerdetMap = new Map<String,List<LorealUploadclass.NewRetailerEditDetailInfo>>();
        Map<String,String> APInameandtypeMap = new Map<String,String>();
        Map<String,String> ConAPInameandtypeMap = new Map<String,String>();
        List<Account> updateAccountList = new List<Account>();

        List<Account> insertAccountList = new List<Account>();//
        List<Account> BillToUpdateList = new List<Account>();//

        List<Account> updateAccounts = new List<Account>();//


        Map<String,String> storeIdTidMap = new Map<String,String>();
        List<Contact> contactList = new List<Contact>();
        set<id> AccountIds=new set<id>();

        List<account> ShipToUpdateList = new List<Account>();
        List<account> BillToUpdateListNew = new List<Account>();
        List<account> ShipToUpdateListNew = new List<Account>();
        List<Partner_Function__c> partnerList = new List<Partner_Function__c>();
        Account BillToUpdate = new Account();
        Account ShipToUpdate = new Account();
        String ShipToAddress;
        String BillToAddress;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.Account.getRecordTypeInfosByName();
        system.debug(RT);
        Map<String,Account> accInfo = new Map<String,Account>();
        String hostUrl;
        // Getting hosturl to append to signature field of account
        for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('COMPETITOR_TRACKING_TYPE'),('Amazon_Configuration')})){
            if(stdListMaster.ivybase__List_Code__c=='AS_HOST')
                hostUrl= stdListMaster.ivybase__List_Name__c;
        }


        for(LorealUploadclass.NewRetailerEditHeaderInfo retailerhead : retailerEditHeader) {
            System.debug('retailerEditHeader::: '+retailerEditHeader); 
            System.debug('retailer::'+!String.ISBLANK(retailerhead.RetailerId));
            if(!String.ISBLANK(retailerhead.RetailerId)){
                retailerInterIdSet.add(retailerhead.RetailerId);
                TidAndretailerHeaderMap.put(retailerhead.Tid,retailerhead);
            }
            if(!String.ISBLANK(retailerhead.isNew)){
                TidAndNewHeaderMap.put(retailerhead.Tid,retailerhead);
            }
        }
        System.debug('retailer Set:::: '+retailerInterIdSet);
        if(retailerInterIdSet.size() > 0 ){
            System.debug('Inside retailerInterIdSet:: '+retailerInterIdSet);
            accInfo = AccountService.getAccountByInternalId(retailerInterIdSet);
            System.debug('account Test:: '+accInfo);
        }


        Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
        Schema.DescribeSObjectResult con = Contact.sObjectType.getDescribe();

        for(string apiName : r.fields.getMap().keySet()) {
            system.debug('apiName'+apiName);
            system.debug('type'+String.ValueOf(r.fields.getMap().get(apiName).getDescribe().getType()));
            APInameandtypeMap.put(apiName,String.ValueOf(r.fields.getMap().get(apiName).getDescribe().getType()));
        }
        for(string apiName : con.fields.getMap().keySet()){
            ConAPInameandtypeMap.put(apiName,String.ValueOf(con.fields.getMap().get(apiName).getDescribe().getType())); 
        }
        System.debug('Sobject::: '+r);
        System.debug('APInameandtypeMap::: '+APInameandtypeMap);
        // system.debug('APInameandtypeMapname'+APInameandtypeMap.get(Name));


        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;

        List<ivybase__Standard_List_Master__c> slmList = StandardListMasterService.getStandardListUsingListType(New List<String> {'LEGAL_ENTITY','MODE_OF_PAYMENT','CHANNEL_HIERARCHY','LUXURY_MAG', 'LUXURY_MAG_SEGMENTATION'});

        Map<String, String> listCodeWithName = new Map<String,String>();

        if (slmList != null && slmList.size() > 0) {
            for (ivybase__Standard_List_Master__c slm : slmList) {

                listCodeWithName.put(slm.Name,slm.ivybase__List_Name__c);
            }
        }
        System.debug('APInameandtypeMap.keyset():::'+APInameandtypeMap.keyset());
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = [Select Id, ivybase__Related_User__c,ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c =:userId];
        List<ivybase__HHTMenu_Master__c> HHTmenulist = [SELECT Id,name,ivybase__Flag__c,ivybase__Flex__c,ivybase__MenuType__c
                                                        FROM ivybase__HHTMenu_Master__c 
                                                        Where ivybase__MenuType__c = 'RETAILER_PROFILE'
                                                        AND ivybase__Flex__c != null
                                                        AND ivybase__Flag__c = 1
                                                        AND ivybase__Location_Hierarchy__c=:res.ivybase__Location_Hierarchy__c]; 

        System.debug('HHTmenulist::: '+HHTmenulist);
        if(HHTmenulist != null && HHTmenulist.size() > 0) { 

            for(ivybase__HHTMenu_Master__c hhtmenu : HHTmenulist) {
                System.debug('hhtmenu::: '+hhtmenu);
                if(!codeandflexMap.containskey(hhtmenu.name)){
                    codeandflexMap.put(hhtmenu.name,hhtmenu.ivybase__Flex__c);
                    System.debug('codeandflexMap::: '+codeandflexMap);
                }
            }
        }
        map<string,decimal> accTidAgentinternalIdMap = new map<string,decimal>();
        for(LorealUploadclass.NewRetailerEditDetailInfo retailerdet : retailerEditDetail) {
            if(retailerdet.Code =='PROFILE_LO_76' && !string.isBlank(retailerdet.Value) && retailerdet.Value!='0'){
                accTidAgentinternalIdMap.put(retailerdet.Tid,decimal.valueof(retailerdet.Value));
            }

            if(!TidAndretailerdetMap.containskey(retailerdet.Tid)) {
                TidAndretailerdetMap.put(retailerdet.Tid,new List<LorealUploadclass.NewRetailerEditDetailInfo>());
            }
            TidAndretailerdetMap.get(retailerdet.Tid).add(retailerdet);
            System.debug('retailerdet.Code===>'+retailerdet.Code);
            System.debug('retailerdet.Value===>'+retailerdet.Value);
            if(!String.ISBlank(retailerdet.code) && codeandflexMap.get(retailerdet.code) != NULL && !String.ISBlank(retailerdet.Value)) {

                if(codeandflexMap.get(retailerdet.code) == 'ivybase__Store_Hierarchy__c') {
                    storehieInterIdSet.add(retailerdet.Value);
                } else if (codeandflexMap.get(retailerdet.code) == 'ivybase__Location_Hierarchy__c') {
                    lochieInterIdSet.add(retailerdet.Value);
                }
            }

        }

        Map<String,ivybase__Store_Hierarchy__c> InterIdandStoreHieMap = new Map<String,ivybase__Store_Hierarchy__c>();
        Map<String,ivybase__Location_Hierarchy__c> InterIdandLocHieMap = new Map<String,ivybase__Location_Hierarchy__c>();

        for(ivybase__Store_Hierarchy__c stoHie : [SELECT Id,ivybase__Internal_Id__c,ivybase__Level__c,ivybase__Parent__c FROM ivybase__Store_Hierarchy__c WHERE ivybase__Internal_Id__c IN:storehieInterIdSet AND ivybase__Active__c = 'Yes']) {

            if(!InterIdandStoreHieMap.containskey(stoHie.ivybase__Internal_Id__c)){
                InterIdandStoreHieMap.put(stoHie.ivybase__Internal_Id__c,stoHie);
            }
        }

        for(ivybase__Location_Hierarchy__c locHie : [SELECT Id,ivybase__Internal_Id__c,ivybase__Level__c,ivybase__Parent__c FROM ivybase__Location_Hierarchy__c WHERE ivybase__Internal_Id__c IN: lochieInterIdSet AND ivybase__Active__c = 'Yes']) {

            if(!InterIdandLocHieMap.containskey(locHie.ivybase__Internal_Id__c)){
                InterIdandLocHieMap.put(locHie.ivybase__Internal_Id__c,locHie);
            }
        }
        String retail_AccountRecordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName = 'Retail_Account' Limit 1].Id;
        for(String retailerdetTid : TidAndretailerdetMap.keyset()) {
            ivybase__Account_Update_Request__c accuptreq = new ivybase__Account_Update_Request__c();
            Account accUpdate = new Account();

            if(accInfo != null && TidAndretailerHeaderMap.get(retailerdetTid) != null && TidAndretailerHeaderMap.get(retailerdetTid).RetailerId != NULL && TidAndretailerHeaderMap.get(retailerdetTid).RetailerId != '' &&
               accInfo.ContainsKey(TidAndretailerHeaderMap.get(retailerdetTid).RetailerId)) {
                accUpdate.Id = (accInfo.get(TidAndretailerHeaderMap.get(retailerdetTid).RetailerId)).Id;
                System.debug('accUpdate.Id::: '+accUpdate.Id);
                accUpdate.Tid__c= retailerdetTid;
            }else{
                accUpdate.Tid__c= retailerdetTid;
                accUpdate.ivybase__Resource__c = res.Id;
                accUpdate.Location_Hierarchy__c=res.ivybase__Location_Hierarchy__c;
                accUpdate.RecordTypeId = retail_AccountRecordTypeId;
                BillToUpdate.RecordTypeId = retail_AccountRecordTypeId;
                ShipToUpdate.RecordTypeId = retail_AccountRecordTypeId;

                if(TidAndNewHeaderMap.get(retailerdetTid).isNew == '1')
                    accUpdate.Is_Conquest__c = true;   
            }
            for(LorealUploadclass.NewRetailerEditDetailInfo retailerdet : TidAndretailerdetMap.get(retailerdetTid)) {
                if(codeandflexMap.get(retailerdet.code) != NULL && retailerdet.value != NULL && retailerdet.value != '' ) {
                    String apiname = codeandflexMap.get(retailerdet.code).tolowercase();
                    System.debug('apiname VEER===>'+apiname);
                    if(APInameandtypeMap.get(apiname) != NULL && !String.ISBLANK(APInameandtypeMap.get(apiname))) {

                        if(APInameandtypeMap.get(apiname) == 'STRING'|| APInameandtypeMap.get(apiname) == 'PICKLIST' || APInameandtypeMap.get(apiname) == 'EMAIL' || APInameandtypeMap.get(apiname) == 'TEXTAREA' || APInameandtypeMap.get(apiname) == 'URL' || APInameandtypeMap.get(apiname) == 'MULTIPICKLIST' || APInameandtypeMap.get(apiname) == 'PHONE') {
                            /*System.debug('retailerdet.value===>'+retailerdet.value);
                            System.debug('retailerdet.code===>'+retailerdet.code);
                            System.debug('listCodeWithName===>'+listCodeWithName);
                            System.debug('APInameandtypeMap===>'+APInameandtypeMap);
                            System.debug('apiname===>'+apiname);
                            System.debug('APInameandtypeMap.get(apiname)===>'+APInameandtypeMap.get(apiname));*/
                            if(listCodeWithName.containsKey(retailerdet.value)){
                                if(apiname.equalsIgnoreCase('Legal_Entity_Type__c')){
                                    system.debug('Legal_Entity_Type__c');
                                    accUpdate.Legal_Entity_Type__c = listCodeWithName.get(retailerdet.value);
                                }

                                else if(apiname.equalsIgnoreCase('Mode_of_Payment__c')){
                                    accUpdate.Mode_of_Payment__c = listCodeWithName.get(retailerdet.value);
                                }
                                else if(apiname.equalsIgnoreCase('ivybase__Customer_Category__c')){
                                    accUpdate.ivybase__Customer_Category__c = listCodeWithName.get(retailerdet.value);
                                }
                                else if(apiname.equalsIgnoreCase('Kerastase_Luxury_Mag__c')){
                                    accUpdate.Kerastase_Luxury_Mag__c = listCodeWithName.get(retailerdet.value);
                                }

                            } 
                            else{
                                if(apiname == 'Billing_Address__c'||apiname == 'Shipping_Address__c'||apiname == 'Store_Address__c' ||
                                   apiname == 'No_of_Stylist__c'|| apiname == 'No_of_Chairs__c'||apiname =='No_of_Backwash_Units__c'||
                                   apiname =='Color_Price__c'||apiname =='Treatment_Price__c'||apiname =='Cutting_Price__c'||
                                   apiname =='Blow_Dry_Price__c'||apiname =='Texture_Price__c'|| apiname =='Key_Competitor__c'||
                                   apiname =='Customer_Attribute1__c'||apiname =='Customer_Attribute2__c'||apiname =='Customer_Attribute3__c'
                                   ||apiname =='Customer_Attribute4__c'||apiname =='Customer_Attribute5__c' || apiname=='ivybase__Active__c'  ){
                                    if(accUpdate.id==null){
                                        if(apiname.equalsIgnoreCase('Billing_Address__c')){
                                            accUpdate.Billing_Address__c=retailerdet.value;
                                        }else if(apiname.equalsIgnoreCase('Shipping_Address__c')){
                                            accUpdate.Shipping_Address__c=retailerdet.value;
                                        }

                                        //MAG CLASSIFICATION FIELDS :

                                        /* else if(apiname.equalsIgnoreCase('Key_Competitor__c')){
                                               accUpdate.Key_Competitor__c = retailerdet.value;
                                           }
                                           else if(apiname.equalsIgnoreCase('Customer_Attribute1__c')){
                                               accUpdate.Customer_Attribute1__c=retailerdet.value;
                                           }
                                           else if(apiname.equalsIgnoreCase('Customer_Attribute2__c')){
                                               accUpdate.Customer_Attribute2__c=retailerdet.value;
                                           }
                                           else if(apiname.equalsIgnoreCase('Customer_Attribute3__c')){
                                               accUpdate.Customer_Attribute3__c=retailerdet.value;
                                           }
                                           else if(apiname.equalsIgnoreCase('Customer_Attribute4__c')){
                                               accUpdate.Customer_Attribute4__c=retailerdet.value;
                                           }
                                           else if(apiname.equalsIgnoreCase('Customer_Attribute5__c')){
                                               accUpdate.Customer_Attribute5__c=retailerdet.value;
                                           }*/
                                    }
                                    //deactivating conquest based on 0 or 1 // added by prabnav on 17/12/2019
                                    if(apiname =='ivybase__Active__c'){
                                        if(retailerdet.value=='0'){
                                            accUpdate.ivybase__Active__c='No'; 
                                        }else if(retailerdet.value=='1'){
                                            accUpdate.ivybase__Active__c='Yes';
                                        }
                                    }
                                    if(apiname == 'Store_Address__c'){
                                        accUpdate.Store_Address__c = retailerdet.value;
                                    }
                                    //MAG CLASSIFICATION FIELDS :

                                    else if(apiname.equalsIgnoreCase('Key_Competitor__c')){
                                        accUpdate.Key_Competitor__c = retailerdet.value;
                                    }
                                    else if(apiname.equalsIgnoreCase('Customer_Attribute1__c')){
                                        accUpdate.Customer_Attribute1__c=retailerdet.value;
                                    }
                                    else if(apiname.equalsIgnoreCase('Customer_Attribute2__c')){
                                        accUpdate.Customer_Attribute2__c=retailerdet.value;
                                    }
                                    else if(apiname.equalsIgnoreCase('Customer_Attribute3__c')){
                                        accUpdate.Customer_Attribute3__c=retailerdet.value;
                                    }
                                    else if(apiname.equalsIgnoreCase('Customer_Attribute4__c')){
                                        accUpdate.Customer_Attribute4__c=retailerdet.value;
                                    }
                                    else if(apiname.equalsIgnoreCase('Customer_Attribute5__c')){
                                        accUpdate.Customer_Attribute5__c=retailerdet.value;
                                    }
                                }

                                else{
                                    accUpdate.put(apiname,retailerdet.value);    
                                }
                            }

                        }
                        else if (APInameandtypeMap.get(apiname) == 'DOUBLE'|| APInameandtypeMap.get(apiname) == 'CURRENCY'){
                            if(retailerdet.value!=null && String.isEmpty(retailerdet.value)==false){
                                accUpdate.put(apiname,ConversionUtility.StringToDecimal(retailerdet.value));
                                System.debug('apiname:: '+apiname+'Vanlue:: '+ ConversionUtility.StringToDecimal(retailerdet.value));
                            }

                        } else if (APInameandtypeMap.get(apiname) == 'DATETIME'|| APInameandtypeMap.get(apiname) == 'DATE'){
                            if(retailerdet.value!=null && !String.isBlank(retailerdet.value)){
                                accUpdate.put(apiname, ConversionUtility.StringToDateConversion(retailerdet.value));
                            }
                        } else if (APInameandtypeMap.get(apiname) == 'BOOLEAN') {

                            System.debug('Checkbox'+APInameandtypeMap.get(apiname.tolowercase()));
                            If(retailerdet.value == '1') {
                                accUpdate.put(apiname,TRUE);
                            } else {
                                accUpdate.put(apiname,FALSE);
                            }

                        } else {
                            System.debug('field type to add'+APInameandtypeMap.get(apiname.tolowercase()));
                        }


                    }


                }//if
            }// for 
			
            for(account ac :insertAccountList){
                    system.debug('active '+ac.ivybase__Active__c);
                }
            
            if(accUpdate.id!=null){
                updateAccountList.add(accUpdate);    
            }else{
                insertAccountList.add(accUpdate);
            }
        }

        if (updateAccountList.size() > 0) {
            try{
                System.debug('updated AccountList:::'+updateAccountList);
                update updateAccountList;

            }catch(Exception e){
                system.debug('errormesage'+e.getMessage());
                CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
            }
        }
        if (insertAccountList.size() > 0) {
            try{
                System.debug('inserted AccountList:::'+insertAccountList);
                insert insertAccountList; 

            }catch(Exception e){
                system.debug('errormesage'+e.getMessage());
                CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
            }
        }



        list<Account>billTo_AccountList = new list<Account>();
        list<Account>shipTo_AccountList = new list<Account>();

        for(Account acc:insertAccountList){
            if(acc.Billing_Address__c!=null){
                Account tempAccount = acc.clone(false,true,false,false);
                tempAccount.Name='BillTo '+tempAccount.Name;
                tempAccount.Store_Address__c=tempAccount.Billing_Address__c;
                tempAccount.Shipping_Address__c=null;
                tempAccount.ivybase__StoreCode__c=null;
                tempAccount.ivybase__Resource__c=null;
                tempAccount.Is_Conquest__c = false;
                tempAccount.Converted_to_Normal_Saloon__c = true;
                billTo_AccountList.add(tempAccount);
            }
            if(acc.Shipping_Address__c!=null){
                Account tempAccount = acc.clone(false,true,false,false);
                tempAccount.Name='ShipTo '+tempAccount.Name;
                tempAccount.Store_Address__c=tempAccount.Shipping_Address__c;
                tempAccount.Billing_Address__c=null;
                tempAccount.ivybase__StoreCode__c=null;
                tempAccount.ivybase__Resource__c=null;
                tempAccount.Is_Conquest__c = false;
                tempAccount.Converted_to_Normal_Saloon__c = true;
                shipTo_AccountList.add(tempAccount);
            }
        }
        insert billTo_AccountList;
        insert shipTo_AccountList;

        //==========================================//
        for(Account acc : insertAccountList){
            system.debug('ID '+acc.id);
            system.debug('Active123  '+acc.ivybase__Active__c);
            if(acc.ivybase__Active__c == 'No'){
            acc.ivybase__Active__c = 'No';
            }
            else {
                acc.ivybase__Active__c = 'YES';
            }
            acc.Billing_Address__c=null;
            acc.Shipping_Address__c=null;
            updateAccounts.add(acc);
        }
        for(Account acc : billTo_AccountList){
            acc.ivybase__Active__c = 'Yes';
            updateAccounts.add(acc);
        }
        for(Account acc : shipTo_AccountList){
            acc.ivybase__Active__c = 'Yes';
            updateAccounts.add(acc);
        }

        if (updateAccounts.size() > 0) {
            try{
                update updateAccounts;
            }catch(Exception e){
                CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
            }
        }
        //==========================================//
        for(Account acc : insertAccountList){
            storeIdTidMap.put(acc.Tid__c,acc.Id);
            AccountIds.add(acc.Id);
        }
        //Invoking hairdreser

        if(HairdresserList!=null){
            HairDresserUploadTranslator.translateHairDresser(HairdresserList,storeIdTidMap);
        }



        //-----Assiging division to partner function started
        Id sellerId = ResourceService.getLoginSellerId();
        List<ivybase__Location_Hierarchy__c> userterritorylist= LocationMasterService.getUserTerritory();
        set<id> teritoryid= new set<id>();
        for(ivybase__Location_Hierarchy__c loct:userterritorylist){
            teritoryid.add(loct.id);
        }
        Set<Id> divids=DivisionSerivce.getDivisionForUserTerritory(teritoryid);
        list<id> divid_list=new list<id>();
        divid_list.addAll(divids);
        //------
        /*************************Adding agent for conquest*******added by pranav on 17122019****/
        if(accTidAgentinternalIdMap!=null){
            list<account> acclistdata= [select id, name,tid__c 
                                        from account 
                                        where tid__c IN: accTidAgentinternalIdMap.keyset() AND Is_Conquest__c=TRUE ];
            map<decimal, string> agentInternalIdVsID= new map<decimal, string>();
            list<account> acclistAgentData= [select id, tid__c,ivybase__Internal_Id__c 
                                             from account 
                                             where ivybase__Internal_Id__c IN:accTidAgentinternalIdMap.values() ];
            if(acclistAgentData!=null && acclistAgentData.size()>0){
                for(account ac:acclistAgentData){
                    agentInternalIdVsID.put(ac.ivybase__Internal_Id__c,ac.id);
                }
            }
            //iterating on conquest salons to map with agents
            list<Agent_Salon_Mapping__c> insertagentsalonlist = new list<Agent_Salon_Mapping__c> ();
            if(acclistdata!=null && acclistdata.size()>0){
                for(account actconqstdata : acclistdata ){
                    Agent_Salon_Mapping__c agsm = new Agent_Salon_Mapping__c ();
                    agsm.Salon__c=actconqstdata.id;
                    if(accTidAgentinternalIdMap.containskey(actconqstdata.tid__c) && accTidAgentinternalIdMap.get(actconqstdata.tid__c)!=null && agentInternalIdVsID.containskey(accTidAgentinternalIdMap.get(actconqstdata.tid__c)) && agentInternalIdVsID.get(accTidAgentinternalIdMap.get(actconqstdata.tid__c))!=null )
                        agsm.Agent__c=agentInternalIdVsID.get(accTidAgentinternalIdMap.get(actconqstdata.tid__c));
                    if(divid_list.size()>0)
                        agsm.Division__c = divid_list[0];
insertagentsalonlist.add(agsm);
                }
                
            }
            
            if (insertagentsalonlist.size() > 0) {
            try{
                System.debug('insertagentsalonlist:::'+insertagentsalonlist);
                insert insertagentsalonlist;

            }catch(Exception e){
                system.debug('errormesage'+e.getMessage());
                CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
            }
        }

        }//main if ends

        /*************end*******************/


        //invoking hairdesser end
        for(Account Billacc : billTo_AccountList){
            System.debug('storeIdTidMap====>'+storeIdTidMap);
            System.debug('Billacc.Tid__c====>'+Billacc.Tid__c);
            if(storeIdTidMap.get(Billacc.Tid__c)!=null){
                Partner_Function__c partner = new Partner_Function__c();
                partner.Account__c = storeIdTidMap.get(Billacc.Tid__c);
                partner.Partner__c = Billacc.Id;
                partner.Type__c = 'Bill To';
                partner.Active__c=True;
                if(divid_list.size()>0)
                    partner.Division__c=divid_list[0];
                partnerList.add(partner);
            }
        }
        for(Account Shipacc : shipTo_AccountList){
            if(storeIdTidMap.get(Shipacc.Tid__c)!=null){
                Partner_Function__c partner = new Partner_Function__c();
                partner.Account__c = storeIdTidMap.get(Shipacc.Tid__c);
                partner.Partner__c = Shipacc.Id;
                partner.Type__c = 'Ship To';
                partner.Active__c=True;
                if(divid_list.size()>0)
                    partner.Division__c=divid_list[0];
                partnerList.add(partner);
            }
        }
        if (partnerList.size() > 0) {
            try{
                System.debug('updated partnerList:::'+partnerList);
                upsert partnerList;

            }catch(Exception e){
                system.debug('errormesage'+e.getMessage());
                CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
            }
        }
        system.debug('AccountIds'+AccountIds);
        System.debug('storeIdTidMap:: '+storeIdTidMap);
        try{
            map<string,contact> AccountContactroleMap=RetailerContactService.getContactRoleMap(AccountIds);
            system.debug('AccountContactroleMap'+AccountContactroleMap);
            for(String retailerTid : TidAndretailerdetMap.keyset()) {
                system.debug('hey');
                // map<string,contact> ContactAndRoleMap=new map<string,contact>();
                system.debug('codeandflexMap1'+codeandflexMap.values());
                System.debug('TidAndretailerdetMap.get(retailerTid)::: '+TidAndretailerdetMap.get(retailerTid));
                for(LorealUploadclass.NewRetailerEditDetailInfo retailerdet : TidAndretailerdetMap.get(retailerTid)){
                    system.debug('codeandflexMap.get(retailerdet.code)'+codeandflexMap.get(retailerdet.code));
                    //system.debug('codeandflexMap.get(retailerdet.code)'+codeandflexMap.get(retailerdet.code).contains('Contact'));
                    if(codeandflexMap.get(retailerdet.code) != NULL && retailerdet.value != NULL && retailerdet.value != '' && codeandflexMap.get(retailerdet.code).contains('Contact.') ) {
                        system.debug('codeandflexMap.get(retailerdet.code).split'+codeandflexMap.get(retailerdet.code).split('.'));
                        string[] k=codeandflexMap.get(retailerdet.code).split('\\.');
                        System.debug('splitted value::: '+k);
                        System.debug('AccountContactroleMap::'+AccountContactroleMap); 
                        // if(AccountContactroleMap.keySet().size()>0)
                        system.debug('hh'+storeIdTidMap.get(retailerTid)+'.'+k.get(1));
                        system.debug('AccountContactroleMapkeyset'+AccountContactroleMap.keyset());
                        if(AccountContactroleMap.keySet().contains(storeIdTidMap.get(retailerTid)+'.'+k.get(1))){
                            system.debug('ggg');
                            system.debug(AccountContactroleMap.get(storeIdTidMap.get(retailerTid)+'.'+k.get(1)));
                            AccountContactroleMap.get(storeIdTidMap.get(retailerTid)+'.'+k.get(1)).put(k.get(2),retailerdet.value);
                        }
                        else{
                            contact c=new contact();
                            System.debug('key:: '+k.get(2));
                            System.debug('value:: '+retailerdet.value);
                            c.put(k.get(2),retailerdet.value);
                            c.Contact_Role__c= k.get(1);
                            c.AccountId=storeIdTidMap.get(retailerTid);
                            AccountContactroleMap.put(storeIdTidMap.get(retailerTid)+'.'+ k.get(1),c);
                            //contactList.add(c);
                            System.debug('contactList when added::'+AccountContactroleMap);

                        }


                    }

                }


            }
            System.debug('Map Size:::'+AccountContactroleMap.size());
            if (AccountContactroleMap.size() > 0) {
                system.debug('contactrecords'+AccountContactroleMap.values());

                System.debug('inserted:: '+AccountContactroleMap.values());
                Database.upsert (AccountContactroleMap.values(),false);


            }
        }
        Catch(Exception e){
            system.debug('erro'+e.getMessage());
            CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
        }
        List<Document__c> documents = new List<Document__c>();
        List<Document__c> updatedocuments = new List<Document__c>();
        map<string,Document__c> DocAccoucountMap=new map<string,Document__c>();
        documents = RetailerDocumentService.getAllDocuments(AccountIds);
        // system.debug('');
        for(Document__c d:documents)
            DocAccoucountMap.put(d.Name+','+d.Retailer__c,d);
        system.debug('DocAccoucountMap'+DocAccoucountMap);
        for(String retailerTid : TidAndretailerdetMap.keyset()) {
            // set<Id> accountIds = new Set<Id>();

            for(LorealUploadclass.NewRetailerEditDetailInfo retailerdet : TidAndretailerdetMap.get(retailerTid)){
                // accountIds.add(storeIdTidMap.get(retailerTid));
                System.debug('Sobject:: '+codeandflexMap.get(retailerdet.code));
                // system.debug()
                if(codeandflexMap.get(retailerdet.code)=='Document__c'){
                    if(!String.isBlank(storeIdTidMap.get(retailerTid))){
                        If(retailerdet.value == 'true' && !String.isBlank(retailerdet.code)) {
                            System.debug('DocAccoucountMap::: '+DocAccoucountMap);
                            System.debug('Available:: '+storeIdTidMap.get(retailerTid));
                            if(DocAccoucountMap.containsKey(retailerdet.code+','+storeIdTidMap.get(retailerTid)))
                            {
                                DocAccoucountMap.get(retailerdet.code+','+storeIdTidMap.get(retailerTid)).Available__c = true;
                            }

                        } else {
                            if(DocAccoucountMap.containsKey(retailerdet.code+','+storeIdTidMap.get(retailerTid)))
                            {
                                DocAccoucountMap.get(retailerdet.code+','+storeIdTidMap.get(retailerTid)).Available__c = false;
                            }
                        }
                        updatedocuments.add( DocAccoucountMap.get(retailerdet.code+','+storeIdTidMap.get(retailerTid))); 
                        System.debug('updatedocuments:::'+updatedocuments);

                    }


                }


            }
        }if(updatedocuments.size() > 0){

            try{

                update updatedocuments;
                System.debug('updatedocuments:::'+updatedocuments);
            }catch(Exception e){
                system.debug('errormesage'+e.getMessage());
                CommonUtility.mobileAppErrorCodesMap.get(''+e.getMessage());
            }
        }




    }



    public static Date convertStringToDate(String datestr){

        Date dateVal;
        if(!String.isBlank(datestr)){
            List<String> dateList = datestr.split('/');
            dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));

        }
        return dateVal;
    }

}