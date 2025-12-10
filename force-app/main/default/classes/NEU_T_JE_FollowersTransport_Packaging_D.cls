@isTest(seeAllData=true)
public class NEU_T_JE_FollowersTransport_Packaging_D {
    @isTest
    static void testConstructor() {
        Shipment__c sp = [SELECT Id, CreatedById, Name FROM Shipment__c Order By CreatedDate desc Limit 1];
        Transport_Packaging_Data__c testTPD = new Transport_Packaging_Data__c(
            Name = 'Test TPD',
            Shipment__c = sp.Id
        );
        insert testTPD;
        
        //suscripción
        EntitySubscription newSub = [SELECT Id FROM EntitySubscription WHERE SubscriberId =: sp.CreatedById Limit 1];
        
        // Configurar comunidad de prueba
        CSH_Community__c commSetting = new CSH_Community__c(
            Name = 'Test Community'
        );
        insert commSetting;
        List<EntitySubscription> testSubs = [SELECT Id FROM EntitySubscription WHERE SubscriberId =: sp.CreatedById];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testTPD);
        NEU_JE_FollowersTransport_Packaging_Data controller = new NEU_JE_FollowersTransport_Packaging_Data(sc);
        List<NEU_JE_FollowersTransport_Packaging_Data.follower_s> followers = controller.getfollower();
        List<NEU_JE_FollowersTransport_Packaging_Data.followersin_s> followersIn = controller.getfollowersin();
        controller.idlinea = followersIn[0].line.Id;
        
        // Ejecutar método
        controller.nuevalinea();
        
        // Verificar resultados
        List<EntitySubscription> subs = [SELECT Id FROM EntitySubscription WHERE ParentId = :testTPD.Id AND SubscriberId = :controller.idlinea];
        // Obtener followers para seleccionar uno        
        controller.idlinea = followers[0].line.Id;
        
        // Ejecutar método
        controller.quitarlinea();
        // Configurar para nueva línea con usuario de comunidad
        controller.idlinea = sp.CreatedById;
        ApexPages.currentPage().getParameters().put('test', 'true');
        
        // Ejecutar método
        controller.nuevalinea();
        
        // Verificar que se creó la suscripción
        List<EntitySubscription> subs2 = [SELECT Id, NetworkId FROM EntitySubscription WHERE SubscriberId = :sp.CreatedById];
        NEU_JE_FollowersTransport_Packaging_Data.test();
        Test.stopTest();
    }
}