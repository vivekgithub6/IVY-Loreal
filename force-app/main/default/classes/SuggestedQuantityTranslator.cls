public with sharing class SuggestedQuantityTranslator {

    public static RExAPIResponseDomain.ResponseInfo objectToSugQtyInfo(List<ivydsd__Suggested_Quantity__c> sugqtyList,set<Id> retailIdforuser,String errorcode){
        
        RExAPIResponseDomain.ResponseInfo sugqtydata = new RExAPIResponseDomain.ResponseInfo();
        
        sugqtydata.Master = 'RtrWiseInventoryMaster';
        sugqtydata.Next ='0';
        sugqtydata.ErrorCode = errorCode == null ? '0' : errorCode; 
        sugqtydata.Field = new List<String>{'productid','retailerId','qty'};
        List<List<String>> sugqtyRec = new List<List<String>>();
        
        if(sugqtyList != null && errorcode == null){
            
            for(ivydsd__Suggested_Quantity__c sug : sugqtyList){
                
                if(retailIdforuser.Contains(sug.ivydsd__Retailer__c)){
                    List<String> temprec = new List<String>();
                    temprec.add(sug.ivydsd__Product__r.ivybase__InternalId__c != null ? String.Valueof(sug.ivydsd__Product__r.ivybase__InternalId__c) : '');
                    temprec.add(sug.ivydsd__Retailer__r.ivybase__Internal_Id__c != null ? String.Valueof(sug.ivydsd__Retailer__r.ivybase__Internal_Id__c) : '');
                    if(sug.ivydsd__Quantity__c != null){
                        temprec.add(String.Valueof(sug.ivydsd__Quantity__c));
                    }else{
                        temprec.add('');
                    }
                   sugqtyRec.add(temprec);     
                }
                
            }
        }
        sugqtydata.Data = sugqtyRec;
        return sugqtydata;
        
    }
}