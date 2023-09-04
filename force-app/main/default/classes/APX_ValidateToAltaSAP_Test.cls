@isTest
public class APX_ValidateToAltaSAP_Test {
    

    public static testMethod void test_APX_ValidateToAltaSAP(){
        
        //Crear una cuenta
        Account newAccount = new Account();
        newAccount.Name = 'Cuenta Test';
        newAccount.is_Ready_SAP__c = true;
        insert newAccount;

        Account newAccount2 = new Account();
        newAccount2.Name = 'Cuenta Test2';
        newAccount2.is_Ready_SAP__c = true;
        newAccount2.Fecha_Alta_Cliente_SAP__c = Datetime.now();
        insert newAccount2;

        APX_ValidateToAltaSAP.wrapperValidateComponent wrapp = new APX_ValidateToAltaSAP.wrapperValidateComponent();
        wrapp.accOBJ =newAccount;
        wrapp.isReady=newAccount.is_Ready_SAP__c;
        wrapp.isUser=true;        

        APX_ValidateToAltaSAP.wrapperValidateComponent wrapp2 = new APX_ValidateToAltaSAP.wrapperValidateComponent();
        wrapp2.accOBJ =newAccount2;
        wrapp2.isReady=newAccount.is_Ready_SAP__c;
        wrapp2.isUser=true;  

        APX_ValidateToAltaSAP.getInfo(newAccount.Id);    
        APX_ValidateToAltaSAP.updateAcc(wrapp);
        APX_ValidateToAltaSAP.updateAcc(wrapp2);
        

       

    }

    public class wrapperValidateComponent{
        public Boolean isReady{get;set;}
        public Boolean isUser{get;set;}
        public Account accOBJ{get;set;}
    } 

}