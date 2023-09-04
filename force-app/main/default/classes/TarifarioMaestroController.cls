public class TarifarioMaestroController {
    public class Tarifario{
        public boolean activo {get;set;}
        public string rateName {get;set;}
        public string recordType {get;set;}
        public string rateCategory {get;set;}
        public string rateType {get;set;}
        public string containerType {get;set;}
        public string route {get;set;}
        public string carrier {get;set;}
        public double buyAmount {get;set;}
        public date vigencia {get;set;}
        public string moneda {get;set;}
        public string linkName {get;set;}
        public string linkEquipo {get;set;}
        public string linkRuta {get;set;}
        public string linkCarrier {get;set;}
    }
    
    @AuraEnabled
    public static string consultaRates(boolean activo, string ruta, string carrier, string equipo, string vigencia, string compra){
        List<Tarifario> lstTarifario = new List<Tarifario>();
        string currentRoute = '';
        string currentContainer = '';
        string currentRouteName = '';
        string currentContainerName = '';
        double currentCosto = 0;
        integer count = 0;
        
        string query = 'SELECT Id, CurrencyIsoCode, Name, Route__c, Route__r.Name, Container_Type__c, Container_Type__r.Name, Active__c, Valid_Until__c, RecordType.Name, Fee_Category__c,TT_Days__c, Rate_Type__c, CreatedBy.Name, Carrier_Account__c, Carrier_Account__r.Name, Buy_Rate__c';
        query += ' FROM Fee__c';
        query += ' WHERE Tarifario_Compras__c = true';
        query += ' AND Active__c = ' + activo + ' AND Carrier_Account__c != null';
        if(ruta != null && ruta != ''){query += ' AND Route__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(ruta) + '%\'');}
        if(carrier != null && carrier != ''){query += ' AND Carrier_Account__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(carrier) + '%\'');}
        if(equipo != null && equipo != ''){query += ' AND Container_Type__r.Name LIKE ' + ('\'%' + String.escapeSingleQuotes(equipo) + '%\'');}
        if(vigencia != null && vigencia != ''){query += ' AND Valid_Until__c = ' + string.escapeSingleQuotes(vigencia);}
        if(compra != null && compra != ''){query += ' AND Buy_Rate__c = ' + double.valueOf(compra);}
        query += ' ORDER BY Route__c, Container_Type__c';
        query += ' LIMIT 50000';
        
        List<Fee__c> ratesList = Database.query(query);
        
        if(ratesList.isEmpty()){return JSON.serialize(lstTarifario);}
        
        currentRoute = ratesList[0].Route__c;
        currentContainer = ratesList[0].Container_Type__c;
        currentRouteName = ratesList[0].Route__r.Name;
        currentContainerName = ratesList[0].Container_Type__r.Name;
        
        for(Fee__c rate : ratesList){
            if(currentRoute == rate.Route__c && currentContainer == rate.Container_Type__c){
                count ++;
                currentCosto += rate.Buy_Rate__c;
            }
            else{
                Tarifario tarifa = new Tarifario();
                tarifa.containerType = currentContainerName;
                tarifa.route = currentRouteName;
                tarifa.buyAmount = currentCosto > 0 ? (currentCosto/count) : 0;
                tarifa.moneda = 'MXN';
                tarifa.linkEquipo = '/' + currentContainer;
        		tarifa.linkRuta = '/' + currentRoute;
                
                lstTarifario.add(tarifa);
                
                count = 1;
                currentCosto = rate.Buy_Rate__c;
                currentRoute = rate.Route__c;
                currentContainer = rate.Container_Type__c;
                currentRouteName = rate.Route__r.Name;
                currentContainerName = rate.Container_Type__r.Name;
            }
            Tarifario tarifa = new Tarifario();
            tarifa.activo = rate.Active__c;
            tarifa.rateName = rate.Name;
            tarifa.recordType = rate.RecordType.Name;
            tarifa.rateCategory = rate.Fee_Category__c;
            tarifa.rateType = rate.Rate_Type__c;
            tarifa.containerType = rate.Container_Type__r.Name;
            tarifa.route = rate.Route__r.Name;
            tarifa.carrier = rate.Carrier_Account__r.Name;
            tarifa.buyAmount = rate.Buy_Rate__c;
            tarifa.vigencia = rate.Valid_Until__c;
            tarifa.moneda = rate.CurrencyIsoCode;
            tarifa.linkName = '/' + rate.Id;
            tarifa.linkEquipo = '/' + rate.Container_Type__c;
            tarifa.linkCarrier = '/' + rate.Carrier_Account__c;
            tarifa.linkRuta = '/' + rate.Route__c;
            
            lstTarifario.add(tarifa);
        }
        
        Tarifario tarifa = new Tarifario();
        tarifa.containerType = currentContainerName;
        tarifa.route = currentRouteName;
        tarifa.buyAmount = currentCosto > 0 ? (currentCosto/count) : 0;
        tarifa.moneda = 'MXN';
        tarifa.linkEquipo = '/' + currentContainer;
        tarifa.linkRuta = '/' + currentRoute;
        
        lstTarifario.add(tarifa);
        
        
        return JSON.serialize(lstTarifario);
    }
}