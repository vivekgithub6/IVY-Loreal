public class SalesKpiServiceClass {
   public static  KPIWrapper.SellerKPI getSalesKPIs(){
        System.debug('inside');
        KPIWrapper.SellerKPI KPIHeader= new KPIWrapper.SellerKPI();
        list<KPIWrapper.SellerKPIDetail>  SellerKPIDetailList=new list<KPIWrapper.SellerKPIDetail> ();
        list<KPIWrapper.SellerKPISKUDetail> KpiSkuDetail=new list<KPIWrapper.SellerKPISKUDetail>();
        list<KPIWrapper.SellerMessageBoard> KPISellerMessageBoard=new  list<KPIWrapper.SellerMessageBoard>();
        
        //KPI parameters
        string KPIID;
        string KPIParamLovId;
        string KPIParamName;
        string KPIParamLovIdQty;
        string KPIParamNameQty;
        string userId;
        date Monthtodate=Date.newInstance(date.Today().year(),date.Today().Month(),1);
        integer d2=Monthtodate.day();
        integer m2=Monthtodate.month();
        integer y2=Monthtodate.year();
        
        Date todayDate = date.Today();
        integer d1=todayDate.day();
        integer m1=todayDate.month();
        integer y1=todayDate.year();
        DateTime todate = DateTime.newInstance(y1, m1, d1);
        
        DateTime fromdate = DateTime.newInstance(y2, m2, d2);
        
        String[] targetActualFields = new String[]{'Account__c','Account_Coverage__c','Actual__c','Resource__c','RecordTypeId','ActualCoverage__c','End_Date1__c',
            'Achievement__c','Incentive_Group__c','Month__c','Parameter_type__c','Product_Group__c','Product_Hierarchy__c','Sales_Target_Acheivement__c',
            'Target__c','Name','Start_Date1__c'};
                String[] productFields = new String[]{'ivybase__InternalId__c'};    
                    
                    if(SecurityUtility.checkIsAccessible('Target_Actual__c', targetActualFields) ){
                        try{
                            user u=[select ivybase__Internal_Id__c from user where id=:userinfo.getUserId()];
                            userId=string.valueOf(u.ivybase__Internal_Id__c);
                            Id resId = ResourceService.getLoginSellerId();
                            Map<string,String> kpiDetailMapName = new Map<String,String>();
                            Map<string,String> kpiDetailMapLovId = new Map<String,String>();
                            //getting divisions
                            string divisionname;
                            Id divisionid;
                            set<string> Divisionids=new set<string>(); 
                            map<string,string> GetAllResourcesDivisons= ResourceService.GetAllResourceDivisionmap();
                            for(string sd:GetAllResourcesDivisons.keyset()){
                                divisionname=GetAllResourcesDivisons.get(sd);
                                divisionid =sd;
                            }
                            system.debug('divisionname'+divisionname);
                            system.debug('diviisonid'+divisionid);
                            list<Target_Actual__c> targetActual=[Select Actual__c,Account_Coverage__c,ActualCoverage__c,Achievement__c,Parameter_type__c,Resource__c,
                                                                 Sales_Target_Acheivement__c,Start_Date1__c,Product_Group__r.ivybase__Grouping_Type__c,RecordType.DeveloperName,End_Date1__c,Target__c,Name 
                                                                 from Target_Actual__c 
                                                                 where Resource__c=:resId 
                                                                 AND Month__c=:Date.today().month() AND Year__c=:Date.today().year() 
                                                                 AND (RecordType.DeveloperName='Sales_KPI' OR Product_Group__r.ivybase__Grouping_Type__c='Colox Penetration')
                                                                 ];
                            system.debug('targetActual'+targetActual);
                            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('KPI_TYPE'),('KPI_DETAIL_TYPE')})){
                                System.debug('stdListMaster::'+stdListMaster);
                                if(stdListMaster.ivybase__List_Code__c=='Sales kpi' && stdListMaster.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname){
                                    KPIID=  (string)stdListMaster.Name;
                                    System.debug('KPI ID::'+KPIID);
                                }
                                    //Colox penetration
                                //Average Strike rate
                                if(((stdListMaster.ivybase__List_Code__c.equalsignorecase('Average Turnover per Rep')) || (stdListMaster.ivybase__List_Code__c.equalsignorecase('Average Turnover Per Order'))||
                                   (stdListMaster.ivybase__List_Code__c.equalsignorecase('Active No Of Customers')) ||(stdListMaster.ivybase__List_Code__c.equalsignorecase('Monthly Activation rate')) || 
                                   (stdListMaster.ivybase__List_Code__c.equalsignorecase('Reactivation-rate'))||(stdListMaster.ivybase__List_Code__c=='Gain of new clients') || (stdListMaster.ivybase__List_Code__c=='Loss of Clients')||
                                   (stdListMaster.ivybase__List_Code__c=='Colox penetration') || (stdListMaster.ivybase__List_Code__c=='Average turnover per salon')||
                                   (stdListMaster.ivybase__List_Code__c=='Avg No Of Orders')|| (stdListMaster.ivybase__List_Code__c=='Average Strike rate') || (stdListMaster.ivybase__List_Code__c=='Avg No Of Visits'))
                                    && (stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname)){
                                         
                                       kpiDetailMapLovId.put((string)stdListMaster.ivybase__List_Code__c, (string)stdListMaster.Name);
                                        system.debug('kpiDetailMapLovId'+kpiDetailMapLovId);
                                       kpiDetailMapName.put((string)stdListMaster.ivybase__List_Code__c, (string)stdListMaster.ivybase__List_Name__c);
                                   system.debug('kpiDetailMapName'+kpiDetailMapName);
                                    }
                                
                                 
                                
                            }
                            
                            //FOrming KPI header
                            KPIHeader.KPIId=KPIID;
                            KPIHeader.UserId=userId;
                            KPIHeader.FromDate=fromdate.format('yyyy/MM/dd');
                            KPIHeader.ToDate=todate.format('yyyy/MM/dd');
                            
                            //KPI Detail
                            for(Target_Actual__c target : targetActual){
                                system.debug('target.RecordType.DeveloperName'+target.RecordType.DeveloperName);
                                system.debug('target.Parameter_type__c'+target.Parameter_type__c);
                               /* if(target.Parameter_type__c=='Average Turnover per Rep'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }*/
                                if(target.Parameter_type__c=='Average Turnover Per Order'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                /*if(target.Parameter_type__c=='Average Turnover per order(SAP)'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    //k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Average Turnover per order(SAP+SFA)'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Coverage rate'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }*/
                                if(target.Parameter_type__c=='Reactivation-rate'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    /*Decimal actual= target.Actual__c;
                                    actual=OrderLineItemTriggerhandler.roundingUP2DecimalPlaces(actual);*/
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Monthly Activation rate'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                   /* Decimal actual= target.Actual__c;
                                    actual=OrderLineItemTriggerhandler.roundingUP2DecimalPlaces(actual);*/
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Gain of new clients'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Loss of Clients'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Product_Group__r.ivybase__Grouping_Type__c=='Colox penetration'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get('Colox penetration');//target.Product_Group__r.ivybase__Grouping_Type__c
                                    system.debug(target.Product_Group__r.ivybase__Grouping_Type__c+'-->ColoX LOV ID<---'+kpiDetailMapLovId.get(target.Product_Group__r.ivybase__Grouping_Type__c));
                                    k.KPIParamName=kpiDetailMapName.get('Colox penetration');//target.Product_Group__r.ivybase__Grouping_Type__c
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Account_Coverage__c);//Sales_Target_Acheivement__c
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Average turnover per salon'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Avg No Of Orders'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }//
                                if(target.Parameter_type__c=='Avg No Of Visits'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }//
                                if(target.Parameter_type__c=='Average Strike rate'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                                if(target.Parameter_type__c=='Active No Of Customers'){
                                    KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                    k.KPIId=KPIID;
                                    k.KPIParamLovId=kpiDetailMapLovId.get(target.Parameter_type__c);
                                    k.KPIParamName=kpiDetailMapName.get(target.Parameter_type__c);
                                    k.Target=String.valueOf(target.Target__c);
                                    k.Achievement=String.valueOf(target.Actual__c);
                                    k.Incentive = String.valueOf(target.Achievement__c);
                                    system.debug('k'+k);
                                    SellerKPIDetailList.add(k); 
                                }
                            }
                            System.debug('KIP Detail:: '+SellerKPIDetailList);
                            System.debug('KpiSkuDetail:: '+KpiSkuDetail);
                            
                            KPIHeader.slerkpidetail=SellerKPIDetailList;  
                            KPIHeader.KpiSkuDetail=KpiSkuDetail;
                            
                            
                        }catch(Exception e){
                            system.debug('erro'+e.getMessage());
                        }
                        System.debug('KPIHeader::'+KPIHeader);
                        return KPIHeader;  
                    }
        
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
    }
   
}