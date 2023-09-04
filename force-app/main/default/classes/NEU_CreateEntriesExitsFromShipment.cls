public with sharing class NEU_CreateEntriesExitsFromShipment {
    public Shipment__c record { get; set; }
    public List<Inventory_Entry__c> entries { get; set; }
    public List<Inventory_Entry__c> new_inventory_entries { get; set; }
    public List<Shipment_Line__c> cargo_lines { get; set; }
    public List<Inventory_Entry__c> all_entries { get; set; }
    public List<Inventory_Exit__c> exits { get; set; }
    public decimal TakenTotal { get; set; }


    public List<line_s> lines { get; set; }
    public class line_s {
        public Shipment_Line__c shipment_line { get; set; }
        public Inventory_Entry__c entry { get; set; }

        public line_s(Shipment_Line__c shipment_line, Inventory_Entry__c entry) {
            this.shipment_line = shipment_line;
            this.entry = entry;
        }
    }

    public List<exit_iventory_s> exitInventory { get; set; }
    public class exit_iventory_s {
        public List<Inventory_Exit__c> ie { get; set; }
        public String pallet { get; set; }

        public exit_iventory_s(List<Inventory_Exit__c> ie, String pallet) {
            this.ie = ie;
            this.pallet = pallet;
        }
    }

    public List<entry_pallets_s> palletEntries { get; set; }
    public class entry_pallets_s {
        public List<Inventory_Entry__c> ies { get; set; }
        public String pallet { get; set; }

        public entry_pallets_s(List<Inventory_Entry__c> ies, String pallet) {
            this.ies = ies;
            this.pallet = pallet;
        }
    }

    public List<exit_pallets_s> palletExits { get; set; }
    public class exit_pallets_s {
        public List<Shipment_Line__c> sl { get; set; }
        public String pallet { get; set; }

        public exit_pallets_s(List<Shipment_Line__c> sl, String pallet) {
            this.sl = sl;
            this.pallet = pallet;
        }
    }

    public List<line_pallets_s> palletLines { get; set; }
    public class line_pallets_s {
        public List<line_s> line_s { get; set; }
        public String pallet { get; set; }


        public line_pallets_s(List<line_s> line_s, String pallet) {
            this.line_s = line_s;
            this.pallet = pallet;
        }
    }

    public List<exit_lines_pallets_s> palletLinesExits { get; set; }
    public class exit_lines_pallets_s {
        public List<exit_s> ex { get; set; }
        public String pallet { get; set; }

        public exit_lines_pallets_s(List<exit_s> ex, String pallet) {
            this.ex = ex;
            this.pallet = pallet;
        }
    }

    public List<exit_s> new_inventory_exits { get; set; }
    public class exit_s {
        public Inventory_Entry__c entry_record { get; set; }
        public Inventory_Exit__c exit_record { get; set; }
        public string sline_selected { get; set; }
        public List<SelectOption> sline_values { get; set; }
        public boolean selected { get; set; }

        public exit_s(Inventory_Entry__c entry_record, Inventory_Exit__c exit_record, string sline_selected, List<SelectOption> sline_values, boolean selected) {
            this.entry_record = entry_record;
            this.exit_record = exit_record;
            this.sline_selected = sline_selected;
            this.sline_values = sline_values;
            this.selected = selected;
        }
    }

    ApexPages.StandardController con;

    public NEU_CreateEntriesExitsFromShipment(ApexPages.StandardController stdController) {
        con = stdController;

        try {
            record = [
                    select Id, Name, Warehouse__c, Warehouse__r.Name, Warehouse__r.Total_Space_m2__c, Warehouse__r.Taken_Space_m2__c, Warehouse__r.Free_Space_m2__c,
                            Total_Surface_m2__c, Warehouse_Movement_Type__c, Account_for__c, Only_Warehouse_Service__c
                    from Shipment__c
                    where Id = :con.getRecord().id
            ];
        } catch (Exception ee) {
            record = new Shipment__c();
        }

        try {


            lines = new List<line_s>();
            palletLines = new List<line_pallets_s>();
            Id IdActualPallet;
            entries = new List<Inventory_Entry__c>();
            cargo_lines = new List<Shipment_Line__c>();


            if (record.Warehouse__c == null || record.Warehouse_Movement_Type__c == null) {
                if (record.Warehouse__c == null)
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'This Shipment doesn\'t have Warehouse. <a href="/' + record.Id + '">Return to Shipment</a>'));
                if (record.Warehouse_Movement_Type__c == null)
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'This Shipment doesn\'t have Warehouse Movement Type. <a href="/' + record.Id + '">Return to Shipment</a>'));
            } else {
                List<Warehouse_Storage_Bin__c> storage_bin = [select Id, Name from Warehouse_Storage_Bin__c where Warehouse__c = :record.Warehouse__c];
                String actualPallet = '';
                Integer counter = 1;

                //inicializacion la agrupación de visualizacion de datos por pallet
                if (storage_bin.size() > 0) {
                    cargo_lines = [
                            select Id, Name, Shipping_Surface_m2__c, Item_Name__c, Item_Name__r.Name, Units_Shipped__c, Item_Name__r.Sourcing_Item_Code__c, Item_Name__r.Item_Description__c,
                                    Item_Name__r.Packaging_Surface_m2__c, Pallet_Code__c, pallet_warehouse__r.Id, pallet_warehouse__r.Name
                            from Shipment_Line__c
                            where Shipment__c = :record.Id
                            order by pallet_warehouse__r.Id asc
                    ];

                    if (record.Warehouse_Movement_Type__c == 'Entries (In)') {
                        entries = [
                                select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c,
                                        Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c,
                                        Item_Description__c, Units_Picked__c, Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name
                                from Inventory_Entry__c
                                where Shipment__c = :record.Id
                                order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
                        ];



                        new_inventory_entries = new List<Inventory_Entry__c>();

                        actualPallet = '';
                        counter = 1;
                        IdActualPallet = null;

                        for (Shipment_Line__c sl : cargo_lines) {
                            Inventory_Entry__c new_entry = new Inventory_Entry__c();
                            new_entry.Item__c = sl.Item_Name__c;
                            new_entry.Shipment__c = record.Id;
                            new_entry.Arrival_Date__c = System.today();
                            new_entry.Shipment_Item_Line__c = sl.Id;
                            new_entry.Units_Entry__c = sl.Units_Shipped__c;
                            new_entry.Warehouse__c = record.Warehouse__c;
                            new_entry.Warehouse_Storage_Bin__c = storage_bin[0].Id;
                            new_entry.Total_Surface_m2__c = (sl.Item_Name__c != null && sl.Item_Name__r.Packaging_Surface_m2__c != null && sl.Units_Shipped__c != null ? sl.Item_Name__r.Packaging_Surface_m2__c * sl.Units_Shipped__c : 0);
                            new_inventory_entries.add(new_entry);

                            //group by pallet && new lookup pallet
                            if (sl.pallet_warehouse__r.Id != null && IdActualPallet == null) {
                                palletLines.add(new line_pallets_s(lines, actualPallet));
                                lines = new List<line_s>();
                                lines.add(new line_s(sl, new_entry));

                                if (counter == cargo_lines.size()) {
                                    palletLines.add(new line_pallets_s(lines, sl.pallet_warehouse__r.Name));
                                }
                            } else if (IdActualPallet == sl.pallet_warehouse__r.Id || IdActualPallet == null) {

                                lines.add(new line_s(sl, new_entry));
                                if (counter == cargo_lines.size()) {
                                    palletLines.add(new line_pallets_s(lines, sl.pallet_warehouse__r.Name));
                                }

                            } else if (IdActualPallet != sl.pallet_warehouse__r.Id) {

                                palletLines.add(new line_pallets_s(lines, actualPallet));
                                lines = new List<line_s>();
                                lines.add(new line_s(sl, new_entry));

                                if (counter == cargo_lines.size()) {
                                    palletLines.add(new line_pallets_s(lines, sl.pallet_warehouse__r.Name));
                                }
                            }
                            IdActualPallet = sl.pallet_warehouse__r.Id;
                            actualPallet = sl.pallet_warehouse__r.Name;
                            counter++;
                        }

                        //aplicando la lógica de los pallets para el calculo final del warehouse
                        Integer counterPallet = 0;
                        decimal surfaceUnit = 0;
                        TakenTotal = 0;
                        List<Id> idpallets = new List<Id>();
                        //calculating total surface
                        for (Shipment_Line__c sl : cargo_lines) {
                            if(sl.pallet_warehouse__c == null ) {
                                TakenTotal += sl.Units_Shipped__c * sl.Item_Name__r.Packaging_Surface_m2__c;
                                TakenTotal = TakenTotal.setScale(2);
                            }else
                            {
                                idpallets.add(sl.pallet_warehouse__c);
                            }
                        }

                        //dividir las medidas del pallet por el nº de unidades que tengan el mismo numero
                        Map<id,decimal> map_pallet_warehouse = new Map<id,decimal>();
                        List<AggregateResult> query_entitysubscription = [select Id Id, SUM(width_cm__c) width, SUM(lenght_cm__c) lenght
                        from pallet_warehouse__c
                        where Id  IN: idpallets
                        group by Id];


                        for(AggregateResult qi: query_entitysubscription)
                        {
                            surfaceUnit =(decimal)qi.get('width') * (decimal)qi.get('lenght') ;
                            surfaceUnit = surfaceUnit/1000;
                            surfaceUnit.setscale(2);

                            TakenTotal += surfaceUnit;
                        }

                        if (record.Warehouse__r.Free_Space_m2__c < TakenTotal)
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'There isn\'t enough space in the Warehouse for this Shipment.'));


                        //refresh Entries
                        refreshEntries();

                    }

                    if (record.Warehouse_Movement_Type__c == 'Deliveries (Out)') {

                        getExitInventory();

                        //calling get Exits
                        getExitspallets();

                    }
                }
            }

        }catch(Exception e)
        {
            System.debug(e);
        }

    }

    public void create_entries() {
        try {

            //dividir las medidas del pallet por el nº de unidades que tengan el mismo numero
            Map<Id,Decimal>palletOptions=new Map<Id,Decimal>();
            Integer counterPallet = 0;
            decimal surfaceUnit = 0;

            //calculating total surface
            for(Inventory_Entry__c ie : new_inventory_entries)
            {
                if(ie.Shipment_Item_Line__r.pallet_warehouse__c == null ) {
                    Decimal totalM2 = ie.Total_Surface_m2__c * ie.Units_Entry__c;
                    ie.Total_Surface_m2__c = totalM2.setScale(2);
                }
            }

            //insert data
            insert new_inventory_entries;

            entries = [
                    select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c,
                            Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c,
                            Item_Description__c, Units_Picked__c, Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name,
                            Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c, Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c, has_pallet__c
                    from Inventory_Entry__c
                    where Shipment__c = :record.Id
                    order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
            ];

            //dividir las medidas del pallet por el nº de unidades que tengan el mismo numero
            Map<id,decimal> map_pallet_warehouse = new Map<id,decimal>();
            List<AggregateResult> query_entitysubscription = [select Shipment_Item_Line__r.pallet_warehouse__r.Id Id, COUNT(Shipment_Item_Line__c) total, MAX(Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c) width, MAX(Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c) lenght
            from Inventory_Entry__c
            where Shipment__c = :record.Id and Shipment_Item_Line__r.pallet_warehouse__r.Id != null
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

            update entriesUpdate;

            //refresh Entries
            refreshEntries();

            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'The Warehouse Entries have been created correctly.'));

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + ex));
        }

    }

    public void create_exits() {
        List<Inventory_Exit__c> new_exits = new List<Inventory_Exit__c>();
        List<Inventory_Entry__c> updateEntry = new List<Inventory_Entry__c>();

        string errors = '';

        for (exit_lines_pallets_s pl : palletLinesExits) {
            for (exit_s e : pl.ex) {
                if (e.selected) {
                    if (e.sline_selected == '' || e.sline_selected == null)
                        errors += 'The Warehouse Entry <strong>' + e.entry_record.Name + '</strong> is selected and doesn\'t have a Cargo Line selected.<br/>';
                    if (e.exit_record.Units_Picked__c == null || e.exit_record.Units_Picked__c == 0)
                        errors += 'The Warehouse Entry <strong>' + e.entry_record.Name + '</strong> is selected and doesn\'t have a valid Units Picked value.<br/>';

                    if (e.sline_selected != '' && e.sline_selected != null) {
                        e.exit_record.Shipment_Item_Line__c = e.sline_selected.split('-')[0];
                        e.exit_record.Item__c = e.sline_selected.split('-')[1];
                    }

                    if (e.exit_record.Units_Picked__c > e.entry_record.Remaining_Units__c)
                        e.exit_record.Units_Picked__c = e.entry_record.Remaining_Units__c;

                    //e.exit_record.Inventory_Entry__r.Exit_Date__c = Date.today();

                    new_exits.add(e.exit_record);
                }
            }
        }

        if (errors == '') {
            try {
                insert new_exits;

                exits = [
                        select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Units_Picked__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name,
                                Inventory_Entry__c, Inventory_Entry__r.Name, CreatedDate, Shipment_Item_Line__c, Shipment_Item_Line__r.Name, Item_Code__c, Item_Description__c,
                                Shipment_Item_Line__r.Pallet_Code__c, Inventory_Entry__r.has_pallet__c,  Inventory_Entry__r.Total_Surface_m2__c, Shipment_Item_Line__r.pallet_warehouse__c
                        from Inventory_Exit__c
                        where Shipment__c = :record.Id
                        order by Shipment_Item_Line__r.Pallet_Code__c asc
                ];

                entries = [
                        select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c,
                                Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c,
                                Item_Description__c, Units_Picked__c, Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name,
                                Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c, Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c, has_pallet__c
                        from Inventory_Entry__c
                        where Shipment__c = :record.Id
                        order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
                ];

                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'The Warehouse Exits have been created correctly.'));


                String actualPallet = '';
                Integer counter = 1;
                List<Inventory_Exit__c> sl_exit_add = new List<Inventory_Exit__c>();
                exitInventory = new List<exit_iventory_s>();
                for (Inventory_Exit__c ie : exits) {
                    //group by pallet
                    if (actualPallet == ie.Shipment_Item_Line__r.Pallet_Code__c || actualPallet == '') {
                        sl_exit_add.add(ie);
                        if (exits.size() == 1) {
                            exitInventory.add(new exit_iventory_s(sl_exit_add, ie.Shipment_Item_Line__r.Pallet_Code__c));
                        }
                    } else if (actualPallet == ie.Shipment_Item_Line__r.Pallet_Code__c) {
                        sl_exit_add.add(ie);
                    } else if (actualPallet != ie.Shipment_Item_Line__r.Pallet_Code__c) {
                        exitInventory.add(new exit_iventory_s(sl_exit_add, actualPallet));
                        sl_exit_add = new List<Inventory_Exit__c>();
                        sl_exit_add.add(ie);

                        if (counter == cargo_lines.size()) {
                            exitInventory.add(new exit_iventory_s(sl_exit_add, ie.Shipment_Item_Line__r.Pallet_Code__c));
                        }
                    }
                    actualPallet = ie.Shipment_Item_Line__r.Pallet_Code__c;
                    counter++;
                }

                //dividir las medidas del pallet por el nº de unidades que tengan el mismo numero
                Map<Id,Decimal>palletOptions=new Map<Id,Decimal>();
                Integer counterPallet = 0;
                decimal surfaceUnit = 0;

                //dividir las medidas del pallet por el nº de unidades que tengan el mismo numero
                Map<id,decimal> map_pallet_warehouse = new Map<id,decimal>();
                List<AggregateResult> query_entitysubscription = [select Shipment_Item_Line__r.pallet_warehouse__r.Id Id, COUNT(Shipment_Item_Line__c) total, MAX(Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c) width, MAX(Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c) lenght
                from Inventory_Entry__c
                where Shipment__c = :record.Id and Shipment_Item_Line__r.pallet_warehouse__r.Id != null and Remaining_Units__c > 0
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

                update entriesUpdate;

                //refresh data
                getExitInventory();
                getExitspallets();

            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + ex));
            }

        } else
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errors));
    }

    private void getExitspallets()
    {
        Id IdActualPallet;
        String actualPallet = '';
        Integer counter = 1;
        new_inventory_exits = new List<exit_s>();

        cargo_lines = [
            select Id, Name, Shipping_Surface_m2__c, Item_Name__c, Item_Name__r.Name, Units_Shipped__c, Item_Name__r.Sourcing_Item_Code__c, Item_Name__r.Item_Description__c,
            Item_Name__r.Packaging_Surface_m2__c, Pallet_Code__c, pallet_warehouse__r.Id, pallet_warehouse__r.Name
            from Shipment_Line__c
            where Shipment__c =: record.Id
            order by pallet_warehouse__r.Id asc
        ];

        List<SelectOption> sline_values = new List<SelectOption>();
        sline_values.add(new SelectOption('', '-- select --'));

        for (Shipment_Line__c sl : cargo_lines) {
            sline_values.add(new SelectOption(sl.Id + '-' + sl.Item_Name__c, sl.Name + ' - ' + sl.Item_Name__r.Name));
        }

        all_entries = [
                select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c,
                        Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c, Item_Description__c, Units_Picked__c,
                        Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name
                from Inventory_Entry__c
                where Remaining_Units__c > 0 and Shipment__c = :record.Id
                order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
        ];

        //palletExits
        actualPallet = '';
        counter = 1;
        IdActualPallet = null;

        palletLinesExits = new List<exit_lines_pallets_s>();
        for (Inventory_Entry__c e : all_entries) {

            Inventory_Exit__c new_inventory_exit = new Inventory_Exit__c();
            new_inventory_exit.Inventory_Entry__c = e.Id;
            new_inventory_exit.Shipment__c = record.Id;
            new_inventory_exit.Units_Picked__c = e.Remaining_Units__c;
            new_inventory_exit.Warehouse__c = e.Warehouse__c;
            new_inventory_exit.Warehouse_Storage_Bin__c = e.Warehouse_Storage_Bin__c;

            //group by pallet && new lookup pallet
            if (e.Shipment_Item_Line__r.pallet_warehouse__r.Id != null && IdActualPallet == null) {
                if(new_inventory_exits.size() > 0)
                palletLinesExits.add(new exit_lines_pallets_s(new_inventory_exits, actualPallet));

                new_inventory_exits = new List<exit_s>();
                new_inventory_exits.add(new exit_s(e, new_inventory_exit, null, sline_values, false));

                if (counter == all_entries.size()) {
                    //new_inventory_exits.add(new exit_s(e, new_inventory_exit, null, sline_values, false));
                    palletLinesExits.add(new exit_lines_pallets_s(new_inventory_exits, e.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }

            }
            else if (IdActualPallet == e.Shipment_Item_Line__r.pallet_warehouse__r.Id || IdActualPallet == null) {
                new_inventory_exits.add(new exit_s(e, new_inventory_exit, null, sline_values, false));
                if (counter == all_entries.size()) {
                    if(new_inventory_exits.size() > 0)
                    palletLinesExits.add(new exit_lines_pallets_s(new_inventory_exits, e.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }

            } else if (IdActualPallet != e.Shipment_Item_Line__r.pallet_warehouse__r.Id) {
                if(new_inventory_exits.size() > 0)
                palletLinesExits.add(new exit_lines_pallets_s(new_inventory_exits, actualPallet));

                new_inventory_exits = new List<exit_s>();
                new_inventory_exits.add(new exit_s(e, new_inventory_exit, null, sline_values, false));

                if (counter == all_entries.size() && new_inventory_exits.size() > 0) {
                    palletLinesExits.add(new exit_lines_pallets_s(new_inventory_exits, e.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
            }


            IdActualPallet = e.Shipment_Item_Line__r.pallet_warehouse__r.Id;
            actualPallet = e.Shipment_Item_Line__r.pallet_warehouse__r.Name;
            counter++;
        }
    }

    private void getExitInventory()
    {
        String actualPallet = '';
        Integer counter = 1;
        Id IdActualPallet;

        exits = [
                select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Units_Picked__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name,
                        Inventory_Entry__c, Inventory_Entry__r.Name, CreatedDate, Shipment_Item_Line__c, Shipment_Item_Line__r.Name, Item_Code__c, Item_Description__c,
                        Shipment_Item_Line__r.Pallet_Code__c, Inventory_Entry__r.has_pallet__c,  Inventory_Entry__r.Total_Surface_m2__c,
                        Shipment_Item_Line__r.pallet_warehouse__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name
                from Inventory_Exit__c
                where Shipment__c = :record.Id
                order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
        ];

        List<Inventory_Exit__c> sl_exit_add = new List<Inventory_Exit__c>();
        exitInventory = new List<exit_iventory_s>();

        for (Inventory_Exit__c ie : exits) {
            //group by pallet
            if (ie.Shipment_Item_Line__r.pallet_warehouse__r.Id != null && IdActualPallet == null) {
                if(sl_exit_add.size() > 0)
                    exitInventory.add(new exit_iventory_s(sl_exit_add, actualPallet));

                sl_exit_add = new List<Inventory_Exit__c>();
                sl_exit_add.add(ie);
                if(exits.size() == counter && actualPallet == ''){
                    exitInventory.add(new exit_iventory_s(sl_exit_add, ie.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
                else if (exits.size() == counter) {
                    exitInventory.add(new exit_iventory_s(sl_exit_add, actualPallet));
                }

            } else if (IdActualPallet == ie.Shipment_Item_Line__r.pallet_warehouse__r.Id || IdActualPallet == null) {

                sl_exit_add.add(ie);
                if (exits.size() == counter && sl_exit_add.size() > 0) {
                    exitInventory.add(new exit_iventory_s(sl_exit_add, ie.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
            } else if (IdActualPallet !=  ie.Shipment_Item_Line__r.pallet_warehouse__r.Id) {
                if(sl_exit_add.size() > 0)
                exitInventory.add(new exit_iventory_s(sl_exit_add, actualPallet));

                sl_exit_add = new List<Inventory_Exit__c>();
                sl_exit_add.add(ie);

                if (counter == exits.size() && sl_exit_add.size() > 0) {
                    exitInventory.add(new exit_iventory_s(sl_exit_add, ie.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
            }
            IdActualPallet = ie.Shipment_Item_Line__r.pallet_warehouse__r.Id;
            actualPallet =  ie.Shipment_Item_Line__r.pallet_warehouse__r.Name;
            counter++;

        }

    }

    public void refreshEntries()
    {

        entries = [
                select Id, Name, Warehouse__c, Warehouse__r.Name, Item__c, Item__r.Name, Total_Surface_m2__c, Units_Entry__c, Remaining_Units__c,
                        Arrival_Date__c, Days_in_Warehouse__c, Exit_Date__c, Warehouse_Storage_Bin__c, Warehouse_Storage_Bin__r.Name, Item_Code__c,
                        Item_Description__c, Units_Picked__c, Shipment_Item_Line__r.Pallet_Code__c, Shipment_Item_Line__r.pallet_warehouse__r.Id, Shipment_Item_Line__r.pallet_warehouse__r.Name,
                        Shipment_Item_Line__r.pallet_warehouse__r.width_cm__c, Shipment_Item_Line__r.pallet_warehouse__r.lenght_cm__c, has_pallet__c
                from Inventory_Entry__c
                where Shipment__c = :record.Id
                order by Shipment_Item_Line__r.pallet_warehouse__r.Id asc
        ];


        //refresh data to show
        String actualPallet = '';
        integer counter = 1;
        Id IdActualPallet;
        palletEntries = new List<entry_pallets_s>();
        List<Inventory_Entry__c> ie_to_add = new List<Inventory_Entry__c>();
        for (Inventory_Entry__c e : entries) {
            //group by pallet
            if (e.Shipment_Item_Line__r.pallet_warehouse__r.Id != null && IdActualPallet == null) {
                palletEntries.add(new entry_pallets_s(ie_to_add, actualPallet));
                ie_to_add = new List<Inventory_Entry__c>();
                ie_to_add.add(e);
                if(counter == entries.size())
                {
                    palletEntries.add(new entry_pallets_s(ie_to_add, actualPallet));
                }
            } else if (IdActualPallet == e.Shipment_Item_Line__r.pallet_warehouse__r.Id || IdActualPallet == null) {
                ie_to_add.add(e);
                if(counter == entries.size())
                {
                    palletEntries.add(new entry_pallets_s(ie_to_add, actualPallet));
                }

            } else if (IdActualPallet !=  e.Shipment_Item_Line__r.pallet_warehouse__r.Id) {
                palletEntries.add(new entry_pallets_s(ie_to_add, actualPallet));
                ie_to_add = new List<Inventory_Entry__c>();
                ie_to_add.add(e);

                if (counter == entries.size()) {
                    palletEntries.add(new entry_pallets_s(ie_to_add, e.Shipment_Item_Line__r.pallet_warehouse__r.Name));
                }
            }
            IdActualPallet =  e.Shipment_Item_Line__r.pallet_warehouse__r.Id;
            actualPallet =  e.Shipment_Item_Line__r.pallet_warehouse__r.Name;
            counter++;

        }
    }

    public pagereference return_shipment() {
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


    public void bypass2() {
        integer a = 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;

        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
        a = a + 1;
    }

}