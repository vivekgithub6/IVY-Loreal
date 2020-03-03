public with sharing class SaloonCatagoryTranslator {
 	public static RExAPIResponseDomain.ResponseInfo objectToSaloonCatagory(List<Salon_Catagory__c > saloonCatagoryRecords,String errorCode) {
    RExAPIResponseDomain.ResponseInfo ClassList = new RExAPIResponseDomain.ResponseInfo();
        
        ClassList.Master = 'RetailerMagSpecification';
        ClassList.Field = new List<String> {'Classid','ServiceFee','NoOfStylist'};
        List<List<String>> classData = new List<List<String>>();
        List<String> Classtype = new List<String>();
        Classtype.add('CHANNEL_HIERARCHY');
        List<ivybase__Standard_List_Master__c> SLMList = StandardListMasterservice.getStandardListUsingListType(Classtype);
        Map<String,String> SLMMap = new Map<String,String>();
        for(ivybase__Standard_List_Master__c s:SLMList)
        {
            SLMMap.put(s.ivybase__List_Code__c,s.Name);
        }
        if(saloonCatagoryRecords != null && errorCode == null) {
           
            for (Salon_Catagory__c  cRec : saloonCatagoryRecords) {
                List<String> cList = new List<String>();
                cList.add(cRec.Salon_Catagoty__c !=null?(SLMMap.containsKey(cRec.Salon_Catagoty__c)==true?SLMMap.get(cRec.Salon_Catagoty__c):null):null);//Class
                cList.add(cRec.Criteria2__r.Range__c !=null?String.valueOf(cRec.Criteria2__r.Range__c ):null);//Criteria2
                cList.add(cRec.Criteria1__r.Range__c !=null?String.valueOf(cRec.Criteria1__r.Range__c ):null);//Criteria1
               	
                
                classData.add(cList);
            }
        }
        ClassList.Data = classData;
        ClassList.ErrorCode = errorCode == null ? '0' : errorCode; 
        ClassList.Next = '0';
        return ClassList;
    }
}