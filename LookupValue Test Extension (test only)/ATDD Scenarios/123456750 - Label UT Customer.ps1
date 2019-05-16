$Features = @()

$Features +=
Feature 'Lookup value UT Customer' {
    Scenario 1  'Assign lookup value to customer' {
        Given	'A lookup value'
        Given	'A customer'
        When	'Set lookup value on customer'
        Then	'Customer has lookup value code field populated'
    }
    Scenario 2  'Assign non-existing lookup value to customer' {
        Given	'A non-existing lookup value'
        Given	'A customer record variable'
        When	'Set non-existing lookup value on customer'
        Then	'Non existing lookup value error thrown'
    }
    Scenario 3  'Assign lookup value on customer card' {
        Given	'A lookup value'
        Given	'A customer card'
        When	'Set lookup value on customer card'
        Then	'Customer has lookup value code field populated'
    }
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456750 `
        -CodeunitName 'Lookup value UT Customer' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456750.LookupValueUTCustomer_2.al'