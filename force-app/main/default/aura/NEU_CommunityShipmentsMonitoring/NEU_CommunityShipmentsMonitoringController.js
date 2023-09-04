({
	init: function (cmp, event, helper) {

        helper.getShipments(cmp);
        helper.getShipmentsSeaImpo(cmp);
        helper.getShipmentsSeaExpo(cmp);

        window.setInterval(
            $A.getCallback(function() {
                helper.getShipments(cmp);
                helper.getShipmentsSeaImpo(cmp);
                helper.getShipmentsSeaExpo(cmp);
            }), 30000
        );
	},
})