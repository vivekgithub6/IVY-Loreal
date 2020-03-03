({
	getValues : function(component, event, helper) {
		
        var managerRecord = component.get("v.selectedManagerRecord");
        console.log('managerRecord'+ JSON.stringify(managerRecord));
        
        var repRecord = component.get("v.selectedrepRecord");
        console.log('managerRecord'+ JSON.stringify(repRecord));
        
	}
})