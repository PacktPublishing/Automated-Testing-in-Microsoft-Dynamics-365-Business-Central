codeunit 81001 "LookupValue UT Sales Document"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";
        isInitialized: Boolean;
        LookupValueCode: Code[10];

        //[FEATURE] LookupValue UT Sales Document

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
        //(2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail

    [Test]
    procedure AssignLookupValueToSalesHeader()
    //[FEATURE] LookupValue UT Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        //[SCENARIO #0004] Assign lookup value to sales header
        Initialize();

        //[GIVEN] A lookup value

        //[GIVEN] A sales header
        CreateSalesHeader(SalesHeader);

        //[WHEN] Set lookup value on sales header
        SetLookupValueOnSalesHeader(SalesHeader, LookupValueCode);

        //[THEN] Sales header has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type", SalesHeader."No.", LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToSalesHeader()
    //[FEATURE] LookupValue UT Sales Document
    var
        SalesHeader: Record "Sales Header";
        NonExistingLookupValueCode: Code[10];
    begin
        //[SCENARIO #0005] Assign non-existing lookup value on sales header

        //[GIVEN] A non-existing lookup value
        NonExistingLookupValueCode := 'SC #0005';
        //[GIVEN] A sales header record variable
        // See local variable SalesHeader

        //[WHEN] Set non-existing lookup value to sales header
        asserterror SetLookupValueOnSalesHeader(SalesHeader, NonExistingLookupValueCode);

        //[THEN] Non existing lookup value error was thrown
        VerifyNonExistingLookupValueError(NonExistingLookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToSalesQuoteDocument()
    //[FEATURE] LookupValue UT Sales Document UI
    var
        SalesHeader: Record "Sales Header";
        SalesDocument: TestPage "Sales Quote";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0006] Assign lookup value on sales quote document page

        //[GIVEN] A lookup value
        Initialize();

        //[GIVEN] A sales quote document page
        CreateSalesQuoteDocument(SalesDocument);

        //[WHEN] Set lookup value on sales quote document
        DocumentNo := SetLookupValueOnSalesQuoteDocument(SalesDocument, LookupValueCode);

        //[THEN] Sales quote has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type"::Quote, DocumentNo, LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToSalesOrderDocument()
    //[FEATURE] LookupValue UT Sales Document UI
    var
        SalesHeader: Record "Sales Header";
        SalesDocument: TestPage "Sales Order";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0007] Assign lookup value on sales order document page

        //[GIVEN] A lookup value
        Initialize();

        //[GIVEN] A sales order document page
        CreateSalesOrderDocument(SalesDocument);

        //[WHEN] Set lookup value on sales order document
        DocumentNo := SetLookupValueOnSalesOrderDocument(SalesDocument, LookupValueCode);

        //[THEN] Sales order has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type"::Order, DocumentNo, LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToSalesInvoiceDocument()
    //[FEATURE] LookupValue UT Sales Document UI
    var
        SalesHeader: Record "Sales Header";
        SalesDocument: TestPage "Sales Invoice";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0008] Assign lookup value on sales invoice document page

        //[GIVEN] A lookup value
        Initialize();

        //[GIVEN] A sales invoice document page
        CreateSalesInvoiceDocument(SalesDocument);

        //[WHEN] Set lookup value on sales invoice document
        DocumentNo := SetLookupValueOnSalesInvoiceDocument(SalesDocument, LookupValueCode);

        //[THEN] Sales invoice has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type"::Invoice, DocumentNo, LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToSalesCreditMemoDocument()
    //[FEATURE] LookupValue UT Sales Document UI
    var
        SalesHeader: Record "Sales Header";
        SalesDocument: TestPage "Sales Credit Memo";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0009] Assign lookup value on sales credit memo document page

        //[GIVEN] A lookup value
        Initialize();

        //[GIVEN] A sales credit memo document page
        CreateSalesCreditMemoDocument(SalesDocument);

        //[WHEN] Set lookup value on sales credit memo document
        DocumentNo := SetLookupValueOnSalesCreditMemoDocument(SalesDocument, LookupValueCode);

        //[THEN] Sales credit memo has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type"::"Credit Memo", DocumentNo, LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToSalesReturnOrderDocument()
    //[FEATURE] LookupValue UT Sales Document UI
    var
        SalesHeader: Record "Sales Header";
        SalesDocument: TestPage "Sales Return Order";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0010] Assign lookup value on sales return order document page

        //[GIVEN] A lookup value
        Initialize();

        //[GIVEN] A sales return order document page
        CreateSalesReturnOrderDocument(SalesDocument);

        //[WHEN] Set lookup value on sales return order document
        DocumentNo := SetLookupValueOnSalesReturnOrderDocument(SalesDocument, LookupValueCode);

        //[THEN] Sales return order has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type"::"Return Order", DocumentNo, LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToBlanketSalesOrderDocument()
    //[FEATURE] LookupValue UT Sales Document UI
    var
        SalesHeader: Record "Sales Header";
        SalesDocument: TestPage "Blanket Sales Order";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0011] Assign lookup value on blanket sales order document page

        //[GIVEN] A lookup value
        Initialize();

        //[GIVEN] A blanket sales order document page
        CreateBlanketSalesOrderDocument(SalesDocument);

        //[WHEN] Set lookup value on blanket sales order document
        DocumentNo := SetLookupValueOnBlanketSalesOrderDocument(SalesDocument, LookupValueCode);

        //[THEN] Blanket sales order has lookup value code field populated
        VerifyLookupValueOnSalesHeader(SalesHeader."Document Type"::"Blanket Order", DocumentNo, LookupValueCode);
    end;

    local procedure Initialize()
    begin
        if isInitialized then
            exit;

        LookupValueCode := CreateLookupValueCode();

        isInitialized := true;
        Commit();
    end;

    local procedure CreateLookupValueCode(): Code[10]
    var
        LookupValue: Record LookupValue;
    begin
        with LookupValue do begin
            Init();
            Validate(
                Code,
                LibraryUtility.GenerateRandomCode(FIELDNO(Code),
                Database::LookupValue));
            Validate(Description, Code);
            Insert();
            exit(Code);
        end;
    end;

    local procedure CreateSalesHeader(var SalesHeader: record "Sales Header")
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Invoice, '');
    end;

    local procedure SetLookupValueOnSalesHeader(var SalesHeader: record "Sales Header"; LookupValueCode: Code[10])
    begin
        with SalesHeader do begin
            Validate("Lookup Value Code", LookupValueCode);
            Modify();
        end;
    end;

    local procedure CreateSalesQuoteDocument(var SalesDocument: TestPage "Sales Quote")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnSalesQuoteDocument(var SalesDocument: TestPage "Sales Quote"; LookupValueCode: Code[10]) DocumentNo: Code[20]
    begin
        with SalesDocument do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            DocumentNo := "No.".Value();
            Close();
        end;
    end;

    local procedure CreateSalesOrderDocument(var SalesDocument: TestPage "Sales Order")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnSalesOrderDocument(var SalesDocument: TestPage "Sales Order"; LookupValueCode: Code[10]) DocumentNo: Code[20]
    begin
        with SalesDocument do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            DocumentNo := "No.".Value();
            Close();
        end;
    end;

    local procedure CreateSalesInvoiceDocument(var SalesDocument: TestPage "Sales Invoice")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnSalesInvoiceDocument(var SalesDocument: TestPage "Sales Invoice"; LookupValueCode: Code[10]) DocumentNo: Code[20]
    begin
        with SalesDocument do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            DocumentNo := "No.".Value();
            Close();
        end;
    end;

    local procedure CreateSalesCreditMemoDocument(var SalesDocument: TestPage "Sales Credit Memo")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnSalesCreditMemoDocument(var SalesDocument: TestPage "Sales Credit Memo"; LookupValueCode: Code[10]) DocumentNo: Code[20]
    begin
        with SalesDocument do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            DocumentNo := "No.".Value();
            Close();
        end;
    end;

    local procedure CreateSalesReturnOrderDocument(var SalesDocument: TestPage "Sales Return Order")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnSalesReturnOrderDocument(var SalesDocument: TestPage "Sales Return Order"; LookupValueCode: Code[10]) DocumentNo: Code[20]
    begin
        with SalesDocument do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            DocumentNo := "No.".Value();
            Close();
        end;
    end;

    local procedure CreateBlanketSalesOrderDocument(var SalesDocument: TestPage "Blanket Sales Order")
    begin
        SalesDocument.OpenNew();
    end;

    local procedure SetLookupValueOnBlanketSalesOrderDocument(var SalesDocument: TestPage "Blanket Sales Order"; LookupValueCode: Code[10]) DocumentNo: Code[20]
    begin
        with SalesDocument do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            DocumentNo := "No.".Value();
            Close();
        end;
    end;

    local procedure VerifyLookupValueOnSalesHeader(DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        SalesHeader: Record "Sales Header";
        FieldOnTableTxt: Label '%1 on %2';
    begin
        with SalesHeader do begin
            Get(DocumentType, DocumentNo);
            Assert.AreEqual(
                LookupValueCode,
                "Lookup Value Code",
                StrSubstNo(
                    FieldOnTableTxt,
                    FieldCaption("Lookup Value Code"),
                    TableCaption())
                );
        end;
    end;

    local procedure VerifyNonExistingLookupValueError(LookupValueCode: Code[10])
    var
        SalesHeader: Record "Sales Header";
        LookupValue: Record LookupValue;
        ValueCannotBeFoundInTableTxt: Label 'The field %1 of table %2 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        with SalesHeader do
            Assert.ExpectedError(
                StrSubstNo(
                    ValueCannotBeFoundInTableTxt,
                    FieldCaption("Lookup Value Code"),
                    TableCaption(),
                    LookupValueCode,
                    LookupValue.TableCaption()));
    end;
}