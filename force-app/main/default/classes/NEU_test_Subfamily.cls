@isTest
private class NEU_test_Subfamily {

 	
	public static testMethod void test_NEU_OM_UploadImageSubfamily() {//ok
     	NEU_StaticVariableHelper.setBoolean1(true);
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
	    insert c;
	    Subfamily__c subfamily = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
	    insert subfamily;
        ApexPages.currentPage().getParameters().put('test', 'test');
        NEU_OM_UploadImageSubfamily uis = new NEU_OM_UploadImageSubfamily(new ApexPages.StandardController( subfamily ));
        uis.upload();
        uis.byPass();
        system.debug( 'Prueba realizada' );
    }
}