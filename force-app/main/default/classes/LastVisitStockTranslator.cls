public class LastVisitStockTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToInvoiceLineItem(LastVisitStockService.LocationStockWrp LocationStockTypes, String errorCode){
        RExAPIResponseDomain.ResponseInfo LastVisitStockMasterResponce = new RExAPIResponseDomain.ResponseInfo();
        LastVisitStockMasterResponce.Master = 'LastVisitStock';
        LastVisitStockMasterResponce.Field = new List<String>{'RetailerId','LocId','ProductId','PUOMId','ShelfPQty'};
            LastVisitStockMasterResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        LastVisitStockMasterResponce.Next = '0';
        
        List<List<String>> LocationStockmasterRec = new List<List<String>>();  
        if (LocationStockTypes != null && errorCode == null) { 
            Map<ivybase__Location_Stock__c,list<ivybase__Product_UOM__c>> LocationStock=LocationStockTypes.LocationStockUOM;
            Map<String, string> StandardCode = LocationStockTypes.StandardCode; 
            
            system.debug('Location Stock Map'+LocationStock);
            if(LocationStock!=null){
                for(ivybase__Location_Stock__c st:LocationStock.keyset()){
                    List<String> LocationStockInfo = new List<String>();
                    System.debug('Retailer::'+st.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c);
                    if(st.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c!=null){
                        LocationStockInfo.add(String.valueof(st.ivybase__Visit__r.ivybase__Store__r.ivybase__Internal_Id__c));//RetailerId
                    }
                    else{
                        LocationStockInfo.add(''); 
                    }
                    if(st.ivybase__Location__r.ivybase__Standard_List_Master__r.Name!=null){
                        system.debug('Location::' +st.ivybase__Location__r.ivybase__Standard_List_Master__r.Name);
                        LocationStockInfo.add(st.ivybase__Location__r.ivybase__Standard_List_Master__r.Name); //LocId
                    }
                    else{
                        LocationStockInfo.add('0');  
                    }
                    if(st.ivybase__Product__r.ivybase__InternalId__c!=null){
                        System.debug('ProdId:::' +st.ivybase__Product__r.ivybase__InternalId__c);
                        LocationStockInfo.add(String.valueof(st.ivybase__Product__r.ivybase__InternalId__c));//ProductId
                    }
                    else{
                        LocationStockInfo.add('0');
                    }
                    
                    string puom=null;
                    Decimal pQty=null;
                    
                    system.debug('Code'+StandardCode);
                    if(StandardCode!=null){
                        for(ivybase__Product_UOM__c uom:LocationStock.get(st)){
                            system.debug('UOM'+uom);
                            system.debug('Stock'+st);
                            System.debug('Piece::' +uom.ivybase__UOM__c); 
                            if(uom.ivybase__UOM__c.equalsIgnoreCase('Piece')){ 
                                if (StandardCode.containsKey(uom.ivybase__UOM__c)) {
                                    puom=StandardCode.get(uom.ivybase__UOM__c);
                                    System.debug('PUOMId:::' +puom);
                                    if(uom.ivybase__UOM_Number__c=='UOM 1'){
                                        pQty= st.ivybase__UOM1__c;
                                        System.debug('PQty::'+pQty);
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    system.debug('PUOM'+puom);
                    system.debug('Qty'+pQty);
                    if(puom!=null){
                        LocationStockInfo.add(puom);//PUOMId 
                    }
                    else{
                        LocationStockInfo.add('0');
                    }
                    if(pQty!=null){
                        LocationStockInfo.add(String.valueof(pQty)); //ShelfPQty
                    }
                    else{ 
                        LocationStockInfo.add('-1'); 
                    }
                    /*if(st.ivybase__Reason_Master__r.Name  !=null){
                    LocationStockInfo.add(st.ivybase__Reason_Master__r.Name  ) ;//ReasonId
                 }
                 else{ 
                     LocationStockInfo.add('0');   
                 }*/
                    LocationStockmasterRec.add(LocationStockInfo); 
                }
               LastVisitStockMasterResponce.Data= LocationStockmasterRec;   
            }
            
        }
        return LastVisitStockMasterResponce;
    }
    
}