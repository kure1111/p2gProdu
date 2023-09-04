public class ConsultaTarifarioProveedorController {
    @AuraEnabled
    public static List<Fee__c> consultaRates(boolean activo, string ruta, string carrier, string equipo, string vigencia, string compra){
        DateTime fechaActual = system.now();
        string query = 'SELECT Id, CurrencyIsoCode, Name, Route__c, Route__r.Name, Container_Type__c, Container_Type__r.Name, Active__c, Valid_Until__c, RecordType.Name, Fee_Category__c,TT_Days__c, Rate_Type__c, CreatedBy.Name, Carrier_Account__c, Carrier_Account__r.Name, Buy_Rate__c,Carrier_Account__r.Customer_Id__c,SAP_Service_Type__c,SAP_Service_Type__r.name';
        query += ' FROM Fee__c';
        query += ' WHERE Tarifario_Compras__c = true';
        query += ' AND Valid_Until__c >= ' + fechaActual.format('yyyy-MM-dd');
        query += ' AND Active__c = ' + activo + ' AND Carrier_Account__c != null';
        if(ruta != null && ruta != ''){query += ' AND Route__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(ruta) + '%\'');}
        if(carrier != null && carrier != ''){query += ' AND Carrier_Account__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(carrier) + '%\'');}
        if(equipo != null && equipo != ''){query += ' AND Container_Type__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(equipo) + '%\'');}
        if(vigencia != null && vigencia != ''){query += ' AND Valid_Until__c = ' + string.escapeSingleQuotes(vigencia);}
        if(compra != null && compra != ''){query += ' AND Buy_Rate__c = ' + double.valueOf(compra);}
        query += ' LIMIT 50000';
        List<Fee__c> ratesList = Database.query(query);
        
        return ratesList;
    }
}