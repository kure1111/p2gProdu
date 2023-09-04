public with sharing class NEU_Custom_Settings_Administration {

	public  List<CSH_Shopping_Cart__c> lista_customer_order  {get;set;}
	public  List<CSH_Community__c> lista_community  {get;set;}
	public  List<CSH_Import_Export__c> lista_Import_Export  {get;set;}
	public  List<CSH_Shipment__c> lista_Shipment  {get;set;}
	public  List<CSH_Shipment_Consolidation__c> lista_Shipment_Consolidation  {get;set;}
	public  List<CSH_Supplier_Request__c> lista_Supplier_Request  {get;set;}
	public  List<CSH_Trade_Consolidation__c> lista_Trade_Consolidation  {get;set;}
	public  List<CSL_Self_Registration__c> lista_Self_Registration  {get;set;}
	
	public void getallcustomssetting()
	{
		
		lista_customer_order = [Select Id, SetupOwnerId, E_Commerce_Offers_Selection__c, Items_Selection__c, Shopping_Cart_Type_Authorized__c from CSH_Shopping_Cart__c where SetupOwnerId =: UserInfo.getOrganizationId()];
		
		lista_community = [Select Community_Id__c from CSH_Community__c where SetupOwnerId =: UserInfo.getOrganizationId()];
	
		lista_Import_Export = [Select Use_Price_List_and_Dicounts__c from CSH_Import_Export__c where SetupOwnerId =: UserInfo.getOrganizationId()];
		
		lista_Shipment = [Select Default_Freight_Mode__c, Default_Supply_Project_Customer_Buyer__c from CSH_Shipment__c where SetupOwnerId =: UserInfo.getOrganizationId()];
		
		lista_Shipment_Consolidation = [Select Show_Only_I_E_Lines_without_SO_Line__c from CSH_Shipment_Consolidation__c where SetupOwnerId =: UserInfo.getOrganizationId()];

		lista_Supplier_Request = [Select Default_Community_URL__c, Default_External_URL__c, Use_External_Url__c from CSH_Supplier_Request__c where SetupOwnerId =: UserInfo.getOrganizationId()];

		lista_Trade_Consolidation = [Select Use_Shipment_Consolidation__c from CSH_Trade_Consolidation__c where SetupOwnerId =: UserInfo.getOrganizationId()];
		
		lista_Self_Registration = [Select Name, Business_Areas__c from CSL_Self_Registration__c where SetupOwnerId =: UserInfo.getOrganizationId()];
	}
	
	public void save()
	{
		update lista_customer_order;
		update lista_community;
		update lista_Import_Export;
		update lista_Shipment;
		update lista_Shipment_Consolidation;
		update lista_Supplier_Request;
		update lista_Trade_Consolidation;
		update lista_Self_Registration;
	}
	
}