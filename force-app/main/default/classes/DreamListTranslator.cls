public class DreamListTranslator {
 public static RExAPIResponseDomain.ResponseInfo objectToJsonInfo(List<Account> DreamList, String errorCode) {
        RExAPIResponseDomain.ResponseInfo DContentInfo = new RExAPIResponseDomain.ResponseInfo ();
        DContentInfo.Master = 'RetailerDreamList';
        DContentInfo.Field = new List<String>{'Rid', 'ProgressPercentage','Status','Remarks','SuperWiserFeedBack','Upload','LastVisitDate','IsConquest'}; 
            List<List<String>> dContentMapList = new List<List<String>>();
     
        if (DreamList != null && errorCode == null ) {
            for (Account A :DreamList) {
                List<String> digitalRec = new List<String>();
                 DateTime visiteddate;
                digitalRec.add( (A.ivybase__Internal_Id__c != null) ? string.valueof(A.ivybase__Internal_Id__c) :'' );
                digitalRec.add( (A.Progress_Percentage__c != null) ? A.Progress_Percentage__c.format() :'' );            
                digitalRec.add( (A.Dream_List_Status__c != null) ? A.Dream_List_Status__c :'' );   
                 digitalRec.add( (A.Remarks__c != null) ? A.Remarks__c :'' );   
               digitalRec.add( '' );   
               digitalRec.add( '' );  
                if( A.Last_Visit_Date__c!=Null){
                                      Date visitDate = A.Last_Visit_Date__c;
        integer d1=visitDate.day();
         integer m1=visitDate.month();
         integer y1=visitDate.year();
         visiteddate = DateTime.newInstance(y1, m1, d1);
                }
                digitalRec.add( (visiteddate!=Null) ? visiteddate.format('yyyy/MM/dd') :'' );    
                
             
                digitalRec.add( (A.Is_Conquest__c==True) ? '1' :'0' );       
               dContentMapList.add(digitalRec);
                system.debug('dContentMapList'+dContentMapList);
            }
        }
        DContentInfo.Data = dContentMapList;
        DContentInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        DContentInfo.Next = '0';
        
      
        return DContentInfo;
    }
}