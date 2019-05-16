$Features = @()

$Features +=
Feature 'Lookup value Posting' {
    Scenario 22 'Check that posted sales invoice and shipment inherit lookup value from sales order' {
		Given	'A sales order with a lookup value'
		When	'Sales order is posted (invoice & ship)'
		Then	'Posted sales invoice has lookup value from sales order'
		Then	'Sales shipment has lookup value from sales order'
	}
	Scenario 27 'Check posting throws error on sales order with empty lookup value' {
		Given	'A sales order without a lookup value'
		When	'Sales order is posted (invoice & ship)'
		Then	'Missing lookup value on sales order error thrown'
	}
	Scenario 23 'Check that posted warehouse shipment line inherits lookup value from sales order through warehouse shipment line' {
		Given	'A location with require shipment'
		Given	'A warehouse employee for current user'
		Given	'A warehouse shipment line with a lookup value created from a sales order'
		When	'Warehouse shipment is posted'
		Then	'Posted warehouse shipment line has lookup value from warehouse shipment line'
	}
	Scenario 25 'Check posting throws error on sales order with empty lookup value' {
		Given	'A location with require shipment'
		Given	'A warehouse employee for current user'
		Given	'A warehouse shipment line created from a sales order without  lookup value'
		When	'Warehouse shipment is posted'
		Then	'Missing lookup value on sales order error thrown'
	}
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456755 `
        -CodeunitName 'Lookup value Posting' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456755.LookupValuePosting_2.al'