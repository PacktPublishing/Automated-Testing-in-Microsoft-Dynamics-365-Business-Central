pageextension 50044 "SalesRtrnOrderListArchPageExt" extends "Sales Return List Archive" //6629
{
    layout
    {
        addlast(Control1)
        {
            field("Lookup Value Code"; "Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the transaction is done for.';
                ApplicationArea = All;
            }
        }
    }
}