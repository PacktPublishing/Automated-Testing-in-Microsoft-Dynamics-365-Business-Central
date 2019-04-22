codeunit 60003 "MyFourthTestCodeunit"
{
    Subtype = Test;

    [Test]
    procedure MyFirstTestPageTestFunction()
    var
        PaymentTerms: TestPage "Payment Terms";
    begin
        PaymentTerms.OpenView();
        PaymentTerms.Last();
        PaymentTerms.Code.AssertEquals('LUC');
        PaymentTerms.Close();
    end;

    [Test]
    procedure MySecondTestPageTestFunction()
    var
        PaymentTerms: TestPage "Payment Terms";
    begin
        PaymentTerms.OpenNew();
        PaymentTerms.Code.SetValue('LUC');
        PaymentTerms."Discount %".SetValue('56');
        PaymentTerms.Description.SetValue(
                PaymentTerms.Code.Value()
            );
        ERROR('Code: %1 \Discount %: %2 \Description: %3',
                PaymentTerms.Code.Value(),
                PaymentTerms."Discount %".Value(),
                PaymentTerms.Description.Value()
            );
        PaymentTerms.Close();
    end;
}