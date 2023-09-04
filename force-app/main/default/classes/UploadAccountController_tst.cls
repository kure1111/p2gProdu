@isTest
public class UploadAccountController_tst {

     @isTest static void createAccounts() {
        string json = '[{"Code":"","ACCOUNT_NAME":"Shanghai South-Logistics Co","ACCOUNT_OWNER":"'+UserInfo.getUserId()+'","Potencializacion":"True","Tax_Id":"xxxxx1xxxxxxxx","Correo":"francisco.ochoa@pak2go.com","Telefono":"1234567899","Direccion":"rio limay 162 -a","Recuperado":"","TagDesarrolloComercial":""}]';
         UploadAccountController.createLines(json);
    }
     @isTest static void updateAccounts() {
         account acc = new account( name='Prueba',
                                    ownerId=UserInfo.getUserId()
         							);
         insert acc;
         string json = '[{"Code":"'+ acc.Id+'","ACCOUNT_NAME":"Shanghai South-Logistics Co","ACCOUNT_OWNER":"'+UserInfo.getUserId()+'","Potencializacion":"True","Tax_Id":"xxxxx1xxxxxxxx","Correo":"francisco.ochoa@pak2go.com","Telefono":"1234567899","Direccion":"rio limay 162 -a","Recuperado":"","TagDesarrolloComercial":""}]';
         UploadAccountController.createLines(json);
    }
    @isTest static void ErrorAccounts() {
         account acc = new account( name='Prueba',
                                    ownerId=UserInfo.getUserId()
         							);
         insert acc;
         string json = '[{"Code":"'+ acc.Id+'","ACCOUNT_NAME":"Shanghai South-Logistics Co","ACCOUNT_OWNER":"Paola","Potencializacion":"True","Tax_Id":"xxxxx1xxxxxxxx","Correo":"francisco.ochoa@pak2go.com","Telefono":"1234567899","Direccion":"rio limay 162 -a","Recuperado":"","TagDesarrolloComercial":""}]';
         UploadAccountController.createLines(json);
    }
}