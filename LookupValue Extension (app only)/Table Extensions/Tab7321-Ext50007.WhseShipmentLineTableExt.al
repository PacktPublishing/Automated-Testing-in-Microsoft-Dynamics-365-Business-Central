tableextension 50007 "WhseShipmentLineTableExt" extends "Warehouse Shipment Line" //7321
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