codeunit 60002 "MyThirdTestCodeunit"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('MyMessageHandler')]
    procedure MyFirstTestFunction()
    begin
        Message('MyFirstTestFunction');
    end;

    [MessageHandler]
    procedure MyMessageHandler(Message: Text[1024])
    begin

    end;
}

