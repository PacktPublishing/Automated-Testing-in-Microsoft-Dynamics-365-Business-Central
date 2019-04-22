pageextension 50006 "BlanketSalesOrderPageExt" extends "Blanket Sales Order" //507
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