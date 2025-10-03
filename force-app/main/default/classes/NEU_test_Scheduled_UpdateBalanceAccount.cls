@isTest(seeAllData=true)
private class NEU_test_Scheduled_UpdateBalanceAccount {

    static testMethod void NEU_Schedule_UpdateBalanceAccount() {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        // Probar programación del job
        NEU_Schedule_UpdateBalanceAccount scheduler = new NEU_Schedule_UpdateBalanceAccount();
        Id jobId = System.schedule('test', '0 0 0 30 12 ? 2099', scheduler);
    }

    static testMethod void NEU_UpdateBalanceAccount() {
        NEU_StaticVariableHelper.setBoolean1(true);

        // Usar cuentas reales
        List<Account> existingAccounts = [SELECT Id FROM Account WHERE Total_Collection_Outstanding_Balance__c != null OR Name != null LIMIT 5];

        // Ejecutar el método real con datos reales
        Test.startTest();
        NEU_UpdateBalanceAccount.update_data();

        // Validación opcional: Verificar si alguna cuenta tiene saldos actualizados
        List<Account> updatedAccounts = [
            SELECT Id, Total_Collection_Outstanding_Balance__c, Late_Outstanding_Payments__c 
            FROM Account 
            WHERE Total_Collection_Outstanding_Balance__c != null OR Late_Outstanding_Payments__c != null 
            LIMIT 5
        ];

        NEU_UpdateBalanceAccount.sendMail('Prueba de error');
        Test.stopTest();
    }
}