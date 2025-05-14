public class P2G_tiempoTranscurridoOppo {
    public static String etapa(Opportunity oportunidad){
        System.debug('Etapa para calcular el tiempo '+oportunidad.StageName);
        String tiempoTranscurrido;
        DateTime fechaActual = System.now();
        String etapa = oportunidad.StageName;
        DateTime fechaCreacion;
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
                Decimal multiplica = productos.UnitPrice * productos.Quantity;
                totalAceptado += multiplica;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && (sub.Status__c == 'Aceptada')){
                        Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * productos.Quantity;
                        totalAceptado += multiplicaSub;
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
                Decimal multiplica = productos.UnitPrice * productos.Quantity;
                cotizado += multiplica;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'Aceptada') || (sub.Status__c == 'Cotizada') || (sub.Status__c == 'Negociación con cliente') || (sub.Status__c == 'Rechazada'))){
                        Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * productos.Quantity;
                        cotizado += multiplicaSub;
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
                Decimal multiplica = productos.UnitPrice * productos.Quantity;
                amountOpportunity += multiplica;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'Aceptada') || (sub.Status__c == 'Cotizada') || (sub.Status__c == 'Negociación con cliente'))){
                        Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * productos.Quantity;
                        amountOpportunity += multiplicaSub;
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
                Decimal multiplica = productos.UnitPrice * productos.Quantity;
                rechazados += multiplica;
                for(SubProducto__c sub : todosSubproductos){
                    if((productos.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'No Cotizada') || (sub.Status__c == 'Rechazada'))){
                        Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * productos.Quantity;
                        rechazados += multiplicaSub;
                    }
                }
            }
        }
        return rechazados;
    }
    //Total Aceptado x producto
    public static Decimal totalAceptadaxProducto(OpportunityLineItem Product, List<SubProducto__c> todosSubproductos){
        Decimal totalAceptado = 0;
        if(product.Status__c == 'Aceptada'){
            Decimal multiplica = product.UnitPrice * product.Quantity;
            totalAceptado += multiplica;
            for(SubProducto__c sub : todosSubproductos){
                if((product.Id == sub.SubProduct_Opportunity_Product__c) && (sub.Status__c == 'Aceptada')){
                    Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * product.Quantity;
                    totalAceptado += multiplicaSub;
                }
            }
        }
        return totalAceptado;
    }
    //Total Cotizado x producto
    public static Decimal totalCotizadoxProducto(OpportunityLineItem Product, List<SubProducto__c> todosSubproductos){
        Decimal cotizado = 0;
        if((product.Status__c == 'Aceptada') || (product.Status__c == 'Cotizada') || (product.Status__c == 'Negociación con cliente') || (product.Status__c == 'Rechazada')){
            Decimal multiplica = product.UnitPrice * product.Quantity;
            cotizado += multiplica;
            for(SubProducto__c sub : todosSubproductos){
                if((product.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'Aceptada') || (sub.Status__c == 'Cotizada') || (sub.Status__c == 'Negociación con cliente') || (sub.Status__c == 'Rechazada'))){
                    Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * product.Quantity;
                    cotizado += multiplicaSub;
                }
            }
    	}
        return cotizado;
    }
    //Total Amount Opportunity x producto
    public static Decimal totalAmountOpportunityxProducto(OpportunityLineItem Product, List<SubProducto__c> todosSubproductos){
        Decimal amountOpportunity = 0;
        if((product.Status__c == 'Aceptada') || (product.Status__c == 'Cotizada') || (product.Status__c == 'Negociación con cliente')){
            Decimal multiplica = product.UnitPrice * product.Quantity;
            amountOpportunity += multiplica;
            for(SubProducto__c sub : todosSubproductos){
                if((product.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'Aceptada') || (sub.Status__c == 'Cotizada') || (sub.Status__c == 'Negociación con cliente'))){
                    Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * product.Quantity;
                    amountOpportunity += multiplicaSub;
                }
            }
        }
        return amountOpportunity;
    }
    //Total Rechazados x producto
    public static Decimal totalRechazadosxProducto(OpportunityLineItem Product, List<SubProducto__c> todosSubproductos){
        Decimal rechazados = 0;
        if((product.Status__c == 'No Cotizada') || (product.Status__c == 'Rechazada')){
            Decimal multiplica = product.UnitPrice * product.Quantity;
            rechazados += multiplica;
            for(SubProducto__c sub : todosSubproductos){
                if((product.Id == sub.SubProduct_Opportunity_Product__c) && ((sub.Status__c == 'No Cotizada') || (sub.Status__c == 'Rechazada'))){
                    Decimal multiplicaSub = sub.SubProduct_Sell_Price__c * product.Quantity;
                    rechazados += multiplicaSub;
                }
            }
        }
        return rechazados;
    }
    //multiplicar para anual
    public static Double multiplicacionAnual(Decimal totalProducto, String frecuencia){
        Double multiplica;
        switch on frecuencia {
            when 'Diario' {
                multiplica = totalProducto * 365;
            }   
            when 'Semanal' {
                multiplica = totalProducto * 53;
            }
            when 'Mensual' {
                multiplica = totalProducto * 12;
            }
            when 'Anual' {
                multiplica = totalProducto * 1;
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
    public static Opportunity sumaTotalesOportunidad(List<OpportunityLineItem> todosProductos, List<SubProducto__c> todosSubproductos, Opportunity op){
        Decimal totalAceptada = P2G_tiempoTranscurridoOppo.totalAceptada(todosProductos,todosSubproductos);
        Decimal totalCotizado = P2G_tiempoTranscurridoOppo.totalCotizado(todosProductos,todosSubproductos);
        Decimal totalAmountOpportunity = P2G_tiempoTranscurridoOppo.totalAmountOpportunity(todosProductos,todosSubproductos);
        Decimal totalRechazados = P2G_tiempoTranscurridoOppo.totalRechazados(todosProductos,todosSubproductos);
        Double totalAceptadaAnual = 0;
        Double totalCotizadoAnual = 0;
        Double totalAmountOpportunityAnual = 0;
        Double totalRechazadosAnual = 0;
        for(OpportunityLineItem oli : todosProductos){
            Decimal productoAceptada = 0;
            Decimal productoCotizado = 0;
            Decimal productoAmountOpportunity = 0;
            Decimal productoRechazados = 0;
            productoAceptada = totalAceptadaxProducto(oli,todosSubproductos);
            productoCotizado = totalCotizadoxProducto(oli,todosSubproductos);
            productoAmountOpportunity = totalAmountOpportunityxProducto(oli,todosSubproductos);
            productoRechazados = totalRechazadosxProducto(oli,todosSubproductos);
            if(oli.OpportunityId == op.Id){
                totalCotizadoAnual += multiplicacionAnual(productoCotizado, oli.PROJ_Frecuencia__c);
                totalAmountOpportunityAnual += multiplicacionAnual(productoAmountOpportunity, oli.PROJ_Frecuencia__c);
                totalRechazadosAnual += multiplicacionAnual(productoRechazados, oli.PROJ_Frecuencia__c);
                totalAceptadaAnual += multiplicacionAnual(productoAceptada, oli.PROJ_Frecuencia__c);
            }
        }
        System.debug('los totales son totalCotizado: '+totalCotizado+' totalAmountOpportunity: '+totalAmountOpportunity+
        ' totalRechazados: '+totalRechazados+' totalCotizadoAnual: '+totalCotizadoAnual+' totalAmountOpportunityAnual: '+
        totalAmountOpportunityAnual+' totalRechazadosAnual: '+totalRechazadosAnual);
        op.Total_Cerrado_Ganado__c = totalAceptada;
        op.Total_Cotizado__c = totalCotizado;
        op.Total_Opportunity__c = totalAmountOpportunity;
        op.Total_Amount_Rechazados__c = totalRechazados;
        op.Total_Cotizado_Anual__c = totalCotizadoAnual;
        op.Total_Opportunity_Anual__c = totalAmountOpportunityAnual;
        op.Total_Amount_Rechazados_Anual__c = totalRechazadosAnual;
        op.Total_Cerrado_Ganado_Anual__c = totalAceptadaAnual;
        
        return Op;
    }
}