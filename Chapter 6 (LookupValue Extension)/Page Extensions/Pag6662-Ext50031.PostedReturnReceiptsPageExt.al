pageextension 50031 "PostedReturnReceiptsPageExt" extends "Posted Return Receipts" //6662
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