$Features = @()

$Features +=
Feature 'Lookup value Contact' {
    Scenario 26 'Check that lookup value is inherited from customer template to customer when creating customer from contact' {
        Given	'A customer template with lookup value'
        Given	'A contact'
        When	'Customer is created from contact'
        Then	'Customer has lookup value code field populated with lookup value from customer template'
	}
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456757 `
        -CodeunitName 'Lookup value Contact' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456757.LookupValueContact_2.al'