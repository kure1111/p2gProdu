public with sharing class APX_ValidateToAltaSAP {
    @AuraEnabled(cacheable=true)
    public static wrapperValidateComponent getInfo(string RecordID) {        
        wrapperValidateComponent wrapp =new wrapperValidateComponent(); 
        wrapp.accOBJ = API_Querys.getAccByID(RecordID);
        wrapp.accOBJ.is_Ready_SAP__c=true;
        wrapp.isReady=wrapp.accOBJ.is_Ready_SAP__c;
        wrapp.isUser=true;/*(Userinfo.getName()=='Leonardo Nocelo')?true:false;*/ //Brandom Gonzalez Leonardo Nocelo
        system.debug('wrapp.isUser: '+wrapp.isUser);
        system.debug('user name: '+Userinfo.getName());
        return wrapp;
    }  
    @AuraEnabled
    public static string  updateAcc(wrapperValidateComponent wrapp){
        try {
            System.debug('lo que recibimos:  '+wrapp);
            if(wrapp.accOBJ.recordtype.Name!='Customer'){
                system.debug('entrando a  actualizacion de recordtype rec actual: '+wrapp.accOBJ.recordtype.Name);
                recordType recordTypeCustomer=API_Querys.getRecordTypeByName('Customer');
                wrapp.accOBJ.recordtypeId =recordTypeCustomer.Id;
                system.debug('recordtype : '+wrapp.accOBJ.recordtypeId);
                system.debug('recordtype : '+wrapp.accOBJ.recordtype.name);
                // Account newAccObj = wrapp.accOBJ;
                // newAccObj.recordtypeId =recordTypeCustomer.Id;
                // system.debug('old CustomerID: '+recordTypeCustomer.Id);
                // system.debug('old CustomerName: '+recordTypeCustomer.NAME);
                // system.debug('old account: '+wrapp.accOBJ);
                // system.debug('old recordtype: '+wrapp.accOBJ.recordtypeID);
                // system.debug('new account: '+newAccObj);
                // system.debug('new recordtype: '+newAccObj.recordtypeID);
                // Update newAccObj;

            }

            DateTime data = Datetime.now();

            String zonaH = data.format('yyyy-MM-dd HH:mm:ss','America/Mexico_City');
            Datetime nowTime = Datetime.valueOfGMT(zonaH);            
            
            if(wrapp.isUser && wrapp.isReady && wrapp.accOBJ.Fecha_Alta_Cliente_SAP__c == null){

                wrapp.accOBJ.Fecha_Alta_Cliente_SAP__c = nowTime;
    
            }else if(wrapp.isUser && wrapp.isReady && wrapp.accOBJ.Fecha_Alta_Cliente_SAP__c != null){
    
                wrapp.accOBJ.Fecha_Actualizacion_Cliente_SAP__c = nowTime;
            }
            System.debug('actualizando account:  '+wrapp.accOBJ);
            System.debug('recordtype Nuevo:  '+wrapp.accOBJ.recordtypeid);
            update wrapp.accOBJ;
            return 'ok';
        } catch (Exception e) {
            System.debug(e.getLineNumber()+'------------'+e.getMessage() +' --- '+e.getStackTraceString());
            return e.getMessage();
        }
    } 
    public class wrapperValidateComponent{
        @AuraEnabled public Boolean isReady{get;set;}
        @AuraEnabled public Boolean isUser{get;set;}
        @AuraEnabled public Account accOBJ{get;set;}
    }                   
}