@IsTest
public class P2G_reenvioCartaPorteTest {
    	@IsTest(SeeAllData=true)
        public static void test(){
            List<Id> shipmentIds = new List<Id>();
            shipmentIds.add('a0JRQ0000001YfZ2AU');
            P2G_reenvioCartaPorte.callSavePdf(shipmentIds);
                        

    }
}