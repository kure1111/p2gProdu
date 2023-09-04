({
	getShipments : function(cmp) {
        var action = cmp.get('c.getShipments');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.shipments', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    getShipmentsSeaImpo : function(cmp) {
            var action = cmp.get('c.getShipmentsSeaImpo');
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.shipmentsSeaImpo', response.getReturnValue());
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        },

        getShipmentsSeaExpo : function(cmp) {
                    var action = cmp.get('c.getShipmentsSeaExpo');
                    action.setCallback(this, $A.getCallback(function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            cmp.set('v.shipmentsSeaExpo', response.getReturnValue());
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            console.error(errors);
                        }
                    }));
                    $A.enqueueAction(action);
                },
})