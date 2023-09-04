/**
 * Created by jamarin on 16/01/2019.
 */

public with sharing class NEU_GenerateMinuta {
    public Event record;
    public string doc { get; set; }
    ApexPages.StandardController con;

    public NEU_GenerateMinuta(ApexPages.StandardController stdController) {

        con = stdController;
        record = [SELECT Id, StartDateTime, Who.Name, Who.Title, EndDateTime,Temas_Pendientes__c, Location, Objetivo__c, Owner.Name, Subject, Comments_Pric__c, Proxima_Reunion__c, Motivo_Minuta__c from Event where id = :con.getRecord().Id];
        List <Event_Issues__c> eventIssues = [select Id, Name, Topic__c, Date__c, Id_Calendar_Event__c, Situation__c, User__r.name, User__c from Event_Issues__c where Id_Calendar_Event__c =: record.Id];

        Set<Id> participantIds = new Set<Id>();

        List<EventRelation> er = [
                SELECT RelationId, Status, Relation.Name
                FROM
                        EventRelation
                WHERE EventId = :con.getRecord().Id
        ];


        List<Lead> leads = [SELECT Id, Name, FirstName, LastName FROM Lead WHERE Id in :participantIds];


        doc = '';
        doc += '<div class="logo" style="float:right"><img src="/resource/logo_pak2go_notifications"/></div><br/>';
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
        doc += '		<td><strong>Objetivo: </strong>';
        if (record.Objetivo__c != null)
            doc += record.Objetivo__c;
        doc += ' </td>';
        doc += '	</tr>';

        doc += '</table>';
        doc += '</div>';

        /* tabla participantes */
        doc += '<div style="margin-top:20px;">';
        doc += '<table class="main_table">';
        doc += '	<tr>';
        doc += '		<th colspan="3" align="center" style="background-color:#a6a9ad;"><span style="color:white;">PARTICIPANTES</span></th>';
        doc += '	</tr>';
        doc += '	<tr>';
        doc += '	<tr>';
        doc += '		<td><strong>Nombre y Apellido </strong></td>';
        doc += '		<td><strong>Cargo</strong></td>';
        doc += '		<td><strong>Referencia</strong></td>';
        doc += '	</tr>';

        for (EventRelation e : [
                SELECT RelationId, Status, Relation.Name, Relation.title, Relation.alias
                FROM
                        EventRelation
                WHERE EventId = :con.getRecord().Id
        ]) {
            doc += '	<tr>';
            doc += '		<td>' + e.Relation.Name + '</td>';
            doc += '		<td> ';
            if (e.Relation.title != null)
                doc += e.Relation.title;
            doc += '		</td>';
            doc += '		<td>';
            if(e.Relation.alias != null &&  e.Status != null)
                doc +=  e.Relation.alias + ' - ' + e.Status;
            doc +=  ' </td>';
            doc += '	</tr>';
        }


        doc += '</table>';
        doc += '</div>';

        /* tabla sintesis temas tratados */
        doc += '<div style="margin-top:20px;">';
        doc += '<table class="main_table">';
        doc += '	<tr>';
        doc += '		<th colspan="4" align="center" style="background-color:#a6a9ad;"><span style="color:white;">SÍNTESIS DE TEMAS TRATADOS</span></th>';
        doc += '	</tr>';
        doc += '	<tr>';
        doc += '	<tr>';
        doc += '		<td><strong>Tema</strong></td>';
        doc += '		<td><strong>Situación / Pasos a seguir</strong></td>';
        doc += '		<td><strong>Responsable</strong></td>';
        doc += '		<td><strong>Fecha</strong></td>';

        doc += '	</tr>';

        for(Event_Issues__c ei:eventIssues)
        {
            doc += '	<tr>';
            doc += ei.Topic__c != null ? '<td>'+ei.Topic__c+'</td>' : '<td></td> ' ;
            doc += ei.Situation__c != null ? '		<td>'+ei.Situation__c+'		</td>' : '<td></td> ' ;
            doc += ei.User__r.name != null ? '		<td>'+ei.User__r.name+'		</td>' : '<td></td> ' ;
            doc += ei.Date__c != null ? '		<td>' +ei.Date__c.day() + '/' + ei.Date__c.month() + '/' + ei.Date__c.year() + '</td>' : '<td></td> ' ;
            doc += '	</tr>';
        }

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
        doc += '<table class="main_table" style="">';
        doc += '	<tr>';
        doc += '		<td style="background-color:#a6a9ad;width:50%;border:1px solid;"> <span style="color:white;">Próxima Reunión</span></td>';
        doc += '		<td style="width:50%;text-color:#a6a9ad;border:1px solid;">';

        if (record.Proxima_Reunion__c != null) {
            doc += record.Proxima_Reunion__c.day() + '/' + record.Proxima_Reunion__c.month() + '/' + record.Proxima_Reunion__c.year() + ', ';
            doc += record.StartDateTime.hour() + ':' + record.StartDateTime.minute() + ' - ' + record.EndDateTime.hour() + ':' + record.Proxima_Reunion__c.minute();
        }
        doc += '    </td>';
        doc += '	</tr>';
        doc += '</table>';
        doc += '</div>';

        /* Firma */
        doc += '<div style="margin-top:75px;margin-right:15px;float:right;font-family: Arial, Helvetica, sans-serif;">';
        doc += '<span style="text-align:right;">'+record.Who.Name+'</span><br/>';
        if (record.Who.Title  != null) {

            doc += '<span style="text-align:right;">' + record.Who.Title + '</span>';
        }
        doc += '</div>';


    }


}