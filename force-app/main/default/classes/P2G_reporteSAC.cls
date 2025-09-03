public class P2G_reporteSAC {
    public static void classifyShipments() {
        // Fecha actual
        Date today = Date.today();
        
        // Obtener el inicio y fin de la semana actual
        Date startOfWeek = today.toStartOfWeek();
        Date endOfWeek = startOfWeek.addDays(6);
        
        // Consultar los registros de Shipment__c de esta semana junto con la cuenta y el propietario
        List<Shipment__c> shipments = [
            SELECT Id, Name, ETD_from_Point_of_Load__c, ETD_Time_from_Point_of_Load__c, Shipment_Status_Plann__c, 
                   Account_for__c, Account_for__r.OwnerId
            FROM Shipment__c 
            WHERE ETD_from_Point_of_Load__c >= :startOfWeek AND ETD_from_Point_of_Load__c <= :endOfWeek
            AND ETD_from_Point_of_Load__c != null
            AND ETD_Time_from_Point_of_Load__c != null
            AND Shipment_Status_Plann__c = 'Pending'
        ];
        
        // Obtener el equipo de la cuenta y agrupar los envíos por usuario
        Map<Id, Set<Id>> accountTeamMap = new Map<Id, Set<Id>>();
        Map<Id, List<Shipment__c>> shipmentsByUser = new Map<Id, List<Shipment__c>>();

        List<AccountTeamMember> accountTeam = [
            SELECT UserId, AccountId
            FROM AccountTeamMember
        ];
        
        for (AccountTeamMember teamMember : accountTeam) {
            if (!accountTeamMap.containsKey(teamMember.AccountId)) {
                accountTeamMap.put(teamMember.AccountId, new Set<Id>());
            }
            accountTeamMap.get(teamMember.AccountId).add(teamMember.UserId);
        }

        for (Shipment__c shipment : shipments) {
            if (accountTeamMap.containsKey(shipment.Account_for__c)) {
                for (Id userId : accountTeamMap.get(shipment.Account_for__c)) {
                    if (!shipmentsByUser.containsKey(userId)) {
                        shipmentsByUser.put(userId, new List<Shipment__c>());
                    }
                    shipmentsByUser.get(userId).add(shipment);
                }
            }
        }
        
        // Procesar cada usuario
        for (Id userId : shipmentsByUser.keySet()) {
            List<Shipment__c> userShipments = shipmentsByUser.get(userId);
            
            // Listas de clasificación
            List<Shipment__c> greenList = new List<Shipment__c>();
            List<Shipment__c> yellowList = new List<Shipment__c>();
            List<Shipment__c> redList = new List<Shipment__c>();
            List<Shipment__c> blackList = new List<Shipment__c>();
            
            // Obtener la fecha y hora actuales en UTC
            DateTime nowUtc = DateTime.now();

            // Convertir el DateTime actual de UTC a hora local
            TimeZone localTimeZone = UserInfo.getTimeZone();
            DateTime nowLocal = nowUtc.addSeconds(localTimeZone.getOffset(nowUtc) / 1000);
            
            for (Shipment__c shipment : userShipments) {
                Date etdDate = shipment.ETD_from_Point_of_Load__c; 
                Time etdTime = shipment.ETD_Time_from_Point_of_Load__c; 
                
                // Crear el DateTime correctamente en UTC
                DateTime etdDateTimeUtc = DateTime.newInstanceGmt(etdDate, etdTime);
                
                // Convertir el DateTime de ETD de UTC a hora local
                DateTime etdDateTimeLocal = etdDateTimeUtc.addSeconds(localTimeZone.getOffset(etdDateTimeUtc) / 1000);
                
                // Obtener solo la fecha sin la parte de la hora
                Date nowDateOnly = nowLocal.date();
                if (nowDateOnly < etdDate) {
                    greenList.add(shipment); // Evento futuro
                } else if (nowDateOnly > etdDate) {     
                    blackList.add(shipment); // Evento pasado
                } else {
                    // Evento hoy, comparar las horas y minutos
                    Integer etdTotalMinutes = etdTime.hour() * 60 + etdTime.minute();
                    Integer nowTotalMinutes = nowUtc.hour() * 60 + nowUtc.minute();
                    Integer differenceInMinutes = etdTotalMinutes - nowTotalMinutes;

                    if (differenceInMinutes < 0) {
                        blackList.add(shipment);
                    } else if (differenceInMinutes <= 240) {
                        redList.add(shipment);
                    } else if (differenceInMinutes <= 360) {
                        yellowList.add(shipment);
                    } else {
                        greenList.add(shipment);
                    }
                }
            }
            
            // Crear contenido HTML para el correo electrónico
            String emailBody = buildEmailBody(greenList, yellowList, redList, blackList);
            
            // Enviar correo electrónico al usuario
            sendEmail(emailBody, userId);
        }
    }
    
    private static String buildEmailBody(List<Shipment__c> greenList, List<Shipment__c> yellowList, List<Shipment__c> redList, List<Shipment__c> blackList) {
        String emailBody = '<html><body>';
    emailBody += '<h1>Reporte de Clasificación de Envíos</h1>';
    emailBody += '<table border="1">';
    emailBody += '<tr><th>Nombre</th><th>Fecha</th><th>Hora</th><th>Estado</th><th>Color</th></tr>';
    
    for (Shipment__c shipment : greenList) {
        emailBody += '<tr style="background-color: #d4edda;"><td>' + shipment.Name + '</td><td>' + String.valueOf(shipment.ETD_from_Point_of_Load__c) + '</td><td>' + String.valueOf(shipment.ETD_Time_from_Point_of_Load__c) + '</td><td>' + shipment.Shipment_Status_Plann__c + '</td><td>Verde</td></tr>';
    }
    for (Shipment__c shipment : yellowList) {
        emailBody += '<tr style="background-color: #ffff00;"><td>' + shipment.Name + '</td><td>' + String.valueOf(shipment.ETD_from_Point_of_Load__c) + '</td><td>' + String.valueOf(shipment.ETD_Time_from_Point_of_Load__c) + '</td><td>' + shipment.Shipment_Status_Plann__c + '</td><td>Amarillo</td></tr>';
    }
    for (Shipment__c shipment : redList) {
        emailBody += '<tr style="background-color: #ff0000;"><td>' + shipment.Name + '</td><td>' + String.valueOf(shipment.ETD_from_Point_of_Load__c) + '</td><td>' + String.valueOf(shipment.ETD_Time_from_Point_of_Load__c) + '</td><td>' + shipment.Shipment_Status_Plann__c + '</td><td>Rojo</td></tr>';
    }
    for (Shipment__c shipment : blackList) {
        emailBody += '<tr style="background-color: #d6d8d9;"><td>' + shipment.Name + '</td><td>' + String.valueOf(shipment.ETD_from_Point_of_Load__c) + '</td><td>' + String.valueOf(shipment.ETD_Time_from_Point_of_Load__c) + '</td><td>' + shipment.Shipment_Status_Plann__c + '</td><td>Negro</td></tr>';
    }
    
    emailBody += '</table>';
    emailBody += '</body></html>';
    System.debug('emailBody: ' + emailBody);
    return emailBody;   
}

private static void sendEmail(String emailBody, Id userId) {
    // Obtener el email del usuario
    User user = [SELECT Email FROM User WHERE Id = :userId LIMIT 1];
    
    if (user != null) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String> { user.Email });
        mail.setSubject('Reporte de shipment por Semaforo');
        mail.setHtmlBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
}