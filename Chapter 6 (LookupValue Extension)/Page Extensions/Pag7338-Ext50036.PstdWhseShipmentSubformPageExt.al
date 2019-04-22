pageextension 50036 "PstdWhseShipmentSubformPageExt" extends "Posted Whse. Shipment Subform" //7338
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