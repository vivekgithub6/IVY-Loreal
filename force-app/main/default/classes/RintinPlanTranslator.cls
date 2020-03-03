public class RintinPlanTranslator {

    public static List<PostResponse.PostResponseObject>  RintinDokoSalonDetailsMethod(Map<String, List<LorealUploadclass.RintinDokoSalonDetailsInfo>> TidAndMarketListMap,
                                                                                      Map<String, Id> TidAndSalesforceIdMap, Map<String, Id> AccountInternalIdMap) 
    {

        List<PostResponse.PostResponseObject> result =new List<PostResponse.PostResponseObject>();
        Rintin_Plan_Details__c salonDetails;
        //delete the existing records
        Set<Id> RintinPlanIdList = new Set<Id>();
        if(TidAndSalesforceIdMap != NULL) {
            for(String id:TidAndSalesforceIdMap.keySet())
            {
                RintinPlanIdList.add(TidAndSalesforceIdMap.get(id));
            }
        }
        List<Rintin_Plan_Details__c> RintinDokoSalonDetailsToDelete = [SELECT id,name from Rintin_Plan_Details__c 
                                                                       where Rintin_Plan__c IN:RintinPlanIdList ];
        delete RintinDokoSalonDetailsToDelete;
        List<Rintin_Plan_Details__c > marketListToInsert = new List<Rintin_Plan_Details__c>();

        system.debug('TidAndMarketListMap'+TidAndMarketListMap);
        system.debug('TidAndSalesforceIdMap'+TidAndSalesforceIdMap);
        if(TidAndMarketListMap != NULL) {
            for(String id:TidAndMarketListMap.keySet())
            {
                if(TidAndMarketListMap.get(id)!=null && (TidAndMarketListMap.get(id).size()>0 || TidAndSalesforceIdMap.keyset().size()>0))
                {
                    List<LorealUploadclass.RintinDokoSalonDetailsInfo> RnDsalondetails  = TidAndMarketListMap.get(id);
                    for(LorealUploadclass.RintinDokoSalonDetailsInfo m : RnDsalondetails)
                    {
                        salonDetails = new Rintin_Plan_Details__c();
                        salonDetails.Rintin_Plan__c = TidAndSalesforceIdMap.get(id)==null?null:TidAndSalesforceIdMap.get(id);
                        if(AccountInternalIdMap != NULL)
                            salonDetails.Retailer_Id__c = AccountInternalIdMap.get(m.Rid)==null?null:AccountInternalIdMap.get(m.Rid); 
                        salonDetails.isActive__c = m.isActive == '1'? true: false;

                        if(m.IsDoko == '1') {
                            salonDetails.IsDoko__c = TRUE;
                        } else {
                            salonDetails.IsRinten__c  = TRUE;
                        }

                        //salonDetails.Name = 'test1';
                        // Until here
                        marketListToInsert.add(salonDetails);
                    }
                }
            }
        }
        system.debug('marketListToInsert line 39'+ marketListToInsert);
        Database.SaveResult[] srList = database.insert(marketListToInsert, FALSE);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    result.add(new PostResponse.PostResponseObject('0',err.getMessage()));                 
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());

                }
            }
        }
        if(result.size()==0)
        {
            result.add(new PostResponse.PostResponseObject('1','Success'));
        }
        return result;

    } 


    public static List<PostResponse.PostResponseObject>  AgentRintinDokoSalonDetailsMethod(Map<String, List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo>> TidAndMarketListMap, Map<String,Id> TidAndSalesforceIdMap, Map<String,Id> AccountInternalIdMap,Map<String,Id> AgentContactInternalIdMap, Map<String,Id> AgentAccountInternalIdMap){

        List<PostResponse.PostResponseObject> result =new List<PostResponse.PostResponseObject>();
        Rintin_Plan_Details__c salonDetails;
        //delete the existing records
        Set<Id> RintinPlanIdList = new Set<Id>();
        if(TidAndSalesforceIdMap != NULL){
            for(String id:TidAndSalesforceIdMap.keySet())
            {
                RintinPlanIdList.add(TidAndSalesforceIdMap.get(id));
            }
        }
        List<Rintin_Plan_Details__c> RintinDokoSalonDetailsToDelete = [select id,name from Rintin_Plan_Details__c 
                                                                       where Rintin_Plan__c IN:RintinPlanIdList and (Hair_Dresser__c!=null or Agent__c != NULL)];
        //delete RintinDokoSalonDetailsToDelete;
        List<Rintin_Plan_Details__c > marketListToInsert = new List<Rintin_Plan_Details__c>();


        system.debug('AgentAccountInternalIdMap' + AgentAccountInternalIdMap );

        if(TidAndMarketListMap != NULL){
            for(String id:TidAndMarketListMap.keySet())
            {
                if(TidAndMarketListMap.get(id)!=null && (TidAndMarketListMap.get(id).size()>0 || TidAndSalesforceIdMap.keyset().size()>0))
                {
                    List<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo> RnDsalondetails  = TidAndMarketListMap.get(id);
                    for(LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo m : RnDsalondetails)
                    {
                        salonDetails = new Rintin_Plan_Details__c();
                        if(TidAndSalesforceIdMap != NULL)
                            salonDetails.Rintin_Plan__c = TidAndSalesforceIdMap.get(id)==null?null:TidAndSalesforceIdMap.get(id);
                        salonDetails.Retailer_Id__c = AccountInternalIdMap.get(m.Rid)==null?null:AccountInternalIdMap.get(m.Rid); 
                        salonDetails.isActive__c = m.isActive == '1'? true: false;
                        salonDetails.Hair_Dresser__c = AgentContactInternalIdMap.get(m.HAId)==null?null:AgentContactInternalIdMap.get(m.HAId);
                        system.debug('agent Id***'+ m.AgentId);
                        system.debug(' map value ' + AgentAccountInternalIdMap.get(m.AgentId));
                        salonDetails.Agent__c = AgentAccountInternalIdMap.get(m.AgentId)==null?null:AgentAccountInternalIdMap.get(m.AgentId);
                        // salonDetails.name = 'test2';
                        // Until here
                        marketListToInsert.add(salonDetails);
                    }
                }
            }
        }
        system.debug('marketListToInsert line 100'+ marketListToInsert);
        Database.SaveResult[] srList = database.insert(marketListToInsert,false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    result.add(new PostResponse.PostResponseObject('0',err.getMessage()));                 
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());

                }
            }
        }
        if(result.size()==0)
        {
            result.add(new PostResponse.PostResponseObject('1','Success'));
        }
        return result;

    }

    public static RExAPIResponseDomain.ResponseInfo objectToRintinPlan(List<Rintin_Plan__c> rintinPlanList, String errorCode){
        RExAPIResponseDomain.ResponseInfo rintinPlanMasterResponse = new RExAPIResponseDomain.ResponseInfo();
        rintinPlanMasterResponse.Master='RintinDokoHeader';
        rintinPlanMasterResponse.Field = new List<String>{'TId', 'PlanId', 'Location', 'Date', 'StartTime', 'EndTime','IsAdhoc','Signature','Brand','Subaxe','IsRinten','TotalPlannedRetailers', 'Sno', 'OrgSalonCode'};
        rintinPlanMasterResponse.ErrorCode  = errorCode == NULL ? '0' : errorCode;
        rintinPlanMasterResponse.Next = '0';
		
        Set<String> salonInternalIdORSoldToSet = new Set<String>();
        Map<String, String> salonInternalIdORSoldToMAP = new Map<String, String>();
        
        //used to holding the list of Rintin Plan records.
        List<List<String>> rintinPlanRecords = new List<List<String>>();

        if(rintinPlanList != NULL) {
            //iterating the list of records which are passing from service class
            for(Rintin_Plan__c rintinPlanRecordList :rintinPlanList ){
                List<String> rPlanListInfo = new List<String>();

                //TId :
                if(rintinPlanRecordList.Tid__c != NULL){
                    rPlanListInfo.add(rintinPlanRecordList.Tid__c);
                }
                else if(rintinPlanRecordList.InternalId__c != NULL) {
                    rPlanListInfo.add(rintinPlanRecordList.InternalId__c);
                }else{
                    rPlanListInfo.add(''); 
                }

                //PlanId :
                if(rintinPlanRecordList.Journey_Plan__r.Tid__c != NULL) {
                    rPlanListInfo.add(rintinPlanRecordList.Journey_Plan__r.Tid__c);
                } else {
                    rPlanListInfo.add(''); 
                }

                //Location :
                if(rintinPlanRecordList.Location__c != NULL) {
                    rPlanListInfo.add(rintinPlanRecordList.Location__c);
                } else {
                    rPlanListInfo.add(''); 
                }

                //Date :
                if(rintinPlanRecordList.Date__c != NULL){
                    // Date d = rintinPlanRecordList.Date__c;
                    Integer d = rintinPlanRecordList.Date__c.day();
                    Integer mo = rintinPlanRecordList.Date__c.month();
                    Integer yr = rintinPlanRecordList.Date__c.year();
                    DateTime dt = DateTime.newInstance(yr, mo, d);

                    rPlanListInfo.add(dt.format('yyyy/MM/dd'));
                }else{
                    rPlanListInfo.add(''); 
                }
                //StartTime :
                rPlanListInfo.add(rintinPlanRecordList.StartTime__c != NULL ? rintinPlanRecordList.StartTime__c:'');
                //EndTime :
                rPlanListInfo.add(rintinPlanRecordList.EndTime__c != NULL ? rintinPlanRecordList.EndTime__c:'');

                // isAdhoc
                rPlanListInfo.add(rintinPlanRecordList.IsAdhoc__c ? '1': '0');

                // Signature
               rPlanListInfo.add( rintinPlanRecordList.SignatureText__c != NULL ? String.valueOf(rintinPlanRecordList.SignatureText__c) : '');

                // Brand
                rPlanListInfo.add( rintinPlanRecordList.BrandText__c != NULL ? String.valueOf(rintinPlanRecordList.BrandText__c) : '');

                // Sub axe
                rPlanListInfo.add(rintinPlanRecordList.SubAxeText__c != NULL ? String.valueOf(rintinPlanRecordList.SubAxeText__c) : '');
                
                // Product
                //rPlanListInfo.add(rintinPlanRecordList.Product_Master__r.ivybase__InternalId__c != NULL ?String.valueOf(rintinPlanRecordList.Product_Master__r.ivybase__InternalId__c) : '');

                // Product
                //rPlanListInfo.add(rintinPlanRecordList.Product__c != NULL &&  rintinPlanRecordList.Product__c != '' ? rintinPlanRecordList.Product__c : '');

                // isRintin
                rPlanListInfo.add(rintinPlanRecordList.IsRinten__c ? '1': '0');
                
                rPlanListInfo.add(rintinPlanRecordList.Total_Planned_Salons_Agents__c != NULL ? String.valueOf(rintinPlanRecordList.Total_Planned_Salons_Agents__c) : '');
                
                // Sno
                rPlanListInfo.add(rintinPlanRecordList.Serial_Number__c != NULL ? rintinPlanRecordList.Serial_Number__c : '');
                
                // OrgSalonCode
                rPlanListInfo.add(rintinPlanRecordList.Org_Salon_Internal_Id__c != NULL ? String.valueOf(rintinPlanRecordList.Org_Salon_Internal_Id__c) : '');
                
                // OrgSalonName
                rPlanListInfo.add(rintinPlanRecordList.Org_Salon_Name__c != NULL ? rintinPlanRecordList.Org_Salon_Name__c : '');
                
                rintinPlanRecords.add(rPlanListInfo);                
            }
        }

        rintinPlanMasterResponse.Data=rintinPlanRecords;

        return rintinPlanMasterResponse;
    }

    public static List<PostResponse.PostResponseObject>  RintinDokoActualsMethod(Map<String, List<LorealUploadclass.RintinDokoVisitHeaderInfo>> TidAndHeaderMap, 
                                                                                 Map<String, Id> TidAndSalesforceIdMap, Map<String, Id> AccountInternalIdMap) 
    {

        List<PostResponse.PostResponseObject> result =new List<PostResponse.PostResponseObject>();

        List<RintinDokoVisitActual__c> actualHeaderList = new List<RintinDokoVisitActual__c>();
        RintinDokoVisitActual__c actualHeader;

        system.debug('TidAndSalesforceIdMap'+TidAndSalesforceIdMap);

        if(TidAndHeaderMap != NULL) {
            for(String tId :TidAndHeaderMap.keySet())
            {
                if(TidAndHeaderMap.get(tId) != NULL && !TidAndHeaderMap.get(tId).isEmpty() && !TidAndSalesforceIdMap.isEmpty())
                {
                    List<LorealUploadclass.RintinDokoVisitHeaderInfo> headerList  = TidAndHeaderMap.get(tId);
                    for(LorealUploadclass.RintinDokoVisitHeaderInfo res : headerList)
                    {
                        actualHeader = new RintinDokoVisitActual__c();
                        actualHeader.Tid__c = res.Tid;
                        actualHeader.Rintin_Plan__c = TidAndSalesforceIdMap.get(res.Visitid) == NULL ? NULL : TidAndSalesforceIdMap.get(res.Visitid);

                        if(AccountInternalIdMap != NULL) 
                            actualHeader.Retailer_Id__c = AccountInternalIdMap.get(res.Rid) == NULL ? NULL : AccountInternalIdMap.get(res.Rid);

                        actualHeader.Attended_Hair_Dressers__c = Decimal.valueOf(res.AttendedHRcount);
                        actualHeader.Total_Hair_Dressers__c = Decimal.valueOf(res.TotalHRcount);
                        actualHeader.Date__c = res.date_x == NULL ? NULL : ConversionUtility.StringToDateConversion(res.date_x);
                        actualHeader.Training_Name__c = res.TrainingName;
                        actualHeader.Total_Salon_Count__c = Integer.ValueOf(res.TotalSalonCount);
                        actualHeader.Attended_Salon_Count__c = Integer.valueOf(res.AttendedSalonCount);
                        if(res.isRinten == '1') {
                           actualheader.Is_Rinten__c = true; 
                        } else if(res.isRinten == '0') {
                             actualheader.Is_Rinten__c = false; 
                        }
                         
                        
                        actualHeaderList.add(actualHeader);
                    }
                }
            }
        }
        system.debug('actualHeaderList'+ actualHeaderList);

        Database.SaveResult[] srList = database.insert(actualHeaderList, FALSE);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    result.add(new PostResponse.PostResponseObject('0', err.getMessage()));                 
                    System.debug('error ->'+err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());

                }
            }
        }

        if(!result.isEmpty())
            result.add(new PostResponse.PostResponseObject('1','Success'));

        return result;

    } 

    public static List<PostResponse.PostResponseObject>  RintinDokoActualsDetailMethod(Map<String, List<LorealUploadclass.RintinDokoVisitDetailInfo>> TidAndHeaderMap, 
                                                                                       Map<String, Id> TidAndSalesforceIdMap, Map<String, Id> AccountInternalIdMap, Map<String, Id> ContactInternalIdMap) 
    {

        List<PostResponse.PostResponseObject> result =new List<PostResponse.PostResponseObject>();

        List<RintinDokoVisitDetail__c> actualDetailList = new List<RintinDokoVisitDetail__c>();
        RintinDokoVisitDetail__c actualDetail;

        system.debug('TidAndSalesforceIdMap'+TidAndSalesforceIdMap);

        if(TidAndHeaderMap != NULL) {
            for(String tId :TidAndHeaderMap.keySet())
            {
                if(TidAndHeaderMap.get(tId) != NULL && !TidAndHeaderMap.get(tId).isEmpty() && !TidAndSalesforceIdMap.isEmpty())
                {
                    for(LorealUploadclass.RintinDokoVisitDetailInfo res : TidAndHeaderMap.get(tId))
                    {
                        actualDetail = new RintinDokoVisitDetail__c();
                        actualDetail.Tid__c = res.Tid;
                        if(string.ISblank(res.HRid)){
                            system.debug('This is for Doko Plan');
                            actualDetail.RintinDokoVisitActual__c = TidAndSalesforceIdMap.get(res.Tid+'.'+res.Agentid) == NULL ? NULL : TidAndSalesforceIdMap.get(res.Tid+'.'+res.Agentid);
                            system.debug('This is for Doko Plan '+ actualDetail.RintinDokoVisitActual__c);
                        }else if(string.isblank(res.Agentid)){
                            system.debug('This is for Rintin Plan');
                            actualDetail.RintinDokoVisitActual__c = TidAndSalesforceIdMap.get(res.Tid+'.'+res.Rid) == NULL ? NULL : TidAndSalesforceIdMap.get(res.Tid+'.'+res.Rid);  
                            system.debug('This is for Rintin Plan '+actualDetail.RintinDokoVisitActual__c);
                        }
                        if(AccountInternalIdMap != NULL) {
                            actualDetail.Retailer_Id__c = AccountInternalIdMap.get(res.Rid) == NULL ? NULL : AccountInternalIdMap.get(res.Rid);
                            actualDetail.Agent__c = AccountInternalIdMap.get(res.Agentid) == NULL ? NULL : AccountInternalIdMap.get(res.Agentid);
                        }
						
                        // ProductTraining
                        if(res.ProductTraining != NULL && res.ProductTraining != '')
                            actualDetail.ProductTraining__c = res.ProductTraining;
                        
                        // BusinessTraining
                        if(res.BusinessTraining != NULL && res.BusinessTraining != '')
                            actualDetail.BusinessTraining__c = res.BusinessTraining; 
                        
                        // BusinessTraining
                        if(res.TechnicalTraining != NULL && res.TechnicalTraining != '')
                            actualDetail.TechnicalTraning__c = res.TechnicalTraining; 
                        
                        actualDetail.Hair_Dresser__c = ContactInternalIdMap.get(res.HRid);
                        actualDetailList.add(actualDetail);
                    }
                }
            }
        }
for(RintinDokoVisitDetail__c actualDetail123:actualDetailList){
                system.debug('actualDetail123 '+actualDetail123);
            }
        Database.SaveResult[] srList = database.insert(actualDetailList, FALSE);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    result.add(new PostResponse.PostResponseObject('0', err.getMessage()));                 
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());

                }
            }
        }

        if(!result.isEmpty())
            result.add(new PostResponse.PostResponseObject('1','Success'));

        return result;
    } 
}