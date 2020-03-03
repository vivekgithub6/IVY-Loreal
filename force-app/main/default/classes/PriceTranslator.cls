public with sharing class PriceTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToPriceMasterInfo(List<ivybase__Price_List_Entrie__c> priceList, Map<Id, Map<String, String>> productIdwithUOMTypewithNumberMap, String errorCode) {
        system.debug('priceList'+priceList);
        RExAPIResponseDomain.ResponseInfo priceInfo = new RExAPIResponseDomain.ResponseInfo ();
        priceInfo.Master = 'PriceBaseMaster';
        priceInfo.Field = new List<String>{'pid', 'BasePrice'}; 
            List<List<String>> GetAllPrice = new List<List<String>>();
        if (errorCode == null && priceList.size() > 0) {
            //for (Price_List_Entrie__c price: priceList) {
            List<List<String>> priceLists = new List<List<String>>();
            for (ivybase__Price_List_Entrie__c price :priceList) {
                
                List<String> priceTemp = new List<String>();
                if(price.Type__c=='YPR0' && price.ivybase__UOM_1_Price__c!=Null){
                    priceTemp.add(price.ivybase__Product__c != null ? String.valueOf(price.ivybase__Product__r.ivybase__InternalId__c):'0');
                    
                    priceTemp.add(string.valueof(price.ivybase__UOM_1_Price__c));
                    priceLists.add(priceTemp);
                }
                
                
            }
            GetAllPrice = priceLists;
            //GetAllPrice.add(priceRec);       
            //}
        }
        priceInfo.Data = GetAllPrice;
        priceInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        priceInfo.Next = '0';     
        return priceInfo ;
    }
    public static RExAPIResponseDomain.ResponseInfo objectToPricenetMasterInfo(List<ivybase__Price_List_Entrie__c> priceList, map<string,string> AccountPriceIdmap,Map<Id,Map<Id,Decimal>> BOMFinalPrice, String errorCode) {
        RExAPIResponseDomain.ResponseInfo priceInfo = new RExAPIResponseDomain.ResponseInfo ();
        UserwiseCountryValues__c user = UserwiseCountryValues__c.getInstance(UserInfo.getUserId());
        priceInfo.Master = 'PriceNetMaster';
        //if(user != null && user.Market_ISO__c == 'SG') {
            priceInfo.Field = new List<String>{'Rid','pid', 'StructPrice','Netprice','pricegroup','IsBOM','BOMId'};  
               // }
        /*else{
            priceInfo.Field = new List<String>{'Rid','pid', 'StructPrice','Netprice','pricegroup','IsBOM'};
                }*/
        List<List<String>> GetAllPrice = new List<List<String>>();
        if (errorCode == null && priceList.size() > 0) {
            //for (Price_List_Entrie__c price: priceList) {
            List<List<String>> priceLists = new List<List<String>>();
            for (ivybase__Price_List_Entrie__c price :priceList) {
                List<String> priceTemp = new List<String>();
                
                if(price.Type__c!='YPR0' && price.ivybase__UOM_1_Price__c != null){
                    if(price.Parent__c!=null)
                    {
                        if(price.Parent__r.ivybase__Price_List__c!=Null && AccountPriceIdmap.keyset().contains(price.Parent__r.ivybase__Price_List__c))
                        {
                            priceTemp.add(AccountPriceIdmap.get(price.Parent__r.ivybase__Price_List__c));
                        }
                    }
                    else if(price.ivybase__Price_List__c!=Null && AccountPriceIdmap.keyset().contains(price.ivybase__Price_List__c))
                        priceTemp.add(AccountPriceIdmap.get(price.ivybase__Price_List__c));
                    else
                        priceTemp.add('');
                    
                    priceTemp.add(price.ivybase__Product__c != null ? String.valueOf(price.ivybase__Product__r.ivybase__InternalId__c):'0');
                    if((price.Type__c=='ZSNP'|| price.Type__c=='ZSN1')&& price.ivybase__UOM_1_Price__c!=Null){
                        priceTemp.add(string.valueof(price.ivybase__UOM_1_Price__c));
                    }
                    else{
                        priceTemp.add('');
                    }
                    if((price.Type__c=='ZPNA'|| price.Type__c=='ZPN2' || price.Type__c=='ZPNB')&& price.ivybase__UOM_1_Price__c!=Null){
                        priceTemp.add(string.valueof(price.ivybase__UOM_1_Price__c));
                    }
                    else{
                        priceTemp.add('');
                    }
                    if((price.Type__c=='ZPNA'|| price.Type__c=='ZPN2' || price.Type__c=='ZPNB')){
                        priceTemp.add('C');
                    }else if((price.Type__c=='ZSNP'|| price.Type__c=='ZSN1'))
                    {
                        priceTemp.add('A');
                    }else
                    {
                        priceTemp.add('');
                    }
                    if(price.Parent__c!=null)
                    {
                        priceTemp.add('1'); 
                    }else
                    {
                        priceTemp.add('0');
                    }//IsBOM
                    //if(user != null && user.Market_ISO__c == 'SG') {
                        if(price.Parent__c != null && price.Parent__r.ivybase__Product__c != null) {
                            priceTemp.add(String.valueOf(price.Parent__r.ivybase__Product__r.ivybase__InternalId__c));
                        } else {
                            priceTemp.add('0');
                        }
                   // }
                    priceLists.add(priceTemp);
                }
            }
            GetAllPrice = priceLists;
            //GetAllPrice.add(priceRec);       
            //}
        }
        priceInfo.Data = GetAllPrice;
        priceInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        priceInfo.Next = '0';     
        return priceInfo ;
    }
    
    /*public static List<List<String>> objectTopriceInfo(List<ivybase__Price_List_Entrie__c> priceList, Map<Id, Map<String, String>> productIdwithUOMTypewithNumberMap) {
List<List<String>> priceLists = new List<List<String>>();
for (ivybase__Price_List_Entrie__c price :priceList) {

List<String> priceTemp = new List<String>();
priceTemp.add(price.ivybase__Product__c != null ? String.valueOf(price.ivybase__Product__r.ivybase__InternalId__c):'0');
if(price.Type__c=='YPR0' && price.ivybase__UOM_1_Price__c!=Null)
priceTemp.add(string.valueof(price.ivybase__UOM_1_Price__c));
else
priceTemp.add('');



priceLists.add(priceTemp);
}
return priceLists;
}*/
    
    /* public static List<String> findpieceCaseOuterValue(ivybase__Price_List_Entrie__c price, string UOMNumber) {
List<String> UOMPriceList = new List<String>();

if (UOMNumber == 'UOM 1') {
UOMPriceList.add(price.ivybase__UOM_1_Price__c != null ? String.valueOf(price.ivybase__UOM_1_Price__c): '0');
UOMPriceList.add(price.ivybase__UOM_1_Credit_Price__c != null ? String.valueOf(price.ivybase__UOM_1_Credit_Price__c): '0');
} else if (UOMNumber == 'UOM 2') {    
UOMPriceList.add(price.ivybase__UOM_2_Price__c != null ? String.valueOf(price.ivybase__UOM_2_Price__c): '0');//csrp1
UOMPriceList.add(price.ivybase__UOM_2_Credit_Price__c != null ? String.valueOf(price.ivybase__UOM_2_Credit_Price__c): '0');//csrp2
} else if (UOMNumber == 'UOM 3') {
UOMPriceList.add(price.ivybase__UOM_3_Price__c != null ? String.valueOf(price.ivybase__UOM_3_Price__c): '0');//Osrp1
UOMPriceList.add(price.ivybase__UOM_3_Credit_Price__c != null ? String.valueOf(price.ivybase__UOM_3_Credit_Price__c): '0');//Osrp2
} else {
UOMPriceList.add('0');
UOMPriceList.add('0');
}

return UOMPriceList;
}*/
    
}