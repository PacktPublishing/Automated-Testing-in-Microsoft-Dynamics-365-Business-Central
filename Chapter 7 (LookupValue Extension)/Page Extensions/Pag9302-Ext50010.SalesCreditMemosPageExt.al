pageextension 50010 "SalesCreditMemosPageExt" extends "Sales Credit Memos" //9302
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