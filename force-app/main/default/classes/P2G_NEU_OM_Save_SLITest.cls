@isTest
public class P2G_NEU_OM_Save_SLITest {
    
    @isTest(SeeAllData=true)
    static void test_NEU_OM_Save_SLI(){
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00057', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line');
        insert shipline;
        NEU_OM_Save_SLI gpcc = new NEU_OM_Save_SLI(new ApexPages.StandardController( ship ));
        system.debug( 'Prueba realizada' );
        Blob b = Blob.valueOf('Test Data');
        gpcc.documento_asociado.Name='Test document.test';
        gpcc.documento_asociado.AuthorId = UserInfo.getUserId();
        gpcc.documento_asociado.IsPublic=true;
        gpcc.documento_asociado.Body = b;
        gpcc.crear();
        
    }
}