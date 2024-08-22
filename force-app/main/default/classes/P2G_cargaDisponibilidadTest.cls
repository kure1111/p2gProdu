@IsTest
public class P2G_cargaDisponibilidadTest {
    @IsTest(SeeAllData=true)
    public static void test(){
        String json = '[{"carrier":"FLETES LUEDAN DEL DESIERTO SA DE CV","idContainerType":"Caja 53 FT","fechaVigencia":"2024-07-04 14:00:00","planner":"Alberto García","searchValueIdLoad":"ZM de Acapulco","searchValueIdUnLoad":"ZM de Monterrey","ticketPromedio":"14","noRutas":"3"},{"carrier":"FLETES LUEDAN DEL DESIERTO SA DE CV","idContainerType":"Caja 53 FT","fechaVigencia":"2024-07-04 14:00:00","planner":"Alberto García","searchValueIdLoad":"Bacalar","searchValueIdUnLoad":"ZM de Monterrey","ticketPromedio":"14","noRutas":"3"},{"carrier":"FLETES LUEDAN DEL DESIERTO SA DE CV","idContainerType":"Caja 53 FT","fechaVigencia":"2024-07-04 14:00:00","planner":"Alberto García","searchValueIdLoad":"Bacalar","searchValueIdUnLoad":"ZM de Monterrey","ticketPromedio":"14","noRutas":"3"}]';
    	P2G_cargaDisponibilidad.cargaLineas(json);
    }
}