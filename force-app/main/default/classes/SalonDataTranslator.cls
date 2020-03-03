/*
 * Block comments with details of changes
 */

//This Method id for sending Reatiler master data
public class SalonDataTranslator
{
    public static RExAPIResponseDomain.ResponseInfo objectToRetailerInfo(List<Account> accRecList, Map<Id,ivybase__Location_Hierarchy__c > locationMap, String errorCode) {
        RExAPIResponseDomain.ResponseInfo ResponseAccountinfo = new RExAPIResponseDomain.ResponseInfo();
        ResponseAccountinfo.Master = 'RetailerMaster';
        ResponseAccountinfo.Field = new List<String> {'RetailerId','RetailerCode','RetailerName','RetailerType','BeatId','CreditLimit','TinNumber','ChannelId','SubChannelId','ClassId',
                                          'IsAttended','RPTypeId','WalkingSequence','RField2','RField3','VisitDays','radius','RetCreditLimit','AccountId',
                                          'RField1','TaxTypeId','RField4','locationid','IsDeadStore','NfcTagId','ContractStatusLovId',
                                          'CreditPeriod','RField5','RField6','RField7','PreferredTime','LastMonthVisits'};

        List<List<String>> accListRec = new List<List<String>>();

        List<ivybase__Standard_List_Master__c> classtypeList = StandardListMasterService.getAllClassTypeList();
        // To get the count of visits for each salons
        SET<Id> idSet = new SET<Id>();

        for(Account a : accRecList) {
            idSet.add(a.Id);
        }

        MAP<Id,Integer> visitsCountList = new MAP<Id,Integer>();

        AggregateResult[] aggregateResultList = [SELECT count(Id), ivybase__Store__c  
                                                 FROM ivybase__Visit__c 
                                                 WHERE ivybase__Store__c IN: idSet group By ivybase__Store__c];

        for(AggregateResult ag : aggregateResultList) {
            visitsCountList.put((Id)ag.get('ivybase__Store__c'),(Integer)ag.get('expr0'));
        }

        Map<String,String> classNameAndCodeMap = new Map<String,String>();      
        for(ivybase__Standard_List_Master__c listMaster : classtypeList ){
            classNameAndCodeMap.put(listMaster.ivybase__List_Code__c,listMaster.Name);
        }
        List<ivybase__Standard_List_Master__c> RetailerTypeList = StandardListMasterService.getStandardListUsingListType(new List<String>{'RETAILER_TYPE'});
        Map<String,String> RetailerTypeNameAndCodeMap = new Map<String,String>();      
        for(ivybase__Standard_List_Master__c listMaster : RetailerTypeList ){
            RetailerTypeNameAndCodeMap.put(listMaster.ivybase__List_Code__c,listMaster.Name);
        }   

        for(Account acc :accRecList ){
            List<String> accTemp = new List<String>();

            ////Adding

            if (acc.ivybase__Internal_Id__c != null) {
                accTemp.add(String.valueOf(acc.ivybase__Internal_Id__c));//'RetailerId'
            } else {
                accTemp.add('');
            }
            accTemp.add(acc.AccountNumber != null ? acc.AccountNumber : '');//RetailerCode
            accTemp.add(acc.Name);//RetailerName
            if(acc.Is_Conquest__c){
                accTemp.add('2');
            }
            else if(acc.Is_Dream_List__c){
                accTemp.add('1');
            } else if(acc.IsAgent__c){
                accTemp.add('3');
            }
            else{
                accTemp.add('0');
            }//RetailerType
            //accTemp.add(RetailerType != null ? RetailerType : '');
            accTemp.add('');//BeatId
            accTemp.add(acc.ivybase__Credit_Limit__c != null ?String.valueOf(acc.ivybase__Credit_Limit__c) :'');//CreditLimit
            accTemp.add(acc.ivybase__TIN_Number__c != null ? acc.ivybase__TIN_Number__c : '');//TinNumber

            accTemp.add('');//ChannelId
            accTemp.add('');//SubChannelId
            accTemp.add((classNameAndCodeMap.get(acc.ivybase__Customer_Category__c) != null) ? classNameAndCodeMap.get(acc.ivybase__Customer_Category__c) :'');//ClassId
            accTemp.add('');//IsAttended
            if(RetailerTypeNameAndCodeMap.containsKey('CASH'))
            {
                accTemp.add(RetailerTypeNameAndCodeMap.get('CASH'));//RPTypeId   
            }else
            {
                accTemp.add('');//RPTypeId  
            }

            accTemp.add('');//WalkingSequence
            accTemp.add('');//RField2
            accTemp.add('');//RField3
            accTemp.add('');//VisitDays
            accTemp.add('');//radius
            accTemp.add('');//RetCreditLimit
            if (acc.ivybase__Parent_Branch__r.ivybase__Internal_Id__c != null) {
                accTemp.add(String.valueOf(acc.ivybase__Parent_Branch__r.ivybase__Internal_Id__c));//AccountId
            } else {
                accTemp.add('');
            }
            accTemp.add('0');//RField1
            accTemp.add('');//TaxTypeId
            accTemp.add(String.isNotBlank(acc.Stock_Location__c) ? acc.Stock_Location__c : '');//RField4
            accTemp.add(( locationMap.get(acc.Location_Hierarchy__c) != null ) ? locationMap.get(acc.Location_Hierarchy__c).ivybase__Internal_Id__c : '');//locationid
            accTemp.add('');//IsDeadStore
            accTemp.add('');//NfcTagId
            accTemp.add('');//ContractStatusLovId
            accTemp.add(acc.ivybase__Credit_Period__c != null ? String.valueOf(acc.ivybase__Credit_Period__c) : '');//CreditPeriod
            accTemp.add(acc.Salon_Frequency__c != null ? acc.Salon_Frequency__c : '');//RField5 //Salon_Frequency__c
            if(acc.IsFocus__c){
                accTemp.add('1');
            }
            else{
                accTemp.add('0');
            }//RField6 IsFocus__c
            //accTemp.add(acc.Salon_Frequency__c != null ? acc.Salon_Frequency__c : '');
            accTemp.add('1');//RField7
            // Commented for japan deployment
            /*if(acc.ivybase__Image_Path__c != null && acc.ivybase__Image_Name__c != null){
            accTemp.add(acc.ivybase__Image_Path__c + acc.ivybase__Image_Name__c ); //ProfileImagePath
        } else{
            accTemp.add(''); //ProfileImagePath
        }*/
            // PreferredTime
            accTemp.add(acc.Preferred_Time__c != NULL  && acc.Preferred_Time__c != '' ? acc.Preferred_Time__c : '' );
            // To add visit count
            integer countOfVisits;
            if(visitsCountList.containskey(acc.Id) && visitsCountList.get(acc.Id)!=null )
                countOfVisits=visitsCountList.get(acc.Id);
            accTemp.add(String.valueOf(countOfVisits) != NULL && String.valueOf(countOfVisits) != '' ?  String.valueOf(countOfVisits) : '');
            accListRec.add(accTemp)  ;  
        }
        ResponseAccountinfo.Data = accListRec;
        ResponseAccountinfo.ErrorCode = errorCode == null ? '0' : errorCode; 
        ResponseAccountinfo.Next = '0';
        return ResponseAccountinfo;
        // return null;
    }

}