pageextension 50015 "CustomerTemplateListPageExt" extends "Customer Template List" //5156
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