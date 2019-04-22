tableextension 50008 "PstdWhseShipmentLineTableExt" extends "Posted Whse. Shipment Line" //7323
{
    fields
    {
        field(50000; "Lookup Value Code"; Code[10])
        {
            Caption = 'Lookup Value Code';
            DataClassification = ToBeClassified;
            TableRelation = "LookupValue";
        }
    }
}