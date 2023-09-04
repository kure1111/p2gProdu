({
    cargaTabla : function(component, event, helper) {
        component.set('v.mycolumns', [
            //   {label: 'Activo', fieldName: 'Active__c', type: 'boolean'},
            {label: 'Cliente', fieldName: 'linkCliente', type: 'url',
             typeAttributes: {label: {fieldName: 'nombreCliente'}, target:'_blank', tooltip: {fieldName: 'nombreCliente'}}},
            {label: 'Customer ID', fieldName: 'customerID', type: 'string'},
            {label: 'Rate Name', fieldName: 'linkName', type: 'url', 
             typeAttributes: {label: {fieldName: 'Name'}, target:'_blank',  tooltip: {fieldName: 'Name'}}},
            {label: 'Route', fieldName: 'linkRuta', type: 'url',
             typeAttributes: {label: {fieldName: 'nombreRuta'}, target:'_blank', tooltip: {fieldName: 'nombreRuta'}}},
            {label: 'Container Type', fieldName: 'linkEquipo', type: 'url',
             typeAttributes: {label: {fieldName: 'nombreEquipo'}, target:'_blank', tooltip: {fieldName: 'nombreEquipo'}}},
            {label: 'Sell Rate', fieldName: 'Fee_Rate__c', type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
            
            // {label: 'RecordType', fieldName: 'tipoRegistro', type: 'string'},
            //{label: 'Rate Category', fieldName: 'Fee_Category__c', type: 'string'},
            //{label: 'TT Days', fieldName: 'TT_Days__c', type: 'string'},
            {label: 'SAP ST', fieldName: 'sapstid', type: 'string'},
            //   {label: 'Rate Type', fieldName: 'Rate_Type__c', type: 'string'},
            {label: 'Vigencia', fieldName: 'Valid_Until__c', type: 'string'}
            // {label: 'CreatedBy', fieldName: 'creadoPor', type: 'string'}            
        ]);
    },
    cargaDatos: function(component, event, helper){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        helper.cargaTablaHelper(component, event);
    }, 
    exportarCsv: function(component, event, helper){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        
        var data = component.get("v.ratesList");
        var csv = helper.convertirCSV(component, data);
        console.log('csv: ' + csv);
        component.find("Id_spinner").set("v.class" , 'slds-hide');
        
        if (csv == null){return;}
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,%EF%BB%BF' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'ExportTarifario.csv';
        document.body.appendChild(hiddenElement);
        hiddenElement.click();
    }
})