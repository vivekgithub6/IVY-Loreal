/**
 * Created By : Ivy Mobility
 * Purpose : 
 * Referred In : OrderTrigger
 * Test Class : TestOrderTrigger
*/
public class OrderTriggerHandler {

    public static boolean RanupdateResourceDivisionInOrder = false; // to avoid recursion
    public static void updateResourceDivisionInOrder(list<ivydsd__Order__c> OrderList, Map<Id, ivydsd__Order__c> orderMap){
        
        if(RanupdateResourceDivisionInOrder == false){
            
            system.debug('Query: updateResourceDivisionInOrder');
            System.debug('OrderList==>'+OrderList);
            Set<Id> resourceID = new Set<Id>();
            for(ivydsd__Order__c ord : OrderList)
            {
                ivydsd__Order__c oldOrd = orderMap.containsKey(ord.Id) == true ? orderMap.get(ord.Id) : null;
                if(oldOrd != null && oldOrd.ivydsd__Order_Status__c != ord.ivydsd__Order_Status__c && String.isBlank(ord.ivydsd__Order_Status__c) == true) {
                    ord.ivydsd__Order_Status__c = oldOrd.ivydsd__Order_Status__c;
                }
                if(ord.ivydsd__Resource__c != null) {
                    resourceID.add(ord.ivydsd__Resource__c);
                    System.debug('ord.ivydsd__Resource__c==>' + ord.ivydsd__Resource__c);
                }
            }
            System.debug('resourceID==>'+resourceID);
            
            List<ivybase__Location_Hierarchy__c> userTerritory = [select id,name,ivybase__Primary_Resource__c FROM ivybase__Location_Hierarchy__c 
                            WHERE ivybase__Primary_Resource__c != null AND ivybase__Primary_Resource__c=:resourceID  AND RecordType.DeveloperName = 'Territory'];
            
            Set<Id> userTerritoryId = new Set<Id>(); 
            Map<Id,Id> resoruceLocationHierarchy = new Map<Id,Id>();    
            for(ivybase__Location_Hierarchy__c l:userTerritory)
            {
                userTerritoryId.add(l.id);
                resoruceLocationHierarchy.put(l.ivybase__Primary_Resource__c,l.id);
            }
            system.debug('userTerritoryId'+userTerritoryId);
            
            List<DivisionLocation__c> divisionList = [select id,name,Division__c, Location_Hierarchy__c from DivisionLocation__c where Location_Hierarchy__c=:userTerritoryId];    
            Map<Id,Id> locationDivision = new Map<Id,Id>();
            
            for(DivisionLocation__c dv:divisionList)
            {
               locationDivision.put(dv.Location_Hierarchy__c, dv.Division__c); 
            }
            for(ivydsd__Order__c o:OrderList)
            {
                if(resoruceLocationHierarchy.containsKey(o.ivydsd__Resource__c) && locationDivision.containsKey(resoruceLocationHierarchy.get(o.ivydsd__Resource__c)) )
                if(locationDivision.get(resoruceLocationHierarchy.get(o.ivydsd__Resource__c))!=null)
                {
                    o.Division__c=locationDivision.get(resoruceLocationHierarchy.get(o.ivydsd__Resource__c));
                }                     
            }
        }
    }
    public static boolean RanupdateEmail = false; // to avoid recursion
    public static void updateEmail(list<ivydsd__Order__c> OrderList){
        if(RanupdateEmail == false){
            
        system.debug('Query: UpdateEmail');
        map<id,string> Accountmailmap=new  map<id,string>();
        map<id,string> Resourcemailmap=new  map<id,string>();
        set<id> AccountIds=new set<id>();
        set<id> resourceIds=new set<id>();
        for(ivydsd__Order__c order:OrderList){
            AccountIds.add(order.ivydsd__Store__c);
            resourceIds.add(order.ivydsd__Resource__c);
        }
        list<Account> AccountList=[select ivybase__Contact_Email__c from Account where id in:AccountIds];
        list<ivybase__Resource__c> resourceList=[select id,ivybase__Email__c from ivybase__Resource__c where id in:resourceIds];
        for(Account A:AccountList)
            Accountmailmap.put(A.id, A.ivybase__Contact_Email__c);
        for(ivybase__Resource__c r:resourceList)
        {
            Resourcemailmap.put(r.id,r.ivybase__Email__c);
        }
        for(ivydsd__Order__c order:OrderList)
        {
            if(Accountmailmap.containsKey(order.ivydsd__Store__c)){
            order.Saloon_Email__c=Accountmailmap.get(order.ivydsd__Store__c);
            }
            if(Resourcemailmap.containsKey(order.ivydsd__Resource__c))
            {
                order.Resource_Email__c =Resourcemailmap.get(order.ivydsd__Resource__c);
            }
        }
        }
    }
    public static boolean Ranupdatestatus = false; // to avoid recursion
    public static void updatestatus(list<ivydsd__Order__c> OrderList){
        if(Ranupdatestatus == false){
            Ranupdatestatus=true;
            system.debug('Query:updatestatus');
        system.debug('OrderList'+OrderList);
        id userid= userinfo.getUserId();
        list<ivybase__Resource__c> res=[select id,name,ivybase__Related_User__c,ivybase__Resource_Type__c,ivybase__Resource_Type__r.Name from ivybase__Resource__c
                                        where ivybase__Related_User__c =:userid ];
        system.debug('res'+res);
        String resorcetypename = Label.ResourceType_Name; 
        
        if(res.size()>0 && res[0].ivybase__Resource_Type__r.Name!=resorcetypename){
            if(OrderList!=null && OrderList.size()>0){
                for(ivydsd__Order__c ord:OrderList){
                    ord.ivydsd__Order_Status__c='draft';
                }
            }
        }
        }
    }
    public static boolean RanupdatestatusOrdered = false; // to avoid recursion
    public static void updatestatusOrdered(list<ivydsd__Order__c> OrderList){
        if(RanupdatestatusOrdered == false){
            RanupdatestatusOrdered=true;
            system.debug('Query:updatestatusOrdered');
        system.debug('OrderList'+OrderList);
        system.debug('Method called');
        id userid= userinfo.getUserId();
        list<ivybase__Resource__c> res=[select id,ivybase__Related_User__c,ivybase__Resource_Type__c,ivybase__Location_Hierarchy__c,ivybase__Resource_Type__r.Name 
                                        from ivybase__Resource__c where ivybase__Related_User__c =:userid ];
        String resorcetypename = Label.ResourceType_Name; 
        //set<id> orderid= new set<id>();
        map<id,ivydsd__Order__c> ordidordMap = new map<id,ivydsd__Order__c>();
        if(res.size()>0 && res[0].ivybase__Resource_Type__r.Name!=resorcetypename){
        list<ivybase__Location_Hierarchy__c> loclist= new list<ivybase__Location_Hierarchy__c> ();
        if(res.size()>0){
            loclist = [select id,ivybase__Internal_Id__c,ivybase__Primary_Resource__c from ivybase__Location_Hierarchy__c where ivybase__Primary_Resource__c=:res[0].id 
                        AND RecordType.developername='Territory'];
        }
        id locid;
        if(loclist.size()>0){
            locid=loclist[0].id;
        }
        map<id,division__c> divMap= new map<id,division__c>();
        list<division__c> divsionlist= [select id,name,Internal_Id__c from Division__c];
        for(Division__c div:divsionlist){
            divMap.put(div.id,div);
        }
        
        map<id,set<id>> divloctionmap= new map<id,set<id>>();System.debug('####'+limits.getQueries());
            list<DivisionLocation__c> divlocation= [select Division__c,Location_Hierarchy__c from DivisionLocation__c where Division__c IN:divMap.keyset()  ];
        for(DivisionLocation__c divloc:divlocation){
            if(divloctionmap.containskey(divloc.Division__c)){
                divloctionmap.get(divloc.Division__c).add(divloc.Location_Hierarchy__c);  
            }
            else{
                set<id> lochirid = new set<id>();
                lochirid.add(divloc.Location_Hierarchy__c);
                divloctionmap.put(divloc.Division__c,lochirid);
            }
        }
        id mydisvisionid =AverageTurnoverPerRep.getdivisionforlocation(divloctionmap,locid); ///to get the resource division ID
        system.debug('mydisvisionid'+mydisvisionid);
        
        //getting min order based on Div ID
        list<Minimum_Order_Amount__c> MinorderfieldsList= [select id,Name,Product_Hierarchy__c,Product_Hierarchy__r.ivybase__Internal_Id__c,
                                                           Store_Hierarchy__c,Store_Hierarchy__r.ivybase__Internal_Id__c,Division__c,
                                                           Division__r.Internal_Id__c,Value__c,From__c,To__c,Division__r.name
                                                           from Minimum_Order_Amount__c 
                                                           Where From__c<=:Date.today() AND To__c>=:Date.today() AND Division__c =:mydisvisionid];
        decimal minamount;
        if(MinorderfieldsList.size()>0){
            minamount= MinorderfieldsList[0].Value__c;
        }
       
            system.debug('Inside If method');
            if(OrderList!=null && OrderList.size()>0){
                for(ivydsd__Order__c ord:OrderList){
                    // orderid.add(ord.id);
                    ordidordMap.put(ord.id,ord);
                }
            }
            //}
            system.debug('ordidordMap'+ordidordMap);
            list<ivydsd__Order__c> ordlist= [select id,(select id from ivydsd__Order_Line_Items__r) from ivydsd__Order__c where ID IN:ordidordMap.keyset() ];
            map<id,list<ivydsd__Order_Line_Item__c>> order_ordlineitemMap= new map<id,list<ivydsd__Order_Line_Item__c>>();
            system.debug('ordlist'+ordlist);
            for(ivydsd__Order__c od:ordlist){
                //if(od.ivydsd__Order_Line_Items__r!=null){
                list<ivydsd__Order_Line_Item__c> olitem= new list<ivydsd__Order_Line_Item__c>();
                for(ivydsd__Order_Line_Item__c ol:od.ivydsd__Order_Line_Items__r){
                    olitem.add(ol);
                }
                order_ordlineitemMap.put(od.id,olitem);
                //}
            }
            system.debug('order_ordlineitemMap'+order_ordlineitemMap);
            // if(res.size()>0 && res[0].ivybase__Resource_Type__r.Name!=resorcetypename){
            if(OrderList!=null && OrderList.size()>0){
                for(ivydsd__Order__c ord:OrderList){
                    system.debug('Linetem map1'+order_ordlineitemMap.containskey(ord.id));
                    if(order_ordlineitemMap.containskey(ord.id)){
                        system.debug('Linetem map'+order_ordlineitemMap.containskey(ord.id));
                        //&& (ord.ivydsd__Order_Value__c>minamount)
                        if(order_ordlineitemMap.get(ord.id).size()>0  ){
                            system.debug('order_ordlineitemMap.get(ord.id).size()'+order_ordlineitemMap.get(ord.id).size());
                            ord.ivydsd__Order_Status__c='Ordered'; 
                        }else{
                            ord.adderror(Label.Line_Item_Error);  
                        }
                    }
                }
            }
        }
        }
    }
    public static boolean RanTaxCalculation = false; // to avoid recursion
    public static void TaxCalculation(list<ivydsd__Order__c> OrderList){
        if(RanTaxCalculation == false){

            system.debug('Query: tax Calculation');
        try{
            set<id> orderid= new set<id>();
            map<string,ivybase__Standard_List_Master__c> standardlistTaxvalue=new map<string,ivybase__Standard_List_Master__c>();
            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('TAX_TYPE')})){
                if(stdListMaster!=null){
                    standardlistTaxvalue.put(stdListMaster.ivybase__List_Type__c,stdListMaster);                
                }
            }
            decimal totaltaxval=0;
            decimal totalvalue;
            decimal taxval=0;
            for(ivydsd__Order__c ord:OrderList){
                if(ord.ivydsd__Order_Value__c!=null ||ord.ivydsd__Order_Value__c!=0 ){
                    if(standardlistTaxvalue.containskey('TAX_TYPE') && standardlistTaxvalue.get('TAX_TYPE')!=null){
                        taxval= decimal.valueOf(standardlistTaxvalue.get('TAX_TYPE').ivybase__Flex1__c);
                        
                        if(taxval!=null && ord.ivydsd__Order_Value__c!=null && (ord.ivydsd__DiscountAmount__c!=null && ord.ivydsd__DiscountAmount__c!=0)){
                            system.debug('******eneterd if'+(ord.ivydsd__DiscountAmount__c!=null || ord.ivydsd__DiscountAmount__c!=0));
                            ord.Total_Tax_Value__c=((ord.ivydsd__Order_Value__c-ord.ivydsd__DiscountAmount__c)*taxval/100);
                            ord.ivydsd__Final_Order_Value__c=(ord.ivydsd__Order_Value__c-ord.ivydsd__DiscountAmount__c+ord.Total_Tax_Value__c);  
                        }else if(taxval!=null && ord.ivydsd__Order_Value__c!=null){
                            system.debug('** no discount');
                            ord.Total_Tax_Value__c=((ord.ivydsd__Order_Value__c)*taxval/100);
                            ord.ivydsd__Final_Order_Value__c=(ord.ivydsd__Order_Value__c+ord.Total_Tax_Value__c);  
                        }
                    }
                } 
            } 
        }
        Catch(Exception e){
            system.debug('error'+e.getMessage());
        }
        }
    }
    
    public static void SubmitForApproval(Set<id> OrderIds){
           //map<string,string> JourneyplanIdOwnerIdMap=new map<string,string>();
        //List<String> resourceTypeNameList = new List<String>{ 'Area','Regional','National'};
            Id submitterId = UserInfo.getUserId();
            UserwiseCountryValues__c  mc = UserwiseCountryValues__c.getInstance(UserInfo.getUserId());
            string countryCode = mc.Market_ISO__c;
            
        //Map<String,Id> ApproverIdSet=new Map<String,Id>();
        
        List<ivybase__HHT_Module_Master__mdt> moduleData = [Select DeveloperName,ivybase__Flag__c from ivybase__HHT_Module_Master__mdt where DeveloperName='Order_Approval'];
        if(moduleData.size()!=null  && moduleData[0].ivybase__Flag__c == 1 ){
            //ApproverIdSet=   ApproverIds.getAllLevelApproverIds(submitterId);
            //system.debug('ApproverIds'+ApproverIdSet);
            List<Id> Approverid = new List<Id>();
            List<Profile> profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Service_ARGO'];
            if(profileId.size()>0)
            {
                Set<Id> pid = new set<Id>();
                for(Profile p:profileId)
                {
                    pid.add(p.id);
                }
                List<User> userList = [select id,name,ProfileId from User where  ProfileId=:pid and Market_ISO__c=:countryCode];
                for(User u:userList)
                {system.debug('u'+u);
                   Approverid.add(u.id); 
                }
            }
                

            /*for(Integer i = 0; i < resourceTypeNameList.size(); i++){
                if(Approverid==Null){
                    if(ApproverIdSet.size()>0 && ApproverIdSet.containskey(resourceTypeNameList[i]) && ApproverIdSet.get(resourceTypeNameList[i])!=Null)
                        Approverid=ApproverIdSet.get(resourceTypeNameList[i]);
                }
            }*/
            for(id s:OrderIds){
                // Create an approval request for the Opportunity
                if(Approverid!=Null && Approverid.size()>0){
                    if(Approval.isLocked(s)==false){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval');
                    req1.setObjectId(s);
                    system.debug('Approverid'+Approverid);
                    req1.setNextApproverIds(Approverid);
                    // Submit the approval request for the Opportunity
                    Approval.ProcessResult result = Approval.process(req1); 
                    }
                }
            } 
            List<Id> OrderIdList = new List<Id>(OrderIds);
            if(OrderIdList.size()>0){
            Approval.unlock(OrderIdList,false);
            }
        } 
        else{
            /*contact  contact1=[select id,email from contact limit 1];//This is required for target object id 
            EmailTemplate template =  [SELECT Id, Name FROM EmailTemplate WHERE Name like 'OrderDetailsToStore' LIMIT 1];
            List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();*/
            List<ivydsd__Order__c> orders = [Select Id,ivydsd__Order_Status__c,Saloon_Email__c from ivydsd__Order__c where Id IN : OrderIds];
            for(ivydsd__Order__c m:orders){
                m.ivydsd__Order_Status__c='Approved';
               /* String[] toAddresses = new String[] {m.Saloon_Email__c}; 
                    Messaging.SingleEmailMessage oneEmail = new Messaging.SingleEmailMessage();    
                system.debug(toAddresses);
                oneEmail.setTreatTargetObjectAsRecipient(false);        
                oneEmail.setTargetObjectId(contact1.id);   
                oneEmail.setSaveAsActivity(false);
                oneEmail.setWhatId(m.id);
                oneEmail.setTemplateId(template.Id);
                oneEmail.setToAddresses(toAddresses);
                myEmails.add(oneEmail);*/
            } 
           // Messaging.SendEmailResult[] results=  Messaging.sendEmail(myEmails);
            update orders;
    }
    }
    public static boolean RanmapToNormalSalon = false; // to avoid recursion
    public static void mapToNormalSalon(List<ivydsd__Order__c> orders){
    
        if(RanmapToNormalSalon == false){
            RanmapToNormalSalon=true;
            System.debug('test');
            Map<Id,Id> salonIdsMap = new Map<Id,Id>();
            for(ivydsd__Order__c Order:orders){
                salonIdsMap.put(Order.Id,Order.ivydsd__Store__c);
            }
            Map<Id,Account> salonMap = new Map<Id,Account>([Select Id,Is_Conquest__c,Is_Dream_List__c,Converted_to_Normal_Saloon__c from Account 
                                                            where Id IN : salonIdsMap.values()]);
            for(ivydsd__Order__c Order:orders){
                if(salonIdsMap.containsKey(Order.Id) && salonMap.containsKey(salonIdsMap.get(Order.Id))){
                    if(salonMap.get(salonIdsMap.get(Order.Id)).Is_Conquest__c == true || salonMap.get(salonIdsMap.get(Order.Id)).Is_Dream_List__c == true
                        || Order.ivydsd__Store__c == null){
                        
                       // Order.ivydsd__Store__c.addError('We can create order only for Normal Salon'); 
                    }
                }
            }
        }
    }
    /* This method is to check SF rep divison and rep division from order are matching or not 
     * Written by Keerthi 12/05/2018
     **/
    public static boolean RanMatchingRepDivison = false; // to avoid recursion
    public static void MatchingRepDivison(List<ivydsd__Order__c> orderlist){
        if(RanMatchingRepDivison == false){
            RanMatchingRepDivison=true;
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'MatchOrderDiv&RepDiv'});
        if(triggerLogicMap.get('MatchOrderDiv&RepDiv') == Null || triggerLogicMap.get('MatchOrderDiv&RepDiv') == false){

            Trigger_Logic_Configuration__c user = Trigger_Logic_Configuration__c.getInstance('MatchOrderDiv&RepDiv');
            if(user!=null && user.UserName__c != null && userinfo.getUserName() == user.UserName__c){
                    set<String> RepDivSet = new set<String>();
                    for(DivisionLocation__c divloc : [select Id, Division__c, Division__r.Division_Code__c,Location_Hierarchy__c, 
                                                        Location_Hierarchy__r.ivybase__Primary_Resource__c, Location_Hierarchy__r.ivybase__Primary_Resource__r.SAP_Id__c 
                                                        from DivisionLocation__c 
                                                      where Location_Hierarchy__r.ivybase__Primary_Resource__r.SAP_Id__c != null] )
                    {
                        String comboDivRep =String.valueOf(divloc.Division__c)+String.valueOf(divloc.Location_Hierarchy__r.ivybase__Primary_Resource__c);
                        RepDivSet.add(comboDivRep);                                      
                    }
                    system.debug('****RepDivSet'+RepDivSet);
                    for (ivydsd__Order__c order : orderlist){
                        if(order.Division__c != null && order.ivydsd__Resource__c != null){
                            String DivRepOrder = String.valueOf(order.Division__c) + String.valueOf(order.ivydsd__Resource__c) ;
                            system.debug('****DivRepOrder'+DivRepOrder);
                            if(!RepDivSet.contains(DivRepOrder)){
                                order.addError('Sales Rep Divsion and Order Division are not matching, PO Number is '+order.Purchase_Order_Number__c);
                            }
                        }
                    }
            }
        }
        }
    }
    /* this method is to update PO number with order number(to use PO number as external ID)
     * written by Keerthi on 12/06/2018
     * */
    public static boolean RanupdatePONumber = false; // to avoid recursion
    public static void updatePONumber(List<ivydsd__Order__c> orderList){
       
        if(RanupdatePONumber == false){
            list<ivydsd__Order__c> UpdateOrderlist = new list<ivydsd__Order__c>();
            system.debug('Query:PO Number Update');
            for(ivydsd__Order__c order : [SELECT Id, Name, Purchase_Order_Number__c,Sales_Document_Number__c, ivydsd__Purchase_Order_Number__c, Customer_PO__c 
                                            FROM ivydsd__Order__c WHERE Id IN :orderList]) {
                                                
                if(String.isBlank(order.Purchase_Order_Number__c) && order.name != null) {
                    order.Purchase_Order_Number__c = order.Name;
                }
                RanupdatePONumber = true;
                system.debug('---Purchase_Order_Number__c-->'+order.Purchase_Order_Number__c);
                if(order.Purchase_Order_Number__c != order.Sales_Document_Number__c)
                 UpdateOrderlist.add(order);
            }
            update UpdateOrderlist;
        } 
    }
    //This method added by Karthikeyan to update the Purchase Order Number based on the Customer PO- used for Mobile upoad
    // & Sales Document No - Used for Integration purpose. The order error message also thrown for integration purpose.
    public static void updatePONo(List<ivydsd__Order__c> orderList, Map<Id, ivydsd__Order__c> orderOldMap) {

        for(ivydsd__Order__c ord : orderList) {
            if( ord.ivydsd__Store__c == null) {//ord.Argo_Order__c == true &&
                ord.ivydsd__Store__c.addError('Store required for the Argo orders');
            }
            if(String.isNotBlank(ord.Customer_PO__c) == true && ord.Argo_Order__c == true 
               && (trigger.isInsert || trigger.isUpdate && (ord.Purchase_Order_Number__c == orderOldMap.get(ord.Id).Customer_PO__c
               || orderOldMap.get(ord.Id).ivydsd__Order_Status__c == 'Draft' || ord.name == ord.Purchase_Order_Number__c) )) {
                   system.debug('orderid'+ord.Id);
                ord.Purchase_Order_Number__c = ord.Customer_PO__c;
            }
            if(trigger.isUpdate == true && String.isNotBlank(ord.Sales_Document_Number__c) == true 
               && ord.Sales_Document_Number__c != ord.Purchase_Order_Number__c) {
               ord.Purchase_Order_Number__c = ord.Sales_Document_Number__c;
            }
        }
    }
}