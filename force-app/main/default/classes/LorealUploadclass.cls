global class LorealUploadclass {

    global class MultipleResponseInfo {
    
        global Journeyplaninfo[] JourneyPlanHeader;
        global JorneyMarketMarketVisitDetailInfo[] JourneyPlan_MarketVisitDetail;
        global JourneyPlanDetailInfo[] JourneyPlanDetail; 
        
        global CompetitorHeaderInfo[] CompetitorHeaderNew;
        global CompetitorDetailsInfo[] CompetitorDetailsNew;
        global CompetitorPhotoDetailsInfo[] CompetitorPhotoDetailsNew;
        
        global PromotionalPlanninginfo[] PromotionalPlanningHeader;
        global PromotionalPlanningDetail[] PromotionalPlanningDetails;
        
        global DreamListInfo[] RetailerDreamList;
        
        global OrderHeader[] OrderHeaderNew;
        global OrderDetail[] OrderDetailNew;
        global SchemeDetail[] SchemeDetailNew;
        global SchemeFreeProductDetail[] SchemeFreeProductDetailNew;
        //Added By VEER : 9/26/19 : to incorporate PackageDetails
        global OrderPackageDetail[] OrderPackageDetailNew;
        
        //global DocumentDetailInfo[] DocumentDetail;
        
        global NewRetailerEditHeaderInfo[] NewRetailerEditHeader;
        global NewRetailerEditDetailInfo[] NewRetailerEditDetail;
        
        global HairdresserInfo[] HairDresserNew;
        
        global cls_OutletTimestamp[] OutletTimestamp;
        global cls_OutletTimeStampDetail[] OutletTimeStampDetail;
        global cls_Nonproductivereasonmaster[] Nonproductivereasonmaster;    
        
        global NewSalesReturnHeader[] SalesReturnHeader;
        global NewSalesReturnDetails[] SalesReturnDetails;
        
        /* Variables to capture Rintin and Doko */
        global RintinDokoHeaderInfo[] RintinDokoHeader;
        global RintinDokoSalonDetailsInfo[] RintinDokoSalonDetails;
        global RintinDokoHairdresserAndAgentDetailsInfo[] RintinDokoHairdresserAndAgentDetails;
        
        global AnswerDetail[] AnswerDetailNew;
        global AnswerHeader[] AnswerHeaderNew;
        //global AnswerImageDetail[] AnswerImageDetailNew;
        
        global DigitalContentTrainingDetaildata[] DigitalContentTrainingDetail;
        
        global RintinDokoVisitHeaderInfo[] RintinDokoVisitHeader;
        global RintinDokoVisitDetailInfo[] RintinDokoVisitDetail;
        
        global AdhocActivityPlanDetailInfo[] AdhocActivityPlanDetail; // This is only for japan.
          
    } 
    
    // AdhocActivityPlanDetail This is for Japan only
    global class AdhocActivityPlanDetailInfo {
        
        global String TId;
        global String ActivityDate;
        global String TypeId; // LOVId
        global String Comment;
        global String StartTime;
        global String EndTime;
        global String PlanName;
        global String UserId;
        global String HourSpent; // Format 01:30 Hours
        
    }
    
    // RintinDokoVisitHeader
    global class RintinDokoVisitHeaderInfo {
        global String  Tid;
        global String  Rid;
        global String  Date_x;
        global String  TotalHRcount;
        global String  AttendedHRcount;
        global String  Visitid;
        global String TrainingName;
        global String TotalSalonCount;
        global String AttendedSalonCount;
        global String isRinten;
    }
    
    global class RintinDokoVisitDetailInfo {
        global String  Tid;
        global String  Rid;
        global String  HRid;
        global String  Agentid;
        global String  ProductTraining;
        global String  BusinessTraining;
        global String  TechnicalTraining;
    }
    
    /* digital content training  data upload detail*/
    global class DigitalContentTrainingDetaildata{
        global String  imgid;
        global String  GroupId;
        global String  DivisionId;
        global String  Date_x;
        global String  NoOfTimesOpened;
        global String  Duration;
        global String  DocumentType;
        global String  RetailerID;
        global String  MenuCode;
    
    }
    
    /* Wrapper class for RintinDokoHeader*/
    global Class RintinDokoHeaderInfo{
        
        global String TId;
        global String PlanId;
        global String Location;
        global String date_x;
        global String StartTime;
        global String EndTime;
        global String IsAdhoc;
        global String Signature;
        global String Brand;
        global String SubAxe;
        //global String ProductHierarchy;
        global string IsRinten;
        global String TotalPlannedRetailers;
        global string Sno;
        global String OrgSalonCode;
        global String OrgSalonName;
    }
    
    /* Wrapper class for RintinDokoSalonDetails */
    global Class RintinDokoSalonDetailsInfo{
        
        global String TId;
        global String Rid;
        global String isActive;
        global String IsDoko;
    }
    
    /* Wrapper class for RintinDokoHairdresserAndAgentDetails */
    global Class RintinDokoHairdresserAndAgentDetailsInfo{
        
        global String TId;
        global String Rid;
        global String HAId;
        global String AgentId;
        global String isActive;
    }
    
    /* Class for Survey  */
    global class AnswerHeader{
        global String uid;  //217169502152017101126
        global String AchBonusPoint;    //0
        global String ModuleID; //4949
        global String type; //RETAILER
        global String MaxBonusPoint;    //0
        global String date_x; //2017/02/15
        global String surveyid; //217
        global String DistributorID;    //245
        global String tgtScore; //0
        global String SupervisiorId;    //0
        global String achScore; //0
        global String counterid;    //0
        global String Remark;   //N
        global String retailerid;   //151718
        global String refid;    //
        global String VisitId;//SFDC-927
        global String ImagePath;
        global String DivisionId;
        global String userid; // TO capture hair dresser details
    }
    
    /* Class for Surveys */
    global class AnswerDetail{
        global String score;    //0
        global String uid;  //217169502152017101126
        global String answer;   //
        global String ImageName; //
        
        global String qid;  //403
        global String answerid; //441
        global String isExcluded;   //0
        global String qtype;    //5138
    }
    
    /* Class for Survey */
    /*global class AnswerImageDetail {
        global String Qid;  //80
        global String Uid;  //28107122017152015
        global String imgName; //"\/Survey\/20170712\/1\/SVY_44_28_80_07122017152005.jpg"
        global String ImagePath;  
    }*/
    
    
    global class NewSalesReturnHeader{
        global string Tid;
        global string ReturnDate;
        global string RetailerID;
        global string RetailerCode;
        global string UserID;
        global string NoOflineItem;
        global string ReturnValue;
        global string remark;
        global string note;
        global string invoiceid;
        global string SignaturePath;
        global string DivisionId;
        global string Status;
        global string ReasonId;
        global string ReasonTypeId;
        global string BIllTo;
        global string ShipTo;
    }
    
    global class NewSalesReturnDetails{
        global string Tid;
        global string ProductID;
        global string batchid;
        global string Pqty;
        global string Srp;
        global string InvoicePrice;
        global string totalamount;
        global string ListPrice;

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
        global String StartTime;
        global String EndTime;
        global String VisitType;
    }
    global class JourneyPlanDetailInfo{
        global string TId;
        global String date_x;
        global String TypeId;
        global String WorkWithUserId;
        global String Comments; // This for testing    
    	global String StartTime;
        global String EndTime;
    }
    global class CompetitorHeaderInfo{
        global String Tid;
        global String RetailerId;
        global String Feedback;
        global String Date_x;
        global String Remark;        
    }
    global class CompetitorDetailsInfo{
        global String Tid;
        global String tcompetitorid;
        global String pid;
        global String qty;
        global String qtysize;
        global String avgPrice;
        global String RetailPrice;
        global String Comments;
        global String contract;
        global String Rebate;
        global String FrqOfRepVisit;
        global String FrqOfEduVisit;
        global String NoOfTraining;
        global String TypeOfTraining;   
    }
    global class CompetitorPhotoDetailsInfo{
        global String Tid;
        global String tcompetitorid;
        global String Name;
        global String Description;
        global String qty;
        global String qtysize;
        global String avgPrice;
        global String SellingPrice;
        global String ImageName;
        global String ImagePath;
    }
    global class PromotionalPlanninginfo{
        global String TId;
        global String Date_x;
        global String Status;
        global String UserId; 
        global String SupervisorComments;
        global String DivisionId;
    }
    global class PromotionalPlanningDetail{
        global String TId;
        global String SchemeId;
        global String RetailerId;
        global String pid; 
        global String Value; 
        global String Qty;
    }
    global class DreamListInfo{
        global string Rid;
        global string ProgressPercentage;
        global string status;
        global string Remarks;
        global string SuperWiserFeedBack;
        global string Upload;
        global string Date_x;
        global string IsConquest;
    }
        
    global class OrderHeader{
        
        public string OrderID;
        public string OrderDate;
        public string RetailerId;
        public string RouteId;
        public string OrderValue;
        public string LinesPerCall;
        public string discount;
        public string deliveryDate;                  
        public string downloadDate;
        public string po;
        public string remark;
        public string latitude;
        public string longitude;
        public string timestampid;
        public string JFlag;
        public string ReturnValue;
        public string sid;
        public string stype;
        public string totalTaxValue;
        public string ImageName;
        public string totalWeight;
        public string BIllTo;
        public string ShipTo;
        public string PayerCode;
        public string Tax;
        public string HandlingCharges;
        public string Notes;
        public string SignatureImagePath;
        public string Status;   
        global string DivisionId;
    }
        
    global class OrderDetail{
    
        public string OrderId;
        public string ProductId;
        public string Qty;
        public string Rate;
        public string uomcount;
        public string pieceQty;
        public string caseqty;
        public string uomid;
        public string totalamount;
        public string d1;
        public string d2;
        public string d3;
        public string DA;
        public string outerQty;
        public string douomQty;
        public string douomid;
        public string OrderType;
        public string casePrice;
        public string outerPrice;
        public string PcsUomId;
        public string isFreeProduct;
        public string BatchId;
        public string lineItemNumber;
        public string Sequence;
        global string DivisionId;
        global String AnimationCode;
        global String AnimationPrice;
        
    }
        
    global class SchemeDetail{
        public string OrderID;  
        public string InvoiceID; 
        public string SchemeID; 
        public string ProductID;
        public string SchemeType; 
        public string Value; 
        public string parentid; 
        public string SchemeDetailNew; 
        public string RetailerId; 
        public string distributorid; 
        public string Amount;
        public string noOfPromo;
        global string DivisionId;
    }
    global class SchemeFreeProductDetail{
        public string OrderID;  
        public string InvoiceID; 
        public string SchemeID; 
        public string FreeProductID;
        public string FreeQty;  
        public string UomID; 
        public string UomCount; 
        public string BatchId; 
        public string parentid;
        public string TaxAmount;
        public string Price;
        global string DivisionId;
    } 
        global class OrderPackageDetail {
        public String OrderId;  
        public String Pid; 
        public String Bpid;
        public String NoOfPackage;
        public String Mqty;
        public String orderpiece;  
        public String RetailerId; 
        public String DivisionId; 
        public String PackageType;
        
    }
        
        
    global class NewRetailerEditHeaderInfo{
        public String  Tid;
        public String RetailerId;
        public String Date_x;
        public String isNew;
      
    }
    global class NewRetailerEditDetailInfo{
        public String Tid;
        public String Code;
        public String Value;
        public String RefId;
        public String RetailerId;
    }
        
      /*  global class DocumentDetailInfo{
            public String Rid;
            public String DocumentCode;
            public String DocumentName;
            public String Availability;
        }*/
    global class HairDresserInfo{
       global String Tid;
       global string Date_x;
       global String RetailerId;
       global String MobileNo;
       global String EmailId;
       global String HairdresserId;
       global String HairdresserName;  
       global String IsExisting;
       global String Signature;
       global String Privacy;
       global String SocialMediaId;
       global String Hairdressercode;  
    }
    
    global class cls_Nonproductivereasonmaster {
        public String UID;  //0295202202017170006696
        public String retailerid;   //203552
        public String RouteID;  //1277
        public String Date_x;   //2017/02/20
        public String ReasonID; //14184
        public String ReasonTypes;  //14058
        public String DistributorID;    //0
    }
    
    global class cls_OutletTimestamp {
        public String VisitID;  //OTS02202017165618
        public String BeatID;   //1277
        public String VisitDate;    //2017/02/20
        public String RetailerID;   //203552
        public String TimeIn;   //2017/02/20 16:56:18
        public String TimeOut;  //2017/02/20 16:56:59
        public String latitude; //0.0
        public String longitude;    //0.0
        public String JFlag;    //0
        public String gpsAccuracy;  //0.0
        public String gpsDistance;  //-1.0
        public String gpsCompliance;    //0
        public String Sequence; //1
        public String Feedback; //
        public String DistributorID;    //0
    }
    
    global class cls_OutletTimeStampDetail {
        public String UID;  //OTS02202017165618
        public String ModuleCode;   //MENU_ASSET
        public String TimeIn;   //2017/02/20 16:56:24
        public String TimeOut;  //2017/02/20 16:56:45
        public String RetailerID;   //203552
    }
}