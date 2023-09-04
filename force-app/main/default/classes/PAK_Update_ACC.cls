global class PAK_Update_ACC {
    global class UAccount{
        webservice String idSFField {get;set;}
        webservice String Customer_id {get;set;}
        webservice String Status_Account {get;set;}
        webservice String Name {get;set;}
        webservice String Brand_Name {get;set;}
        webservice String Tax_id {get;set;}
        webservice String Phone {get;set;}
        webservice String Email {get;set;}
        webservice String Tipo_de_pago {get;set;}
        webservice String Forma_de_pago {get;set;}
        webservice String Credits_terms {get;set;}
        webservice String Acuse {get;set;}
        webservice String ReqOrdenCompra {get;set;}
        webservice String SalesEmployer {get;set;}
        webservice String Credit_Limit {get;set;}
        webservice String Direccion {get;set;} 
        webservice String Anticipo {get;set;} // valores SI y No.
        webservice String Authorized_credit {get;set;} // Valores 1 y 0.
        webservice String Tipo_Acuse {get;set;} // valores Si , No y Asignar.
        webservice String Venta {get;set;}// valores Si , No y Asignar.
        webservice String RecordType {get;set;} // valores CLIENTE Y PROVEEDOR
        webservice String Source_Account {get;set;}
        webservice String UserNameSAP {get;set;}
        webservice String MotivoInactivo {get;set;}
        webservice String CodigoPostal {get;set;}
        webservice String Ciudad {get;set;}
        webservice String Estado {get;set;}
        webservice String Pais {get;set;}
        webservice String Street {get;set;}
        webservice String SolicitadoPor {get;set;}
        webservice String CarrierEmail {get;set;}
        webservice String WorkPlace {get;set;}
        webservice String Banco {get;set;}
        webservice String Clabe {get;set;}
        webservice String PaisBanco {get;set;}
        webservice String BancoSup {get;set;}
        webservice String CuentaBanco {get;set;}
        webservice String Comentarios {get;set;}
        webservice String Unidades {get;set;}
        webservice String GrupoSap {get;set;}
        webservice String CuentaEspejo {get;set;}
        webservice String Gps {get;set;}
        webservice String Vetado {get;set;}
        webservice String ReportaVetado {get;set;}
        webservice String Estatus {get;set;}  
        webservice String currencyIsoCode {get;set;}
    }
    
    global class CANCEL_INV{
        webservice String IdInovice {get;set;}//Id
        Webservice String Cancel {get;set;}//CANCELAR
        webservice String Tipo {get;set;}//NOTA-PEDIDO
    }
    
    global class TOTAL_FACT{
        webservice String IdInovice {get;set;}//Id
        Webservice String TotalFacturado {get;set;}//MONTO DE FACTURA
        webservice String Tipo {get;set;}//NOTA-PEDIDO
        webservice String FechaFactura {get;set;}
        webservice String UI {get;set;}
    }
    
    global class NOTA_CREDITO{
        webservice String Plaza {get;set;}
        Webservice String Customer_Id {get;set;}
        webservice String NombreCliente {get;set;}
        webservice String NombreVendedor {get;set;}
        webservice String ImporteTotal {get;set;}
        webservice String Motivo {get;set;}
        webservice String NumeroFactura {get;set;}
        webservice String NumeroCredito {get;set;}
        webservice String IdInovice {get;set;}
    }
}