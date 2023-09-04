({
    doInit : function(component, event, helper) {

        var recordId = component.get("v.recordId");
        var url = '/apex/NEU_OM_CreateItemsLines?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();

        console.log('valeria');

    }
})