({
    cargarQuote : function(component, event) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var qId = component.get("v.id");
        var action = component.get("c.getQuote");
        action.setParams({"quoteId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                component.set("v.quote", respuesta);
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
        action.setParams({"quoteId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    if(record.Service_Rate_Name__c != null){record.rateName = record.Service_Rate_Name__r.Name;}else{record.rateName = '';}
                    if(record.Service_Rate_Name__c != null && record.Service_Rate_Name__r.Delivery_Zone__c != null){
                        record.deliveryZone = record.Service_Rate_Name__r.Delivery_Zone__r.Name;
                    }else{
                        record.deliveryZone = "";
                    }
                    record.validUntil = record.Service_Rate_Name__r.Valid_Until__c;
                    if(record.Service_Rate_Name__c != null && record.Service_Rate_Name__r.Account_for__c != null){record.linkCliente = "/" + record.Service_Rate_Name__r.Account_for__c;}else{record.linkCliente = '/#';}
                    if(record.Service_Rate_Name__c != null && record.Service_Rate_Name__r.Account_for__c != null){record.nombreCliente = record.Service_Rate_Name__r.Account_for__r.Name;}else{record.nombreCliente = '';}
                    record.totalVol = record.Import_Export_Quote__r.Total_Volume_m3_2__c;
                    record.totalW = record.Import_Export_Quote__r.Total_Weight_Kg2__c;
                    if(record.Service_Rate_Name__c != null && record.Service_Rate_Name__r.Container_Type__c != null){record.nombreEquipo = record.Service_Rate_Name__r.Container_Type__r.Name;}else{record.nombreEquipo = '';}
                    if(record.Service_Rate_Name__c != null && record.Service_Rate_Name__r.Container_Type__c != null){record.linkEquipo = '/'+record.Service_Rate_Name__r.Container_Type__c;}else{record.linkEquipo = '/#';}
                });
                component.set("v.serviceLines", response.getReturnValue());
            }            
            component.find("Id_spinner").set("v.class" , 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    cargarRates: function(component, event){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var qId = component.get("v.id");
        var action = component.get("c.consultaRates");
        action.setParams({"quoteId" : qId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    if(record.SAP_Service_Type__c != null){record.sapName = record.SAP_Service_Type__r.Name;}else{record.sapName = '';}
                    if(record.SAP_Service_Type__c != null){record.sapLink = '/' + record.SAP_Service_Type__c;}else{record.sapLink = '/#';}
                    if(record.Route__c != null){record.nombreRuta = record.Route__r.Name;}else{record.nombreRuta = '';}
                    if(record.Route__c != null){record.linkRuta = '/'+record.Route__c;}else{record.linkRuta = '/#';}
                    if(record.Account_for__c != null){record.nombreCliente = record.Account_for__r.Name;}else{record.nombreCliente = '';}
                    if(record.Account_for__c != null){record.linkCliente = '/'+record.Account_for__c;}else{record.linkCliente = '/#';}
                    if(record.Carrier_Account__c != null){
                        record.linkCarrier = '/' + record.Carrier_Account__c;
                        record.nombreCarrier = record.Carrier_Account__r.Name;
                    }
                    else{
                        record.linkCarrier = '';
                        record.nombreCarrier = '';
                    }
                    if(record.Container_Type__c != null){record.nombreEquipo = record.Container_Type__r.Name;}else{record.nombreEquipo = '';}
                    if(record.Container_Type__c != null){record.linkEquipo = '/'+record.Container_Type__c;}else{record.linkEquipo = '/#';}
                    record.cantidad = 1;
                    //record.comentarios = '';
                    if(record.Comments__c != null){record.comentarios = record.Comments__c;}else{record.comentarios = '';}
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
        var action = component.get("c.createLineas");
        action.setParams({"quoteId" : qId, "jsn" : jsonlines});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var respuesta = response.getReturnValue();
                if(respuesta == "ok"){
                    this.cargarServiceLines(component, event);
                    this.cargarRates(component, event);
                    this.mensaje("success", "Import-Export Service Lines created!");
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