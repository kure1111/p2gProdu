global class P2G_WS_EmbarquesWrapper {
    public class Requerido{
         public String vehicle_NumPlacaTracto{get;set;}
         public String operationExecutive{get;set;}
         public String operator1_Name{get;set;}
         public String accountOriginAddress{get;set;}
         public Date ETD{get;set;}
         public Time ETDTime{get;set;}
         public String accountForCustomer_Name{get;set;}
         public String customerReference{get;set;}
         public String accountDestinationAddress{get;set;}
         public Date ETA{get;set;}
         public Time ETATime{get;set;}
         public String carrier_CustomerId{get;set;}
         public String shipment_Name{get;set;}
         public String AddressOri{get;set;}
         public String AddressDes{get;set;}
        
    }
    public class buscaEmbarques{
        public String accountOriginAddress{get;set;}
        public String entradaCarga{get;set;}
        public String shipment{get;set;}
        public String idAccountOriginAddress{get;set;}
        public String equivalenteLT{get;set;}
        public String accountDestinationAddress{get;set;}
        public String idAccountDestinationAddress{get;set;}
        public String entradaDestino{get;set;}
        public String operadorNumRcontrol{get;set;}
        public String operadorSinRcontrol{get;set;}
        public String unidad{get;set;}
        public String cliente{get;set;}
    }
    public class response {
        public List<AppointmentLoadDetail> details {get;set;}
    }

    public class AppointmentLoadDetail {
        public Integer appointment_load_detail_id {get;set;}
        public String status {get;set;}
        public String shipment {get;set;}
        public String activityNum {get;set;}
        public String error_type {get;set;}
        public String error_message {get;set;}
        public String field {get;set;}
    }
    public class getUserToken{
        public Integer userId{get;set;}
        public Integer companyId{get;set;}
        public Datetime lastLogin{get;set;}
        public String locationName{get;set;}
        public String token{get;set;}
        public Datetime created{get;set;}
        public Datetime expires{get;set;}
    }
    public class getUserTokenError{
        public String key{get;set;}
        public Integer code{get;set;}
        public Integer severity{get;set;}
        public Integer layer{get;set;}
        public String message{get;set;}
        public String messageArgs{get;set;}
    }
    public class cargaEmbarques{
        public String token{get;set;}
        public List<Parameters> parameters{get;set;}
    }
    public class Parameters{
        public Truck truck{get;set;}
        public Driver driver{get;set;}
        public Source source{get;set;}
        public Product product{get;set;}
        public String shipment{get;set;}
        public Destinies destinies{get;set;}
        public Trailers trailers{get;set;}
        public Transline transline{get;set;}
        public String type_operation{get;set;}
        public String type_operacion_id{get;set;}
    }
    public class searchFilters{
        public String key{get;set;}
        public String company_type{get;set;}
        public String activity_num{get;set;}
        public String shipment{get;set;}
    }
    public class respuestaSearch{
        public SourceRes source{get;set;}
        public list<destinyRes> destiny{get;set;}
        public String stop_id{get;set;}
        public Vehicle vehicle{get;set;}
        public String shipment{get;set;}
        public Tendering tendering{get;set;}
        public Vehicle trailer_1{get;set;}
        public Vehicle trailer_2{get;set;}
        public String vehicle_type{get;set;}
        public String supplier_name{get;set;}
        public Integer supply_chain_id{get;set;}
        public boolean PDFCartaPorte{get;set;}
    }
    public class error{
        public respuestaSearchError error{get;set;}
    }
    public class respuestaSearchError{
        public String key{get;set;}
        public Integer code{get;set;}
        public Integer severity{get;set;}
        public Integer layer{get;set;}
        public String message{get;set;}
        public String message_args{get;set;}
        public String sql_state{get;set;}
    }
    public class Truck{
        public String eco{get;set;}
        public String plate{get;set;}
        public String type{get;set;}
        public String type_description{get;set;}
    }
    public class Driver{
        public String credential{get;set;}
        public String phone{get;set;}
        public String aux_1{get;set;}
        public String aux_2{get;set;}
        public String aux_3{get;set;}
        public String email{get;set;}
        public String fiscal_code{get;set;}
        public String name{get;set;}
    }
    public class Source{
        public String aux_1{get;set;}
        public String aux_2{get;set;}
        public String aux_3{get;set;}
        public String aux_4{get;set;}
        public String aux_5{get;set;}
        public String country_code{get;set;}
        public String muni_code{get;set;}
        public String customer_equiv{get;set;}
        public String customer_name{get;set;}
        public String latitude{get;set;}
        public String longitude{get;set;}
        public String phone{get;set;}
        public String equiv{get;set;}
        public String address{get;set;}
        public String description{get;set;}
        public Planning planning{get;set;}
    }
    public class Planning{
        public List<Plan> plan{get;set;}
    }
    public class Plan{
        public Code code{get;set;}
        public String name{get;set;}
        public String dateti{get;set;}
    }
    public class Code{
        public String value{get;set;} 
    }
    public class Product{
        public String aux_1{get;set;}
        public String aux_2{get;set;}
        public String aux_3{get;set;}
        public String description{get;set;}
        public String product_type{get;set;}
        public String equiv{get;set;}
        public Integer quantity{get;set;}
        public String sku{get;set;}
        public Decimal volume{get;set;}
        public Decimal weigth{get;set;}
    }
    public class Destinies{
        public List<Destiny> destiny{get;set;}
    }
    public class Destiny{
        public String aux_1{get;set;}
        public String aux_2{get;set;}
        public String aux_3{get;set;}
        public String aux_4{get;set;}
        public String aux_5{get;set;}
        public String chep_pallets{get;set;}
        public String pallets_01{get;set;}
        public String pallets_02{get;set;}
        public String country_code{get;set;}
        public String dsta_uss_external_company{get;set;}
        public String muni_code{get;set;}
        public String customer_equiv{get;set;}
        public String customer_name{get;set;}
        public String latitude{get;set;}
        public String longitude{get;set;}
        public String phone{get;set;}
        public String confirmation{get;set;}
        public String activitynum{get;set;}
        public String equiv{get;set;}
        public String address{get;set;}
        public String autorized_person{get;set;}
        public String description{get;set;}
        public Planning planning{get;set;}
        public String seal_1{get;set;}
        public String seal_2{get;set;}
        public String seal_3{get;set;}
        public String state_code{get;set;}
        public String sequence{get;set;}
    }
    public class Trailers{
        public String eco{get;set;}
        public String plate{get;set;}
        public Integer order{get;set;}
        public String type{get;set;}
        public String type_description{get;set;}
    }
    public class Transline{
        public String equiv{get;set;}
        public String description{get;set;}
        public String fiscal_code{get;set;}
    }
    public class SourceRes{
        public List<PlanRes> plan{get;set;}
        public List<Track> track{get;set;}
        public String region_name{get;set;}
        public String location_name{get;set;}
        public list<String> location_equiv{get;set;}
        public String seal_1{get;set;}
        public String seal_2{get;set;}
        public String ori_aux_1{get;set;}
        public String ori_aux_2{get;set;}
        public String ori_aux_3{get;set;}
        public String ori_aux_4{get;set;}
        public String ori_aux_5{get;set;}
        
    }
    public class PlanRes{
        public String dat{get;set;}
        public Carrier carrier{get;set;}
        public String event_key{get;set;}
    }
    public class Carrier{
        public String fiscal_code{get;set;}
        public String company_name{get;set;}
    }
    public class Vehicle{
        public String eco{get;set;}
        public String plate{get;set;}
    }
    public class destinyRes{
        public Date ETA{get;set;}
        public List<PlanRes> plan{get;set;}
        public List<Track> track{get;set;}
        public Reject Reject{get;set;}
        public Integer orden{get;set;}
        public String dst_aux_1{get;set;}
        public String semaphore{get;set;}
        public String region_name{get;set;}
        public String activity_num{get;set;}
        public String location_name{get;set;}
        public List<String> location_equiv{get;set;}
    }
    public class Reject{
        public String type{get;set;}
        public String cause{get;set;}
        public String status{get;set;}
    }
    public class Track{
        public String dat{get;set;}
        public Double latitude{get;set;}
        public Double longitude{get;set;}
        public String event_key{get;set;}
        public driverRes driver{get;set;}
        public Carrier carrier{get;set;}
        public Vehicle vehicle{get;set;}
        public List<Evidence> evidence{get;set;}
    }
    public class driverRes{
        public String certified{get;set;}
        public String full_name{get;set;}
        public String fiscal_code{get;set;}
    }
    public class Evidence{
        public String path{get;set;}
        public String type{get;set;}
    }
    public class Tendering{
        public String status{get;set;}
        public String created{get;set;}
        public String finish_tendering{get;set;}
        public String confirmed_date{get;set;}
    }
}