page 60000 "MyTestsExecutor"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'My Test Executor';

    actions
    {
        area(Processing)
        {
            action(MyFirstTestCodeunit)
            {
                Caption = 'My First Test Codeunit';
                ToolTip = 'Executes My First Test Codeunit';
                ApplicationArea = All;
                Image = ExecuteBatch;
                RunObject = codeunit MyFirstTestCodeunit;
            }
            action(MySecondTestCodeunit)
            {
                Caption = 'My Second Test Codeunit';
                ToolTip = 'Executes My Second Test Codeunit';
                ApplicationArea = All;
                Image = ExecuteBatch;
                RunObject = codeunit MySecondTestCodeunit;
            }
            action(MyThirdTestCodeunit)
            {
                Caption = 'My Third Test Codeunit';
                ToolTip = 'Executes My Third Test Codeunit';
                ApplicationArea = All;
                Image = ExecuteBatch;
                RunObject = codeunit MyThirdTestCodeunit;
            }
            action(MyFourthTestCodeunit)
            {
                Caption = 'My Fourth Test Codeunit';
                ToolTip = 'Executes My Fourth Test Codeunit';
                ApplicationArea = All;
                Image = ExecuteBatch;
                RunObject = codeunit MyFourthTestCodeunit;
            }
        }
    }
}