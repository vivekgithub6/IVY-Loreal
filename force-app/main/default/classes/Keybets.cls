public class Keybets {
    public static KPIWrapper.SellerKPI CalculateKeybets (){
        string KPIID;
        map<string,ivybase__Standard_List_Master__c> standardlistLOVId=new map<string,ivybase__Standard_List_Master__c>(); 

        Date todayDate = date.Today();
        integer d1=todayDate.day();
        integer m1=todayDate.month();
        integer y1=todayDate.year();
        DateTime ToDat = DateTime.newInstance(y1, m1, d1);
        string divisionname;
        date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        integer d2=Monthtodate.day();
        integer m2=Monthtodate.month();
        integer y2=Monthtodate.year();
        DateTime FromDat = DateTime.newInstance(y2, m2, d2); 
        id resid=ResourceService.getLoginSellerId();
        id userid=userinfo.getUserId();
        //Query standard list master
        user u=[select id,ivybase__Internal_Id__c from user where ID =:userid];
        //gettting locids
         map<string,string> GetAllResourcesDivisons= ResourceService.GetAllResourceDivisionmap();
                        for(string sd:GetAllResourcesDivisons.keyset()){
                            divisionname=GetAllResourcesDivisons.get(sd);
                             }
                        system.debug('divisionname'+divisionname);
     
        for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('KPI_TYPE'),('KPI_DETAIL_TYPE')})){
            if(stdListMaster.ivybase__List_Code__c=='Key Bets' && stdListMaster.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname)
                KPIID=  (string)stdListMaster.Name;
            else{
                standardlistLOVId.put(stdListMaster.ivybase__List_Code__c+'.'+stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c,stdListMaster);
            }
        }
        //--
       set<id> sfids= new set<id>();
        List<Sales_Forecast__c> SalesforecastList = PromotionalPlanningService.getApprovedPromotionalPlan();
        for(Sales_Forecast__c sfd:SalesforecastList){
            sfids.add(sfd.id);
        }
        Map<id,decimal> sfidnewlaunchvalue= new map<id,decimal>();
        Map<id,decimal> sfidpromotionvalue= new map<id,decimal>();
        list<Sales_Forecast_Detail__c> sfdetaillst= [select id,Target__c,Sales_Forecast__c,RecordType.name,RecordType.developername
                                                     from Sales_Forecast_Detail__c
                                                     where Sales_Forecast__c IN :sfids];
        for(Sales_Forecast_Detail__c sf:sfdetaillst){
            if(sf.RecordType.developername=='New_Launch'){
                if(sfidnewlaunchvalue!=null && sfidnewlaunchvalue.containskey(sf.Sales_Forecast__c)  && sfidnewlaunchvalue.get(sf.Sales_Forecast__c)!=null){
                    decimal newlaunchval=sfidnewlaunchvalue.get(sf.Sales_Forecast__c);
                    newlaunchval=newlaunchval+sf.Target__c;
                    sfidnewlaunchvalue.put(sf.Sales_Forecast__c,newlaunchval); 
                }else{
                   sfidnewlaunchvalue.put(sf.Sales_Forecast__c,sf.Target__c);  
                }
            }else if(sf.RecordType.developername=='Promotion'){
                if(sfidpromotionvalue!=null && sfidpromotionvalue.containskey(sf.Sales_Forecast__c) && sfidpromotionvalue.get(sf.Sales_Forecast__c)!=null){
                    decimal promval=sfidpromotionvalue.get(sf.Sales_Forecast__c);
                    promval=promval+sf.Target__c;
                    sfidpromotionvalue.put(sf.Sales_Forecast__c,promval); 
                }else{
                   sfidpromotionvalue.put(sf.Sales_Forecast__c,sf.Target__c);  
                } 
                
            }
        }
                    
        system.debug('sfidnewlaunchvalue'+sfidnewlaunchvalue);
        
        list<KPIWrapper.SellerKPIDetail> skpidetaillist= new list<KPIWrapper.SellerKPIDetail> ();
        list<KPIWrapper.SellerKPISKUDetail> sKpiSkuDetaillist= new list<KPIWrapper.SellerKPISKUDetail>();
        list<KPIWrapper.SellerMessageBoard> msgboardlist=new list<KPIWrapper.SellerMessageBoard>();
        
        for(Sales_Forecast__c sfc:SalesforecastList){
        KPIWrapper.SellerKPIDetail skpidetail = new KPIWrapper.SellerKPIDetail();
            
        skpidetail.KPIId=KPIID;
        if(standardlistLOVId.containskey('New Launch'+'.'+divisionname)){
            skpidetail.KPIParamName=standardlistLOVId.get('New Launch'+'.'+divisionname).ivybase__List_Name__c;
            skpidetail.KPIParamLovId=standardlistLOVId.get('New Launch'+'.'+divisionname).Name;
        }else{
            skpidetail.KPIParamName=''; 
            skpidetail.KPIParamLovId='';
        }
         if(sfidnewlaunchvalue.containskey(sfc.Id)){
            skpidetail.Target=string.valueof(sfidnewlaunchvalue.get(sfc.Id));
           }
        skpidetail.Achievement=string.valueof(sfc.Total_Achieved_Value__c);
        skpidetail.Incentive='';
        skpidetail.Flex1='';
            
            KPIWrapper.SellerKPIDetail skpidetail1 = new KPIWrapper.SellerKPIDetail();
            
        skpidetail1.KPIId=KPIID;
        if(standardlistLOVId.containskey('Promotions'+'.'+divisionname)){
            skpidetail1.KPIParamName=standardlistLOVId.get('Promotions'+'.'+divisionname).ivybase__List_Name__c;
            skpidetail1.KPIParamLovId=standardlistLOVId.get('Promotions'+'.'+divisionname).Name;
        }else{
            skpidetail1.KPIParamName=''; 
            skpidetail1.KPIParamLovId='';
        }
         if(sfidpromotionvalue.containskey(sfc.Id)){
            skpidetail1.Target=string.valueof(sfidpromotionvalue.get(sfc.Id));
           }
        skpidetail1.Achievement=string.valueof(sfc.Promotion_Achieved_Value__c);
        skpidetail1.Incentive='';
        skpidetail1.Flex1='';
            
        skpidetaillist.add(skpidetail); 
        skpidetaillist.add(skpidetail1);
        }
         KPIWrapper.SellerKPI selerkpi= new KPIWrapper.SellerKPI();
        selerkpi.KPIId=KPIID;
        selerkpi.UserId=string.valueOf(u.ivybase__Internal_Id__c);
        selerkpi.FromDate=FromDat.format('yyyy/MM/dd');
        selerkpi.ToDate= ToDat.format('yyyy/MM/dd');
        selerkpi.Flex1='';
        selerkpi.Flex2='';
         selerkpi.slerkpidetail=skpidetaillist;
        selerkpi.KpiSkuDetail=sKpiSkuDetaillist;
        selerkpi.KPISellerMessageBoard=msgboardlist;
        return selerkpi;          
    }
}