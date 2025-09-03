@isTest
public class UniqueRouteTest {
    @IsTest(SeeAllData=true)
    public static void test(){
        Location__c location = [SELECT Id,Country__c,State__c, Name FROM Location__c limit 1];
        Carrier_Line_Load_Point__c point = new Carrier_Line_Load_Point__c();
        point.Name = 'Pruebita';
        point.Country_of_Load__c = location.Country__c;
        point.State_of_Load__c = location.State__c;
        point.Port_Airport_of_Load__c = location.Id;
        //
        point.Country_of_Discharge__c = location.Country__c;
        point.State_of_Discharge__c = location.State__c;
        point.Port_Airport_of_Discharge__c = location.Id;
        insert point;
        
    }

}