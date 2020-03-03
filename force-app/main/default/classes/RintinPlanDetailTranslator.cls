public class RintinPlanDetailTranslator {
    
    public static RExAPIResponseDomain.ResponseInfo translateSalonDetails(List<Rintin_Plan_Details__c> rintinSalonDetails, String errorCode){
        RExAPIResponseDomain.ResponseInfo salonDetailsMasterResponse = new RExAPIResponseDomain.ResponseInfo();
        salonDetailsMasterResponse.Master = 'RintinDokoSalonDetails';
        salonDetailsMasterResponse.Field = new List<String>{'TId', 'Rid', 'isActive', 'IsDoko'};
            salonDetailsMasterResponse.ErrorCode  = errorCode == NULL ? '0' : errorCode;
        salonDetailsMasterResponse.Next = '0';
        
        List<List<String>> salonDetailsRecords = new List<List<String>>();
        List<String> rpdList;
        
        if(rintinSalonDetails != NULL && errorCode == NULL){
            
            for(Rintin_Plan_Details__c rpd : rintinSalonDetails){
                rpdList = new List<String>();
                //TId :
                if(rpd.Rintin_Plan__r.Tid__c != NULL)
                    rpdList.add(String.valueOf(rpd.Rintin_Plan__r.Tid__c));
                else if(rpd.Rintin_Plan__r.InternalId__c != NULL)
                    rpdList.add(String.valueOf(rpd.Rintin_Plan__r.InternalId__c));
                else
                    rpdList.add('');
                
                //Rid :
                if(rpd.Retailer_Id__c != NULL)
                    rpdList.add(String.valueOf(rpd.Retailer_Id__r.ivybase__Internal_Id__c));
                else
                    rpdList.add('');
                
                //isActive :
                if(rpd.isActive__c)
                    rpdList.add('1');
                else
                    rpdList.add('0');
                
                //IsDoko :
                if(rpd.isDoko__c)
                    rpdList.add('1');
                else
                    rpdList.add('0');
                
                salonDetailsRecords.add(rpdList);
            }
        }
        salonDetailsMasterResponse.Data = salonDetailsRecords;
        return salonDetailsMasterResponse;
    }
    public static RExAPIResponseDomain.ResponseInfo translateHairDresserDetails(List<Rintin_Plan_Details__c> hairDresserDetails, String errorCode){
        RExAPIResponseDomain.ResponseInfo hairDresserMasterResponse = new RExAPIResponseDomain.ResponseInfo();
        hairDresserMasterResponse.Master = 'RintinDokoHairdresserAndAgentDetails';
        hairDresserMasterResponse.Field = new List<String>{'TId', 'Rid', 'HId','AgentId','isActive'};
            hairDresserMasterResponse.ErrorCode  = errorCode == NULL ? '0' : errorCode;
        hairDresserMasterResponse.Next = '0';
        
        List<List<String>> hairDresserRecords = new List<List<String>>();
        List<String> rpdList;
        
        if(hairDresserDetails != NULL && errorCode == NULL){
            
            for(Rintin_Plan_Details__c rpd : hairDresserDetails){
                rpdList = new List<String>();
                //TId :
                if(rpd.Rintin_Plan__r.Tid__c != NULL)
                    rpdList.add(String.valueOf(rpd.Rintin_Plan__r.Tid__c));
                
                else if(rpd.Rintin_Plan__r.InternalId__c != NULL)
                    rpdList.add(String.valueOf(rpd.Rintin_Plan__r.InternalId__c));
                
                else
                    rpdList.add('');
                
                //Rid :
                if(rpd.Retailer_Id__c != NULL)
                    rpdList.add(String.valueOf(rpd.Retailer_Id__r.ivybase__Internal_Id__c));
                else
                    rpdList.add('');
                
                //HAId :
                if(rpd.Hair_Dresser__c != NULL && rpd.Hair_Dresser__r.Internal_Id__c != NULL)
                    rpdList.add(String.valueOf(rpd.Hair_Dresser__r.Internal_Id__c));
                else
                    rpdList.add('');
                
                //AgentId
                if(rpd.Agent__c != NULL){
                    rpdList.add(String.valueOf(rpd.Agent__r.ivybase__Internal_Id__c));
                } else {
                    rpdList.add('');
                }
                
                
                //isActive :
                if(rpd.isActive__c)
                    rpdList.add('1');
                else
                    rpdList.add('0');
                
                hairDresserRecords.add(rpdList);
            }
        }
        hairDresserMasterResponse.Data = hairDresserRecords;
        return hairDresserMasterResponse;
    }
    
    public static RExAPIResponseDomain.ResponseInfo translateRetailerRDVisitMapping(List<Rintin_Plan__c> retailerRDVisitMappings, Map<String, String> visitLovIdMap, String errorCode){
        RExAPIResponseDomain.ResponseInfo retailerRDVisitMappingResponse = new RExAPIResponseDomain.ResponseInfo();
        retailerRDVisitMappingResponse.Master = 'RetailerRDVisitMappingMaster';
        retailerRDVisitMappingResponse.Field = new List<String>{'Rid', 'Date', 'VisitTypeId', 'isActive', 'AgentId', 
            'Visitid'};
                retailerRDVisitMappingResponse.ErrorCode  = errorCode == NULL ? '0' : errorCode;
        retailerRDVisitMappingResponse.Next = '0';
        
        
        List<List<String>> retailerRDVisitRecords = new List<List<String>>();
        List<String> rpdList;
        
        if(retailerRDVisitMappings != NULL && errorCode == NULL){
            
            for (Rintin_Plan__c rp : retailerRDVisitMappings) {
                if (!rp.Rintin_Plan_Details__r.isEmpty()) {
                    for(Rintin_Plan_Details__c rpd : rp.Rintin_Plan_Details__r){
                        rpdList = new List<String>();
                        
                        //Rid :
                        if(rpd.Retailer_Id__c != NULL)
                            rpdList.add(String.valueOf(rpd.Retailer_Id__r.ivybase__Internal_Id__c));
                        else
                            rpdList.add('');
                        
                        //Date :
                        if(rpd.Rintin_Plan__r.Date__c != NULL){
                            DateTime dt = DateTime.newInstance(rpd.Rintin_Plan__r.Date__c.year(), rpd.Rintin_Plan__r.Date__c.month(), rpd.Rintin_Plan__r.Date__c.day());
                            rpdList.add(dt.format('yyyy/MM/dd'));
                        } else 
                            rpdList.add(System.NOW().format('yyyy/MM/dd'));
                        
                        //VisitTypeId :
                        if(visitLovIdMap != NULL && rpd.isDoko__c && visitLovIdMap.containskey('VISIT_DOKO') 
                           && visitLovIdMap.get('VISIT_DOKO') != NULL)
                            rpdList.add(visitLovIdMap.get('VISIT_DOKO'));
                        else if (visitLovIdMap != NULL && !rpd.isDoko__c && visitLovIdMap.containskey('VISIT_RINTEN') 
                                 && visitLovIdMap.get('VISIT_RINTEN') != NULL)
                            rpdList.add(visitLovIdMap.get('VISIT_RINTEN'));
                        else
                            rpdList.add('');
                        
                        //isActive :
                        if(rpd.isActive__c)
                            rpdList.add('1');
                        else
                            rpdList.add('0');
                        
                        //AgentId
                        if(rpd.Agent__c != NULL)
                            rpdList.add(String.valueOf(rpd.Agent__r.ivybase__Internal_Id__c));
                        else
                            rpdList.add('');
                        
                        //Visitid :
                        if(rpd.Rintin_Plan__c != NULL)
                            rpdList.add(String.valueOf(rpd.Rintin_Plan__r.TId__c));
                        else
                            rpdList.add('');
                        
                        retailerRDVisitRecords.add(rpdList);
                    } 
                } else {
                    rpdList = new List<String>();
                    
                    //Rid :
                    rpdList.add('0');
                    
                    //Date :
                    if(rp.Date__c != NULL){
                        DateTime dt = DateTime.newInstance(rp.Date__c.year(), rp.Date__c.month(), rp.Date__c.day());
                        rpdList.add(dt.format('yyyy/MM/dd'));
                    } else 
                        rpdList.add(System.NOW().format('yyyy/MM/dd'));
                    
                    //VisitTypeId :
                    if(visitLovIdMap != NULL && !rp.IsRinten__c && visitLovIdMap.containskey('VISIT_DOKO') 
                       && visitLovIdMap.get('VISIT_DOKO') != NULL)
                        rpdList.add(visitLovIdMap.get('VISIT_DOKO'));
                    else if (visitLovIdMap != NULL && rp.IsRinten__c && visitLovIdMap.containskey('VISIT_RINTEN') 
                             && visitLovIdMap.get('VISIT_RINTEN') != NULL)
                        rpdList.add(visitLovIdMap.get('VISIT_RINTEN'));
                    else
                        rpdList.add('');
                    
                    //isActive :
                    rpdList.add('0');
                    
                    //AgentId
                    rpdList.add('0');
                    
                    //Visitid :
                    if(rp.TId__c != NULL)
                        rpdList.add(String.valueOf(rp.TId__c));
                    else
                        rpdList.add('');
                    
                    retailerRDVisitRecords.add(rpdList);
                }
            }
        }
        retailerRDVisitMappingResponse.Data = retailerRDVisitRecords;
        return retailerRDVisitMappingResponse;
    }
}