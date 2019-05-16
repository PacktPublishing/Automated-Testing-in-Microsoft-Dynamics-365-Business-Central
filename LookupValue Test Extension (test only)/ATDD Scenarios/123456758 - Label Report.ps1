$Features = @()

$Features +=
Feature 'Lookup value Report' {
    Scenario 29 'Test that lookup value shows on CustomerList report' {
	Given	'2 customers with different lookup value'
	When	'Run report CustomerList'
	Then	'Report dataset contains both customers with lookup value'
	}
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456758 `
        -CodeunitName 'Lookup value Report' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456758.LookupValueReport_2.al'