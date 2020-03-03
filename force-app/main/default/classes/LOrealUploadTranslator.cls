public class LOrealUploadTranslator {
    
    public static Map<String, Id> visitStoreDateWithVisitSFIdMap = new Map<String, Id>();
    public static List<ivybase__Standard_List_Master__c> reasonlist;
    
    
    /* This method is only for japan */
    public static LIST<PostResponse.PostResponseObject> AdhocActivityPlanDetailTransaction(LIST<LorealUploadclass.AdhocActivityPlanDetailInfo> AdhocActivityDetail) {
        
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        
        try{
            
            AdhocTranslator.translateData(AdhocActivityDetail);
            
        } catch(Exception e) {
            
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
    }
    
    
    
    /* Method to insert Rintin and Doko */
    public static LIST<PostResponse.PostResponseObject> RintinDokoTransaction(List<LorealUploadclass.RintinDokoHeaderInfo> RintinDokoHeader,List<LorealUploadclass.RintinDokoSalonDetailsInfo> RintinDokoSalonDetailsInfo, List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo> RintinDokoHairdresserAndAgentDetails){
        
        system.debug('RintinDokoHeader'+ RintinDokoHeader);
        //system.debug('RintinDokoSalonDetailsInfo'+ RintinDokoSalonDetailsInfo);
        //system.debug('RintinDokoHairdresserAndAgentDetails'+ RintinDokoHairdresserAndAgentDetails);
        
        
        boolean allSuccess=true;
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        
        //set<string> TIdset = new set<string>(); //set to hold all the Tid
        MAP<String,Id> TidAndSalesforceIdMap = new MAP<String,Id>(); // MAP to store transaction Id and Rintin Plan Id 
        SET<string> tidInSfSET=new SET<string>(); //To store the TId present in salesforce
        // MAP to store transaction Id and Response from Mobility 
        MAP<string,LorealUploadclass.RintinDokoHeaderInfo> tidVsRintinPlanJsonMap =new MAP<string,LorealUploadclass.RintinDokoHeaderInfo>(); 
        SET<String> idNotinSFSET = new SET<String>(); // SET to store TId not present in SF
        
        /* Map to  store transaction id and plan Id (Internal Id) */
        MAP<String, String> TidJourneyPlanMAP = new MAP<String, String>();
        SET<String> productHierarchyInternalIdSet = new SET<String>();  // To store product hierarchy internal Id
        SET<Decimal> productInternalIdSet = new SET<Decimal>();// To product internal Id
        
        MAP<String,Id> internalIdProductHierarchyIdMap = new MAP<String,Id>();// To store internalIdProductIdMap
        MAP<String,Id> internalIdProductIdMap = new MAP<String,Id>();// Map to store productId and Internal Id
        
        Map<Decimal, String> internalIdANDSoldToMap = new Map<Decimal, String>();
        Set<Long> salonInternalIdSET = new Set<Long>();
        
        /* Checking of RintinDokoHeader is not NULL */
        if(RintinDokoHeader != NULL) {
            for(LorealUploadclass.RintinDokoHeaderInfo rintinPlan : RintinDokoHeader) {
                TidJourneyPlanMAP.put(rintinPlan.TId, rintinPlan.PlanId);
                if (String.isNotBlank(rintinPlan.OrgSalonCode)) {
                    salonInternalIdSET.add(Long.valueOf(rintinPlan.OrgSalonCode));
                }
            }
            
            LIST<JourneyPlan__c> journeyPlanLIST = new LIST<JourneyPlan__c>();
            
            /* Quering journey plans where internal Ids present in upload */
            journeyPlanLIST = [SELECT Id,Tid__c,InternalId__c,Status__c, Month__c,Year__c
                               FROM JourneyPlan__c   
                               WHERE InternalId__c IN: TidJourneyPlanMAP.Values() OR Tid__c IN: TidJourneyPlanMAP.Values()];
            
            /* Set to store internalIds for Journey plan where status is not approved */
            SET<String> internalIDSET = new SET<String>(); 
            MAP<String,JourneyPlan__c> internalIdandJourneyPlanIdMAP = new MAP<String,JourneyPlan__c>();
            
            // To store journey plan details, To delete Rintin plan and Rintin plan details
            LIST<Id> journeyPlanIdList = new LIST<Id>(); 
            
            for(JourneyPlan__c jp: journeyPlanLIST) {
                // Commented bcz after upload also Ritin plan can be uploaded like adhoc
                //if(jp.Status__c != 'Approved') {
                internalIDSET.add(jp.Tid__c);//changed to tid from intebral id
                internalIdandJourneyPlanIdMAP.put(jp.Tid__c,jp); //changedd to Tid from internal id
                journeyPlanIdList.add(jp.Id);
                //}
            }
            
            system.debug('internalIDSET ' + internalIDSET);
            system.debug('journeyPlanIdList' + journeyPlanIdList);
            
            
            if(journeyPlanIdList.size()>0 || test.isRunningTest()) {
                LIST<Rintin_Plan__c> rinTinPlanList = new LIST<Rintin_Plan__c>();  
                rinTinPlanList = [SELECT Id,Journey_Plan__c ,Date__c, TId__c
                                  FROM Rintin_Plan__c 
                                  WHERE (Journey_Plan__c IN :journeyPlanIdList OR TId__c IN : TidJourneyPlanMAP.keySet()) AND Date__c >= TODAY ];
                
                LIST<Rintin_Plan__c> rintinPlanToDelete = new LIST<Rintin_Plan__c>();
                if(rinTinPlanList.size()>0) {
                    for(Rintin_Plan__c rp : rinTinPlanList) {
                        if(!TidJourneyPlanMAP.containsKey(rp.TId__c)) {
                            rintinPlanToDelete.add(rp);
                        }
                    }
                    Database.delete(rintinPlanToDelete); 
                    
                    // Database.delete(rinTinPlanList);                    
                }
            }
            
            if(RintinDokoHeader != NULL) {
                for(LorealUploadclass.RintinDokoHeaderInfo rintinPlan : RintinDokoHeader) {
                    //if(internalIDSET.contains(rintinPlan.PlanId)){ // removed by pranav because fr Rp, Jp is nt required 
                    tidVsRintinPlanJsonMap.put(rintinPlan.TId,rintinPlan);
                    //}
                }
            }
            
            system.debug('tidVsRintinPlanJsonMap'+tidVsRintinPlanJsonMap);
            
            
            // Quering user details to insert in Name field of Rintin Plan record
            list<User> userLIST= new list<user>([SELECT ID,name,ivybase__Internal_Id__c,(select id,name,ivybase__Related_User__c,ivybase__Location_Hierarchy__c from ivybase__Resources__r ) FROM user where id=: userinfo.getUserId() ]);
            
            /* Internal User Id */
            String userInternalId = userLIST[0].ivybase__Internal_Id__c==null ? null : String.valueOf(userLIST[0].ivybase__Internal_Id__c);
            
            //to store the Tid which is not present in Salesforce
            set<string> idNotinSF = new set<string>();
            
            /* Adding all TId's from upload, the later point we will remove */ 
            idNotinSF.addAll(tidVsRintinPlanJsonMap.keyset());
            
            //list of All Journey plan Records to upsert
            List<Rintin_Plan__c> listOfRintinPlanToUpsert = new List<Rintin_Plan__c>();
            
            for (Account acc : [SELECT Id, ivybase__Internal_Id__c, Sold_To_Party_Number__c FROM Account WHERE ivybase__Internal_Id__c IN :salonInternalIdSET]) {
                internalIdANDSoldToMap.put(acc.ivybase__Internal_Id__c, acc.Sold_To_Party_Number__c);
            }
            system.debug('$$$$testQuery '+ [SELECT id,Tid__c,Name,Date__c,InternalId__c,Journey_Plan__r.status__c,
                                             StartTime__c,Location__c, EndTime__c, Journey_Plan__r.Month__c, Journey_Plan__r.Year__c 
                                             FROM  Rintin_Plan__c]);
            //system.debug('');
            for(Rintin_Plan__c rintinPlan : [SELECT id,Tid__c,Name,Date__c,InternalId__c,Journey_Plan__r.status__c,
                                             StartTime__c,Location__c, EndTime__c, Journey_Plan__r.Month__c, Journey_Plan__r.Year__c 
                                             FROM  Rintin_Plan__c WHERE (Tid__c =: tidVsRintinPlanJsonMap.keySet() or InternalId__c =: tidVsRintinPlanJsonMap.keySet())]){
                          system.debug('****rintintestplan '+rintinplan);                       
                                                 String TidInternalId='';
                                                 if(rintinPlan.Tid__c!=null && rintinPlan.Tid__c!='')
                                                 {
                                                     TidInternalId= rintinPlan.Tid__c;
                                                 }
                                                 else
                                                 {
                                                     TidInternalId=rintinPlan.InternalId__c;
                                                 }
                                                 
                                                 /* Add transaction Ids present in SF for present upload */
                                                 tidInSfSET.add(TidInternalId);
                                                 
                                                 // Commented bcz after upload also Ritin plan can be uploaded like adhoc
                                                 //if(rintinPlan.Journey_Plan__r.status__c != 'Approved'){
                                                 
                                                 // Checking if date is not NULL, if yes Update with new one 
                                                 rintinPlan.Date__c = tidVsRintinPlanJsonMap.get(TidInternalId).Date_x==null || tidVsRintinPlanJsonMap.get(TidInternalId).Date_x=='' ? rintinPlan.Date__c : ConversionUtility.StringToDateConversion(tidVsRintinPlanJsonMap.GET(TidInternalId).Date_x);
                                                 
                                                 // Checking if location is not NULL, if yes Update with new one
                                                 rintinPlan.Location__c = tidVsRintinPlanJsonMap.get(TidInternalId).Location==null || tidVsRintinPlanJsonMap.get(TidInternalId).Location =='' ? rintinPlan.Location__c : tidVsRintinPlanJsonMap.get(TidInternalId).Location;
                                                 
                                                 // Checking if start time  is not NULL, if yes Update with new one
                                                 rintinPlan.StartTime__c = tidVsRintinPlanJsonMap.get(TidInternalId).StartTime==null || tidVsRintinPlanJsonMap.get(TidInternalId).StartTime =='' ? rintinPlan.StartTime__c : tidVsRintinPlanJsonMap.get(TidInternalId).StartTime;
                                                 
                                                 // Checking if end time  is not NULL, if yes Update with new one                               
                                                 rintinPlan.EndTime__c = tidVsRintinPlanJsonMap.get(TidInternalId).EndTime==null || tidVsRintinPlanJsonMap.get(TidInternalId).EndTime =='' ? rintinPlan.EndTime__c : tidVsRintinPlanJsonMap.get(TidInternalId).EndTime;
                                                 
                                                 // To get resource from logged in user
                                                 ivybase__Resource__c loggedinUser =  ResourceService.getSellerId(UserInfo.getUserId());
                                                 rintinPlan.Resource__c =loggedinUser.Id;
                                                 
                                                 
                                                 // To get the total planned salons and Agent count
                                                 rintinPlan.Total_Planned_Salons_Agents__c  =  tidVsRintinPlanJsonMap.get(TidInternalId).TotalPlannedRetailers==null || tidVsRintinPlanJsonMap.get(TidInternalId).TotalPlannedRetailers =='' ? rintinPlan.Total_Planned_Salons_Agents__c : Integer.valueOf(tidVsRintinPlanJsonMap.get(TidInternalId).TotalPlannedRetailers);                               
                                                 
                                                 rintinPlan.Tid__c = tidVsRintinPlanJsonMap.GET(TidInternalId).TId==null ? rintinPlan.Tid__c:tidVsRintinPlanJsonMap.GET(TidInternalId).TId;
                                                 
                                                 //rintinPlan.Name=''+userLIST[0].Name+'-'+rintinPlan.Journey_Plan__r.Month__c+'-'+rintinPlan.Journey_Plan__r.Year__c;
                                                 
                                                 //rintinPlan.Journey_Plan__c = internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId).Id;
                                                 
                                                 if(internalIdandJourneyPlanIdMAP.containskey(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId) && internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId)!=null)
                                                     rintinPlan.Journey_Plan__c = internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId).Id;
                                                 /*else
rintinPlan.Journey_Plan__c =null;*/
                                                 
                                                 //rintinPlan.Name=''+userLIST[0].Name+'-'+ internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId).Month__c + '-'+ internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId).Year__c;
                                                 
                                                 if(internalIdandJourneyPlanIdMAP.containskey(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId) && internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId)!=null)
                                                     rintinPlan.Name=''+userLIST[0].Name+'-'+ internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId).Month__c + '-'+ internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(TidInternalId).PlanId).Year__c;
                                                 else
                                                     rintinPlan.Name=''+userLIST[0].Name+'-'+ date.today().Month()+'-'+date.today().year();
                                                 // To get signature 
                                                 rintinPlan.SignatureText__c = tidVsRintinPlanJsonMap.GET(TidInternalId).Signature == NULL || tidVsRintinPlanJsonMap.GET(TidInternalId).Signature == ''? rintinPlan.SignatureText__c : tidVsRintinPlanJsonMap.get(TidInternalId).Signature;
                                                 
                                                 // To get brand 
                                                 rintinPlan.BrandText__c = tidVsRintinPlanJsonMap.GET(TidInternalId).Brand == NULL || tidVsRintinPlanJsonMap.GET(TidInternalId).Brand == '' ? rintinPlan.BrandText__c : tidVsRintinPlanJsonMap.get(TidInternalId).Brand;
                                                 
                                                 // To get sub axe
                                                 rintinPlan.SubAxeText__c = tidVsRintinPlanJsonMap.GET(TidInternalId).SubAxe == NULL || tidVsRintinPlanJsonMap.GET(TidInternalId).SubAxe == ''? rintinPlan.SubAxeText__c : tidVsRintinPlanJsonMap.get(TidInternalId).SubAxe;
                                                 
                                                 if(tidVsRintinPlanJsonMap.GET(TidInternalId).IsRinten == '1') {
                                                     rintinPlan.IsRinten__c =true;
                                                 } else {
                                                     rintinPlan.IsRinten__c =false;
                                                 }                                  
                                                 
                                                 //Sno:
                                                 rintinPlan.Serial_Number__c = (tidVsRintinPlanJsonMap.get(TidInternalId).Sno != NULL ? tidVsRintinPlanJsonMap.get(TidInternalId).Sno : '');
                                                 
                                                 //OrgSalonCode:
                                                 if ( String.isNotBlank(tidVsRintinPlanJsonMap.get(TidInternalId).OrgSalonCode)) {
                                                     Decimal salonInternalId = Decimal.valueOf(tidVsRintinPlanJsonMap.get(TidInternalId).OrgSalonCode);
                                                     if (internalIdANDSoldToMap.get(salonInternalId) != NULL) {
                                                         rintinPlan.Org_Salon_Code__c = internalIdANDSoldToMap.get(salonInternalId);
                                                     }
                                                     rintinPlan.Org_Salon_Internal_Id__c = salonInternalId;
                                                 }
                                                 
                                                 //OrgSalonName:
                                                 rintinPlan.Org_Salon_Name__c = (tidVsRintinPlanJsonMap.get(TidInternalId).OrgSalonName != NULL ? tidVsRintinPlanJsonMap.get(TidInternalId).OrgSalonName : '');
                                                 
                                                 listOfRintinPlanToUpsert.add(rintinPlan);
                                                 //}
                                                 
                                                 system.debug('inside update');
                                             }
            
            /* Removing Tid's which are present in SF */
            idNotinSF.removeAll(tidInSfSET);
            
            /* Inserting records which are not present in SF */
            
            for(string Tidsset:tidVsRintinPlanJsonMap.keyset()){
                if(idNotinSF.contains(Tidsset)) {
                    
                    
                    system.debug('inside sf');
                    Rintin_Plan__c rintinPlan = new Rintin_Plan__c();
                    
                    rintinPlan.Date__c = tidVsRintinPlanJsonMap.get(Tidsset).Date_x==null || tidVsRintinPlanJsonMap.get(Tidsset).Date_x=='' ? null: ConversionUtility.StringToDateConversion(tidVsRintinPlanJsonMap.GET(Tidsset).Date_x);
                    rintinPlan.Location__c = tidVsRintinPlanJsonMap.get(Tidsset).Location==null || tidVsRintinPlanJsonMap.get(Tidsset).Location =='' ? null : tidVsRintinPlanJsonMap.get(Tidsset).Location;
                    
                    // Checking if start time  is not NULL, if yes Update with new one
                    rintinPlan.StartTime__c = tidVsRintinPlanJsonMap.get(Tidsset).StartTime==null || tidVsRintinPlanJsonMap.get(Tidsset).StartTime =='' ? NULL : tidVsRintinPlanJsonMap.get(Tidsset).StartTime;
                    
                    // Checking if end time  is not NULL, if yes Update with new one                               
                    rintinPlan.EndTime__c = tidVsRintinPlanJsonMap.get(Tidsset).EndTime==null || tidVsRintinPlanJsonMap.get(Tidsset).EndTime =='' ? null : tidVsRintinPlanJsonMap.get(Tidsset).EndTime;
                    
                    rintinPlan.Tid__c = tidVsRintinPlanJsonMap.GET(Tidsset).TId==null ? NULL:tidVsRintinPlanJsonMap.GET(Tidsset).TId;
                    
                    // To get resource from logged in user
                    ivybase__Resource__c loggedinUser =  ResourceService.getSellerId(UserInfo.getUserId());
                    rintinPlan.Resource__c =loggedinUser.Id;
                    
                    // To get the total planned salons and Agent count
                    rintinPlan.Total_Planned_Salons_Agents__c  =  tidVsRintinPlanJsonMap.get(Tidsset).TotalPlannedRetailers==null || tidVsRintinPlanJsonMap.get(Tidsset).TotalPlannedRetailers =='' ? NULL : Integer.valueOf(tidVsRintinPlanJsonMap.get(Tidsset).TotalPlannedRetailers);                               
                    
                    if(internalIdandJourneyPlanIdMAP.containskey(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId) && internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId)!=null)
                        rintinPlan.Journey_Plan__c = internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId).Id;
                    
                    if(internalIdandJourneyPlanIdMAP.containskey(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId) && internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId)!=null)
                        rintinPlan.Name=''+userLIST[0].Name+'-'+ internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId).Month__c + '-'+ internalIdandJourneyPlanIdMAP.get(tidVsRintinPlanJsonMap.GET(Tidsset).PlanId).Year__c;
                    else
                        rintinPlan.Name=''+userLIST[0].Name+'-'+ date.today().Month()+'-'+date.today().year();
                    
                    // To get signature 
                    rintinPlan.SignatureText__c = tidVsRintinPlanJsonMap.get(Tidsset).Signature==null || tidVsRintinPlanJsonMap.get(Tidsset).Signature =='' ?  null : tidVsRintinPlanJsonMap.get(Tidsset).Signature;
                    
                    // To get brand 
                    rintinPlan.BrandText__c = tidVsRintinPlanJsonMap.get(Tidsset).Brand==null || tidVsRintinPlanJsonMap.get(Tidsset).Brand =='' ?  null : tidVsRintinPlanJsonMap.get(Tidsset).Brand;
                    
                    // To get sub axe
                    rintinPlan.SubAxeText__c = tidVsRintinPlanJsonMap.get(Tidsset).SubAxe==null || tidVsRintinPlanJsonMap.get(Tidsset).SubAxe =='' ?  null : tidVsRintinPlanJsonMap.get(Tidsset).SubAxe;
                    
                    if(tidVsRintinPlanJsonMap.get(Tidsset).IsAdhoc== '1') {
                        rintinPlan.IsAdhoc__c = true;
                    } else {
                        rintinPlan.IsAdhoc__c =false;
                    }
                    if(tidVsRintinPlanJsonMap.get(Tidsset).IsRinten== '1') {
                        rintinPlan.IsRinten__c = true;
                    } else {
                        rintinPlan.IsRinten__c =false;
                    }                    
                    
                    //Sno:
                    rintinPlan.Serial_Number__c = (tidVsRintinPlanJsonMap.get(Tidsset).Sno != NULL ? tidVsRintinPlanJsonMap.get(Tidsset).Sno : '');
                    
                    //OrgSalonCode:
                    if ( String.isNotBlank(tidVsRintinPlanJsonMap.get(Tidsset).OrgSalonCode)) {
                        Decimal salonInternalId = Decimal.valueOf(tidVsRintinPlanJsonMap.get(Tidsset).OrgSalonCode);
                        if (internalIdANDSoldToMap.get(salonInternalId) != NULL) {
                            rintinPlan.Org_Salon_Code__c = internalIdANDSoldToMap.get(salonInternalId);
                        }
                        rintinPlan.Org_Salon_Internal_Id__c = salonInternalId;
                    }
                    
                    //OrgSalonName:
                    rintinPlan.Org_Salon_Name__c = (tidVsRintinPlanJsonMap.get(Tidsset).OrgSalonName != NULL ? tidVsRintinPlanJsonMap.get(Tidsset).OrgSalonName : '');
                    
                    listOfRintinPlanToUpsert.add(rintinPlan);
                }
            }
            
            system.debug('listOfRintinPlanToUpsert'+ listOfRintinPlanToUpsert);
            
            Database.UpsertResult [] saveResult = Database.upsert(listOfRintinPlanToUpsert,false);
            //system.debug('saveResult'+ saveResult);
            for (Database.UpsertResult sr : saveResult) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted rinitn ' + sr.getId());
                }
                else {
                    allSuccess=false;
                    // Operation failed, so get all error                
                    for(Database.Error err : sr.getErrors()) {
                        postResult.add(new PostResponse.PostResponseObject('0',err.getMessage()));                 
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        
                    }
                }
            }
            
            //create a map of Tid and realted JourneyPlan Records salesfroce id
            
            for(Rintin_Plan__c s :listOfRintinPlanToUpsert) {
                TidAndSalesforceIdMap.put(s.Tid__c,s.id);
            }
            
            
        }
        
        /* To insert RintinDokoSalonDetails records */ 
        Set<Long> RetailerIdSet = new Set<Long>();
        SET<String> RetailerIdStringSet = new SET<String>();
        List<LorealUploadclass.RintinDokoSalonDetailsInfo> listVar; 
        Map<String,List<LorealUploadclass.RintinDokoSalonDetailsInfo>> TidAndsalonListMap = new Map<String,List<LorealUploadclass.RintinDokoSalonDetailsInfo>>();
        if(RintinDokoSalonDetailsInfo!=null && RintinDokoSalonDetailsInfo.size()>0) 
        {
            for(LorealUploadclass.RintinDokoSalonDetailsInfo res:RintinDokoSalonDetailsInfo){
                
                if(res.Rid!=null && String.isEmpty(res.Rid)==false)
                {
                    RetailerIdSet.add(Long.valueOf(res.Rid));  
                    RetailerIdStringSet.add(res.Rid);
                }
                //if tid is present in map add the records to the list.
                if(TidAndsalonListMap.get(res.TId)!=null)
                {
                    TidAndsalonListMap.get(res.TId).add(res);
                    
                }
                //if tid is not present in map
                else
                {
                    listVar = new List<LorealUploadclass.RintinDokoSalonDetailsInfo>();
                    listVar.add(res);
                    TidAndsalonListMap.put(res.TId,listVar); 
                }
            }
            
            system.debug('RetailerIdset 213'+ RetailerIdset);
            //Map<retailerId , Account id(saelsfroce id)>
            Map<String,Id> AccountInternalIdMap = new Map<String,Id>();
            List<Account> RetailerAccount = [select id,ivybase__Internal_Id__c from Account where ivybase__Internal_Id__c IN :RetailerIdset];
            
            for(Account a:RetailerAccount)
            {
                AccountInternalIdMap.put(String.valueOf(a.ivybase__Internal_Id__c),a.id);
            }
            
            LIST<Account> RetailerConquestAccount = new LIST<Account>();
            
            RetailerConquestAccount = [select id,Tid__c from Account where Tid__c IN :RetailerIdStringSet];
            
            for(Account acc: RetailerConquestAccount) {
                AccountInternalIdMap.put(acc.Tid__c,acc.Id);
            }
            
            // process the market record in translator to insert
            try{
                List<PostResponse.PostResponseObject> result=RintinPlanTranslator.RintinDokoSalonDetailsMethod(TidAndsalonListMap, TidAndSalesforceIdMap, AccountInternalIdMap);
                for(PostResponse.PostResponseObject r:result)
                {
                    if(r.Response=='0')
                    {
                        allSuccess=false;
                        postResult.add(r);  
                    }
                }                
            }
            catch(Exception e)
            {
                DmlException exce = (DmlException)e;
                String ErrorMsg='General Error'+e.getStackTraceString()+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName()+''+exce.getCause()+''+exce.getMessage();
                allSuccess=false;
                postResult.add(new PostResponse.PostResponseObject('0','General Error:'+ErrorMsg));
            }
        }
        
        
        /* To insert RintinDokoHairdresserAndAgentDetails records */
        Set<Long> agentRetailerIdSet = new Set<Long>();
        SET<String> agentRetailerIdStringSet = new SET<String>();
        Set<Long> HairDresserIdSet = new Set<Long>();
        Set<string> HairDresserIdSet1 = new Set<string>();
        SET<Long> onlyAgentIdSet = new SET<Long>();// TO store agent internal Ids
        List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo> agentListVar; 
        Map<String,List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo>> AgentTidAndsalonListMap = new Map<String,List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo>>();
        
        if(RintinDokoHairdresserAndAgentDetails != NULL && RintinDokoHairdresserAndAgentDetails.size()>0) {
            
            for(LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo res : RintinDokoHairdresserAndAgentDetails){
                system.debug('res1234 '+res);
                if(res.HAId != NULL && res.HAId != '') {
                    HairDresserIdSet.add(Long.valueOf(res.HAId));
                    HairDresserIdSet1.add(res.HAId);
                }
                if(res.Rid != NULL && res.Rid != '') {
                    agentRetailerIdSet.add(Long.valueOf(res.Rid));
                    agentRetailerIdStringSet.add(String.valueOf(res.Rid));
                }
                system.debug('agentresId'+ res.AgentId);
                if(res.AgentId!= NULL && res.AgentId != '') {
                    onlyAgentIdSet.add(Long.valueOf(res.AgentId));
                }
                //if tid is present in map add the records to the list.
                if(AgentTidAndsalonListMap.get(res.TId)!=null)
                {
                    AgentTidAndsalonListMap.get(res.TId).add(res);
                    
                }
                //if tid is not present in map
                else
                {
                    agentListVar = new List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo>();
                    agentListVar.add(res);
                    AgentTidAndsalonListMap.put(res.TId,agentListVar); 
                }
            }
            
            // To get retailer Id
            Map<String,Id> AgentAccountInternalIdMap = new Map<String,Id>();
            Map<String,Id> onlyAgentAccountInternalIdMap = new Map<String,Id>();
            
            List<Account> RetailerAccount = [select id,ivybase__Internal_Id__c from Account where ivybase__Internal_Id__c IN:agentRetailerIdSet];
            
            system.debug('onlyAgentIdSet'+ onlyAgentIdSet);
            
            // To query conquest salons
            LIST<Account> conquestList = new LIST<Account>();
            conquestList = [select id,Tid__c from Account where Tid__c IN:agentRetailerIdStringSet and Is_Conquest__c = true];
            system.debug('conquestList'+ conquestList);
            
            LIST<Account> agentAccount = [select id,ivybase__Internal_Id__c from Account where ivybase__Internal_Id__c=:onlyAgentIdSet];
            
            
            system.debug('agentAccount'+ agentAccount);
            system.debug('RetailerAccount'+ RetailerAccount);
            
            for(Account a:RetailerAccount)
            {
                AgentAccountInternalIdMap.put(String.valueOf(a.ivybase__Internal_Id__c),a.id);
            }
            // Added for conquest salons
            for(Account a:conquestList) {
                
                AgentAccountInternalIdMap.put(a.Tid__c,a.id);
            }
            system.debug('AgentAccountInternalIdMap'+ AgentAccountInternalIdMap);
            
            for(Account a:agentAccount){
                onlyAgentAccountInternalIdMap.put(String.valueOf(a.ivybase__Internal_Id__c),a.id);
            }
            
            system.debug('onlyAgentAccountInternalIdMap'+ onlyAgentAccountInternalIdMap);
            system.debug('HairDresserIdSet ->'+ HairDresserIdSet);
            
            Map<String,Id> AgentContactInternalIdMap = new Map<String,Id>();
            List<Contact> RetailerContact = [select id,Internal_Id__c,HairdresserId__c from Contact where Internal_Id__c In: HairDresserIdSet OR HairdresserId__c IN:HairDresserIdSet1];
            
            system.debug('RetailerContact'+ RetailerContact);
            
            
            for(Contact c : RetailerContact)
            {
                AgentContactInternalIdMap.put(String.valueOf(c.Internal_Id__c),c.id);
                if(c.HairdresserId__c!=null){
                    AgentContactInternalIdMap.put(c.HairdresserId__c,c.id);
                }
            }
            
            system.debug('AgentContactInternalIdMap'+ AgentContactInternalIdMap);
            try{
                List<PostResponse.PostResponseObject> result = RintinPlanTranslator.AgentRintinDokoSalonDetailsMethod(AgentTidAndsalonListMap, TidAndSalesforceIdMap,AgentAccountInternalIdMap ,AgentContactInternalIdMap,onlyAgentAccountInternalIdMap);
                for(PostResponse.PostResponseObject r:result)
                { 
                    if(r.Response=='0')
                    {
                        allSuccess=false;
                        postResult.add(r);  
                    }
                }                
            }
            catch(Exception e)
            {
                DmlException exce = (DmlException)e;
                String ErrorMsg='General Error'+e.getStackTraceString()+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName()+''+exce.getCause()+''+exce.getMessage();
                allSuccess=false;
                postResult.add(new PostResponse.PostResponseObject('0','General Error:'+ErrorMsg));
            }
            
        } 
        if(postResult.size()==0 && allSuccess==true && RintinDokoHeader!=null && RintinDokoSalonDetailsInfo!=null && RintinDokoHairdresserAndAgentDetails!=null)
        {
            postResult.add(new PostResponse.PostResponseObject('1','success'));
        }
        else
        {
            String errorMessage='Null value->';
            if(RintinDokoHeader==null)
            {
                errorMessage+=' RintinDokoHeader';
            }
            if(RintinDokoSalonDetailsInfo==null)
            {
                errorMessage+=' RintinDokoSalonDetailsInfo';
            }
            if(RintinDokoHairdresserAndAgentDetails==null)
            {
                errorMessage+=' RintinDokoHairdresserAndAgentDetails'; 
            }
            postResult.add(new PostResponse.PostResponseObject('0','Warning :'+errorMessage));
        }
        return postResult; 
    }  
    
    public static LIST<PostResponse.PostResponseObject> RintinDokoActualsTransaction (List<LorealUploadclass.RintinDokoVisitHeaderInfo> RintinDokoActualsHeader, List<LorealUploadclass.RintinDokoVisitDetailInfo> RintinDokoVisitActualsDetail) {
        
        Boolean allSuccess = TRUE;
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        
        Map<String, Id> planIdAndSalesforceIdMap = new Map<String, Id>();
        
        // MAP to store transaction Id and Response from Mobility 
        MAP<String, LorealUploadclass.RintinDokoHeaderInfo> tidVsRintinPlanJsonMap =new MAP<string,LorealUploadclass.RintinDokoHeaderInfo>(); 
        
        Set<String> visitId = new Set<String>();
        Set<Long> RetailerIdSet = new Set<Long>();
        SET<String> RetailerIdStringSet = new SET<String>();
        Map<String, List<LorealUploadclass.RintinDokoVisitHeaderInfo>> tidVsRintinPlanActualJsonMap = new Map<String, List<LorealUploadclass.RintinDokoVisitHeaderInfo>>();
        
        Set<Long> HairDresserIdSet = new Set<Long>();
        
        MAP<String,Id> TidAndSalesforceIdMap = new MAP<String,Id>(); // MAP to store transaction Id and Rintin Plan Id 
        
        Map<String,List<LorealUploadclass.RintinDokoVisitDetailInfo>> tidVsRintinPlanDetailJsonMap = new Map<String,List<LorealUploadclass.RintinDokoVisitDetailInfo>>();
        
        Set<String> TIdset = new Set<String>();
        
        if (RintinDokoActualsHeader != NULL) {
            for(LorealUploadclass.RintinDokoVisitHeaderInfo res : RintinDokoActualsHeader){
                visitId.add(res.Visitid);
                
                if(tidVsRintinPlanActualJsonMap.get(res.TId) != NULL)
                    tidVsRintinPlanActualJsonMap.get(res.TId).add(res);
                else
                    tidVsRintinPlanActualJsonMap.put(res.TId, new List<LorealUploadclass.RintinDokoVisitHeaderInfo> {res});
                
                RetailerIdSet.add(Long.valueOf(res.Rid));
                RetailerIdStringSet.add(res.Rid); // For conquest Salons
            }
            system.debug('tidVsRintinPlanActualJsonMap '+tidVsRintinPlanActualJsonMap);
        }
        
        if(RintinDokoVisitActualsDetail != NULL) {
            for ( LorealUploadclass.RintinDokoVisitDetailInfo res : RintinDokoVisitActualsDetail) {
                if(String.isNotBlank(res.HRid)) 
                    HairDresserIdSet.add(Long.valueOf(res.HRid));
                
                if(String.isNotBlank(res.Rid)){
                    RetailerIdSet.add(Long.valueOf(res.Rid));
                    RetailerIdStringSet.add(res.Rid);
                }
                
                if(String.isNotBlank(res.Agentid)){
                    RetailerIdSet.add(Long.valueOf(res.Agentid));
                    RetailerIdStringSet.add(res.Agentid);
                }
                
                
                TIdset.add(res.TId);
                
                if(tidVsRintinPlanDetailJsonMap.containsKey(res.TId))
                    tidVsRintinPlanDetailJsonMap.get(res.TId).add(res);
                else
                    tidVsRintinPlanDetailJsonMap.put(res.TId, new List<LorealUploadclass.RintinDokoVisitDetailInfo>{res});
            }
        }        
        
        for(Rintin_Plan__c rPlan : [SELECT Id, TId__c, Journey_Plan__c, Location__c, Date__c, 
                                    StartTime__c, EndTime__c, InternalId__c
                                    FROM Rintin_Plan__c 
                                    WHERE TId__c IN :visitId ])
        {
            planIdAndSalesforceIdMap.put(String.valueOf(rPlan.TId__c), rPlan.Id);//InternalId__c
        }
        
        system.debug('RetailerIdset 213'+ RetailerIdset);
        //Map<retailerId , Account id(saelsfroce id)>
        Map<String,Id> AccountInternalIdMap = new Map<String,Id>();
        
        for(Account a : [SELECT id, ivybase__Internal_Id__c
                         FROM Account 
                         WHERE ivybase__Internal_Id__c IN :RetailerIdset]) {
                             AccountInternalIdMap.put(String.valueOf(a.ivybase__Internal_Id__c), a.id);
                         }
        
        for(Account a : [SELECT id, ivybase__Internal_Id__c,Tid__c
                         FROM Account 
                         WHERE Tid__c IN :RetailerIdStringset and Is_Conquest__c = true]) {
                             AccountInternalIdMap.put(a.Tid__c, a.id);
                             
                         }        
        
        
        system.debug('AccountInternalIdMap223'+ AccountInternalIdMap);
        
        try{
            List<PostResponse.PostResponseObject> result = RintinPlanTranslator.RintinDokoActualsMethod(tidVsRintinPlanActualJsonMap, planIdAndSalesforceIdMap, AccountInternalIdMap);
            for(PostResponse.PostResponseObject r:result)
            {
                if(r.Response=='0')
                {
                    allSuccess=false;
                    postResult.add(r);  
                }
            }                
        }
        catch(Exception e)
        {
            DmlException exce = (DmlException)e;
            String ErrorMsg='General Error'+e.getStackTraceString()+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName()+''+exce.getCause()+''+exce.getMessage();
            allSuccess=false;
            postResult.add(new PostResponse.PostResponseObject('0','General Error:'+ErrorMsg));
        }
        
        
        
        if(!postResult.isEmpty() && allSuccess && RintinDokoVisitActualsDetail != NULL ){
            postResult.add(new PostResponse.PostResponseObject('1','success'));
        }
        else
        {
            
            if(RintinDokoVisitActualsDetail != NULL) {
                
                for (RintinDokoVisitActual__c rec : [SELECT Id, Tid__c,Retailer_Id__c,Retailer_Id__r.ivybase__Internal_Id__c FROM RintinDokoVisitActual__c WHERE Tid__c IN :TIdset]) {
                    TidAndSalesforceIdMap.put(rec.Tid__c+'.'+rec.Retailer_Id__r.ivybase__Internal_Id__c, rec.Id);
                }
                Map<String,Id> AgentContactInternalIdMap = new Map<String,Id>();
                //List<Contact> RetailerContact = [select id,Internal_Id__c from Contact where Internal_Id__c In: HairDresserIdSet];
                
                for(Contact c : [SELECT Id, Internal_Id__c 
                                 FROM Contact 
                                 WHERE Internal_Id__c In: HairDresserIdSet])
                {
                    AgentContactInternalIdMap.put(String.valueOf(c.Internal_Id__c),c.id);
                }
                system.debug('AgentContactInternalIdMap '+AgentContactInternalIdMap);
                try {
                    List<PostResponse.PostResponseObject> result = RintinPlanTranslator.RintinDokoActualsDetailMethod(tidVsRintinPlanDetailJsonMap, TidAndSalesforceIdMap, AccountInternalIdMap, AgentContactInternalIdMap);
                    for(PostResponse.PostResponseObject r:result) { 
                        if(r.Response=='0') {
                            allSuccess=false;
                            postResult.add(r);  
                        }
                    }                
                }
                catch(Exception e) {
                    DmlException exce = (DmlException)e;
                    String ErrorMsg='General Error'+e.getStackTraceString()+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName()+''+exce.getCause()+''+exce.getMessage();
                    allSuccess=false;
                    postResult.add(new PostResponse.PostResponseObject('0','General Error:'+ErrorMsg));
                }
            }
        }
        return postResult;
    }
    
    public static List<PostResponse.PostResponseObject> journeyPlanTransaction(List<LorealUploadclass.Journeyplaninfo> journeyPlanning,List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo> journeyPlanMarketData,List<LorealUploadclass.JourneyPlanDetailInfo> journeyPlandetaildata,List<ivybase__Location_Hierarchy__c> userTerritory, List<LorealUploadclass.RintinDokoHeaderInfo> RintinDokoHeader){
        
        boolean allSuccess=true;
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        system.debug('journeyPlanning*********'+journeyPlanning);
        //set to hold all the Tid
        set<string> TIdset = new set<string>();
        Map<String,Id> TidAndSalesforceIdMap = new Map<String,Id>();
        //map<Tid,JourneyPlanRecord>
        map<string,LorealUploadclass.Journeyplaninfo> tidVsJourneyplanJsonMap =new map<string,LorealUploadclass.Journeyplaninfo>();
        //to store the tid present in salesforce
        set<string> tidInSf=new set<string>();
        Map<id,JourneyPlan__c> journeyPlanMap= new Map<id,JourneyPlan__c>();
        
        
        
        
        /* To delete Rintin doko details if Rintinheader is not present in JSON */
        if(journeyPlanning!=null ){
            for(LorealUploadclass.Journeyplaninfo res:journeyPlanning){
                if(res.Status!='A'){
                    TIdset.add(res.TId);
                    tidVsJourneyplanJsonMap.put(res.TId,res);
                    system.debug('tidVsJourneyplanJsonMap'+tidVsJourneyplanJsonMap);
                }
                
            }
            
            LIST<JourneyPlan__c> journeyPlanList = [select id,Tid__c,Name,Date__c,Month__c,Year__c,UserId__c,SupervisorComments__c,Status__c,Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c,InternalId__c 
                                                    FROM  JourneyPlan__c 
                                                    WHERE (Tid__c=:TIdset or InternalId__c=:TIdset)];
            
            // Deleting Rintin doko details if rintin doko details are not present in JSON.
            if(RintinDokoHeader == NULL) {
                
                LIST<id> journeyPlanIdList = new LIST<Id>();
                
                for(JourneyPlan__c jp : journeyPlanList){
                    journeyPlanIdList.add(jp.Id);
                }
                
                if(journeyPlanIdList.size()>0) {
                    LIST<Rintin_Plan__c> rinTinPlanList = new LIST<Rintin_Plan__c>();  
                    rinTinPlanList = [SELECT Id,Journey_Plan__c 
                                      FROM Rintin_Plan__c 
                                      WHERE Journey_Plan__c IN :journeyPlanIdList ];
                    
                    if(rinTinPlanList.size()>0) {
                        Database.delete(rinTinPlanList);                    
                    }
                }
            }
            
            
            
            
            //to store the Tid which is not present in Salesforce
            set<string> idNotinSF = new set<string>();
            String[] lstMstrFields = new String[]{'ivybase__List_Code__c','ivybase__List_Type__c','ivybase__List_Name__c','Name'};
                //get JP_Activity from Standard List master eg:{R-Reject,A-Approve}
                map<string,string> statusMapListCode = RESTJourneyPlan.getJP_ActivtyFromStandardListMaaster(lstMstrFields);
            map<string,string> statusMapListCodeForStatus=new map<string,string>();
            for(string code:statusMapListCode.keyset()){
                statusMapListCodeForStatus.put(statusMapListCode.get(code),code);
            }
            list<User> usr= new list<user>([SELECT ID,name,ivybase__Internal_Id__c,(select id,name,ivybase__Related_User__c,ivybase__Location_Hierarchy__c from ivybase__Resources__r ) FROM user where id=: userinfo.getUserId() ]);
            //get user Internal Id
            String userID = usr[0].ivybase__Internal_Id__c==null?null:String.valueOf(usr[0].ivybase__Internal_Id__c);
            // system.debug('User - related territory'+usr[0].ivybase__Resources__r[0].ivybase__Location_Hierarchy__c);
            //list of All Journey plan Records to upsert
            List<JourneyPlan__c> listOfJourneyPlanToUpsert = new List<JourneyPlan__c>();
            //interate over all the related journey plan records present in salesforce to update the records.
            //system.debug('TIDSET from main'+TIdset);
            
            //for(JourneyPlan__c queryjournyplan:[select id,Tid__c,Name,Date__c,Month__c,Year__c,UserId__c,SupervisorComments__c,Status__c,Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c,InternalId__c from  JourneyPlan__c WHERE (Tid__c=:TIdset or InternalId__c=:TIdset)]){
            
            for(JourneyPlan__c queryjournyplan:journeyPlanList) {   
                
                system.debug('queryjournyplan'+queryjournyplan);
                
                if(tidVsJourneyplanJsonMap.containskey(queryjournyplan.InternalId__c) || tidVsJourneyplanJsonMap.containskey(queryjournyplan.Tid__c)){
                    String idjp='';
                    if(queryjournyplan.Tid__c!=null && queryjournyplan.Tid__c!='')
                    {
                        idjp= queryjournyplan.Tid__c;
                    }
                    else
                    {
                        idjp=queryjournyplan.InternalId__c;
                    }
                    
                    tidInSf.add(idjp);
                    system.debug(idjp+'idjp');
                    if(queryjournyplan.Status__c!='Approved'){
                        system.debug('*********'+tidVsJourneyplanJsonMap.GET(idjp));
                        queryjournyplan.Date__c=tidVsJourneyplanJsonMap.GET(idjp).date_x==null ||tidVsJourneyplanJsonMap.GET(idjp).date_x==''?queryjournyplan.Date__c: ConversionUtility.StringToDateConversion(tidVsJourneyplanJsonMap.GET(idjp).date_x);
                        
                        queryjournyplan.Year__c=tidVsJourneyplanJsonMap.GET(idjp).Year==null ||tidVsJourneyplanJsonMap.GET(idjp).Year==''?queryjournyplan.Year__c:ConversionUtility.StringToInteger(tidVsJourneyplanJsonMap.GET(idjp).Year);
                        queryjournyplan.Month__c=tidVsJourneyplanJsonMap.GET(idjp).Month==null ||tidVsJourneyplanJsonMap.GET(idjp).Month==''?queryjournyplan.Month__c: ConversionUtility.StringToInteger(tidVsJourneyplanJsonMap.GET(idjp).Month);
                        queryjournyplan.SupervisorComments__c=tidVsJourneyplanJsonMap.GET(idjp).SupervisorComments==null || tidVsJourneyplanJsonMap.GET(idjp).SupervisorComments==''?queryjournyplan.SupervisorComments__c:tidVsJourneyplanJsonMap.GET(idjp).SupervisorComments;
                        queryjournyplan.Status__c=tidVsJourneyplanJsonMap.GET(idjp).Status==null?queryjournyplan.Status__c:statusMapListCodeForStatus.get(tidVsJourneyplanJsonMap.GET(idjp).Status);
                        queryjournyplan.UserId__c=tidVsJourneyplanJsonMap.GET(idjp).UserId==null?queryjournyplan.UserId__c:tidVsJourneyplanJsonMap.GET(idjp).UserId;
                        
                        queryjournyplan.Tid__c =tidVsJourneyplanJsonMap.GET(idjp).TId==null?queryjournyplan.Tid__c:tidVsJourneyplanJsonMap.GET(idjp).TId;
                        queryjournyplan.Name=''+usr[0].Name+'-'+queryjournyplan.Month__c+'-'+queryjournyplan.Year__c;
                        listOfJourneyPlanToUpsert.add(queryjournyplan);
                    }
                }
                
            }
            //to get the TId which is not present in the salesforce database to insert them.
            idNotinSF=tidVsJourneyplanJsonMap.keyset();
            system.debug('idNotinSF'+idNotinSF);
            system.debug('tidInSf'+tidInSf);
            idNotinSF.removeAll(tidInSf);
            //system.debug('TIdList++++'+TIdList);
            system.debug('TIDSET not in sf '+idNotinSF);
            JourneyPlan__c queryjournyplan;
            //interating over tid which is not present in salesforce
            for(string Tidsset:tidVsJourneyplanJsonMap.keyset())
            {
                if(tidVsJourneyplanJsonMap.containskey(Tidsset)){
                    queryjournyplan=new JourneyPlan__c();
                    system.debug('tidVsJourneyplanJsonMap'+tidVsJourneyplanJsonMap);
                    queryjournyplan.Date__c=tidVsJourneyplanJsonMap.GET(Tidsset).date_x==null || tidVsJourneyplanJsonMap.GET(Tidsset).date_x==''?null: ConversionUtility.StringToDateConversion(tidVsJourneyplanJsonMap.GET(Tidsset).date_x);
                    queryjournyplan.Year__c=tidVsJourneyplanJsonMap.GET(Tidsset).Year==null ||tidVsJourneyplanJsonMap.GET(Tidsset).Year==''?null:ConversionUtility.StringToInteger(tidVsJourneyplanJsonMap.GET(Tidsset).Year);
                    queryjournyplan.Month__c=tidVsJourneyplanJsonMap.GET(Tidsset).Month==null || tidVsJourneyplanJsonMap.GET(Tidsset).Month==''?null:ConversionUtility.StringToInteger(tidVsJourneyplanJsonMap.GET(Tidsset).Month);
                    queryjournyplan.SupervisorComments__c=tidVsJourneyplanJsonMap.GET(Tidsset).SupervisorComments==null?null:tidVsJourneyplanJsonMap.GET(Tidsset).SupervisorComments;
                    queryjournyplan.Status__c=tidVsJourneyplanJsonMap.GET(Tidsset).Status==null?null:statusMapListCodeForStatus.get(tidVsJourneyplanJsonMap.GET(Tidsset).Status);
                    System.debug('userTerritory[0]:::'+userTerritory);
                    queryjournyplan.Territory__c =userTerritory[0].id;
                    
                    queryjournyplan.UserId__c=tidVsJourneyplanJsonMap.GET(Tidsset).UserId==null?userID:tidVsJourneyplanJsonMap.GET(Tidsset).UserId;
                    queryjournyplan.Tid__c =tidVsJourneyplanJsonMap.GET(Tidsset).TId==null?queryjournyplan.Tid__c:tidVsJourneyplanJsonMap.GET(Tidsset).TId;
                    queryjournyplan.Name=''+usr[0].Name+'-'+queryjournyplan.Month__c+'-'+queryjournyplan.Year__c;
                    listOfJourneyPlanToUpsert.add(queryjournyplan);
                }
            } 
            
            Database.UpsertResult [] saveResult = Database.upsert(listOfJourneyPlanToUpsert,false);
            
            LIST<Id> upsertIdList = new LIST<Id>();
            
            for (Database.UpsertResult sr : saveResult) {
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted ' + sr.getId());
                    upsertIdList.add(sr.getId());
                }
                else {
                    allSuccess=false;
                    // Operation failed, so get all error                
                    for(Database.Error err : sr.getErrors()) {
                        postResult.add(new PostResponse.PostResponseObject('0',err.getMessage()));                 
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        
                    }
                }
            }
            
            system.debug('upsertIdList'+ upsertIdList);
            
            if(upsertIdList.size()>0 && journeyPlanMarketData == NULL && journeyPlandetaildata == NULL) {
                
                LIST<JourneyPlanActivity__c> jPActivityListToDelete = new LIST<JourneyPlanActivity__c>();
                jPActivityListToDelete =  [SELECT Id 
                                           FROM JourneyPlanActivity__c
                                           WHERE JourneyPlan__c IN : upsertIdList];
                
                if(jPActivityListToDelete.size()>0) {
                    database.delete(jPActivityListToDelete);
                    
                }
            }
            
            
            //create a map of Tid and realted JourneyPlan Records salesfroce id
            
            for(JourneyPlan__c s :listOfJourneyPlanToUpsert)
            {
                TidAndSalesforceIdMap.put(s.Tid__c,s.id);
            }
            
        }
        //store all Retailer id 
        Set<long> RetailerIdSet = new Set<Long>();
        Set<string> RetailerIdSetWithTid = new Set<string>();
        Set<String> VisitIDSet = new Set<String>();
        List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo> listVar;
        //to insert market visit records 
        //Map<tid,List<marketRecrods>>
        Map<String,List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>> TidAndMarketListMap = new Map<String,List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>>();
        if(journeyPlanMarketData!=null && journeyPlanMarketData.size()>0)
        {
            for(LorealUploadclass.JorneyMarketMarketVisitDetailInfo res:journeyPlanMarketData){
                
                /*if(res.date_x!=null && String.isEmpty(res.date_x)==false )
{
res.date_x=ConvertTOSFFormatDate(res.date_x);
}*/
                
                if(res.VisitType!=null && String.isEmpty(res.VisitType)==false )
                {
                    VisitIDSet.add(res.VisitType); 
                }
                
                
                if(res.RetailerId!=null && String.isEmpty(res.RetailerId)==false)
                {
                    RetailerIdSet.add(Long.valueOf(res.RetailerId));  
                    RetailerIdSetWithTid.add(res.RetailerId);
                }
                //if tid is present in map add the records to the list.
                if(TidAndMarketListMap.get(res.TId)!=null)
                {
                    TidAndMarketListMap.get(res.TId).add(res);
                    
                }
                //if tid is not present in map
                else
                {
                    listVar = new List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>();
                    listVar.add(res);
                    TidAndMarketListMap.put(res.TId,listVar);
                }
            }
            
            List<ivybase__Standard_List_Master__c> StandardListMaster_Listvisit = [select id,name from ivybase__Standard_List_Master__c where name IN :VisitIDSet]; 
            //map<listtype,record id of realted standard list master>
            Map<String,Id> visitID_StandardListID_Map = new Map<String,Id>(); 
            for(ivybase__Standard_List_Master__c rec:StandardListMaster_Listvisit)
            {
                visitID_StandardListID_Map.put(rec.Name,rec.Id);
            }
            
            
            //Map<retailerId , Account id(saelsfroce id)>
            Map<String,Id> AccountInternalIdMap = new Map<String,Id>();
            List<Account> RetailerAccount = [select id,ivybase__Internal_Id__c,Tid__c
                                             from Account 
                                             where ivybase__Internal_Id__c=:RetailerIdset OR Tid__c IN: RetailerIdSetWithTid];
            
            List<Account> RetailerAccount1 = [select id,ivybase__Internal_Id__c,Tid__c
                                              from Account 
                                              where Tid__c IN: RetailerIdSetWithTid AND Is_Conquest__c=TRUE];
            for(Account a:RetailerAccount)
            {
                AccountInternalIdMap.put(String.valueOf(a.ivybase__Internal_Id__c),a.id);
                // AccountInternalIdMap.put(a.Tid__c,a.id);
                
            }
            if(RetailerAccount1!=null && RetailerAccount1.size()>0){
                for(Account a:RetailerAccount1)
                {
                    AccountInternalIdMap.put(a.Tid__c,a.id);
                    // AccountInternalIdMap.put(a.Tid__c,a.id);
                    
                }
            }
            
            
            
            // process the market record in translator to insert
            try{
                List<PostResponse.PostResponseObject> result=JourneyPlanMarketTraslatorUpload.marketVisitTranslator(TidAndMarketListMap, TidAndSalesforceIdMap, AccountInternalIdMap, visitID_StandardListID_Map);
                for(PostResponse.PostResponseObject r:result)
                {
                    if(r.Response=='0')
                    {
                        allSuccess=false;
                        postResult.add(r);  
                    }
                }                
            }
            catch(Exception e)
            {
                DmlException exce = (DmlException)e;
                String ErrorMsg='General Error'+e.getStackTraceString()+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName()+''+exce.getCause()+''+exce.getMessage();
                allSuccess=false;
                postResult.add(new PostResponse.PostResponseObject('0','General Error:'+ErrorMsg));
            }
        }
        Set<String> typeIDSet = new Set<String>();
        //map<tid,List<activityrecords>>
        Map<String,List<LorealUploadclass.JourneyPlanDetailInfo>> TidAndActivityListMap = new Map<String,List<LorealUploadclass.JourneyPlanDetailInfo>>();
        List<LorealUploadclass.JourneyPlanDetailInfo> listOfActivityVar;
        if(journeyPlandetaildata!=null && journeyPlandetaildata.size()>0)
        {
            for(LorealUploadclass.JourneyPlanDetailInfo res:journeyPlandetaildata){
                /*if(res.date_x!=null &&  String.isEmpty(res.date_x)==false)
{
res.date_x=ConvertTOSFFormatDate(res.date_x);
}*/
                if(res.TypeId!=null && String.isEmpty(res.TypeId)==false )
                {
                    typeIDSet.add(res.TypeId); 
                }
                //if tid is present in map
                if(TidAndActivityListMap.get(res.TId)!=null)
                {
                    TidAndActivityListMap.get(res.TId).add(res);
                    
                }else//if tid is not present in map
                {
                    listOfActivityVar = new List<LorealUploadclass.JourneyPlanDetailInfo>();
                    listOfActivityVar.add(res);
                    TidAndActivityListMap.put(res.TId,listOfActivityVar);
                }
            }
            List<ivybase__Standard_List_Master__c> StandardListMaster_List = [select id,name from ivybase__Standard_List_Master__c where name=:typeIDSet]; 
            //map<listtype,record id of realted standard list master>
            Map<String,Id> typeID_StandardListID_Map = new Map<String,Id>(); 
            for(ivybase__Standard_List_Master__c rec:StandardListMaster_List)
            {
                typeID_StandardListID_Map.put(rec.Name,rec.Id);
            }
            //process the activity records in translator
            try{
                List<PostResponse.PostResponseObject> result = JourneyPlanActivityTranslatorUpload.activityTranslator(TidAndActivityListMap,typeID_StandardListID_Map,TidAndSalesforceIdMap); 
                for(PostResponse.PostResponseObject r:result)
                {
                    if(r.Response=='0')
                    {
                        allSuccess=false;
                        postResult.add(r);  
                    }
                }
            }
            catch(Exception e)
            {
                system.debug('123456Exception');
                String ErrorMsg='General Error'+e.getStackTraceString()+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
                if(e.getTypeName()=='DmlException')
                {
                    DmlException exce = (DmlException)e;
                    ErrorMsg=ErrorMsg+''+exce.getCause()+''+exce.getMessage();
                }
                allSuccess=false;
                postResult.add(new PostResponse.PostResponseObject('0','General Error:'+ErrorMsg));
            } 
        }
        if(postResult.size()==0 && allSuccess==true && journeyPlanning!=null && journeyPlanMarketData!=null && journeyPlandetaildata!=null)
        {
            postResult.add(new PostResponse.PostResponseObject('1','success'));
        }
        else
        {
            String errorMessage='Null value->';
            if(journeyPlanning==null)
            {
                errorMessage+=' JourneyPlanHeader';
            }
            if(journeyPlanMarketData==null)
            {
                errorMessage+=' JourneyPlan_MarketVisitDetail';
            }
            if(journeyPlandetaildata==null)
            {
                errorMessage+=' JourneyPlanDetail'; 
            }
            postResult.add(new PostResponse.PostResponseObject('0','Warning :'+errorMessage));
        }
        return postResult;  
    }
    public static List<PostResponse.PostResponseObject> CompetitorTrackingTransaction(List<LorealUploadclass.CompetitorHeaderInfo> CompetitorHeaderNew,List<LorealUploadclass.CompetitorDetailsInfo> CompetitorDetailsNew,List<LorealUploadclass.CompetitorPhotoDetailsInfo> CompetitorPhotoDetailsNew){
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        System.debug('CompetitorHeader::'+CompetitorHeaderNew);
        System.debug('CompetitorDetails::'+CompetitorDetailsNew);
        System.debug('CompetitorPhotoDetails::'+CompetitorPhotoDetailsNew);
        try{
            if(CompetitorHeaderNew != null && CompetitorHeaderNew.size()>0 && CompetitorPhotoDetailsNew != null && CompetitorPhotoDetailsNew.size()>0)
                CompetitorTrackingTranslator.translate(CompetitorHeaderNew,CompetitorDetailsNew,CompetitorPhotoDetailsNew);
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
    }
    
    //SalesForecast Object Records Insertion
    public static List<PostResponse.PostResponseObject> PromotionalPlanningTransaction(List<LorealUploadclass.PromotionalPlanninginfo> PromotionalPlanningHeader,List<LorealUploadclass.PromotionalPlanningDetail> PromotionalPlanningDetails,List<ivybase__Location_Hierarchy__c> userTerritory){
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            //
            Map<String,Id> Sales_Forecast_Tid_Id_Map=promotionalPlanHeaderUploadTranslator.translate(PromotionalPlanningHeader,userTerritory);
            //SalesForcast Promotional Detail
            if(Sales_Forecast_Tid_Id_Map.keyset().size()>0 && PromotionalPlanningDetails!=null){ 
                promotionalPlanDetailUploadTranslator.translate(Sales_Forecast_Tid_Id_Map,PromotionalPlanningDetails);
            }
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
    }
    
    //DreamList  
    public static List<PostResponse.PostResponseObject> DreamListTransaction(List<LorealUploadclass.DreamListInfo> DreamListHeader){
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            if(DreamListHeader!=null){
                DreamListUploadTranslator.translate(DreamListHeader);//
            }
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
    }
    //HairDresserList  
    /*public static List<PostResponse.PostResponseObject> HairDresserListTransaction(List<LorealUploadclass.HairDresserInfo> NewHairDresser,Map<String,String> storeIdTidMap){
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            if(NewHairDresser!=null){
                HairDresserUploadTranslator.translateHairDresser(NewHairDresser,storeIdTidMap);//
            }
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg;
        }
        postResult.add(str);
        return postResult;
    }*/
    //ordr transacion
   public static List<PostResponse.PostResponseObject> orderTransaction(List<LorealUploadclass.OrderHeader> orderHeader,List<LorealUploadclass.OrderDetail> orderDetail,List<LorealUploadclass.SchemeDetail> SchemeDetail,List<LorealUploadclass.SchemeFreeProductDetail> SchemeFreeProductDetail){
        system.debug('Entered Order Transaction'+orderHeader+''+orderDetail+''+SchemeDetail);
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            if(orderHeader!=null){
                OrderUploadTranslator.translateOrderHeader(orderHeader,orderDetail);  
            }
            if(orderDetail!=null){
                OrderUploadTranslator.translateOrderDetails(orderDetail,SchemeDetail,SchemeFreeProductDetail);    
            }
            if(SchemeDetail!=null || SchemeFreeProductDetail!=null)
            {
                OrderUploadTranslator.translateSchemeApplyDetails(SchemeDetail,SchemeFreeProductDetail);
            }
            //
        }
        catch(Exception e)
        {
            
            String msg = e.getStackTraceString();
            system.debug('msg'+msg);
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            system.debug('str.ErrorMsg'+str.ErrorMsg);
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
    } ///commented for japan deploymnt purpose
    
    /*   public static List<PostResponse.PostResponseObject> RetailerCheckListTransaction(List<LorealUploadclass.DocumentDetailInfo> DocumentDetail){
List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
str.Response = '1';
str.ErrorMsg = 'Success';
try{
if(DocumentDetail!=null){
RetailerCheckListUploadTranslator.translate(DocumentDetail);
}
}
catch(Exception e)
{ 
String msg = e.getStackTraceString();
str.Response='0';
str.ErrorMsg='General Error'+msg;
}
postResult.add(str);
return postResult;

}*/
    //retailer edit transaction
    public static List<PostResponse.PostResponseObject> RetailerEditTransaction(List<LorealUploadclass.NewRetailerEditHeaderInfo> NewRetailerEditHeader,List<LorealUploadclass.NewRetailerEditDetailInfo> NewRetailerEditDetail,List<LorealUploadclass.HairDresserInfo> NewHairDresser){
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        Map<String,String> storeIdTidMap = new Map<String,String>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            if(NewRetailerEditHeader!=null && NewRetailerEditDetail != null && NewRetailerEditHeader.size()>0 && NewRetailerEditDetail.size()>0){
                RetailerEditUploadTranslator.translate(NewRetailerEditHeader,NewRetailerEditDetail,NewHairDresser);
            }
            else if(NewHairDresser!=Null)
                HairDresserUploadTranslator.translateHairDresser(NewHairDresser,storeIdTidMap);  
            if(Test.isRunningTest())
            {
                throw new DmlException('DmlException');
            }
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
        
    }
    
    //Survey upload Method
    public static List<PostResponse.PostResponseObject> surveyUpload(List<LorealUploadclass.AnswerHeader> AnswerHeader,List<LorealUploadclass.AnswerDetail> AnswerDetail,Map<String, ivybase__Survey__c> surveyInternalIdwithId,Id sellerId,Map<String, Id> storeInternalIdwithId, Map<String, Id> quetionInternalIdwithId,Map<String, Id> surveyquestionWithQuestionIdMap,Map<String, String> reqHeaderParamMap){
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        Map<String,String> storeIdTidMap = new Map<String,String>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        system.debug('surveyInternalIdwithId'+ surveyInternalIdwithId);
        try{
            if(AnswerHeader!=null){
                AnswerTranslator.uploadAnswer(AnswerHeader,AnswerDetail,surveyInternalIdwithId,sellerId,storeInternalIdwithId,quetionInternalIdwithId,surveyquestionWithQuestionIdMap,reqHeaderParamMap);
            }
            
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg;
        }
        postResult.add(str);
        return postResult;
        
    }
    
    //Order Return transaction
  /*  public static List<PostResponse.PostResponseObject> OrderReturnTransaction(List<LorealUploadclass.NewSalesReturnHeader> NewSalesReturnHeader,List<LorealUploadclass.NewSalesReturnDetails> NewSalesReturnDetails){
        //system.debug('Entered Order Transaction'+orderHeader+''+orderDetail+''+SchemeDetail);
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            if(NewSalesReturnHeader!=null){
                //salesReturnUploadTranslator.translateOrderReturnHeader(NewSalesReturnHeader);  
            }
            if(NewSalesReturnDetails!=null){
                //salesReturnUploadTranslator.translateOrderReturnDetails(NewSalesReturnDetails);    
            }
            
            //
        }
        catch(Exception e)
        {
            
            String msg = e.getStackTraceString();
            system.debug('msg'+msg);
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            system.debug('str.ErrorMsg'+str.ErrorMsg);
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
        
    }*/
    //commented for JPN
    //digital content detail data
    public static List<PostResponse.PostResponseObject> Digitalcontentdata(List<LorealUploadclass.DigitalContentTrainingDetaildata> DigitalContentTrainingDetaildata){
        //system.debug('Entered Order Transaction'+orderHeader+''+orderDetail+''+SchemeDetail);
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        try{
            if(DigitalContentTrainingDetaildata!=null){
                DigitalConTrainingDetUploadTransalator.translateDigitalContentTrainingDetail(DigitalContentTrainingDetaildata);  
            }
            
            
            //
        }
        catch(Exception e)
        {
            
            String msg = e.getStackTraceString();
            system.debug('msg'+msg);
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            system.debug('str.ErrorMsg'+str.ErrorMsg);
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
        
    }
    
    public static String ConvertTOSFFormatDate(String dateStringFromJson)
    {
        String strDate = dateStringFromJson;
        String[] SplitDate = strDate.split('/');
        String day = SplitDate[2];
        String month = SplitDate[1];
        String year = SplitDate[0];
        String formattedData = month+'/'+day+'/'+year;
        return formattedData;   
    }
    
    public static Date convertStringToDate(String datestr){
        
        Date dateVal;
        List<String> dateList = datestr.split('/');
        dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
        return dateVal;
    }
    public static ivybase__Visit__c getVisit(List<ivybase__Visit__c> visitlist, Id storeId, Date visitDate){
        
        if(visitlist != null && visitlist.size() >0){
            for( ivybase__Visit__c visit : visitlist){
                
                if( visit.ivybase__Store__c ==  storeId && visit.ivybase__Visit_Date__c == visitDate){
                    return visit;
                }
            }
        }
        return null;
    }
    
    // Start to save visit and visit detail
    public static List<PostResponse.PostResponseObject> uploadVisitDetails(List<LorealUploadclass.cls_OutletTimestamp> outletHeader, 
                                                                           List<LorealUploadclass.cls_OutletTimeStampDetail> outletDetail,
                                                                           List<LorealUploadclass.cls_Nonproductivereasonmaster> Nonproductivereasonmaster)
    {
        
        List<PostResponse.PostResponseObject> postResult = new List<PostResponse.PostResponseObject>();
        Map<String,String> storeIdTidMap = new Map<String,String>();
        PostResponse.PostResponseObject str = new PostResponse.PostResponseObject();
        str.Response = '1';
        str.ErrorMsg = 'Success';
        
        Map<String,LorealUploadclass.cls_OutletTimestamp> visitIdAndOutletTimeStampMap = 
            new Map<String,LorealUploadclass.cls_OutletTimestamp>();
        Map<String,List<LorealUploadclass.cls_OutletTimestamp>> outletCombAndOutletClsMap = 
            new Map<String,List<LorealUploadclass.cls_OutletTimestamp>>(); 
        Set<String> retailerInternalIdSet = new Set<String>();
        Set<Id> storeIdSet = new Set<Id>();
        Map<String,String> retailerSFIdAndInternalIdMap = new Map<String,String>();
        Map<String,Id> visitUIdAndSFIdMap = new  Map<String,Id>();
        List<ivybase__Visit__c> visitList = new List<ivybase__Visit__c>();
        Set<Id> VisitIdsnottoupdate = new Set<Id>();
        Set<String> reasonIdSet = new Set<String>();
        Map<String,List<LorealUploadclass.cls_Nonproductivereasonmaster>> ReasonMsterClsMap = 
            new Map<String,List<LorealUploadclass.cls_Nonproductivereasonmaster>>(); 
        AccountDomain.accountIdandNameInfo accinfo;
        Map<String,ivybase__Visit__c> visitIdAndVisitObjMap = new Map<String,ivybase__Visit__c>();
        List<ivybase__Visit_Time__c> visitTimeList = new List<ivybase__Visit_Time__c>();
        List<ivybase__Visit_Detail__c> visitDetailList = new List<ivybase__Visit_Detail__c>();
        Map<String,String> reasonIdAndSFReasonMap = new Map<String,String>();
        Map<Id,Id> accwithlastvisitMap = new Map<Id,Id>();
        
        try{
            List<ivybase__Resource__c> contactList = ResourceService.getResourceByUserId(UserInfo.getUserId());
            Id sellerId;
            String sellerName = '';
            if (contactList != null && contactList.size() > 0) {
                sellerId = contactList[0].Id;
                sellerName = contactList[0].Name;
            }
            // Forming Non Productive Reason Master Map based on RetailerID & VisitDate Combination  
            if(Nonproductivereasonmaster != null){
                for(LorealUploadclass.cls_Nonproductivereasonmaster nonprod : Nonproductivereasonmaster){
                    
                    reasonIdSet.add(nonprod.ReasonID);
                    if (nonprod.retailerid != null && nonprod.retailerid.isNumeric()) {
                        retailerInternalIdSet.add(nonprod.retailerid);
                    }
                    if(nonprod.Date_x != null && nonprod.retailerid != null) {
                        if(!ReasonMsterClsMap.containsKey( nonprod.retailerid + '-'  + nonprod.Date_x)){
                            ReasonMsterClsMap.put( nonprod.retailerid + '-'  + nonprod.Date_x, 
                                                  new List<LorealUploadclass.cls_Nonproductivereasonmaster>());
                        }
                        ReasonMsterClsMap.get( nonprod.retailerid + '-'  + nonprod.Date_x).add( nonprod);
                    }
                }
            }
            
            //Forming OutlineStampHeader Map based on RetailerID & VisitDate Combination 
            system.debug(':::outletHeader:::'+outletHeader);
            if (outletHeader != null ) {
                for(LorealUploadclass.cls_OutletTimestamp outline: outletHeader){
                    
                    if( outline.RetailerID != null && outline.RetailerID.trim() != '' 
                       && outline.VisitDate != null && outline.VisitDate.trim() != ''){
                           
                           Date tempdate = convertStringToDate(outline.VisitDate);
                           String visitDate = String.valueOf(tempdate).replace('-','/');
                           
                           if(!outletCombAndOutletClsMap.containsKey( outline.RetailerID + '-'  + VisitDate ))
                               outletCombAndOutletClsMap.put( outline.RetailerID + '-'  + VisitDate, 
                                                             new List<LorealUploadclass.cls_OutletTimestamp>());
                           outletCombAndOutletClsMap.get( outline.RetailerID + '-'  + VisitDate ).add( outline );
                       }
                    
                    if(outline.retailerid != null && outline.retailerid.isNumeric()) {
                        retailerInternalIdSet.add(outline.retailerid);
                    }
                    
                    if(outline.VisitID != null && outline.VisitID.trim() != '') 
                        visitIdAndOutletTimeStampMap.put(outline.VisitID,outline);   
                }
            }
            //Collected All internal retailer id to fetch Account records 
            accinfo = AccountService.getAccountIdByInternalId(retailerInternalIdSet);
            for(String internalId : accinfo.internalIdAndSFIdMap.keyset()){
                storeIdSet.add(accinfo.internalIdAndSFIdMap.get(internalId));
                retailerSFIdAndInternalIdMap.put(accinfo.internalIdAndSFIdMap.get(internalId),internalId );
            }
            system.debug('::retailerSFIdAndInternalIdMap:::'+retailerSFIdAndInternalIdMap);
            //Collecting SF Id from Reason Internal Id
            for(ivybase__Standard_List_Master__c reasonMtr : getReasonList()){
                reasonIdAndSFReasonMap.put(reasonMtr.Name,reasonMtr.ivybase__List_Name__c);
            }
            Map<String, boolean> storeIdwithNovisitMap = new Map<String, Boolean>();
            //Update Visit Records, if visit has same retailer id and visit date already.
            for(ivybase__Visit__c visit : VisitService.getVisitsForStoreAndSeller(storeIdSet)){
                system.debug(':::visit:::'+visit); 
                if( retailerSFIdAndInternalIdMap != null && retailerSFIdAndInternalIdMap.containskey(visit.ivybase__Store__c)
                   && !storeIdwithNovisitMap.containsKey(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c)) ) {
                       storeIdwithNovisitMap.put(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c), false);                    
                   }     
                
                system.debug(':::visit.ivybase__Store__c:::'+visit.ivybase__Store__c); 
                if(retailerSFIdAndInternalIdMap.get( visit.ivybase__Store__c ) != null && visit.ivybase__Original_Date__c != null ){
                    
                    system.debug(':::visit:2::');
                    String visitDate = String.valueOf(visit.ivybase__Original_Date__c).replace('-','/');
                    String retailIdAndVisitDateStr = retailerSFIdAndInternalIdMap.get( visit.ivybase__Store__c ) + '-' + visitDate;
                    system.debug('::::retailIdAndVisitDateStr:::'+retailIdAndVisitDateStr);
                    system.debug('::::ReasonMsterClsMap::::'+ReasonMsterClsMap);
                    
                    if( outletCombAndOutletClsMap.get( retailIdAndVisitDateStr ) != null ){
                        
                        storeIdwithNovisitMap.put(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c), true); 
                        system.debug(':::visit:22::');
                        List<LorealUploadclass.cls_OutletTimestamp> outletTimeClsList = new List<LorealUploadclass.cls_OutletTimestamp>();
                        outletTimeClsList  = outletCombAndOutletClsMap.get( retailIdAndVisitDateStr  );
                        
                        if( outletTimeClsList.size() > 0 && outletTimeClsList[0].VisitID != null && outletTimeClsList[0].VisitDate != null){
                            
                            for(LorealUploadclass.cls_OutletTimestamp outlet : outletTimeClsList){
                                visitUIdAndSFIdMap.put( outlet.VisitID, visit.Id);
                            }
                            visit.ivybase__Visit_Date__c = convertStringToDate(outletTimeClsList[0].VisitDate);
                            visit.ivybase__Status__c  = 'Completed';
                            
                            if ( String.isEmpty(outletTimeClsList[0].latitude) == false  
                                && String.isEmpty(outletTimeClsList[0].longitude) == false ) {
                                    
                                    visit.ivybase__Lat_Position__Latitude__s = Decimal.valueOf(outletTimeClsList[0].latitude);
                                    visit.ivybase__Lat_Position__Longitude__s = Decimal.valueOf(outletTimeClsList[0].longitude);
                                }
                            
                            visitList.add(visit);
                            VisitIdsnottoupdate.add(visit.Id);
                            String monthString = visit.ivybase__Visit_Date__c.month() < 10 ? '0'+visit.ivybase__Visit_Date__c.month() : ''+visit.ivybase__Visit_Date__c.month();
                            String dayString = visit.ivybase__Visit_Date__c.day() < 10 ? '0'+visit.ivybase__Visit_Date__c.day() : ''+visit.ivybase__Visit_Date__c.day();
                            String visitDateStr = visit.ivybase__Visit_Date__c.year()+'/'+monthString +'/'+dayString;
                            
                            visitStoreDateWithVisitSFIdMap.put(outletTimeClsList[0].RetailerID + ''+ visitDateStr, visit.Id);
                        }
                        
                    } else if( ReasonMsterClsMap != null && ReasonMsterClsMap.containsKey(retailIdAndVisitDateStr) ) {
                        
                        storeIdwithNovisitMap.put(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c), true); 
                        system.debug(':::visit:3::'+storeIdwithNovisitMap);
                        List<LorealUploadclass.cls_Nonproductivereasonmaster > nonProdClsList = 
                            new List<LorealUploadclass.cls_Nonproductivereasonmaster >();
                        nonProdClsList = ReasonMsterClsMap.get( retailIdAndVisitDateStr  );
                        
                        if(nonProdClsList.size() > 0 && nonProdClsList[0].ReasonID != null){
                            system.debug(':::visit:4::');
                            visit.ivybase__Non_Productive_Reason__c = (reasonIdAndSFReasonMap.containsKey(nonProdClsList[0].ReasonID)) ? 
                                reasonIdAndSFReasonMap.get(nonProdClsList[0].ReasonID): '';
                            
                            visit.ivybase__Status__c  = 'Not Completed';                                          
                            visitList.add(visit);
                            VisitIdsnottoupdate.add(visit.Id);
                        }
                        
                    } else if (ReasonMsterClsMap != null) {
                        if (retailerSFIdAndInternalIdMap != null && retailerSFIdAndInternalIdMap.containsKey(visit.ivybase__Store__c)
                            && storeIdwithNovisitMap.containskey(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c))
                            && !storeIdwithNovisitMap.get(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c))) { 
                                
                                storeIdwithNovisitMap.remove(retailerSFIdAndInternalIdMap.get(visit.ivybase__Store__c)); 
                            }
                    }
                }
            }
            if (ReasonMsterClsMap != null && Nonproductivereasonmaster != null ) {
                for (LorealUploadclass.cls_Nonproductivereasonmaster nonprod : Nonproductivereasonmaster) {
                    system.debug(':::storeIdwithNovisitMap:::'+storeIdwithNovisitMap);
                    if (storeIdwithNovisitMap.size() == 0 || (storeIdwithNovisitMap.containsKey(nonprod.retailerid) 
                                                              && !storeIdwithNovisitMap.get(nonprod.retailerid))) {
                                                                  
                                                                  ivybase__Visit__c visitRec = new ivybase__Visit__c();
                                                                  visitRec.ivybase__Store__c  = accinfo.internalIdAndSFIdMap.get( nonprod.retailerid);
                                                                  
                                                                  visitRec.ivybase__Resource__c  = sellerId ;
                                                                  visitRec.ivybase__Type__c = 'Planned';
                                                                  visitRec.ivybase__Status__c  = 'Not Completed';
                                                                  visitRec.ivybase__Visit_Date__c = convertStringToDate( nonprod.Date_x );
                                                                  visitRec.ivybase__Original_Date__c = visitRec.ivybase__Visit_Date__c;
                                                                  visitRec.ivybase__Non_Productive_Reason__c = (reasonIdAndSFReasonMap.containsKey(nonprod.ReasonID)) ? 
                                                                      reasonIdAndSFReasonMap.get(nonprod.ReasonID): '';
                                                                  
                                                                  String visitName = '';
                                                                  
                                                                  if (accinfo.internalIdAndNameMap != null && accinfo.internalIdAndNameMap.containsKey(nonprod.retailerid)) {
                                                                      
                                                                      visitName += accinfo.internalIdAndNameMap.get( nonprod.retailerid).length() <= 30 ? 
                                                                          accinfo.internalIdAndNameMap.get( nonprod.retailerid) : accinfo.internalIdAndNameMap.get(nonprod.retailerid).substring(0,30);
                                                                      
                                                                  }
                                                                  if (sellerName != '') {
                                                                      if (visitName != '') {
                                                                          visitName += '-';
                                                                      }
                                                                      visitName += sellerName.length() <= 30 ? sellerName : sellerName.substring(0,30);
                                                                  }
                                                                  if (visitRec.ivybase__Visit_Date__c != null) {
                                                                      if (visitName != '') {
                                                                          visitName += '-';
                                                                      }
                                                                      visitName += visitRec.ivybase__Visit_Date__c.year()+'-'+visitRec.ivybase__Visit_Date__c.month()+'-'+visitRec.ivybase__Visit_Date__c.day();
                                                                  }
                                                                  if (!String.isBlank(visitName)) {    
                                                                      visitRec.Name = visitName; 
                                                                  }
                                                                  visitList.add(visitRec);
                                                              }
                }
            }
            //Ideintify the Seller Name & Id
            // List<Contact> contactList = ContactService.getContactsByUserId(UserInfo.getUserId());
            
            System.debug('::::visitIdAndOutletTimeStampMap'+visitIdAndOutletTimeStampMap+':::visitUIdAndSFIdMap'+visitUIdAndSFIdMap);       
            Set<String> retailIdAndSellerAndVisitDateCombo = new Set<String>();
            //Insert new visit records, if retailer id and visit date combinations is new one
            Map<Id, String> storeIdwithInternalIdMap = new Map<Id, String>();
            
            String[] visitFields = new String[] { 'Name','ivybase__Original_Date__c','ivybase__Type__c','ivybase__Visit_Date__c',
                'ivybase__Status__c','ivybase__Lat_Position__Latitude__s',
                'ivybase__Lat_Position__Longitude__s','ivybase__Seller__c','ivybase__Resource__c'};
                    String[] visitTimeFields = new String[] { 'ivybase__Visit__c','ivybase__Time_In__c','ivybase__Time_Out__c'};
                        String[] visitDetailFields = new String[]{'ivybase__Visit__c','ivybase__ModuleCode__c','ivybase__Time_In__c',
                            'ivybase__Time_Out__c'};
                                
                                if (SecurityUtility.checkIsEditable('ivybase__Visit__c', visitFields )
                                    && SecurityUtility.checkIsCreateable('ivybase__Visit_Time__c', visitTimeFields)
                                    && SecurityUtility.checkIsCreateable('ivybase__Visit_Detail__c', visitDetailFields) )
                            {
                                
                                for(String visitId : visitIdAndOutletTimeStampMap.keyset()){
                                    
                                    if(visitUIdAndSFIdMap.containsKey(visitId) == false){
                                        
                                        if(visitIdAndOutletTimeStampMap.get(visitId).RetailerID != null 
                                           && visitIdAndOutletTimeStampMap.get(visitId).VisitDate != null){
                                               
                                               String  avoidVisitDuplicate  =  visitIdAndOutletTimeStampMap.get(visitId).RetailerID + sellerId + visitIdAndOutletTimeStampMap.get(visitId).VisitDate;
                                               
                                               if(!retailIdAndSellerAndVisitDateCombo.contains(avoidVisitDuplicate)){
                                                   
                                                   ivybase__Visit__c visitRec = new ivybase__Visit__c();
                                                   if (visitIdAndOutletTimeStampMap != null && accinfo.internalIdAndSFIdMap != null 
                                                       && visitIdAndOutletTimeStampMap.containsKey(visitId)) {
                                                           
                                                           visitRec.ivybase__Store__c  = accinfo.internalIdAndSFIdMap.get( visitIdAndOutletTimeStampMap.get(visitId).RetailerID );
                                                           storeIdwithInternalIdMap.put(visitRec.ivybase__Store__c, visitIdAndOutletTimeStampMap.get(visitId).RetailerID);
                                                       }
                                                   // visitRec.ivybase__Seller__c  = sellerId ;
                                                   visitRec.ivybase__Resource__c  = sellerId ;System.debug('Resource_sellerid'+sellerId);
                                                   visitRec.ivybase__Type__c = 'Planned';
                                                   visitRec.ivybase__Status__c  = 'Completed';
                                                   visitRec.ivybase__Visit_Date__c = convertStringToDate(visitIdAndOutletTimeStampMap.get(visitId).VisitDate );
                                                   visitRec.ivybase__Original_Date__c = visitRec.ivybase__Visit_Date__c;
                                                   
                                                   String visitName = '';
                                                   
                                                   if (visitIdAndOutletTimeStampMap != null && accinfo.internalIdAndNameMap != null 
                                                       && visitIdAndOutletTimeStampMap.containsKey(visitId)
                                                       && visitIdAndOutletTimeStampMap.size() > 0 && accinfo.internalIdAndNameMap.size() > 0) {
                                                           
                                                           visitName += accinfo.internalIdAndNameMap.get( visitIdAndOutletTimeStampMap.get(visitId).RetailerID ).length() <= 30 ? accinfo.internalIdAndNameMap.get( visitIdAndOutletTimeStampMap.get(visitId).RetailerID ) : accinfo.internalIdAndNameMap.get( visitIdAndOutletTimeStampMap.get(visitId).RetailerID ).substring(0,30);
                                                           
                                                       }
                                                   
                                                   if (String.isEmpty(visitIdAndOutletTimeStampMap.get(visitId).latitude) == false  
                                                       && String.isEmpty(visitIdAndOutletTimeStampMap.get(visitId).longitude) == false ) {
                                                           
                                                           visitRec.ivybase__Lat_Position__Latitude__s = Decimal.valueOf(visitIdAndOutletTimeStampMap.get(visitId).latitude);
                                                           visitRec.ivybase__Lat_Position__Longitude__s = Decimal.valueOf(visitIdAndOutletTimeStampMap.get(visitId).longitude);
                                                       }
                                                   if (sellerName != '') {
                                                       if (visitName != '') {
                                                           visitName += '-';
                                                       }
                                                       visitName += sellerName.length() <= 30 ? sellerName : sellerName.substring(0,30);
                                                   }
                                                   if (visitRec.ivybase__Visit_Date__c != null) {
                                                       if (visitName != '') {
                                                           visitName += '-';
                                                       }
                                                       visitName += visitRec.ivybase__Visit_Date__c.year()+'-'+visitRec.ivybase__Visit_Date__c.month()+'-'+visitRec.ivybase__Visit_Date__c.day();
                                                   }
                                                   if (!String.isBlank(visitName)) {    
                                                       visitRec.Name = visitName; 
                                                   }
                                                   
                                                   visitIdAndVisitObjMap.put(visitId,visitRec);
                                                   retailIdAndSellerAndVisitDateCombo.add(avoidVisitDuplicate);
                                               }
                                           }
                                    }
                                }
                                System.debug('****visitIdAndVisitObjMap'+visitIdAndVisitObjMap);
                                //Insert DML execution of UnPlanned visit records ----------------------
                                if (visitIdAndVisitObjMap != null && visitIdAndVisitObjMap.size() > 0) {
                                    insert visitIdAndVisitObjMap.values();
                                    for(ivybase__Visit__c visit : visitIdAndVisitObjMap.values()) {
                                        
                                        if(!accwithlastvisitMap.containskey(visit.ivybase__Store__c)) {
                                            accwithlastvisitMap.put(visit.ivybase__Store__c,visit.Id);
                                        }
                                    }
                                    
                                }
                                System.debug('****accwithlastvisitMap'+accwithlastvisitMap);
                                for(String vid: visitIdAndVisitObjMap.keyset()){
                                    visitUIdAndSFIdMap.put(vid,visitIdAndVisitObjMap.get(vid).Id);
                                    ivybase__Visit__c insertedVisit = visitIdAndVisitObjMap.get(vid);
                                    
                                    if (storeIdwithInternalIdMap != null && storeIdwithInternalIdMap.size() > 0 
                                        && storeIdwithInternalIdMap.containsKey(insertedVisit.ivybase__Store__c)) {
                                            
                                            String monthString = insertedVisit.ivybase__Visit_Date__c.month() < 10 ? '0'+insertedVisit.ivybase__Visit_Date__c.month() : ''+insertedVisit.ivybase__Visit_Date__c.month();
                                            String dayString = insertedVisit.ivybase__Visit_Date__c.day() < 10 ? '0'+insertedVisit.ivybase__Visit_Date__c.day() : ''+insertedVisit.ivybase__Visit_Date__c.day();
                                            String visitDateStr = insertedVisit.ivybase__Visit_Date__c.year()+'/'+monthString +'/'+dayString;
                                            visitStoreDateWithVisitSFIdMap.put(storeIdwithInternalIdMap.get(insertedVisit.ivybase__Store__c)+ ''+ visitDateStr, insertedVisit.Id);
                                        }            
                                }
                                
                                //Inserting visit time records using OutlineStamp time -----
                                
                                for( String strg :outletCombAndOutletClsMap.keyset()){
                                    
                                    for(LorealUploadclass.cls_OutletTimestamp outletstamp : outletCombAndOutletClsMap.get( strg ) ){
                                        
                                        if(outletstamp.VisitID != null && outletstamp.VisitID.trim() != null && visitUIdAndSFIdMap.get( outletstamp.VisitID ) != null){
                                            
                                            ivybase__Visit_Time__c vdTime = new ivybase__Visit_Time__c();
                                            vdTime.ivybase__Visit__c = visitUIdAndSFIdMap.get( outletstamp.VisitID );
                                            vdTime.ivybase__Time_In__c = CommonUtility.convertStringToLocalDT(outletstamp.timein);
                                            vdTime.ivybase__Time_Out__c = CommonUtility.convertStringToLocalDT(outletstamp.timeout);
                                            visitTimeList.add(vdTime);
                                        }
                                        
                                    }
                                }
                                
                                system.debug('::outletDetail::'+outletDetail);
                                // Inserting visit detail records using outline stamp detail
                                if (outletDetail != null) {
                                    for(LorealUploadclass.cls_OutletTimeStampDetail outline : outletDetail){
                                        
                                        if(outline.UID != null && outline.UID.trim() != '' && visitUIdAndSFIdMap.get( outline.UID ) != null){
                                            
                                            ivybase__Visit_Detail__c visitDetail = new ivybase__Visit_Detail__c();
                                            visitDetail.ivybase__Visit__c = visitUIdAndSFIdMap.get( outline.UID );
                                            visitDetail.ivybase__ModuleCode__c = outline.ModuleCode;
                                            visitDetail.ivybase__Time_In__c = CommonUtility.convertStringToLocalDT(outline.timein);
                                            visitDetail.ivybase__Time_Out__c = CommonUtility.convertStringToLocalDT(outline.timeout);
                                            visitDetailList.add(visitDetail);
                                        }
                                    }
                                }
                                
                                
                                //DML execution of survey result detail records -------------------------------
                                if(visitList.size() > 0) {
                                    upsert  visitList;
                                    
                                    for(ivybase__Visit__c visit : visitList) {
                                        
                                        if(VisitIdsnottoupdate.contains(visit.Id) == false && !accwithlastvisitMap.containskey(visit.ivybase__Store__c)) {
                                            accwithlastvisitMap.put(visit.ivybase__Store__c,visit.Id);
                                        }
                                    }
                                }
                                if(visitDetailList.size() > 0) insert visitDetailList;
                                if(visitTimeList.size() > 0) insert visitTimeList;
                                
                                
                                System.debug('visitList::::'+visitList);
                                
                                System.debug('accwithlastvisitMap::::'+accwithlastvisitMap);
                                List<Account> accList = AccountService.getAccbyId(accwithlastvisitMap.keyset());
                                System.debug('accList ::::'+accList );
                                
                                
                                if(accList != null && accList.size() > 0) {
                                    
                                    for(Account acc : accList){
                                        
                                        if(accwithlastvisitMap.get(acc.Id) != NULL){
                                            acc.ivybase__Second_LastVisit__c = acc.ivybase__Last_Visit__c;
                                            acc.ivybase__Last_Visit__c = accwithlastvisitMap.get(acc.Id);
                                        }
                                    }
                                    
                                    update accList;
                                    System.debug('accList-updated ::::'+accList );
                                }
                            } else {
                                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                            }
        }
        catch(Exception e)
        { 
            String msg = e.getStackTraceString();
            str.Response='0';
            str.ErrorMsg='General Error'+msg+'-cause-'+e.getCause()+'line'+e.getLineNumber()+'==typename='+e.getTypeName();
            if(e.getTypeName()=='DmlException')
            {
                DmlException exce = (DmlException)e;
                str.ErrorMsg=str.ErrorMsg+''+exce.getCause()+''+exce.getMessage();
            }
        }
        postResult.add(str);
        return postResult;
    }
    
    public static List<ivybase__Standard_List_Master__c> getReasonList(){
        
        if(reasonlist == null){
            reasonlist  = StandardListMasterService.getStandardListBylistType('REASON');
            return reasonlist;
        }else{
            return reasonlist;
        }
    }
}