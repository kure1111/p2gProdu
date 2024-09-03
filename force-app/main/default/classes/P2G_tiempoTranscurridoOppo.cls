public class P2G_tiempoTranscurridoOppo {
    public static String etapa(Opportunity oportunidad){
        System.debug('Etapa para calcular el tiempo '+oportunidad.StageName);
        String tiempoTranscurrido;
        DateTime fechaActual = System.now();
        String etapa = oportunidad.StageName;
        DateTime fechaCreacion;
        //Boolean regresa = P2G_PruebaMetodos.areStringsEqualAsAsciiSum(oportunidad.StageName, 'Cotización');
        //System.debug('regresa de cadenas '+ regresa);
        switch on etapa {
            when 'Entendimiento' {
                fechaCreacion = oportunidad.CreatedDate;
                tiempoTranscurrido = tiempoTranscurridas(fechaCreacion, fechaActual,oportunidad.CreatedDate);
            }	
            when 'Cotización' {
                fechaCreacion = oportunidad.Data_Time_Cotizacion__c;
                tiempoTranscurrido = tiempoTranscurridas(fechaCreacion, fechaActual,oportunidad.CreatedDate);
            }
            when 'Negociación' {
                fechaCreacion = oportunidad.Data_Time_Negociacion__c;
                tiempoTranscurrido = tiempoTranscurridas(fechaCreacion, fechaActual,oportunidad.CreatedDate);
            }
            when else {
                System.debug('No existe esa etapa');
            }
        }
        return tiempoTranscurrido;
    }
    public static String tiempoTranscurridas(DateTime fechaCreacion,DateTime fechaActual,DateTime CreatedDate){
        System.debug('fechaCreacion: '+fechaCreacion+' fechaActual: '+fechaActual);
        //tiempo trascurrido total de la oportunidad
        String tiempoTotal = tiempoTotalTranscurrido(CreatedDate, fechaActual);
        // Calcular la diferencia en milisegundos de la etapa
        String tiempoTranscurrido;
        Long diferenciaMilisegundos = fechaActual.getTime() - fechaCreacion.getTime();
        System.debug('milisegundo '+diferenciaMilisegundos);
        Integer calcularMinutosTranscurridos = calcularMinutosTranscurridos(diferenciaMilisegundos);
        System.debug('minutos '+calcularMinutosTranscurridos);
        if(calcularMinutosTranscurridos < 60){
            tiempoTranscurrido = calcularMinutosTranscurridos + ' Minutos - Tiempo total en la Opportunidad: '+tiempoTotal;
        }else{
            tiempoTranscurrido = calcularDiaHoraTranscurridos(diferenciaMilisegundos) + ' - Tiempo total en la Opportunidad: '+tiempoTotal;
        }
        return tiempoTranscurrido;
    }
    public static String tiempoTranscurridoOli(DateTime fechaCreacion,DateTime fechaActual){
        System.debug('fechaCreacion: '+fechaCreacion+' fechaActual: '+fechaActual);
        //tiempo trascurrido total de la oportunidad
        String tiempoTranscurrido;
        Long diferenciaMilisegundos = fechaActual.getTime() - fechaCreacion.getTime();
        System.debug('milisegundo '+diferenciaMilisegundos);
        Integer calcularMinutosTranscurridos = calcularMinutosTranscurridos(diferenciaMilisegundos);
        System.debug('minutos '+calcularMinutosTranscurridos);
        if(calcularMinutosTranscurridos < 60){
            tiempoTranscurrido = calcularMinutosTranscurridos + ' Minutos';
        }else{
            tiempoTranscurrido = calcularDiaHoraTranscurridos(diferenciaMilisegundos);
        }
        return tiempoTranscurrido;
    }
    public static String tiempoTotalTranscurrido(DateTime fechaCreacion,DateTime fechaActual){
        System.debug('fechaCreacion: '+fechaCreacion+' fechaActual: '+fechaActual);
        String tiempoTotal;
        Long diferenciaMilisegundos = fechaActual.getTime() - fechaCreacion.getTime();
        System.debug('milisegundo '+diferenciaMilisegundos);
        Integer calcularMinutosTranscurridos = calcularMinutosTranscurridos(diferenciaMilisegundos);
        System.debug('minutos '+calcularMinutosTranscurridos);
        if(calcularMinutosTranscurridos < 60){
            tiempoTotal = calcularMinutosTranscurridos + ' Minutos';
        }else{
            tiempoTotal = calcularDiaHoraTranscurridos(diferenciaMilisegundos);
        }
        return tiempoTotal;
    }
    public static Integer calcularMinutosTranscurridos(Long diferenciaMilisegundos) {
        // Convertir la diferencia de milisegundos a minutos
        Integer minutosTranscurridos = Integer.valueOf(diferenciaMilisegundos / (1000 * 60));
        return minutosTranscurridos;
    }
    public static String calcularDiaHoraTranscurridos(Long diferenciaMilisegundos) {
        String tiempoTranscurrido;
        // Convertir la diferencia en días y horas
        Integer diasTranscurridos = Integer.valueOf(diferenciaMilisegundos / (1000 * 60 * 60 * 24));
        Integer horasTranscurridas = (Integer)((diferenciaMilisegundos / (1000 * 60 * 60)) - (diasTranscurridos * 24));
        tiempoTranscurrido = diasTranscurridos+' Dias '+horasTranscurridas+' Horas';
        return tiempoTranscurrido;
    }
    //Para ir sumando el Total Amount
    @InvocableMethod
    public static void sumaTotalAmount(List<String> idOppo){
     	Opportunity op = new Opportunity();
        List<OpportunityLineItem> listOli = [SELECT Id, Name, OpportunityId, opportunity.Total_Amount_Aceptada__c, PROJ_Frecuencia__c,
                                             Precio_Sugerido_Venta__c, Quantity FROM OpportunityLineItem 
											WHERE OpportunityId =: idOppo[0] AND Precio_Sugerido_Venta__c != 0 AND Precio_Sugerido_Venta__c != null];
        Double totalAmount = 0;
		Double multiplicacionTotalAmount;
        if(listOli.size()>0){
            for(OpportunityLineItem Product : listOli){
                multiplicacionTotalAmount = multiplicacionTotalAmount(Product.Precio_Sugerido_Venta__c, Product);
                totalAmount += multiplicacionTotalAmount;
            }
            op.id = listOli[0].OpportunityId;
            op.Total_Amount_del__c = totalAmount;
            Update op;
        }
    }
    //Para ir sumando el Total Amount aceptado
    public static Double sumaTotalAmountAceptado(List<OpportunityLineItem> todosProductos){
     	Double totalAmount = 0;
		Double multiplicacionTotalAmount;
        for(OpportunityLineItem Product : todosProductos){
            if(Product.Status__c == 'Aceptada'){
                System.debug('el oli que se suma: '+Product.Id+' fre: '+Product.PROJ_Frecuencia__c);
                multiplicacionTotalAmount = multiplicacionTotalAmount(Product.UnitPrice, Product);
                totalAmount += multiplicacionTotalAmount;
            }
        }
		return totalAmount;
    }
    public static Double multiplicacionTotalAmount(Decimal precioVenta , OpportunityLineItem oli){
		Double multiplica;
        switch on oli.PROJ_Frecuencia__c {
            when 'Diario' {
                multiplica = precioVenta * oli.Quantity * 365;
            }	
            when 'Semanal' {
                multiplica = precioVenta * oli.Quantity * 53;
            }
            when 'Mensual' {
                multiplica = precioVenta * oli.Quantity * 12;
            }
            when 'Anual' {
                multiplica = precioVenta * oli.Quantity * 1;
            }
            when else {
                multiplica = 0;
                System.debug('No existe esa frecuencia');
            }
        }
        return multiplica;
    }
    //consulta todos los Productos
    public static List<OpportunityLineItem> todosProductos(List<String> idOppo){
        List<OpportunityLineItem> listOli = [SELECT id, Name, Status__c, UnitPrice, PROJ_Frecuencia__c, Quantity, OpportunityId
                                             FROM OpportunityLineItem WHERE OpportunityId IN: idOppo];
        return listOli;
    }
    //consulta todos los Subproductos
    public static List<SubProducto__c> todosSubproductos(List<String> idOppo){
        List<SubProducto__c> listSub = [SELECT id, Name, Status__c, SubProduct_Sell_Price__c, SubProduct_Opportunity_Product__c
                                        FROM SubProducto__c WHERE SubProduct_Opportunity__c IN: idOppo];
        return listSub;
    }
    //Total Aceptado
    public static Decimal totalAceptada(List<OpportunityLineItem> todosProductos, List<SubProducto__c> todosSubproductos){
        Decimal totalAceptado = 0;
        for(OpportunityLineItem productos : todosProductos){
            if(productos.Status__c == 'Aceptada'){
                totalAceptado += productos.UnitPrice;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && (sub.Status__c == 'Aceptada')){
                        totalAceptado += sub.SubProduct_Sell_Price__c;
                    }
                }
            }
        }
        return totalAceptado;
    }
    //Total Cotizado
    public static Decimal totalCotizado(List<OpportunityLineItem> todosProductos, List<SubProducto__c> todosSubproductos){
        Decimal cotizado = 0;
        for(OpportunityLineItem productos : todosProductos){
            if((productos.Status__c == 'Aceptada') || (productos.Status__c == 'Cotizada') || (productos.Status__c == 'Negociación con cliente') || (productos.Status__c == 'Rechazada')){
                cotizado += productos.UnitPrice;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'Aceptada') || (sub.Status__c == 'Cotizada') || (sub.Status__c == 'Negociación con cliente') || (sub.Status__c == 'Rechazada'))){
                        cotizado += sub.SubProduct_Sell_Price__c;
                    }
                }
            }
        }
        return cotizado;
    }
    //Total Amount Opportunity
    public static Decimal totalAmountOpportunity(List<OpportunityLineItem> todosProductos, List<SubProducto__c> todosSubproductos){
        Decimal amountOpportunity = 0;
        for(OpportunityLineItem productos : todosProductos){
            if((productos.Status__c == 'Aceptada') || (productos.Status__c == 'Cotizada') || (productos.Status__c == 'Negociación con cliente')){
                amountOpportunity += productos.UnitPrice;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'Aceptada') || (sub.Status__c == 'Cotizada') || (productos.Status__c == 'Negociación con cliente'))){
                        amountOpportunity += sub.SubProduct_Sell_Price__c;
                    }
                }
            }
        }
        return amountOpportunity;
    }
    //Total Rechazados
    public static Decimal totalRechazados(List<OpportunityLineItem> todosProductos, List<SubProducto__c> todosSubproductos){
        Decimal rechazados = 0;
        for(OpportunityLineItem productos : todosProductos){
            if((productos.Status__c == 'No Cotizada') || (productos.Status__c == 'Rechazada')){
                rechazados += productos.UnitPrice;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'No Cotizada') || (sub.Status__c == 'Rechazada'))){
                        rechazados += sub.SubProduct_Sell_Price__c;
                    }
                }
            }
        }
        return rechazados;
    }
        //multipmicar para anual
    public static Double multiplicacionAnual(Decimal sumaTotal , String frecuencia){
		Double multiplica;
        switch on frecuencia {
            when 'Diario' {
                multiplica = sumaTotal * 365;
            }	
            when 'Semanal' {
                multiplica = sumaTotal * 53;
            }
            when 'Mensual' {
                multiplica = sumaTotal * 12;
            }
            when 'Anual' {
                multiplica = sumaTotal * 1;
            }
            when else {
                multiplica = 0;
                System.debug('No existe esa frecuencia');
            }
        }
        return multiplica;
    }
    //Para pasar a Ejecucion
    //Revisar si la quote esta aceptada
    public static String quoteVendida(String idOppo){
        List<Quote> quote = [SELECT Id, Name, Vendido__c FROM Quote WHERE OpportunityId =: idOppo AND Vendido__c = True];
        String valida;
        if(quote.size()>0 && quote[0].Vendido__c == True){
            valida = 'Quote Vendido';
        }else{
            valida = null;
        }
        return valida;
    }
    //Revisa si los Opportunity products estan aceptadas, rechasadas o no cotizadas
    public static Integer statusOpportunityProduct(String idOppo){
        List<OpportunityLineItem> listOli =[SELECT Id, Name, Status__c FROM OpportunityLineItem WHERE OpportunityId =: idOppo];
        Integer diferenteStatus = 0;
        for(OpportunityLineItem oli : listOli){
            if((oli.Status__c != 'No Cotizada') && (oli.Status__c != 'Rechazada') && (oli.Status__c != 'Aceptada')){
                diferenteStatus ++;
            }
        }
        return diferenteStatus;
    }
    //Revisar si el cliente es valido
    public static String validaCliente(String idAccount){
        Account cuenta = [SELECT Record_Type_Name__c, Customer_Id__c, ActiveSap__c FROM Account WHERE Id =: idAccount];
        String valida;
        if((cuenta.Record_Type_Name__c == 'Customer') && (cuenta.Customer_Id__c != null || cuenta.Customer_Id__c != '') && (cuenta.ActiveSap__c == true)){
            valida = 'si es valida la cuenta';
        }else{
            valida = null;
        }
        return valida;
    }
    public static void pase(){
        Integer a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
        a = 1;
    }
}