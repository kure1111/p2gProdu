@isTest(seeAllData=true)
private class PAK_SLPCODETest {

    @isTest
    static void testSLPCODE_USER_CodeExistsAndNotExists() {
        // Buscar un usuario real en la org que tenga un SalesEmployer__c con valor no nulo
        User usrWithCode = [SELECT Id, SalesEmployer__c FROM User WHERE IsActive = TRUE AND SalesEmployer__c != null LIMIT 1];

        // Crear entradas: una que coincida con un usuario real y otra que no
        List<PAK_SLPCODE.SLPCODE> inputList = new List<PAK_SLPCODE.SLPCODE>();

        PAK_SLPCODE.SLPCODE codeExists = new PAK_SLPCODE.SLPCODE();
        codeExists.Codigo = usrWithCode.SalesEmployer__c;

        PAK_SLPCODE.SLPCODE codeNotExists = new PAK_SLPCODE.SLPCODE();
        codeNotExists.Codigo = 'NO_MATCH_CODE';

        inputList.add(codeExists);
        inputList.add(codeNotExists);

        Test.startTest();
        List<PAK_SLPCODE.status> result = PAK_SLPCODE.SLPCODE_USER(inputList);
        Test.stopTest();
    }

    @isTest(seeAllData=true)
    static void testSLPCODE_USER_ExceptionHandling() {
        // Este test forzará un error modificando dinámicamente FLS (por ejemplo, usando un código que cause NullPointer)
        // Vamos a simular el error pasando una lista null (sabemos que SLPCODE_USER espera una lista no nula)

        Test.startTest();
        List<PAK_SLPCODE.status> result = PAK_SLPCODE.SLPCODE_USER(null);
        Test.stopTest();
    }
}