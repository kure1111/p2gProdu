@isTest 
public class P2G_llamadoWebHelperTest {
    @isTest 
    static void testCallout() {
        P2G_llamadoWebHelper.setWebServiceUpdate(true);
        P2G_llamadoWebHelper.getWebServiceUpdate();
    }
}