pageextension 50037 "PostedWhseShipmentLinesPageExt" extends "Posted Whse. Shipment Lines" //7362
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