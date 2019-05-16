$Features = @()

$Features +=
Feature 'Lookup value UT Sales Document' {
    Scenario 4 'Assign lookup value to sales header' {
		Given	'A lookup value'
		Given	'A sales header'
		When	'Set lookup value on sales header'
		Then	'Sales header has lookup value code field populated'
	}
	Scenario 5 'Assign non-existing lookup value on sales header' {
		Given	'A non-existing lookup value'
		Given	'A sales header record variable'
		When	'Set non-existing lookup value to sales header'
		Then	'Non existing lookup value error was thrown'
	}
	Scenario 6 'Assign lookup value on sales quote document page' {
		Given	'A lookup value'
		Given	'A sales quote document page'
		When	'Set lookup value on sales quote document'
		Then	'Sales quote has lookup value code field populated'
	}
	Scenario 7 'Assign lookup value on sales order document page' {
		Given	'A lookup value'
		Given	'A sales order document page'
		When	'Set lookup value on sales order document'
		Then	'Sales order has lookup value code field populated'
	}
	Scenario 8 'Assign lookup value on sales invoice document page' {
		Given	'A lookup value'
		Given	'A sales invoice document page'
		When	'Set lookup value on sales invoice document'
		Then	'Sales invoice has lookup value code field populated'
	}
	Scenario 9 'Assign lookup value on sales credit memo document page' {
		Given	'A lookup value'
		Given	'A sales credit memo document page'
		When	'Set lookup value on sales credit memo document'
		Then	'Sales credit memo has lookup value code field populated'
	}
	Scenario 10 'Assign lookup value on sales return order document page' {
		Given	'A lookup value'
		Given	'A sales return order document page'
		When	'Set lookup value on sales return order document'
		Then	'Sales return order has lookup value code field populated'
	}
	Scenario 11 'Assign lookup value on blanket sales order document page' {
		Given	'A lookup value'
		Given	'A blanket sales order document page'
		When	'Set lookup value on blanket sales order document'
		Then	'Blanket sales order has lookup value code field populated'
	}
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456751 `
        -CodeunitName 'Lookup value UT Sales Document' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456751.LookupValueUTSalesDocument_2.al'