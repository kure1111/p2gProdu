/**
 * @description       : 
 * @author            : Brandom Gonzalez
 * @group             : 
 * @last modified on  : 08-12-2022
 * @last modified by  : Brandom Gonzalez
 * % Test			  : 87%
**/
public with sharing class APX_Verificacion_Pak_Control {   
    
    @AuraEnabled(cacheable = true)
    public static List<Shipment__c> getRecord(String spId){
        system.debug('APX_Verificacion_Pak_Control: ' + spId);
        return [Select Id,Name,Carrier__c,Carrier__r.Name, Compania_GPS__c,Liga_Cuenta_Espejo__c,Usuario_Cuenta_Espejo__c,Contrasena_Cuenta_Espejo__c,
                National_Operator__c,National_Operator__r.Name, Vehicle__c,Vehicle__r.Name, Vehicle__r.Registration_Number__c,Vehicle__r.Numero_Poliza_Seguro__c, 
                National_Operator__r.Numlicvig_ope__c,Vehicle__r.Poliza_Responsabilidad_civil__c,Vehicle__r.Poliza_Seguro_Medio_Ambiente__c, 
                National_Operator__r.Licvig_ope__c,National_Operator__r.Fecha_de_vigencia_de_la_licencia__c,National_Operator__r.Telfij_ope__c,
                Vehicle__r.Account_Owner_Vehicle__c, Vehicle__r.Account_Owner_Vehicle__r.Name, Vehicle__r.Account_Owner_Vehicle__r.Parent.Name, Vehicle__r.Account_Owner_Vehicle__r.Record_Type_Name__c,
                Vehicle__r.Account_Owner_Vehicle__r.Arrendatario_Propietario__c, Account_for__c, Account_for__r.Name, Account_for__r.RecordType.Name,
                Vehicle__r.Nombre_Aseguradora__c from  Shipment__c where Id=:spId];
    }      

    @AuraEnabled
    public static void  cancelModal(String recordId){
        try {
            
            Shipment__c sp = [Select Id, name, Shipment_Status_Plann__c from Shipment__c where Id=:recordId];
            sp.Shipment_Status_Plann__c = 'In Progress';
            update sp; 
            system.debug('Se ha cambiado el Shipment status planner: ' + sp.Shipment_Status_Plann__c);

        } catch (Exception e) {
            system.debug('Ocurrio un erro al actualizar el Shipment status planner cuando cierra el modal: ' + e.getCause() + ' Linea: ' + e.getLineNumber() + 
                            ' mensaje: ' + e.getMessage());

            String errorMsg = e.getMessage();
            Integer i = errorMsg.lastIndexOf('_EXCEPTION,');
            String pureErrorMsg = errorMsg.substring(i+1);            
            throw new AuraHandledException(pureErrorMsg);            
        }
    }

    @AuraEnabled
    public static String updateShipmentData(String recordId, Shipment__c spData, Vehicle__c vData, Operadores__c opeData, String carrierGPS){
        try {
                    
            System.debug('Actualizar datos del Shipment, Vehiculo, Operador y Cuenta...');            
            
            Shipment__c ship = [select id, Vehicle__c,National_Operator__c, Carrier__c from Shipment__c where id=:recordId]; 
            Account carrier = [Select Id, name from Account where Id =: ship.Carrier__c];

            spData.Id = recordId;        
            vData.Id = ship.Vehicle__c;
            opeData.Id = ship.National_Operator__c;       
            ship.VERIFY_PAK_CONTROL__c = true;
            ship.VerificacionPak__c = true;     
            carrier.Comgps_cta__c = carrierGPS;

            update vData;
            update spData;            
            update opeData;
            update ship;
            update carrier;

            System.debug('Se ha actualizado correctamente los datos');
            return 'Se ha validado correctamente los datos';       
                        
        } catch (Exception e) {
            system.debug('Ocurrio un erro al actualizar los datos: ' + e.getCause() + ' Linea: ' + e.getLineNumber() + 
                            ' mensaje: ' + e.getMessage());
            
            return e.getMessage();                            
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<SObject> findRecords(String search, String objectName, String accId, String type){
        try {            
            String searchName = '%'+search+'%';           
            string searchText = '\'%' + String.escapeSingleQuotes(search) + '%\'';                         
            String label = (objectName == 'Vehicle__c') ? 'Account_for_SCP__c': (objectName == 'Operadores__c') ? 'Account__c' : (objectName == 'Shipment__c') ? 'Account_for__c' : (objectName == 'Debit_Note__c') ? 'Account_for__c' :null;
            String query;
            String carrierID='\''+accId+'\''; 
            system.debug('Obteniendo registros de:  ' + objectName + ' label: ' + label);

            if(objectName == 'Account'){
               String recordType = '\'' + String.escapeSingleQuotes(type) + '\'';
               query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' and RecordType.Name ='+recordType+' limit 5';             
            }else{                
                query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' and '+label+' ='+carrierID+' limit 5';
                system.debug('No Account: ' + query);                                
            }           
            system.debug('return: ' + Database.query(query));
            
            return Database.query(query);
            
        } catch (Exception e) {
            system.debug('Ocurrio un error al encontrar la informacion de  ' +objectName + ' : ' + e.getCause() + ' Linea: ' + e.getLineNumber() + 
                            ' mensaje: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String updateShipmentObject(String spId, Id objId){
        
        String name;

        try {
            
            string objectName= string.valueOf(objId.getSObjectType());
            Shipment__c sp = [Select Carrier__c, National_Operator__c, Vehicle__c from Shipment__c where Id =: spId];            

            if(objectName == 'Account'){
                sp.Carrier__c = objId;                
                name = 'Carrier';
            }else if(objectName == 'Operadores__c'){                
                sp.National_Operator__c = objId;
                name = 'Operador';                
            }else if(objectName == 'Vehicle__c'){
                sp.vehicle__c = objId;  
                name = 'Vehiculo';              
            }

            update sp;            
            system.debug('Se ha actualizado  ' + name + ' del Shipment correctamente');

            return name;

        } catch (Exception e) {
            system.debug('Ocurrio un error al actualizar el ' +name + ' : ' + e.getCause() + ' Linea: ' + e.getLineNumber() + ' mensaje: ' + e.getMessage());
            return name;            
        }
    }

    @AuraEnabled
    public static Boolean recordChangeData(String recordId, Id objId){
        
        String name;

        try {

            string objectName= string.valueOf(objId.getSObjectType());
            Shipment__c sp = [Select Carrier__c, National_Operator__c, Vehicle__c from Shipment__c where Id =: recordId];            

            if(objectName == 'Account'){
                sp.Carrier__c = null;
                sp.National_Operator__c = null;      
                sp.vehicle__c = null;          
                name = 'Carrier';
            }else if(objectName == 'Operadores__c'){                
                sp.National_Operator__c = null;
                name = 'Operador';                
            }else if(objectName == 'Vehicle__c'){
                sp.vehicle__c = null;
                name = 'Vehiculo';
            }

            update sp;            
            system.debug('Se ha cambiado ' + name + ' del Shipment correctamente');        
            return true;

        } catch (Exception e) {

            system.debug('Ocurrio un error cambiar los datos del ' +name + ' : ' + e.getCause() + ' Linea: ' + e.getLineNumber() + ' mensaje: ' + e.getMessage());
            return false;            
        }
    }    
}