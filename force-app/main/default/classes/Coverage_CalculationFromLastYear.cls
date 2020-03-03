/*
* Block comments with details of changes
*/
global class Coverage_CalculationFromLastYear
{
    global static void makeCalculationForCoverage(List<Target_Actual__c> scope){
      /*  List<Target_Actual__c> UpdateTargetList = new list<Target_Actual__c>();
        date PgroupStartdate;
        date PgroupEnddate;
        Decimal BuyLogicValue;
        string BuyLogic;
        set<id> newlaunchSkuId= new set<id>();
        set<id> prodhirId= new set<id>();
        set<id> AccountSKUIds=new set<id>();
        Map<id,set<id>> AccountSkuMap= new Map<id,set<id>>();
        Map<Id,String> AccountIdNameMap = new Map<Id,String>();
        Map<id,set<id>> productdatarelatedtoHirarchy= new Map<id,set<id>>();

        if(scope.size()>0){
            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:scope[0].Incentive_Group__c];

            //querying product group based on Target Actual prd grp id with including start date and end date.
            list<ivybase__Product_Group_Detail__c> prdgrpdetails=[select id,Product_Hierarchy__c,ivybase__Product__c,ivybase__Product_Group__r.Buy_Logic_Value__c,ivybase__Product_Group__r.ivybase__Start_Date__c,ivybase__Product_Group__r.ivybase__End_Date__c,ivybase__Product_Group__r.Buy_Logic__c,ivybase__Product_Group__c 
                                                                  from ivybase__Product_Group_Detail__c 
                                                                  where  ivybase__Product_Group__c=:scope[0].Product_Group__c ];
            if(prdgrpdetails.size()>0){
                PgroupStartdate=prdgrpdetails[0].ivybase__Product_Group__r.ivybase__Start_Date__c;
                PgroupEnddate= prdgrpdetails[0].ivybase__Product_Group__r.ivybase__End_Date__c;  
            }
            //forming set of new Launch Skus id.
            for(ivybase__Product_Group_Detail__c PGD:prdgrpdetails){
                if(PGD.ivybase__Product__c!=null){
                    newlaunchSkuId.add(PGD.ivybase__Product__c);
                    if(pgd.Product_Hierarchy__c!=null)prodhirId.add(pgd.Product_Hierarchy__c);
                    if(PGD.ivybase__Product_Group__r.Buy_Logic_Value__c!=null)BuyLogicValue=pgd.ivybase__Product_Group__r.Buy_Logic_Value__c;
                    if(PGD.ivybase__Product_Group__r.Buy_Logic__c!=null)BuyLogic=pgd.ivybase__Product_Group__r.Buy_Logic__c;
                }
            } 
            ///end of for loop
            if(prodhirId.size()>0){
                productdatarelatedtoHirarchy = ProductHierarchyService.getAlltheProductUnderProductHierarchywithSetOfPHId(prodhirId);

            }
            if(productdatarelatedtoHirarchy!=null){
                newlaunchSkuId.addall(productdatarelatedtoHirarchy.keyset());
            }
            //Querying sku saloons created today ,this is for coverage  calculations 
            list<SKU_SaloonSale__c> SKUSaloonSaleList=[select Product_Master__c,Account__r.name,Account__c,InvoiceDate__c,Resource__c from SKU_SaloonSale__c where InvoiceDate__c >=:PgroupStartdate AND InvoiceDate__c <=:PgroupEnddate AND Resource__c=:scope[0].Resource__c AND Product_Master__c IN:newlaunchSkuId];
            if(SKUSaloonSaleList.size()>0){
                for(SKU_SaloonSale__c skusal:SKUSaloonSaleList){
                    AccountIdNameMap.put(skusal.Account__c,skusal.Account__r.name);
                    if(AccountSkuMap.containskey(skusal.Account__c)){
                        AccountSkuMap.get(skusal.Account__c).add(skusal.Product_Master__c);
                    }else{
                        set<id> skuid= new set<id>();
                        skuid.add(skusal.Product_Master__c); 
                        AccountSkuMap.put(skusal.Account__c,skuid);
                    }
                }
            }
            set<id> satisfiedAccounts= new set<id>();
            if(AccountSkuMap!=null){
                for(id accid:AccountSkuMap.keyset()){
                    if(BuyLogic!=null && BuyLogic=='ALL'){
                        if(newlaunchSkuId.size()>0 && AccountSkuMap.containskey(accid)){
                            if( AccountSkuMap.get(accid).containsAll(newlaunchSkuId)){
                                satisfiedAccounts.add(accid); 
                            }
                        }
                    }
                    else if(BuyLogic!=null && BuyLogic=='ANY' && AccountSkuMap.containskey(accid) ){
                        AccountSKUIds.addall(accountSkuMap.get(accid));
                        integer SKUIDSize=newlaunchSkuId.size();//prodskuId = prdgrp prdcts+Hirarrchy prdcts
                        integer AccountSKUIdSize=AccountSkuMap.get(accid).size();
                        newlaunchSkuId.addall(accountSkuMap.get(accid));
                        integer AllSKUIdssize=newlaunchSkuId.size();// this line has all skus which are from PG and Acount sKU level
                        system.debug('AllSKUIdssize'+AllSKUIdssize);
                        integer diff=(SKUIDSize+AccountSKUIdSize)-AllSKUIdssize;
                        if(diff>=BuyLogicValue){
                            satisfiedAccounts.add(accid); 
                        }
                    }
                }
            }
            system.debug('satisfiedAccounts'+satisfiedAccounts);
            set<Id> exisitingAccount = new Set<Id>();
            set<id> accountoftotalcounttilldate= new set<id>();
            List<Account_Target__c> AccountCaptured = [select id,Account__c,Target_Actual__c from Account_Target__c where Target_Actual__c=:scope[0].id];
            for(Account_Target__c acc:AccountCaptured)
            {
                exisitingAccount.add(acc.Account__c);  
                accountoftotalcounttilldate.add(acc.Account__c);
            }
            system.debug('accountoftotalcounttilldate'+accountoftotalcounttilldate);
            system.debug('accountoftotalcounttilldate size before'+accountoftotalcounttilldate.size());
            accountoftotalcounttilldate.addall(satisfiedAccounts);
            system.debug('accountoftotalcounttilldate'+accountoftotalcounttilldate);
            system.debug('accountoftotalcounttilldate size after'+accountoftotalcounttilldate.size());
            List<Account_Target__c> toInsert = new List<Account_Target__c>();
            //itreating on satisfied accounts aand check with existed if its not there then created
            for(id Accnts:satisfiedAccounts){
                if(!exisitingAccount.contains(Accnts)){
                    Account_Target__c accTar = new Account_Target__c();
                    accTar.Account__c=Accnts;
                    accTar.Target_Actual__c=scope[0].id;
                    if(AccountIdNameMap.containskey(Accnts))
                    {   
                        accTar.Name=AccountIdNameMap.get(Accnts);
                    }
                    toInsert.add(accTar);
                }
            }
            if(toInsert.size()>0){
                database.insert(toInsert);
            }

            for(Target_Actual__c tact:scope){
                tact.Achievement__c=0;
                if(tact.Target__c>0){
                    decimal coveredcomparision=(accountoftotalcounttilldate.size()/tact.Target__c)*100;
                    tact.Achievement__c=  ConquestBatch_MY.getincnetive(incentiveslab,coveredcomparision);
                    UpdateTargetList.add(tact) ;
                }
            }

            if(UpdateTargetList.size()>0){
                update UpdateTargetList;
            }
        }*/ //end of scopee
    }

    /******************************
starting the top 20 calculation

***************************************************/


      global static void Top20calculationforSG(List<Target_Actual__c> scope) {
        if(scope.size()>0){
            list<Target_Actual__c> updatetalist = new list<Target_Actual__c>();
            Map<id,set<id>> accountSkuMap = new map<id,set<id>>();
            Map<id,string> AccountIdNameMap= new Map<id,string>();
            set<id> AccountIdset= new set<id>();
            date PgroupStartdate;
            date PgroupEnddate;
            set<id> newlaunchSkuId= new set<id>();
            Decimal BuyLogicValue;
            string BuyLogic;
            set<id> totalAcntcovered = new set<id>();//used to hold the account covered id set for this quarter
            list<Account_Target__c> AccountTargetList= new list<Account_Target__c>();
            id incentivegroupid;
            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:incentivegroupid ];
            //querying product group based on Target Actual prd grp id with including start date and end date.
            list<ivybase__Product_Group_Detail__c> prdgrpdetails=[select id,Product_Hierarchy__c,ivybase__Product__c,ivybase__Product_Group__r.Buy_Logic_Value__c,ivybase__Product_Group__r.ivybase__Start_Date__c,ivybase__Product_Group__r.ivybase__End_Date__c,ivybase__Product_Group__r.Buy_Logic__c,ivybase__Product_Group__c 
                                                                  from ivybase__Product_Group_Detail__c 
                                                                  where  ivybase__Product_Group__c=:scope[0].Product_Group__c ];
            if(prdgrpdetails.size()>0){
                PgroupStartdate=prdgrpdetails[0].ivybase__Product_Group__r.ivybase__Start_Date__c;
                PgroupEnddate= prdgrpdetails[0].ivybase__Product_Group__r.ivybase__End_Date__c;  
            }
            for(ivybase__Product_Group_Detail__c PGD:prdgrpdetails){
                if(PGD.ivybase__Product__c!=null){
                    newlaunchSkuId.add(PGD.ivybase__Product__c);
                    if(PGD.ivybase__Product_Group__r.Buy_Logic_Value__c!=null)BuyLogicValue=pgd.ivybase__Product_Group__r.Buy_Logic_Value__c;
                    if(PGD.ivybase__Product_Group__r.Buy_Logic__c!=null)BuyLogic=pgd.ivybase__Product_Group__r.Buy_Logic__c;
                }
            }
            map<id,set<id>> accuntskuMap= new map<id,set<id>>();
            //Querying sku saloons created today ,this is for coverage  calculations 
            list<AggregateResult> SKUSaloonSaleList = new list<AggregateResult> ();

            SKUSaloonSaleList=[select Product_Master__c,sum(Quantity__c) qtysm,Account__c,Account__r.name nam from 
                               SKU_SaloonSale__c 
                               where Product_Master__c IN:newlaunchSkuId AND InvoiceDate__c >=: scope[0].Start_Date1__c AND InvoiceDate__c <=:scope[0].End_Date1__c  AND Resource__c=:scope[0].Resource__c
                               group by Product_Master__c,Account__c,Account__r.name ];
            system.debug('SKUSaloonSaleList'+SKUSaloonSaleList);
            if(SKUSaloonSaleList.size()>0){
                for(AggregateResult skusal:SKUSaloonSaleList){
                    if((decimal)skusal.get('qtysm')>=BuyLogicValue){//BuyLogicValue
                        if(accuntskuMap.containskey((id)skusal.get('Account__c'))){
                            accuntskuMap.get((id)skusal.get('Account__c')).add((id)skusal.get('Product_Master__c'));
                        }else{
                        set<id> setskuids= new set<id>();
                            setskuids.add((id)skusal.get('Product_Master__c'));
                            accuntskuMap.put((id)skusal.get('Account__c'),setskuids);
                        }
                    }

                    //AccountIdset.add((id)skusal.get('Account__c'));
                    AccountIdNameMap.put((id)skusal.get('Account__c'),(string)skusal.get('nam'));

                }
                system.debug('accuntskuMap'+accuntskuMap);
                if(accuntskuMap!=null){
                    for(id accid:accuntskuMap.keyset()){
                        if(accuntskuMap.get(accid)!=null && accuntskuMap.get(accid).containsAll(newlaunchSkuId)){//.containsAll
                            AccountIdset.add(accid);
                        }
                    }
                }
                system.debug('AccountIdset'+AccountIdset);
                //querying exits account coveered records
                set<id> existingAccountcoveredIds= new set<id>();
                list<Account_Target__c> AccountTarget=[select Account__c,Target_Actual__c,Product_Group__c,Target_Actual__r.Recordtype.developername,Target_Actual__r.Resource__c from Account_Target__c where Target_Actual__c=:scope[0].id ];
                for(Account_Target__c ATC:AccountTarget){
                    existingAccountcoveredIds.add(ATC.Account__c);
						totalAcntcovered.add(ATC.Account__c);
                }
                //totalAcntcovered.addall(existingAccountcoveredIds);//adding all Coverd Ids till now
                totalAcntcovered.addall(AccountIdset); //which holds all count of satisfied accounts including existing

                if(AccountIdset.size()>0){
                    for(id AccountId:AccountIdset){
                       // if(BuyLogic!=null && BuyLogic.equalsignorecase('ALL')){
                            if(!existingAccountcoveredIds.contains(AccountId)){
                                Account_Target__c Accounttarget1=new Account_Target__c();
                                Accounttarget1.Account__c=AccountId;
                                if(AccountIdNameMap.containsKey(AccountId)) Accounttarget1.name= AccountIdNameMap.get(AccountId);
                                Accounttarget1.Target_Actual__c=scope[0].id;
                                Accounttarget1.Product_Group__c=scope[0].Product_Group__c;
                                //Accounttarget.month__c= todayDate.Month();
                                AccountTargetList.add(Accounttarget1); 
                            }
                        //} 
                    }
                }
                if(AccountTargetList.size()>0){
                    database.insert(AccountTargetList);
                }

                /**list<Target_Actual__c> LatestTarActualdata=[select id,Resource__c,Target__c,Achievement__c,Account_Coverage__c,Year__c,Product_Group__c,Product_Group__r.ivybase__Grouping_Type__c
                                                            from Target_Actual__c where id=:scope[0].id];**/
                for(Target_Actual__c Targetactul:scope){
                    //Targetactul.Achievement__c=0;
                    // Targetactul.Target__c=0;
                  if(Targetactul.Target__c!=0 && Targetactul.Target__c!=null) {
                      decimal coveredcomparision=(totalAcntcovered.size()/Targetactul.Target__c)*100;
                    Targetactul.Achievement__c=ConquestBatch_MY.getincnetive(incentiveslab,coveredcomparision);
                  }
                    updatetalist.add(Targetactul);  

                }
                if(updatetalist.size()>0){
                database.update(updatetalist);
                   }

            }//end of sku saloon size check

        }

    }
    /******************************
starting the new launch calculation

***************************************************/
    global static void NewLaunchCalculation(List<Target_Actual__c> scope){
        List<Target_Actual__c> UpdateTargetList = new list<Target_Actual__c>();
        date PgroupStartdate;
        date PgroupEnddate;
        Decimal BuyLogicValue;
        string BuyLogic;
        set<id> newlaunchSkuId= new set<id>();
        set<id> prodhirId= new set<id>();
        Map<id,set<id>> AccountSkuMap= new Map<id,set<id>>();
        Map<Id,String> AccountIdNameMap = new Map<Id,String>();
        Map<id,set<id>> productdatarelatedtoHirarchy= new Map<id,set<id>>();

        if(scope.size()>0){
            //querying incentive slab based on the target actual incentive group assigned to resource.
            list<Incentive_Slab__c> incentiveslab=[select id,Incentive_Group__c,Maximum__c,Minimum__c,Incentive__c from Incentive_Slab__c where  Incentive_Group__c =:scope[0].Incentive_Group__c];

            //querying product group based on Target Actual prd grp id with including start date and end date.
            list<ivybase__Product_Group_Detail__c> prdgrpdetails=[select id,Product_Hierarchy__c,ivybase__Product__c,ivybase__Product_Group__r.Buy_Logic_Value__c,ivybase__Product_Group__r.ivybase__Start_Date__c,ivybase__Product_Group__r.ivybase__End_Date__c,ivybase__Product_Group__r.Buy_Logic__c,ivybase__Product_Group__c 
                                                                  from ivybase__Product_Group_Detail__c 
                                                                  where  ivybase__Product_Group__c=:scope[0].Product_Group__c ];
            if(prdgrpdetails.size()>0){
                PgroupStartdate=prdgrpdetails[0].ivybase__Product_Group__r.ivybase__Start_Date__c;
                PgroupEnddate= prdgrpdetails[0].ivybase__Product_Group__r.ivybase__End_Date__c;  
            }
            //forming set of new Launch Skus id.
            for(ivybase__Product_Group_Detail__c PGD:prdgrpdetails){
                if(PGD.ivybase__Product__c!=null){
                    newlaunchSkuId.add(PGD.ivybase__Product__c);
                    if(pgd.Product_Hierarchy__c!=null)prodhirId.add(pgd.Product_Hierarchy__c);
                    if(PGD.ivybase__Product_Group__r.Buy_Logic_Value__c!=null)BuyLogicValue=pgd.ivybase__Product_Group__r.Buy_Logic_Value__c;
                    if(PGD.ivybase__Product_Group__r.Buy_Logic__c!=null)BuyLogic=pgd.ivybase__Product_Group__r.Buy_Logic__c;
                }
            } 
            ///end of for loop
            if(prodhirId.size()>0){
                productdatarelatedtoHirarchy = ProductHierarchyService.getAlltheProductUnderProductHierarchywithSetOfPHId(prodhirId);

            }
            if(productdatarelatedtoHirarchy!=null){
                newlaunchSkuId.addall(productdatarelatedtoHirarchy.keyset());
            }
            system.debug('newlaunchSkuId'+newlaunchSkuId);
            //Querying sku saloons created today ,this is for coverage  calculations 
            list<SKU_SaloonSale__c> SKUSaloonSaleList=[select Product_Master__c,Account__r.name,Account__c,InvoiceDate__c,Resource__c from SKU_SaloonSale__c where InvoiceDate__c >=:PgroupStartdate AND InvoiceDate__c <=:PgroupEnddate AND Resource__c=:scope[0].Resource__c AND Product_Master__c IN:newlaunchSkuId];
            if(SKUSaloonSaleList.size()>0){
                for(SKU_SaloonSale__c skusal:SKUSaloonSaleList){
                    AccountIdNameMap.put(skusal.Account__c,skusal.Account__r.name);
                    if(AccountSkuMap.containskey(skusal.Account__c)){
                        AccountSkuMap.get(skusal.Account__c).add(skusal.Product_Master__c);
                    }else{
                        set<id> skuid= new set<id>();
                        skuid.add(skusal.Product_Master__c); 
                        AccountSkuMap.put(skusal.Account__c,skuid);
                    }
                }
            }
            system.debug('AccountSkuMap'+AccountSkuMap);
            set<id> satisfiedAccounts= new set<id>();
            if(AccountSkuMap!=null){
                for(id accid:AccountSkuMap.keyset()){
                    if(newlaunchSkuId.size()>0 && AccountSkuMap.containskey(accid)){
                       if(AccountSkuMap.get(accid).containsAll(newlaunchSkuId)){ // if(newlaunchSkuId.containsAll(AccountSkuMap.get(accid)))
                            satisfiedAccounts.add(accid); 
                        }
                    }
                }
            }
            system.debug('satisfiedAccounts'+satisfiedAccounts);
            list<Account_Target__c> exisitingAccount = new list<Account_Target__c>();
            set<id> accountoftotalcounttilldate= new set<id>();
            List<Account_Target__c> AccountCaptured = [select id,Account__c,Target_Actual__c from Account_Target__c where Target_Actual__c=:scope[0].id];
            for(Account_Target__c acc:AccountCaptured)
            {
                exisitingAccount.add(acc);  
                //accountoftotalcounttilldate.add(acc.Account__c);
            }
            delete exisitingAccount;
            system.debug('accountoftotalcounttilldate'+accountoftotalcounttilldate);
            system.debug('accountoftotalcounttilldate size before'+accountoftotalcounttilldate.size());
            accountoftotalcounttilldate.addall(satisfiedAccounts);
            system.debug('accountoftotalcounttilldate'+accountoftotalcounttilldate);
            system.debug('accountoftotalcounttilldate size after'+accountoftotalcounttilldate.size());
            List<Account_Target__c> toInsert = new List<Account_Target__c>();
            //itreating on satisfied accounts aand check with existed if its not there then created
            for(id Accnts:satisfiedAccounts){
               // if(!exisitingAccount.contains(Accnts)){
                    Account_Target__c accTar = new Account_Target__c();
                    accTar.Account__c=Accnts;
                    accTar.Target_Actual__c=scope[0].id;
                    if(AccountIdNameMap.containskey(Accnts))
                    {   
                        accTar.Name=AccountIdNameMap.get(Accnts);
                    }
                    toInsert.add(accTar);
                //}
            }
            if(toInsert.size()>0){
                database.insert(toInsert);
            }

            for(Target_Actual__c tact:scope){
                tact.Achievement__c=0;
                if(tact.Target__c>0){
                    decimal coveredcomparision=(satisfiedAccounts.size()/tact.Target__c)*100;
                    tact.Achievement__c=  ConquestBatch_MY.getincnetive(incentiveslab,coveredcomparision);
                    UpdateTargetList.add(tact) ;
                }
            }

            if(UpdateTargetList.size()>0){
                update UpdateTargetList;
            }
        }//end of scopee

    }

}