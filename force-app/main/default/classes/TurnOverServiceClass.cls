public class TurnOverServiceClass{
   public static  KPIWrapper.SellerKPI getTurnOvers(){
        KPIWrapper.SellerKPI KPIHeader= new KPIWrapper.SellerKPI();
       // list<KPIWrapper.SellerKPIDetail>  SellerKPIDetail=new list<KPIWrapper.SellerKPIDetail> ();
        list<KPIWrapper.SellerKPISKUDetail> KpiSkuDetail=new list<KPIWrapper.SellerKPISKUDetail>();
        list<KPIWrapper.SellerMessageBoard> KPISellerMessageBoard=new  list<KPIWrapper.SellerMessageBoard>();
        map<string,ivybase__Standard_List_Master__c> ProducthierarchyLOVId=new map<string,ivybase__Standard_List_Master__c>();
        map<string,ivybase__Standard_List_Master__c> ProducthierarchyRecordtypeIdLOVId=new map<string,ivybase__Standard_List_Master__c>();
        map<string,string> Productheirarchyidinternalidmap=new map<string,string>();
        map<string,string> SubaxenameLovIdMap=new  map<string,string>();
      set<id> ProducthierachyIds=new set<id>();
        //KPI parameters
        string KPIID;
        string KPIParamLovId;
        string KPIParamName;
        string userId;
        string divisionname;
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
        String[] TURNOVERFields = new String[]{'Sales_Value__c','Product_Hierarchy__c','Month__c'};
            
            if(SecurityUtility.checkIsAccessible('Turnover__c', TURNOVERFields)){
                try{
                    user u=[select ivybase__Internal_Id__c,id from user where id=:userinfo.getUserId()];
                    userId=string.valueOf(u.ivybase__Internal_Id__c);
                string resid= ResourceService.getSellerId(u.id).id;
                    string divisionid;
                    set<id> SKUIDs=new set<id>();
                     set<id> SubAxeIds=new set<id>();
                   map<string,string> GetResourceDivisionmap= ResourceService.GetAllResourceDivisionmap();
                    for(string s:GetResourceDivisionmap.keyset())
                        divisionid=s;
                    system.debug('divisionid'+divisionid);
                    list<ivybase__Product__c> SKUList=[select id from ivybase__Product__c where Division__c=:divisionid and ivybase__Parent__r.recordtype.developername='Function'];
                    for(ivybase__Product__c p:SKUList)
                        SKUIDs.add(p.id);
                    system.debug('SKUIDs'+SKUIDs);
                   map<string,string> getAllsubbrand_MAP_For_The_SKU =ProductHierarchyService.getAllProductHierarchy_MAP_For_The_SKU(SKUIDs,'subaxe');
                    for(string s:getAllsubbrand_MAP_For_The_SKU.keyset())
                        SubAxeIds.add(getAllsubbrand_MAP_For_The_SKU.get(s));
                    system.debug('SubAxeIds'+SubAxeIds.size());
                    list<Turnover__c>  turnOverList=[select  Sales_Value__c,Product_Hierarchy__r.ivybase__Internal_Id__c,Product_Hierarchy__r.name  from Turnover__c where Month__c=:Date.Today().Month() AND Year__c=:Date.Today().Year() and Product_Hierarchy__r.RecordType.developerName='Sub_Axe'  and Resource__c=:resid];//and Product_Hierarchy__c in:SubAxeIds
                    system.debug('turnOverList'+turnOverList);
                      
                    
                    //getting divisions
                     
                          map<string,string> GetAllResourcesDivisons= ResourceService.GetAllResourceDivisionmap();
                        for(string sd:GetAllResourcesDivisons.keyset()){
                            divisionname=GetAllResourcesDivisons.get(sd);
                             }
                        system.debug('divisionname'+divisionname);
                         //geting lovids
                    for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('KPI_TYPE'),('KPI_DETAIL_TYPE'),('SUB_AXE_LEVEL')})){
                        if(stdListMaster.ivybase__List_Code__c=='Turnover' && stdListMaster.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname)
                            KPIID=  (string)stdListMaster.Name;
                        if(stdListMaster.ivybase__List_Code__c=='Sub Axe' && stdListMaster.ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c==divisionname){
                            KPIParamLovId=  (string)stdListMaster.Name;
                            KPIParamName= (string)stdListMaster.ivybase__List_Name__c;
                        }
                        if(stdListMaster.ivybase__List_Type__c=='SUB_AXE_LEVEL'){
                           SubaxenameLovIdMap.put(stdListMaster.ivybase__List_Name__c.toLowerCase(), stdListMaster.Name); 
                        }
                    }
                    system.debug('SubaxenameLovIdMap'+SubaxenameLovIdMap);
                      system.debug('turnkppid'+KPIID);
                    system.debug('subKPIParamLovId'+KPIParamLovId);
                    system.debug('KPIParamName'+KPIParamName);
                    //FOrming KPI header
                    KPIHeader.KPIId=KPIID;
                    KPIHeader.UserId=userId;
                    KPIHeader.FromDate=fromdate.format('yyyy/MM/dd');
                    KPIHeader.ToDate=todate.format('yyyy/MM/dd');
                    //Formign KPI SKU Detail
                    for(Turnover__c turnover:turnOverList){
                        system.debug('turnover value'+turnover.Sales_Value__c);
                        KPIWrapper.SellerKPISKUDetail k=new KPIWrapper.SellerKPISKUDetail();
                        k.KPIId=KPIID;
                        k.KPIParamLovId=KPIParamLovId;
                        k.KPIParamName=KPIParamName;
                        // system.debug('t.Product_Hierarchy__r.ivybase__Internal_Id__c'+t.Product_Hierarchy__r.ivybase__Internal_Id__c);
                        k.pid=turnover.Product_Hierarchy__r.ivybase__Internal_Id__c;
                        k.Achievement=string.valueof(turnover.Sales_Value__c);
                        system.debug('nameprod'+turnover.Product_Hierarchy__r.name+SubaxenameLovIdMap.get(turnover.Product_Hierarchy__r.name));
                        k.SubAxeId=SubaxenameLovIdMap.get(turnover.Product_Hierarchy__r.name.toLowerCase());
                        system.debug('k'+k);
                        KpiSkuDetail.add(k);
                    }
                    KPIHeader.KpiSkuDetail=KpiSkuDetail;     
                    
                }
                Catch(Exception e){
                    system.debug('erromessage'+e.getMessage());
                }
                return KPIHeader;
            }
        else {
            
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
        
    }
}