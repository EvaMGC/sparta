@web @rest
Feature: Test adding a new Socket input in Sparta GUI
		
	Background: Setup Sparta GUI
		Given I set web base url to '${SPARTA_HOST}:${SPARTA_PORT}'
		Given I send requests to '${SPARTA_HOST}:${SPARTA_API_PORT}'
	
	Scenario: Try to add a new input
		Given I browse to '/#/dashboard/inputs'
		Then I wait '1' second
		Then '1' element exists with 'css:button[data-qa="inputs-new-button"]'
		When I click on the element on index '0'
		Then I wait '1' second
		And '1' element exists with 'css:aside[data-qa="fragment-details-modal"]'
		
		# Select socket
		Given '1' element exists with 'css:label[data-qa="fragment-detail-type-socket"]'
		When I click on the element on index '0'
		Then I wait '1' second
		
		# Try with empty name
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		When I click on the element on index '0'
		# Error message should appear
		Then '1' element exists with 'css:span[data-qa="fragment-detail-name-error-required"]'
		Then '1' element exists with 'css:span[data-qa="fragment-details-socket-hostname-error-required"]'
		Then '1' element exists with 'css:span[data-qa="fragment-details-socket-port-error-required"]'
		
		# Try name with spaces
		Given '1' element exists with 'css:input[data-qa="fragment-detail-name"]'
		Then I type 'valid Socket Input' on the element on index '0'
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		When I click on the element on index '0'
		# Error message should appear
		Then '1' element exists with 'css:span[data-qa="fragment-detail-name-error-pattern"]'
		Given '1' element exists with 'css:input[data-qa="fragment-detail-name"]'
		Then I send 'HOME, SHIFT + END, DELETE' on the element on index '0'
		
		# Try with port using letters
		Given '1' element exists with 'css:input[data-qa="fragment-details-socket-port"]'
		Then I type 'port' on the element on index '0'
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		When I click on the element on index '0'
		# Error message should appear
		Then '1' element exists with 'css:span[data-qa="fragment-details-socket-port-error-pattern"]'
		
		# Try with invalid port number
		Given '1' element exists with 'css:input[data-qa="fragment-details-socket-port"]'
		Then I type '66666' on the element on index '0'
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		When I click on the element on index '0'
		# Error message should appear
		Then '1' elements exist with 'css:span[data-qa="fragment-details-socket-port-error-pattern"]'
		
		# Fill in name field
		Given '1' element exists with 'css:input[data-qa="fragment-detail-name"]'
		Then I type 'validSocketInput' on the element on index '0'
		# Fill in host field
		Given '1' element exists with 'css:input[data-qa="fragment-details-socket-hostname"]'
		Then I type 'localhost' on the element on index '0'
		# Fill in port field
		Given '1' element exists with 'css:input[data-qa="fragment-details-socket-port"]'
		Then I send 'HOME, SHIFT + END, DELETE' on the element on index '0'
		And I type '5672' on the element on index '0'
		
		# Create
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		When I click on the element on index '0'
		# Check that input fragment has been created
		# Retrieve input fragment id using api
		When I send a 'GET' request to '/fragment/input/name/validsocketinput'
		Then the service response status must be '200'.
		And I save element '$.id' in attribute 'previousFragmentID'
		# Check that an input element has been created
		Then '1' element exists with 'css:span[data-qa="input-context-menu-!{previousFragmentID}"]'
		
		# Add same input fragment
		Then '1' element exists with 'css:button[data-qa="inputs-new-button"]'
		When I click on the element on index '0'
		Then I wait '1' second
		And '1' element exists with 'css:aside[data-qa="fragment-details-modal"]'
		# Select Socket
		Given '1' element exists with 'css:label[data-qa="fragment-detail-type-socket"]'
		When I click on the element on index '0'
		Then I wait '1' second
		# Fill in name field
		Given '1' element exists with 'css:input[data-qa="fragment-detail-name"]'
		Then I type 'validSocketInput' on the element on index '0'
		# Fill in host field
		Given '1' element exists with 'css:input[data-qa="fragment-details-socket-hostname"]'
		Then I type 'localhost' on the element on index '0'
		# Fill in port field
		Given '1' element exists with 'css:input[data-qa="fragment-details-socket-port"]'
		Then I type '5672' on the element on index '0'
		
		# Create
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		When I click on the element on index '0'
		Then '1' element exists with 'css:span[translate="_INPUT_ERROR_100_"]'
		
		# Cancel operation
		Given '1' element exists with 'css:button[data-qa="modal-cancel-button"]'
		Then I click on the element on index '0'
		# Check pop up is closed
		And I wait '1' second
		Then '0' element exists with 'css:button[data-qa="modal-cancel-button"]'
		
		# Delete input fragment created
		Given '1' element exists with 'css:span[data-qa="input-context-menu-!{previousFragmentID}"]'
		Then I click on the element on index '0'
		And I wait '1' second
		Given '1' element exists with 'css:st-menu-element[data-qa="input-context-menu-!{previousFragmentID}-delete"]'
		When I click on the element on index '0'
		Then I wait '1' second
		And '1' element exists with 'css:aside[data-qa="delete-modal"]'
		Given '1' element exists with 'css:button[data-qa="modal-ok-button"]'
		Then I click on the element on index '0'
		And I wait '1' second
		And '0' element exists with 'css:span[data-qa="input-context-menu-!{previousFragmentID}"]'