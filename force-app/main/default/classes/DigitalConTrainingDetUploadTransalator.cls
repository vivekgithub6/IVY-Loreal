/*
 * capturing all the data related to digital content how many times it opened
 */
public class DigitalConTrainingDetUploadTransalator
{
    public static  void translateDigitalContentTrainingDetail(List<LorealUploadclass.DigitalContentTrainingDetaildata> DigitalContentTrainingDetaildata)
    {
        Map<string,string> DigitalContentInternalIDvsID = new Map<string,string>();//getting id,internalid map of digtal content
        set<string> imageids= new set<string>();
        set<String> retailerIdSet =  new set<String>();
        set<string> GroupDivisionIDSet = new set<string>();// groupid & divisionId
        //outer if starts
        if(DigitalContentTrainingDetaildata!=null && DigitalContentTrainingDetaildata.size()>0){
            for(LorealUploadclass.DigitalContentTrainingDetaildata Dcdata : DigitalContentTrainingDetaildata ){
                if(string.isblank(Dcdata.imgid)==false){
                    imageids.add(Dcdata.imgid);
                }
                if(String.isEmpty(Dcdata.RetailerID) == false){
                    retailerIdSet.add(String.valueOf(Dcdata.RetailerID));
                }
                if(String.isEmpty(Dcdata.GroupId) == false){
                    GroupDivisionIDSet.add(String.valueOf(Dcdata.GroupId));
                }
                if(String.isEmpty(Dcdata.DivisionId) == false){
                    GroupDivisionIDSet.add(String.valueOf(Dcdata.DivisionId));
                }
            }

            if(imageids.size()>0){
                DigitalContentInternalIDvsID = DigitalContentMappingService.getAllContentData(imageids);  //image id data
            }

            //getting acountids
            Map<String,Account> internalIdWithAccountMap  = new Map<String,Account>();
            if(retailerIdSet.size()>0){
                internalIdWithAccountMap = AccountService.getAccountByInternalId(retailerIdSet);//getting acountids
            }

            //gettng data related to standard list master and storing in different maps  based on the data shared through Upload
            List<ivybase__Standard_List_Master__c> StandardListMaster_List = [select id,name,ivybase__List_Name__c,ivybase__List_Type__c from ivybase__Standard_List_Master__c where name=:GroupDivisionIDSet]; 
            //map<listtype,record id of realted standard list master>
            Map<String,Id> GroupIdStldMap = new Map<String,Id>();
            Map<String,string> DivisionStldMap = new Map<String,Id>(); 
            for(ivybase__Standard_List_Master__c rec:StandardListMaster_List)
            {
                if(rec.ivybase__List_Type__c!='DIVISION_TYPE'){
                    GroupIdStldMap.put(rec.Name,rec.Id);
                }else{
                    DivisionStldMap.put(rec.Name,rec.ivybase__List_Name__c);
                }

            }
            Map<string,String> divnameDivIdMap =Resourceservice.GetAllResourceDivisionNameIdmap();//getting division IDs of rep
            //starts records inserting here
            list<Digital_Content_Training_Detail__c> insertdata = new list<Digital_Content_Training_Detail__c>();
            for(LorealUploadclass.DigitalContentTrainingDetaildata  digitaldata: DigitalContentTrainingDetaildata){
                // new instance creating here
                Date returndate;
                if(String.isEmpty(digitaldata.date_x) == false){
                    returndate = (digitaldata.date_x.trim() != '') ? ConversionUtility.StringToDateConversion(digitaldata.date_x):null;
                }
                String retailerId = (String.isEmpty(digitaldata.RetailerId) == false) ? String.valueOf(digitaldata.RetailerId):'';
                Digital_Content_Training_Detail__c dctd = new Digital_Content_Training_Detail__c();
                dctd.Digital_Content__c = DigitalContentInternalIDvsID.containskey(digitaldata.imgid) ? DigitalContentInternalIDvsID.get(digitaldata.imgid) : dctd.Digital_Content__c ;//image id 
                dctd.Standard_List_Master__c=GroupIdStldMap.containskey(digitaldata.GroupId) ? GroupIdStldMap.get(digitaldata.GroupId) : dctd.Standard_List_Master__c; //Group Id
                if(DivisionStldMap!=null && DivisionStldMap.containskey(digitaldata.DivisionId) && divnameDivIdMap!=null && divnameDivIdMap.containskey(DivisionStldMap.get(digitaldata.DivisionId)) && divnameDivIdMap.get(DivisionStldMap.get(digitaldata.DivisionId))!=null ){
                    dctd.Division__c=divnameDivIdMap.get(DivisionStldMap.get(digitaldata.DivisionId));
                }//division id
                dctd.Date__c = returndate!=null ? returndate : dctd.Date__c; //date
                dctd.No_Of_Times_Opened__c=(String.isEmpty(digitaldata.NoOfTimesOpened) == false ? ConversionUtility.StringToInteger(digitaldata.NoOfTimesOpened):0); //NoOfTimesOpened
                dctd.Duration__c=(String.isEmpty(digitaldata.Duration) == false ? ConversionUtility.StringToDecimal(digitaldata.Duration):0);//duration
                //document type missed
                dctd.Salon__c=(internalIdWithAccountMap.containsKey(retailerId ) ? internalIdWithAccountMap.get(retailerId).Id : dctd.Salon__c);//store
                insertdata.add(dctd);
            }

            if(insertdata.size()>0){
                List<String> Digitaldatadetail = new List<String> {'Digital_Content__c', 'Date__c','No_Of_Times_Opened__c'};
                if (SecurityUtility.checkIsCreateable('Digital_Content_Training_Detail__c', Digitaldatadetail)) {
                    System.debug('Query:Main return update');
                    insert insertdata;
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
            }
        } ///outer if ends here
    }
}