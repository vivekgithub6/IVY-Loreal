({
	firstPage : function(component, event, helper) {
		component.set("v.curntpage", 1);
	},
    prevPage : function(component, event){
        component.set("v.curntpage", Math.max(component.get('v.curntpage')-1, 1));
    },
    nextPage : function(component,event){
        component.set("v.curntpage", Math.min(component.get('v.curntpage')+1, component.get("v.totalpages")));
    },
    lastPage : function(component,event){
        component.set("v.curntpage", component.get("v.totalpages"));
    },
    onSelectChange : function(component,event){
        if(component.get("v.junctionTable")){ 
            console.log('if');
       var selected = component.find("levels").get("v.value");
       var cmpEvent = component.getEvent("cmpEventJn");
        cmpEvent.setParams({
            "pagesize" : selected  });
        cmpEvent.fire();
        }
        else{
            console.log('else');
            var selected = component.find("levels").get("v.value");
       var cmpEvent = component.getEvent("cmpEvent");
        cmpEvent.setParams({
            "pagesize" : selected  });
        cmpEvent.fire(); 
        }
    }
})