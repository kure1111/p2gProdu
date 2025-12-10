@isTest
public class P2G_NEU_CheckDuplicateTrafficTest {
    
    @isTest(SeeAllData=true)
    static void NEU_CheckDuplicateTrafficTest() {
        Test.startTest();
        
        Country__c country = new Country__c(Name = 'Test Country', ISO_Code__c = 'EUR');
        insert country;
        
        
        State__c state1 = new State__c(Name = 'State 1', Country__c = country.Id);
        State__c state2 = new State__c(Name = 'State 2', Country__c = country.Id);
        insert new List<State__c>{state1, state2};
            
            
            Location__c location1 = new Location__c(
                Name = 'Test Location',
                City__c = 'City',
                Country__c = country.Id,
                Subdivision__c = state1.Id,
                UNLOCODE__c = 'LOC123'
            );
        
        Location__c location2 = new Location__c(
            Name = 'New Location',
            City__c = 'City 2',
            Country__c = country.Id,
            Subdivision__c = state2.Id,
            UNLOCODE__c = 'NEWLOC'
        );
        insert new List<Location__c>{location1, location2};
            
            
            Account acc = [SELECT Id FROM Account WHERE RecordType.Name='Customer' AND BillingCountry='MX' AND Owner.SalesEmployer__c!=null LIMIT 1];
        
        
        Traffic__c trafficWithExistingRoute = new Traffic__c(
            Name='Test Traffic',
            Account__c = acc.Id,
            Country_of_Load__c = country.Id,
            Country_of_Discharge__c = country.Id,
            State_of_Load__c = state1.Id,
            State_of_Discharge__c = state1.Id, // Debe ser del mismo país
            Site_of_Load__c = location1.Id,
            Site_of_Discharge__c = location1.Id,
            Profit_Proyection__c = 100,
            Revenue_Proyection__c = 200,
            Shipments_Proyection__c = 2
        );
        insert trafficWithExistingRoute;
        
        Traffic__c trafficWithNewRoute = new Traffic__c(
            Account__c = acc.Id,
            Country_of_Load__c = country.Id,
            Country_of_Discharge__c = country.Id,
            State_of_Load__c = state2.Id, // Usar ID del estado, no string
            State_of_Discharge__c = state2.Id, // Usar ID del estado, no string
            Site_of_Load__c = location2.Id,
            Site_of_Discharge__c = location2.Id,
            Profit_Proyection__c = 50,
            Revenue_Proyection__c = 150,
            Shipments_Proyection__c = 1
        );
        insert trafficWithNewRoute;
        
        
        Test.stopTest();
    }
}