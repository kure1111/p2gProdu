@isTest
public class P2G_CargaObjSalesforceTest {
    
    @isTest(SeeAllData=true)
    public static void main(){
        NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c quote= [SELECT Id, Route__c, Account_for__c FROM Customer_Quote__c WHERE Pricing_Executive__c!=null LIMIT 1];
        Account account= [SELECT Id FROM Account WHERE RecordType.Name='Customer' LIMIT 1];
        String recordTypefee = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c fee = new Fee__c();
        fee.RecordTypeId = recordTypefee;
        fee.Name = 'Flete Nacional';
        fee.Route__c = quote.Route__c;
        fee.CurrencyIsoCode = 'MXN';
        fee.Fee_Category__c = 'Road Freights';
        fee.Group__c = 'SP-FN-FLETE NACIONAL';
        fee.Account_for__c=quote.Account_for__c;
        
        insert fee;
        
        Container_Type__c container = new Container_Type__c(Name='Super tracto Camion',Type__c='Road',Cargo_Weight_Kg__c=22222);
        insert container;
        
        Quote_Item_Line__c cargoLine = new Quote_Item_Line__c();
        cargoLine.Import_Export_Quote__c=quote.Id;
        cargoLine.Name='cargo12';
        cargoLine.Container_Type__c=container.Id;
        //cargoLine.Clave_de_Servicio__c=producto.Id;
        cargoLine.Extension_Item_Name__c='Papel';
        cargoLine.CurrencyIsoCode='MXN';
        cargoLine.Conversion_Rate_to_Currency_Header__c=1;
        cargoLine.Units__c=1;
        cargoLine.Total_Shipping_Weight_Kgs__c=1;
        cargoLine.Peso_Neto__c=1;
        cargoLine.Total_Shipping_Volume_m3__c=1;
        insert cargoLine;
        
        
        Import_Export_Fee_Line__c quote_fee = new Import_Export_Fee_Line__c();
        quote_fee.Import_Export_Quote__c = quote.id;
        quote_fee.Name = 'lineas items';
        quote_fee.Service_Rate_Name__c= fee.Id;
        quote_fee.Concept_1_Sell_Price__c =10;
        quote_fee.Concept_2_Sell_Price__c = 10;
        quote_fee.Concept_3_Sell_Price__c =10;
        quote_fee.Concept_4_Sell_Price__c = 10;
        quote_fee.Concept_5_Sell_Price__c =10;
        insert quote_fee;
        
    }
    
    //Creacion del Shipment y Shipment Service Line
    @isTest(SeeAllData=true)
    public static void testCreateShipment(){
        NEU_StaticVariableHelper.setBoolean1(true);
        Customer_Quote__c quote= [SELECT Id, Route__c, Account_for__c FROM Customer_Quote__c WHERE Pricing_Executive__c!=null LIMIT 1];
        Country__c country= [SELECT Id FROM Country__c LIMIT 1];
        
        Country__c country2 = new Country__c(
            Name = 'Mexico',
        ISO_Code_2c__c = 'MX',
        ISO_Code__c = 'MEX'
            );
        insert country2;
        
        State__c state = new State__c(
            Name = 'Sonora',
        ISO_Code_2c__c = 'SO',
        country__c = country.Id
            );
        insert state;
        
        Location__c location = new Location__c(
            Name = 'Hermosillo',
        state__c = state.Id,
        country__c = country.Id
            );
        insert location;
        
        Container_Type__c container = new Container_Type__c();
        container.Name = 'test';
        insert container;
        
        Shipment__c new_shipment = new Shipment__c();
        new_shipment.Name = 'SP-FN-23-001999';
        new_shipment.Freight_Mode__c= 'Road';
        new_shipment.Service_Type__c= 'FTL';
        new_shipment.ETA_Point_of_Discharge__c = Date.valueOf('2023-05-2');
        new_shipment.ETD_from_Point_of_Load__c = Date.valueOf('2023-05-12');
        new_shipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(08,0,0,0);
        new_shipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(08,0,0,0);
        new_shipment.Route__c = quote.Route__c;
        new_shipment.Account_for__c= quote.account_for__c;
        new_shipment.Country_of_Discharge__c = country.Id;
        new_shipment.Country_of_Load__c = country.Id;
        new_shipment.State_of_Discharge__c = state.Id;
        new_shipment.State_of_Load__c = state.Id;
        new_shipment.Site_of_Discharge__c = location.Id;
        new_shipment.Site_of_Load__c = location.Id;
        new_shipment.Container_Type__c = container.Id;
        new_shipment.Service_Mode__c = 'NATIONAL';
        insert new_shipment;
        
        Shipment_Fee_Line__c feeFalse = new Shipment_Fee_Line__c();
        feeFalse.Name = 'Fee False';
        feeFalse.Campo_Control__c = false;
        feeFalse.Shipment__c=new_shipment.Id;
        
        Catalogo_SAT__c servicio = new Catalogo_SAT__c();
        servicio.Name = 'Papel Test';
        servicio.Clave_SAT__c = '15975361';
        servicio.Material_PeligrosoCP__c = true;
        servicio.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        insert servicio;
        
        Catalogo_SAT__c cajasCon = new Catalogo_SAT__c();
        cajasCon.Name = 'cajas conexion Test';
        cajasCon.Clave_SAT__c = '01264588';
        cajasCon.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Fraccion Arancelaria').getRecordTypeId();
        insert cajasCon;
        
        Catalogo_SAT__c embalaje = new Catalogo_SAT__c();
        embalaje.Name = 'Envases y embalajes Test';
        embalaje.Clave_SAT__c = 'Envases y embalajes Test';
        embalaje.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Embalaje').getRecordTypeId();
        insert embalaje;
        
        Shipment_Line__c cl = new Shipment_Line__c();
        cl.Name = '001';
        cl.Shipment__c = new_shipment.Id;
        cl.Container_Type__c = container.Id;        
        cl.Clave_de_Servicio__c = servicio.Id;
        //cl.pedimento__c = 'Test pedimiento';
        //cl.Peso_Neto__c = 10;
        //cl.Units_Shipped__c = 2;
        //cl.Shipping_Weight_Kg__c = 2;
        //cl.CP_Fraccion_Arancelaria__c = cajasCon.Id;
        //cl.Embalaje__c = embalaje.Id;
        insert cl;
    }
    
    
}