public class P2G_CargaEmbarques {
    public static String mapeoCargaEmbarque(String shipId){
        P2G_WS_EmbarquesWrapper.Parameters CargaEmbarques = new P2G_WS_EmbarquesWrapper.Parameters();
        String listaJson;
        String jsonModificado;
        try{
            Shipment__c ship = [SELECT Name, Vehicle__r.Num_Placa_Tracto__c,National_Operator__r.Id_Recurso_Confiable__c,
                                Operation_Executive__r.Name, National_Operator__r.Name, Account_Origin_Address__c, ETD_from_Point_of_Load__c, 
                                ETD_Time_from_Point_of_Load__c, ETA_Point_of_Discharge__c, ETA_Time_Point_of_Discharge__c,
                                Account_for__c,Account_for__r.Name, Account_Shipment_Reference__c, Account_Destination_Address__c,
                                Vehicle__c,Carrier__r.Customer_Id__c FROM Shipment__c WHERE id =: shipId];
            P2G_WS_EmbarquesWrapper.Requerido requerido = new P2G_WS_EmbarquesWrapper.Requerido();
            requerido.vehicle_NumPlacaTracto = ship.Vehicle__r.Num_Placa_Tracto__c;
            requerido.operationExecutive = ship.Operation_Executive__r.Name;
            requerido.operator1_Name = ship.National_Operator__r.Name;
            requerido.accountOriginAddress = ship.Account_Origin_Address__c;
            requerido.ETD = ship.ETD_from_Point_of_Load__c;
            requerido.ETDTime = ship.ETD_Time_from_Point_of_Load__c;
            requerido.accountForCustomer_Name = ship.Account_for__r.Name;
            requerido.customerReference = ship.Account_Shipment_Reference__c;
            requerido.accountDestinationAddress = ship.Account_Destination_Address__c;
            requerido.ETA = ship.ETA_Point_of_Discharge__c;
            requerido.ETATime = ship.ETA_Time_Point_of_Discharge__c;
            requerido.carrier_CustomerId = ship.Carrier__r.Customer_Id__c;
            requerido.shipment_Name = ship.Name;
            String nulos = checkFields(requerido);
            if(nulos == null){
                String stringETD = String.valueOf(ship.ETD_from_Point_of_Load__c);
                String[] parseEtd = stringETD.split(' ');
                String etd = parseEtd[0];
                String stringETA = String.valueOf(ship.ETA_Point_of_Discharge__c);
                String[] parseEta = stringETA.split(' ');
                String eta = parseEta[0];
                String stringETDTime = String.valueOf(ship.ETD_Time_from_Point_of_Load__c);
                String[] parseEtdTime = stringETDTime.split('.000Z');
                String etdTime = parseEtdTime[0];
                String stringETATime = String.valueOf(ship.ETA_Time_Point_of_Discharge__c);
                String[] parseEtaTime = stringETATime.split('.000Z');
                String etaTime = parseEtaTime[0];
                String fechaOrigen = etd +' '+ etdTime;
                String fechaDestino = eta +' '+ etaTime;
                CargaEmbarques.truck = new P2G_WS_EmbarquesWrapper.truck();
                CargaEmbarques.Driver = new P2G_WS_EmbarquesWrapper.Driver();
                CargaEmbarques.source = new P2G_WS_EmbarquesWrapper.source();
                CargaEmbarques.source.planning = new P2G_WS_EmbarquesWrapper.Planning();
                CargaEmbarques.source.planning.plan = new List<P2G_WS_EmbarquesWrapper.Plan>();
                P2G_WS_EmbarquesWrapper.Plan plan = new P2G_WS_EmbarquesWrapper.Plan();
                plan.code = new P2G_WS_EmbarquesWrapper.Code();
                CargaEmbarques.Product = new P2G_WS_EmbarquesWrapper.Product();
                CargaEmbarques.destinies = new P2G_WS_EmbarquesWrapper.Destinies();
                CargaEmbarques.destinies.destiny = new List<P2G_WS_EmbarquesWrapper.Destiny>();
                P2G_WS_EmbarquesWrapper.Destiny destino = new P2G_WS_EmbarquesWrapper.Destiny();
                destino.planning = new P2G_WS_EmbarquesWrapper.Planning();
                destino.planning.plan = new List<P2G_WS_EmbarquesWrapper.Plan>();
                CargaEmbarques.trailers = new P2G_WS_EmbarquesWrapper.trailers();
                CargaEmbarques.Transline = new P2G_WS_EmbarquesWrapper.Transline();
                CargaEmbarques.truck.plate = ship.Vehicle__r.Num_Placa_Tracto__c;//obligatorio
                CargaEmbarques.Driver.aux_2 = ship.National_Operator__r.Name;//agregado
                CargaEmbarques.Driver.name = ship.National_Operator__r.Name;//agregado
                CargaEmbarques.Source.aux_1 = ship.Operation_Executive__r.Name;//obligatorio
                CargaEmbarques.Source.aux_2 = ship.National_Operator__r.Name;//obligatorio(operador rcontrol)
                CargaEmbarques.Source.equiv = ship.Account_Origin_Address__c;//obligatorio
                plan.dateti = fechaOrigen;
                plan.name = 'ENTRANCE';//obligatorio
                plan.code.value = 'ENTRANCE';
                CargaEmbarques.source.planning.plan.add(plan);//obligatorio
                destino.aux_2 = ship.Account_for__r.Name; //obligatirio
                destino.aux_3 = ship.Account_Shipment_Reference__c; //obligatirio
                destino.equiv = ship.Account_Destination_Address__c;//obligatorio
                plan.dateti = fechaDestino;//obligatorio
                plan.name = 'ENTRANCE';//obligatorio
                plan.code.value = 'ENTRANCE';
                destino.planning.plan.add(plan);
                CargaEmbarques.destinies.destiny.add(destino);
                CargaEmbarques.Transline.equiv = ship.Carrier__r.Customer_Id__c;//obligatorio'RECO';//
                CargaEmbarques.shipment = ship.Name;//obligatorio
                CargaEmbarques.trailers.order = 1;
                listaJson ='['+Json.serialize(CargaEmbarques)+']';
                String jsonModi = listaJson.replace('dateti','datetime');
                jsonModificado = listaJson.replace('null','""');
                system.debug('-----Trabajo Listo :) -----: '+ jsonModificado);
            }else{
                jsonModificado = 'Campo Faltante: '+nulos;
            }
        }
        catch(Exception e){
            jsonModificado ='Error en llenar Campos P2G_CargaEmbarques: '+e.getLineNumber();
            System.debug('Error en llenar Campos P2G_CargaEmbarques: '+e.getLineNumber());
        }
        return jsonModificado;
    }
    public static String checkFields(P2G_WS_EmbarquesWrapper.Requerido record) {
        String jsonRecord = JSON.serialize(record);
        Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonRecord);    
        String nullOrEmptyFields;
        for (String fieldName : parsedJson.keySet()) {
            Object fieldValue = parsedJson.get(fieldName);
            if (fieldValue == null || (fieldValue instanceof String && String.isBlank((String)fieldValue))) {
                nullOrEmptyFields = fieldName;
            }
        }
        return nullOrEmptyFields;
    }
}