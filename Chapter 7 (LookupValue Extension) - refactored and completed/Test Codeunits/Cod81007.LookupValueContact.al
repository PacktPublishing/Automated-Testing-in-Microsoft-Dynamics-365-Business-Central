codeunit 81007 "LookupValue Contact"
{
    Subtype = Test;

    var
        Assert: Codeunit Assert;
        LibrarySales: Codeunit "Library - Sales";
        LibraryMarketing: Codeunit "Library - Marketing";
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;

        //[FEATURE] LookupValue Contact

        //Instruction NOTES
        //(1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail

    [Test]
    procedure CreateCustomerFromContactWithLookupValue()
    //[FEATURE] LookupValue Contact
    var
        Contact: Record Contact;
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Template";
    begin
        //[SCENARIO #0026] Check that lookup value is inherited from customer template to customer when creating customer from contact

        //[GIVEN] A customer template with lookup value
        CreateCustomerTemplate(CustomerTemplate, UseLookupValue());
        //[GIVEN] A contact
        CreateCompanyContact(Contact);

        //[WHEN] Customer is created from contact
        CreateCustomerFromContact(Contact, CustomerTemplate.Code, Customer);

        //[THEN] Customer has lookup value code field populated with lookup value from customer template
        VerifyLookupValueOnCustomer(Customer."No.", CustomerTemplate."Lookup Value Code");
    end;

    local procedure CreateCustomerTemplate(var CustomerTemplate: Record "Customer Template"; WithLookupValue: Boolean): Code[10]
    begin
        LibrarySales.CreateCustomerTemplate(CustomerTemplate);

        with CustomerTemplate do begin
            if WithLookupValue then begin
                Validate("Lookup Value Code", CreateLookupValueCode());
                Modify();
            end;
            exit("Lookup Value Code");
        end;
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure UseLookupValue(): Boolean
    begin
        exit(true)
    end;

    local procedure UseNoLookupValue(): Boolean
    begin
        exit(false)
    end;

    local procedure CreateCompanyContact(var Contact: Record Contact);
    begin
        LibraryMarketing.CreateCompanyContact(Contact);
    end;

    local procedure CreateCustomerFromContact(Contact: Record Contact; CustomerTemplateCode: Code[10]; var Customer: Record Customer);
    begin
        Contact.SetHideValidationDialog(TRUE);
        Contact.CreateCustomer(CustomerTemplateCode);
        FindCustomerByCompanyName(Customer, Contact.Name);
    end;

    local procedure FindCustomerByCompanyName(var Customer: Record Customer; CompanyName: Text[50]);
    begin
        with Customer do begin
            SetRange(Name, CompanyName);
            FindFirst();
        end;
    end;

    local procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    var
        Customer: Record Customer;
    begin
        with Customer do begin
            Get(CustomerNo);
            Assert.AreEqual(LookupValueCode, "Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(FieldCaption("Lookup Value Code"), TableCaption()));
        end;
    end;
}