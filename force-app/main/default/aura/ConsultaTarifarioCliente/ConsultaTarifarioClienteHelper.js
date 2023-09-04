({
    cargaTablaHelper : function(component, event) {
        var activo = component.get("v.factivo");
        var ruta = component.get("v.fruta");
        var cliente = component.get("v.fcliente");
        var equipo = component.get("v.fequipo");
        var vigencia = component.get("v.fvigencia");
        var venta = component.get("v.fventa");
        
        console.log("Activo: " + activo);
        console.log("Ruta: " + ruta);
        console.log("Cliente: " + cliente);
        console.log("Equipo: " + equipo);
        console.log("Vigencia: " + vigencia);
        console.log("Venta: " + venta);
        
        var action = component.get("c.consultaRates");
        action.setParams({
            "activo" : activo,
            "ruta" : ruta,
            "cliente" : cliente,
            "equipo" : equipo,
            "vigencia" : vigencia,
            "venta" : venta
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                console.log("Records: " + records.length);
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    if(record.Route__c != null){record.nombreRuta = record.Route__r.Name;}else{record.nombreRuta = '';}
                    if(record.Route__c != null){record.linkRuta = '/'+record.Route__c;}else{record.linkRuta = '/#';}
                    if(record.Account_for__c != null){record.nombreCliente = record.Account_for__r.Name;}else{record.nombreCliente = '';}
                    if(record.Account_for__c != null){record.linkCliente = '/'+record.Account_for__c;}else{record.linkCliente = '/#';}
                    if(record.Container_Type__c != null){record.nombreEquipo = record.Container_Type__r.Name;}else{record.nombreEquipo = '';}
                    if(record.Container_Type__c != null){record.linkEquipo = '/'+record.Container_Type__c;}else{record.linkEquipo = '/#';}
                    if(record.Account_for__c != null){record.customerID = record.Account_for__r.Customer_Id__c;}else{record.customerID = '';}
                    if(record.SAP_Service_Type__c != null){record.sapstid = record.SAP_Service_Type__r.Name;}else{record.sapstid = '';}
                    record.tipoRegistro = record.RecordType.Name;
                    record.creadoPor = record.CreatedBy.Name;
                    if(record.Carrier_Account__c != null){record.carrier = record.Carrier_Account__r.Name;}else{record.carrier = '';} 
                    record.compra = record.Buy_Rate__c;
                });
                component.set("v.ratesList", response.getReturnValue());
                if(component.get("v.ratesList").length > 0){
                    component.set("v.exportdisabled", false);
                }else{
                    component.set("v.exportdisabled", true);
                }
                component.find("Id_spinner").set("v.class" , 'slds-hide');
            }
        });
        $A.enqueueAction(action);
    },
    convertirCSV : function(component,objectRecords){
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        if (objectRecords == null || !objectRecords.length) {return null;}
        
        columnDivider = ',';
        lineDivider =  '\n';
  
        keys = ['Active__c','Name','tipoRegistro','Fee_Category__c','TT_Days__c',
                'Rate_Type__c','nombreEquipo','Fee_Rate__c','nombreRuta','nombreCliente',
                'Valid_Until__c','creadoPor', 'Id', 'carrier', 'compra'];
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
               
               csvStringResult += '"'+ objectRecords[i][skey]+'"'; 
               
               counter++;
 
            }
             csvStringResult += lineDivider;
          }
        
        return csvStringResult;        
    }
})