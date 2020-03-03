public class CustomerInfoTranslator {
    
    public static RExAPIResponseDomain.ResponseInfo objectToRetailerCustomerInfo(List<Account> accounts,Map<Id,Decimal> YTDValue,Map<String, String> listNamewithListIdMap,String errorCode){
        system.debug('errorCode'+errorCode);
        RExAPIResponseDomain.ResponseInfo RetailerCustomerInfoResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerCustomerInfoResponce.Master = 'RetailerCustomerInfo';
        RetailerCustomerInfoResponce.Field = new List<String>{'Rid','PayerCode','NewNodeLastLevel','YTD','Luxury','SocialMediaId','IsEmailMandatory'};
        RetailerCustomerInfoResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerCustomerInfoResponce.Next = '0'; 
        system.debug('accounts'+accounts);
        List<List<String>> retailerCustomerInfoData = new List<List<String>>();
        try{
            accounts = accounts!=null ? accounts : new List<Account>();
            for(Account acc : accounts){
                System.debug('accounts inside for::'+acc);
                System.debug('accounts inside for::'+acc.Id);
                System.debug('accounts inside for::'+acc.Sold_To_Party_Number__c);
                List<String> retailerData = new List<String>();
                if(acc.ivybase__Internal_Id__c != null){
                    retailerData.add(String.valueOf(acc.ivybase__Internal_Id__c)); //Rid
                }else{
                    retailerData.add(''); 
                }
                if(acc.Sold_To_Party_Number__c != null){
                    retailerData.add(acc.Sold_To_Party_Number__c );//PayerCode
                }else{
                    retailerData.add('');
                }
                retailerData.add(acc.AccountNumber); // NewNodeLastLevel
                if(String.valueOf(YTDValue.get(acc.Id)) != null){
                    retailerData.add(String.valueOf(YTDValue.get(acc.Id))); //YTD
                }else{
                    retailerData.add('0');
                }

                if(acc.Kerastase_Luxury_Mag__c != null){
                    retailerData.add(listNamewithListIdMap.get(acc.Kerastase_Luxury_Mag__c)); //Luxury
                }else{
                    retailerData.add('');
                }
                if(acc.Social_Media_Id__c != null){
                    retailerData.add(acc.Social_Media_Id__c );//social mediaid
                }else{
                    retailerData.add('');
                }
                if(acc.Order_Email__c == true){
                    retailerData.add('1');//IsEmailMandatory
                }else {
                    retailerData.add('0');
                }
                retailerCustomerInfoData.add(retailerData);
                System.debug('retailerData:: '+retailerData);
            }
            System.debug('retailerCustomerInfoData:: '+retailerCustomerInfoData);
            RetailerCustomerInfoResponce.Data = retailerCustomerInfoData;
            return RetailerCustomerInfoResponce;
        } catch(Exception e){
            system.debug('errorCode'+errorCode);
            return RetailerCustomerInfoResponce;
        }
    }  

    public static RExAPIResponseDomain.ResponseInfo objectToRetailerCheck(List<Document__c> documentRecords,String errorCode){

        RExAPIResponseDomain.ResponseInfo RetailerCheckListResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerCheckListResponce.Master = 'RetailerCheckList';
        ivybase__Resource__c loggedInResource = ResourceService.getSellerId(UserInfo.getUserId());
        RetailerCheckListResponce.Field = new List<String>{'Rid','DocumentName','DocumentCode','Availability'};
       //RetailerCheckListResponce.Field = new List<String>{'Rid','DocumentName','DocumentCode','Availability','DivisionID'};

       
        RetailerCheckListResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerCheckListResponce.Next = '0'; 
        System.debug('RetailerCheckListResponce'+RetailerCheckListResponce);
        List<List<String>> retailerCheckListData = new List<List<String>>();  
        System.debug('documentRecords::' +documentRecords);
        try{
            if(documentRecords != null){
                for(Document__c doc : documentRecords){
                    List<String> retailerData = new List<String>(); 
                    if(doc.Retailer__c != null){
                        retailerData.add(String.valueOf(doc.Retailer__r.ivybase__Internal_Id__c)); //Rid
                    }else{
                        retailerData.add('0');
                    }
                    if(doc.Document_Name__c != null){
                        retailerData.add(doc.Document_Name__c);//Document Name
                    }else{
                        retailerData.add('');
                    }

                    if(doc.Name != null){
                        retailerData.add(doc.Name); //Document Code
                    }else{
                        retailerData.add('');
                    }
                    if(doc.Available__c != null){
                        retailerData.add(String.valueOf(doc.Available__c)); //Availability
                    }else{
                        retailerData.add('');
                    }
                    //retailerData.add('0');
                    
					
                    retailerCheckListData.add(retailerData);
                }
            }
            System.debug('RetailerCheckListResponce'+RetailerCheckListResponce);
            RetailerCheckListResponce.Data = retailerCheckListData;
            return RetailerCheckListResponce;
        }
        Catch(Exception e){
            return RetailerCheckListResponce;
        }
    }
    public static RExAPIResponseDomain.ResponseInfo objectToRetailerMagClassifiction(List<Account> accounts,Map<string,Date> salonInvDateMap,Map<string,Date> salonLastVisitdateMap,Map<string,Decimal> salonAvgOrderValue,map<string,string> resourceDivMap,map<string,string> Divisionlovidmap,String errorCode){

        RExAPIResponseDomain.ResponseInfo RetailerCheckListResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerCheckListResponce.Master = '';
        
        ivybase__Resource__c loggedInResource = ResourceService.getSellerId(UserInfo.getUserId());
        
        RetailerCheckListResponce.Field = new List<String>{'Rid','LastVisitDate','LastInvoiceDate','AvgOrderValue','DueAmount'};
       // RetailerCheckListResponce.Field = new List<String>{'Rid','LastVisitDate','LastInvoiceDate','AvgOrderValue','DueAmount','DivisionID'};
      
        
        RetailerCheckListResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerCheckListResponce.Next = '0'; 

        System.debug('accounts in translator::: '+accounts); 
        List<List<String>> retailerMagClassData = new List<List<String>>();  

        

        try{
            /*	for(Account acc : accounts){
                for(string divids :resourceDivMap.keyset()){
                    List<String> retailerData = new List<String>();
                    System.debug('acc:: '+acc);
                    if(acc.ivybase__Internal_Id__c != null){
                        retailerData.add(String.valueOf(acc.ivybase__Internal_Id__c)); //Rid
                    }
                    else{
                        retailerData.add('0');
                    }


                    if(salonLastVisitdateMap != null && salonLastVisitdateMap.containsKey(acc.Id+'.'+divids) && salonLastVisitdateMap.get(acc.Id+'.'+divids) !=null){
                        retailerData.add(salonLastVisitdateMap.get(acc.Id+'.'+divids).format());   //LastVisitDate
                    }
                    else{
                        retailerData.add('');
                    }
                    if(salonInvDateMap != null && salonInvDateMap.containsKey(acc.Id+'.'+divids) && salonInvDateMap.get(acc.Id+'.'+divids) !=null){
                        retailerData.add(salonInvDateMap.get(acc.Id+'.'+divids).format());  //LastInvoiceDate
                    }else{
                        retailerData.add('');
                    }
                    if(salonAvgOrderValue != null && salonAvgOrderValue.containsKey(acc.Id+'.'+divids) && salonAvgOrderValue.get(acc.Id+'.'+divids) !=null){
                        decimal avgval=salonAvgOrderValue.get(acc.Id+'.'+divids);
                        avgval=OrderLineItemTriggerhandler.roundingUP2DecimalPlaces(avgval);
                        retailerData.add(String.valueOf(avgval)); //AvgOrderValue
                    }else{
                        retailerData.add('0');
                    }
                    if(acc.Due_Amount__c != null){
                        retailerData.add(String.valueOf(acc.Due_Amount__c));
                    }else{
                        retailerData.add('0');
                    }
                    if(resourceDivMap.containskey(divids) && resourceDivMap.get(divids)!=null && Divisionlovidmap!=null && Divisionlovidmap.containskey(resourceDivMap.get(divids)) && Divisionlovidmap.get(resourceDivMap.get(divids))!=null){
                        retailerData.add(Divisionlovidmap.get(resourceDivMap.get(divids)));
                    }else{
                        retailerData.add('');
                    }//divisionid
                    retailerMagClassData.add(retailerData); 

                }
            }*/
            
            for(Account acc : accounts){
            List<String> retailerData = new List<String>();
            System.debug('acc:: '+acc);
            if(acc.ivybase__Internal_Id__c != null){
                retailerData.add(String.valueOf(acc.ivybase__Internal_Id__c)); //Rid
            }
            else{
                retailerData.add('0');
            }
             
            
            if(salonLastVisitdateMap != null && salonLastVisitdateMap.containsKey(acc.Id) && salonLastVisitdateMap.get(acc.Id) !=null){
                retailerData.add(salonLastVisitdateMap.get(acc.Id).format());   //LastVisitDate
            }
            else{
                retailerData.add('');
            }
            if(salonInvDateMap != null && salonInvDateMap.containsKey(acc.Id) && salonInvDateMap.get(acc.Id) !=null){
               retailerData.add(salonInvDateMap.get(acc.Id).format());  //LastInvoiceDate
            }else{
                retailerData.add('');
            }
            if(salonAvgOrderValue != null && salonAvgOrderValue.containsKey(acc.Id) && salonAvgOrderValue.get(acc.Id) !=null){
                decimal avgval=salonAvgOrderValue.get(acc.Id);
                avgval=OrderLineItemTriggerhandler.roundingUP2DecimalPlaces(avgval);
                retailerData.add(String.valueOf(avgval)); //AvgOrderValue
            }else{
                retailerData.add('0');
            }
            if(acc.Due_Amount__c != null){
                retailerData.add(String.valueOf(acc.Due_Amount__c));
            }else{
                retailerData.add('0');
            }
             
           retailerMagClassData.add(retailerData); 
            
        }
        }catch(Exception e){}

        RetailerCheckListResponce.Data = retailerMagClassData;
        System.debug('RetailerCheckListResponce::'+RetailerCheckListResponce);
        return RetailerCheckListResponce;
    }

    //public static RExAPIResponseDomain.ResponseInfo objectToRetailersalesContribution(map<string,Decimal> RetailerSalesContribution,map<string,string> Divisionlovidmap,String errorCode){
    public static RExAPIResponseDomain.ResponseInfo objectToRetailersalesContribution(map<string,Decimal> RetailerSalesContribution,String errorCode){

        RExAPIResponseDomain.ResponseInfo RetailerCheckListResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerCheckListResponce.Master = 'RetailerSalesContribution';
        RetailerCheckListResponce.Field = new List<String>{'Rid','Pid','SubAxeLovId','Value'};
        RetailerCheckListResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerCheckListResponce.Next = '0'; 

        System.debug('sales contribtuion::: '+RetailerSalesContribution); 
        List<List<String>> retailersales = new List<List<String>>();  
        try{
            for(string s : RetailerSalesContribution.keySet()){
                List<String> retailerData = new List<String>();
                retailerData.add(s.split('\\.')[2]!=Null?s.split('\\.')[2]:''); //Rid
                retailerData.add(s.split('\\.')[1]!=Null?s.split('\\.')[1]:''); //pid
                retailerData.add(!String.isBlank(s.split('\\.')[0])?s.split('\\.')[0]:''); //subaxelovid

                retailerData.add(String.valueOf(RetailerSalesContribution.get(s))!=Null?String.valueOf(RetailerSalesContribution.get(s)):''); //Rid

                //retailerData.add(String.valueOf(RetailerSalesContribution.get(s))!=Null?String.valueOf(RetailerSalesContribution.get(s)):''); //Rid
				/*if(Divisionlovidmap!=null && s.split('\\.')[3]!=Null && Divisionlovidmap.containskey(s.split('\\.')[3]) && Divisionlovidmap.get(s.split('\\.')[3])!=null){
                retailerData.add(Divisionlovidmap.get(s.split('\\.')[3]));
                }else{
                    retailerData.add('');
                }*///divid
                retailersales.add(retailerData); 

            }
        }catch(Exception e){}

        RetailerCheckListResponce.Data = retailersales;
        return RetailerCheckListResponce;
    }
    public static RExAPIResponseDomain.ResponseInfo objectToRetailerContract(list<Contract__c> getContractList,map<string,string> Divisionlovidmap,String errorCode){

        RExAPIResponseDomain.ResponseInfo RetailerCheckListResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerCheckListResponce.Master = 'RetailerContractInfo';
        
        //RetailerCheckListResponce.Field = new List<String>{'RetailerId','ContractId','ContractDesc','ContractType','ContractValue','StartDate','EndDate','Status','DivisionID'};
        RetailerCheckListResponce.Field = new List<String>{'RetailerId','ContractId','ContractDesc','ContractType','ContractValue','StartDate','EndDate','Status'};

        RetailerCheckListResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerCheckListResponce.Next = '0'; 
        List<List<String>> retailersales = new List<List<String>>();  
        try{
            system.debug('getContractList'+getContractList);
            for(Contract__c contract:getContractList){
                List<String> retailerData = new List<String>();  
                retailerData.add(String.valueOf(contract.Account__r.ivybase__Internal_Id__c)!=Null?String.valueOf(contract.Account__r.ivybase__Internal_Id__c):''); //Rid
                retailerData.add(String.valueOf(contract.Internal_Id__c)!=Null?String.valueOf(contract.Internal_Id__c):''); //Rid
                retailerData.add(String.valueOf(contract.Description__c)!=Null?String.valueOf(contract.Description__c):''); //Rid
                retailerData.add(String.valueOf(contract.Contract_Type__c)!=Null?String.valueOf(contract.Contract_Type__c):''); //Rid
                retailerData.add(String.valueOf(contract.Contract_Value__c)!=Null?String.valueOf(contract.Contract_Value__c):''); //Rid
                retailerData.add(String.valueOf(contract.Start_Date__c)!=Null?String.valueOf(contract.Start_Date__c):''); //Rid
                retailerData.add(String.valueOf(contract.End_Date__c)!=Null?String.valueOf(contract.End_Date__c):''); //Rid
                retailerData.add(String.valueOf(contract.Status__c)!=Null?String.valueOf(contract.Status__c):''); //Rid
                /*if(Divisionlovidmap!=null && contract.division__c!=null && Divisionlovidmap.containskey(contract.division__r.name) && Divisionlovidmap.get(contract.division__r.name)!=null){
                retailerData.add(Divisionlovidmap.get(contract.division__r.name));
                }else{
                    retailerData.add('');
                }*///divid
                retailersales.add(retailerData); 
            }



            //retailerData.add(String.valueOf(RetailerSalesContribution.get(s))!=Null?String.valueOf(RetailerSalesContribution.get(s)):''); //Rid






        }
        catch(Exception e){
            system.debug('errror'+e.getMessage());
        }

        RetailerCheckListResponce.Data = retailersales;
        system.debug('RetailerCheckListResponce'+RetailerCheckListResponce);
        return RetailerCheckListResponce;
    }
    
    //new code
    public static RExAPIResponseDomain.ResponseInfo objectToRetailerMagDetails(list<Account> accounts,String errorCode){
        RExAPIResponseDomain.ResponseInfo RetailerMagResponse = new RExAPIResponseDomain.ResponseInfo();
        RetailerMagResponse.Master = 'RetailerMagDetails';
        RetailerMagResponse.Field = new List<String>{'Rid','Noofstylist','Noofchairs','Noofbackwashunits','Colorprice','TreatmentPrice','CuttingPrice','BlowdryPrice','TexturePrice','KeyCompetitor','CustomerAttribute1','CustomerAttribute2','CustomerAttribute3','CustomerAttribute4','CustomerAttribute5'};
        RetailerMagResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerMagResponse.Next = '0';	
        List<List<String>> retailerMagData = new List<List<String>>(); 
        system.debug('accounts'+accounts);
        try{
            for(Account acc : accounts){
                List<String> retailerData = new List<String>();
                retailerData.add(String.valueOf(acc.ivybase__Internal_Id__c)!=Null?String.valueOf(acc.ivybase__Internal_Id__c):''); //Rid
                retailerData.add(String.valueOf(acc.No_of_Stylist__c)!=Null?String.valueOf(acc.No_of_Stylist__c):''); //Noofstylist
                retailerData.add(String.valueOf(acc.No_of_Chairs__c)!=Null?String.valueOf(acc.No_of_Chairs__c):''); //Noofchairs
                retailerData.add(String.valueOf(acc.No_of_Backwash_Units__c)!=Null?String.valueOf(acc.No_of_Backwash_Units__c):''); //Noofbackwashunits
                retailerData.add(String.valueOf(acc.Color_Price__c)!=Null?String.valueOf(acc.Color_Price__c):''); //Colorprice
                retailerData.add(String.valueOf(acc.Treatment_Price__c)!=Null?String.valueOf(acc.Treatment_Price__c):''); //TreatmentPrice
                retailerData.add(String.valueOf(acc.Cutting_Price__c)!=Null?String.valueOf(acc.Cutting_Price__c):''); //CuttingPrice
                retailerData.add(String.valueOf(acc.Blow_Dry_Price__c)!=Null?String.valueOf(acc.Blow_Dry_Price__c):''); //BlowdryPrice
                retailerData.add(String.valueOf(acc.Texture_Price__c)!=Null?String.valueOf(acc.Texture_Price__c):''); //TexturePrice
                retailerData.add(String.valueOf(acc.Key_Competitor__c)!=Null?String.valueOf(acc.Key_Competitor__c):''); //KeyCompetitor
                retailerData.add(String.valueOf(acc.Customer_Attribute1__c)!=Null?String.valueOf(acc.Customer_Attribute1__c):''); //CustomerAttribute1
                retailerData.add(String.valueOf(acc.Customer_Attribute2__c)!=Null?String.valueOf(acc.Customer_Attribute2__c):''); //CustomerAttribute2
                retailerData.add(String.valueOf(acc.Customer_Attribute3__c)!=Null?String.valueOf(acc.Customer_Attribute3__c):''); //CustomerAttribute3
                retailerData.add(String.valueOf(acc.Customer_Attribute4__c)!=Null?String.valueOf(acc.Customer_Attribute4__c):''); //CustomerAttribute4
                retailerData.add(String.valueOf(acc.Customer_Attribute5__c)!=Null?String.valueOf(acc.Customer_Attribute5__c):''); //CustomerAttribute5
                retailerMagData.add(retailerData);
            }
        }
        catch(Exception e){
            system.debug('errror'+e.getMessage());
        }
        
        RetailerMagResponse.Data = retailerMagData;
        system.debug('RetailerMagResponse'+RetailerMagResponse);
        return RetailerMagResponse;	
    }

}