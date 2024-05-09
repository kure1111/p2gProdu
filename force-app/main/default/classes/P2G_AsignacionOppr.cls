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
            String fechaInicioStr = datos[1];// + 'T00:00:00Z';
            String fechaFinStr = datos[2];// + 'T23:59:59Z';
            
            String soqlQuery = 'SELECT Id,Equip_Placed__c,Monitoreo_Recepci_n_Acuse__c,Name, Shipment_Status_Plann__c,ETD_Time_from_Point_of_Load__c, Operation_Executive__c, Operation_Executive__r.Name, ' +
                'Account_for__c, Account_for__r.Name, CreatedDate,Total_Services_Sell_Amount__c,Route__c,Total_Services_Std_Buy_Amount__c,Carrier__c,' +
                'Carrier__r.Name,ETD_from_Point_of_Load__c,ETA_Point_of_Discharge__c,Route__r.Name '+
                'FROM Shipment__c ' +
                'WHERE ETD_from_Point_of_Load__c = ' + fechaInicioStr; 
                //' AND ETD_from_Point_of_Load__c <= ' + fechaFinStr;
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
            if(datos[7]!=null && datos[7]!='All'){
                soqlQuery += ' AND Shipment_Type__c = \''+ datos[7] +'\'';
            }

            if(datos[8] != 'All'){
                soqlQuery += ' AND Id IN ( SELECT Shipment__c FROM Shipment_Fee_Line__c WHERE Service_Rate_Name__r.Zona__c = \''+ datos[8] + '\' )';
            }

            soqlQuery += ' ORDER BY ETD_Time_from_Point_of_Load__c ASC';
            System.debug('consulta seccion3: '+soqlQuery);
            listaShipments = Database.query(soqlQuery);
        } catch (Exception e) {
            System.debug('Error en seccion3: ' + e.getMessage());
        }
        
        return listaShipments;
    }
    
    @AuraEnabled
    public static List<Shipment__c> getStatus2(List<String> datos) {
        List<Shipment__c> listaShipments = new List<Shipment__c>(); 
        List<Shipment_Fee_Line__c> listaServiceLine = new List<Shipment_Fee_Line__c>(); 
        Map<String,String> zonas = new Map<String,String>();
        String  idUser= UserInfo.getUserId();
        String idGenerico =idUser;
        String idGenerico2 =idUser;
        if(!Test.isRunningTest()){
            idGenerico = System.Label.Operation_Executive;
            idGenerico2 = System.Label.Operation_Executive2;
        }
        
        try {
            String fechaInicioStr = datos[2];// + 'T00:00:00Z';
            String fechaFinStr = datos[3];// + 'T23:59:59Z';
            
            String soqlQuery = 'SELECT Id,Equip_Placed__c,Seguimiento_de_devolucion_comentarios__c,Monitoreo_Recepci_n_Acuse__c, Name,Shipment_Type__c,ETD_Time_from_Point_of_Load__c, Shipment_Status_Plann__c, Operation_Executive__c, Operation_Executive__r.Name, ' +
                'Account_for__c, Account_for__r.Name, CreatedDate,Total_Services_Sell_Amount__c,Route__c,ETD_from_Point_of_Load__c,'+
                'ETA_Point_of_Discharge__c, LastModifiedDate,Route__r.Name, Shipment_Status_Mon__c ' +
                'FROM Shipment__c ' +
                'WHERE Shipment_Status_Plann__c = \'' + datos[1] + '\'' +
                ' AND ETD_from_Point_of_Load__c = ' + fechaInicioStr;
                //' AND ETD_from_Point_of_Load__c <= ' + fechaFinStr;
            if(datos[4] == 'mios'){
                soqlQuery += ' AND Operation_Executive__c = \''+ idUser +'\'';              
            }
            if(datos[0] == '2'){
                soqlQuery += ' AND (Operation_Executive__c = null OR Operation_Executive__c = \'' +idGenerico +'\' OR Operation_Executive__c = \'' +idGenerico2 +'\' )';   
            }
            if(datos[0] == '3'){
                soqlQuery += ' AND Operation_Executive__c != null AND Operation_Executive__c != \'' +idGenerico +'\'' +' AND Operation_Executive__c != \'' +idGenerico2 +'\'';  
            }
            if(datos[0] == '5'){
                soqlQuery += ' AND Shipment_Status_Mon__c != \'Delivery on Route_M\'';   
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
            if(datos[0] == '7'){
                soqlQuery += ' AND Shipment_Status_Mon__c = \'Delivery on Route_M\'';// prod: Delivery on Route_M
            }
            if(datos[8] != 'All'){
                soqlQuery += ' AND Shipment_Type__c = \''+ datos[8] +'\'';
            }

            if(datos[9] != 'All'){
                soqlQuery += ' AND Id IN ( SELECT Shipment__c FROM Shipment_Fee_Line__c WHERE Service_Rate_Name__r.Zona__c = \''+ datos[9] + '\' )';
            }


            soqlQuery += ' ORDER BY ETD_Time_from_Point_of_Load__c ASC';
            System.debug('consulta columns' + soqlQuery);
            listaShipments = Database.query(soqlQuery);
            listaServiceLine = [SELECT Shipment__c, Service_Rate_Name__c,Service_Rate_Name__r.Zona__c FROM Shipment_Fee_Line__c WHERE Shipment__c IN:listaShipments];
            for(Shipment_Fee_Line__c item : listaServiceLine){
                if(item.Service_Rate_Name__c != null){
                    zonas.put(item.Shipment__c, item.Service_Rate_Name__r.Zona__c);
                }
            }

            for(Shipment__c item:listaShipments){
                item.Seguimiento_de_devolucion_comentarios__c = zonas.get(item.Id);
            }
        } catch (Exception e) {
            System.debug('Error consulta ' + e.getMessage());
        }
        
        return listaShipments;
    }
    
    @AuraEnabled
    public static void updateExecute(String shipmentId,list<String> datos) {
        NEU_StaticVariableHelper.setBoolean1(true);
        P2G_llamadoWebHelper.setWebServiceUpdate(true);
        Shipment__c shipmentToUpdate = new Shipment__c();
        shipmentToUpdate.Id = shipmentId;
        shipmentToUpdate.Shipment_Status_Plann__c = 'In Progress';
        shipmentToUpdate.Operation_Executive__c = UserInfo.getUserId();
        if(datos[1]!='No'){
            shipmentToUpdate.Shipment_Status_Plann__c = 'Pending';
            shipmentToUpdate.Operation_Executive__c = datos[1];
        }
        if (!Test.isRunningTest()){
            update shipmentToUpdate;
        }
        NEU_StaticVariableHelper.setBoolean1(false);
        P2G_llamadoWebHelper.setWebServiceUpdate(false);
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
        //[8] -> Zona
        list<Shipment__c> lista2 = new list<Shipment__c>();
        List<Shipment__c> lista3 = new List<Shipment__c>();
        List<Shipment__c> lista4 = new List<Shipment__c>();
        List<Shipment__c> lista5 = new List<Shipment__c>();
        List<Shipment__c> lista6 = new List<Shipment__c>();
        List<Shipment__c> lista7 = new List<Shipment__c>();
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
        datos[0] = '6';
        datos[1] = 'Closed';
        lista6 = getStatus2(datos);
       	datos[0] = '7';
        datos[1] = 'Confirmed';
        lista7 = getStatus2(datos);
        return new List<List<Shipment__c>>{lista2, lista3,lista4,lista5,lista6,lista7};
            }
    
    @AuraEnabled
    public static List<Account> searchAccounts(String search) {
        if (String.isNotBlank(search) && search.length() >= 3) {
            search = '%' + search + '%';
            return [SELECT Id, Name, Customer_Id__c FROM Account WHERE Name LIKE :search LIMIT 10];
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