codeunit 80000 "Library - Lookup Value"
{
    var
        LibraryUtility: Codeunit "Library - Utility";

    procedure CreateLookupValue(var LookupValue: Record LookupValue)
    begin
        with LookupValue do begin
            Init();
            Validate(Code, LibraryUtility.GenerateRandomCode(FieldNo(Code), Database::LookupValue));
            Validate(Description, Code);
            Insert();
        end;
    end;

    procedure CreateLookupValueCode(): Code[10]
    var
        LookupValue: Record LookupValue;
    begin
        CreateLookupValue(LookupValue);
        exit(LookupValue.Code);
    end;
}