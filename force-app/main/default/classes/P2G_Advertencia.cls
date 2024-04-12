public class P2G_Advertencia {
    public static void handleBeforeUpdate(Shipment__c shipment, Map<Id, Shipment__c> oldMap) {
        List<Log_Aprobacion__c> logAprobacion = [SELECT Id, Name, Status__c FROM Log_Aprobacion__c WHERE Shipment__c =: shipment.Id];
        String statusOld = oldMap.get(shipment.Id).Shipment_Status_Plann__c;
        String status = shipment.Shipment_Status_Plann__c;
        String EmailAprobador = System.Label.aprobadorMargenRol;
        //String IdUsuario = userinfo.getUserId();
        String EmailUsuario = UserInfo.getUserEmail();
        if( (status == 'In Progress' && statusOld == 'Pending') || (status == 'Confirmed' && statusOld == 'In Progress')){
            if (logAprobacion.size() > 0){
                if(logAprobacion[0].Status__c == 'Aprobada' || EmailUsuario == EmailAprobador){
                    
                }
                else{
                    //agregar error chipment
                    shipment.addError('Necesita Aprobacion');
                }
            }
            else{
                Decimal necesitaAprobacion = proceso(shipment.Id);
                if(necesitaAprobacion != 0){
                    shipment.Shipment_Status_Plann__c=statusOld;
                    sendShipmentLink(shipment.Id,EmailAprobador);
                }
            }   
        }
        
    }
    
    public static Decimal proceso(String idShip){
        Map<Id, Fee__c> tarifarios = new Map<Id, Fee__c>();
        Map<Id, Shipment_Fee_Line__c> feeLinesMap = new Map<Id, Shipment_Fee_Line__c>();
        List<Shipment_Fee_Line__c> feeLines = [SELECT Id, Service_Rate_Name__r.Buy_Rate__c,Name,Service_Rate_Name__r.Account_for__c, Shipment__c, Service_Rate_Name__r.Route__c,
                                               Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Container_Type__c 
                                               FROM Shipment_Fee_Line__c 
                                               WHERE Shipment__c = :idShip];
        
        for (Shipment_Fee_Line__c fee : feeLines) {
            Fee__c serviceRate = P2G_CreacionFolios.condicionesTarifario(fee.Service_Rate_Name__r.Account_for__c, fee.Service_Rate_Name__r.SAP_Service_Type__c,
                                                                         fee.Service_Rate_Name__r.Container_Type__c, fee.Service_Rate_Name__r.Route__c);
            if (serviceRate != null) {
                tarifarios.put(fee.Id, serviceRate);
                feeLinesMap.put(fee.Id, fee);
            }
        }
        
        Decimal maximoGeneral = 0;
        Decimal precioMax = 0;
        Decimal precioLinea = 0;
        for (Id feeId : tarifarios.keySet()) {
            Fee__c fee = tarifarios.get(feeId);
            Shipment_Fee_Line__c serviceLine = feeLinesMap.get(feeId);
            System.debug('Tarifario: '+ fee);
            System.debug('Linea: '+ serviceLine);
            Decimal max = fee.BuyPriceMax__c;
            //Decimal margen = 0;
            if (max == null) {
                return 0;
            }
            Decimal buySell = serviceLine.Service_Rate_Name__r.Buy_Rate__c;
            if(max - buySell < 0 && max - buySell < maximoGeneral){
                maximoGeneral = max - buySell;
                precioMax = max;
                precioLinea = buySell;
            }
            /*if(margen(buySell, max) > maximoGeneral){
maximoGeneral = margen(buySell, max);
}*/
        }
        //maximoGeneral si es negativo necesita aprobacion
        if(maximoGeneral < 0){
            //String userRolId = UserInfo.getUserRoleId();
            /*
Map<Id, Rol_Margen__c> mapRolMargen = new Map<Id, Rol_Margen__c>();

// Llenar el mapa con los roles de margen
for(Rol_Margen__c rolMargen : [SELECT Id, Name, Margen_Aprobacion__c 
FROM Rol_Margen__c 
WHERE Margen_Aprobacion__c >=: maximoGeneral 
ORDER BY Margen_Aprobacion__c ASC]) {
mapRolMargen.put(rolMargen.Id, rolMargen);
}

if(mapRolMargen.containsKey(userRolId)) {
// El usuario tiene un margen de aprobación suficiente
//Rol_Margen__c userRolMargen = mapRolMargen.get(userRolId);
// Ahora puedes acceder a los campos de Rol_Margen__c para el usuario actual
} 
else {
// Obtener correos de usuarios cuyos UserRoleId está en la lista de roles de margen
List<User> usersWithSufficientMargin = [SELECT Id, Email 
FROM User 
WHERE UserRoleId IN :mapRolMargen.keySet()];

// Crear un mapa para almacenar los correos de usuarios, indexados por el ID del rol
Map<Id, String> userEmailsByRoleId = new Map<Id, String>();
for (User user : usersWithSufficientMargin) {
userEmailsByRoleId.put(user.UserRoleId, user.Email);
}

// Crear una lista de correos de usuarios, ordenada de acuerdo con el orden de los roles de margen
List<String> orderedEmails = new List<String>();
for (Id roleId : mapRolMargen.keySet()) {
if (userEmailsByRoleId.containsKey(roleId)) {
orderedEmails.add(userEmailsByRoleId.get(roleId));
}
}
//crea objecto
creaLogAprobacion(idShip);
//Envia correo
//sendShipmentLink(shipment.Id,orderedEmails[0]);

}*/
            creaLogAprobacion(idShip,precioMax,precioLinea);
        }
        return maximoGeneral;
        
    }
    
    public static void creaLogAprobacion(id shipment, Decimal precio1, Decimal precio2){
        Log_Aprobacion__c aprobacion = new Log_Aprobacion__c();
        aprobacion.Status__c = 'Solicitud Enviada';
        aprobacion.SolicitadoPor__c = userinfo.getUserId();
        aprobacion.Shipment__c = shipment;
        aprobacion.montoMaximo__c = precio1;
        aprobacion.montoPorAprobar__c = precio2;
        insert aprobacion;
        
    }
    
    public static void sendShipmentLink(String idShipment, String emailAddress) {
        //String shipmentLink = URL.getOrgDomainUrl().toExternalForm() + '/lightning/n/AprobacionMargenes?c__recordId=' + idShipment;
        String shipmentLink = URL.getOrgDomainUrl().toExternalForm() + '/lightning/action/quick/Shipment__c.Aprobar?objectApiName&context=RECORD_DETAIL&recordId=' + idShipment;
        // Crear el contenido del correo electrónico
        String emailSubject = 'Enlace al objeto de envío';
        String emailBody = 'Shipment en Espera de Aprobacion: ' + shipmentLink;
        
        // Crear el correo electrónico
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{ emailAddress , 'alberto.garcia@pak2go.com', 'carlos.martinez@2gologistics.com'});
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);
        
        // Enviar el correo electrónico
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ email });
        
        // Verificar los resultados del envío del correo electrónico
        if (sendResults[0].isSuccess()) {
            System.debug('Correo electrónico enviado con éxito a ' + emailAddress);
        } else {
            System.debug('Error al enviar el correo electrónico: ' + sendResults[0].getErrors()[0].getMessage());
        }
    }
    
    public class csvLine {
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String ServiceLineName { get; set; }
        @AuraEnabled public String Carrier { get; set; }
        @AuraEnabled public String RateName { get; set; }
        @AuraEnabled public String BuyAmount { get; set; }
        @AuraEnabled public String Route { get; set; }
        @AuraEnabled public String sellRate { get; set; }
        @AuraEnabled public String ContainerType { get; set; }
        @AuraEnabled public String motivo { get; set; }
        @AuraEnabled public String BuyRateMax { get; set; }
        @AuraEnabled public String spName { get; set; }
        @AuraEnabled public String operationExe { get; set; }
        @AuraEnabled public String etd { get; set; }
    }
    
    @AuraEnabled
    public static List<csvLine> getShipmentFeeLines(String idShipment) {
        String motivo='';
        Map<Id, Fee__c> tarifarios = new Map<Id, Fee__c>();
        Map<Id, Shipment_Fee_Line__c> feeLinesMap = new Map<Id, Shipment_Fee_Line__c>();
        List<csvLine> csvLines = new List<csvLine>();
        List<Log_Aprobacion__c> aprobacion = [SELECT Id, Status__c,motivoSolicitud__c FROM Log_Aprobacion__c WHERE Shipment__c =:idShipment];
        // Consulta para obtener las líneas de tarifas de envío
        
        List<Shipment_Fee_Line__c> feeLines = [SELECT Id,Service_Rate_Name__r.Carrier_Account__r.Name,Service_Rate_Name__r.Name, Service_Rate_Name__r.Buy_Rate__c,Service_Rate_Name__r.Fee_Rate__c,Name,Service_Rate_Name__r.Account_for__c,
                                               Shipment__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Container_Type__r.Name,
                                               Shipment__r.Name, Shipment__r.Operation_Executive__r.Name,Shipment__r.ETD_from_Point_of_Load__c
                                               FROM Shipment_Fee_Line__c
                                               WHERE Shipment__c = :idShipment];
        for (Shipment_Fee_Line__c fee : feeLines) {
            Fee__c serviceRate = P2G_CreacionFolios.condicionesTarifario(fee.Service_Rate_Name__r.Account_for__c, fee.Service_Rate_Name__r.SAP_Service_Type__c, fee.Service_Rate_Name__r.Container_Type__c, fee.Service_Rate_Name__r.Route__c);
            if (serviceRate != null) {
                tarifarios.put(fee.Id, serviceRate);
                feeLinesMap.put(fee.Id, fee);
            }
        }
        if(aprobacion.size() > 0 ){
            motivo = aprobacion[0].motivoSolicitud__c;
        }
        
        for (Shipment_Fee_Line__c feeLine : feeLines) {
            Fee__c fee = tarifarios.get(feeLine.Id);
            csvLine csv = new csvLine();
            csv.ServiceLineName = feeLine.Name;
            csv.Carrier = feeLine.Service_Rate_Name__r.Carrier_Account__r.Name;
            csv.RateName = feeLine.Service_Rate_Name__r.Name;
            csv.BuyAmount = feeLine.Service_Rate_Name__r.Buy_Rate__c+'';
            csv.Route = feeLine.Service_Rate_Name__r.Route__r.Name;
            csv.ContainerType = feeLine.Service_Rate_Name__r.Container_Type__r.Name;
            csv.motivo = motivo;
            if(fee != null){
                csv.BuyRateMax = fee.BuyPriceMax__c+'';
            }
            
            csv.etd = String.valueOf(feeLine.Shipment__r.ETD_from_Point_of_Load__c);
            csv.spName = feeLine.Shipment__r.Name;
            csv.operationExe = feeLine.Shipment__r.Operation_Executive__r.Name;
            csv.sellRate = feeLine.Service_Rate_Name__r.Fee_Rate__c +'';
            csvLines.add(csv);
        }
        
        return csvLines;
    }
    
    @AuraEnabled
    public static void updateLogAprobacion(String recordId, String motivo){
        List<Log_Aprobacion__c> aprobacion = [SELECT Id FROM Log_Aprobacion__c WHERE Shipment__c =:recordId];
        if(aprobacion.size() > 0){
            aprobacion[0].motivoSolicitud__c = motivo;
            update aprobacion[0];
        }
    }
    
    @AuraEnabled
    public static void approveShipment(String shipmentId, String status){
        List<Log_Aprobacion__c> aprobacion = [SELECT Id, Status__c,Shipment__c, SolicitadoPor__c, Shipment__r.Name FROM Log_Aprobacion__c WHERE Shipment__c =:shipmentId];
        if(aprobacion.size() > 0){
            aprobacion[0].Status__c = status;
            aprobacion[0].aprobado_por__c = userinfo.getUserId();
            update aprobacion;
            emailSendPlanner(aprobacion[0]);
            //Shipment__c aprobado =  new Shipment__c();
            //aprobado.Id = shipmentId;
            //aprobado.Shipment_Status_Plann__c = 'Confirmed';
            //update aprobado;
        }
    }
    
    public static void emailSendPlanner(Log_Aprobacion__c log){
        String emailUser = [SELECT email FROM user WHERE id =: log.SolicitadoPor__c].Email;
        String shipmentLink = URL.getOrgDomainUrl().toExternalForm() + '/' + log.Shipment__c;
        
        // Crear el contenido del correo electrónico
        String emailSubject = 'Shipment ' + log.Shipment__r.Name +' '+ log.Status__c;
        String emailBody = 'Shipment ' + shipmentLink;
        
        // Crear el correo electrónico
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{ emailUser });
        email.setSubject(emailSubject);
        email.setPlainTextBody(emailBody);
        
        // Enviar el correo electrónico
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ email });
    }
    
    @AuraEnabled
    public static Log_Aprobacion__c mostrarAdvertencia(String shipmentId){
        Log_Aprobacion__c log = new Log_Aprobacion__c();
        List<Log_Aprobacion__c> aprobacion = [SELECT Id,Status__c,montoMaximo__c,montoPorAprobar__c,Shipment__c, motivoSolicitud__c,SolicitadoPor__c, Shipment__r.Name 
                                              FROM Log_Aprobacion__c 
                                              WHERE Shipment__c =:shipmentId];
        if(aprobacion.size() > 0 ){
            if((aprobacion[0].motivoSolicitud__c=='' || aprobacion[0].motivoSolicitud__c == null) && aprobacion[0].Status__c =='Solicitud Enviada'){
                log = aprobacion[0];
            }
        }
        
        return log;
    }
    
    public static void updateRate( List<Shipment_Fee_Line__c> lineas){
        Set<Id> shipmentServiceLineIds = new Set<Id>();
        Map<Id, Shipment_Fee_Line__c> shipmentServiceLineToBuyPrice = new Map<Id, Shipment_Fee_Line__c>();
        
        for (Shipment_Fee_Line__c linea : lineas) {
            shipmentServiceLineIds.add(linea.Service_Rate_Name__c);
            shipmentServiceLineToBuyPrice.put(linea.Service_Rate_Name__c, linea);
        }
    
        // Realizar una consulta a Fee__c usando los IDs de Shipment_Service_Line__c en la lista
        List<Fee__c> fees = [SELECT Id, Name, Buy_Rate__c FROM Fee__c WHERE Id IN :shipmentServiceLineIds];   	
        for(Fee__c rate: fees){
            Shipment_Fee_Line__c linea = shipmentServiceLineToBuyPrice.get(rate.Id);
            rate.Buy_Rate__c = linea.Shipment_Buy_Price__c;
        }
        update fees;
     }
    
}