public class ConsultaTarifarioClienteController {
    @AuraEnabled
    public static List<Fee__c> consultaRates(boolean activo, string ruta, string cliente, string equipo, string vigencia, string venta){
        DateTime fechaActual = system.now();
        string query = 'SELECT Id, CurrencyIsoCode, Name, Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Container_Type__c, Container_Type__r.Name, Active__c, Valid_Until__c, Fee_Rate__c, RecordType.Name, Fee_Category__c,TT_Days__c, Rate_Type__c, CreatedBy.Name, Carrier_Account__c, Carrier_Account__r.Name, Buy_Rate__c,Account_for__r.Customer_Id__c,SAP_Service_Type__c,SAP_Service_Type__r.Name';
        query += ' FROM Fee__c';
        query += ' WHERE CustomRate__c = true';
        query += ' AND Active__c = ' + activo;
        query += ' AND Valid_Until__c >= ' + fechaActual.format('yyyy-MM-dd');
        if(ruta != null && ruta != ''){query += ' AND Route__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(ruta) + '%\'');}
        if(cliente != null && cliente != ''){query += ' AND Account_for__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(cliente) + '%\'');}
        if(equipo != null && equipo != ''){query += ' AND Container_Type__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(equipo) + '%\'');}
        if(vigencia != null && vigencia != ''){query += ' AND Valid_Until__c = ' + string.escapeSingleQuotes(vigencia);}
        if(venta != null && venta != ''){query += ' AND Fee_Rate__c = ' + double.valueOf(venta);}
        query += ' LIMIT 50000';
        List<Fee__c> ratesList = Database.query(query);
        
        return ratesList;
    }
}