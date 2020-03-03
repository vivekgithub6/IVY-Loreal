public class AverageTurnoverPerRep {
   /* public static KPIWrapper.SellerKPI TurnOverPerRep (KPIWrapper.SellerKPI TotalWrapper,map<string,ivybase__Standard_List_Master__c> standardlistLOVId,string divisionname){
        id resid=ResourceService.getLoginSellerId();
        list<ivybase__Location_Hierarchy__c> loctritoryidlist=LocationMasterService.getUserTerritory();
        id loctritoryid;
        if(loctritoryidlist.size()>0){
         loctritoryid=loctritoryidlist[0].id;
        }
        system.debug('resid'+resid);
        Date todayDate = date.Today();
        date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        Integer Monthrec = todayDate.month();
        
        map<id,division__c> divMap= new map<id,division__c>();
        list<division__c> divsionlist= [select id,name,Internal_Id__c from Division__c];
        for(Division__c div:divsionlist){
            divMap.put(div.id,div);
        }
        
        map<id,set<id>> divloctionmap= new map<id,set<id>>();
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
        id mydisvisionid =getdivisionforlocation(divloctionmap,loctritoryid);
        Aggregateresult [] TurnovrAggresult =[Select sum(SaleAmount__c)amt,Product_Master__r.Division__c pdiv from SKU_SaloonSale__c where Product_Master__r.Division__c!=null AND Product_Master__r.Division__c=:mydisvisionid AND (InvoiceDate__c>=: Monthtodate AND InvoiceDate__c<=:todayDate) group by Product_Master__r.Division__c  ];
        system.debug('Turnovr'+TurnovrAggresult);
        
        Decimal avrgesale=0;
        if(TurnovrAggresult.size()>0){
            for(Aggregateresult agg:TurnovrAggresult){
                system.debug('inside fro loop rrep');
                if(divloctionmap!=null){
                if(divloctionmap.containskey((String)agg.get('pdiv'))){
                    if(divloctionmap.containskey((String)agg.get('pdiv'))&& divloctionmap.get((String)agg.get('pdiv'))!=null && divloctionmap.get((String)agg.get('pdiv')).size()!=0 && divloctionmap.get((String)agg.get('pdiv')).size()!=null && (Decimal)agg.get('amt')!=null){
                        avrgesale=+((Decimal)agg.get('amt')/divloctionmap.get((String)agg.get('pdiv')).size());
                        system.debug('avrgesale'+(Decimal)agg.get('amt')/divloctionmap.get((String)agg.get('pdiv')).size());
                    }
                    
                } 
                }
            }
        }
        else{
            avrgesale=0;
            system.debug('avrgesale'+avrgesale);
        }
        KPIWrapper.SellerKPI selerkpi= TotalWrapper;        
        list<KPIWrapper.SellerKPIDetail> skpidetaillist= TotalWrapper.slerkpidetail;
        KPIWrapper.SellerKPIDetail skpidetail = new KPIWrapper.SellerKPIDetail();
        skpidetail.KPIId=selerkpi.KPIId;
        if(standardlistLOVId!=null && standardlistLOVId.containskey('Average Turnover per Rep'+'.'+divisionname)){
            skpidetail.KPIParamName=standardlistLOVId.get('Average Turnover per Rep'+'.'+divisionname).ivybase__List_Name__c;
            skpidetail.KPIParamLovId=standardlistLOVId.get('Average Turnover per Rep'+'.'+divisionname).Name;   
        }
        else{
            skpidetail.KPIParamName='';
            skpidetail.KPIParamLovId='';
        }
        skpidetail.Target='';
        skpidetail.Achievement=string.valueof(avrgesale);
        skpidetail.Incentive='';
        skpidetail.Flex1='';
        skpidetaillist.add(skpidetail);
        
        selerkpi.slerkpidetail=skpidetaillist;
        
        return selerkpi;
        
    }*/
    
    public static id getdivisionforlocation( map<id,set<id>> divloc,id locid){
        for(id divid:divloc.keyset()){
            if(divloc.get(divid).contains(locid)){
                return  divid;
            }
        }
        return null;
    }
}