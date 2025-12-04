*** Settings ***
Documentation       Purchase page elements and keywords
Library             SeleniumLibrary
Resource            ../Utilities/Common.resource
*** Variables ***
${header_name}                           //p[@data-target='page.businessNameHeader']
${header_txt}                            //span[@data-target='page.headerText']
${other_option_radio}                    //input[@data-target='amount.otherOptionButton']
${other_value_input}                     //input[@type='number' and @data-target='amount.otherInput']
${required_field_error_msg}              //div[@data-target='email.purchaserEmailError']    #duplicate1
${purchaser_email_input}                 //input[@data-target='email.purchaserEmailInput']
${first_name_input}                      //input[@data-target='name.purchaserFirstNameInput']
${last_name_input}                       //input[@data-target='name.purchaserLastNameInput']
${send_to_me_tab}                        //a[@data-action='tabs#showSendToMe' and @data-target='tabs.sendToMyselfTab']
${send_to_someone_else_tab}              //a[@data-target='tabs.sendToOtherTab']
# ${invalid_email_format_error_msg}        //div[@data-target='email.purchaserEmailError']    #duplicate1
${recipient_email_input}                 //input[@data-target='email.recipientEmailInput']
${recipient_email_msg_input}             //textarea[@data-target='email.recipientMessageInput']
${invalid_recipient_email_error_msg}     //div[@data-target='email.recipientEmailError']    #duplicate2
# ${recipient_invalid_email_format_error}  //div[@data-target='email.recipientEmailError']     #duplicate2
${checkout_button}                       //button[@data-target="checkout.checkoutButton"]
${other_input_error_msg}                 //p[@data-target="amount.otherSectionError"]
${plus_free_value_other}                 //span[@data-target="amount.otherDiscountInfo"]

*** Keywords ***
Assert Header Name And Text
    [Documentation]    Assert the header name on the purchase page
    [Arguments]    ${expected_header_name}    ${expected_header_txt}
    
    ${actual_header_name}=    Get Locator Text    ${header_name}
    ${actual_header_txt}=    Get Locator Text    ${header_txt}
    Should Be Equal    ${actual_header_name}    ${expected_header_name}
    Should Be Equal    ${actual_header_txt}     ${expected_header_txt}

Select Voucher Amount
    [Documentation]    Select a voucher amount option by its value
    [Arguments]    ${amount}
    ${locator}=    Set Variable    xpath=//input[@data-target='amount.optionButton' and @data-display-amount='${amount}']
    Wait Until Element Is Visible    ${locator}    10s
    Click Element    ${locator}

Select And Type Other Voucher Value
    [Documentation]    Select the 'Other' option for voucher amount
    [Arguments]    ${other_value}
    Wait Until Element Is Visible    ${other_option_radio}    10s
    Click Element    ${other_option_radio}
    Wait Until Element Is Visible    ${other_value_input}    10s
    Clear Element Text    ${other_value_input}
    Input Text    ${other_value_input}    ${other_value}

Check Required Field Error Message
    [Documentation]    Check the required field error message for purchaser email
    [Arguments]    ${input_type}    ${expected_error_msg}
    
    IF    '${input_type}' == 'Purchaser Email Input'
        ${actual_error_msg}=    Get Locator Text    ${invalid_email_format_error_msg}
        Should Be Equal    ${actual_error_msg}    ${expected_error_msg}
    ELSE IF   '${input_type}' == 'Recipien Email Input'
        ${actual_error_msg}=    Get Locator Text    ${invalid_recipient_email_error_msg}
        Should Be Equal    ${actual_error_msg}    ${expected_error_msg}
    END

Checkout Button State Should Be
    [Documentation]    Verify if the checkout button is enabled or disabled
    [Arguments]    ${expected_state}
    
    ${action}=    Get Element Attribute    xpath=${checkout_button}    data-action

    Run Keyword If    '${expected_state}' == 'enabled'
    ...    Should Be Equal    ${action}    checkout#checkoutAction
    Run Keyword If    '${expected_state}' == 'disabled'
    ...    Should Be Equal    ${action}    ${EMPTY}

Check Other Input Error Message
    [Documentation]    Check the error message for other input value 
    ...    if the minimum and maximum value is not met
    [Arguments]    ${expected_error_msg}
    
    ${actual_error_msg}=    Get Locator Text    ${other_input_error_msg}
    Should Be Equal    ${actual_error_msg}    ${expected_error_msg}

Type Purchaser Mail
    [Documentation]    Type the purchaser email in the input field
    [Arguments]    ${purchaser_email}
    
    Input Text    ${purchaser_email_input}    ${purchaser_email}

Type Purchaser Names
    [Documentation]    Type the purchaser first and last names in the input fields
    [Arguments]    ${first_name}    ${last_name}
    
    Input Text    ${first_name_input}    ${first_name}
    Input Text    ${last_name_input}    ${last_name}

Checkout Purchase
    [Documentation]    Click the checkout button to finish the purchase
    Checkout Button State Should Be    enabled
    Click Button    ${checkout_button}

Select Send To Someone Else Tab
    [Documentation]    Select the 'Send to someone else' tab on the purchase page
    Wait Until Element Is Visible    ${send_to_someone_else_tab}    10s
    Execute Javascript    document.evaluate("//a[@data-target='tabs.sendToOtherTab']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    Click Element    ${send_to_someone_else_tab}

Type Recipient Email And Message
    [Documentation]    Type the recipient email and message in the input fields
    [Arguments]    ${recipient_email}    ${recipient_message}
    Wait Until Element Is Visible    ${recipient_email_input}    10s
    Input Text    ${recipient_email_input}    ${recipient_email}
    Input Text    ${recipient_email_msg_input}    ${recipient_message}
