page 50000 "LookupValues"
{
    PageType = List;
    SourceTable = "LookupValue";
    Caption = 'Lookup Values';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(RepeaterControl)
            {
                field("Code"; "Code")
                {
                    ToolTip = 'Specifies a code to identify this lookup value.';
                    ApplicationArea = All;
                }
                field("Description"; "Description")
                {
                    ToolTip = 'Specifies a text to describe the lookup value.';
                    ApplicationArea = All;
                }
            }
        }
    }
}