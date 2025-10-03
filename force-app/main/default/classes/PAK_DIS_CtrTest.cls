@isTest(SeeAllData=true)
public class PAK_DIS_CtrTest {
    @isTest
    static void testCancelarYEnviarDisbursement() {
        // Buscar un registro que tenga todos los datos relacionados
        Shipment_Disbursement__c dis = [
            SELECT Id, Account__r.Customer_id__c, CurrencyIsoCode, Shipment__r.Freight_Mode__c,
                   Shipment__r.Service_Mode__c, Shipment__r.Service_Type__c,
                   Total_Excl_VAT__c, Total_Incl_VAT__c
            FROM Shipment_Disbursement__c 
            WHERE Disbursement_Status__c != null 
            AND Account__r.Customer_id__c != null
            AND Shipment__r.Freight_Mode__c != null
            AND Shipment__r.Service_Mode__c != null
            AND Shipment__r.Service_Type__c != null
            AND CurrencyIsoCode != null
            LIMIT 1
        ];

        // Verificar que exista una línea de disbursement con los datos necesarios
        List<Disbursement_Line__c> lines = [
            SELECT Id, Units__c, Unit_Price__c, VAT__c, Sujeto_a_Ret__c,
                   Total_Incl_VAT__c, Numero_Linea__c, SAP_Service_Type__r.Code__c,
                   Concept__c
            FROM Disbursement_Line__c
            WHERE Disbursement__c = :dis.Id
            LIMIT 1
        ];
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(dis);
        PAK_DIS_Ctr controller = new PAK_DIS_Ctr(stdController);
        controller.Cancelar();
        controller.Send();
        controller.byPass();
        Test.stopTest();
    }
}