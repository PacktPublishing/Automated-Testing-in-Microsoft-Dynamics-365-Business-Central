codeunit 81002 "LookupValue UT Cust. Template"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibrarySales: Codeunit "Library - Sales";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;

        //[FEATURE] LookupValue UT Customer Template

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
        //(2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail


    [Test]
    procedure AssignLookupValueToCustomerTemplate()
    //[FEATURE] LookupValue UT Customer Template
    var
        CustomerTemplate: Record "Customer Template";
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #00012] Assign lookup value to customer

        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] A customer template
        CreateCustomerTemplate(CustomerTemplate);

        //[WHEN] Set lookup value on customer template
        SetLookupValueOnCustomerTemplate(CustomerTemplate, LookupValueCode);

        //[THEN] Customer template has lookup value code field populated
        VerifyLookupValueOnCustomerTemplate(CustomerTemplate.Code, LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToCustomerTemplate()
    //[FEATURE] LookupValue UT Customer Template
    var
        CustomerTemplate: Record "Customer Template";
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #00013] Assign non-existing lookup value to customer template

        //[GIVEN] A non-existing lookup value
        LookupValueCode := 'SC #0013';
        //[GIVEN] A customer template record variable
        // See local variable CustomerTemplate

        //[WHEN] Set non-existing lookup value to customer template
        asserterror SetLookupValueOnCustomerTemplate(CustomerTemplate, LookupValueCode);

        //[THEN] Non existing lookup value error was thrown
        VerifyNonExistingLookupValueError(LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToCustomerTemplateCard()
    //[FEATURE] LookupValue UT Customer Template UI
    var
        CustomerTemplateCard: TestPage "Customer Template Card";
        CustomerTemplateCode: Code[10];
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #00014] Assign lookup value on customer template card

        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] A customer template card
        CreateCustomerTemplateCard(CustomerTemplateCard);

        //[WHEN] Set lookup value on customer template card
        CustomerTemplateCode := SetLookupValueOnCustomerTemplateCard(CustomerTemplateCard, LookupValueCode);

        //[THEN] Customer template has lookup value code field populated
        VerifyLookupValueOnCustomerTemplate(CustomerTemplateCode, LookupValueCode);
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CreateCustomerTemplate(var CustomerTemplate: record "Customer Template")
    begin
        LibrarySales.CreateCustomerTemplate(CustomerTemplate);
    end;

    local procedure CreateCustomerTemplateCard(var CustomerTemplateCard: TestPage "Customer Template Card")
    var
        CustomerTemplate: Record "Customer Template";
    begin
        CustomerTemplateCard.OpenNew();
        CustomerTemplateCard.Code.SetValue(LibraryUtility.GenerateRandomCode(CustomerTemplate.FieldNo(Code), Database::"Customer Template"));
    end;

    local procedure SetLookupValueOnCustomerTemplate(var CustomerTemplate: record "Customer Template"; LookupValueCode: Code[10])
    begin
        with CustomerTemplate do begin
            Validate("Lookup Value Code", LookupValueCode);
            Modify();
        end;
    end;

    local procedure SetLookupValueOnCustomerTemplateCard(var CustomerTemplateCard: TestPage "Customer Template Card"; LookupValueCode: Code[10]) CustomerTemplateCode: Code[10]
    begin
        with CustomerTemplateCard do begin
            Assert.IsTrue("Lookup Value Code".Editable(), 'Editable');
            "Lookup Value Code".SetValue(LookupValueCode);
            CustomerTemplateCode := "Code".Value();
            Close();
        end;
    end;

    local procedure VerifyLookupValueOnCustomerTemplate(CustomerTemplateCode: Code[10]; LookupValueCode: Code[10])
    var
        CustomerTemplate: Record "Customer Template";
    begin
        with CustomerTemplate do begin
            Get(CustomerTemplateCode);
            Assert.AreEqual(LookupValueCode, "Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(FieldCaption("Lookup Value Code"), TableCaption()));
        end;
    end;

    local procedure VerifyNonExistingLookupValueError(LookupValueCode: Code[10])
    var
        CustomerTemplate: Record "Customer Template";
        LookupValue: Record LookupValue;
    begin
        with CustomerTemplate do
            Assert.ExpectedError(
                LibraryMessages.GetValueCannotBeFoundInTableTxt(
                    FieldCaption("Lookup Value Code"),
                    TableCaption(),
                    LookupValueCode,
                    LookupValue.TableCaption()));
    end;
}