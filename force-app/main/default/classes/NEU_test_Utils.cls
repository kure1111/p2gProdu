@isTest
private class NEU_test_Utils {

    static testMethod void test_NEU_Utils() {
        NEU_StaticVariableHelper.setBoolean1(true);
        NEU_Utils c = new NEU_Utils();

        // Métodos de instancia
        c.toDecimalR(null);
        c.toDecimalR('00');
        c.toDecimalR('a');
        c.toDecimalR('3.3,3');
        c.getDecimalSepR();
        c.getThousandSepR();

        // Métodos estáticos
        NEU_Utils.toDecimal(null);
        NEU_Utils.toDecimal('00');
        NEU_Utils.toDecimal('a');
        NEU_Utils.toDecimal('3.3,3');
        NEU_Utils.getDecimalSep();
        NEU_Utils.getThousandSep();

        // safeDecimal
        NEU_Utils.safeDecimal((Integer)null);
        NEU_Utils.safeDecimal((Decimal)null);
        NEU_Utils.safeDecimal((String)null);
        NEU_Utils.safeDecimal(0.0);

        // safeInteger
        Decimal valor = null;
        NEU_Utils.safeInteger(valor);
        NEU_Utils.safeInteger(0.1);
        Integer valor_int = null;
        NEU_Utils.safeInteger(valor_int);
        NEU_Utils.safeInteger(0);
        NEU_Utils.safeInteger('a');
        NEU_Utils.safeInteger('0');

        // safeString
        NEU_Utils.safeString(null);
        NEU_Utils.safeString(0.0);
        NEU_Utils.safeString(System.today());
        NEU_Utils.safeString(System.now());
        NEU_Utils.safeString('test');
        NEU_Utils.safeString(0, 2);
        NEU_Utils.safeString(0.1, 2);

        // getAccounts + populateClone + populate + getStringPopulate
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        if (!list_accounts.isEmpty()) {
            Account a = list_accounts[0];
            insert a;
            NEU_Utils.populateClone(a);
            NEU_Utils.populate(new String[]{'Id'}, 'Contact', a.Id);
            NEU_Utils.getStringPopulate(a);
        }
    }

    static testMethod void test_formatAddress() {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        // formatAddress con distintas combinaciones de null
        NEU_Utils.formatAddress('1', '2', '3', '4', '5');
        NEU_Utils.formatAddress(null, '2', '3', '4', '5');
        NEU_Utils.formatAddress('1', null, '3', '4', '5');
        NEU_Utils.formatAddress(null, null, '3', '4', '5');
        NEU_Utils.formatAddress('1', null, null, '4', '5');
        NEU_Utils.formatAddress(null, '2', null, '4', '5');
        NEU_Utils.formatAddress(null, null, null, '4', '5');
        NEU_Utils.formatAddress(null, null, null, null, '5');

        // Métodos relacionados con IATA/PIMA
        NEU_Utils.getCarrierAgentIATA('MTY', 'MTY');
        NEU_Utils.getCarrierAgentIATA('GDL', 'GDL');
        NEU_Utils.getCarrierAgentIATA('MID', 'MID');
        NEU_Utils.getCarrierAgentIATA('test', 'test');

        NEU_Utils.getPIMA('MTY', 'MTY');
        NEU_Utils.getPIMA('GDL', 'GDL');
        NEU_Utils.getPIMA('MID', 'MID');
        NEU_Utils.getPIMA('test', 'test');

        NEU_Utils.removeAccents('test');
        NEU_Utils.removeAccents('áéíóúñÑ');
        
    }
    @isTest
    static void test_deserialize() {
        // Caso 1: cadena vacía
        String result1 = NEU_Utils.deserialize('');
    
        // Caso 2: cadena sin el patrón esperado
        String input2 = '{"Name":"Test"}';
        String result2 = NEU_Utils.deserialize(input2);
        // Caso 3: cadena con el patrón esperado
        String input3 = '{"Account__r":{"sobjectType":"Account","Name":"Test"},"OtherField":"value"}';
        String result3 = NEU_Utils.deserialize(input3);
    }
	
    @isTest
    static void test_getPicklistSimple() {
        // Caso 1: Campo no encontrado
        List<String> result1 = NEU_Utils.getPicklistSimple('Account', 'NonExistentField');
    
        // Caso 2: Objeto no encontrado
        List<String> result2 = NEU_Utils.getPicklistSimple('NonExistentObject', 'Industry');
    
        // Caso 3: Campo de tipo picklist encontrado
        List<String> result3 = NEU_Utils.getPicklistSimple('Account', 'Industry');
        // Caso 4: Campo no de tipo picklist
        List<String> result4 = NEU_Utils.getPicklistSimple('Account', 'Name');
    }
    
    @isTest
    static void test_getDependentPicklist() {
        // Caso 1: Objeto no existe
        Map<String, List<String>> result1 = NEU_Utils.getDependentPicklist('NoExiste', 'Industry', 'Type');
        // Caso 2: Campo(s) no existen
        Map<String, List<String>> result2 = NEU_Utils.getDependentPicklist('Account', 'Industry', 'NoExisteCampo');
        // Caso 3: Campos válidos pero sin dependencia real (simulado)
        Map<String, List<String>> result3 = NEU_Utils.getDependentPicklist('Account', 'Industry', 'Ownership');
    }


}