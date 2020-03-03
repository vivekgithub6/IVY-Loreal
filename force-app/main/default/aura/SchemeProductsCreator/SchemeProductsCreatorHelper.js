({
    getconfigdata : function(cmp, event) {
        $A.util.removeClass(cmp.find('mySpinner'), 'change');
        var configName=cmp.get("v.configurationName");
        
        var action=cmp.get("c.getConfiguration");
        console.log("enetr");
        action.setCallback(this, function (response) {
            var state = response.getState();
            $A.util.addClass(cmp.find('mySpinner'), 'change');
            if (state === "SUCCESS") {
                console.log("hi");
                var data= response.getReturnValue();
                console.log('Configuration data'+JSON.stringify(data));
                cmp.set("v.configurationData",data.config);
                this.SignatureInit(cmp);
                this.BrandInit(cmp,event);
                //  cmp.set("v.SecondParentName",data.Parent2LabelName);
                //this.getjunctiondata(cmp);
                //this.getColumnName(cmp);
                //this.searchKeyChange(cmp,event);
                // Invoke apex to fetch existing junction records (write a separate function)
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
    },
    SignatureInit : function(component) {
        var action = component.get("c.getProductHierarchyLevel1");
        action.setParams({
            'levelName' : component.get("v.configurationData").Product_Hierarchy_Level_1_Name__c});
        
        action.setCallback(this, function(response) {
            //  alert(JSON.stringify(response.getReturnValue()));
            var list = response.getReturnValue();
            var signatures;
            /* for(var i=0;i<list.length;i++)
                 if(list[i].name!='Signature')
                     signatures.add(list[i].name);*/
            component.set("v.SignatureValues", list);
        })
        $A.enqueueAction(action);
    },
    BrandInit:function(component,event) {
        var action = component.get("c.getProductHierarchyLevel2");
        action.setParams({
            'level1Id' : component.get("v.selectedsignature"),
            'levelName':component.get("v.configurationData").Product_Hierarchy_Level_2_Name__c,
            'level1name':component.get("v.configurationData").Product_Hierarchy_Level_1_Name__c
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            var signatures;
            /* for(var i=0;i<list.length;i++)
                 console.log()
                 if(list[i].name!='Signature')
                     signatures.add(list[i].name);*/
            component.set("v.BrandValues", list);
        })
        $A.enqueueAction(action);
    },
    searchKeyChange : function(component,event, bool){
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
        $A.util.removeClass(component.find('parentSpinner'), 'change');
        var action = component.get('c.getSKURecord');
        var searchKey = component.find('searchId').get('v.value');
        
        var condition = component.get("v.configurationData").Search_Condition__c;
        
        var searchFieldList = component.get("v.configurationData").Product_Column_Name__c;
        var junctionObj = component.get("v.configurationData").Product_Object_API_Name__c;
        // var sortOrder = component.get("v.configurationData").jBuilder__Sort_Order__c;
        //alert('Search Field '+searchFieldList);
        //console.log("Action1");
        //console.log("ParentfieldName"+component.get("v.configurationData").Product_Column_Name__c);
       // console.log("Product_Object_API_Name__c"+junctionObj);
        action.setParams({
            'searchKey' : searchKey,
            'fieldNames' : component.get("v.configurationData").Product_Column_Name__c,
            'condition' : condition,
            'junctionObj' : junctionObj,
            
            'level2id':component.get("v.selectedbrand"),
            'levelName':component.get("v.configurationData").Product_Hierarchy_Level_2_Name__c,
            'bool' : component.get('v.flag'),
            'Parent1': component.get("v.recordId")
        });
        
        action.setCallback(this,function(response){
            console.log("hhh");
            var state = response.getState();
            $A.util.addClass(component.find('mySpinner'), 'change');
            $A.util.addClass(component.find('parentSpinner'), 'change');
            if(state === "SUCCESS"){
                console.log("hhh");
                component.set('v.queryRecords',response.getReturnValue());
                console.log("hhh");
                // helper.paginateRecords(component,JSON.stringify(response.getReturnValue()));
                console.log("hhhpagin");
                console.log(JSON.stringify(response.getReturnValue()));
                var pageNumber = component.get("v.pageval");
                var pgsize =component.get("v.pagesize");
                var pageRecords = response.getReturnValue().slice((pageNumber-1)*pgsize, pageNumber*pgsize);
                
                component.set("v.totalpages", Math.floor((response.getReturnValue().length +(pgsize-1))/pgsize));
                
                
                for(var i=0;i<pageRecords.length;i++){
                    for(var j=0;j<component.get("v.selectdlist").length;j++){
                        if(pageRecords[i].Id==component.get("v.selectdlist")[j]){
                            pageRecords[i].select = true;
                        }
                    }
                }

                if(bool== true && pageRecords.length==0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "type": "warning",
                        "message": 'Warning: No Records Found'
                    });
                    toastEvent.fire();
                }
                
                component.set('v.recordList', pageRecords);
                
                console.log('recordList'+ JSON.stringify(component.get('v.recordList')));
                
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error!",
                    message: 'ERROR: Please try again',
                    type: 'error',
                    duration: '5000',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
            component.find("master").set("v.value",false);  

           // alert(pageRecords.length);
            var count=0;
            for(var i=0;i<pageRecords.length;i++){
                for(var j=0;j<component.get("v.selectdlist").length;j++){
                    if(pageRecords[i].Id==component.get("v.selectdlist")[j] && pageRecords[i].select ==true){
                       //alert('inside for next'+JSON.stringify(pageRecords[i].select)); 
						count=count+1;
                    }
                }
            }
            if(count==pageRecords.length && bool==false)
                 component.find("master").set("v.value",true);  
            
        });
        
        $A.enqueueAction(action);
    },
    getParentTableColumn : function(component,event){
        console.log('helper'+component.get('v.configurationData').Product_Column_Name__c);
        var action = component.get('c.getParentFieldDetails');
        $A.util.removeClass(component.find('mySpinner'), 'change');
        action.setParams({
            'parentObjName' : component.get('v.configurationData').Product_Object_API_Name__c,
            'parentColumnName' : component.get("v.configurationData").Product_Column_Name__c,
        });
        action.setCallback(this,function(response) {
            $A.util.addClass(component.find('mySpinner'), 'change');
            $A.util.addClass(component.find('parentSpinner'), 'change');
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log("Successss");
                //    component.set("v.wrapperListParent",response.getReturnValue());
                var wrapperData = response.getReturnValue();
                
                var columnList= [{label:wrapperData[0].label, fieldName:wrapperData[0].fieldName, type: wrapperData[0].type}];
                for(var i=1;i<wrapperData.length;i++){
                    columnList.push({label:wrapperData[i].label, fieldName:wrapperData[i].fieldName, type: wrapperData[i].type});
                }
                
                component.set("v.columnLabelParent",columnList);
                console.log("columnList"+JSON.stringify(columnList));
                var bool = false;
                console.log("key");
                this.searchKeyChange(component,event,bool);
                // alert('column '+JSON.stringify(columnList));
            }else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "ERROR: Please try again"
                });
                //toastEvent.fire();      
                console.error(errors);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    paginateRecords : function(component){
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
        var bool=true;
        
        console.log("Paginate");
        var recordList = component.get("v.queryRecords");
        //  alert('recordList '+recordList);
        var pageNumber = component.get("v.pageval");
        var pgsize =component.get("v.pagesize");
        var pageRecords = recordList.slice((pageNumber-1)*pgsize, pageNumber*pgsize);
        
        component.set("v.totalpages", Math.floor((recordList.length +(pgsize-1))/pgsize));
        
        for(var i=0;i<pageRecords.length;i++){
            for(var j=0;j<component.get("v.selectdlist").length;j++){
                if(pageRecords[i].Id==component.get("v.selectdlist")[j]){
                    pageRecords[i].select = true;
                }
            }
        }
        
        component.set('v.recordList', pageRecords);
        component.find("master").set("v.value",false);
       // alert('rec lenght'+component.get("v.recordList").length);
       // alert('rec'+component.get("v.recordList"));
       // alert('page rec'+pageRecords.length);
        var selectedlist=component.get("v.selectdlist");
        var recordList1=component.get("v.recordList");
        if(selectedlist.length!=0){
            var boxPack = component.find("boxPack");
            if (!Array.isArray(boxPack)) {
                boxPack = [boxPack];
            }
            
            var count=0;
            for(var i=0;i<pageRecords.length;i++){
                for(var j=0;j<component.get("v.selectdlist").length;j++){
                    if(pageRecords[i].Id==component.get("v.selectdlist")[j] && pageRecords[i].select ==true){
                       console.log(JSON.stringify(pageRecords[i])+'inside for next'+JSON.stringify(pageRecords[i].select)); 
						count=count+1;
                    }
                }
            }
            if(count==pageRecords.length)
                 component.find("master").set("v.value",true);  

        }
       // alert( component.find("master").get("v.value"));
    }   
})