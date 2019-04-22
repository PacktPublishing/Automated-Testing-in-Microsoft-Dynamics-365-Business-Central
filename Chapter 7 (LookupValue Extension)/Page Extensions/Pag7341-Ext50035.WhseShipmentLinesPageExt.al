pageextension 50035 "WhseShipmentLinesPageExt" extends "Whse. Shipment Lines" //7341
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