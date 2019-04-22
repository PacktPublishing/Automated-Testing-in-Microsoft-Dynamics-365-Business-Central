codeunit 50000 "SalesHeaderEvents"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        with SalesHeader do
            "Lookup Value Code" := SellToCustomer."Lookup Value Code";
    end;
}