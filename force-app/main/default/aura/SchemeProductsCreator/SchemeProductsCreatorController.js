({
    init : function(component, event, helper) {
        console.log('config');
        helper.getconfigdata(component);	
        
    },
    BrandInit1 : function(component,event,helper) {
        helper.BrandInit(component,event);
    },
    showProducts : function(component, event, helper){
        $A.util.removeClass(component.find('producttable'), 'change');
        //component.set('v.checkRecords',true);
        var bool = true;
        // helper.searchKeyChange(component,event,bool);
        
        console.log('event'+event);
        helper.getParentTableColumn(component,event);
        
    },
    keyChange : function(cmp,event,helper){
        cmp.set("v.flag",true);
        //cmp.set('v.checkRecords',true);
        var bool= false;
        helper.searchKeyChange(cmp,event,bool);
    },
    handleCmpEvent : function(component,event,helper){
        var data = event.getParam("pagesize");
        component.set("v.pagesize", data);
        //helper.getjunctiondata(component);
        var bool= false;
        helper.searchKeyChange(component,event,bool);
    },
    
    
    Selectall:function(component,event){ 
       // alert(JSON.stringify(component.get("v.selectdlist")));
           /** To remove duplicates from selectdlist list **/
        if(component.get("v.selectdlist")!=null){
               var con = component.get("v.selectdlist");
               var uniqueObjs = [];
               //create a object with unique leads
               con.forEach(function(conItem) {
                   uniqueObjs[conItem] = conItem;
               });
               //reinitialise con array
               con = [];
               var keys = Object.keys(uniqueObjs);
               //fill up con again
               keys.forEach(function(key) {
                   con.push(uniqueObjs[key]);
               });
               component.set("v.selectdlist", con);
        }
               /** End of To remove duplicates from selectdlist list **/
        var reclist=component.get("v.recordList");
        var selectedlist=component.get("v.selectdlist");
        var boxPack = component.find("boxPack");
        if (!Array.isArray(boxPack)) {
            boxPack = [boxPack];
        }
        //alert(boxPack);
       // alert('****'+component.find("master").get("v.value"));
        if(component.find("master").get("v.value")==true){ 
            
            for (var i = 0; i < boxPack.length; i++) {
                if (boxPack[i].get("v.text") !== undefined) {
                    selectedlist.push(boxPack[i].get("v.text"));
                    boxPack[i].set("v.value", true);
                }
            }
        }
        else{
            for (var i = 0; i < boxPack.length; i++){
                boxPack[i].set("v.value",false);
            }  
        }
        //boxPack1.Set("v.value",true);
    },
    onSelection : function(component,event){
        var reclist=component.get("v.selectdlist");
        if(reclist==undefined){
            reclist =[];
        }
        if(event.getSource().get("v.value")){
            var recId = event.getSource().get("v.text");
            reclist.push(recId);
            component.set("v.selectdlist",reclist);
        }
        else{
            reclist = [];
            console.log("reclist"+reclist);
            for(var i=0;i<component.get("v.selectdlist").length;i++){
                if(component.get("v.selectdlist")[i]== event.getSource().get("v.text")){
                    
                }
                else{
                    reclist.push(component.get("v.selectdlist")[i]);
                }
            }
            component.set("v.selectdlist",reclist);
            // console.log("v.selectdlist",v.selectdlist)
            if(component.find("master").get("v.value")==true){
                component.find("master").set("v.value",false);
            }
        }
    },
    
    renderPage : function(component, event, helper){
        helper.paginateRecords(component);
    },
    
    renderJunctionPage : function(component, event, helper){
        helper.paginatejunctionRecords(component);
    },
    
    
    handleJunctionRecords: function(component,event,helper){
        
        var data = event.getParam("pagesize");
        component.set("v.junpagesize", data);
        helper.getjunctiondata(component);
        
    },
    
    
    createjunctionrecords : function(cmp,event,helper){
        console.log( cmp.get("v.recordId"));
        //console.log('column'+JSON.stringify(cmp.get("v.columnLabel")));
        var listSize = cmp.get("v.selectdlist");
        if(listSize.length>0){
            $A.util.removeClass(cmp.find('mySpinner'), 'change');
            var action=cmp.get("c.insertjunctionrecords");
            action.setParams({
                'secondParentlist' : cmp.get("v.selectdlist"),
                'Parent1': cmp.get("v.recordId"),
                'parentfields': cmp.get("v.configurationData").Product_Column_Name__c,
                'junctionObjname':  cmp.get("v.configurationData").Product_Object_API_Name__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                $A.util.addClass(cmp.find('mySpinner'), 'change');
                if (state === "SUCCESS") {
                    var data= response.getReturnValue();
                    $A.util.addClass(cmp.find('modalPopUp'), 'change');
                    // helper.getjunctiondata(cmp,event);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Success!",
                        message: 'Junction records created successfully',
                        type: 'success',
                        duration: '5000',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    
                    /*var sObectEvent = $A.get("e.force:navigateToSObject");
                sObectEvent .setParams({
                "recordId": cmp.get("v.recordId")
                
              });
              sObectEvent.fire();*/
                cmp.set("v.selectdlist",[]);
                var bool = false;
                helper.searchKeyChange(cmp,event, bool);
                
            } else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": 'ERROR: Please try again '
                });
                toastEvent.fire();                
            }
             
         });
            
            $A.enqueueAction(action);
        }
          else{
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                  "title": "Error!",
                  "type": "error",
                  "message": 'ERROR: Please select atleast one record '
              });
              toastEvent.fire();
          }
      },
    
})