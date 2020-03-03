//create turnovers
public class CreateTurnOverRecords {
    public static void createTurnOvers(list<Account> Accountlist,string MarketIso){
        system.debug('');
        //system.debug('SKUSaloonSalesList'+SKUSaloonSalesList);
        try{
            set<id> accid=new set<id>();
            for(Account a:Accountlist){
                accid.add(a.id);
                system.debug('accid'+accid);
            }
            Date todayDate = date.Today();
            string tdydate=string.valueOf(todayDate);//'2018-10-31';
            Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
            string mtdate=string.valueOf(Monthtodate);//'2018-01-01';
            list<AggregateResult> SKUSaloonSalesList;
            Map<String, Dates_Batches__c> vMapNameCustomSett = Dates_Batches__c.getAll();
            if(vMapNameCustomSett.containskey('skusaloon')){
                if(vMapNameCustomSett.get('skusaloon').StartDate__c!=null && vMapNameCustomSett.get('skusaloon').EndDate__c!=null){
                    date strtdate=vMapNameCustomSett.get('skusaloon').StartDate__c;
                    date enddate=vMapNameCustomSett.get('skusaloon').EndDate__c;
                    SKUSaloonSalesList=[select Resource__c,Account__c,InvoiceDate__c,sum(SaleAmount__c)amt, p.ivybase__Parent__c funid from SKU_SaloonSale__c s,s.Product_Master__r p where Account__c IN:accid AND Resource__c!=null AND Product_Master__c!=null AND  InvoiceDate__c>=:strtdate AND InvoiceDate__c<=:enddate group by InvoiceDate__c,Resource__c,Account__c,p.ivybase__Parent__c ];
                }
                else{
                    SKUSaloonSalesList=[select Resource__c,Account__c,InvoiceDate__c,sum(SaleAmount__c)amt, p.ivybase__Parent__c funid from SKU_SaloonSale__c s,s.Product_Master__r p where Account__c IN:accid AND Resource__c!=null AND Product_Master__c!=null AND  InvoiceDate__c>=:Monthtodate AND InvoiceDate__c<=:todayDate group by InvoiceDate__c,Resource__c,Account__c,p.ivybase__Parent__c ];
                }
            } else{
                SKUSaloonSalesList=[select Resource__c,Account__c,InvoiceDate__c,sum(SaleAmount__c)amt, p.ivybase__Parent__c funid from SKU_SaloonSale__c s,s.Product_Master__r p where Account__c IN:accid AND Resource__c!=null AND Product_Master__c!=null AND  InvoiceDate__c>=:Monthtodate AND InvoiceDate__c<=:todayDate group by InvoiceDate__c,Resource__c,Account__c,p.ivybase__Parent__c ];
            }
            system.debug('SKUSaloonSalesList'+SKUSaloonSalesList);
            set<id> tids=new set<id>();
            set<id> FunctionIds=new set<id>();
            set<id> ClassIds=new set<id>();
            set<id> Accountids=new set<id>();
            set<id> Resourceids=new set<id>();
            map<string,Turnover__c> Turonovermap=new map<string,Turnover__c>();
            map<id,Turnover__c>    ClassTurnovermap=new  map<id,Turnover__c>();
            map<string,Decimal> SalesvalueMap=new map<string,Decimal>();
            map<string,Decimal> FunctionSalesvalueMap=new map<string,Decimal>();
            map<string,Turnover__c> FuncturnoverClassMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> ClassturnoverSubaxeMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> SubaxeturnoverxeMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> NuanceturnoveraxeMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> ReferenceturnovernuanceMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> SubBrandturnoverreferenceMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> BrandturnoverSubbrandMap=new  map<string,Turnover__c>();
            map<string,Turnover__c> SignatureturnoverSubbrandMap=new  map<string,Turnover__c>();
            
            map<string,string> ProductHierarchyparent=new map<string,string>();
            list<Turnover__c> UpdateTurnOverlist=new list<Turnover__c>();
            
            
            //Querying all TurnOver records
            integer currentmonth=Date.Today().Month();
            integer currentyear=Date.Today().year();
            // integer Previousmonth=Date.Today().addmonths(-1).month();
            // integer Prepreviousmonth=Date.Today().addmonths(-2).month();
            //AND Resource__c='a0Y1H00000FJ0swUAD' AND Account__c='0011H00001T7vdKQAR'];
            
            system.debug('Turonovermap'+Turonovermap);
            //querying all producthierarchy records
            List<ivybase__Product_Hierarchy__c> ProductHierarchyList=ProductHierarchyService.getAllProductHierarchy_List1(MarketIso);
            for(ivybase__Product_Hierarchy__c p:ProductHierarchyList)
                ProductHierarchyparent.put(p.id, p.ivybase__Parent__c);
            
            //Iterating over skusaloon and mapping function and total sales
            for(AggregateResult ar:SKUSaloonSalesList){
                FunctionIds.add((String)ar.get('funid'));
                Accountids.add((Id)ar.get('Account__c'));
                Resourceids.add((Id)ar.get('Resource__c'));
                date d=(Date)ar.get('InvoiceDate__c');
                integer month=d.month();
                integer year=d.year();
                system.debug('m'+month);
                // string s=(String)ar.get('funid')+(String)ar.get('funid');
                if(SalesvalueMap.containskey((String)ar.get('funid')+'.'+(String)ar.get('Account__c')+'.'+ month+'.'+(String)ar.get('Resource__c')+'.'+ year)){
                    decimal val=SalesvalueMap.get((String)ar.get('funid')+'.'+(String)ar.get('Account__c')+'.'+ month+'.'+(String)ar.get('Resource__c')+'.'+ year)+(Decimal)ar.get('amt');
                    SalesvalueMap.put((String)ar.get('funid')+'.'+(String)ar.get('Account__c')+'.'+ month+'.'+(String)ar.get('Resource__c')+'.'+ year, val);
                }   else{
                    SalesvalueMap.put((String)ar.get('funid')+'.'+(String)ar.get('Account__c')+'.'+ month+'.'+(String)ar.get('Resource__c')+'.'+ year, (Decimal)ar.get('amt'));
                }
            }
            list<Turnover__c> TurnOverList;
            if(vMapNameCustomSett.containskey('TurnOverMonth')){
                if(vMapNameCustomSett.get('TurnOverMonth').Month__c!=null){
                   decimal Monthcurrent=vMapNameCustomSett.get('TurnOverMonth').Month__c;
                   TurnOverList=[select id,Product_Hierarchy__c,Year__c,Month__c,Account__c,Resource__c,Product_Hierarchy__r.ivybase__Parent__c,Sales_Value__c,Product_Hierarchy__r.RecordType.Name from Turnover__c where Resource__c!=null AND Account__c in:Accountids AND Month__c<=:Monthcurrent AND Year__c=:currentyear]; 
                }else{
                 TurnOverList=[select id,Product_Hierarchy__c,Year__c,Month__c,Account__c,Resource__c,Product_Hierarchy__r.ivybase__Parent__c,Sales_Value__c,Product_Hierarchy__r.RecordType.Name from Turnover__c where Resource__c!=null AND Account__c in:Accountids AND Month__c=:currentmonth AND Year__c=:currentyear];//AND Account__c in:Accountids
                }
            }
            else{
             TurnOverList=[select id,Product_Hierarchy__c,Year__c,Month__c,Account__c,Resource__c,Product_Hierarchy__r.ivybase__Parent__c,Sales_Value__c,Product_Hierarchy__r.RecordType.Name from Turnover__c where Resource__c!=null AND Account__c in:Accountids AND Month__c=:currentmonth AND Year__c=:currentyear];//AND Account__c in:Accountids
            }
                system.debug('SalesvalueMap'+SalesvalueMap); 
            for(Turnover__c turnover:TurnOverList){
                //if(Accountids.contains(turnover.Account__c))
                turnover.Sales_Value__c=0;
                UpdateTurnOverlist.add(turnover);
                Turonovermap.put(turnover.Product_Hierarchy__c+'.'+turnover.Account__c+'.'+turnover.Month__c+'.'+turnover.Resource__c+'.'+turnover.Year__c, turnover);
            }
            //iterating over functionids and checking whetehr turnover is there or not if not there, we are craeting a one
            for(string functionAccountid:SalesvalueMap.keyset()){
                system.debug('functionAccountid'+functionAccountid);
                string[] s=functionAccountid.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(functionAccountid)){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c=SalesvalueMap.get(functionAccountid);
                        t.Product_Hierarchy__c=s[0];
                        t.Account__c=s[1];
                        t.Month__c=Decimal.valueof(s[2]);
                        t.Resource__c=s[3];
                        t.Year__c=Decimal.valueof(s[4]);
                        if(ProductHierarchyparent.containsKey(s[0])==true && ProductHierarchyparent.get(s[0])!=null){
                            FuncturnoverClassMap.put(s[0]+'.'+ProductHierarchyparent.get(s[0])+'.'+s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4],t); //pattern is current producthierarchy.itsparent.account.month.resource.year  
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('presales'+Turonovermap.get(functionAccountid).Sales_Value__c);
                        system.debug('current'+SalesvalueMap.get(functionAccountid));
                        Turonovermap.get(functionAccountid).Sales_Value__c=  Turonovermap.get(functionAccountid).Sales_Value__c+SalesvalueMap.get(functionAccountid);
                        if(ProductHierarchyparent.containsKey(s[0])==true && ProductHierarchyparent.get(s[0])!=null){
                            FuncturnoverClassMap.put(s[0]+'.'+ProductHierarchyparent.get(s[0])+'.'+s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4], Turonovermap.get(functionAccountid));   
                        }
                        //UpdateTurnOverlist.add( Turonovermap.get(functionAccountid));
                    }
                }
                else{
                    Turnover__c t=new Turnover__c(); 
                    t.Sales_Value__c=SalesvalueMap.get(functionAccountid);
                    t.Product_Hierarchy__c=s[0];
                    t.Account__c=s[1];
                    t.Month__c=Decimal.valueof(s[2]);
                    t.Resource__c=s[3];
                    t.Year__c=Decimal.valueof(s[4]);
                    if(ProductHierarchyparent.containsKey(s[0])==true && ProductHierarchyparent.get(s[0])!=null){
                        FuncturnoverClassMap.put(s[0]+'.'+ProductHierarchyparent.get(s[0])+'.'+s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4],t);   
                    }
                    Turonovermap.put(s[0]+'.'+s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4],t);
                    UpdateTurnOverlist.add(t);
                }
            }
            //iterating over classids and checking whetehr turnover is there por not if not there we are craeting a one
            system.debug('FuncturnoverClassMapsize'+FuncturnoverClassMap.size());
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            for(string classAccountID:FuncturnoverClassMap.keyset()){
                string[] s=classAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        system.debug('d');
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= FuncturnoverClassMap.get(classAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(classAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            ClassturnoverSubaxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        
                        system.debug('presalesva'+Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        system.debug('currentsalevalue'+FuncturnoverClassMap.get(classAccountID).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+FuncturnoverClassMap.get(classAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            ClassturnoverSubaxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        //UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2])); 
                        system.debug('ClassturnoverSubaxeMap'+ClassturnoverSubaxeMap);
                    }
                }
                else{
                    Turnover__c t=new Turnover__c(); 
                    t.Sales_Value__c=FuncturnoverClassMap.get(classAccountID).Sales_Value__c;
                    t.Product_Hierarchy__c=s[1];
                    t.Account__c=s[2];
                    t.Month__c=Decimal.valueof(s[3]);
                    t.Resource__c=s[4];//+'.'+s[5]
                    t.Year__c=Decimal.valueof(s[5]);
                    Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                    Turonovermap.put(s[0]+'.'+s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                    FuncturnoverClassMap.put(t.Product_Hierarchy__r.ivybase__Parent__c,t);   
                    UpdateTurnOverlist.add(t);
                }  
            }
            
            //iterating over SubAxeids and checking whether turnover is there por not if not there we are craeting a one
            system.debug('ClassturnoverSubaxeMap.keyset()'+ClassturnoverSubaxeMap.keyset());  
            system.debug('ClassturnoverSubaxeMap'+ClassturnoverSubaxeMap);
            for(string SubAxeAccountID:ClassturnoverSubaxeMap.keyset()){
                system.debug('ClassturnoverSubaxeMap.get'+ClassturnoverSubaxeMap.get(SubAxeAccountID));
                string[] s=SubAxeAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(SubAxeAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            SubaxeturnoverxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            SubaxeturnoverxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        //UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2])); 
                        system.debug('SubaxeturnoverxeMap'+SubaxeturnoverxeMap);
                    }
                }
                
            }
            
            //iterating over Axeids and checking whether turnover is there or not if not there we are craeting a one
            system.debug('SubaxeturnoverxeMap.keyset()'+SubaxeturnoverxeMap.keyset());  
            system.debug('SubaxeturnoverxeMap'+SubaxeturnoverxeMap.size());
            for(string AxeAccountID:SubaxeturnoverxeMap.keyset()){
                system.debug('ClassturnoverSubaxeMap.get'+SubaxeturnoverxeMap.get(AxeAccountID));
                string[] s=AxeAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= SubaxeturnoverxeMap.get(AxeAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];//+'.'+s[5]
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(AxeAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            NuanceturnoveraxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+SubaxeturnoverxeMap.get(AxeAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+SubaxeturnoverxeMap.get(AxeAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            NuanceturnoveraxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        //UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2])); 
                    }
                }
                
            }
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            for(string NuanceAccountID:NuanceturnoveraxeMap.keyset()){
                system.debug('NuanceturnoveraxeMap.get'+NuanceturnoveraxeMap.get(NuanceAccountID));
                string[] s=NuanceAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= NuanceturnoveraxeMap.get(NuanceAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];//+'.'+s[5]
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(NuanceAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            ReferenceturnovernuanceMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+NuanceturnoveraxeMap.get(NuanceAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+NuanceturnoveraxeMap.get(NuanceAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            ReferenceturnovernuanceMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        // UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2]));   
                    }
                }
                
            }
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            for(string ReferenceAccountID:ReferenceturnovernuanceMap.keyset()){
                system.debug('ReferenceturnovernuanceMap.get'+ReferenceturnovernuanceMap.get(ReferenceAccountID));
                string[] s=ReferenceAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= ReferenceturnovernuanceMap.get(ReferenceAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];//+'.'+s[5]
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(ReferenceAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            SubBrandturnoverreferenceMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+ReferenceturnovernuanceMap.get(ReferenceAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+ReferenceturnovernuanceMap.get(ReferenceAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            SubBrandturnoverreferenceMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        // UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2]));  
                    }
                }
                
            }
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            for(string SubbrandAccountID:SubBrandturnoverreferenceMap.keyset()){
                system.debug('SubBrandturnoverreferenceMap.get'+SubBrandturnoverreferenceMap.get(SubbrandAccountID));
                string[] s=SubbrandAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= SubBrandturnoverreferenceMap.get(SubbrandAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];//+'.'+s[5]
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(SubbrandAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            BrandturnoverSubbrandMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+SubBrandturnoverreferenceMap.get(SubbrandAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+SubBrandturnoverreferenceMap.get(SubbrandAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            BrandturnoverSubbrandMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        // UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2]));   
                    }
                }
                
            }
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            system.debug('UpdateTurnOverlistsize'+UpdateTurnOverlist.size());
            
            for(string brandAccountID:BrandturnoverSubbrandMap.keyset()){
                system.debug('SubBrandturnoverreferenceMap.get'+BrandturnoverSubbrandMap.get(brandAccountID));
                string[] s=brandAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= BrandturnoverSubbrandMap.get(brandAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];//+'.'+s[5]
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(brandAccountID, t);
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            SignatureturnoverSubbrandMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5],t);   
                        }
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+BrandturnoverSubbrandMap.get(brandAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+BrandturnoverSubbrandMap.get(brandAccountID).Sales_Value__c;
                        if(ProductHierarchyparent.containsKey(s[1])==true && ProductHierarchyparent.get(s[1])!=null){
                            SignatureturnoverSubbrandMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]));   
                        }
                        // UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2]));   
                    }
                }
                
            }
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            for(string signatureAccountID:SignatureturnoverSubbrandMap.keyset()){
                
                system.debug('SubBrandturnoverreferenceMap.get'+SignatureturnoverSubbrandMap.get(signatureAccountID));
                string[] s=signatureAccountID.split('\\.');
                if(Turonovermap.size()>0){ 
                    if(!Turonovermap.keyset().contains(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5])){
                        system.debug('new');
                        Turnover__c t=new Turnover__c(); 
                        t.Sales_Value__c= SignatureturnoverSubbrandMap.get(signatureAccountID).Sales_Value__c;
                        t.Product_Hierarchy__c=s[1];
                        t.Account__c=s[2];
                        t.Month__c=Decimal.valueof(s[3]);
                        t.Resource__c=s[4];
                        t.Year__c=Decimal.valueof(s[5]);
                        Turonovermap.put(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5], t);
                        Turonovermap.put(signatureAccountID, t);
                        // SubaxeturnoverxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2],t);   
                        UpdateTurnOverlist.add(t);
                    }
                    else{
                        system.debug('ClassturnoverSubaxeMap.get(SubAxeAccountID).Sales_Value__c'+SignatureturnoverSubbrandMap.get(signatureAccountID).Sales_Value__c);
                        system.debug(' Turonovermapvalues'+ Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c);
                        Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c= Turonovermap.get(s[1]+'.'+s[2]+'.'+s[3]+'.'+s[4]+'.'+s[5]).Sales_Value__c+SignatureturnoverSubbrandMap.get(signatureAccountID).Sales_Value__c;
                        // SubaxeturnoverxeMap.put(s[1]+'.'+ProductHierarchyparent.get(s[1])+'.'+s[2], Turonovermap.get(SubAxeAccountID));   
                        //UpdateTurnOverlist.add(Turonovermap.get(s[1]+'.'+s[2]));   
                    }
                }
                
            }
            
            system.debug('UpdateTurnOverlist'+UpdateTurnOverlist);
            system.debug('UpdateTurnOverlistsize'+UpdateTurnOverlist.size());
            for(Turnover__c t:UpdateTurnOverlist)
                tids.add(t.id);
            system.debug('tsize'+tids.size());
            //updating
            if(UpdateTurnOverlist.size()>0){
                upsert UpdateTurnOverlist;
                
                UpdateTurnOverlist.clear();
            }
            
            
        }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage()+'--'+e.getLineNumber());
        }
    }
    
   
    
    
    
}