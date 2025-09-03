@IsTest
public class P2G_DisponibilidadOfertadaTest {
    @IsTest(SeeAllData=true)
    public static void test(){
        P2G_DisponibilidadOfertada.WrapperDispo wraper = P2G_DisponibilidadOfertada.getWrapper();
        wraper.venta = '2';
        wraper.ticketPromedio = '3.5';
        wraper.route = 'a0E4T000000WPqBUAW';
        wraper.idRoute = 'a0E4T000000WPqBUAW';
        wraper.planner = '0054T0000025ew3QAA';
        wraper.idPlanner = '0054T0000025ew3QAA';
        wraper.noRutas = '6';
        wraper.kpiVigencia = '7';
        wraper.kpiAprobacion = '8';
        wraper.folio = '9';
        wraper.folioName = '10';
        wraper.fechaVigencia = (System.TODAY()-1)+'';
        wraper.curren = 'MXN';
        wraper.idContainerType = 'a0F4T000000R9qxUAC';
        wraper.carrier = '0014T000005QpduQAC';
        wraper.idCarrier = '0014T000005QpduQAC';
        wraper.searchValueIdLoad = 'a034T000004FHR9QAO';
        wraper.searchValueIdUnLoad = 'a034T00000C660iQAB';
        wraper.id = '12';
        wraper.bandera = '13';
        wraper.bgColor = '14';
        wraper.containerType = '15';
        wraper.fechaCreacion =  (System.TODAY()+1)+'';
        wraper.idUnidadPeso = '16';
        wraper.tomado = true;
        wraper.idAccount ='0014T000005QuaJQAS';
        
        List<P2G_DisponibilidadOfertada.WrapperDispo> lista = new List<P2G_DisponibilidadOfertada.WrapperDispo>();
        lista.add(wraper);
        
       	List<P2G_Disponibilidad__c> dispo = P2G_DisponibilidadOfertada.mapeoWrapper(lista);
        insert dispo;
        lista[0].Id = dispo[0].Id;
        P2G_DisponibilidadOfertada.rutasVencidas(lista);
        
        P2G_Disponibilidad__c dis = P2G_DisponibilidadOfertada.crearDisponibilidad(wraper);
        
        P2G_DisponibilidadOfertada.createRuta( 'a034T000004FHnVQAW','a034T000004FHnVQAW');
        List<P2G_DisponibilidadOfertada.WrapperDispo> obtener = P2G_DisponibilidadOfertada.obtenerDisponibilidades(1);
        List<P2G_DisponibilidadOfertada.WrapperDispo> obtener2 = P2G_DisponibilidadOfertada.obtenerDisponibilidades(2);
        P2G_DisponibilidadOfertada.aproba();
    }
    
}