public  with sharing class IncentiveServiceClass {
    public static  KPIWrapper.SellerKPI getSalesTargets(){
        KPIWrapper.SellerKPI KPIHeader= new KPIWrapper.SellerKPI();
        list<KPIWrapper.SellerKPIDetail>  SellerKPIDetailList=new list<KPIWrapper.SellerKPIDetail> ();
        list<KPIWrapper.SellerKPISKUDetail> KpiSkuDetail=new list<KPIWrapper.SellerKPISKUDetail>();
        list<KPIWrapper.SellerMessageBoard> KPISellerMessageBoard=new  list<KPIWrapper.SellerMessageBoard>();
        map<string,ivybase__Standard_List_Master__c> ProducthierarchyLOVId=new map<string,ivybase__Standard_List_Master__c>();
        map<string,ivybase__Standard_List_Master__c> ProducthierarchyRecordtypeIdLOVId=new map<string,ivybase__Standard_List_Master__c>();
        map<string,string> Productheirarchyidinternalidmap=new map<string,string>();
        set<id> ProducthierachyIds=new set<id>();
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
        String[] salesTargetFields = new String[]{'Target__c','Achievement__c','Actual__c','Resource__c','RecordTypeId','Account_Coverage__c','Account_Coverage__c','MX__c','ISMS_Coverage__c','Account_Coverage__c'};
            String[] productFields = new String[]{'ivybase__InternalId__c'};    
                if(SecurityUtility.checkIsAccessible('Target_Actual__c', salesTargetFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', productFields)){
                    try{
                        user u=[select ivybase__Internal_Id__c from user where id=:userinfo.getUserId()];
                        userId=string.valueOf(u.ivybase__Internal_Id__c);
                        //Date todayDate = date.Today();
                        Id resId = ResourceService.getLoginSellerId();
                        Map<string,String> kpiDetailMapName = new Map<String,String>();
                        Map<string,String> kpiDetailMapLovId = new Map<String,String>();
                        Map<string,String> kpiDetailMapLovIdMYNew = new Map<String,String>();
                        Map<string,String> kpiDetailMapNameMYNew = new Map<String,String>();
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
                        list<Target_Division__c> TargetDivisions=[Select Division__c,Division__r.name,Target_Actual__c,Target_Actual__r.Market_ISO__c,Target_Actual__r.Parameter_type__c,Target_Actual__r.Name,Target_Actual__r.Target__c,Target_Actual__r.Actual__c,Target_Actual__r.RecordType.DeveloperName,Target_Actual__r.Achievement__c,Target_Actual__r.Account_Coverage__c, Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c,Target_Actual__r.ActualCoverage__c,Target_Actual__r.Month__c,Target_Actual__r.Sales_Target_Acheivement__c from Target_Division__c where Target_Actual__r.Resource__c=:resId and ((Target_Actual__r.Start_Date1__c<=:todayDate and Target_Actual__r.End_Date1__c>=:todayDate) OR (Target_Actual__r.Month__c=:Date.today().month() and Target_Actual__r.year__c=:Date.today().year()) OR(Target_Actual__r.Target_Actual__r.Start_Date1__c<=:todayDate and Target_Actual__r.Target_Actual__r.End_Date1__c>=:todayDate)) and Division__c =:divisionid and Target_Actual__r.RecordType.DeveloperName!='Sales_KPI'];//
                        system.debug('TargetDivisions'+TargetDivisions);
                        
                        //list<Target_Division__c> TargetDivisions=[Select Division__c,Division__r.name,Target_Actual__c,Target_Actual__r.Market_ISO__c,Target_Actual__r.Parameter_type__c,Target_Actual__r.Name,Target_Actual__r.Target__c,Target_Actual__r.Actual__c,Target_Actual__r.RecordType.DeveloperName,Target_Actual__r.Achievement__c,Target_Actual__r.Account_Coverage__c, Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c,Target_Actual__r.ActualCoverage__c,Target_Actual__r.Month__c,Target_Actual__r.Sales_Target_Acheivement__c from Target_Division__c where Target_Actual__r.Resource__c=:resId and Target_Actual__r.Month__c=:Date.today().month() and Target_Actual__r.year__c=:Date.today().year() and Division__c =:divisionid and Target_Actual__r.RecordType.DeveloperName!='Sales_KPI'];
                        for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('KPI_TYPE'),('KPI_DETAIL_TYPE')})){
                            system.debug('stdListMaster'+stdListMaster.ivybase__List_Name__c);
                            system.debug('dname'+stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c);
                            
                            if(stdListMaster.ivybase__List_Code__c=='Incentive' && stdListMaster.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname)
                                KPIID=  (string)stdListMaster.Name;
                            if(stdListMaster.ivybase__List_Code__c=='Sell in Performance' && stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname){
                                
                                KPIParamLovId=  (string)stdListMaster.Name;
                                KPIParamName= (string)stdListMaster.ivybase__List_Name__c;
                            }
                            
                            if((stdListMaster.ivybase__List_Code__c=='Variable- (LP: SMARTBOND)' || stdListMaster.ivybase__List_Code__c=='Activation' || stdListMaster.ivybase__List_Code__c=='Conquest'
                                || stdListMaster.ivybase__List_Code__c=='ISMS' || stdListMaster.ivybase__List_Code__c=='MX' 
                                || stdListMaster.ivybase__List_Code__c=='Fusio Dose' || stdListMaster.ivybase__List_Code__c=='Extensioniste'  || stdListMaster.ivybase__List_Code__c=='Inventory_Check' || stdListMaster.ivybase__List_Code__c=='Sales KPIs(Kera)') && stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname){
                                    kpiDetailMapName.put((string)stdListMaster.ivybase__List_Code__c, (string)stdListMaster.ivybase__List_Name__c);
                                    kpiDetailMapLovId.put((string)stdListMaster.ivybase__List_Code__c, (string)stdListMaster.Name);
                                }
                            
                            //adding and forming the Map of Listname and List code of Kpi Detail type
                            if(stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname){
                                kpiDetailMapLovIdMYNew.put((string)stdListMaster.ivybase__Display_Name__c, (string)stdListMaster.Name);
                                kpiDetailMapNameMYNew.put((string)stdListMaster.ivybase__Display_Name__c, (string)stdListMaster.ivybase__List_Name__c);
                            }
                        }
                        system.debug('kpiDetailMapName'+kpiDetailMapName);
                        system.debug('kpiDetailMapLovId'+kpiDetailMapLovId);
                        system.debug('kpiDetailMapNameMYNew'+kpiDetailMapNameMYNew);
                        system.debug('kpiDetailMapLovIdMYNew'+kpiDetailMapLovIdMYNew);
                        //FOrming KPI header
                        KPIHeader.KPIId=KPIID;
                        KPIHeader.UserId=userId;
                        KPIHeader.FromDate=fromdate.format('yyyy/MM/dd');
                        KPIHeader.ToDate=todate.format('yyyy/MM/dd');
                        // System.debug('Targets:: '+targets);
                        //KPI Detail
                        //
                        /***Forming Conquest semister******/
                        decimal totaltarget=0;
                        decimal totalactual=0;
                        decimal totalachievement=0;
                        string Finalparameter;
                        for(Target_Division__c target1 : TargetDivisions){
                            system.debug('target1'+target1);
                            system.debug('target2'+target1.Target_Actual__c);
                            //system.debug('target3'+target1.Target_Actual__r.Parameter_type__c);
                           /* if(target1.Target_Actual__r.Parameter_type__c!=null ){
                                system.debug('conquestmonthly'+target1.Target_Actual__r.Parameter_type__c);
                            }*/
                            if(target1.Target_Actual__r.RecordType.DeveloperName=='Conquest' && target1.Target_Actual__r.Parameter_type__c!=null && target1.Target_Actual__r.Market_ISO__c.equalsignorecase('SG') && target1.Target_Actual__r.Parameter_type__c.equalsignorecase('Conquest Semester')){
                             totaltarget=totaltarget+target1.Target_Actual__r.Target__c;
                                totalactual=totalactual+target1.Target_Actual__r.Actual__c;
                                if(target1.Target_Actual__r.Achievement__c!=null)
                                totalachievement =totalachievement+target1.Target_Actual__r.Achievement__c;
                                
                                Finalparameter=target1.Target_Actual__r.Parameter_type__c;
                            }
                        } 
                        system.debug('Finalparameter'+Finalparameter);
                        /******logic End***********/
                        for(Target_Division__c target : TargetDivisions){
                            system.debug('target.Target_Actual__r.RecordType.DeveloperName'+target.Target_Actual__r.RecordType.DeveloperName);
                            system.debug('target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c'+target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Sales_Target' && target.Target_Actual__r.Market_ISO__c.equalsignorecase('PH')){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=KPIParamLovId;
                                k.KPIParamName=KPIParamName;
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //adding MY related Incnetives target Achievement
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Sales_Target' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Parameter_type__c.equalsignorecase('Target achievement')){
                                system.debug('Inside MY Sales Target');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //adding MY related Incnetives Quarter incentive
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Sales_Target' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Parameter_type__c.equalsignorecase('Quarter incentive')){
                                system.debug('Inside MY Sales Target Quater Incentbe');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                             //adding MY related Incnetives Quarter incentive
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Sales_Target' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Parameter_type__c.equalsignorecase('Mid Month')){
                                system.debug('Inside MY Sales Target Quater Incentbe');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                               //adding MY related Incnetives Salesrecovery
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Sales_Target' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Parameter_type__c.equalsignorecase('Sales recovery')){
                                system.debug('Inside MY Sales Target Quater Incentbe');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Conquest' && target.Target_Actual__r.Market_ISO__c.equalsignorecase('PH')){
                                system.debug('Conquest');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY conquest Monthly Incentive
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Conquest' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Market_ISO__c.equalsignorecase('MY') &&target.Target_Actual__r.Parameter_type__c.equalsignorecase('Conquest Monthly')){
                                system.debug('Conquest Masaia month');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY conquest Purchase Incentive
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Conquest' && target.Target_Actual__r.Parameter_type__c!=null &&target.Target_Actual__r.Parameter_type__c.equalsignorecase('Conquest Purchase')){
                                system.debug('Conquest qautertr');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY Keybets Incentives
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Keybets_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Top 20 MAJI Shades')){
                                system.debug('Keybets Incentives');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                 k.Achievement='0.00';   
                                }
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY Keybets Incentives SMART Bond
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Keybets_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('SMART Bond')){
                                system.debug('Keybets Incentives');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                 k.Achievement='0.00';   
                                }
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY Keybets Incentives Powermix
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Keybets_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Powermix')){
                                system.debug('Keybets Incentives');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                 k.Achievement='0.00';   
                                }
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY Keybets Incentives Top 20 Sku
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Keybets_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Top 20 SKUs')){
                                system.debug('Keybets Incentives');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                 k.Achievement='0.00';   
                                }
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //MY Keybets Incentives Fusio Dose
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Keybets_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Fusio Dose')){
                                system.debug('Keybets Incentives');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                 k.Achievement='0.00';   
                                }
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG Incnetives TurnOver
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Sales_Target' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Parameter_type__c.equalsignorecase('TurnOver Incentive')){
                                system.debug('Inside MY Sales Target turnover Incentbe');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG Incnetive Pillar incnetive Fusio Dose
                            if(target.Target_Actual__r.RecordType.DeveloperName=='SG_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Fusio Dose')){
                                system.debug('SG Incentives Fusio Dose');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                    k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                    k.Achievement='0.00';   
                                }                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG Incnetive Pillar incnetive SCALP  
                            if(target.Target_Actual__r.RecordType.DeveloperName=='SG_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('SCALP')){
                                system.debug('SG Incentives SCALP ');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                if(target.Target_Actual__r.Target__c!=0){
                                    k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                }else{
                                    k.Achievement='0.00';   
                                }
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG Incnetive Pillar incnetive New Launch  
                            if(target.Target_Actual__r.RecordType.DeveloperName=='SG_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('New Launch')){
                                system.debug('SG Incentives New Launch ');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG Incnetive Pillar Incentives Top 20 Sku
                            if(target.Target_Actual__r.RecordType.DeveloperName=='SG_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Top 20 SKUs')){
                                system.debug('Keybets Incentives');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                system.debug('kpiDetailMapLovIdMYNew'+kpiDetailMapLovIdMYNew);
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG Incnetive Color Incentive
                            if(target.Target_Actual__r.RecordType.DeveloperName=='SG_Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c!=null && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c.equalsignorecase('Color Incentive')){
                                system.debug('SG Incnetive Color Incentive');
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG conquest Monthly Incentive
                            if(target.Target_Actual__r.RecordType.DeveloperName.equalsignorecase('Conquest') && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Market_ISO__c.equalsignorecase('SG') && target.Target_Actual__r.Parameter_type__c.equalsignorecase('Conquest monthly')){
                                system.debug('Conquest Singapore month');
                                system.debug('Name1234567'+kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c));
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.Parameter_type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            //SG conquest Semester Incentive
                             /**   if(target.Target_Actual__r.RecordType.DeveloperName=='Conquest' && target.Target_Actual__r.Parameter_type__c!=null && target.Target_Actual__r.Market_ISO__c.equalsignorecase('SG') &&target.Target_Actual__r.Parameter_type__c.equalsignorecase('Conquest Semester')){
                                system.debug('Conquest Singapore semseter');
                                
                            }**/
                            //SG Raectivation 
                            //Boolean react= true;
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Reactivation' && target.Target_Actual__r.Market_ISO__c.equalsignorecase('SG') ){
                                system.debug('Enter reactivation');
                                //react=false;
                                system.debug('react bool'+target.Target_Actual__r.id);
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovIdMYNew.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.KPIParamName=kpiDetailMapNameMYNew.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                /* Decimal actual= target.Target_Actual__r.Actual__c;
actual=OrderLineItemTriggerhandler.roundingUP2DecimalPlaces(actual);*/
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                                
                            }
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Activation' && target.Target_Actual__r.Market_ISO__c.equalsignorecase('PH')){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                /* Decimal actual= target.Target_Actual__r.Actual__c;
actual=OrderLineItemTriggerhandler.roundingUP2DecimalPlaces(actual);*/
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            if(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c=='MX'){
                                
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                
                                SellerKPIDetailList.add(k);
                                
                            }
                            if(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c=='ISMS'){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('targetname'+target.Target_Actual__r.name);
                                system.debug('acheiem'+target.Target_Actual__r.Achievement__c);
                                SellerKPIDetailList.add(k);
                            }
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Coverage' && target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c=='Fusio Dose'){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                
                                SellerKPIDetailList.add(k);
                            }
                            if(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c=='Sales KPIs(Kera)'){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                
                                SellerKPIDetailList.add(k);
                            }
                            if(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c=='Extensioniste'){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.Product_Group__r.ivybase__Grouping_Type__c);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                
                                SellerKPIDetailList.add(k);
                            }
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Inventory_Check'){
                                KPIWrapper.SellerKPIDetail k=new KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.KPIParamName=kpiDetailMapName.get(target.Target_Actual__r.RecordType.DeveloperName);
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Account_Coverage__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                system.debug('k'+k);
                                SellerKPIDetailList.add(k); 
                            }
                            
                            if(target.Target_Actual__r.RecordType.DeveloperName=='Quantity'){
                                system.debug('targetname'+target.Target_Actual__r.name);
                                KPIWrapper.SellerKPIDetail k=new  KPIWrapper.SellerKPIDetail();
                                k.KPIId=KPIID;
                                k.KPIParamLovId=kpiDetailMapLovId.get('Variable- (LP: SMARTBOND)');
                                k.KPIParamName=kpiDetailMapName.get('Variable- (LP: SMARTBOND)');
                                k.Target=String.valueOf(target.Target_Actual__r.Target__c);
                                k.Achievement=String.valueOf(target.Target_Actual__r.Actual__c);
                                k.Incentive = String.valueOf(target.Target_Actual__r.Achievement__c);
                                
                                SellerKPIDetailList.add(k);
                            }
                            
                        }
                                if((Finalparameter!=null && Finalparameter!='')){
                               KPIWrapper.SellerKPIDetail k1=new KPIWrapper.SellerKPIDetail();
                                k1.KPIId=KPIID;
                                k1.KPIParamLovId=kpiDetailMapLovIdMYNew.get(Finalparameter);
                                k1.KPIParamName=kpiDetailMapNameMYNew.get(Finalparameter);
                                k1.Target=String.valueOf(totaltarget);
                                k1.Achievement=String.valueOf(totalactual);
                                k1.Incentive = String.valueOf(totalachievement);
                                system.debug('k1'+k1);
                                SellerKPIDetailList.add(k1);
                        }
                        System.debug('KIP Detail:: '+SellerKPIDetailList);
                        System.debug('KpiSkuDetail:: '+KpiSkuDetail);
                        KPIHeader.slerkpidetail=SellerKPIDetailList;  
                        KPIHeader.KpiSkuDetail=KpiSkuDetail;
                    }catch(Exception e){
                        system.debug('erro'+e.getMessage()+'line number'+e.getLineNumber() +'***'+e.getCause());
                    }
                    return KPIHeader;  
                }else{
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                    
                }
    }
}