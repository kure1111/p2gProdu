@IsTest
public class P2G_AccountAddressTest {
    @IsTest(SeeAllData=true)
    public static void test(){
        List<String> lista = new List<String>();
        lista.add('mexico');
        lista.add('Nuevo León');
        lista.add('Nuevo León');
        lista.add('Monterrey');
        lista.add('Industrial');
        lista.add('Calle Miguel Barragán');
        lista.add('609');
        lista.add('64440');
        lista.add('Nobre');
        lista.add('direcionn');
        lista.add('25.726856099763733');
        lista.add('-100.32075821083983');
        P2G_AccountAddress.createAddress(lista);
        String id = P2G_AccountAddress.createAddressD(lista);
        lista.add(id);
        P2G_AccountAddress.getAddress('CHAPALA GDL');
        P2G_AccountAddress.getCP('45672'); 
        P2G_AccountAddress.getMapMarkers('45672');
        P2G_AccountAddress.getMapMarkersByName('CHAPALA GDL');
        P2G_AccountAddress.getResume(id);
        P2G_AccountAddress.getDuplicates('6350','El Zapote Del Valle');

        String id2 = P2G_AccountAddress.addressEdit(lista);
        
    }

}