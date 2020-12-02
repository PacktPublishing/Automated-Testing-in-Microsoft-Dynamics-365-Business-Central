codeunit 80010 "Library - Tests Setup"
{
    procedure SetSkipOnAfterCreateCustomer(Handle: Boolean)
    var
        TestsSetup: Record TestsSetup;
    begin
        with TestsSetup do begin
            if not Get() then
                EnsureStandardTestsSetupExists();
            "Skip OnAfterCreateCustomer" := Handle;
            Modify();
        end;
    end;

    local procedure EnsureStandardTestsSetupExists()
    var
        TestsSetup: Record TestsSetup;
    begin
        TestsSetup.InsertIfNotExists();
    end;


    procedure SkipOnAfterCreateCustomer(): Boolean
    var
        TestsSetup: Record TestsSetup;
    begin
        with TestsSetup do
            if Get() then
                exit("Skip OnAfterCreateCustomer")
    end;
}