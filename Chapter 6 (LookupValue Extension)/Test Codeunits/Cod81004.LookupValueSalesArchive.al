codeunit 81004 "LookupValue Sales Archive"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";

        //[FEATURE] LookupValue Sales Archive

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure ArchiveSalesOrderWithLookupValue();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
    begin
        //[SCENARIO #0018] Archive sales order with lookup value
        ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::Order)
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure ArchiveSalesQuoteWithLookupValue();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
    begin
        //[SCENARIO #0019] Archive sales quote with lookup value
        ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::Quote)
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure ArchiveSalesReturnOrderWithLookupValue();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
    begin
        //[SCENARIO #0020] Archive sales return order with lookup value
        ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::"Return Order")
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure FindLookupValueOnSalesListArchive();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0021] Check that lookup value is shown right on Sales List Archive
        //[GIVEN] A sales document with a lookup value
        //[WHEN] Sales document is archived
        //[THEN] Archived sales document has lookup value from sales document
        DocumentNo := ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::Order);
        //[THEN] LookupValue is shown right on Sales List Archive
        VerifyLookupValueOnSalesListArchive(SalesHeader."Document Type"::Order, DocumentNo);
    end;

    local procedure ArchiveSalesDocumentWithLookupValue(DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"): Code[20]
    var
        SalesHeader: record "Sales Header";
    begin
        //[GIVEN] A sales document with a lookup value
        CreateSalesDocumentWithLookupValue(SalesHeader, DocumentType);

        //[WHEN] Sales document is archived
        ArchiveSalesDocument(SalesHeader);

        //[THEN] Archived sales document has lookup value from sales document
        VerifyLookupValueOnSalesDocumentArchive(DocumentType, SalesHeader."No.", SalesHeader."Lookup Value Code", 1);  // Used 1 for No. of Archived Versions

        exit(SalesHeader."No.")
    end;

    local procedure CreateSalesDocumentWithLookupValue(var SalesHeader: record "Sales Header"; DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"): Code[20]
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');

        with SalesHeader do begin
            Validate("Lookup Value Code", CreateLookupValueCode());
            Modify();
            exit("Lookup Value Code")
        end;
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

    local procedure ArchiveSalesDocument(var SalesHeader: Record "Sales Header");
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.ArchiveSalesDocument(SalesHeader);
    end;

    local procedure VerifyLookupValueOnSalesDocumentArchive(DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; LookupValueCode: Code[20]; VersionNo: Integer);
    var
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        FindSalesDocumentArchive(SalesHeaderArchive, DocumentType, DocumentNo);
        SalesHeaderArchive.SetRange("Version No.", VersionNo);
        SalesHeaderArchive.FindFirst();
        Assert.AreEqual(LookupValueCode, SalesHeaderArchive."Lookup Value Code", '');
    end;

    local procedure VerifyLookupValueOnSalesListArchive(DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesListArchive: TestPage "Sales List Archive";
        FieldOnTableTxt: Label '%1 on %2';
    begin
        SalesHeaderArchive.Get(DocumentType, DocumentNo, 1, 1);  // Used 1 for Occurrence of Document No.  No. of Archived Versions
        SalesListArchive.OpenView();
        SalesListArchive.GoToRecord(SalesHeaderArchive);

        with SalesHeaderArchive do
            // Assert.AreEqual(
            //     "Lookup Value Code",
            //     SalesListArchive."Lookup Value Code".Value(),
            //     LibraryMessages.GetFieldOnTableTxt(FieldCaption("Lookup Value Code"), TableCaption()));
            Assert.AreEqual(
                "Lookup Value Code",
                SalesListArchive."Lookup Value Code".Value(),
                StrSubstNo(
                    FieldOnTableTxt,
                    FieldCaption("Lookup Value Code"),
                    TableCaption())
                );
    end;

    local procedure FindSalesDocumentArchive(var SalesHeaderArchive: Record "Sales Header Archive"; DocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        SalesHeaderArchive.SetRange("Document Type", DocumentType);
        SalesHeaderArchive.SetRange("No.", DocumentNo);
        SalesHeaderArchive.FindFirst();
    end;

    [ConfirmHandler]
    procedure ConfirmHandlerYes(Question: Text[1024]; var Reply: Boolean);
    begin
        // Just to handle the confirm
        Reply := true;
    end;

    [MessageHandler]
    procedure MessageHandler(Message: Text[1024]);
    begin
        // Just to handle the message
    end;
}