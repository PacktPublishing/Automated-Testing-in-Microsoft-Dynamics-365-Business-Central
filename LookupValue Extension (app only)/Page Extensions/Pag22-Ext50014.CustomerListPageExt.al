pageextension 50014 "CustomerListPageExt" extends "Customer List" //22
{
    layout
    {
        addlast(Control1)
        {
            field("Lookup Value Code"; "Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the customer buys from.';
                ApplicationArea = All;
            }
        }
    }
}