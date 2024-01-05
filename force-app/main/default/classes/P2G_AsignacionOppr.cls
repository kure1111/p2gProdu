public class P2G_AsignacionOppr {
    @AuraEnabled
    public static List<Shipment__c> seccion3(List<String> datos) {
        //status
        //fechaInicio
        //fechaFin
        //All/My
        //acc
        //carr
        //op
        List<Shipment__c> listaShipments = new List<Shipment__c>(); 
        String  idUser= UserInfo.getUserId();
        if(datos[1] == '' || datos[1]==null){
                    datos[1] = Datetime.now().format('yyyy-MM-dd');
        }
        if(datos[2] == ''|| datos[2]==null){
        			datos[2] = Datetime.now().format('yyyy-MM-dd');
        }
        try {
            String fechaInicioStr = datos[1] + 'T00:00:00Z';
            String fechaFinStr = datos[2] + 'T23:59:59Z';
            
            String soqlQuery = 'SELECT Id, Name, Shipment_Status_Plann__c, Operation_Executive__c, Operation_Executive__r.Name, ' +
                'Account_for__c, Account_for__r.Name, CreatedDate,Total_Services_Std_Buy_Amount__c,Route__c,Carrier__c,' +
                'Carrier__r.Name,ETD_from_Point_of_Load__c,ETA_Point_of_Discharge__c,Route__r.Name '+
                'FROM Shipment__c ' +
                'WHERE CreatedDate >= ' + fechaInicioStr +
                ' AND CreatedDate <= ' + fechaFinStr;
            if (datos[0] !='All') {
                soqlQuery += ' AND Shipment_Status_Plann__c = \'' + datos[0] + '\'';           
        	}
            if(datos[3] == 'mios'){
                soqlQuery += ' AND CreatedById = \''+ idUser +'\'';              
            }
            if(datos[4]!= null && datos[4]!=''){
                soqlQuery += ' AND Account_for__c = \''+ datos[4] +'\'';    
            }
            if(datos[5]!=null && datos[5]!=''){
                soqlQuery += ' AND Carrier__c = \''+ datos[5] +'\'';     
            }
            if(datos[6]!=null && datos[6]!=''){
                soqlQuery += ' AND Operation_Executive__c = \''+ datos[6] +'\'';      
            }
            
            
            System.debug('conuslta: '+soqlQuery);
            listaShipments = Database.query(soqlQuery);
        } catch (Exception e) {
            System.debug('Error en seccion3: ' + e.getMessage());
        }
        
        return listaShipments;
    }
    
    @AuraEnabled
    public static List<Shipment__c> getStatus2(List<String> datos) {
        List<Shipment__c> listaShipments = new List<Shipment__c>(); 
        String  idUser= UserInfo.getUserId();
        String idGenerico =idUser;
        if(!Test.isRunningTest()){
            idGenerico = System.Label.Operation_Executive;
        }
        
        try {
            String fechaInicioStr = datos[2] + 'T00:00:00Z';
            String fechaFinStr = datos[3] + 'T23:59:59Z';
            
            String soqlQuery = 'SELECT Id, Name, Shipment_Status_Plann__c, Operation_Executive__c, Operation_Executive__r.Name, ' +
                'Account_for__c, Account_for__r.Name, CreatedDate,Total_Services_Std_Buy_Amount__c,Route__c,ETD_from_Point_of_Load__c,'+
                'ETA_Point_of_Discharge__c, LastModifiedDate,Route__r.Name ' +
                'FROM Shipment__c ' +
                'WHERE Shipment_Status_Plann__c = \'' + datos[1] + '\'' +
                ' AND CreatedDate >= ' + fechaInicioStr +
                ' AND CreatedDate <= ' + fechaFinStr;
            if(datos[4] == 'mios'){
                soqlQuery += ' AND CreatedById = \''+ idUser +'\'';              
            }
            if(datos[0] == '2'){
                soqlQuery += ' AND (Operation_Executive__c = null OR Operation_Executive__c = \'' +idGenerico +'\')';         
            }
            if(datos[0] == '3'){
                soqlQuery += ' AND Operation_Executive__c != null';       
            }
            
			if(!String.isBlank(datos[5])){
                soqlQuery += ' AND Account_for__c = \''+ datos[5] +'\'';    
            }
            if(!String.isBlank(datos[6])){
                soqlQuery += ' AND Carrier__c = \''+ datos[6] +'\'';     
            }
            if(!String.isBlank(datos[7])){
                soqlQuery += ' AND Operation_Executive__c = \''+ datos[7] +'\'';      
            }
            System.debug('soqlQuery: '+soqlQuery);
            
            listaShipments = Database.query(soqlQuery);
        } catch (Exception e) {
            System.debug('Error consulta ' + e.getMessage());
        }
        
        return listaShipments;
    }
    
    @AuraEnabled
    public static  List<List<Shipment__c>> updateExecute(String shipmentId,list<String> datos) {
        List<Shipment__c> lista1 = new List<Shipment__c>();
        List<Shipment__c> lista2 = new List<Shipment__c>();
        NEU_StaticVariableHelper.setBoolean1(true);
        P2G_llamadoWebHelper.setWebServiceUpdate(true);
        Shipment__c shipmentToUpdate = new Shipment__c();
        shipmentToUpdate.Id = shipmentId;
        shipmentToUpdate.Operation_Executive__c = UserInfo.getUserId();
        if (!Test.isRunningTest()){
            update shipmentToUpdate;
        }
        NEU_StaticVariableHelper.setBoolean1(false);
        P2G_llamadoWebHelper.setWebServiceUpdate(false);
        lista1 = getStatus2(datos);
        datos[0] = '3';
        lista2 = getStatus2(datos);
        return new List<List<Shipment__c>>{lista1, lista2};
            }
    
    @AuraEnabled
    public static  List<List<Shipment__c>> columns(String shipmentId,list<String> datos) {
        //[0] -> columna
        //[1] -> status
        //[2] -> startDate
        //[3] -> endDate
        //[4] -> all/mios
        //[5] -> account
        //[6] -> carrier
        //[7] -> Operation executive
        list<Shipment__c> lista2 = new list<Shipment__c>();
        List<Shipment__c> lista3 = new List<Shipment__c>();
        List<Shipment__c> lista4 = new List<Shipment__c>();
        List<Shipment__c> lista5 = new List<Shipment__c>();
        List<Shipment__c> lista6 = new List<Shipment__c>();
        if(datos[2] == ''){
                    datos[2] = Datetime.now().format('yyyy-MM-dd');
        }
        if(datos[3] == ''){
        			datos[3] = Datetime.now().format('yyyy-MM-dd');
        }
        lista2 = getStatus2(datos);
        datos[0] = '3';
        lista3 = getStatus2(datos);
        datos[0] = '4';
        datos[1] = 'In Progress';
        lista4 = getStatus2(datos);
        datos[0] = '5';
        datos[1] = 'Confirmed';
        lista5 = getStatus2(datos);
        datos[1] = 'Closed';
        lista6 = getStatus2(datos);
        return new List<List<Shipment__c>>{lista2, lista3,lista4,lista5,lista6};
            }
    
    @AuraEnabled
    public static List<Account> searchAccounts(String search) {
        if (String.isNotBlank(search) && search.length() >= 3) {
            search = '%' + search + '%';
            return [SELECT Id, Name FROM Account WHERE Name LIKE :search LIMIT 10];
        } else {
            return new List<Account>();
        }
    }
    @AuraEnabled
    public static List<User> searchOpExecutive(String search) {
        if (String.isNotBlank(search) && search.length() >= 3) {
            search = '%' + search + '%';
            return [SELECT Id, Name FROM User WHERE Name LIKE :search LIMIT 10];
        } else {
            return new List<User>();
        }
    }
}