pageextension 50004 "SalesCreditMemoPageExt" extends "Sales Credit Memo" //44
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