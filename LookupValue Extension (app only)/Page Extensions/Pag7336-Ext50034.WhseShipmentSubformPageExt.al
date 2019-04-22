pageextension 50034 "WhseShipmentSubformPageExt" extends "Whse. Shipment Subform" //7336
{
    layout
    {
        addlast(Control1)
        {
            field("Lookup Value Code"; "Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value of the source document that the entry originates from.';
                ApplicationArea = All;
            }
        }
    }
}