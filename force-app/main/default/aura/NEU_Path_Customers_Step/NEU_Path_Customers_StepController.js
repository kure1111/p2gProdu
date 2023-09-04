({
	process : function(component, event, helper) 
    {
        var eType = component.get("v.eType");
        var active = component.get("v.active");
        
        if(eType == "cargo" && active == true)
        {
            var stepClickEvent = component.getEvent("stepClickCargo");
            stepClickEvent.fire();            
        }

        if(eType == "send" && active == true)
        {
            var stepClickEvent = component.getEvent("stepClickSendToP2G");
            stepClickEvent.fire();            
        }

        if(eType == "confirm" && active == true)
        {
            var stepClickEvent = component.getEvent("stepClickConfirmToP2G");
            stepClickEvent.fire();            
        }        
        
        if(eType == "reject" && active == true)
        {
            var stepClickEvent = component.getEvent("stepClickRejectToP2G");
            stepClickEvent.fire();            
        }
	}
})