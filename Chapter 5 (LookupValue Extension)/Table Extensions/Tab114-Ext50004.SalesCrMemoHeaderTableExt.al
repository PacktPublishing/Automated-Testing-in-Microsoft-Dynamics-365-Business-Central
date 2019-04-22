tableextension 50004 "SalesCrMemoHeaderTableExt" extends "Sales Cr.Memo Header" //114
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