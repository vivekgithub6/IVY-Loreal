({
    selectRecord : function(component, event, helper){  
        
        //console.log('single Record :'+ component.get("v.singleRecord"));
        // call the event   
        var compsearchEvent = component.getEvent("selectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compsearchEvent.setParams({
            "recordByEvent" : component.get("v.singleRecord") 
        });  
        // fire the event  
        compsearchEvent.fire();
    },
})