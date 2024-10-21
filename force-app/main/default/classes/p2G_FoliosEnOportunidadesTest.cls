@isTest(SeeAllData=true)
public class p2G_FoliosEnOportunidadesTest {
	@isTest
    public static void prueba(){
        NEU_StaticVariableHelper.setBoolean1(true);
        OpportunityLineItem oli = [SELECT OpportunityId , PROJ_Modalidad__c FROM OpportunityLineItem 
                                   WHERE OpportunityId != null AND Opportunity.Total_IEQO_Creados__c > 0
                                   LIMIT 1];
        System.debug('OpportunityLineItem: ' + oli);
        List<Customer_Quote__c> getIEQO = p2G_FoliosEnOportunidades.getIEQO(oli.OpportunityId,'FN-');
        String asignar = p2G_FoliosEnOportunidades.asignarFolio(oli.OpportunityId,getIEQO[0].Id);
        List<p2G_FoliosEnOportunidades.wrapperProduct> lista = p2G_FoliosEnOportunidades.getRoute(oli.OpportunityId);
        List<p2G_FoliosEnOportunidades.wrapperProduct> listaCrear = new List<p2G_FoliosEnOportunidades.wrapperProduct>();
        listaCrear.add(lista[0]);
        String ss = p2G_FoliosEnOportunidades.foliosACrear(listaCrear);
        List<Customer_Quote__c> listaIEQ = [SELECT Id,Name,Opportunity__c FROM Customer_Quote__c limit 1];
        p2G_FoliosEnOportunidades.enviarCorreo(listaIEQ,'pruebita');
        p2G_FoliosEnOportunidades.asignarFolio(oli.Id,listaIEQ[0].Id);
        List<p2G_FoliosEnOportunidades.wrapperProduct> wrapper = p2G_FoliosEnOportunidades.getWrapper();
        p2G_FoliosEnOportunidades.crearFoliosFuturo(lista);
        lista[0].grupo ='SP-FI-FLETE INTER';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-A-AEREO';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-CE-COMERCIO EXT';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-M-MARITIMO';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-PTO-PUERTOS';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-R-GLOBAL ROUTING';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-EX-SEGUROS';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-PQ-PAQUETERIA';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-WH-ALMACENAJE';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        lista[0].grupo ='SP-T-CONSOLIDADO';
        p2G_FoliosEnOportunidades.grupo(lista[0]);
        
    }
}