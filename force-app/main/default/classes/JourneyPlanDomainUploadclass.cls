global class JourneyPlanDomainUploadclass {
     global class MultipleResponseInfo {
    	global Journeyplaninfo[] JourneyPlanHeader;
         global JorneyMarketMarketVisitDetailInfo[] JourneyPlan_MarketVisitDetail;
          global JourneyPlanDetailInfo[] JourneyPlanDetail;     
    }  
    
    global class Journeyplaninfo{
        global string TId;
        global String date_x;
        global String UserId;
        global String Month;
        global String Year;
        global String SupervisorComments;
        global String Status;
    }
    global class JorneyMarketMarketVisitDetailInfo{
        global string TId;
        global String date_x;
        global String RetailerId;
    }
    global class JourneyPlanDetailInfo{
        global string TId;
        global String date_x;
        global String TypeId;
        global String WorkWithUserId;
        global String Comments; // This for testing
       
    }
}