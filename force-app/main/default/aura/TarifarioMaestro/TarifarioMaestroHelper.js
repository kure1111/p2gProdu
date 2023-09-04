({
    cargaTablaHelper : function(component, event) {
        var activo = component.get("v.factivo");
        var ruta = component.get("v.fruta");
        var carrier = component.get("v.fcarrier");
        var equipo = component.get("v.fequipo");
        var vigencia = component.get("v.fvigencia");
        var compra = component.get("v.fcompra");
        
        console.log("Activo: " + activo);
        console.log("Ruta: " + ruta);
        console.log("Carrier: " + carrier);
        console.log("Equipo: " + equipo);
        console.log("Vigencia: " + vigencia);
        console.log("Compra: " + compra);
        
        var action = component.get("c.consultaRates");
        action.setParams({
            "activo" : activo,
            "ruta" : ruta,
            "carrier" : carrier,
            "equipo" : equipo,
            "vigencia" : vigencia,
            "compra" : compra
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = JSON.parse(response.getReturnValue());
                records.forEach(function(record){
                    record.css = '';
                    if(record.rateName == null || record.rateName == ''){record.css = 'filaresumen';}
                });
                component.set("v.ratesList", records);
                if(component.get("v.ratesList").length > 0){
                    component.set("v.exportdisabled", false);
                }else{
                    component.set("v.exportdisabled", true);
                }
                component.find("Id_spinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    }
})