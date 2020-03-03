//TestRestKpIMaster
public class SellerMessageBoardService {
    public static KPIWrapper.SellerKPI getSellerMessageBoard(){
         Id user = UserInfo.getUserId();
            String userId = String.valueOf([SELECT Id, ivybase__Internal_Id__c FROM User where Id=:user].ivybase__Internal_Id__c);
            Id resid = ResourceService.getLoginSellerId();
             KPIWrapper.SellerKPI KPIHeader= new KPIWrapper.SellerKPI();
     
        List<MessageMapping__c> msgMapping = new List<MessageMapping__c>();
        List<KPIWrapper.SellerMessageBoard>  SellerMessageBoard = new List<KPIWrapper.SellerMessageBoard> ();
         list<KPIWrapper.SellerKPIDetail>  SellerKPIDetail=new list<KPIWrapper.SellerKPIDetail> ();
        list<KPIWrapper.SellerKPISKUDetail> KpiSkuDetail=new list<KPIWrapper.SellerKPISKUDetail>();
         //list<KPIWrapper.SellerMessageBoard> KPISellerMessageBoard=new  list<KPIWrapper.SellerMessageBoard>();
        
     //   list<SellerMessageBoard>
        String[] msgMappingFields = new String[] {'Name','Message__c','Resource__c'};
            String[] msgFields = new String[] {'Name'};
                if(SecurityUtility.checkIsAccessible('MessageMapping__c', msgMappingFields)
                   && SecurityUtility.checkIsAccessible('Message__c', msgFields)){
                       msgMapping   = [Select Name,Message__c,Resource__c,Message__r.Name,Message__r.Message__c,Message__r.Valid_From__c,Message__r.Valid_To__c from MessageMapping__c where Message__r.Valid_From__c <=today AND Message__r.Valid_To__c >=today AND Resource__c !=null AND Resource__c=: resId AND Message__c!=null];
                   system.debug('msgMapping'+msgMapping);
                       for(MessageMapping__c msgMap : msgMapping){
                           KPIWrapper.SellerMessageBoard k=new KPIWrapper.SellerMessageBoard();
                           k.Userid = String.valueOf(userId);
                           k.Messageid = String.valueOf(msgMap.Message__r.Name);
                           k.Message = msgMap.Message__r.Message__c;
                           k.SuveyCount = '';
                           SellerMessageBoard.add(k);
                       }
                   
                   }
        KPIHeader.KPISellerMessageBoard = SellerMessageBoard;
        KPIHeader.slerkpidetail=SellerKPIDetail;
            KPIHeader.KpiSkuDetail=KpiSkuDetail;
       
        
        return KPIHeader;
    }

}