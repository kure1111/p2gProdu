/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class NEU_test_S_and_O_Plan {

    static testMethod void test_NEU_Company_Plan_Filter() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Company_Plan__c new_company_plan = new Company_Plan__c(Name='test company', Active__c= true, Valid_From__c = system.today(), Valid_To__c = system.today().addmonths(8));
        insert new_company_plan;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account customer = list_accounts[0];
        insert customer;
        NEU_Factory__c new_factory_line = new NEU_Factory__c(Account_Owner__c =customer.Id );
        insert new_factory_line;
        Labor_Program__c new_labor_program = new Labor_Program__c(Valid_From__c = system.today(), Valid_To__c = system.today().addmonths(8), Company_Plan__c =new_company_plan.Id, Factory_Line__c =new_factory_line.Id );
        insert new_labor_program;
        NEU_Company_Plan_Filter company = new NEU_Company_Plan_Filter(new ApexPages.StandardController( new_company_plan ));
        NEU_Company_Plan_Filter.Data class_data = new NEU_Company_Plan_Filter.Data('',10,10,10);
              
        company.pintar_grafico();
        company.getPrograms();
        company.pintar_grafico();
        company.getcountries();
        company.getlocations();
        company.getfactories();
        company.getfamilies();
        company.getsubfamilies();
        company.getvalids_froms();
    }
    
    static testMethod void test_NEU_Make_Line_Plan() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Company_Plan__c new_company_plan = new Company_Plan__c(Name='test company', Active__c= true, Valid_From__c = system.today(), Valid_To__c = system.today().addmonths(8));
        insert new_company_plan;
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        NEU_Factory__c new_factory = new NEU_Factory__c(Account_Owner__c = a.Id);
        insert new_factory;
        Labor_Program__c lp = new Labor_Program__c(Factory_Line__c = new_factory.Id, Company_Plan__c = new_company_plan.Id, Valid_From__c = system.today(), Valid_To__c = system.today().addyears(2) );
        insert lp;
        Production_Order__c new_production_order = new Production_Order__c(Item__c = g.Id, Labor_Program__c =lp.Id);
        insert new_production_order;
        Item_Program__c new_item_program = new Item_Program__c(Family__c = c.Id, Factory_Line__c = new_factory.Id, Item__c = g.Id, Subfamily__c = d.Id);
        insert new_item_program;
        Item_Historical_Data__c new_item_ihd = new Item_Historical_Data__c(Family__c = c.Id, Item_Name__c = g.Id, Units__c = 10,  Subfamily__c = d.Id, From__c = system.today().addyears(1));
        insert new_item_ihd;
        NEU_Make_Line_Plan make_line_plan = new NEU_Make_Line_Plan(new ApexPages.StandardController( new_company_plan ));
        List<string> listado_familias = new List<string>();
        listado_familias.add(c.Id);
        make_line_plan.setselected( listado_familias);
        make_line_plan.graphData = make_line_plan.graphData;
        make_line_plan.nperiods = make_line_plan.nperiods;
        
        make_line_plan.years = make_line_plan.years;
        make_line_plan.year = system.today().year();
        make_line_plan.datatype = make_line_plan.datatype;
        make_line_plan.headers = make_line_plan.headers;
        
        make_line_plan.currentItem = g.Id;
        make_line_plan.currentItem = make_line_plan.currentItem;
        make_line_plan.currentSubfamily = make_line_plan.currentSubfamily;
        make_line_plan.currentFamily = make_line_plan.currentFamily;
        make_line_plan.getprogram();
        make_line_plan.updatePlan();
        make_line_plan.getItems();
        make_line_plan.currentItem = null;
        make_line_plan.currentFamily = c.Id;
        make_line_plan.getprogram();
        make_line_plan.currentFamily = null;
        make_line_plan.currentSubfamily = d.Id;
        make_line_plan.getprogram();
        make_line_plan.year = system.today().addyears(1).year();
        make_line_plan.automaticPlan();
        make_line_plan.getfamilies();
        make_line_plan.datatype = 'subfamilies'; 
        make_line_plan.getItems();
        
        make_line_plan.getfamilyList();
        make_line_plan.getfamilyname();
        make_line_plan.setfamilies(null);
        
        
        
        
    }
    
    static testMethod void test_NEU_Upload_Capacity_Plan() 
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Company_Plan__c new_company_plan = new Company_Plan__c(Name='test company', Active__c= true, Valid_From__c = system.today(), Valid_To__c = system.today().addmonths(8));
        insert new_company_plan;
        NEU_Upload_Capacity_Plan upload_capacity = new NEU_Upload_Capacity_Plan(new ApexPages.StandardController( new_company_plan ));
        upload_capacity.documento1Name = 'test_excel.xlsx';
        upload_capacity.upload();
    }
}