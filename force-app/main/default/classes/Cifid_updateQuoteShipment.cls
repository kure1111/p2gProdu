//Generated by wsdl2apex

public class Cifid_updateQuoteShipment {
    public class LogInfo {
        public String category;
        public String level;
        private String[] category_type_info = new String[]{'category','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] level_type_info = new String[]{'level','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'category','level'};
    }
    public class DebuggingInfo_element {
        public String debugLog;
        private String[] debugLog_type_info = new String[]{'debugLog','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'debugLog'};
    }
    public class address {
        public String city;
        public String country;
        public String countryCode;
        public String geocodeAccuracy;
        public String postalCode;
        public String state;
        public String stateCode;
        public String street;
        private String[] city_type_info = new String[]{'city','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] country_type_info = new String[]{'country','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] countryCode_type_info = new String[]{'countryCode','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] geocodeAccuracy_type_info = new String[]{'geocodeAccuracy','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] postalCode_type_info = new String[]{'postalCode','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] state_type_info = new String[]{'state','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] stateCode_type_info = new String[]{'stateCode','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] street_type_info = new String[]{'street','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'city','country','countryCode','geocodeAccuracy','postalCode','state','stateCode','street'};
    }
    public class SessionHeader_element {
        public String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'sessionId'};
    }
    public class estatus {
        public String code;
        public String message;
        private String[] code_type_info = new String[]{'code','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] message_type_info = new String[]{'message','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'code','message'};
    }
    public class updateQuote_element {
        public Cifid_updateQuoteShipment.Shipment ship;
        private String[] ship_type_info = new String[]{'ship','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'ship'};
    }
    public class CallOptions_element {
        public String client;
        private String[] client_type_info = new String[]{'client','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'client'};
    }
    public class Shipment {
        public String airBookingNumber;
        public String airStatus;
        public String ata;
        public String atd;
        public String bookingconfirmation;
        public String carrier;
        public String deliveryAddress;
        public String externalNumber;
        public String externalQuoteNumber;
        public String flightNumber;
        public String freeDays;
        public String hblNumber;
        public DateTime lastUpdate;
        public String mawbNumber;
        public String oceanExpoStatus;
        public String oceanImpoStatus;
        public String opExecutive;
        public String pickupAddress;
        public String seaBookingNumber;
        public String seaContainerNumber;
        public String spCurrency;
        public String statusMonitoreo;
        public String statusPlanner;
        public String totalServBuyAmmount;
        public String vessel;
        public Decimal vesselLat;
        public Decimal vesselLon;
        private String[] airBookingNumber_type_info = new String[]{'airBookingNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] airStatus_type_info = new String[]{'airStatus','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] ata_type_info = new String[]{'ata','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] atd_type_info = new String[]{'atd','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] bookingconfirmation_type_info = new String[]{'bookingconfirmation','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] carrier_type_info = new String[]{'carrier','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] deliveryAddress_type_info = new String[]{'deliveryAddress','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] externalNumber_type_info = new String[]{'externalNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] externalQuoteNumber_type_info = new String[]{'externalQuoteNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] flightNumber_type_info = new String[]{'flightNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] freeDays_type_info = new String[]{'freeDays','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] hblNumber_type_info = new String[]{'hblNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] lastUpdate_type_info = new String[]{'lastUpdate','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] mawbNumber_type_info = new String[]{'mawbNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] oceanExpoStatus_type_info = new String[]{'oceanExpoStatus','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] oceanImpoStatus_type_info = new String[]{'oceanImpoStatus','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] opExecutive_type_info = new String[]{'opExecutive','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] pickupAddress_type_info = new String[]{'pickupAddress','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] seaBookingNumber_type_info = new String[]{'seaBookingNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] seaContainerNumber_type_info = new String[]{'seaContainerNumber','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] spCurrency_type_info = new String[]{'spCurrency','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] statusMonitoreo_type_info = new String[]{'statusMonitoreo','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] statusPlanner_type_info = new String[]{'statusPlanner','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] totalServBuyAmmount_type_info = new String[]{'totalServBuyAmmount','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] vessel_type_info = new String[]{'vessel','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] vesselLat_type_info = new String[]{'vesselLat','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] vesselLon_type_info = new String[]{'vesselLon','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'airBookingNumber','airStatus','ata','atd','bookingconfirmation','carrier','deliveryAddress','externalNumber','externalQuoteNumber','flightNumber','freeDays','hblNumber','lastUpdate','mawbNumber','oceanExpoStatus','oceanImpoStatus','opExecutive','pickupAddress','seaBookingNumber','seaContainerNumber','spCurrency','statusMonitoreo','statusPlanner','totalServBuyAmmount','vessel','vesselLat','vesselLon'};
    }
    public class updateQuoteResponse_element {
        public Cifid_updateQuoteShipment.estatus result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'result'};
    }
    public class DebuggingHeader_element {
        public Cifid_updateQuoteShipment.LogInfo[] categories;
        public String debugLevel;
        private String[] categories_type_info = new String[]{'categories','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'0','-1','false'};
        private String[] debugLevel_type_info = new String[]{'debugLevel','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'categories','debugLevel'};
    }
    public class location {
        public Double latitude;
        public Double longitude;
        private String[] latitude_type_info = new String[]{'latitude','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] longitude_type_info = new String[]{'longitude','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'latitude','longitude'};
    }
    public class AllowFieldTruncationHeader_element {
        public Boolean allowFieldTruncation;
        private String[] allowFieldTruncation_type_info = new String[]{'allowFieldTruncation','http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak','true','false'};
        private String[] field_order_type_info = new String[]{'allowFieldTruncation'};
    }
    public class Cifid_ShipmentFromPak {
        public String endpoint_x = 'https://na85.salesforce.com/services/Soap/class/Cifid_ShipmentFromPak';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public Cifid_updateQuoteShipment.DebuggingInfo_element DebuggingInfo;
        public Cifid_updateQuoteShipment.SessionHeader_element SessionHeader;
        public Cifid_updateQuoteShipment.CallOptions_element CallOptions;
        public Cifid_updateQuoteShipment.DebuggingHeader_element DebuggingHeader;
        public Cifid_updateQuoteShipment.AllowFieldTruncationHeader_element AllowFieldTruncationHeader;
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak';
        private String AllowFieldTruncationHeader_hns = 'AllowFieldTruncationHeader=http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak', 'Cifid_updateQuoteShipment'};
        public Cifid_updateQuoteShipment.estatus updateQuote(Cifid_updateQuoteShipment.Shipment ship) {
            Cifid_updateQuoteShipment.updateQuote_element request_x = new Cifid_updateQuoteShipment.updateQuote_element();
            request_x.ship = ship;
            Cifid_updateQuoteShipment.updateQuoteResponse_element response_x;
            Map<String, Cifid_updateQuoteShipment.updateQuoteResponse_element> response_map_x = new Map<String, Cifid_updateQuoteShipment.updateQuoteResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',
              'updateQuote',
              'http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak',
              'updateQuoteResponse',
              'Cifid_updateQuoteShipment.updateQuoteResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}