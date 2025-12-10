@isTest
public class NEU_OM_ShipFeeLinesPriceListYDiscountT {
    @isTest(SeeAllData=true)
    static void testConstructor() {
        Shipment__c sp = [SELECT Id,CurrencyIsoCode,Name,Site_of_Load__c,Site_of_Discharge__c,Pickup_Cartage__c,Total_Weight_Kg__c,Total_Volume_m3__c,Purchase_Incoterm__c,Sales_Incoterm__c,Account_for__c,Carrier__c,N_Containers__c,Conversion_Rate_Date__c,Total_Services_Std_Buy_Amount__c,Total_Services_Std_Buy_Amount_number__c,Total_Services_Sell_Amount__c,Total_Services_Sell_Amount_number__c,Delivery_Cartage__c,Supplier_Account__c,Enable_Route_Options__c,Country_of_Discharge__c,Country_of_Load__c,Site_of_Load__r.Name,Site_of_Discharge__r.Name,Route__c,Container_Type__c,Route__r.Port_Airport_of_Load__r.Name,Route__r.Country_of_Load__r.Name,Route__r.Port_Airport_of_Discharge__r.Name,Route__r.Country_of_Discharge__r.Name,State_of_Discharge__c,State_of_Load__c,Route__r.State_of_Load__r.Name,Route__r.State_of_Discharge__r.Name FROM Shipment__c WHERE Shipment_Status_Plann__c != 'Closed' AND Traslado_Ingreso__c != Null AND National_Operator__c != Null Order By CreatedDate desc LIMIT 1];
        Fee__c testFee = [SELECT Id,Valid_From__c,Name,CurrencyIsoCode,Container_Type__c, Route__c,Route__r.Name,Cost_Concept_1__c, Cost_Concept_2__c, Cost_Concept_3__c, Cost_Concept_4__c, Cost_Concept_5__c, Pallet_Type__c, Valid_Until__c, RecordTypeId, Account_for__r.Name,TT_Days__c,Carrier_Account__c,  Delivery_Zone__c, Port_Airport__c, Fee__c, Master_Allocation__c, Sub_Allocation__c,Fee_Category__c, Group__c, SAP_Service_Type__c, Sap_Service_Type_Buy__c, SAP_Service_Type__r.Code__c, Sap_Service_Type_Buy__r.Code__c, Route_Info__c, Bunker_Adjustment_Factor_BAF_Cont__c, Peak_Season_Surcharge_PSS_Cont__c FROM Fee__c LIMIT 1];
        
        // Crear una línea de tarifa de envío
        Shipment_Fee_Line__c testLine = new Shipment_Fee_Line__c(
            Shipment__c = sp.Id,
            Service_Rate_Name__c = testFee.Id,
            Units__c = 1,
            Shipment_Sell_Price__c = 100,
            Shipment_Buy_Price__c = 80
        );
        insert testLine;
        Test.startTest();
        ApexPages.StandardController stdController = new ApexPages.StandardController(sp);
        NEU_OM_ShipFeeLinesPriceListYDiscount controller = new NEU_OM_ShipFeeLinesPriceListYDiscount(stdController);
        String groupName = controller.getGroup();
        NEU_OM_ShipFeeLinesPriceListYDiscount controller2 = new NEU_OM_ShipFeeLinesPriceListYDiscount(new ApexPages.StandardController(sp));
        List<NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_currency_s> lines = controller2.getshipfeeLines();
        controller2.id_oi = testLine.Id;
        controller2.delete_fee_select();
        controller2.fee_record = testFee;
        controller2.getSociedadSap();
        String getrecordtype = controller2.getrecordtype();
        controller2.setrecordtype('vat');
        controller2.setnewcategory('Sea Freights');
        controller2.change_ratio_category();
        Shipment__c getshipment_filter = controller2.getshipment_filter();
        controller2.sortList(2);
        controller2.setshipment_filter(sp);
        Fee__c getservice_rate_filter = controller2.getservice_rate_filter();
        controller2.setservice_rate_filter(testFee);
		String remove1 = NEU_OM_ShipFeeLinesPriceListYDiscount.remove1('Tést');
		Boolean checkExistRoute = controller2.checkExistRoute();
		controller2.createNewRoute();
		controller2.all_accounts_filter();
		controller2.all_carriers_filter();
		controller2.filter_new_carrier();
		controller2.all_containers_filter();
		List<NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_currency_s> getshipfeeLines_all = controller2.getshipfeeLines_all();
		List<NEU_OM_ShipFeeLinesPriceListYDiscount.Shipment_Fee_Line_currency_s> getshipfeeLines_without = controller2.getshipfeeLines_without();
		controller2.go_compare_fees_filtro();
		controller2.search_name_filter();
		controller2.buscar_paises_sites();
		controller2.go_compare_fees_filtro_insertados();
		controller2.all_routes_filter();
		controller2.update_check_show_all_categories();
		controller2.update_check_hidden_all_categories();
		//List<NEU_OM_ShipFeeLinesPriceListYDiscount.NEUEBUSCM_Shipment_Fee_Line_s> getFee_List_Price = controller2.getFee_List_Price();
		controller2.anterior_siguiente_fee();
		controller2.update_record();
		Test.stopTest();
    }
    @isTest
    public static void runTest(){
        NEU_OM_ShipFeeLinesPriceListYDiscount nos = new NEU_OM_ShipFeeLinesPriceListYDiscount();
        nos.runtest();
    }
}