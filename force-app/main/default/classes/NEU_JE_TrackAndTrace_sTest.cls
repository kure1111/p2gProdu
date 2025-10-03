@isTest
private class NEU_JE_TrackAndTrace_sTest {
    
    @isTest
    static void testCompareToLogic() {
        // Fechas en formato ISO 8601 (yyyy-MM-dd'T'HH:mm)
        String futureDate = System.now().addDays(5).formatGmt('yyyy-MM-dd\'T\'HH:mm');
        String pastDate = System.now().addDays(-5).formatGmt('yyyy-MM-dd\'T\'HH:mm');

        // Instancias con fechas diferentes
        NEU_JE_TrackAndTrace_s futureItem = new NEU_JE_TrackAndTrace_s(
            'ATAPOD1', 'Activity1', 'A1', 'BL1', 'B1', '100', 'CONT1', '20GP',
            futureDate, 'ETA1', 'ETD1', 'FD1', 'FDC1', '1234567', 'LOC1', 'LC1', 'OP1',
            'OR1', 'OC1', 'POD1', 'PDC1', 'POL1', 'PLC1', 'SCAC1', 'SERVICE1', 'SRC1', 
            'VESSEL1', 'VOY1', '1000', 'A'
        );

        NEU_JE_TrackAndTrace_s pastItem = new NEU_JE_TrackAndTrace_s(
            'ATAPOD2', 'Activity2', 'A2', 'BL2', 'B2', '200', 'CONT2', '40HC',
            pastDate, 'ETA2', 'ETD2', 'FD2', 'FDC2', '2345678', 'LOC2', 'LC2', 'OP2',
            'OR2', 'OC2', 'POD2', 'PDC2', 'POL2', 'PLC2', 'SCAC2', 'SERVICE2', 'SRC2',
            'VESSEL2', 'VOY2', '2000', 'B'
        );

        // El futuro es menor (debería regresar -1)
        System.assertEquals(-1, futureItem.compareTo(pastItem), 'Futuro debe ser menor que pasado');

        // El pasado es mayor (debería regresar 1)
        System.assertEquals(1, pastItem.compareTo(futureItem), 'Pasado debe ser mayor que futuro');

        // Igualdad (debería regresar 0)
        NEU_JE_TrackAndTrace_s equalItem = new NEU_JE_TrackAndTrace_s(
            'ATAPOD3', 'Activity3', 'A3', 'BL3', 'B3', '300', 'CONT3', '45HC',
            pastDate, 'ETA3', 'ETD3', 'FD3', 'FDC3', '3456789', 'LOC3', 'LC3', 'OP3',
            'OR3', 'OC3', 'POD3', 'PDC3', 'POL3', 'PLC3', 'SCAC3', 'SERVICE3', 'SRC3',
            'VESSEL3', 'VOY3', '3000', 'C'
        );

        System.assertEquals(0, pastItem.compareTo(equalItem), 'Fechas iguales deben regresar 0');
    }

    @isTest
    static void testConstructorFlags() {
        // Fecha pasada
        String pastDate = System.now().addDays(-1).formatGmt('yyyy-MM-dd\'T\'HH:mm');

        NEU_JE_TrackAndTrace_s item = new NEU_JE_TrackAndTrace_s(
            'ATAPOD', 'Activity', 'Code', 'BL', 'Booking', 'Cap', 'CONT', 'TYPE',
            pastDate, 'ETA', 'ETD', 'FD', 'FDC', '1234567', 'LOC', 'LC', 'OP',
            'OR', 'OC', 'POD', 'PDC', 'POL', 'PLC', 'SCAC', 'SERVICE', 'SRC',
            'VESSEL', 'VOY', '100', 'Z'
        );

        // Validaciones básicas
        System.assertEquals(true, item.Ha_Pasado, 'Ha_Pasado debe ser true para fecha pasada');
        System.assertEquals(false, item.online, 'online debe iniciar en false');
        System.assertEquals('', item.Mmsi, 'MMSI debe ser vacío');
        System.assertEquals(false, item.searched, 'searched debe iniciar en false');
        System.assertEquals('1234567', item.Imo_Number, 'IMO debe permanecer igual si longitud es 7');
    }
}