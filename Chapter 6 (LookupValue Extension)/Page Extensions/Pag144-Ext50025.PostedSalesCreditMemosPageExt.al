pageextension 50025 "PostedSalesCreditMemosPageExt" extends "Posted Sales Credit Memos" //144
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