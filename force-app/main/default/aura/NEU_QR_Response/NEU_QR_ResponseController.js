({
    init : function(component, event, helper)
    {
        //var shipmentId = component.get('v.recordId');
        var weoId = helper.getParameterByName(component , event, 'exitorder');
        var pallet = helper.getParameterByName(component , event, 'pallet');
        var shipmentId = helper.getParameterByName(component , event, 'shipment');


        
        if(shipmentId != undefined && shipmentId != '')
        {
            //alert('Shipment Id: '+shipmentId);
            //helper.getShipments(component,weoId);
            component.set('v.recordId',shipmentId); 
            component.set('v.pallet',pallet);
            
            helper.getInvetoryEntries(component);
            
            //helper.getWareHousesExitByShipment(component);
            //helper.getInventoryExitsByShipment(component);
        }        
        else if(weoId != undefined && weoId != undefined)
        {
            component.set('v.exitorder',weoId); 
            component.set('v.pallet',pallet);
            helper.getWareHousesExit(component);
            helper.getInventoryExits(component);
        }
        
    },
})