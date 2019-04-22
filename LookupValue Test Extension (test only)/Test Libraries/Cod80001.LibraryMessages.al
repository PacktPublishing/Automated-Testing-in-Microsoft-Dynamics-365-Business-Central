codeunit 80001 "Library - Messages"
{
    var
        LibraryUtility: Codeunit "Library - Utility";

    procedure GetFieldOnTableTxt(FieldCaption: Text; TableCaption: Text): Text
    var
        FieldOnTableTxt: Label '%1 on %2';
    begin
        exit(StrSubstNo(
                FieldOnTableTxt,
                FieldCaption,
                TableCaption))
    end;

    procedure GetPageControlEditableTxt(ControlCaption: Text; ControlEditability: Boolean): Text
    var
        PageControlEditableTxt: Label 'Page control "%1": Editable = %2.';
    begin
        exit(StrSubstNo(
                PageControlEditableTxt,
                ControlCaption,
                ControlEditability))
    end;

    procedure GetValueCannotBeFoundInTableTxt(FieldCaption: Text; TableCaption: Text; LookupValueCode: Code[10]; LookupValueTableCaption: Text): Text
    var
        ValueCannotBeFoundInTableTxt: Label 'The field %1 of table %2 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        exit(StrSubstNo(
                ValueCannotBeFoundInTableTxt,
                FieldCaption,
                TableCaption,
                LookupValueCode,
                LookupValueTableCaption))
    end;

    procedure GetFieldMustHaveValueInSalesHeaderTxt(NewFieldCaption: Text; SalesHeader: Record "Sales Header"): Text
    var
        FieldMustHaveValueInSalesHeaderTxt: Label '%1 must have a value in %2: %3=%4, %5=%6. It cannot be zero or empty.';
    begin
        with SalesHeader do
            exit(StrSubstNo(
                    FieldMustHaveValueInSalesHeaderTxt,
                    NewFieldCaption,
                    TableCaption(),
                    FieldCaption("Document Type"),
                    "Document Type",
                    FieldCaption("No."),
                    "No."))
    end;
}