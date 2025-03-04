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
@isTest(SeeAllData=true)
private class NEU_test_Minuta {
    @isTest
    public static void test(){
        Event event = [SELECT Id, StartDateTime, Who.Name, Who.Title, EndDateTime,Temas_Pendientes__c, Location, Objetivo__c,
                       Owner.Name, Subject, Comments_Pric__c, Proxima_Reunion__c, Motivo_Minuta__c, TipoMeeting__c, WhatId, WhoId
				 		FROM Event LIMIT 1];
        NEU_GenerateMinuta gm = new NEU_GenerateMinuta(new ApexPages.StandardController(event));
        Event getEvent = NEU_GenerateMinuta.getEvent(event.id);
        List<Contact> getContact = NEU_GenerateMinuta.getContact('Maria');
        String generaPDF = NEU_GenerateMinuta.generaPDF(event, 'Mensual', '2024-10-29T20:27:00.000Z', '2024-10-29T20:27:00.000Z');
        Event nuevoEvento = NEU_GenerateMinuta.nuevoEvento(event, 'Mensual', '2024-10-29T20:27:00.000Z', '2024-10-29T20:27:00.000Z');
        Event updateEvent = NEU_GenerateMinuta.updateEvent(event, '2024-10-29T20:27:00.000Z',event.id);
        DateTime acomodoFechaHora = NEU_GenerateMinuta.acomodoFechaHora('2024-10-29T20:27:00.000Z');
    }
}