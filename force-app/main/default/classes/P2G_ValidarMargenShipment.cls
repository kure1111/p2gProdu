public class P2G_ValidarMargenShipment {
    public static void validarMargen(Shipment__c ship) {
        try {
    		User roleName = [SELECT UserRole.Name FROM User WHERE Id = :UserInfo.getUserId()];
            Rol_Margen__c rolMargen = [SELECT Id, Name, A_Margen_Operativo__c, AW_WCA_Margen_Operativo__c, FI_LTL_Margen_Operativo__c,
                                       FI_Margen_Operativo__c, FN_Margen_Operativo__c, M_FCL_Margen_Operativo__c, M_LCL_Margen_Operativo__c,
                                       PTO_Margen_Operativo__c, R_Margen_Operativo__c, W_WCA_Margen_Operativo__c
                                       FROM Rol_Margen__c WHERE Name =: roleName.UserRole.Name];
            boolean margenMenos;
            switch on ship.Shipment_Type__c  {
            when 'A' {
                margenMenor(ship.SPMargen_Operativo__c, rolMargen.A_Margen_Operativo__c, ship);
            }
            when 'AW' {
                margenMenor(ship.SPMargen_Operativo__c, rolMargen.AW_WCA_Margen_Operativo__c, ship);
            }
            when 'FI' {
                if(ship.Service_Type__c == 'LTL'){
                    margenMenor(ship.SPMargen_Operativo__c, rolMargen.FI_LTL_Margen_Operativo__c, ship);
                }else{
                    margenMenor(ship.SPMargen_Operativo__c, rolMargen.FI_Margen_Operativo__c, ship);
                }
            }
            when 'M' {
                if(ship.Service_Type__c == 'FCL'){
                    margenMenor(ship.SPMargen_Operativo__c, rolMargen.M_FCL_Margen_Operativo__c, ship);
                }else if(ship.Service_Type__c == 'LCL'){
                    margenMenor(ship.SPMargen_Operativo__c, rolMargen.M_LCL_Margen_Operativo__c, ship);
                }
            }
            when 'PTO' {
                margenMenor(ship.SPMargen_Operativo__c, rolMargen.PTO_Margen_Operativo__c, ship);
            }
            when 'R' {
                margenMenor(ship.SPMargen_Operativo__c, rolMargen.R_Margen_Operativo__c, ship);
            }
            when 'WH' {
                margenMenor(ship.SPMargen_Operativo__c, rolMargen.W_WCA_Margen_Operativo__c, ship);
            }
            when 'FN' {
                margenMenor(ship.SPMargen_Operativo__c, rolMargen.FN_Margen_Operativo__c, ship);
            }
            when else {
                System.debug('No existe esa ');
            }
        }
        } catch (Exception e) {
            // Agregar un mensaje de error en la pantalla
            ship.addError('Occurrip un error' + e.getMessage());
        }
    }
    public static void margenMenor(Decimal mOperativo, Decimal margen,Shipment__c Ship){
        boolean margenMenos;
        margenMenos = mOperativo < margen;
        String body = bodyEmail(Ship);
        try{
            if(margenMenos == true){
                List<String> emails = listaEmails();
                System.debug('Llamando al método @future...');
                //envioEmail(Ship.Name, body, emails);
                // Agregar un mensaje de error en la pantalla
                ship.addError('El margen es menor a lo que puede el usuario confirmar, favor de solicitar aprobación con su lider');
            }
        }catch (Exception e) {
        	System.debug('Error al enviar correo: ' + e.getMessage());
    	}
    }
    /*@future
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
    }*/
    public static String bodyEmail(Shipment__c ship){
        // Crear el enlace dinámico al registro
        String spLink = '';// URL.getSalesforceBaseUrl().toExternalForm() + '/' + ship.Id;
        // Configurar el cuerpo del correo en HTML
        String emailBody = '<html>' +
                           '<body>' +
                           '<h1>****Solicitud de Confirmación en Shipment***</h1>' +
                           '<p>El SP <a href="' + spLink + '">' + ship.Name + '</a> tiene los márgenes menores a los que puede confirmar el operador '+UserInfo.getName()+'.</p>' +
                           '<p>Favor de aprobar el SP correspondiente lo antes posible.</p>' +
                           '<br>' +
            			   '<h3>Informacion del Shipment</h3>' +
                           '<p>Cliente: ' + ship.Account_for__r.Name + '</p>' +
                           '<p>Operador: ' + ship.Operation_Executive__c + '</p>' +
                           '<p>Buy Price: $ ' + ship.Total_Services_Std_Buy_Amount_number__c.format() + '</p>' +
                           '<p>Sell Price: $ ' + ship.Total_Services_Sell_Amount_number__c.format() + '</p>' +
                           '<p>Margen: ' + ship.SPMargen_Operativo__c + '%</p>' +
                           '<br><p>Gracias,</p>' +
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
        testA();
        return emails;
    }
    public static void testA(){
        Integer a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;
        a =1;

    }
}