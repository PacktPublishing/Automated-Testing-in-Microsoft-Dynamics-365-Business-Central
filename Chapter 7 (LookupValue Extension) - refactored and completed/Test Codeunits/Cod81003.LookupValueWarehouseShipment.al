codeunit 81003 "LookupValue Warehouse Shipment"
{
    Subtype = Test;

    var
        DefaultLocation: Record Location;
        Assert: Codeunit Assert;
        LibraryRandom: Codeunit "Library - Random";
        LibrarySales: Codeunit "Library - Sales";
        LibraryWarehouse: Codeunit "Library - Warehouse";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;
        LookupValueCode: Code[10];

        //[FEATURE] LookupValue Warehouse Shipment

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
        //(2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail

    [Test]
    procedure AssignLookupValueToWarehouseShipmentLine()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesOrderNo: Code[20];
    begin
        //[SCENARIO #0015] Assign lookup value to warehouse shipment line on warehouse shipment page

        //[GIVEN] A lookup value
        //[GIVEN] A location with require shipment
        //[GIVEN] A warehouse employee for current user
        Initialize();
        //[GIVEN] A warehouse shipment from released sales order with line with require shipment location
        SalesOrderNo := CreateWarehouseShipmentFromSalesOrder(DefaultLocation, UseNoLookupValue());

        //[WHEN] Set lookup value on warehouse shipment line on warehouse shipment page
        FindAndSetLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToWarehouseShipmentHeader()
    //[FEATURE] LookupValue UT Warehouse Shipment
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        NoExistingLookupValueCode: Code[10];
    begin
        //[SCENARIO #0016] Assign non-existing lookup value on warehouse shipment line

        //[GIVEN] A non-existing lookup value
        NoExistingLookupValueCode := 'SC #0016';
        //[GIVEN] A warehouse shipment line record variable
        // See local variable WarehouseShipmentLine

        //[WHEN] Set non-existing lookup value to warehouse shipment line
        asserterror SetLookupValueOnWarehouseShipmentLine(WarehouseShipmentLine, NoExistingLookupValueCode);

        //[THEN] Non existing lookup value error was thrown
        VerifyNonExistingLookupValueError(NoExistingLookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToLineOnWarehouseShipmentDocument()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesOrderNo: Code[20];
    begin
        //[SCENARIO #0017] Assign lookup value to warehouse shipment line on warehouse shipment page

        //[GIVEN] A lookup value
        //[GIVEN] A location with require shipment
        //[GIVEN] A warehouse employee for current user
        Initialize();
        //[GIVEN] A warehouse shipment from released sales order with line with require shipment location
        SalesOrderNo := CreateWarehouseShipmentFromSalesOrder(DefaultLocation, UseNoLookupValue());

        //[WHEN] Set lookup value on warehouse shipment line on warehouse shipment document page
        SetLookupValueOnLineOnWarehouseShipmentDocumentPage(SalesOrderNo);

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);
    end;

    [Test]
    procedure CreateWarehouseShipmentFromSalesOrderWithLookupValue()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesOrderNo: Code[20];
    begin
        //[SCENARIO #0030] Create warehouse shipment from sales order with lookup value
        //[GIVEN] A lookup value
        //[GIVEN] A location with require shipment
        //[GIVEN] A warehouse employee for current user
        Initialize();

        //[WHEN] Create warehouse shipment from released sales order with lookup value and with line with require shipment location
        SalesOrderNo := CreateWarehouseShipmentFromSalesOrder(DefaultLocation, UseLookupValue());

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);
    end;

    [Test]
    procedure GetSalesOrderWithLookupValueOnWarehouseShipment()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
        WarehouseShipmentNo: Code[20];
    begin
        //[SCENARIO #0031] Get sales order with lookup value on warehouse shipment

        //[GIVEN] A lookup value
        //[GIVEN] A location with require shipment
        //[GIVEN] A warehouse employee for current user
        Initialize();
        //[GIVEN] A released sales order with lookup value and with line with require shipment location
        CreateAndReleaseSalesOrder(SalesHeader, DefaultLocation, UseLookupValue());
        //[GIVEN] A warehouse shipment without lines
        WarehouseShipmentNo := CreateWarehouseShipmentWithOutLines(DefaultLocation."Code");

        //[WHEN] Get sales order with lookup value on warehouse shipment
        GetSalesOrderShipment(WarehouseShipmentNo);

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesHeader."No.", LookupValueCode);
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
        WarehouseEmployee: Record "Warehouse Employee";
    begin
        if isInitialized then
            exit;

        LookupValueCode := LibraryLookupValue.CreateLookupValueCode();
        LibraryWarehouse.CreateLocationWMS(DefaultLocation, false, false, false, false, true);
        LibraryWarehouse.CreateWarehouseEmployee(WarehouseEmployee, DefaultLocation."Code", false);

        isInitialized := true;
        Commit();
    end;

    local procedure CreateWarehouseShipmentFromSalesOrder(Location: Record Location; WithLookupValue: Boolean): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateAndReleaseSalesOrder(SalesHeader, Location, WithLookupValue);
        LibraryWarehouse.CreateWhseShipmentFromSO(SalesHeader);
        exit(SalesHeader."No.");
    end;

    local procedure CreateAndReleaseSalesOrder(var SalesHeader: record "Sales Header"; Location: Record Location; WithLookupValue: Boolean)
    var
        SalesLine: record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, '');
        CreateSalesLine(SalesHeader, SalesLine, SalesLine.Type::Item, '', 1, Location."Code");

        with SalesHeader do
            if WithLookupValue then begin
                Validate("Lookup Value Code", LookupValueCode);
                Modify();
            end;

        LibrarySales.ReleaseSalesDocument(SalesHeader);
    end;

    local procedure CreateSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; Type: Option; ItemNo: Code[20]; Qty: Decimal; LocationCode: Code[10]);
    begin
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, Type, ItemNo, Qty);
        with SalesLine do begin
            Validate("Location Code", LocationCode);
            Validate("Qty. to Ship", Qty);
            Validate("Qty. to Invoice", Qty);
            Validate("Unit Price", LibraryRandom.RandInt(50));
            Modify(true);
        end;
    end;

    local procedure FindWarehouseShipmentLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SourceNo: Code[20])
    begin
        with WarehouseShipmentLine do begin
            SetRange("Source Document", "Source Document"::"Sales Order");
            SetRange("Source No.", SourceNo);
            FindFirst();
        end;
    end;

    local procedure FindAndSetLookupValueOnWarehouseShipmentLine(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, DocumentNo);
        SetLookupValueOnWarehouseShipmentLine(WarehouseShipmentLine, LookupValueCode);
    end;

    local procedure SetLookupValueOnWarehouseShipmentLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; LookupValueCode: Code[10])
    begin
        with WarehouseShipmentLine do begin
            Validate("Lookup Value Code", LookupValueCode);
            Modify();
        end;
    end;

    local procedure SetLookupValueOnLineOnWarehouseShipmentDocumentPage(DocumentNo: Code[20])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WarehouseShipmentPage: TestPage "Warehouse Shipment";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, DocumentNo);
        with WarehouseShipmentPage do begin
            OpenEdit();
            GoToKey(WarehouseShipmentLine."No.");
            WhseShptLines.GoToKey(WarehouseShipmentLine."No.", WarehouseShipmentLine."Line No.");
            Assert.IsTrue(WhseShptLines."Lookup Value Code".Editable(), 'Editable');
            WhseShptLines."Lookup Value Code".SetValue(LookupValueCode);
            Close();
        end;
    end;

    local procedure CreateWarehouseShipmentWithOutLines(LocationCode: Code[10]): Code[20]
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        LibraryWarehouse.CreateWarehouseShipmentHeader(WarehouseShipmentHeader);
        with WarehouseShipmentHeader do begin
            Validate("Location Code", LocationCode);
            Modify();
            exit("No.");
        end;
    end;

    local procedure GetSalesOrderShipment(WarehouseShipmentNo: Code[20])
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseSourceFilter: Record "Warehouse Source Filter";
    begin
        with WarehouseShipmentHeader do begin
            Get(WarehouseShipmentNo);
            LibraryWarehouse.GetSourceDocumentsShipment(WarehouseShipmentHeader, WarehouseSourceFilter, "Location Code");
        end;
    end;

    local procedure VerifyLookupValueOnWarehouseShipmentLine(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, DocumentNo);
        with WarehouseShipmentLine do
            Assert.AreEqual(
                LookupValueCode,
                "Lookup Value Code",
                LibraryMessages.GetFieldOnTableTxt(
                    FieldCaption("Lookup Value Code"),
                    TableCaption()));
    end;

    local procedure VerifyNonExistingLookupValueError(LookupValueCode: Code[10])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        LookupValue: Record LookupValue;
    begin
        with WarehouseShipmentLine do
            Assert.ExpectedError(
                LibraryMessages.GetValueCannotBeFoundInTableTxt(
                    FieldCaption("Lookup Value Code"),
                    TableCaption(),
                    LookupValueCode,
                    LookupValue.TableCaption()));
    end;
}