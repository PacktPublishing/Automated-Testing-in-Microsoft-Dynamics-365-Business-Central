codeunit 80051 "Library - Initialize"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Library - Test Initialize", 'OnBeforeTestSuiteInitialize', '', false, false)]
    local procedure OnBeforeTestSuiteInitializeEvent(CallerCodeunitID: Integer)
    begin
        Initialize(CallerCodeunitID);
    end;

    local procedure Initialize(CallerCodeunitID: Integer)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibrarySetup: Codeunit "Library - Setup";
    begin
        case CallerCodeunitID of
            Codeunit::"ERM Fixed Assets Journal",
            Codeunit::"ERM Fixed Assets GL Journal":
                LibrarySetup.UpdateCustomers(LibraryLookupValue.CreateLookupValueCode());
            Codeunit::"Service Order Release":
                LibrarySetup.UpdateSalesHeader(LibraryLookupValue.CreateLookupValueCode());
            Codeunit::"Sales E2E":
                LibrarySetup.UpdateCustomerTemplates(LibraryLookupValue.CreateLookupValueCode());
        end;
    end;
}