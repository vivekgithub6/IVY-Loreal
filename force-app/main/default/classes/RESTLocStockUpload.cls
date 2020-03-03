@RestResource(urlMapping = '/v1/LocStockUpload/')
global class RESTLocStockUpload {

    global class LocStock {
        global cls_ClosingStockHeader[] ClosingStockHeader;
        global cls_ClosingStockDetail[] ClosingStockDetail;
    }
    global class cls_ClosingStockHeader {
        public String longitude;  //0
        public String RetailerID;   //44
        public String latitude;  //0
        public String StockID;   //106302017154832
        public String remark; //
        public String Date_x;  //2017/06/30
        public String DistributorID;    //0
        public String Menucode;
    }
    global class cls_ClosingStockDetail {
        public String Shelfpqty;  //0
        public String ouomqty;   //0
        public String Facing;  //0
        public String uomqty;   //324
        public String LocId; //524
        public String ProductID;  //10064
        public String ouomid;    //827
        public String whpqty;  //0
        public String PcsUOMId;   //826
        public String whoqty;  //0
        public String StockID;   //106302017154832
        public String msqqty; //0
        public String shelfoqty;  //0
        public String isListed;    //0
        public String Shelfcqty;  //76
        public String IsOwn;   //1
        public String uomid;  //828
        public String ReasonID;   //0
        public String isDistributed; //0
        public String whcqty;  //0  
        public String isAvailable;
        public String catLovID;
    }
    @HTTPPost
    global static void LocStockUpload() {
        RestRequest req = RestContext.request;
         if (req != null) {
             Blob requestBody = req.requestBody;
             String requestStr = requestBody.toString();
             LocStock ls = (LocStock)JSON.deserialize(requestStr, LocStock.class);
             Map<String, Integer> ridMap = new Map<String, Integer>();
             Map<String, Date> stockDateMap = new Map<String, Date>();
             for(cls_ClosingStockHeader csh : ls.ClosingStockHeader) {
                 ridMap.put(csh.StockID, Integer.valueOf(csh.RetailerID));
                 stockDateMap.put(csh.StockID, convertStringToDate(csh.Date_x));
             }
             
             List<ivybase__Visit_Detail__c> visitDetailList = [SELECT  ivybase__Visit__c, ivybase__Visit__r.ivybase__Visit_Date__c,
                                                                       ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c
                                                               FROM ivybase__Visit_Detail__c 
                                                               WHERE ivybase__ModuleCode__c = 'MENU_STOCK'];
             
             Map<Integer, Map<Date, String>> retailerDateVisitMap = new Map<Integer, Map<Date, String>>();
             
             for(ivybase__Visit_Detail__c visitDetail :visitDetailList) {
                 
                 if(retailerDateVisitMap.containsKey(Integer.valueOf(visitDetail.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c))) {
                     
                     retailerDateVisitMap.get(Integer.valueOf(visitDetail.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c)).put(visitDetail.ivybase__Visit__r.ivybase__Visit_Date__c, visitDetail.ivybase__Visit__c);
                 }
                 else {
                     
                     Map<Date, String> DateVisitMap = new Map<Date, String>();
                     DateVisitMap.put(visitDetail.ivybase__Visit__r.ivybase__Visit_Date__c, visitDetail.ivybase__Visit__c);
                     retailerDateVisitMap.put(Integer.valueOf(visitDetail.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c), DateVisitMap);
                 }
             }
             
             Map<String, Id> locIdMap = new Map<String, Id>();
             for(ivybase__Location__c loc : [SELECT Id, ivybase__Belongs_To__r.ivybase__Internal_Id__c FROM ivybase__Location__c
                                             WHERE ivybase__Belongs_To__r.ivybase__Internal_Id__c IN :ridMap.values()]){
                                                 locIdMap.put(''+loc.ivybase__Belongs_To__r.ivybase__Internal_Id__c, loc.Id);
                                             }
             Map<String, Id> prodIdMap = new Map<String, Id>();
             for(ivybase__Product__c prod : [SELECT Id, Name, ivybase__InternalId__c FROM ivybase__Product__c]) {
                 prodIdMap.put(''+prod.ivybase__InternalId__c, prod.Id);
             }
             List<ivybase__Location_Stock__c> locStockList = new List<ivybase__Location_Stock__c>();
             for(cls_ClosingStockDetail csd : ls.ClosingStockDetail) {
                 ivybase__Location_Stock__c locStk = new ivybase__Location_Stock__c();
                 locStk.ivybase__Product__c = String.isNotBlank(csd.ProductID) == true 
                     && prodIdMap.containsKey(csd.ProductID) == true?
                     prodIdMap.get(csd.ProductID) : null;
                 locStk.ivybase__Location__c = String.isNotBlank(csd.StockID) == true && 
                     locIdMap.containsKey(String.valueOf(ridMap.get(csd.StockID))) == true ? 
                     locIdMap.get(String.valueOf(ridMap.get(csd.StockID))) : null;
                 locStk.ivybase__UOM1__c = Integer.valueOf(csd.Shelfpqty);
                 
                 if(String.isNotBlank(csd.StockID) == true && ridMap.containsKey(csd.StockID) &&
                    retailerDateVisitMap.containsKey(ridMap.get(csd.StockID)) &&
                    retailerDateVisitMap.get(ridMap.get(csd.StockID)).containsKey(stockDateMap.get(csd.StockID))) {
                     
                     locStk.ivybase__Visit__c = retailerDateVisitMap.get(ridMap.get(csd.StockID)).get(stockDateMap.get(csd.StockID));
                 }
                                            
                 locStockList.add(locStk);
             }
             if(locStockList != null && locStockList.isEmpty() == false) {
                 insert locStockList;
             }
         }
    }
    global static Date convertStringToDate(String datestr){
        
        Date dateVal;
        List<String> dateList = datestr.split('/');
        dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
        return dateVal;
    }
}