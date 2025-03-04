/**
 * Created by jamarin on 16/01/2019.
 */

public with sharing class NEU_GenerateMinuta {
    public Event record;
    public string doc { get; set; }
    ApexPages.StandardController con;

    public NEU_GenerateMinuta(ApexPages.StandardController stdController) {

        con = stdController;
        record = [SELECT Id, StartDateTime, Who.Name, Who.Title, EndDateTime,Temas_Pendientes__c, Location, Objetivo__c, Owner.Name, Subject, Comments_Pric__c, Proxima_Reunion__c, Motivo_Minuta__c, TipoMeeting__c
				 from Event where id = :con.getRecord().Id];
        List <Event_Issues__c> eventIssues = [select Id, Name, Topic__c, Date__c, Id_Calendar_Event__c, Situation__c, User__r.name, User__c from Event_Issues__c where Id_Calendar_Event__c =: record.Id];
		List<StaticResource> logo_carta_porte = [SELECT Id, Name, Body, SystemModStamp, NamespacePrefix FROM StaticResource WHERE Name =: 'logo_carta_porte'];
        Set<Id> participantIds = new Set<Id>();

        List<EventRelation> er = [
                SELECT RelationId, Status, Relation.Name
                FROM
                        EventRelation
                WHERE EventId = :con.getRecord().Id
        ];


        List<Lead> leads = [SELECT Id, Name, FirstName, LastName FROM Lead WHERE Id in :participantIds];


        doc = '';
        doc += '<div class="logo" style="float:right"><img style="width:6cm; height:3cm;" src="/resource/'+logo_carta_porte[0].SystemModStamp.getTime()+'/'+(logo_carta_porte[0].NamespacePrefix != null && logo_carta_porte[0].NamespacePrefix != '' ? logo_carta_porte[0].NamespacePrefix+ '__' : '')+'logo_carta_porte"/></div><br/>';
        doc += '<h2 style="margin-top:50px;float:left;	font-family: Arial, Helvetica, sans-serif; margin-left:20px;color:#a6a9ad;">Minuta de Reunión</h2>';

        /* tabla información general*/
        doc += '<div style="margin-top:100px;">';
        doc += '<table class="main_table">';
        doc += '	<tr>';
        doc += '		<th colspan="2" align="center" style="background-color:#a6a9ad;"><span style="color:white;">INFORMACIÓN GENERAL</span></th>';
        doc += '	</tr>';
        doc += '	<tr>';
        doc += '	<tr>';
        doc += '		<td><strong>Fecha/Hora : </strong> ' + record.StartDateTime.day() + '/' + record.StartDateTime.month() + '/' + record.StartDateTime.year()+ ' ' + record.StartDateTime.hour() + ':' + record.StartDateTime.minute() +  ' - ' + record.EndDateTime.day() + '/' + record.EndDateTime.month() + '/' + record.EndDateTime.year() + ' '+ record.EndDateTime.hour() + ':' + record.EndDateTime.minute() + '</td>';
        doc += '		<td><strong>Motivo: </strong> ' + record.Motivo_Minuta__c + '</td>';
        doc += '	</tr>';

        doc += '	<tr>';
        doc += '		<td><strong>Lugar: </strong>';
        if (record.Location != null)
            doc += record.Location;
        doc += '</td>';
        doc += '		<td><strong>Moderador: </strong>' + record.Owner.Name + '</td>';
        doc += '	</tr>';

        doc += '	<tr>';
        doc += '		<td><strong>Título: </strong> ' + record.Subject + '</td>';
        doc += '		<td><strong>Tipo de Meeting: </strong>';
        if (record.TipoMeeting__c != null)
            doc += record.TipoMeeting__c;
        doc += ' </td>';
        doc += '	</tr>';

        doc += '</table>';
        doc += '</div>';
        /* tabla notas */
        doc += '<div style="margin-top:20px;">';
        doc += '<table class="main_table">';
        doc += '	<tr>';
        doc += '		<th colspan="4" align="center" style="background-color:#a6a9ad;"><span style="color:white;">NOTAS</span></th>';
        doc += '	</tr>';
        doc += '	<tr>';
        doc += '	<tr>';
        doc += '		<td>' + record.Comments_Pric__c + '</td>';
        doc += '	</tr>';
        doc += '</table>';
        doc += '</div>';
        /* tabla temas pendientes */
        doc += '<div style="margin-top:20px;">';
        doc += '<table class="main_table">';
        doc += '	<tr>';
        doc += '		<th colspan="4" align="center" style="background-color:#a6a9ad;"><span style="color:white;">TEMAS PENDIENTES</span></th>';
        doc += '	</tr>';
        doc += '	<tr>';
        doc += '	<tr>';
        doc += '		<td>' ;

        if(record.Temas_Pendientes__c != null)
            doc +=    record.Temas_Pendientes__c;

        doc += '       </td>';
        doc += '	</tr>';
        doc += '</table>';
        doc += '</div>';
        /* tabla proxima reunion */
        doc += '<div style="margin-top:20px;">';
        doc += '<table class="main_table">';
        doc += '	<tr>';
        doc += '		<th colspan="4" align="center" style="background-color:#a6a9ad;"><span style="color:white;">Próxima Reunión</span></th>';
        doc += '	</tr>';
        doc += '	<tr>';
        doc += '	<tr>';
        doc += '		<td>' ;

        if (record.Proxima_Reunion__c != null) {
            doc += record.Proxima_Reunion__c.day() + '/' + record.Proxima_Reunion__c.month() + '/' + record.Proxima_Reunion__c.year() + ', ';
            doc += record.Proxima_Reunion__c.hour() + ':' + record.Proxima_Reunion__c.minute();
        }
        doc += '       </td>';
        doc += '	</tr>';
        doc += '</table>';
        doc += '</div>';
        /* Firma */
        doc += '<div style="margin-top:75px;margin-right:15px;float:right;font-family: Arial, Helvetica, sans-serif;">';
        doc += '<p>Nombre de contacto:</p>';
        doc += '<span style="text-align:right;">'+record.Who.Name+'</span><br/>';
        if (record.Who.Title  != null) {
            doc += '<span style="text-align:right;">' + record.Who.Title + '</span>';
        }
        doc += '</div>';
    }
	@AuraEnabled
    public static Event getEvent(String eventId){
        Event event = [SELECT Id, StartDateTime, WhoId, Who.Name, Who.Title, EndDateTime,Temas_Pendientes__c, Location, 
                             WhatId, What.Name, Owner.Name, Subject, Comments_Pric__c, Proxima_Reunion__c, Motivo_Minuta__c,
                             TipoMeeting__c from Event where id = :eventId LIMIT 1];
        return event;
    }
	@AuraEnabled
    public static List<Contact> getContact(String nombre){
        String searchKeyword = '%' + nombre + '%';
        List<Contact> contact = [SELECT Id, Name, AccountId, Account.Name, Account.Record_Type_Name__c,
                                 Account.Customer_Id__c from Contact WHERE Name LIKE : searchKeyword limit 15];
        return contact;
    }
    @AuraEnabled
    public static String generaPDF(Event evento, String frecuencia, String inicio, String fin){
        String mensaje = '';
        System.debug('el evento que llega: '+evento+' '+frecuencia+' '+inicio+' '+fin);
        try{
            System.debug(!string.isBlank(frecuencia));
            if(!string.isBlank(frecuencia)){
                Event newEvent = nuevoEvento(evento, frecuencia, inicio, fin);
        		insert newEvent;
                Event meeting = updateEvent(evento,inicio,newEvent.Id);
                update meeting;
            }else{
                Event meeting = updateEvent(evento,'No Proximo','No');
                update meeting;
            }
            mensaje = 'Exito';
        }catch(Exception e){
            mensaje = 'Error al modificar la minuta: '+e.getMessage()+e.getLineNumber();
            System.debug(mensaje);     
        }
        return mensaje;
    }
    public static Event nuevoEvento(Event evento, String frecuencia, String inicio, String fin){
        DateTime fechaInicio = acomodoFechaHora(inicio);
        DateTime fechaFin = acomodoFechaHora(fin);
        Event newEvent = new Event();
            newEvent.Subject = evento.Subject;
            newEvent.Motivo_Minuta__c = evento.Motivo_Minuta__c;
            newEvent.TipoMeeting__c = evento.TipoMeeting__c;
            newEvent.OwnerId = evento.OwnerId;
            newEvent.WhatId = evento.WhatId;
            newEvent.WhoId = evento.WhoId;
            newEvent.Tipo_Visita__c = frecuencia;
            newEvent.StartDateTime = fechaInicio;
            newEvent.EndDateTime = fechaFin;
        return newEvent;
    }
    public static Event updateEvent(Event eventInfo, String proximo, String idEvent){
        Event meeting = new Event();
        meeting.WhoId = eventInfo.WhoId;
        meeting.Temas_Pendientes__c = eventInfo.Temas_Pendientes__c;
        meeting.Location = eventInfo.Location;
        meeting.Comments_Pric__c = eventInfo.Comments_Pric__c;
        meeting.Id = eventInfo.Id;
        if(proximo != 'No Proximo'){
            DateTime fecha = acomodoFechaHora(proximo);
            meeting.Proxima_Reunion__c = fecha;
            meeting.Id_Proxima_Reunion__c = idEvent;
        }
        return meeting;
    }
    public static DateTime acomodoFechaHora(String fecha){
        fecha = fecha.replace('.', ' ');
        fecha = fecha.replace('T', ' ');
        List<String> listFecha = fecha.split(' ');
        String stringFechaHora = listFecha[0]+' '+listFecha[1];
        
        DateTime fechaHora = DateTime.valueOf(stringFechaHora);
        return fechaHora;
    }
}