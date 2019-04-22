codeunit 81005 "LookupValue Posting"
{
    Subtype = Test;

    var
        DefaultLocation: Record Location;
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryWarehouse: Codeunit "Library - Warehouse";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;

        //[FEATURE] LookupValue Posting

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail

    [Test]
    procedure PostSalesOrderWithLookupValue();
    //[FEATURE] LookupValue Posting Sales Document
    var
        SalesHeader: record "Sales Header";
        PostedSaleInvoiceNo: Code[20];
        SalesShipmentNo: Code[20];
    begin
        //[SCENARIO #0022] Check that posted sales invoice and shipment inherit lookup value from sales order
        Initialize();

        //[GIVEN] A sales order with a lookup value
        CreateSalesOrder(SalesHeader, UseLookupValue());

        //[WHEN] Sales order is posted (invoice & ship)
        PostSalesDocument(SalesHeader, PostedSaleInvoiceNo, SalesShipmentNo);

        //[THEN] Posted sales invoice has lookup value from sales order
        VerifyLookupValueOnPostedSalesInvoice(PostedSaleInvoiceNo, SalesHeader."Lookup Value Code");
        //[THEN] Sales shipment has lookup value from sales order
        VerifyLookupValueOnSalesShipment(SalesShipmentNo, SalesHeader."Lookup Value Code");
    end;

    [Test]
    procedure PostSalesOrderWithNoLookupValue();
    //[FEATURE] LookupValue Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
        PostedSaleInvoiceNo: Code[20];
        SalesShipmentNo: Code[20];
    begin
        //[SCENARIO #0027] Check posting throws error on sales order with empty lookup value
        Initialize();

        //[GIVEN] A sales order without a lookup value
        CreateSalesOrder(SalesHeader, UseNoLookupValue());

        //[WHEN] Sales order is posted (invoice & ship)
        asserterror PostSalesDocument(SalesHeader, PostedSaleInvoiceNo, SalesShipmentNo);

        //[THEN] Missing lookup value on sales order error thrown
        VerifyMissingLookupValueOnSalesOrderError(SalesHeader);
    end;

    [Test]
    procedure PostWarehouseShipmentFromSalesOrderWithLookupValue();
    //[FEATURE] LookupValue Posting Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
        WarehouseShipmentNo: Code[20];
        PostedWarehouseShipmentNo: Code[20];
    begin
        //[SCENARIO #0023] Check that posted warehouse shipment line inherits lookup value from sales order through warehouse shipment line

        //[GIVEN] A location with require shipment
        //[GIVEN] A warehouse employee for current user
        Initialize();

        //[GIVEN] A warehouse shipment line with a lookup value created from a sales order
        WarehouseShipmentNo := CreateWarehouseShipmentFromSalesOrder(SalesHeader, UseLookupValue());

        //[WHEN] Warehouse shipment is posted
        PostedWarehouseShipmentNo := PostWarehouseShipment(WarehouseShipmentNo);

        //[THEN] Posted warehouse shipment line has lookup value from warehouse shipment line
        VerifyLookupValueOnPostedWarehouseShipmentLine(PostedWarehouseShipmentNo, SalesHeader."Lookup Value Code");
    end;

    [Test]
    procedure PostWarehouseShipmentFromSalesOrderWithNoLookupValue();
    //[FEATURE] LookupValue Posting Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
        WarehouseShipmentNo: Code[20];
        PostedWarehouseShipmentNo: Code[20];
    begin
        //[SCENARIO #0025] Check posting throws error on sales order with empty lookup value

        //[GIVEN] A location with require shipment
        //[GIVEN] A warehouse employee for current user
        Initialize();

        //[GIVEN] A warehouse shipment created from a sales order without lookup value
        WarehouseShipmentNo := CreateWarehouseShipmentFromSalesOrder(SalesHeader, UseNoLookupValue());

        //[WHEN] Warehouse shipment is posted
        asserterror PostedWarehouseShipmentNo := PostWarehouseShipment(WarehouseShipmentNo);

        //[THEN] Missing lookup value on sales order error thrown
        VerifyMissingLookupValueOnSalesOrderError(SalesHeader);
    end;

    local procedure UseLookupValue(): Boolean
    begin
        exit(true)
    end;

    local procedure UseNoLookupValue(): Boolean
    begin
        exit(false)
    end;

    local procedure Initialize()
    var
        LibraryTestsSetup: Codeunit "Library - Tests Setup";
    begin
        if isInitialized then
            exit;

        LibraryTestsSetup.SetSkipOnAfterCreateCustomer(true);
        LocationSetup();

        isInitialized := true;
        Commit();
    end;

    local procedure LocationSetup();
    begin
        CreateAndUpdateLocation(DefaultLocation, false, false, false, true, false);  // Location Blue with Require Shipment.
    end;

    local procedure CreateAndUpdateLocation(var Location: Record Location; RequirePutAway: Boolean; RequirePick: Boolean; RequireReceive: Boolean; RequireShipment: Boolean; BinMandatory: Boolean);
    var
        WarehouseEmployee: Record "Warehouse Employee";
    begin
        LibraryWarehouse.CreateLocationWMS(Location, BinMandatory, RequirePutAway, RequirePick, RequireReceive, RequireShipment);
        LibraryWarehouse.CreateWarehouseEmployee(WarehouseEmployee, Location.Code, false);
    end;

    local procedure CreateSalesOrder(var SalesHeader: record "Sales Header"; WithLookupValue: Boolean)
    var
        SalesLine: record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, CreateCustomerNo());
        CreateSalesLine(SalesHeader, SalesLine, SalesLine.Type::Item, '', 1, DefaultLocation."Code");

        with SalesHeader do
            if WithLookupValue then begin
                Validate("Lookup Value Code", CreateLookupValueCode());
                Modify();
            end;
    end;

    local procedure CreateCustomerNo(): code[20]
    begin
        exit(LibrarySales.CreateCustomerNo());
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; Type: Option; ItemNo: Code[20]; Quantity: Decimal; LocationCode: Code[10]);
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Type, ItemNo, Quantity);
        with SalesLine do begin
            Validate("Location Code", LocationCode);
            Validate("Qty. to Ship", Quantity);
            Validate("Qty. to Invoice", Quantity);
            Validate("Unit Price", LibraryRandom.RandInt(50));
            Modify(true);
        end;
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure PostSalesDocument(var SalesHeader: record "Sales Header"; var PostedSaleInvoiceNo: Code[20]; var SalesShipmentNo: Code[20])
    begin
        LibrarySales.PostSalesDocument(SalesHeader, true, true);
        PostedSaleInvoiceNo := FindPostedSalesOrderToInvoice(SalesHeader."No.");
        SalesShipmentNo := FindPostedSalesOrderToShipment(SalesHeader."No.")
    end;

    local procedure FindPostedSalesOrderToInvoice(OrderNo: Code[20]): Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        with SalesInvoiceHeader do begin
            SetRange("Order No.", OrderNo);
            FindFirst();
            exit("No.");
        end;
    end;

    local procedure FindPostedSalesOrderToShipment(OrderNo: Code[20]): Code[20]
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        with SalesShipmentHeader do begin
            SetRange("Order No.", OrderNo);
            FindFirst();
            exit("No.");
        end;
    end;

    local procedure CreateWarehouseShipmentFromSalesOrder(var SalesHeader: Record "Sales Header"; WithLookupValue: Boolean) WarehouseShipmentNo: Code[20]
    begin
        CreateSalesOrder(SalesHeader, WithLookupValue);
        LibrarySales.ReleaseSalesDocument(SalesHeader);
        WarehouseShipmentNo := CreateWarehouseShipment(SalesHeader);
    end;

    local procedure CreateWarehouseShipment(SalesHeader: Record "Sales Header"): Code[20]
    var
        WarehouseShipmentHeader: record "Warehouse Shipment Header";
    begin
        LibraryWarehouse.CreateWhseShipmentFromSO(SalesHeader);
        GetWarehouseShipmentHeader(WarehouseShipmentHeader, SalesHeader."No.");
        exit(WarehouseShipmentHeader."No.");
    end;

    // local procedure CreateAndRegisterPick(SalesHeaderNo: Code[20]);
    // var
    //     WarehouseActivityLine: Record "Warehouse Activity Line";
    // begin
    //     CreatePick(SalesHeaderNo);
    //     RegisterWarehouseActivity(
    //         WarehouseActivityLine."Source Document"::"Sales Order",
    //         SalesHeaderNo,
    //         WarehouseActivityLine."Activity Type"::Pick);
    // end;

    local procedure CreatePick(SourceNo: Code[20]);
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        GetWarehouseShipmentHeader(WarehouseShipmentHeader, SourceNo);
        LibraryWarehouse.CreatePick(WarehouseShipmentHeader);
    end;

    local procedure GetWarehouseShipmentHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SourceNo: Code[20])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, SourceNo);
        WarehouseShipmentHeader.Get(WarehouseShipmentLine."No.");
    end;

    local procedure FindWarehouseShipmentLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SourceNo: Code[20])
    begin
        with WarehouseShipmentLine do begin
            Setrange("Source Document", "Source Document"::"Sales Order");
            Setrange("Source No.", SourceNo);
            FindFirst();
        end;
    end;

    local procedure RegisterWarehouseActivity(SourceDocument: Option; SourceNo: Code[20]; ActivityType: Option)
    var
        WarehouseActivityHeader: Record "Warehouse Activity Header";
        WarehouseActivityLine: Record "Warehouse Activity Line";
    begin
        FindWarehouseActivityLine(WarehouseActivityLine, SourceDocument, SourceNo, ActivityType);
        WarehouseActivityLine.AutofillQtyToHandle(WarehouseActivityLine);
        WarehouseActivityHeader.Get(WarehouseActivityLine."Activity Type", WarehouseActivityLine."No.");
        LibraryWarehouse.RegisterWhseActivity(WarehouseActivityHeader);
    end;

    local procedure FindWarehouseActivityLine(var WarehouseActivityLine: Record "Warehouse Activity Line"; SourceDocument: Option; SourceNo: Code[20]; ActivityType: Option)
    begin
        with WarehouseActivityLine do begin
            Setrange("Source Document", SourceDocument);
            Setrange("Source No.", SourceNo);
            Setrange("Activity Type", ActivityType);
            FindFirst();
        end;
    end;

    local procedure PostWarehouseShipment(DocumentNo: Code[20]) PostedWarehouseShipmentNo: Code[20]
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        WarehouseShipmentHeader.Get(DocumentNo);
        LibraryWarehouse.PostWhseShipment(WarehouseShipmentHeader, false);
        PostedWarehouseShipmentNo := FindPostedWhsShipmentToWhsShipment(DocumentNo);
    end;

    local procedure FindPostedWhsShipmentToWhsShipment(DocumentNo: Code[20]): Code[20];
    var
        PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header";
    begin
        with PostedWhseShipmentHeader do begin
            SetRange("Whse. Shipment No.", DocumentNo);
            FindFirst();
            exit("No.");
        end;
    end;

    local procedure VerifyLookupValueOnPostedSalesInvoice(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        with SalesInvoiceHeader do begin
            Get(DocumentNo);
            Assert.AreEqual(
                "Lookup Value Code",
                LookupValueCode,
                LibraryMessages.GetFieldOnTableTxt(
                    FieldCaption("Lookup Value Code"),
                    TableCaption()));
        end;
    end;

    local procedure VerifyLookupValueOnSalesShipment(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        with SalesShipmentHeader do begin
            Get(DocumentNo);
            Assert.AreEqual(
                LookupValueCode,
                "Lookup Value Code",
                LibraryMessages.GetFieldOnTableTxt(
                    FieldCaption("Lookup Value Code"),
                    TableCaption()));
        end;
    end;

    local procedure VerifyLookupValueOnPostedWarehouseShipmentLine(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
    begin
        with PostedWhseShipmentLine do begin
            SetRange("No.", DocumentNo);
            FindFirst();
            Assert.AreEqual(
                LookupValueCode,
                "Lookup Value Code",
                LibraryMessages.GetFieldOnTableTxt(
                    FieldCaption("Lookup Value Code"),
                    TableCaption()));
        end;
    end;

    local procedure VerifyMissingLookupValueOnSalesOrderError(SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do
            Assert.ExpectedError(
                LibraryMessages.GetFieldMustHaveValueInSalesHeaderTxt(
                    FieldCaption("Lookup Value Code"),
                    SalesHeader));
    end;
}