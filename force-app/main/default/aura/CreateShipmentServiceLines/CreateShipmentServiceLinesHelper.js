({
    cargarShipment : function(component, event) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var qId = component.get("v.id");
        var action = component.get("c.getShipment");
        action.setParams({"shipId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                component.set("v.shipment", respuesta);
                console.log("cargar shipment OK");
            }            
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    isWTP : function(component, event) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var qId = component.get("v.id");
        var action = component.get("c.isWTP");
        action.setParams({"quoteId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                component.set("v.isWTP", respuesta);
            }            
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    cargarServiceLines: function(component, event){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var qId = component.get("v.id");
        var action = component.get("c.consultaServiceLines");
        action.setParams({"shipId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Carga ssl response OK");
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.rateName = record.Service_Rate_Name__r.Name;
                    if(record.Service_Rate_Name__r.Delivery_Zone__c != null){
                        record.deliveryZone = record.Service_Rate_Name__r.Delivery_Zone__r.Name;
                    }else{
                        record.deliveryZone = "";
                    }
                    record.route__c = record.Shipment__r.Route__r.Name;
                    record.validUntil = record.Service_Rate_Name__r.Valid_Until__c;
                    record.linkCliente = "/" + record.Service_Rate_Name__r.Account_for__c;
                    record.nombreCliente = record.Service_Rate_Name__r.Account_for__r.Name;
                    record.totalVol = record.Shipment__r.Total_Volume_m3__c;
                    record.totalW = record.Shipment__r.Total_Weight_Kg__c;
                    
                    if(record.Service_Rate_Name__r.Container_Type__c != null){
                        record.nombreEquipo = record.Service_Rate_Name__r.Container_Type__r.Name;
                        
                        record.linkEquipo = '/'+record.Service_Rate_Name__r.Container_Type__c;
                    }
                });
                component.set("v.serviceLines", response.getReturnValue());
                console.log("Carga ssl OK");
            }            
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    cargarRates: function(component, event){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var qId = component.get("v.id");
        var action = component.get("c.consultaRates");
        action.setParams({"shipId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.sapName = record.SAP_Service_Type__r.Name;
                    record.sapLink = '/' + record.SAP_Service_Type__c;
                    record.nombreRuta = record.Route__r.Name;
                    record.linkRuta = '/'+record.Route__c;
                    record.nombreCliente = record.Account_for__r.Name;
                    record.linkCliente = '/'+record.Account_for__c;
                    if(record.Carrier_Account__c != null){
                        record.linkCarrier = '/' + record.Carrier_Account__c;
                        record.nombreCarrier = record.Carrier_Account__r.Name;
                    }
                    else{
                        record.linkCarrier = '';
                        record.nombreCarrier = '';
                    }
                    
                    if(record.Container_Type__c != null)
                    {
                        record.nombreEquipo = record.Container_Type__r.Name;       
                        record.linkEquipo = '/'+record.Container_Type__c;
                    }
                    record.cantidad = 1;
                    record.comentarios = '';
                });
                component.set("v.ratesList", response.getReturnValue());
            }            
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    crearLineas: function(component, event){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var lineas = component.get("v.selectedRates");
        var qId = component.get("v.id");
        var lines = [];
        lineas.forEach(function(l){
            var line = new Object();
            line.rate = l.Id;
            line.units = l.cantidad;
            line.comments = l.comentarios;
            line.feecategory = l.Fee_Category__c;
            line.currencycode = l.CurrencyIsoCode;
            line.sell = l.Fee_Rate__c;
            line.buy = l.Buy_Rate__c;
            lines.push(line);
        });
        var jsonlines = JSON.stringify(lines);
        console.log("Lines: " + jsonlines);
        console.log("shipId: " + qId);
        var action = component.get("c.createLineas");
        action.setParams({"shipId" : qId, "jsn" : jsonlines});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                if(respuesta == "ok"){
                    this.cargarServiceLines(component, event);
                    this.cargarRates(component, event);
                    this.mensaje("success", "Shipment Service Lines created!");
                    $A.get('e.force:refreshView').fire();
                }else{
                    this.mensaje("error", respuesta);
                }
            }
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    mensaje: function(tipo, mensaje){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: mensaje,
            type: tipo
        });
        toastEvent.fire();
    }
})