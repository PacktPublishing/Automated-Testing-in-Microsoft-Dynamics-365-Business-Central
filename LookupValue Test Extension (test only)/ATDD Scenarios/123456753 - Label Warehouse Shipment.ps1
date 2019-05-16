$Features = @()

$Features +=
Feature 'Lookup value Warehouse Shipment' {
    Scenario 15  'Assign lookup value to warehouse shipment line' {	
        Given	'A lookup value'
        Given	'A location with require shipment'
        Given	'A warehouse employee for current user'
        Given	'A warehouse shipment from released sales order with line with require shipment location'
        When	'Set lookup value on warehouse shipment line'
        Then	'Warehouse shipment line has lookup value code field populated'
    }
    Scenario 16  'Assign non-existing lookup value on warehouse shipment line' {
        Given	'A non-existing lookup value'
        Given	'A warehouse shipment line record variable'
        When	'Set non-existing lookup value to warehouse shipment line'
        Then	'Non existing lookup value error was thrown'
    }
    Scenario 17  'Assign lookup value to warehouse shipment line on warehouse shipment document page' {
        Given	'A lookup value'
        Given	'A location with require shipment'
        Given	'A warehouse employee for current user'
        Given	'A warehouse shipment from released sales order with line with require shipment location'
        When	'Set lookup value on warehouse shipment line on warehouse shipment document page'
        Then	'Warehouse shipment line has lookup value code field populated'
    }
    Scenario 30  'Create warehouse shipment from sales order with lookup value' {
        Given	'A lookup value'
        Given	'A location with require shipment'
        Given	'A warehouse employee for current user'
        When	'Create warehouse shipment from released sales order with lookup value and with line with require shipment location'
        Then	'Warehouse shipment line has lookup value code field populated'
    }
    Scenario 31  'Get sales order with lookup value on warehouse shipment' {
        Given	'A lookup value'
        Given	'A location with require shipment'
        Given	'A warehouse employee for current user'
        Given	'A released sales order with lookup value and with line with require shipment location'
        Given	'A warehouse shipment without lines'
        When	'Get sales order with lookup value on warehouse shipment'
        Then	'Warehouse shipment line has lookup value code field populated'
    }
}

$Features | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 123456753 `
        -CodeunitName 'Lookup value Warehouse Shipment' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        #  | Out-File '.\Test Codeunits\COD123456753.LookupValueWarehouseShipment_2.al'