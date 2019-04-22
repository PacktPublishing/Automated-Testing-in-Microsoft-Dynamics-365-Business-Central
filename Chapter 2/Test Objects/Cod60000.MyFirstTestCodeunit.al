codeunit 60000 "MyFirstTestCodeunit"
{
    Subtype = Test;

    [Test]
    procedure MyFirstTestFunction()
    begin
        Message('MyFirstTestFunction');
    end;

    [Test]
    procedure MySecondTestFunction()
    begin
        Error('MySecondTestFunction');
    end;
}

