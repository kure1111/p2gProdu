@isTest(SeeAllData=true)
public class P2G_CreateCaseForNoShow_Test {

    @isTest
    static void testCaseForOperationalFailure() {
        RecordType caseRecordType = getCaseRecordType();
        Account accountFor = getCustomerAccount();
        List<Account> carriers = getCarriers();

        Shipment__c newShipment = [
            SELECT Id, Name, Reason_for_declined__c, Carrier__c 
            FROM Shipment__c 
            WHERE Shipment_Status_Plann__c = 'Cancel' 
              AND declined_for__c = 'Falla operativa' 
              AND Carrier__c != null
              AND Id = 'a0JRQ000001lEzp2AE'
            LIMIT 1
        ];

        Test.startTest();
        P2G_CreateCaseForNoShow.isAlreadyProcessed = false;
        P2G_CreateCaseForNoShow.casesNoShow(
            new List<Shipment__c>{ newShipment }, 
            new Map<Id, Shipment__c>()
        );
        Test.stopTest();

        List<Case> cases = [
            SELECT Id, Subject, Shipment__c 
            FROM Case 
            WHERE Shipment__c = :newShipment.Id
        ];
    }

    @isTest
    static void testCaseForCarrierChange() {
        RecordType caseRecordType = getCaseRecordType();
        List<Account> carriers = getCarriers();
        Account carrier2 = carriers[1];

        Shipment__c oldShipment = [
            SELECT Id, Name, Carrier__c, Declined_for__c
            FROM Shipment__c 
            WHERE  Carrier__c != null
            AND Id = 'a0JRQ000001lEzp2AE'
            LIMIT 1
        ];

        oldShipment.Carrier__c = carrier2.Id;
        update oldShipment;

        Map<Id, Shipment__c> oldShipmentsMap = new Map<Id, Shipment__c>{ 
            oldShipment.Id => oldShipment 
        };

        Test.startTest();
        P2G_CreateCaseForNoShow.isAlreadyProcessed = false;
        P2G_CreateCaseForNoShow.casesNoShow(
            new List<Shipment__c>{ oldShipment }, 
            oldShipmentsMap
        );
        Test.stopTest();

        List<Case> cases = [
            SELECT Id, Subject 
            FROM Case 
            WHERE Shipment__c = :oldShipment.Id
        ];
    }

    private static RecordType getCaseRecordType() {
        List<RecordType> caseRecordTypes = [
            SELECT Id FROM RecordType WHERE SObjectType = 'Case' LIMIT 1
        ];
        return caseRecordTypes[0];
    }

    private static Account getCustomerAccount() {
        Account account = [
            SELECT Id, Name, RecordTypeId 
            FROM Account 
            WHERE RecordType.Name = 'Customer' 
            LIMIT 1
        ];
        return account;
    }

    private static List<Account> getCarriers() {
        List<Account> carriers = [
            SELECT Id, Name 
            FROM Account 
            WHERE RecordType.Name = 'Supply Chain Partner' 
            LIMIT 2
        ];
        return carriers;
    }
    @isTest
static void testCaseForOperationalDeclineWithExistingRecords() {
    Shipment__c oldShipment = [
        SELECT Id, Name, Carrier__c, Declined_for__c 
        FROM Shipment__c 
        WHERE Declined_for__c != 'Falla operativa'
          AND Carrier__c != null
        LIMIT 1
    ];

    List<Shipment__c> potentialNewShipments = [
        SELECT Id, Name, Carrier__c, Declined_for__c, 
               Shipment_Status_Plann__c, Reason_for_declined__c
        FROM Shipment__c 
        WHERE Declined_for__c = 'Falla operativa'
          AND Shipment_Status_Plann__c = 'Cancel'
        LIMIT 10
    ];

    Shipment__c newShipment = null;
    for (Shipment__c shipment : potentialNewShipments) {
        if (String.isNotBlank(shipment.Reason_for_declined__c)) {
            newShipment = shipment;
            break;
        }
    }

    Map<Id, Shipment__c> oldShipmentsMap = new Map<Id, Shipment__c>{
        newShipment.Id => oldShipment
    };

    Test.startTest();
    P2G_CreateCaseForNoShow.isAlreadyProcessed = false;
    P2G_CreateCaseForNoShow.casesNoShow(
        new List<Shipment__c>{ newShipment },
        oldShipmentsMap
    );
    P2G_CreateCaseForNoShow.getRelatedCases(newShipment.Id);
    Test.stopTest();

    /*List<Case> cases = [
        SELECT Id, Subject 
        FROM Case 
        WHERE Shipment__c = :newShipment.Id
    ];*/
}

}