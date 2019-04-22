codeunit 81000 "LookupValue UT Customer"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";

        //[FEATURE] LookupValue UT Customer

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
        //(2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail

    [Test]
    procedure AssignLookupValueToCustomer()
    //[FEATURE] LookupValue UT Customer
    var
        Customer: Record Customer;
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0001] Assign lookup value to customer

        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] A customer
        CreateCustomer(Customer);

        //[WHEN] Set lookup value on customer
        SetLookupValueOnCustomer(Customer, LookupValueCode);

        //[THEN] Customer has lookup value field populated
        VerifyLookupValueOnCustomer(Customer."No.", LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToCustomer()
    //[FEATURE] LookupValue UT Customer
    var
        Customer: Record Customer;
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0002] Assign non-existing lookup value to customer

        //[GIVEN] A non-existing lookup value
        LookupValueCode := 'SC #0002';
        //[GIVEN] A customer record variable
        // See local variable Customer

        //[WHEN] Set non-existing lookup value on customer
        asserterror SetLookupValueOnCustomer(Customer, LookupValueCode);

        //[THEN] Non existing lookup value error thrown
        VerifyNonExistingLookupValueError(LookupValueCode);
    end;

    [Test]
    [HandlerFunctions('HandleConfigTemplates')]
    procedure AssignLookupValueToCustomerCard()
    //[FEATURE] LookupValue UT Customer UI
    var
        CustomerCard: TestPage "Customer Card";
        CustomerNo: Code[20];
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0003] Assign lookup value on customer card

        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] A customer card
        CreateCustomerCard(CustomerCard);

        //[WHEN] Set lookup value on customer card
        CustomerNo := SetLookupValueOnCustomerCard(CustomerCard, LookupValueCode);

        //[THEN] Customer has lookup value field populated
        VerifyLookupValueOnCustomer(CustomerNo, LookupValueCode);
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

    local procedure CreateCustomer(var Customer: record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;

    local procedure SetLookupValueOnCustomer(var Customer: record Customer; LookupValueCode: Code[10])
    begin
        with Customer do begin
            Validate("Lookup Value Code", LookupValueCode);
            Modify();
        end;
    end;

    local procedure CreateCustomerCard(var CustomerCard: TestPage "Customer Card")
    begin
        CustomerCard.OpenNew();
    end;

    local procedure SetLookupValueOnCustomerCard(var CustomerCard: TestPage "Customer Card"; LookupValueCode: Code[10]) CustomerNo: Code[20]
    begin
        with CustomerCard do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            CustomerNo := "No.".Value();
            Close();
        end;
    end;

    local procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    var
        Customer: Record Customer;
        FieldOnTableTxt: Label '%1 on %2';
    begin
        with Customer do begin
            Get(CustomerNo);
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
        Customer: Record Customer;
        LookupValue: Record LookupValue;
        ValueCannotBeFoundInTableTxt: Label 'The field %1 of table %2 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        with Customer do
            Assert.ExpectedError(
                StrSubstNo(
                    ValueCannotBeFoundInTableTxt,
                    FieldCaption("Lookup Value Code"),
                    TableCaption(),
                    LookupValueCode,
                    LookupValue.TableCaption()));
    end;

    [ModalPageHandler]
    procedure HandleConfigTemplates(var ConfigTemplates: TestPage "Config Templates")
    begin
        ConfigTemplates.OK.Invoke();
    end;
}