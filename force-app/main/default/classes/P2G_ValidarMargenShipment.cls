public class P2G_ValidarMargenShipment {
    @AuraEnabled
    public static Shipment__c getShipment(String shipId){
        Shipment__c ship = [SELECT Id, Name, Shipment_Type__c, SPMargen_Operativo__c, Shipment_Status_Plann__c,Total_Services_Std_Profit__c,
                            Total_Real_Profit_of_Services__c, Account_for__c, Account_for__r.Name, Operation_Executive__c,
                            Total_Services_Std_Buy_Amount__c, Total_Services_Sell_Amount_number__c, Profit__c, Total_Services_Std_Buy_Amount_number__c
                            FROM Shipment__c WHERE Id = :shipId];
        return ship;
    }
    public static String validarMargen(Shipment__c ship, String status) {
        String mensaje = MargenEs(ship);
        String body = bodyEmail(Ship);
        if(mensaje == 'Requiere Aprobacion'){
            Ship.Shipment_Status_Plann__c = status;
            Log_Aprobacion__c log  = creaLogAprobacion(Ship.Id, Ship.Total_Real_Profit_of_Services__c);
            List<String> emails = listaEmails();
            envioEmail(Ship.Name, body, emails);
        }else{
            Ship.Shipment_Status_Plann__c = Ship.Shipment_Status_Plann__c;
        }
        return mensaje;
    }
    public static String MargenEs(Shipment__c ship) {
       String mensaje;
       try {
           User roleName = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
           Rol_Margen__c rolMargen = [SELECT Id, Name, A_Margen_Operativo__c, AW_WCA_Margen_Operativo__c, FI_LTL_Margen_Operativo__c,
                                       FI_Margen_Operativo__c, FN_Margen_Operativo__c, M_FCL_Margen_Operativo__c, M_LCL_Margen_Operativo__c,
                                       PTO_Margen_Operativo__c, R_Margen_Operativo__c, W_WCA_Margen_Operativo__c
                                       FROM Rol_Margen__c WHERE Name =: roleName.UserRole.Name];
            switch on ship.Shipment_Type__c  {
                when 'A' {
                    mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.A_Margen_Operativo__c);
                }
                when 'AW' {
                    mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.AW_WCA_Margen_Operativo__c);
                }
                when 'FI' {
                    if(ship.Service_Type__c == 'LTL'){
                        mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.FI_LTL_Margen_Operativo__c);
                    }else{
                        mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.FI_Margen_Operativo__c);
                    }
                }
                when 'M' {
                    if(ship.Service_Type__c == 'FCL'){
                        mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.M_FCL_Margen_Operativo__c);
                    }else if(ship.Service_Type__c == 'LCL'){
                        mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.M_LCL_Margen_Operativo__c);
                    }
                }
                when 'PTO' {
                    mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.PTO_Margen_Operativo__c);
                }
                when 'R' {
                    mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.R_Margen_Operativo__c);
                }
                when 'WH' {
                    mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.W_WCA_Margen_Operativo__c);
                }
                when 'FN' {
                    mensaje = margenMenor(ship.SPMargen_Operativo__c, rolMargen.FN_Margen_Operativo__c);
                }
                when else {
                    System.debug('No existe esa ');
                }
            }
        } catch (Exception e) {
            // Agregar un mensaje de error en la pantalla
            System.debug('Occurrip un error' + e.getMessage());
        }
        return mensaje;
    }
    public static String margenMenor(Decimal mOperativo, Decimal margen){
        String mensaje;
        boolean margenMenos = mOperativo < margen;
        if(margenMenos == true){
            mensaje = 'Requiere Aprobacion';
        }else{
            mensaje = 'Todo bien';
        }
        return mensaje;
    }
    //@future
    public static void envioEmail(String spName, String body, List<String> emails){
        try{
        system.debug('la lista de emails es: '+emails);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(emails);
            email.setSubject('Solicitud de Confirmación en ' + spName); 
            email.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            system.debug('Se ha enviado un Email correctamente');
        } catch (Exception e) {
            System.debug('Error al enviar el correo: ' + e.getMessage());
        }
    }
    public static String bodyEmail(Shipment__c ship){
        Account acc = [SELECT Id, Name FROM Account WHERE Id =: ship.Account_for__c];
        // Crear el enlace dinámico al registro
        String baseUrl = System.URL.getOrgDomainUrl().toExternalForm();
        String shipmentLink = baseUrl + '/' + ship.Id;
        // Configurar el cuerpo del correo en HTML
        System.debug('el cliente es: '+acc.Name);
        String emailBody = '<!DOCTYPE html>'+
            			   '<html lang="en">' +
            			   '<style>'+
        				   '.slds-button-success {display: inline-block; text-align: center; text-decoration: none; font-family: Arial, sans-serif;'+
            			   'font-size: 14px; font-weight: bold; color: #ffffff; background-color: #28a745; padding: 10px 20px; border: none;'+
                		   'border-radius: 4px; cursor: pointer; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); transition: background-color 0.2s ease-in-out;}'+
                		   //'.slds-button-success:hover {background-color: #218838;}'+
                		   //'.slds-button-success:active {background-color: #1e7e34;}'+
                		   '</style>'+
                           '<body>' +
                           '<h2>****Solicitud de Confirmación en Shipment***</h2>' +
                           '<p>El SP <a href="' + shipmentLink + '">' + ship.Name + '</a> tiene los márgenes menores a los que puede confirmar el operador '+UserInfo.getName()+'.</p>' +
                           '<p>Favor de aprobar el SP correspondiente lo antes posible.</p>' +
                           '<p>Dar clic en el boton verde "Aprobar" de la parte de abajo</p>' +
                           '<p>En el Shipment buscar el boton "Aprobar" en la parte superior derecha</p>' +
                           '<p>En la ventana que se mostrara podra aprobar o rechazar de acuerdo a su criterio.</p>' +
                           '<br>'+
                           '<p style="margin-top: 10px; margin-bottom: 0;">'+ // Reduce el margen superior y elimina el margen inferior
                           '<a href="' + shipmentLink + '" class="slds-button-success">'+//style="display: inline-block; padding: 20px 40px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 10px; font-weight: bold; font-size: 24px; border: 1px solid #000000;">'+
                           'Aprobar'+
                           '</a>'+
                           '</p>'+
                           '<br>'+
            			   '<h3>Informacion del Shipment</h3>' +
                           '<p>Cliente: ' + acc.Name + '</p>' +
                           '<p>Solicitud generada por: ' +  UserInfo.getName() + '</p>' +
                           '<p>Total Services Buy Amount: $ ' + ship.Total_Services_Std_Buy_Amount_number__c.format() + '</p>' +
                           '<p>Total Services Sell Amount: $ ' + ship.Total_Services_Sell_Amount_number__c.format() + '</p>' +
                           '<p>Total Services Profit: $ ' + ship.Total_Services_Std_Profit__c.format() + '</p>' +
                           '<p>Profit %: ' + ship.Profit__c + '%</p>' +
            			   '<br>'+
                           '<br><p>Gracias.</p>' +
                           '</body>' +
                           '</html>';
        return emailBody;
    }
    public static List<String> listaEmails(){
        List<Lideres_Aprobacion_Shipment__mdt> emailsMeta = [SELECT Email_Lider__c FROM Lideres_Aprobacion_Shipment__mdt];
        List<String> emails = new List<String>();
        for(Lideres_Aprobacion_Shipment__mdt email : emailsMeta){
            emails.add(email.Email_Lider__c);
        }
        return emails;
    }
    public static Log_Aprobacion__c creaLogAprobacion(id shipment,Decimal sellRate){
        Log_Aprobacion__c aprobacion = new Log_Aprobacion__c();
        aprobacion.Status__c = 'Solicitud Enviada';
        aprobacion.SolicitadoPor__c = userinfo.getUserId();
        aprobacion.Shipment__c = shipment;
        aprobacion.sellRate__c = sellRate;
        aprobacion.motivoSolicitud__c = 'Solicitud de confirmación por Margen';
        insert aprobacion;
        return aprobacion;
    }
    @AuraEnabled
    public static List<P2G_Advertencia.csvLine> getShipmentFeeLines(String idShipment) {
        String motivo='';
        Map<Id, Fee__c> tarifarios = new Map<Id, Fee__c>();
        Map<Id, Shipment_Fee_Line__c> feeLinesMap = new Map<Id, Shipment_Fee_Line__c>();
        List<P2G_Advertencia.csvLine> csvLines = new List<P2G_Advertencia.csvLine>();
        List<Log_Aprobacion__c> aprobacion = [SELECT Id, Status__c,motivoSolicitud__c FROM Log_Aprobacion__c WHERE Shipment__c =:idShipment];
        // Consulta para obtener las líneas de tarifas de envío
        List<Shipment_Fee_Line__c> feeLines = [SELECT Id,Service_Rate_Name__r.Carrier_Account__r.Name,Service_Rate_Name__r.Name, Service_Rate_Name__r.Buy_Rate__c,Service_Rate_Name__r.Fee_Rate__c,Name,Service_Rate_Name__r.Account_for__c,
                                               Shipment__c, Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.SAP_Service_Type__c, Service_Rate_Name__r.Container_Type__r.Name, Service_Rate_Name__c,
                                               Shipment__r.Name, Shipment__r.Operation_Executive__r.Name,Shipment__r.ETD_from_Point_of_Load__c,Shipment__r.Total_Services_Std_Buy_Amount_number__c,
                                               Shipment__r.Total_Services_Sell_Amount_number__c, Shipment__r.Profit__c
                                               FROM Shipment_Fee_Line__c
                                               WHERE Shipment__c = :idShipment];
        if(aprobacion.size() > 0 ){
            if(aprobacion[0].motivoSolicitud__c != 'Solicitud de confirmación por Margen'){
            	motivo = aprobacion[0].motivoSolicitud__c;
            }
        }
        for (Shipment_Fee_Line__c feeLine : feeLines) {
            Fee__c fee = tarifarios.get(feeLine.Id);
            P2G_Advertencia.csvLine csv = new P2G_Advertencia.csvLine();
            csv.ServiceLineName = feeLine.Name;
            csv.Carrier = feeLine.Service_Rate_Name__r.Carrier_Account__r.Name;
            csv.RateName = feeLine.Service_Rate_Name__r.Name;
            csv.BuyAmount = '$ ' + feeLine.Service_Rate_Name__r.Buy_Rate__c.format();
            csv.sellRate = '$ ' + feeLine.Service_Rate_Name__r.Fee_Rate__c.format();
            csv.Route = feeLine.Service_Rate_Name__r.Route__r.Name;
            csv.ContainerType = feeLine.Service_Rate_Name__r.Container_Type__r.Name;
            
            csv.BuyRateMax = feeLine.Shipment__r.Profit__c + '%';
            csv.etd = String.valueOf(feeLine.Shipment__r.ETD_from_Point_of_Load__c);
            csv.operationExe = feeLine.Shipment__r.Operation_Executive__r.Name;
            csv.motivo = '$ ' + feeLine.Shipment__r.Total_Services_Std_Buy_Amount_number__c.format();
            csv.spName = '$ ' + feeLine.Shipment__r.Total_Services_Sell_Amount_number__c.format();
            csvLines.add(csv);
        }
        return csvLines;
    }
}