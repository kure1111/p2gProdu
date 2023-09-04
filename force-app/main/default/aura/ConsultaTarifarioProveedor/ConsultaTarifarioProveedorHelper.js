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
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                    if(record.Route__c != null){record.nombreRuta = record.Route__r.Name;}else{record.nombreRuta = '';}
                    if(record.Route__c != null){record.linkRuta = '/'+record.Route__c;}else{record.linkRuta = '/#';}
                    if(record.Carrier_Account__c == null){record.nombreCarrier = '';}else{record.nombreCarrier = record.Carrier_Account__r.Name;}
                    if(record.Carrier_Account__c == null){record.linkCarrier = '';}else{record.linkCarrier = '/'+record.Carrier_Account__c;}
                    if(record.Container_Type__c != null){record.nombreEquipo = record.Container_Type__r.Name;}else{record.nombreEquipo = '';}
                    if(record.Container_Type__c != null){record.linkEquipo = '/'+record.Container_Type__c;}else{record.linkEquipo = '/#';}
                    if(record.Carrier_Account__c == null){record.carrierID = '';}else{record.carrierID = record.Carrier_Account__r.Customer_Id__c;}
                    if(record.SAP_Service_Type__c == null){record.sapst = '';}else{record.sapst = record.SAP_Service_Type__r.Name;}
                    record.tipoRegistro = record.RecordType.Name;
                    record.creadoPor = record.CreatedBy.Name;
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
                'Rate_Type__c','nombreEquipo','Buy_Rate__c','nombreRuta','nombreCarrier',
                'Valid_Until__c','creadoPor'];
        
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