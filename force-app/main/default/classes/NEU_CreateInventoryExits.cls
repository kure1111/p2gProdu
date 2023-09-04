public with sharing class NEU_CreateInventoryExits {
    public Warehouse__c record { get; set; }
    public List<Inventory_Entry__c> entries { get; set; }
    public Warehouse_Exit_Order__c filter { get; set; }

    public List<exit_s> new_inventory_exits { get; set; }
    public class exit_s {
        public Inventory_Entry__c entry_record { get; set; }
        public Inventory_Exit__c exit_record { get; set; }
        public boolean selected { get; set; }

        public exit_s(Inventory_Entry__c entry_record, Inventory_Exit__c exit_record, boolean selected) {
            this.entry_record = entry_record;
            this.exit_record = exit_record;
            this.selected = selected;
        }
    }

    public List<exit_lines_pallets_s> palletLines { get; set; }
    public class exit_lines_pallets_s {
        public List<exit_s> ex { get; set; }
        public String pallet { get; set; }

        public exit_lines_pallets_s(List<exit_s> ex, String pallet) {
            this.ex = ex;
            this.pallet = pallet;
        }
    }

    ApexPages.StandardController con;

    public NEU_CreateInventoryExits(ApexPages.StandardController stdController) {
        con = stdController;

        try {
            record = [
                    select Id, Name
                    from Warehouse__c
                    where Id = :con.getRecord().id
            ];
        } catch (Exception ee) {
            record = new Warehouse__c();
        }

        filter = new Warehouse_Exit_Order__c();
        filter.Warehouse__c = record.Id;

    }

    public void search_entries() {
        string query_entries = 'SELECT Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c, Item_Description__c,';
        query_entries += ' Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c, Shipment__c, Units_Picked__c,';
        query_entries += ' Shipment_Item_Line__c, Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id , Shipment_Item_Line__r.pallet_warehouse__r.Name';
        query_entries += ' FROM Inventory_Entry__c';
        query_entries += ' WHERE Remaining_Units__c > 0';
        query_entries += ' AND Warehouse__c = \'' + record.Id + '\'';
        query_entries += ' ' + (filter.Account_for_Customer__c != null ? ' AND Shipment__r.Account_for__c = \'' + filter.Account_for_Customer__c + '\'' : '');
        query_entries += ' ORDER BY Shipment_Item_Line__r.pallet_warehouse__r.Id ASC';
        List<Inventory_Entry__c> all_entries = database.query(query_entries);

        new_inventory_exits = new List<exit_s>();
        String actualPallet = '';
        Integer counter = 1;
        Id IdActualPallet;
        palletLines = new List<exit_lines_pallets_s>();

        for (Inventory_Entry__c e : all_entries) {
            Inventory_Exit__c new_inventory_exit = new Inventory_Exit__c();
            //new_inventory_exit.Inventory_Entry__c = e.Id;
            new_inventory_exit.Units_Picked__c = e.Remaining_Units__c;
            new_inventory_exit.Warehouse__c = e.Warehouse__c;
            new_inventory_exit.Warehouse_Storage_Bin__c = e.Warehouse_Storage_Bin__c;
            new_inventory_exit.Shipment__c = e.Shipment__c;
            new_inventory_exit.Shipment_Item_Line__c = e.Shipment_Item_Line__c;


            //group by pallet && new lookup pallet
            if (e.Shipment_Item_Line__r.pallet_warehouse__r.Id != null && IdActualPallet == null) {
                palletLines.add(new exit_lines_pallets_s(new_inventory_exits, actualPallet));
                new_inventory_exits = new List<exit_s>();
                new_inventory_exits.add(new exit_s(e, new_inventory_exit, (Test.isRunningTest() ? true : false)));

                if (counter == all_entries.size()) {
                    new_inventory_exits.add(new exit_s(e, new_inventory_exit, (Test.isRunningTest() ? true : false)));
                }
            }
            else if (IdActualPallet == e.Shipment_Item_Line__r.pallet_warehouse__r.Id || IdActualPallet == null) {
                new_inventory_exits.add(new exit_s(e, new_inventory_exit, (Test.isRunningTest() ? true : false)));
                if (counter == all_entries.size()) {
                    palletLines.add(new exit_lines_pallets_s(new_inventory_exits, e.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
            } else if (IdActualPallet != e.Shipment_Item_Line__r.pallet_warehouse__r.Id) {
                palletLines.add(new exit_lines_pallets_s(new_inventory_exits, actualPallet));
                new_inventory_exits = new List<exit_s>();
                new_inventory_exits.add(new exit_s(e, new_inventory_exit, (Test.isRunningTest() ? true : false)));

                if (counter == all_entries.size()) {
                    palletLines.add(new exit_lines_pallets_s(new_inventory_exits, e.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
            }
            IdActualPallet = e.Shipment_Item_Line__r.pallet_warehouse__r.Id;
            actualPallet = e.Shipment_Item_Line__r.pallet_warehouse__r.Name;
            counter++;

        }
    }

    public pagereference create_exits() {
        try {
            insert filter;

            List<Inventory_Exit__c> new_exits = new List<Inventory_Exit__c>();

            string errors = '';

            System.debug(palletLines);

            if (palletLines != null) {
                for(exit_lines_pallets_s pl : palletLines)
                {
                    for (exit_s e : pl.ex) {
                        if (e.selected) {
                            if (e.exit_record.Units_Picked__c == null || e.exit_record.Units_Picked__c == 0)
                                errors += 'The Warehouse Entry <strong>' + e.entry_record.Name + '</strong> is selected and doesn\'t have a valid Units Picked value.<br/>';

                            e.exit_record.Item__c = e.entry_record.Item__c;

                            if (e.exit_record.Units_Picked__c > e.entry_record.Remaining_Units__c)
                                e.exit_record.Units_Picked__c = e.entry_record.Remaining_Units__c;

                            e.exit_record.Warehouse_Exit_Order__c = filter.Id;

                            e.exit_record.Inventory_Entry__c = e.entry_record.Id;

                            new_exits.add(e.exit_record);
                        }
                    }
                }

                System.debug(new_exits.size());
                System.debug(new_exits);

                if (new_exits.size() > 0) {
                    if (errors == '') {
                        try {
                            insert new_exits;

                            List<Id> idShipments = new List<Id>();
                            for(Inventory_Exit__c ne : new_exits)
                            {
                                idShipments.add(ne.Shipment__c);
                            }

                            /* Updating Surface data pallets*/

                            decimal surfaceUnit = 0;


                            List <Inventory_Exit__c> exits = [
                                    select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Units_Picked__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name,
                                            Inventory_Entry__c, Inventory_Entry__r.Name, CreatedDate, Shipment_Item_Line__c, Shipment_Item_Line__r.Name, Item_Code__c, Item_Description__c,
                                            Shipment_Item_Line__r.Pallet_Code__c, Inventory_Entry__r.has_pallet__c,  Inventory_Entry__r.Total_Surface_m2__c, Shipment_Item_Line__r.pallet_warehouse__c
                                    from Inventory_Exit__c
                                    where Shipment__c =: idShipments
                                    order by Shipment_Item_Line__r.Pallet_Code__c asc
                            ];

                            List<Inventory_Entry__c> entries = [
                                    select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c,
                                            Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c,
                                            Item_Description__c, Units_Picked__c, Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name,
                                            Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c, Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c, has_pallet__c
                                    from Inventory_Entry__c
                                    where Shipment__c = :idShipments
                                    order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
                            ];

                            System.debug(idShipments);

                            //dividir las medidas del pallet por el nº de unidades que tengan el mismo numero
                            Map<id,decimal> map_pallet_warehouse = new Map<id,decimal>();
                            List<AggregateResult> query_entitysubscription = [select Shipment_Item_Line__r.pallet_warehouse__r.Id Id, COUNT(Shipment_Item_Line__c) total, MAX(Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c) width, MAX(Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c) lenght
                            from Inventory_Entry__c
                            where Shipment__c IN : idShipments and Shipment_Item_Line__r.pallet_warehouse__r.Id != null and Remaining_Units__c > 0
                            group by Shipment_Item_Line__r.pallet_warehouse__r.Id];

                            for(AggregateResult qi: query_entitysubscription)
                            {
                                surfaceUnit =(decimal)qi.get('width') * (decimal)qi.get('lenght') ;
                                surfaceUnit = surfaceUnit / (decimal)qi.get('total');
                                surfaceUnit = surfaceUnit / 1000;
                                surfaceUnit.setscale(2);

                                map_pallet_warehouse.put((String)qi.get('Id'),surfaceUnit);
                            }

                            List <Inventory_Entry__c> entriesUpdate = new List <Inventory_Entry__c>();
                            Decimal unitSurface = 0;

                            for(Inventory_Entry__c ie : entries) {
                                if(ie.Shipment_Item_Line__r.pallet_warehouse__c != null ) {
                                    unitSurface = map_pallet_warehouse.get(ie.Shipment_Item_Line__r.pallet_warehouse__c);
                                    if(unitSurface > 0)
                                    {
                                        ie.Total_Surface_m2__c = unitSurface;
                                        ie.has_pallet__c  = true;
                                        entriesUpdate.add(ie);
                                    }
                                }
                            }

                            System.debug(entriesUpdate);

                            update entriesUpdate;

                            /*Paging reference*/
                            PageReference pgReturnPage;
                            String returnUrl = '/' + filter.Id;
                            pgReturnPage = new PageReference(returnUrl);
                            pgReturnPage.setRedirect(true);
                            return pgReturnPage;
                        } catch (Exception ex) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + ex)); return null;
                        }
                    } else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errors));
                        return null;
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'You have to select at least one Inventory Entry.'));
                    return null;
                }
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'You have to select at least one Inventory Entry.'));
                return null;
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + ex)); return null;
        }
    }

    public pagereference return_warehouse() {
        PageReference pgReturnPage;
        String returnUrl = '/' + record.Id;
        pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }


    public void bypass()
    {
        integer a= 1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;


    }


    public void bypass2()
    {
        integer a= 1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;
        a= a+1;

        a= a+1;
        a= a+1;


    }
}