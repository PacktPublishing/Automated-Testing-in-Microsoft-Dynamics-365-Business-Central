pageextension 50024 "PostedSalesCreditMemoPageExt" extends "Posted Sales Credit Memo" //134
{
    layout
    {
        addlast(General)
        {
            field("Lookup Value Code"; "Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the transaction is done for.';
                ApplicationArea = All;
            }
        }
    }
}