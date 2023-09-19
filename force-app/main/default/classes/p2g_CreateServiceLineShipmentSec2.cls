public class p2g_CreateServiceLineShipmentSec2 {
	@AuraEnabled
    public static List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> CrearLineQuote(String line, Integer numLinea){
        System.debug('Json que llego: '+ numLinea);
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> listWrapper = P2G_UpdateShipmentServiceLine.CrearListaWrapper(line,numLinea);
        System.debug('La line wrapper: '+ listWrapper);
        //calcular nombre de linea
        Integer NameLine = p2g_CreateServiceLineShipment.CalculoNombreLine(listWrapper[0].ShipmentId);
        List<Fee__c> listaFee = new List<Fee__c>();
        List<Shipment_Fee_Line__c> listaFeeLine = new List<Shipment_Fee_Line__c>();
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> listaRespuesta =new List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper>();
        String message;
        p2g_CreateServiceLineQuote.quoteFeeLineWrapper nuevalinea = new p2g_CreateServiceLineQuote.quoteFeeLineWrapper();
        try{
            System.debug('Entra al try');
            for(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper: listWrapper){
                //Modificar campo devolucion
                Fee__c updateRate = p2g_CreateServiceLineShipment.updateRate(wrapper);
                listaFee.add(updateRate);
                //Crear Lista Service linea
                Shipment_Fee_Line__c feeLine = p2g_CreateServiceLineShipment.CreateServiceLine(NameLine,wrapper);
                feeLine.Es_de_IEQ__c = true; // viene de cotizacion
                listaFeeLine.add(feeLine); //Guardar en lista
                NameLine++;
                system.debug('set: '+listaFee);
                system.debug('line: '+listaFeeLine+' name: '+NameLine);
            }
            //modifucar Rate
            system.debug('fee: '+listaFee);
            Update listaFee;
            //Crear service Line
            System.debug('la lista a modificar de Service Line es: '+listaFeeLine);
            insert listaFeeLine;
            Integer posicion=0;
            for(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper: listWrapper){
                wrapper.Id = listaFeeLine[posicion].Id;
                wrapper.Name = listaFeeLine[posicion].Name;
                nuevalinea = p2g_CreateServiceLineQuote.rellenaSeccion(wrapper);
                listaRespuesta.add(nuevalinea);
                posicion++;
            }
            message='Se realizo la inserción exitosamente';
        }catch(Exception e){
            System.debug('Entra al catch');
            listaRespuesta = null;
            message='Error al realizar la inserción: '+e.getMessage()+e.getLineNumber();
            System.debug('Error al realizar la modificacion: '+e.getMessage()+e.getLineNumber());
        }
        System.debug('lo que devuelve es: '+nuevalinea);
        return listaRespuesta;
    }
}