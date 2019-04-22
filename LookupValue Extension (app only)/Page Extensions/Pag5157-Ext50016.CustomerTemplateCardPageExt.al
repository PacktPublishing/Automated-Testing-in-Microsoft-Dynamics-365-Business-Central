pageextension 50016 "CustomerTemplateCardPageExt" extends "Customer Template Card" //5157
{
    layout
    {
        addlast(General)
        {
            field("Lookup Value Code"; "Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the customer buys from.';
                ApplicationArea = All;
            }
        }
    }
}