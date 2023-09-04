({
   	init : function (cmp, event, helper) {
        var action = cmp.get("c.getShipment");
        action.setParams({recordId : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.shipment", response.getReturnValue());
                console.log(response.getReturnValue());
                var row_json = response.getReturnValue();

                if(row_json['Freight_Mode__c'] == 'Sea' || row_json['Freight_Mode__c'] == 'Air')
                {
                    var spinner = cmp.find("mySpinner");
        			$A.util.toggleClass(spinner, "slds-hide");
				}
                
                if(row_json['Freight_Mode__c'] == 'Road')
                {
                    helper.getShipmentTrack(cmp);
                    helper.getRoutePoints(cmp);
                }
			}
        });
		$A.enqueueAction(action);
    },
})