({
    doinit : function(component, event, helper) {
         //var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var action=component.get("c.getschemes");
        
        action.setCallback(this,function(response){
            //  var spinner = component.find("mySpinner");
            //$A.util.toggleClass(spinner, "slds-hide");
            var state=response.getState();
           //alert('state'+state);
            if(state=="SUCCESS"){//
                
                component.set("v.Scheme",response.getReturnValue());
                //alert(JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);      
        
    },
    keyChange:function(component, event, helper){
       console.log("hai");
        helper.searchKeyChange(component, event, helper);
        
    },
    ShowDetails:function(component, event, helper){
        component.set("v.Schemegroupwrapper",null);
        component.set("v.promotionQuantity",0);
        if(component.get("v.show")==true){
            component.set("v.show",false);
        }
        if(component.get("v.showfree")==true){
            component.set("v.showfree",false);
        }
       helper.showbuygrp(component,helper,event);
        helper.showFreeProducts(component, event, helper);
    },
    optIn:function(component, event, helper){
        var wrapper=component.get("v.schemegrp");
        
        console.log('****'+event.getSource().get("v.value"));
    },
    
    setval:function(component, event, helper){
        // component.set("v.promotionchangeQuantity",component.get("v.promotionQuantity"));
                var quant=component.get("v.promotionQuantity");
        if(quant>0){
        var wrapper=component.get("v.Schemegroupwrapper");
        //alert('MAin Wrapper'+JSON.stringify(wrapper));
        for(var i=0; i<wrapper.length;i++){
          //  alert();
          //alert('logic'+JSON.stringify(wrapper[i]));
            if(wrapper[i].ProGrpLogic=='AND'){
                var qty=(wrapper[i].slabtargetMin)*quant;
                var ProGrpPrdcts=wrapper[i].ProGrpPrdcts;
                
                var prdgrppush=[];
               // console.log('prdgrp'+JSON.stringify(prdgrp));
                var prdgrptot=0;
                for(var j=0;j<ProGrpPrdcts.length;j++){
                   // prdgrp[i].Qty__c=qty;
                  //prdgrppush.push(prdgrp[i]);  
               wrapper[i].ProGrpPrdcts[j].qty=qty;
                }
                //wrapper[i].ProGrpPrd=prdgrppush;
               console.log('updates'+JSON.stringify(wrapper[i].ProGrpPrd));

               // console.log('updated values'+);
               // console.log('prdgrppush--- '+JSON.stringify(prdgrppush));
              // wrapper[i].ProGrpPrd= prdgrppush;
            }
        }
        component.set("v.Schemegroupwrapper",wrapper);
        
        console.log( 'data  '+JSON.stringify(component.get("v.Schemegroupwrapper")));
    }
        ////---------
        if(quant>0){
        var wrapper=component.get("v.schemefreegrpwrapper");
        //alert('MAin Wrapper'+JSON.stringify(wrapper));
        for(var i=0; i<wrapper.length;i++){
         
          //alert('logic'+JSON.stringify(wrapper[i]));
            if(wrapper[i].ProGrpLogic=='AND'){
                var qty=(wrapper[i].Maxfreeqty)*quant;
                var prdgrp=wrapper[i].ProGrpPrd; 
                var prdgrppush=[];
               // console.log('prdgrp'+JSON.stringify(prdgrp));
                var prdgrptot=0;
                for(var j=0;j<prdgrp.length;j++){
                   // prdgrp[i].Qty__c=qty;
                  //prdgrppush.push(prdgrp[i]);  
               wrapper[i].ProGrpPrd[j].Qty__c=qty;
                }
                //wrapper[i].ProGrpPrd=prdgrppush;
               console.log('updates'+JSON.stringify(wrapper[i].ProGrpPrd));

               // console.log('updated values'+);
               // console.log('prdgrppush--- '+JSON.stringify(prdgrppush));
              // wrapper[i].ProGrpPrd= prdgrppush;
            }
        }
        component.set("v.schemefreegrpwrapper",wrapper);
        
        console.log( 'data  '+JSON.stringify(component.get("v.schemefreegrpwrapper")));
    }
    },
    
    ApplyPromotion: function(component, event, helper) {
        //alert('123456');
        
        //alert('freed products data'+JSON.stringify(component.get("v.schemefreegrpwrapper")));
        helper.createlineitems(component, event, helper);
    },
    createorder:function(component, event, helper) {
       helper.lineitemscreate(component,event, helper); 
    },
    closeModal: function(component, event, helper) {
        var cmpTarget1 = component.find('changeIt');
       // alert('asdfg');
        $A.util.addClass(cmpTarget1, 'change');
    },
})