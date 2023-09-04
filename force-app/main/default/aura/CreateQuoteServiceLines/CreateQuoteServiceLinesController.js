({
    rowSelection: function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRowsCount', selectedRows.length);
    },
    crearLineas: function(component, event, helper){
        var count = component.get("v.selectedRowsCount");
        console.log("Líneas seleccionadas: " + count);
        if(count < 1){helper.mensaje("error", "Debe seleccionar al menos una tarifa para crear service lines");return;}
        var lines = [];
        lines = component.find("ratesTable").getSelectedRows();
        var lineNumber = 1;
        lines.forEach(function(l){
            if(l.cantidad < 1){
                helper.mensaje("error", "Línea " + lineNumber +  ": 'Units' debe ser mayor a 0");
                return;
            }
            lineNumber++;
        });
        component.set("v.selectedRates", lines);
        helper.crearLineas(component, event);
    },
    handleSaveEdition: function (component, event, helper) {
        var listRates = component.get("v.ratesList");
        var draftValues = event.getParam('draftValues');
        console.log("DV: " + draftValues);
        draftValues.forEach(function(val){       
            var rowId = val.Id;
            var row;
            listRates.forEach(function(record){
                if(record.Id == rowId){row = record;}
            });            
            if(val.cantidad != null){row.cantidad = val.cantidad;}
            if(val.comentarios != null){row.comentarios = val.comentarios;}
            if(val.Fee_Rate__c != null){row.Fee_Rate__c = val.Fee_Rate__c;}
        });
        component.set("v.ratesList", listRates);
        component.set("v.draftValues", []);
    },
    handleCancelEdition: function (component) {},
    createRecord : function (component, event, helper) {
        var quote = component.get("v.quote");
        var createRecordEvent = $A.get("e.force:createRecord");
        
        var recordID = '0124T000000PU0kQAG';
        
     //   if(quote.FolioResume__c == "FN" && quote.Account_for__c == "0010R000019aZF8QAM")
      //		  recordID = "0120R000003Qo7wQAC" ;
       
        
        createRecordEvent.setParams({
            "entityApiName": "Fee__c",
            "recordTypeId": recordID,
            "defaultFieldValues": {
                'Account_for__c' : quote.Account_for__c,
                'Route__c': quote.Route__c,
                'Active__c': true
            },
            "navigationLocation" : "LOOKUP",
            "panelOnDestroyCallback": function(event) {
                helper.cargarRates(component, event);
            }
        });
        createRecordEvent.fire();
    },
    onInit : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Tarifario', fieldName: 'CustomRate__c', type: 'boolean', initialWidth: 80},
            {label: 'Rate Name', fieldName: 'Name', type: 'string', initialWidth: 170},
            {label: 'Group', fieldName: 'Group__c', type: 'string', initialWidth: 80},
            {label: 'SAP Service Type', fieldName: 'sapLink', type: 'url', initialWidth: 170,
             typeAttributes: {label: {fieldName: 'sapName'}, target:'_blank',  tooltip: {fieldName: 'sapName'}}},
            {label: 'Route', fieldName: 'linkRuta', type: 'url', initialWidth: 220,
             typeAttributes: {label: {fieldName: 'nombreRuta'}, target:'_blank', tooltip: {fieldName: 'nombreRuta'}}},
            {label: 'Valid Until', fieldName: 'Valid_Until__c', type: 'string', initialWidth: 110},
            {label: 'Account for', fieldName: 'linkCliente', type: 'url', initialWidth: 220,
             typeAttributes: {label: {fieldName: 'nombreCliente'}, target:'_blank', tooltip: {fieldName: 'nombreCliente'}}},            
            {label: 'Carrier', fieldName: 'linkCarrier', type: 'url', initialWidth: 150,
             typeAttributes: {label: {fieldName: 'nombreCarrier'}, target:'_blank', tooltip: {fieldName: 'nombreCarrier'}}},
            {label: 'TT Days', fieldName: 'TT_Days__c', type: 'string', initialWidth: 100},
            {label: 'Rate Type', fieldName: 'Rate_Type__c', type: 'string', initialWidth: 110},
            {label: 'Container Type', fieldName: 'linkEquipo', type: 'url', initialWidth: 160,
             typeAttributes: {label: {fieldName: 'nombreEquipo'}, target:'_blank', tooltip: {fieldName: 'nombreEquipo'}}},
            {label: 'Sell Rate', fieldName: 'Fee_Rate__c', type: 'currency', initialWidth: 120, editable: true, typeAttributes: { required:true, currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Buy Rate', fieldName: 'Buy_Rate__c', type: 'currency', initialWidth: 120, typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Units', fieldName: 'cantidad', type: 'integer', initialWidth: 100, editable: true, typeAttributes: { required: true}},
            {label: 'Comments Service Line', fieldName: 'comentarios', type: 'string', initialWidth: 230, editable: true, typeAttributes: { required: true}}
        ]);
        
        component.set('v.servicelinescolumns', [
            {label: 'Rate Category', fieldName: 'Service_Rate_Category__c', type: 'string', initialWidth: 130},
            {label: 'Rate Name', fieldName: 'rateName', type: 'string', initialWidth: 170},
            {label: 'Route', fieldName: 'route__c', type: 'string', initialWidth: 220},
            {label: 'Pickup / Delivery Zone', fieldName: 'deliveryZone', type: 'string', initialWidth: 170},
            {label: 'Valid Until', fieldName: 'validUntil', type: 'string', initialWidth: 110},
            {label: 'Account for', fieldName: 'linkCliente', type: 'url', initialWidth: 220,
             typeAttributes: {label: {fieldName: 'nombreCliente'}, target:'_blank', tooltip: {fieldName: 'nombreCliente'}}}, 
            {label: 'Rate Type', fieldName: 'Rate_Type__c', type: 'string', initialWidth: 110},
            {label: 'Total Volume (m3)', fieldName: 'totalVol', type: 'number', initialWidth: 130},
            {label: 'Total Weight (Kg)', fieldName: 'totalW', type: 'number', initialWidth: 130},
            {label: 'Container Type', fieldName: 'linkEquipo', type: 'url', initialWidth: 160,
             typeAttributes: {label: {fieldName: 'nombreEquipo'}, target:'_blank', tooltip: {fieldName: 'nombreEquipo'}}},
            {label: 'Units', fieldName: 'Units__c', type: 'number', initialWidth: 100},
            {label: 'Sell Price', fieldName: 'Quote_Sell_Price__c', initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Sell Amount', fieldName: 'Sell_Amount_Number__c', initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Std. Buy Price', fieldName: 'Quote_Buy_Price__c', initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Std. Buy Amount', fieldName: 'Std_Buy_Amount_Number__c', initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            {label: 'Comments Service Line', fieldName: 'Extension_Service_Name__c', initialWidth: 230, type: 'string'}
        ]);
        
        // Carga quote
        var myPageRef = component.get("v.pageReference");
        //var id = myPageRef.state.c__id;
        var id = component.get("v.recordId");
        console.log("Import-Export Quote ID: " + id);
        component.set("v.id", id);
        helper.cargarQuote(component, event);
        helper.isWTP(component, event);
        helper.cargarServiceLines(component, event);
        helper.cargarRates(component, event);
    }
})