codeunit 50001 "WhsePostShipmentEvents"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostSourceDocument', '', false, false)]
    local procedure OnBeforePostSourceDocumentEvent(var WhseShptLine: Record "Warehouse Shipment Line"; PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; TransferHeader: Record "Transfer Header")
    begin
        with SalesHeader do
            if "No." <> '' then
                TestField("Lookup Value Code");
    end;
}