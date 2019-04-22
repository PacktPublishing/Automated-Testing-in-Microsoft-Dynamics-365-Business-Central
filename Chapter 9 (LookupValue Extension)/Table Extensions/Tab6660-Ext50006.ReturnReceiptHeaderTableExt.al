tableextension 50006 "ReturnReceiptHeaderTableExt" extends "Return Receipt Header" //6660
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