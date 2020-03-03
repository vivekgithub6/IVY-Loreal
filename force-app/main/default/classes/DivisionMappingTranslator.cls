public class DivisionMappingTranslator {
    public static RExAPIResponseDomain.ResponseInfo TranslateStoreDivToJson(List<StoreDivisionMapping__c> storeDivRecords,string errorcode){
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        RExAPIResponseDomain.ResponseInfo RetailerDivisionResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerDivisionResponce.Master = 'RetailerDivisionMapping';
        if(resource.Market_ISO__c=='JPN')
        RetailerDivisionResponce.Field = new List<String> {'DivisionId','RetailerId','ChId','CHName','Frequency'};
        else
        RetailerDivisionResponce.Field = new List<String> {'DivisionId','RetailerId','ChId','CHName'};   
        RetailerDivisionResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerDivisionResponce.Next = '0'; 
        List<List<String>> retailerDivisions = new List<List<String>>();
        map<string,string> Divisionlovidmap=new map<string,string>();
        try{
            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')})){
                Divisionlovidmap.put(stdListMaster.ivybase__List_Name__c, stdListMaster.Name);

            }
            system.debug('storeDivRecords '+ storeDivRecords);
            system.debug('Divisionlovidmap'+Divisionlovidmap);
            for(StoreDivisionMapping__c storeDiv : storeDivRecords){
                List<String> retailerDivision = new List<String>();
                system.debug('divname'+storeDiv.Division__c);
                system.debug('Divisionlovidmap'+ Divisionlovidmap);
                system.debug('Divisionlovidmap'+ Divisionlovidmap.get(storeDiv.Division__c));
                if(storeDiv.Division__c != null && Divisionlovidmap.containskey(storeDiv.Division__c) && Divisionlovidmap.get(storeDiv.Division__c)!=null  ){
                    retailerDivision.add(Divisionlovidmap.get(storeDiv.Division__c)); //DivisionId
                }else{
                    retailerDivision.add(''); 
                }
                if(storeDiv.Account__c != null){
                    retailerDivision.add(String.valueOf(storeDiv.Account__r.ivybase__Internal_Id__c)); //RetailerId
                }else{
                    retailerDivision.add(''); 
                }
                retailerDivision.add(storeDiv.Store_Hierarchy__r.ivybase__Internal_Id__c != NULL ? String.valueOf(storeDiv.Store_Hierarchy__r.ivybase__Internal_Id__c):'');
                retailerDivision.add(storeDiv.Store_Hierarchy__r.name!=NULL ? storeDiv.Store_Hierarchy__r.name :'');
                if(resource.Market_ISO__c=='JPN')
                retailerDivision.add(storeDiv.Salon_Frequency__c!=NULL ? storeDiv.Salon_Frequency__c :'');
                retailerDivisions.add(retailerDivision);
            }
system.debug('retailerDivisions '+retailerDivisions);
        }catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
        RetailerDivisionResponce.data = retailerDivisions;

        return RetailerDivisionResponce;   
    }

    public static RExAPIResponseDomain.ResponseInfo TranslateCUsersToJson(map<string,string> UserdivMap,string errorcode){
        ivybase__Resource__c res=ResourceService.getSellerId(userinfo.getuserid());
        RExAPIResponseDomain.ResponseInfo RetailerHairdresserResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerHairdresserResponce.Master = 'UserDivisionMapping';
        if(res.Market_ISO__c=='JPN'){
            RetailerHairdresserResponce.Field = new List<String> {'DivisionId','UserId','DefaultDivision'};
        }else{
            RetailerHairdresserResponce.Field = new List<String> {'DivisionId','UserId'};
        }
        RetailerHairdresserResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerHairdresserResponce.Next = '0'; 
        List<List<String>> retailerDivisions = new List<List<String>>();
        map<string,string> StdLovidDivisionmap=new map<string,string>();
        try{  
            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')})){
                StdLovidDivisionmap.put(stdListMaster.ivybase__List_Name__c, stdListMaster.Name);
            }
            for (string con:UserdivMap.keySet()) {
                List<String> retailerDivision = new List<String>();
                retailerDivision.add(String.valueOf(StdLovidDivisionmap.get(con.split('\\.')[0]) )!= null ? String.valueOf(StdLovidDivisionmap.get(con.split('\\.')[0])) : '');//divid

                retailerDivision.add(String.valueOf(UserdivMap.get(con))!=null ? String.valueOf(UserdivMap.get(con)) : '');//userid
                if(res.Market_ISO__c=='JPN') {       
                    if(con.split('\\.')[2].equalsignorecase('False')){
                        retailerDivision.add('0');
                    }else{
                        retailerDivision.add('1');
                    }   //DefaultDivision                
                }                                   
                retailerDivisions.add(retailerDivision);
            }
            RetailerHairdresserResponce.data=retailerDivisions;
        }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
        return RetailerHairdresserResponce;

    }

}