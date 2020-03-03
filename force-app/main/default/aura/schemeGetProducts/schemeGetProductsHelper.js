({
    showbuygrp:function(component,helper,event){
        // var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-show");
        var action=component.get("c.promotiongroups");
        component.set("v.schemeid",component.find("Schemeid").get("v.value"));
        action.setParams({
            "schemid":component.find("Schemeid").get("v.value"),
        });
        action.setCallback(this,function(response){
            //var spinner = component.find("mySpinner");
            // $A.util.toggleClass(spinner, "slds-hide");
            var state=response.getState();
        // alert('state'+state);
            if(state=="SUCCESS"){
            //    var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
                component.set("v.Schemegroupwrapper",response.getReturnValue());
                component.set("v.show",true);
                console.log(JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action); 
        
    },
    searchKeyChange:function(component,helper,event) {
        //var action = component.get('c.getSKURecord');
        var searchKey = component.find('searchId').get('v.value');
        var entireWrapper = component.get("v.Schemegroupwrapper");
        var productHierarchyScheme;
        console.log(entireWrapper);
        for(var i=0;i<entireWrapper.length;i++)
        {
            if(entireWrapper[i].prodhirrecsID!=null)
            {
                productHierarchyScheme=entireWrapper[i];
            }
        }
        console.log(productHierarchyScheme);
        if(productHierarchyScheme.SWAPprodhirrecs==null)
        {
            productHierarchyScheme.SWAPprodhirrecs=productHierarchyScheme.prodhirrecs;
        }
        else
        {
            for(var i=0;i<productHierarchyScheme.prodhirrecs.length;i++)
            {
                if(productHierarchyScheme.SWAPprodhirrecs[i].Prodid==productHierarchyScheme.prodhirrecs[i].Prodid)
                {
                    productHierarchyScheme.SWAPprodhirrecs[i]=productHierarchyScheme.prodhirrecs[i];
                }  
            }
            productHierarchyScheme.prodhirrecs=productHierarchyScheme.SWAPprodhirrecs;  
        }
        
        console.log(productHierarchyScheme);
        var searchrelatedrecords=[];
        for(var i=0;i<productHierarchyScheme.prodhirrecs.length;i++)
        {
            var matchFound=false;
            
            var value = productHierarchyScheme.prodhirrecs[i].ProdName;
            
            
            if(value.toString().toLowerCase().indexOf(searchKey)!= -1)
            {
                matchFound=true;
            }
            if(matchFound)
            {
                searchrelatedrecords.push(productHierarchyScheme.prodhirrecs[i]);  
            }
        }
        
        productHierarchyScheme.prodhirrecs=searchrelatedrecords;
        
        for(var i=0;i<entireWrapper.length;i++)
        {
            if(entireWrapper[i].prodhirrecsID!=null)
            {
                entireWrapper[i]=productHierarchyScheme;
            }
        }
        component.set("v.Schemegroupwrapper",entireWrapper);
        
    },
    showFreeProducts : function(component,helper,event) {
        console.log('schemeid--->'+JSON.stringify(component.get("v.schemeid")));
        
        var action=component.get("c.promotionfreegroups");
        action.setParams({
            "schemid":component.get("v.schemeid")
        });
        action.setCallback(this,function(response){
            //var spinner = component.find("mySpinner");
            // $A.util.toggleClass(spinner, "slds-hide");
            var state=response.getState();
            //alert('state'+state);
            if(state=="SUCCESS"){
                
                component.set("v.schemefreegrpwrapper",response.getReturnValue());
                
                console.log(JSON.stringify(response.getReturnValue()));
                console.log('******'+JSON.stringify(component.get("v.Schemegroupwrapper")));
            }
        });
        //var cmpTarget1 = component.find('changeIt');
        //$A.util.removeClass(cmpTarget1, 'change');
        $A.enqueueAction(action);
    },
    
    createlineitems:function(component,helper,event) {
        var wrpdata= component.get("v.Schemegroupwrapper"); 
        var errorFound=false;
        var ErrorMessage='';
        var AnyConditionOneMatched=false;
        if(component.get("v.promotionQuantity")>0){
            var NoOfTimesPromotionApplied=component.get("v.promotionQuantity");
            for(var i=0;i<wrpdata.length;i++){
                if(wrpdata[i].schemetype=='QTY'){
                    if(wrpdata[i].promobuyloic=='AND'){
                        if(wrpdata[i].ProGrpPrdcts!=null){ //normal products
                            var slabtargetMinimum = wrpdata[i].slabtargetMin;
                            var targetToMeet = slabtargetMinimum*NoOfTimesPromotionApplied;
                            var quantityBoughtunderThisGroup=0;
                            for(var j=0;j<wrpdata[i].ProGrpPrdcts.length;j++){
                                quantityBoughtunderThisGroup=quantityBoughtunderThisGroup+wrpdata[i].ProGrpPrdcts[j].qty;
                            }
                            if(quantityBoughtunderThisGroup<targetToMeet)
                            {
                                errorFound=true; 
                                ErrorMessage='Slab Target not met';
                            }
                        }
                        else
                        {
                            var slabtargetMinimum = wrpdata[i].slabtargetMin;
                            var targetToMeet = slabtargetMinimum*NoOfTimesPromotionApplied;
                            var quantityBoughtunderThisGroup=0;
                            
                            //we got product hierarchy
                            for(var j=0;j<wrpdata[i].prodhirrecs.length;j++)
                            {
                                if(wrpdata[i].prodhirrecs[j].prodcheckBool){
                                    quantityBoughtunderThisGroup=quantityBoughtunderThisGroup+wrpdata[i].prodhirrecs[j].quantity;
                                }
                            }
                            if(quantityBoughtunderThisGroup<targetToMeet)
                            {
                                errorFound=true; 
                                ErrorMessage='Slab Target not met';
                            }
                            
                        }
                        
                    }
                    else if(wrpdata[i].promobuyloic=='ANY'){
                        
                        //any condition
                        if(wrpdata[i].ProGrpPrdcts!=null){ //normal products
                            var slabtargetMinimum = wrpdata[i].slabtargetMin;
                            var targetToMeet = slabtargetMinimum*NoOfTimesPromotionApplied;
                            var quantityBoughtunderThisGroup=0;
                            for(var j=0;j<wrpdata[i].ProGrpPrdcts.length;j++){
                                quantityBoughtunderThisGroup=quantityBoughtunderThisGroup+wrpdata[i].ProGrpPrdcts[j].qty;
                            }
                            if(quantityBoughtunderThisGroup>=targetToMeet)
                            {
                                errorFound=false;
                                AnyConditionOneMatched=true;
                            }
                            else
                            {
                                if(AnyConditionOneMatched)
                                {
                                    errorFound=false; 
                                }else
                                {
                                    errorFound=true;
                                    ErrorMessage='Slab Target not met'; 
                                }
                                
                                
                            }
                        }
                        else
                        {
                            var slabtargetMinimum = wrpdata[i].slabtargetMin;
                            var targetToMeet = slabtargetMinimum*NoOfTimesPromotionApplied;
                            var quantityBoughtunderThisGroup=0;
                            
                            //we got product hierarchy
                            for(var j=0;j<wrpdata[i].prodhirrecs.length;j++)
                            { 
                                if(wrpdata[i].prodhirrecs[j].prodcheckBool){
                                    quantityBoughtunderThisGroup=quantityBoughtunderThisGroup+wrpdata[i].prodhirrecs[j].quantity;
                                }
                            }
                            if(quantityBoughtunderThisGroup>=targetToMeet)
                            {
                                errorFound=false;
                                AnyConditionOneMatched=true;
                            }
                            else
                            {
                                if(AnyConditionOneMatched)
                                {
                                    errorFound=false; 
                                }else
                                {
                                    errorFound=true;
                                    ErrorMessage='Slab Target not met'; 
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                } else if(wrpdata[i].schemetype=='SV'){
                    if(wrpdata[i].promobuyloic=='ANY'){
                        if(wrpdata[i].ProGrpPrdcts!=null){
                            //Writing for Normal Products
                           var slabtargetMinimum = wrpdata[i].slabtargetMin;
                            var targetToMeet = slabtargetMinimum*NoOfTimesPromotionApplied;
                            //alert('targetToMeet'+targetToMeet);
                            var quantityBoughtunderThisGroup=0;
                            for(var j=0;j<wrpdata[i].ProGrpPrdcts.length;j++){
                                quantityBoughtunderThisGroup=quantityBoughtunderThisGroup+wrpdata[i].ProGrpPrdcts[j].qty*wrpdata[i].ProGrpPrdcts[j].price;
                            }
                            //alert(quantityBoughtunderThisGroup +' targetToMeet '+targetToMeet);
                            if(quantityBoughtunderThisGroup<targetToMeet)
                            {
                                errorFound=true; 
                                ErrorMessage='Slab Target not met';
                            } 
                            
                        }
                        else{
                            
                            //hirarchy logic.
                        }
                    }
                    
                }
            }
        }
        else
        {
            errorFound=true;
            ErrorMessage='Apply Promotion first';
            
        }
        if(errorFound && AnyConditionOneMatched==false)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":'error',
                "message": ErrorMessage
            });
            toastEvent.fire();
        }
        else
        {//no error all success case 
            component.set("v.showfree",true);
            component.set("v.show",false);
        }
    },
    
    lineitemscreate:function(component,helper,event) {
        
        
        var wrpdata= component.get("v.schemefreegrpwrapper");
        console.log('***wrpdata  '+JSON.stringify(wrpdata));
        var check=false;
        //var any= false;
        var qty = false;
        var valuebased=false;
        var totalReqQuan=0;
        var totalQt=0;
        var AnyAnd=false;
        var iterBool=false;
        var AnyANy=false;
        var iterBool2=false;
        var AndAny=false;
        var iterBool3=false;
        var BuyLogic='No';
        var iterBool4=false;
        var SatisfyTotal=true;
        var type='';
        var it=0;
        var Grptype='';
        for(var i=0;i<wrpdata.length;i++){
            console.log('totalqty'+totalReqQuan);
            BuyLogic= wrpdata[i].promogetlogic;
            type=wrpdata[i].schemetype;
            if(wrpdata[i].schemetype=='QTY'){
                if(wrpdata[i].ProGrpPrd!=null){
                    for( var j=0;j<wrpdata[i].ProGrpPrd.length;j++){
                        if(wrpdata[i].schemegrouptype=='SV'){
                            Grptype='SV';
                            totalReqQuan=component.get("v.promotionQuantity")*wrpdata[i].ValueWorth;
                            totalQt=totalQt+(wrpdata[i].ProGrpPrd[j].Qty__c*wrpdata[i].ProGrpPrd[j].Product_Value_Worth__c);
                            if(totalReqQuan<totalQt) qty==false;
                            else qty=true;
                            //alert('check');
                        }
                        
                        else  if(wrpdata[i].promogetlogic=='AND' && component.get("v.promotionQuantity")!=0 ){
                            totalReqQuan= component.get("v.promotionQuantity")*wrpdata[i].Maxfreeqty;
                           // alert('totalReqQuan'+totalReqQuan);
                            if(wrpdata[i].ProGrpLogic=='ANY'){
                                if(iterBool2==false){
                                    totalQt=0;
                                    iterBool2=true;
                                }
                                // alert('check'+JSON.stringify(wrpdata[i]));
                                //alert('qtyyyy'+wrpdata[i].ProGrpPrd[j].Qty__c);
                                if(wrpdata[i].ProGrpPrd[j].Qty__c!='undefined' &&  wrpdata[i].ProGrpPrd[j].Qty__c!='NaN'){
                                    //alert(totalQt+'tot');
                                    totalQt=totalQt+ wrpdata[i].ProGrpPrd[j].Qty__c;     
                                }
                                console.log('totalQt'+totalQt);  
                                
                                
                            }
                            if(wrpdata[i].ProGrpLogic=='AND') 	qty=true;
                            
                        } 
                            else if(wrpdata[i].promogetlogic=='ANY' && component.get("v.promotionQuantity")!=0 ){
                                // totalReqQuan=component.get("v.promotionQuantity");
                                
                                if( wrpdata[i].ProGrpLogic=='AND'    ){
                                    if(iterBool3==false){
                                        totalQt=0;
                                        iterBool3=true;
                                    }
                                    totalReqQuan=component.get("v.promotionQuantity")*wrpdata[i].Maxfreeqty;
                                    if(wrpdata[i].ProGrpPrd[j].Qty__c !='undefined' && wrpdata[i].ProGrpPrd[j].Qty__c!='NaN' ){
                                        totalQt=totalQt+wrpdata[i].ProGrpPrd[j].Qty__c;
                                    }
                                    
                                }
                                
                                if( wrpdata[i].ProGrpLogic=='ANY'  ){
                                    if(iterBool==false){
                                        totalQt=0;
                                        iterBool=true;
                                    }
                                    totalReqQuan=component.get("v.promotionQuantity")*wrpdata[i].Maxfreeqty;
                                    
                                    if(wrpdata[i].ProGrpPrd[j].Qty__c!='undefined' && wrpdata[i].ProGrpPrd[j].Qty__c!='NaN'){
                                        //alert(totalQt+'tot');
                                        totalQt=totalQt+ wrpdata[i].ProGrpPrd[j].Qty__c;    
                                        
                                    }
                                    //alert(totalQt+'tot234');
                                }
                                
                                //main any products
                                
                            }
                    }
                }}
            else {
                if(wrpdata[i].ProGrpLogic=='AND') 	qty=true;
                else if(iterBool4==false){
                    totalQt=0;
                    iterBool4=true;
                }
                //alert('iterBool4'+iterBool4);
                if(wrpdata[i].ProGrpPrd!=null){
                    for(var j=0;j<wrpdata[i].ProGrpPrd.length;j++){
                        totalReqQuan=component.get("v.promotionQuantity")*wrpdata[i].Maxfreeqty;
                        if(wrpdata[i].ProGrpPrd[j].Qty__c !='undefined' ){
                            totalQt=totalQt+(wrpdata[i].ProGrpPrd[j].Qty__c);  
                        }
                    } 
                }
                
            }
            
            //alert(totalReqQuan+'totalQt'+totalQt+'qty'+qty);
            if(( totalReqQuan<totalQt)){
               // alert('inside break'+iterBool)
                // qty=true;
                if(iterBool2==true) AndAny=true;
                else if(iterBool==true)   { 
                    AnyANy=true; 
                    it=it+1;
                }
                    else  if(iterBool3==true  )  {
                        AnyAnd=true;
                        it=it+1;
                    }
                
                /*else  if(iterBool4==true){  
                            SatisfyTotal=false;
                            alert('SatisfyTotal'+SatisfyTotal);
                        }*/
                
            }else  if(iterBool4==true){  
                SatisfyTotal=false;
                //alert('SatisfyTotal'+SatisfyTotal);
            }
        }
        if(BuyLogic=='ANY' && Grptype!='SV' ){
            
            if(type=='QTY'  ){
                //alert(AnyAnd+'checsf'+AnyANy+'it'+it);
                if((AnyAnd==false || AnyANy==false) && it==2  ){
                    //alert(AnyAnd+'AnyANy'+AnyANy);
                    qty=true; //changd
                }
                else  if((AnyANy==true && AnyAnd==false)&& it==1){
                    qty=false;
                }
                    else  if((AnyANy==false && AnyAnd==true)&& it==1){
                        qty=false;
                    }
                        else  qty=true;// changed
            }
            else{
                if(iterBool4==true && SatisfyTotal==false) qty=true;
                else qty=true;//changed
            }
        }
        else if(AndAny==true){
            //alert('check'+AndAny);
            qty=false; //chnaged
        }
        
       // alert('qty+++++' +qty);
        /* if(check==false){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":'error',
                "message": "Have to select  products from all groups."
            });
            toastEvent.fire();
        }*/
        //changed
        if(qty==false){
            //alert('inside');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":'error',
                "message": "Get products limit exceeded."
            });
            toastEvent.fire();
        }
        if(check==false && qty==false){
            
        }
        /*if(check==false && any==false && qty==false && valuebased==false){
            
            alert('INSIDE FALSE');
            var recordid= component.get("v.recordId");
            console.log('reordid '+JSON.stringify(recordid));
            var action=component.get("c.CreateLineItems");
            action.setParams({
                "wrpdata":JSON.stringify(component.get("v.Schemegroupwrapper")),
                "orderid":component.get("v.recordId")
            });
            
            action.setCallback(this,function(response){
                //var spinner = component.find("mySpinner");
                // $A.util.toggleClass(spinner, "slds-hide");
                var state=response.getState();
                //alert('state'+state);
                if(state=="SUCCESS"){
                    console.log('Created Success fully');
                }
            });
            
            $A.enqueueAction(action);
        }*/
    }
})