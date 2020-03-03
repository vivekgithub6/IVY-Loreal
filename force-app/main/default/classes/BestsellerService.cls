public class BestsellerService {
    public static map<Decimal, list<BestsellerService.productwrap>> getBestSellingProducts(){
        List< Account > accRouteList = AccountService.getAllRetailerMaster_List_for_Resource();
        set<id> accidset= new set<id>();
        for(Account acc:accRouteList){
            accidset.add(acc.id);
        }
        AggregateResult[] groupedResults  =[Select sum(ivydsd__UOM_1_Quantity__c) qty, ivydsd__Invoice__r.ivydsd__Store__r.Name,ivydsd__Invoice__r.ivydsd__Store__c storeid, ivydsd__Product_Master1__r.Name product,ivydsd__Product_Master1__c
                                            from ivydsd__Invoice_Line_Item__c where ivydsd__Invoice__r.ivydsd__Store__c IN:accidset AND ivydsd__Invoice__r.ivydsd__Invoice_Date__c >=LAst_N_Months:3
                                            Group By ivydsd__Invoice__r.ivydsd__Store__r.Name, ivydsd__Product_Master1__r.Name,ivydsd__Product_Master1__c,ivydsd__Invoice__r.ivydsd__Store__c order by sum(ivydsd__UOM_1_Quantity__c) DESC];
        set<id> accid = new set<id>();
        set<id> prdid =new set<id>();
        
        for(AggregateResult agg:groupedResults){
            accid.add((id)agg.get('storeid'));
            prdid.add((id)agg.get('ivydsd__Product_Master1__c'));
        }
        system.debug('grouped'+groupedResults);
        
        Map<id,decimal> accidvsintrnlId = new Map<id,decimal> ();
        List<Account> accountList = [SELECT Id, Name, ivybase__Internal_Id__c FROM Account WHERE Id IN:accid AND ivybase__Active__c = 'Yes'];
        for(account ac:accountList){
            accidvsintrnlId.put(ac.Id,ac.ivybase__Internal_Id__c);
        }
        system.debug('accidvsintrnlId'+accidvsintrnlId);
        
        Map<id,decimal> prodidvsintrnlId = new Map<id,decimal> ();
        list<ivybase__Product__c> prdlist=[SELECT Id, ivybase__InternalId__c FROM ivybase__Product__c WHERE Id IN:prdid];
        for(ivybase__Product__c prd:prdlist){
            prodidvsintrnlId.put(prd.id,prd.ivybase__InternalId__c);
        }
        system.debug('prodidvsintrnlId'+prodidvsintrnlId);
        
        map<decimal,list<productwrap>> Accprodcountmap= new map<decimal,list<productwrap>>();
        
        for(AggregateResult ag:groupedResults){
            if(accidvsintrnlId.containskey((id)ag.get('storeid')) && prodidvsintrnlId.containskey((id)ag.get('ivydsd__Product_Master1__c'))){
                if(Accprodcountmap.containskey(accidvsintrnlId.get((id)ag.get('storeid')))){
                    list<BestsellerService.productwrap> prodmap = Accprodcountmap.get(accidvsintrnlId.get((id)ag.get('storeid')));
                    if(prodmap!=NULL && prodmap.size()>0 && prodmap.size()<=19){
                        BestsellerService.productwrap prod = new BestsellerService.productwrap();
                        prod.productid = prodidvsintrnlId.get((id)ag.get('ivydsd__Product_Master1__c'));
                        prod.count = (Decimal)ag.get('qty');
                        prodmap.add(prod); 
                        Accprodcountmap.put(accidvsintrnlId.get((id)ag.get('storeid')),prodmap);
                    }
                }
                else{
                    list<BestsellerService.productwrap> productWithValue = new list<BestsellerService.productwrap>();
                    BestsellerService.productwrap prod = new BestsellerService.productwrap();
                    prod.productid = prodidvsintrnlId.get((id)ag.get('ivydsd__Product_Master1__c'));
                    prod.count = (Decimal)ag.get('qty');
                    productWithValue.add(prod);
                    Accprodcountmap.put(accidvsintrnlId.get((id)ag.get('storeid')),productWithValue);
                }
            }
        }
        system.debug('Accprodcountmap'+Accprodcountmap);
        return Accprodcountmap;   
    }
    
  
    
    public class productwrap{
        public decimal productid;
        public decimal count;
         public productwrap(){
            
        }
    }
}