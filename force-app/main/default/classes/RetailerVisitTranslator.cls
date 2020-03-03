public class RetailerVisitTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToJourneyPlanDetail(List<JourneyPlanActivity__c> journeyPlanDetailData, Decimal userid,String errorCode){
        RExAPIResponseDomain.ResponseInfo LastVisitStockMasterResponce = new RExAPIResponseDomain.ResponseInfo();
        LastVisitStockMasterResponce.Master = 'RetailerClientMappingMaster';
        LastVisitStockMasterResponce.Field = new List<String>{'RiD','Date','Userid'};
        LastVisitStockMasterResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        LastVisitStockMasterResponce.Next = '0'; 
        
        List<List<String>> retClientMappingmasterRec = new List<List<String>>();  
        if (journeyPlanDetailData != null && errorCode == null) { 
            
            system.debug('journeyPlanDetailData'+journeyPlanDetailData);
            if(journeyPlanDetailData !=null){
                for(JourneyPlanActivity__c jpd:journeyPlanDetailData){
                    List<String> retClientMapping = new List<String>();
                    
                    if(jpd.Store__c != null){
                        retClientMapping.add(String.valueOf(jpd.Store__r.ivybase__Internal_Id__c)); //CompanyID
                    }else{
                       retClientMapping.add(''); 
                    }
                    if(jpd.Date__c != null){
                        integer d=jpd.Date__c.day();
                      integer mo=jpd.Date__c.month();
                     integer yr=jpd.Date__c.year();
                 	DateTime DT = DateTime.newInstance(yr, mo, d);
                     retClientMapping.add(DT.format('yyyy/MM/dd'));
                        
                    }else{
                       retClientMapping.add(''); 
                    }
                     retClientMapping.add(String.valueOf(userid));
                    retClientMappingmasterRec.add(retClientMapping);
                }
            }
        }
        LastVisitStockMasterResponce.Data = retClientMappingmasterRec;
        
        return LastVisitStockMasterResponce;
    }

}