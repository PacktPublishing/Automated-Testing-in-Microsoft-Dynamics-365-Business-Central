tableextension 50001 "SalesHeaderTableExt" extends "Sales Header" //36
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