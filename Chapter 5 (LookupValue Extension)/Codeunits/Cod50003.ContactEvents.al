codeunit 50003 "ContactEvents"
{
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnCreateCustomerOnTransferFieldsFromTemplate', '', false, false)]
    local procedure OnCreateCustomerOnTransferFieldsFromTemplateEvent(var Customer: Record Customer; CustomerTemplate: Record "Customer Template")
    begin
        with Customer do
            "Lookup Value Code" := CustomerTemplate."Lookup Value Code";
    end;
}