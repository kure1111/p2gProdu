@isTest
public class P2G_NEU_TaskUtilisTest {
	@isTest
    static void newTaskRelationTest(){
        
    }
    @isTest
    static void testNewTaskRelation_Success() {
        // Crear datos de prueba
        Account accTest=new Account();
        accTest.Name='TESTCustomer';
        accTest.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //Prod
        accTest.OwnerId='0054T0000025ew3QAA';
        //UAT
        //accTest.OwnerId='005DV00000EDOsaYAH';
        insert accTest;
        
        Task testTask = new Task(
            Subject = 'Test Task',
            ActivityDate = Date.today(),
            WhatId = accTest.Id
        );
        insert testTask;
                
        Test.startTest();
        SObject result = NEU_TaskUtils.newTaskRelation(testTask.Id, true, accTest.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testWithTaskRelation_True() {
        // Ejecutar método bajo prueba
        Test.startTest();
        Boolean result = NEU_TaskUtils.withTaskRelation();
        Test.stopTest();
        
    }
}