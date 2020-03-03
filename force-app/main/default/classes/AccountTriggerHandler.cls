public class AccountTriggerHandler {
    //inserting dummy contacts for an account/
    public static void insertHairDresser(List<Account> accounts){
        set<id> accid = new set<id>();
       
        list<contact> insertDummyCons = new list<contact>();
        for(account acct : accounts){
            if(acct.Market_ISO__c	=='JPN'){
              //if(AcctIdVSContactListMap.containskey(acct.id) && AcctIdVSContactListMap.get(acct.id)!=null && AcctIdVSContactListMap.get(acct.id).isEmpty()){
              contact con = new contact();
                  con.lastname='Dummy contact';
                  con.Email=acct.id+'@dummy.com';
                con.AccountId = acct.id;
                  insertDummyCons.add(con);
              //}
            }
        }
        
        if(!insertDummyCons.isEmpty()){
            insert insertDummyCons; 
        }

    }
    //method ends
    public static void reDocumentData(List<Account> accounts){
        
        Set<Id> acLocId = new Set<Id>();
        for(Account a:accounts)
        {
            if(a.Location_Hierarchy__c!=null){
                acLocId.add(a.Location_Hierarchy__c);
            }
        }
        List<ivybase__HHTMenu_Master__c> hhtMenuData = [Select ivybase__MenuType__c,name,ivybase__MName__c,ivybase__MNumber__c,ivybase__Flag__c,ivybase__Location_Hierarchy__c
                                                        from ivybase__HHTMenu_Master__c
                                                        where ivybase__Flex__c='Document__c' and ivybase__Location_Hierarchy__c=:acLocId and ivybase__Flag__c = 1];
        System.debug('hhtMenuData::: '+hhtMenuData);
        Map<Id,List<ivybase__HHTMenu_Master__c>> LocationWiseData = new Map<Id,List<ivybase__HHTMenu_Master__c>>();
        for(ivybase__HHTMenu_Master__c masterData :hhtMenuData)
        {
            if(LocationWiseData.containsKey(masterData.ivybase__Location_Hierarchy__c))
            {
                LocationWiseData.get(masterData.ivybase__Location_Hierarchy__c).add(masterData);
            }
            else
            {
                List<ivybase__HHTMenu_Master__c> data = new List<ivybase__HHTMenu_Master__c>();
                data.add(masterData);
                LocationWiseData.put(masterData.ivybase__Location_Hierarchy__c, data);
            }
        }
        Map<String,String> hhtMenuMap = new Map<String,String>();
        List<Document__C> documentList = new List<Document__c>();
        for(Account acc : accounts){
            if(acc.Location_Hierarchy__c!=null && LocationWiseData.containsKey(acc.Location_Hierarchy__c)){
                for(ivybase__HHTMenu_Master__c hhtMenu : LocationWiseData.get(acc.Location_Hierarchy__c)){
                    Document__C doc = new Document__C();
                    doc.Name = hhtMenu.name;
                    doc.Document_Name__c = hhtMenu.ivybase__MName__c;
                    doc.Retailer__c = acc.Id;
                    doc.Market_ISO__c = acc.Market_ISO__c;
                    //doc.Document_Code__c = hhtMenu.DeveloperName;
                    documentList.add(doc);
                }
            }
        }
        
        insert documentList;
        
    }
    
    /*public static void createPartner(list<Account> Accountlist){
list<Partner_Function__c> Partnerlist=new list<Partner_Function__c>();
for(Account A:Accountlist){
if(A.Is_Conquest__c==True){
Partner_Function__c p=new Partner_Function__c();
p.Account__c=A.id;
p.Partner__c=A.id;
p.Type__c=  'Bill To';
Partnerlist.add(p);
}
}
if(Partnerlist.size()>0)
insert Partnerlist;
}*/
    
    public static void updateNormalSalon(list<Account> Accountlist){
        List<Account> updateAccList = new List<Account>();
        for(Account acc : Accountlist){
            acc.Converted_Date__c = Date.today();
            acc.Is_Conquest__c = false;
            updateAccList.add(acc);
        }
        System.debug('updateAccList::'+updateAccList);
    }
    /* this method is to copy the outstanding amount/Due amount and credit limit from payer account to sold to party(main account)
* Written by Keerthi on 12/05/2018
* */
    Public static void updateOutstandingAmountinSoldtoParty(list<Account> AccountList)
    {
        list<account> updateAcclist = new list<account>();
        Map<id,id> AccountPayerMap = new Map<Id,id>();
        set<id> AccountSet = new set<id>();
        for(Partner_Function__c pf : [select Type__c,Partner__c,Partner__r.Due_Amount__c,Account__c,Account__r.Due_Amount__c from Partner_Function__c where Partner__c IN:AccountList and type__c= 'Payer'])
        {
            if(pf.Account__c != pf.Partner__c){
                AccountPayerMap.put(pf.Account__c, pf.Partner__c);
                AccountSet.add(pf.Account__c); 
                AccountSet.add(pf.Partner__c);
            }
        }
        system.debug('AccountPayerMap->'+AccountPayerMap);
        Map<Id,Account> AccountMap = new Map<Id,Account>([select id, due_amount__c,ivybase__Credit_Limit__c from account where Id in :AccountSet]);
        
        for(id i: AccountPayerMap.keyset()){
            account acc = AccountMap.get(i);
            Account Payer = AccountMap.get(AccountPayerMap.get(i));
            acc.due_amount__c = Payer.due_amount__c;
            if(acc.ivybase__Credit_Limit__c == null) {
                acc.ivybase__Credit_Limit__c = payer.ivybase__Credit_Limit__c;
            }
            updateAcclist.add(acc);
        }
        system.debug(updateAcclist);
        update updateAcclist;
    }
    
    //for mag population
    public static void updateMag(List<Account> Accountlist)
    {
        try
        {
            Map<Salon_Catagory__c, String> salonCategories = new Map<Salon_Catagory__c, String>();
            for(Salon_Catagory__c sc : [SELECT		Id, Name, Criteria1__r.Max__c, Criteria1__r.Min__c, Criteria2__r.Max__c,
                                        Criteria2__r.Min__c, Market_ISO__c
                                        FROM	 	Salon_Catagory__c ])
            {
                if(!salonCategories.containskey(sc))
                    salonCategories.put(sc, sc.Name);                
            }
            system.debug('salonCategories'+salonCategories);
            for(Account acc:Accountlist)
            {
                if(acc.No_of_Stylist__c != NULL && acc.Color_Price__c != NULL) 
                {
                    for(Salon_Catagory__c sc:salonCategories.keyset())
                    {
                        if (acc.Market_ISO__c == sc.Market_ISO__c) 
                        {
                            if(sc.Criteria1__r.Max__c!=null && sc.Criteria1__r.Min__c!=null && sc.Criteria2__r.Min__c!=null &&  sc.Criteria2__r.Max__c!=null)
                            {
                                if(acc.No_of_Stylist__c >= sc.Criteria1__r.Min__c && acc.No_of_Stylist__c<= sc.Criteria1__r.Max__c && Integer.valueof(acc.Color_Price__c) >= sc.Criteria2__r.Min__c && Integer.valueof(acc.Color_Price__c)<= sc.Criteria2__r.Max__c)
                                {
                                    system.debug('result'+salonCategories.get(sc));
                                    acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                    break;
                                }
                                system.debug(' acc.ivybase__Customer_Category__c'+ acc.ivybase__Customer_Category__c);
                            }
                            else if(sc.Criteria1__r.Max__c==null && sc.Criteria2__r.Max__c==null && acc.No_of_Stylist__c >= sc.Criteria1__r.Min__c  && Integer.valueof(acc.Color_Price__c) >= sc.Criteria2__r.Min__c)
                            {
                                system.debug('result'+salonCategories.get(sc));
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else if(sc.Criteria1__r.Min__c==null && sc.Criteria2__r.Min__c==null &&  acc.No_of_Stylist__c<= sc.Criteria1__r.Max__c && Integer.valueof(acc.Color_Price__c)<= sc.Criteria2__r.Max__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else if(sc.Criteria1__r.Max__c==null && acc.No_of_Stylist__c >= sc.Criteria1__r.Min__c && Integer.valueof(acc.Color_Price__c) >= sc.Criteria2__r.Min__c && Integer.valueof(acc.Color_Price__c)<= sc.Criteria2__r.Max__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else if(sc.Criteria2__r.Max__c==null && Integer.valueof(acc.Color_Price__c) >= sc.Criteria2__r.Min__c && acc.No_of_Stylist__c >= sc.Criteria1__r.Min__c && acc.No_of_Stylist__c<= sc.Criteria1__r.Max__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                            }
                            else if(sc.Criteria1__r.Min__c==null &&  acc.No_of_Stylist__c<= sc.Criteria1__r.Max__c && Integer.valueof(acc.Color_Price__c) >= sc.Criteria2__r.Min__c && Integer.valueof(acc.Color_Price__c)<= sc.Criteria2__r.Max__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else if(sc.Criteria2__r.Min__c==null && Integer.valueof(acc.Color_Price__c)<= sc.Criteria2__r.Max__c && acc.No_of_Stylist__c >= sc.Criteria1__r.Min__c && acc.No_of_Stylist__c<= sc.Criteria1__r.Max__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else if(sc.Criteria1__r.Max__c==null && sc.Criteria2__r.Min__c==null && acc.No_of_Stylist__c >= sc.Criteria1__r.Min__c && Integer.valueof(acc.Color_Price__c)<= sc.Criteria2__r.Max__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else if(sc.Criteria1__r.Min__c==null && sc.Criteria2__r.Max__c==null &&  acc.No_of_Stylist__c<= sc.Criteria1__r.Max__c && Integer.valueof(acc.Color_Price__c) >= sc.Criteria2__r.Min__c)
                            {
                                acc.ivybase__Customer_Category__c=salonCategories.get(sc);
                                break;
                            }
                            else
                            {
                                system.debug('in else');
                                acc.ivybase__Customer_Category__c='';
                            }
                            system.debug('account'+acc); 
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Exception'+e);
        }
    }
}