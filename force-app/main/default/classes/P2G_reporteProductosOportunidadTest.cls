@isTest(SeeAllData=true)
public class P2G_reporteProductosOportunidadTest {
    @isTest
    public static void test(){
        List<OpportunityLineItem> getProducts = P2G_reporteProductosOportunidad.getProducts();
        List<Subproducto__c> getSubProductos = P2G_reporteProductosOportunidad.getSubProductos();
        List<P2G_reporteProductosOportunidad.ComboboxOption> getAccountOptions = P2G_reporteProductosOportunidad.getAccountOptions();
        List<P2G_reporteProductosOportunidad.ComboboxOption> getOwnerOppoOptions = P2G_reporteProductosOportunidad.getOwnerOppoOptions();
        List<P2G_reporteProductosOportunidad.ComboboxOption> getIcOptions = P2G_reporteProductosOportunidad.getIcOptions();
        List<OpportunityLineItem> buscaProductosPendientes = P2G_reporteProductosOportunidad.buscaProductosPendientes('Pendiente por cotizar', 'SP-FN-FLETE NACIONAL', getProducts[0].Opportunity.AccountId, getProducts[0].Opportunity.OwnerId, getProducts[0].Opportunity.Usuario_IC__c);
        List<Subproducto__c> buscaSubProductosPendientes = P2G_reporteProductosOportunidad.buscaSubProductosPendientes('Pendiente por cotizar','SP-FN-FLETE NACIONAL', getProducts[0].Opportunity.AccountId, getProducts[0].Opportunity.OwnerId, getProducts[0].Opportunity.Usuario_IC__c);
        List<OpportunityLineItem> buscaProductosCotizados = P2G_reporteProductosOportunidad.buscaProductosCotizados('Cotizada', 'SP-FN-FLETE NACIONAL', getProducts[0].Opportunity.AccountId, getProducts[0].Opportunity.OwnerId, getProducts[0].Opportunity.Usuario_IC__c);
        List<Subproducto__c> buscaSubProductosCotizados = P2G_reporteProductosOportunidad.buscaSubProductosCotizados('Cotizada', 'SP-FN-FLETE NACIONAL', getProducts[0].Opportunity.AccountId, getProducts[0].Opportunity.OwnerId, getProducts[0].Opportunity.Usuario_IC__c);
        List<OpportunityLineItem> buscaProductosAceptados = P2G_reporteProductosOportunidad.buscaProductosAceptados('Aceptada', 'SP-FN-FLETE NACIONAL', getProducts[0].Opportunity.AccountId, getProducts[0].Opportunity.OwnerId, getProducts[0].Opportunity.Usuario_IC__c);
        List<Subproducto__c> buscaSubProductosAceptados = P2G_reporteProductosOportunidad.buscaSubProductosAceptados('Aceptada', 'SP-FN-FLETE NACIONAL', getProducts[0].Opportunity.AccountId, getProducts[0].Opportunity.OwnerId, getProducts[0].Opportunity.Usuario_IC__c);
        List<p2G_FoliosEnOportunidades.wrapperProduct> getProductsAceptados = P2G_reporteProductosOportunidad.getProductsAceptados();
        List<Account> getAccountAceptados = P2G_reporteProductosOportunidad.getAccountAceptados('Cliente');
        List<p2G_FoliosEnOportunidades.wrapperProduct> getProductsEnCuentas = P2G_reporteProductosOportunidad.getProductsEnCuentas(getAccountAceptados[0].Id,'SP-FN-FLETE NACIONAL');
        List<Import_Export_Fee_Line__c> getServiceLineIEQO = P2G_reporteProductosOportunidad.getServiceLineIEQO();
        List<Import_Export_Fee_Line__c> buscaIEQOPendientes = P2G_reporteProductosOportunidad.buscaIEQOPendientes('Awaiting costs suppliers','FN', getServiceLineIEQO[0].Import_Export_Quote__r.Account_for__c, getServiceLineIEQO[0].Import_Export_Quote__r.CreatedById, getServiceLineIEQO[0].Import_Export_Quote__r.Pricing_Executive__c);
        list<User> getUser = P2G_reporteProductosOportunidad.getUser('Mar');
    }

}