$Features = @()

$Features +=
Feature 'Lookup value Sales Archive' {
    Scenario 18 'Archive sales order with lookup value' {
		Given	'A sales order with a lookup value'
		When	'Sales order is archived'
		Then	'Archived sales order has lookup value from sales order'
	}
	Scenario 19 'Archive sales quote with lookup value' {
		Given	'A sales quote with a lookup value'
		When	'Sales quote is archived'
		Then	'Archived sales quote has lookup value from sales quote'
	}
	Scenario 20 'Archive sales return order with lookup value' {
		Given	'A sales return order with a lookup value'
		When	'Sales return order is archived'
		Then	'Archived sales return order has lookup value from sales return order'
	}
	Scenario 21 'Check that lookup value is shown right on Sales List Archive' {
		Given	'A sales document with a lookup value'
		When	'Sales document is archived'
		Then	'Archived sales document has lookup value from sales document'
		Then	'lookup value is shown right on Sales List Archive'
	}
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456754 `
        -CodeunitName 'Lookup value Sales Archive' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456754.LookupValueSalesArchive_2.al'