public class KPITranslator {
    public static  RExAPIResponseDomain.multipleResponseInfo TranslateKPIHeaderTOJson(list<KPIWrapper.SellerKPI> KPIList,string errorcode){
        RExAPIResponseDomain.multipleResponseInfo KPIres=new RExAPIResponseDomain.multipleResponseInfo(); 
        KPIres.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        
        try{
            //KPI Header
            RExAPIResponseDomain.ResponseInfo KPIHeaderres= new RExAPIResponseDomain.ResponseInfo();
            KPIHeaderres.Master = 'SellerKPI';
            KPIHeaderres.Field = new List<String> {'KPIId','UserId','FromDate','ToDate','Flex1','Flex2'};
                KPIHeaderres.ErrorCode  = errorCode == null ? '0' : errorCode;
            KPIHeaderres.Next = '0'; 
            List<List<String>> KPIHeaders = new List<List<String>>();
            
            for (KPIWrapper.SellerKPI KPI:KPIList) {
                if(KPI.KPIId!=Null){
                    List<String> KPIheader = new List<String>();
                    KPIheader.add(String.valueOf(KPI.KPIId) != null ? String.valueOf(KPI.KPIId) : '');
                    KPIheader.add(String.valueOf(KPI.UserId) != null ? String.valueOf(KPI.UserId) : '');
                    KPIheader.add(String.valueOf(KPI.FromDate) != null ? String.valueOf(KPI.FromDate) : '');
                    KPIheader.add(String.valueOf(KPI.ToDate) != null ? String.valueOf(KPI.ToDate) : '');
                    KPIheader.add('');
                    KPIheader.add('');
                    
                    KPIHeaders.add(KPIheader);
                }
            }
            KPIHeaderres.data=KPIHeaders;
            KPIres.tables.add(KPIHeaderres);
            
            //KPI data
            
            RExAPIResponseDomain.ResponseInfo KPIDatares= new RExAPIResponseDomain.ResponseInfo();
            KPIDatares.Master = 'SellerKPIDetail';
            KPIDatares.Field = new List<String> {'KPIId','KPIParamName','KPIParamLovId','Target','Achievement','Incentive','Flex1'};
                KPIDatares.ErrorCode  = errorCode == null ? '0' : errorCode;
            KPIDatares.Next = '0'; 
            List<List<String>> KPIDataList = new List<List<String>>();
            
            for (KPIWrapper.SellerKPI KPI:KPIList) {
                if(KPI.slerkpidetail!=Null)
                    for(KPIWrapper.SellerKPIDetail KPIDetail:KPI.slerkpidetail){
                        List<String> KPIData = new List<String>();
                        KPIData.add(String.valueOf(KPIDetail.KPIId) != null ? String.valueOf(KPIDetail.KPIId) : '');
                        KPIData.add(String.valueOf(KPIDetail.KPIParamName) != null ? String.valueOf(KPIDetail.KPIParamName) : '');
                        KPIData.add(String.valueOf(KPIDetail.KPIParamLovId) != null ? String.valueOf(KPIDetail.KPIParamLovId) : '');
                        KPIData.add(String.valueOf(KPIDetail.Target) != null ? String.valueOf(KPIDetail.Target) : '');
                        //KPIDetail.Achievement=(KPIDetail.Achievement!='0')?String.valueOf((Decimal.valueOf(KPIDetail.Achievement))/100):'0';
                        KPIData.add(String.valueOf(KPIDetail.Achievement) != null ? String.valueOf(KPIDetail.Achievement) : '');
                         KPIData.add(String.valueOf(KPIDetail.Incentive) != null ? String.valueOf(KPIDetail.Incentive) : '');
                         KPIData.add('');
                        
                        KPIDataList.add(KPIData);
                    }
            }
            
            KPIDatares.data=KPIDataList;
            KPIres.tables.add(KPIDatares);
            //KPISKUleveldata
            
            //if(KPIList.KpiSkuDetail!=Null)
            RExAPIResponseDomain.ResponseInfo KPISKUDatares= new RExAPIResponseDomain.ResponseInfo();
            KPISKUDatares.Master = 'SellerKPISKUDetail';
            KPISKUDatares.Field = new List<String> {'KPIId','KPIParamName','KPIParamLovId','pid','Target','Achievement','Incentive','Flex1','SubAxeId'};
                KPISKUDatares.ErrorCode  = errorCode == null ? '0' : errorCode;
            KPISKUDatares.Next = '0'; 
            List<List<String>> KPISKUDataList = new List<List<String>>();
            
            for (KPIWrapper.SellerKPI KPI:KPIList) {
                if(KPI.KpiSkuDetail!=Null)
                    for(KPIWrapper.SellerKPISKUDetail KPIDetail:KPI.KpiSkuDetail){
                        List<String> KPISKUData = new List<String>();
                        KPISKUData.add(String.valueOf(KPIDetail.KPIId) != null ? String.valueOf(KPIDetail.KPIId) : '');
                        KPISKUData.add(String.valueOf(KPIDetail.KPIParamName) != null ? String.valueOf(KPIDetail.KPIParamName) : '');
                        KPISKUData.add(String.valueOf(KPIDetail.KPIParamLovId) != null ? String.valueOf(KPIDetail.KPIParamLovId) : '');
                        KPISKUData.add(String.valueOf(KPIDetail.pid) != null ? String.valueOf(KPIDetail.pid) : '');
                        KPISKUData.add('');
                        KPISKUData.add(String.valueOf(KPIDetail.Achievement) != null ? String.valueOf(KPIDetail.Achievement) : '');
                        KPISKUData.add('');
                        KPISKUData.add('');
                         KPISKUData.add(String.valueOf(KPIDetail.SubAxeId) != null ? String.valueOf(KPIDetail.SubAxeId) : '');
                      
                        KPISKUDataList.add(KPISKUData);
                    }
            }
            
            KPISKUDatares.data=KPISKUDataList;
            KPIres.tables.add(KPISKUDatares);
            //KPI SellerMessageBoard
            RExAPIResponseDomain.ResponseInfo KPISellerMessageBoard= new RExAPIResponseDomain.ResponseInfo();
            KPISellerMessageBoard.Master = 'SellerMessageBoard';
            KPISellerMessageBoard.Field = new List<String> {'Userid','Messageid','Message','SuveyCount'};
                KPISellerMessageBoard.ErrorCode  = errorCode == null ? '0' : errorCode;
            KPISellerMessageBoard.Next = '0'; 
            List<List<String>> KPIMessageBoardList = new List<List<String>>();
            
            for (KPIWrapper.SellerKPI KPI:KPIList) {
                if(KPI.KPISellerMessageBoard!=Null)
                    for(KPIWrapper.SellerMessageBoard KPIDetail:KPI.KPISellerMessageBoard){
                        List<String> KPIMessageData = new List<String>();
                        KPIMessageData.add(String.valueOf(KPIDetail.Userid) != null ? String.valueOf(KPIDetail.Userid) : '');
                        KPIMessageData.add(String.valueOf(KPIDetail.Messageid) != null ? String.valueOf(KPIDetail.Messageid) : '');
                        KPIMessageData.add(String.valueOf(KPIDetail.Message) != null ? String.valueOf(KPIDetail.Message) : '');
                        KPIMessageData.add('');
                        
                        KPIMessageBoardList.add(KPIMessageData);
                    }
            }
            
            KPISellerMessageBoard.data=KPIMessageBoardList;
            KPIres.tables.add(KPISellerMessageBoard);
            
        }
        Catch(Exception e){
            system.debug('erromesa'+e.getMessage());
        }
        
        
        return KPIres;
    }
    
}