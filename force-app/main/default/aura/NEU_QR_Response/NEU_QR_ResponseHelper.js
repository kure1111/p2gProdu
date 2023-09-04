({
    
    getWareHousesExit : function(component) {
        var action = component.get('c.getWareHousesExit');
        action.setParams({
            exitId : component.get('v.exitorder')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                if(rows.length != 0)
                {    
                    component.set('v.item', rows);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getWareHousesExitByShipment : function(component) {
        var action = component.get('c.getWareHousesExitByShipment');
        console.log(component.get('v.recordId'));
        console.log(component.get('v.pallet'));
        action.setParams({
            shipId : component.get('v.recordId'),
            pallet : component.get('v.pallet')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                component.set('v.item', rows);
                console.log(rows);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getInventoryExits : function(component) {
        
        var action = component.get('c.getInventoryExits');
        action.setParams({
            exitId : component.get('v.exitorder'),
            pallet:component.get('v.pallet')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                //component.set('v.wh_lines', rows);
                //component.set('v.items_lines', rows);
                component.set('v.inventory_entries', rows);
                if( component.get('v.inventory_entries').length == 0)
                {
                    getShipmentCargoLines(component);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getInventoryExitsByShipment : function(component) {
        
        var action = component.get('c.getInventoryExitsByShipment');
        action.setParams({
            shipId : component.get('v.recordId'),
            pallet:component.get('v.pallet')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                component.set('v.wh_lines', rows);
                component.set('v.items_lines', rows);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getShipmentCargoLines : function(component) 
    {
        var action = component.get('c.getShipmentCargoLines');
        action.setParams({
            shipId : component.get('v.recordId'),
            pallet:component.get('v.pallet')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                component.set('v.shipment_lines', rows);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getInvetoryEntries : function(component) 
    {
        var action = component.get('c.getInvetoryEntries');
        action.setParams({
            shipId : component.get('v.recordId'),
            pallet:component.get('v.pallet')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                component.set('v.inventory_entries', rows);
                if( component.get('v.inventory_entries').length == 0)
                {
                    getShipmentCargoLines(component);
                }

            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    //get url params by name
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
})