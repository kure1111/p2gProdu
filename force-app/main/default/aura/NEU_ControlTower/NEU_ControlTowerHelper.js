({
    getShipment : function(cmp, shipment_id, freight_mode){
        var action = cmp.get("c.getShipment");
        action.setParams({shipment_id : shipment_id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.shipment", response.getReturnValue());
                
                var row_json = response.getReturnValue();
                var freight_mode = row_json['Freight_Mode__c'];
                
                if(freight_mode == 'Sea')
                {
                    jQuery("#capa_track_trace").css("display","block");
                    jQuery("#leyenda").css("display","");
                	jQuery(".capa_mapa").css("display","");
                    
                    var spinner = cmp.find("mySpinner");
                	$A.util.toggleClass(spinner, "slds-hide");
                }
                
                if(freight_mode == 'Road')
                {
                    this.getRoutePoints(cmp);
                    this.getShipmentTrack(cmp);
                    
                    jQuery("#capa_track_trace").css("display","block");
                	jQuery("#leyenda").css("display","");
                	jQuery(".capa_mapa").css("display","");
                }
                
                if(freight_mode == 'Air')
                {
                    jQuery("#capa_track_trace").css("display","block");
                	jQuery("#leyenda").css("display","block");
        			jQuery(".capa_mapa").css("display","block");
		
					var spinner = cmp.find("mySpinner");
                	$A.util.toggleClass(spinner, "slds-hide");
				}
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action); 
    },
    
    getPlannedShipments : function(cmp) {
        var action = cmp.get('c.getShipmentsPlanned');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Account_for__r) row.Account_for__rName = row.Account_for__r.Name;
                }
                cmp.set('v.planned_shipments', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getIntransitShipments : function(cmp) {
        var action = cmp.get('c.getIntransitShipments');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Account_for__r) row.Account_for__rName = row.Account_for__r.Name;
                }
                cmp.set('v.intransit_shipments', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getDeliveredShipments : function(cmp) {
        var action = cmp.get('c.getDeliveredShipments');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Account_for__r) row.Account_for__rName = row.Account_for__r.Name;
                }
                cmp.set('v.delivered_shipments', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getRoadShipments : function(cmp) {
        var action = cmp.get('c.getRoadShipments');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Account_for__r) row.Account_for__rName = row.Account_for__r.Name;
                }
                cmp.set('v.road_shipments', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getAirShipments : function(cmp) {
        var action = cmp.get('c.getAirShipments');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Account_for__r) row.Account_for__rName = row.Account_for__r.Name;
                }
                cmp.set('v.air_shipments', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
      
    sortData: function (cmp, fieldName, sortDirection, table_name) {
        var data = cmp.get(table_name);
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set(table_name, data);
    },
    
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },
    
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
        action.setParams({shipment_selected : cmp.get("v.shipment")});
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
    
    getRoadData : function(cmp){
		
        var action = cmp.get("c.getRoadData");
        action.setParams({shipment_selected : cmp.get("v.shipment")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.shipment_stops", response.getReturnValue());
				
                jQuery("#leyenda").css("display","block");
                jQuery(".capa_mapa").css("display","block");

			} else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
		$A.enqueueAction(action);
    },
})