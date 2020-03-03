({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        let action = component.get("c.fetchLookUpValues");
        // set param to method  
        console.log('resourceType ' + component.get("v.resourceType"));
        console.log('managerId ' +  component.get("v.ManagerRecord").Id);
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'resourceType' : component.get("v.resourceType"),
            'managerId' : component.get("v.ManagerRecord").Id
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            let state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
})