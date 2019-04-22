codeunit 80002 "Library - Setup"
{
    procedure UpdateCustomers(LookupValue: Code[10])
    var
        Customer: Record Customer;
    begin
        Customer.ModifyAll("Lookup Value Code", LookupValue);
    end;

    procedure UpdateCustomerTemplates(LookupValue: Code[10])
    var
        CustomerTemplate: Record "Customer Template";
    begin
        CustomerTemplate.ModifyAll("Lookup Value Code", LookupValue);
    end;

    procedure UpdateSalesHeader(LookupValue: Code[10])
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.ModifyAll("Lookup Value Code", LookupValue);
    end;


}