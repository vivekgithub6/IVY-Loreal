public class Reactivation_Rate_Service {
    public static KPIWrapper.SellerKPI getReactivationRate (KPIWrapper.SellerKPI TotalWrapper,map<string,ivybase__Standard_List_Master__c> standardlistLOVId,string divisionname){
        system.debug('TotalWrapper'+TotalWrapper);
         Date todayDate = date.Today();
         date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        date PreviousMonthtodate=Date.newInstance(todayDate.year(),todayDate.Month()-1,1);
        Integer numberOfDays = Date.daysInMonth(PreviousMonthtodate.year(), PreviousMonthtodate.month());
        Date lastDayOfMonth = Date.newInstance(PreviousMonthtodate.year(), PreviousMonthtodate.month(), numberOfDays);
        Integer Monthrec = todayDate.month(); 
        id resid=ResourceService.getLoginSellerId();
     /*AggregateResult groupedResults1 =[select count(ivydsd__Store__c) storecnt
                                                   from ivydsd__Order__c 
                                                   where ivydsd__Resource__c=:resid AND ivydsd__Order_Date__c >=: PreviousMonthtodate AND ivydsd__Order_Date__c<=:todayDate 
                                                    ];*/
       /* AggregateResult groupedResults =[select count(ivydsd__Store__c) storecnt
                                                   from ivydsd__Invoice__c 
                                                   where ivydsd__Store__r.ivybase__Active__c='YES' AND ivydsd__Store__r.Is_Conquest__c!=TRUE AND ivydsd__Store__r.Is_Dream_List__c!=TRUE AND ivydsd__Resource__c=:resid AND ivydsd__Store__r.LastInvoiceDate__c >=: PreviousMonthtodate AND ivydsd__Store__r.LastInvoiceDate__c<=:todayDate 
                                                    ];*/
        
        //system.debug('groupe9090990909090'+groupedResults);
       //to retrieve all the Aggreed Active Customer data 
        list<account> routeAccountList=AccountService.getAllRetailerMaster_List_for_Resource();
        system.debug('routeAccountList'+routeAccountList);
        set<id> agreedActiveCustomers = new set<id>();
        Decimal count;
        if(routeAccountList.size()>0 && routeAccountList!=null){
            for(Account acc:routeAccountList){
                if(acc.Is_Conquest__c!=True && acc.Is_Dream_List__c!=TRUE){
                    agreedActiveCustomers.add(acc.id);
                }
            }
        }
        /*AggregateResult groupedResults1 =[select count(ivydsd__Store__c) storecnt
                                                   from ivydsd__Invoice__c 
                                          where ivydsd__Store__r.ivybase__Active__c='YES' AND ivydsd__Store__r.Is_Conquest__c!=TRUE AND ivydsd__Store__r.Is_Dream_List__c!=TRUE AND ivydsd__Store__c IN:agreedActiveCustomers AND (ivydsd__Invoice_Date__c >=: PreviousMonthtodate AND ivydsd__Invoice_Date__c<=:todayDate)  
                                                    ];*/
       
        AggregateResult groupedResults =[select count(id) storecnt
                                                   from account 
                                                   where id IN:agreedActiveCustomers  AND ivybase__Active__c='YES' AND Is_Conquest__c!=TRUE AND Is_Dream_List__c!=TRUE  AND ((SecondLastInvoiceDate__c>=:PreviousMonthtodate AND SecondLastInvoiceDate__c<=:lastDayOfMonth) AND ( LastInvoiceDate__c<=:todayDate)) 
                                                    ];
        //system.debug('reactgroupedResults1'+groupedResults1);
        system.debug('reactgroupedResults'+groupedResults);
        system.debug('agreedActiveCustomers'+agreedActiveCustomers);
        if(agreedActiveCustomers.size()>0){
        count=agreedActiveCustomers.size();
            system.debug('reactagreedActiveCustomers Size'+count);
        }
        
        Decimal AvereagereactivationRate=0;
        system.debug('Decimal resuklt'+(decimal)groupedResults.get('storecnt'));
        if(count!=0 && count!=null && ((decimal)groupedResults.get('storecnt'))!=null){
           // if(groupedResults.contains('storecnt')){
            AvereagereactivationRate=((((decimal)groupedResults.get('storecnt'))/count)*100).setscale(2);
            //}
        }else{
            AvereagereactivationRate=0;
        }
         KPIWrapper.SellerKPI selerkpi= TotalWrapper;        
       list<KPIWrapper.SellerKPIDetail> skpidetaillist= TotalWrapper.slerkpidetail;
        KPIWrapper.SellerKPIDetail skpidetail = new KPIWrapper.SellerKPIDetail();
        skpidetail.KPIId=selerkpi.KPIId;
        if(standardlistLOVId!=null && standardlistLOVId.containskey('Reactivation-rate'+'.'+divisionname)){
         skpidetail.KPIParamName=standardlistLOVId.get('Reactivation-rate'+'.'+divisionname).ivybase__List_Name__c;
       	 skpidetail.KPIParamLovId=standardlistLOVId.get('Reactivation-rate'+'.'+divisionname).Name;   
        }
        else{
         skpidetail.KPIParamName='';
        skpidetail.KPIParamLovId='';
        }
        skpidetail.Target='';
        skpidetail.Achievement=string.valueof(AvereagereactivationRate)+'%';
        skpidetail.Incentive='';
        skpidetail.Flex1='';
        skpidetaillist.add(skpidetail);
        
        selerkpi.slerkpidetail=skpidetaillist;
        return selerkpi;
    }
    
    public static KPIWrapper.SellerKPI MonthlyActivationrate(KPIWrapper.SellerKPI TotalWrapper,map<string,ivybase__Standard_List_Master__c> standardlistLOVId,string divisionname){
        Date todayDate = date.Today();
        date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        date PreviousMonthtodate=Date.newInstance(todayDate.year(),todayDate.Month()-1,1);
        Integer Monthrec = todayDate.month(); 
        id resid=ResourceService.getLoginSellerId();
        
        /*AggregateResult groupedResults =[select count(ivydsd__Store__c) storecnt
                                                   from ivydsd__Invoice__c 
                                                   where ivydsd__Store__r.ivybase__Active__c='YES'AND ivydsd__Store__r.Is_Conquest__c!=TRUE AND ivydsd__Store__r.Is_Dream_List__c!=TRUE  AND ivydsd__Resource__c=:resid AND ivydsd__Store__r.LastInvoiceDate__c >=: Monthtodate AND ivydsd__Store__r.LastInvoiceDate__c<=:todayDate 
                                                    ];*/
        
        //to retrieve all the Aggreed Active Customer data 
        list<account> routeAccountList=AccountService.getAllRetailerMaster_List_for_Resource();
        system.debug('routeAccountList'+routeAccountList);
        set<id> agreedActiveCustomers = new set<id>();
        Decimal count;
        if(routeAccountList.size()>0 && routeAccountList!=null){
            for(Account acc:routeAccountList){
                if(acc.Is_Conquest__c!=True && acc.Is_Dream_List__c!=TRUE){
                    agreedActiveCustomers.add(acc.id);
                }
            }
        }
         AggregateResult groupedResults =[select count(id) storecnt
                                                   from account 
                                                   where id IN:agreedActiveCustomers  AND ivybase__Active__c='YES' AND Is_Conquest__c!=TRUE AND Is_Dream_List__c!=TRUE  AND LastInvoiceDate__c >=: Monthtodate AND LastInvoiceDate__c<=:todayDate 
                                                    ];
        system.debug('groupedResults1'+groupedResults);
        system.debug('agreedActiveCustomers'+agreedActiveCustomers);
        if(agreedActiveCustomers.size()>0){
        count=agreedActiveCustomers.size();
            system.debug('agreedActiveCustomers Size'+count);
        }
        
        Decimal AvereagereactivationRate=0;
        system.debug('Decimal resuklt'+(decimal)groupedResults.get('storecnt'));
        if(count!=0 && count!=null && ((decimal)groupedResults.get('storecnt'))!=null){
           // if(groupedResults.contains('storecnt')){
            AvereagereactivationRate=((((decimal)groupedResults.get('storecnt'))/count)*100).setscale(2) ;
            //}
        }else{
            AvereagereactivationRate=0;
        }
         KPIWrapper.SellerKPI selerkpi= TotalWrapper;        
       list<KPIWrapper.SellerKPIDetail> skpidetaillist= TotalWrapper.slerkpidetail;
        KPIWrapper.SellerKPIDetail skpidetail = new KPIWrapper.SellerKPIDetail();
        skpidetail.KPIId=selerkpi.KPIId;
        if(standardlistLOVId!=null && standardlistLOVId.containskey('Monthly Activation rate'+'.'+divisionname)){
         skpidetail.KPIParamName=standardlistLOVId.get('Monthly Activation rate'+'.'+divisionname).ivybase__List_Name__c;
       	 skpidetail.KPIParamLovId=standardlistLOVId.get('Monthly Activation rate'+'.'+divisionname).Name;   
        }
        else{
         skpidetail.KPIParamName='';
        skpidetail.KPIParamLovId='';
        }
        skpidetail.Target='';
        skpidetail.Achievement=string.valueof(AvereagereactivationRate)+'%';
        skpidetail.Incentive='';
        skpidetail.Flex1='';
        skpidetaillist.add(skpidetail);
        
        selerkpi.slerkpidetail=skpidetaillist;
        return selerkpi;
    }
}