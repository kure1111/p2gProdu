({
    getRoutePoints : function(cmp) {
        var action = cmp.get('c.getRoutePoints');
        action.setParams({shipment_selected : cmp.get("v.shipment")});
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                cmp.set('v.route_points', rows);
                var spinner = cmp.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getShipmentTrack : function(cmp){
        var action = cmp.get("c.getShipmentTrack");
        action.setParams({recordId : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.shipment_track", response.getReturnValue());
                if(response.getReturnValue() != null)
                {
                    jQuery("#leyenda").css("display","none");
                	jQuery(".capa_mapa").css("display","none");
                }
			} else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
		$A.enqueueAction(action);
    },
})