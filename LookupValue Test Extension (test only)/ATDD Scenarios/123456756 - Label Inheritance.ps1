$Features = @()

$Features +=
Feature 'Lookup value Inheritance' {
    Scenario 24 'Assign customer lookup value to sales document' {
		Given	'A customer with a lookup value'
		Given	'A sales document (invoice) without a lookup value'
		When	'Set customer on sales header'
		Then	'lookup value on sales document is populated with lookup value of customer'
	}
	Scenario 28 'Create customer from configuration template with lookup value' {
		Given	'A configuration template (customer) with lookup value'
		When	'Create customer from configuration template'
		Then	'lookup value on customer is populated with lookup value of configuration template'
	}
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456756 `
        -CodeunitName 'Lookup value Inheritance' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456756.LookupValueInheritance_2.al'