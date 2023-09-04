({
    cargaTabla : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Activo', fieldName: 'activo', type: 'boolean', cellAttributes: { class: {fieldName: 'css'}}},
            {label: 'Rate Name', fieldName: 'linkName', type: 'url', cellAttributes: { class: {fieldName: 'css'}},
             typeAttributes: {label: {fieldName: 'rateName'}, target:'_blank',  tooltip: {fieldName: 'rateName'}}},
            {label: 'RecordType', fieldName: 'recordType', type: 'string', cellAttributes: { class: {fieldName: 'css'}}},
            {label: 'Rate Category', fieldName: 'rateCategory', type: 'string', cellAttributes: { class: {fieldName: 'css'}}},
            {label: 'Rate Type', fieldName: 'rateType', type: 'string', cellAttributes: { class: {fieldName: 'css'}}},
            {label: 'Carrier', fieldName: 'linkCarrier', type: 'url', cellAttributes: { class: {fieldName: 'css'}},
             typeAttributes: {label: {fieldName: 'carrier'}, target:'_blank', tooltip: {fieldName: 'carrier'}}},
            {label: 'Route', fieldName: 'linkRuta', type: 'url', cellAttributes: { class: {fieldName: 'css'}},
             typeAttributes: {label: {fieldName: 'route'}, target:'_blank', tooltip: {fieldName: 'route'}}},
            {label: 'Container Type', fieldName: 'linkEquipo', type: 'url', cellAttributes: { class: {fieldName: 'css'}},
             typeAttributes: {label: {fieldName: 'containerType'}, target:'_blank', tooltip: {fieldName: 'containerType'}}},
            {label: 'Buy Rate', fieldName: 'buyAmount', type: 'currency', typeAttributes: { currencyCode: { fieldName: 'moneda' }}, cellAttributes: { class: {fieldName: 'css'}}},                        
            {label: 'Vigencia', fieldName: 'vigencia', type: 'string', cellAttributes: { class: {fieldName: 'css'}}}           
        ]);
    },
    cargaDatos: function(component, event, helper){
        component.find("Id_spinner").set("v.class" , 'slds-show');
        helper.cargaTablaHelper(component, event);
    }
})