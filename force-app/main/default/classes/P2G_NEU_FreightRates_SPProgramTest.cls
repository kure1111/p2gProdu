@isTest
public class P2G_NEU_FreightRates_SPProgramTest {
    @isTest
    static void NEU_FreightRates_ShipmentsPrograms() {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10');
        insert ship_prog;
        
        NEU_FreightRates_ShipmentsPrograms fsp = new NEU_FreightRates_ShipmentsPrograms(new ApexPages.StandardController(ship_prog));
        fsp.ordenar_tabla_fees();
        
    }
}