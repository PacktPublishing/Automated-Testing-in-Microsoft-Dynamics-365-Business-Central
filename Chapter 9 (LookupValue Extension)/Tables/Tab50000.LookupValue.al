table 50000 "LookupValue"
{
    Caption = 'Lookup Value';
    DataClassification = ToBeClassified;
    LookupPageId = "LookupValues";

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}