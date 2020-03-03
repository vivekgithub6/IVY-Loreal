public class KPIWrapper {
    public class SellerKPI{
        public string KPIId;
        public string UserId;
        public string FromDate;
        public string ToDate;
        public string Flex1;
        public string Flex2;
        public list<SellerKPIDetail> slerkpidetail;
        public list<SellerKPISKUDetail> KpiSkuDetail;
        public list<SellerMessageBoard> KPISellerMessageBoard;
    }
    public class SellerKPIDetail{
        public string  KPIId;
        public string KPIParamName;
        public string KPIParamLovId;
        public string Target;
        public string Achievement;
        public string Incentive;
        public string Flex1;
    }
    public class SellerKPISKUDetail{
        public string   KPIId;
        public string  KPIParamLovId;
        public string  KPIParamName;
        public string pid;       
        public string  Target;
        public string  Achievement;
        public string  Incentive;
        public string  Flex1;
        public string SubAxeId;
    }
    public class SellerMessageBoard{
        public string   Userid;
        public string Messageid;
        public string Message;
        public string SuveyCount;  
    }
}