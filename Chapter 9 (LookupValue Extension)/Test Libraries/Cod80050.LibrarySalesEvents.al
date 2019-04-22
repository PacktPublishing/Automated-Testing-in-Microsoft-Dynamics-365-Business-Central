codeunit 80050 "Library - Sales Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Library - Sales", 'OnAfterCreateCustomer', '', false, false)]
    local procedure OnAfterCreateCustomerEvent(var Customer: Record Customer)
    var
        LibraryTestsSetup: Codeunit "Library - Tests Setup";
    begin
        if LibraryTestsSetup.SkipOnAfterCreateCustomer() then
            exit;

        SetLookupValueOnCustomer(Customer);
    end;

    local procedure SetLookupValueOnCustomer(var Customer: record Customer)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
    begin
        with Customer do begin
            Validate("Lookup Value Code", LibraryLookupValue.CreateLookupValueCode());
            Modify();
        end;
    end;
}