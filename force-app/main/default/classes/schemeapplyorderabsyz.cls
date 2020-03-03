public class schemeapplyorderabsyz 
{
   @AuraEnabled
    public static list<ivydsd__Scheme__c> getschemes(){
        return [SELECT Id, Name ,ivydsd__Internal_Id__c,ivydsd__Scheme_Buy_Logic__c,ivydsd__Scheme_Get_Logic__c
                FROM ivydsd__Scheme__c];
    }
    //

    public static list<ivybase__Product__c>  getskusunderhirarchy(id phid){

        Set<Id> PHIDSet = new Set<Id>();
        PHIDSet.add(phid);
        Set<Id> functionIdSet = new Set<Id>();
        set<String> rectypename = new Set<String>();
        List<ivybase__Product_Hierarchy__c> nuancetoSignature= [select id,RecordType.DeveloperName from ivybase__Product_Hierarchy__c
                                                                where id=:PHIDSet or 
                                                                ivybase__Parent__c=:PHIDSet or
                                                                ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or 
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet 
                                                               ];
        for(ivybase__Product_Hierarchy__c p:nuancetoSignature)
        {
            if(p.RecordType.DeveloperName=='Function')
            {
                functionIdSet.add(p.id);
            }
            rectypename.add(p.RecordType.DeveloperName);
            PHIDSet.add(p.id);
        }
        if(functionIdSet.size()==0){
            system.debug(PHIDSet.size());
            system.debug('q1'+rectypename);
            system.debug('Fn set '+functionIdSet);
            List<ivybase__Product_Hierarchy__c> functionToNuance= [select id,RecordType.DeveloperName from ivybase__Product_Hierarchy__c
                                                                   where id=:PHIDSet or 
                                                                   ivybase__Parent__c=:PHIDSet or
                                                                   ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or
                                                                   ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or
                                                                   ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or
                                                                   ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet or 
                                                                   ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHIDSet 
                                                                  ];


            for(ivybase__Product_Hierarchy__c p:functionToNuance)
            {
                if(p.RecordType.DeveloperName=='Function')
                {
                    functionIdSet.add(p.id);
                }
                rectypename.add(p.RecordType.DeveloperName);
                PHIDSet.add(p.id);
            }
        }
        system.debug(PHIDSet.size());
        system.debug('q2'+rectypename);
        system.debug('Fn set '+functionIdSet);

        List<ivybase__Product__c> productUnderPHID = [select id,name from ivybase__Product__c  where ivybase__Parent__c=:functionIdSet];
        system.debug(productUnderPHID.size());

        return productUnderPHID;
    }
    @AuraEnabled
    public static list<schemegroupproductwrapperClass> promotiongroups(string schemid){
        list<ivydsd__Scheme_Group__c> schmgrplist= [SELECT Id, Name,Product_Hierarchy__c,ivydsd__Scheme__c,ivydsd__Scheme__r.ivydsd__Scheme_Type__c,ivydsd__Scheme__r.ivydsd__Scheme_Get_Logic__c,ivydsd__Scheme__r.ivydsd__Scheme_Buy_Logic__c,(select id,ivydsd__Product1__c,ivydsd__Product1__r.name,Product_Value_Worth__c,qty__c from ivydsd__Scheme_Group_Details__r),(select id,ivydsd__Maximum_Value__c,ivydsd__Minimum_Value__c,Type__c from ivydsd__Scheme_Slab_Target__r),ivydsd__Group_Logic__c,ivydsd__Group_Type__c
                                                    FROM ivydsd__Scheme_Group__c where ivydsd__Group_Type__c='Buy' AND ivydsd__Scheme__c =:schemid ];
        system.debug('schmgrplist'+schmgrplist);
        list<ivydsd__Scheme_Group__c> schmgrppHrchy= new list<ivydsd__Scheme_Group__c>();
        //String a='SELECT Id, Name,Product_Hierarchy__c,Product_Hierarchy__r.Product_Hierarchy_Code__c FROM ivydsd__Scheme_Group__c where ivydsd__Group_Type__c=\'Buy\' AND ivydsd__Scheme__c =:'+schemid+' AND Product_Hierarchy__c!=null';
        //system.debug(a+'QUERY'+Database.query(a));
        schmgrppHrchy=[SELECT Id, Name,Product_Hierarchy__c,Product_Hierarchy__r.Product_Hierarchy_Code__c FROM ivydsd__Scheme_Group__c where ivydsd__Group_Type__c='Buy' AND ivydsd__Scheme__c =:schemid AND Product_Hierarchy__c!=null];

        //getting skus
        /*list<ivybase__Product__c> prdlistfrmHirarcy = new list<ivybase__Product__c>();
        if(schmgrppHrchy!=null && schmgrppHrchy.size()>0 ){
        prdlistfrmHirarcy=  getskus(schmgrppHrchy[0].Product_Hierarchy__r.Product_Hierarchy_Code__c);
            }*/
        list<schemegroupproductwrapperClass> wrapschemegroupprd= new list<schemegroupproductwrapperClass>();

        for(ivydsd__Scheme_Group__c sg:schmgrplist){

            system.debug('sg'+sg);
            schemegroupproductwrapperClass wrpcls= new schemegroupproductwrapperClass();
            wrpcls.ProGrpName=sg.Name;
            wrpcls.ProGrpLogic=sg.ivydsd__Group_Logic__c;
            wrpcls.promobuyloic=sg.ivydsd__Scheme__r.ivydsd__Scheme_Buy_Logic__c;
            wrpcls.schemetype=sg.ivydsd__Scheme__r.ivydsd__Scheme_Type__c;
            wrpcls.prodhirrecsID=sg.Product_Hierarchy__c;

            if(sg.Product_Hierarchy__c!=null){
                List<ivybase__Product__c> productunderHierarchy= getskusunderhirarchy(sg.Product_Hierarchy__c);
                List<productUnderProductHir> productunderHierarchyWrapper = new List<productUnderProductHir>();
                for(ivybase__Product__c p:productunderHierarchy)
                {
                    productUnderProductHir eachProduct = new productUnderProductHir();
                    eachProduct.ProdName=p.name;
                    eachProduct.Prodid=p.id;
                    productunderHierarchyWrapper.add(eachProduct);
                }

                wrpcls.prodhirrecs=productunderHierarchyWrapper;    
            }
            else{
                list<ivydsd__Scheme_Group_Product__c> innerlist= new list<ivydsd__Scheme_Group_Product__c>();
                list<productgrpprodcts> innerprdlist= new list<productgrpprodcts>();
                for(ivydsd__Scheme_Group_Product__c sgp:sg.ivydsd__Scheme_Group_Details__r){
                    productgrpprodcts eachgrpprd= new productgrpprodcts();
                        eachgrpprd.ProdctName=sgp.ivydsd__Product1__r.name;
                        eachgrpprd.Prodctid=sgp.ivydsd__Product1__c;
                    eachgrpprd.price=sgp.Product_Value_Worth__c;
                        //eachgrpprd.qty
                    innerlist.add(sgp);
                    innerprdlist.add(eachgrpprd);
                }


                wrpcls.ProGrpPrd=innerlist;
                wrpcls.ProGrpPrdcts=innerprdlist;
            }
            for(ivydsd__Scheme_Slab_Target__c sst:sg.ivydsd__Scheme_Slab_Target__r){
                wrpcls.slabtargetMin=sst.ivydsd__Minimum_Value__c;
                wrpcls.schemebuygrouptype=sst.Type__c;

            }
            wrapschemegroupprd.add(wrpcls);

        }
        system.debug('wrapschemegroupprd'+wrapschemegroupprd);
        return  wrapschemegroupprd;  
    }

    @AuraEnabled
    public static list<schemegetgroupproductwrapperClass> promotionfreegroups(list<id> schemid){
        list<ivydsd__Scheme_Group__c> schemgetgrplist= [SELECT Id, ivydsd__Scheme__r.ivydsd__Scheme_Type__c,ivydsd__Scheme__r.ivydsd__Scheme_Get_Logic__c,Name,(select id,ivydsd__Product1__c,Qty__c,ivydsd__Product1__r.name,Product_Value_Worth__c from ivydsd__Scheme_Group_Details__r),
                                                        (select id,Name,ivydsd__Scheme_Group__c,ivydsd__Free_Quantity__c,Scheme_Type__c,ivydsd__Free_Quantity_UOM__c,ivydsd__Maximum_Free_Quantity__c,ivydsd__Maximum_Percentage_Discount__c,ivydsd__Maximum_Price_Discount__c,ivydsd__Maximum_Rate_Discount__c,
                                                         ivydsd__Percentage_Discount__c,ivydsd__Price_Discount__c,Product_Value_Worth__c from ivydsd__Scheme_Free_Details__r),ivydsd__Scheme__c,ivydsd__Group_Logic__c,ivydsd__Group_Type__c
                                                        FROM ivydsd__Scheme_Group__c where ivydsd__Group_Type__c='Get' AND ivydsd__Scheme__c IN:schemid ];

        list<schemegetgroupproductwrapperClass> wrapschemegroupprd= new list<schemegetgroupproductwrapperClass>();
        for(ivydsd__Scheme_Group__c sg:schemgetgrplist){
            schemegetgroupproductwrapperClass schemeget= new schemegetgroupproductwrapperClass();
            schemeget.ProGrpName=sg.Name;
            schemeget.ProGrpLogic=sg.ivydsd__Group_Logic__c;
            schemeget.promogetlogic=sg.ivydsd__Scheme__r.ivydsd__Scheme_Get_Logic__c;
            schemeget.schemetype=sg.ivydsd__Scheme__r.ivydsd__Scheme_Type__c;
            //schemeget.schemegrouptype=
            list<ivydsd__Scheme_Group_Product__c> innerlist= new list<ivydsd__Scheme_Group_Product__c>();
            for(ivydsd__Scheme_Group_Product__c sgp:sg.ivydsd__Scheme_Group_Details__r){
                innerlist.add(sgp);
            }

            schemeget.ProGrpPrd=innerlist;
            for(ivydsd__Scheme_Free_Detail__c sfd:sg.ivydsd__Scheme_Free_Details__r){
                schemeget.Maxfreeqty=sfd.ivydsd__Maximum_Free_Quantity__c;
                schemeget.ValueWorth=sfd.Product_Value_Worth__c;
                schemeget.schemegrouptype=sfd.Scheme_Type__c;
            }
            wrapschemegroupprd.add(schemeget);
        }

        return wrapschemegroupprd;
    }

    @AuraEnabled
    public static void CreateLineItems(string wrpdata,id orderid){
        system.debug('wrpdata-->'+wrpdata);
        system.debug('OrderId-->'+orderid);
        try{
            list<ivydsd__Order_Line_Item__c> lineitem = new list< ivydsd__Order_Line_Item__c>();
            Type idArrType= Type.forName('List<schemegroupproductwrapperClass>');
            List<schemegroupproductwrapperClass> ids=(List<schemegroupproductwrapperClass>)JSON.deserialize(wrpdata, List<schemegroupproductwrapperClass>.class);
            system.debug('ids==='+ids);
            for(schemegroupproductwrapperClass orderdata: ids){
                for(ivydsd__Scheme_Group_Product__c prd:orderdata.ProGrpPrd){
                    if(prd.Qty__c !=null && prd.Qty__c!=0 ){
                        system.debug('orderdataqty'+prd.Qty__c);
                        ivydsd__Order_Line_Item__c ordline= new ivydsd__Order_Line_Item__c();
                        ordline.ivydsd__Order__c=orderid;
                        ordline.ivydsd__Product1__c=prd.ivydsd__Product1__c;
                        ordline.ivydsd__UOM_1_Quantity__c=prd.Qty__c;
                        ordline.ivydsd__UOM_1_Name__c='Piece';
                        lineitem.add(ordline);  
                    }
                }
            }
            system.debug('lineitem-->'+lineitem);
            if(lineitem.size()>0){
                insert lineitem;
            }
        }
        Catch(Exception e){
            system.debug('eror'+e.getMessage());
        }

    }


    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class schemegroupproductwrapperClass{
        @AuraEnabled public String ProGrpName {get;set;}
        @AuraEnabled public String ProGrpLogic {get;set;}
        @AuraEnabled public String promobuyloic{get;set;}
        @AuraEnabled public String schemetype{get;set;}
        @AuraEnabled public String schemebuygrouptype{get;set;}
        // @AuraEnabled public Decimal qty {get;set;}
        @AuraEnabled public Boolean checkBool {get;set;}
        @AuraEnabled public String ProdHirName {get;set;}
        @AuraEnabled public ID prodhirrecsID {get;set;}
        @AuraEnabled public list<productUnderProductHir> prodhirrecs {get;set;}
        @AuraEnabled public list<productUnderProductHir> SWAPprodhirrecs {get;set;}
        @AuraEnabled public list<ivydsd__Scheme_Group_Product__c> ProGrpPrd {get;set;}
        @AuraEnabled public list<productgrpprodcts> ProGrpPrdcts {get;set;}
        @AuraEnabled public Decimal slabtargetMin {get;set;}


        public schemegroupproductwrapperClass(){
            checkBool=False;

            //qty=0;
        }


    }
    public class productUnderProductHir{
        @AuraEnabled public Boolean prodcheckBool {get;set;}  
        @AuraEnabled public String ProdName {get;set;}
        @AuraEnabled public id Prodid {get;set;}
        @AuraEnabled public decimal quantity {get;set;}
        public productUnderProductHir()
        {
            prodcheckBool=false;
            quantity=0;
        }
    }

    public class productgrpprodcts{
        @AuraEnabled public String ProdctName {get;set;}
        @AuraEnabled public id Prodctid {get;set;}
        @AuraEnabled public decimal qty {get;set;}
        @AuraEnabled public decimal price{get;set;}
    }
    public class schemegetgroupproductwrapperClass{
        @AuraEnabled public String ProGrpName {get;set;}
        @AuraEnabled public String ProGrpLogic {get;set;}
        @AuraEnabled public String promogetlogic{get;set;}
        @AuraEnabled public String schemetype{get;set;}
        // @AuraEnabled public Decimal qty {get;set;}
        @AuraEnabled public Boolean checkBool {get;set;}
        //@AuraEnabled public String ProdHirName {get;set;}
        @AuraEnabled public list<ivydsd__Scheme_Group_Product__c> ProGrpPrd {get;set;}
        @AuraEnabled public Decimal Maxfreeqty {get;set;}
        @AuraEnabled public String schemegrouptype{get;set;}
        @AuraEnabled public Decimal ValueWorth {get;set;}


        public schemegetgroupproductwrapperClass(){
            checkBool=False;
            //qty=0;
        }

    }
     }