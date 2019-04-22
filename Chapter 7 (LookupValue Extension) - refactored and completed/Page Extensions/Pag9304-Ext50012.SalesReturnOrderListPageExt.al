pageextension 50012 "SalesReturnOrderListPageExt" extends "Sales Return Order List" //9304
{
    layout
    {
        addfirst(Control1)
        {
            field("Lookup Value Code"; "Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the transaction is done for.';
                ApplicationArea = All;
            }
        }
    }
}