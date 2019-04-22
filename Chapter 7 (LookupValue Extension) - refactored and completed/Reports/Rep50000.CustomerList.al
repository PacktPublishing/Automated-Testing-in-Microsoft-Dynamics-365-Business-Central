Report 50000 "CustomerList"
{
    //Converted from standard report 101 "Customer - List"

    DefaultLayout = RDLC;
    RDLCLayout = './Report Layouts/CustomerList.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Customer List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
            column(COMPANYNAME; CompanyProperty.DisplayName()) { }
            column(Customer_TABLECAPTION_CustFilter; TableCaption() + ': ' + CustFilter) { }
            column(CustFilter; CustFilter) { }
            column(Customer_No_; "No.")
            {
                IncludeCaption = true;
            }
            column(Customer_Customer_Posting_Group_; "Customer Posting Group")
            {
                IncludeCaption = true;
            }
            column(Customer_Customer_Disc_Group_; "Customer Disc. Group")
            {
                IncludeCaption = true;
            }
            column(Customer_Invoice_Disc_Code_; "Invoice Disc. Code")
            {
                IncludeCaption = true;
            }
            column(Customer_Customer_Price_Group_; "Customer Price Group")
            {
                IncludeCaption = true;
            }
            column(Customer_Fin_Charge_Terms_Code_; "Fin. Charge Terms Code")
            {
                IncludeCaption = true;
            }
            column(Customer_Payment_Terms_Code_; "Payment Terms Code")
            {
                IncludeCaption = true;
            }
            column(Customer_Salesperson_Code_; "Salesperson Code")
            {
                IncludeCaption = true;
            }
            column(Customer_Currency_Code_; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(Customer_Credit_Limit_LCY_; "Credit Limit (LCY)")
            {
                DecimalPlaces = 0 : 0;
                IncludeCaption = true;
            }
            column(Customer_Balance_LCY_; "Balance (LCY)")
            {
                IncludeCaption = true;
            }
            column(Customer_Contact; Contact)
            {
                IncludeCaption = true;
            }
            column(Customer_Phone_No_; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(Customer_Lookup_Value_Code; "Lookup Value Code")
            {
                // IncludeCaption = true;
                // outcommented as it appears not to work on an extension field
            }
            column(Customer_Lookup_Value_CodeCaption; FieldCaption("Lookup Value Code")) { }
            column(CustAddr_1_; CustAddr[1]) { }
            column(CustAddr_2_; CustAddr[2]) { }
            column(CustAddr_3_; CustAddr[3]) { }
            column(CustAddr_4_; CustAddr[4]) { }
            column(CustAddr_5_; CustAddr[5]) { }
            column(CustAddr_6_; CustAddr[6]) { }
            column(CustAddr_7_; CustAddr[7]) { }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Balance (LCY)");
                FormatAddr.FormatAddr(
                  CustAddr, Name, "Name 2", '', Address, "Address 2",
                  City, "Post Code", County, "Country/Region Code");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    Labels
    {
        TitleCaption = 'Customer - List';
        PageCaption = 'Page';
        Total_LCY_Caption = 'Total (LCY)';

    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);

    end;

    var
        FormatAddr: Codeunit "Format Address";
        CustFilter: Text;
        CustAddr: array[8] of Text[50];
}