*** Settings ***
Documentation       Purchase and summary page elements and keywords
Library             SeleniumLibrary
Resource            ../Utilities/Common.resource

*** Variables ***
${summary_header}                      //h2[normalize-space()='Summary']
${voucher_value}                       //p[@id='confirm-voucher-value']
${processing_fee_value}                //p[@id='confirm-processing-value']
${total_cost}                          //p[@id='confirm-total-amount']
${confirm_purchaser_email}             //p[@id='confirm-purchaser-email']
${confirm_recipient_email}             //p[@id='confirm-recipient-email']
${confirm_button}                      //button[@data-action='confirm#confirmAction']
${submit_button}                       //button[@data-action='stripe-purchase#confirmPayment']
${credt_card_number_input}             //input[@data-elements-stable-field-name='cardNumber']
${credit_card_expiry_input}            //input[@data-elements-stable-field-name='cardExpiry']
${cvc_input}                           //input[@data-elements-stable-field-name='cardCvc']
${payment_details_text}                //div[normalize-space()='Payment details']
${payment_frame}                       //div[@id='stripe-payment-form']
${cvc_icon}                            //div[contains(@class, 'CardBrandIcon-container') and @data-back-icon-name='cvc']
${card_field_number}                   //span[@class='CardField-number CardField-child']


*** Keywords ***
Confirm Summary
    [Documentation]    Click the confirm button on the summary page
    Execute Javascript    document.evaluate("//button[@data-action='confirm#confirmAction']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    Wait Until Element Is Visible    ${confirm_button}    10s
    Click Element    ${confirm_button}
    
Assert Purchase Details
    [Documentation]    Assert the summary details on the summary page
    [Arguments]    ${expected_voucher_value}    ${expected_processing_fee}    ${expected_total_cost}    
    ...    ${expected_purchaser_email}    ${expected_recipient_email}
    Wait Until Element Is Visible    ${voucher_value}    30s
    
    ${actual_voucher_value}=    Get Locator Text    ${voucher_value}
    ${actual_processing_fee}=    Get Locator Text    ${processing_fee_value}
    ${actual_total_cost}=    Get Locator Text    ${total_cost}
    ${actual_purchaser_email}=    Get Locator Text    ${confirm_purchaser_email}
    ${actual_recipient_email}=    Get Locator Text    ${confirm_recipient_email}
    
    Should Be Equal    ${actual_voucher_value}       ${expected_voucher_value}
    Should Be Equal    ${actual_processing_fee}      ${expected_processing_fee}
    Should Be Equal    ${actual_total_cost}         ${expected_total_cost}
    Should Be Equal    ${actual_purchaser_email}     ${expected_purchaser_email}
    Should Be Equal    ${actual_recipient_email}     ${expected_recipient_email}

Provide Credit Card Details And Accept Payment
    [Documentation]    Provide credit card details on the summary page
    [Arguments]    ${card_number}    ${expiry}    ${cvc}
    
    Wait Until Page Contains Element    ${payment_details_text}    10s
    Wait Until Page Contains Element    ${payment_frame}   10s
    Execute Javascript    document.evaluate("//button[@data-action='stripe-purchase#confirmPayment']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(true);
    Click Element    ${card_field_number}
    Input Text    ${credt_card_number_input}    ${card_number}
    Wait Until Element Is Visible    ${credit_card_expiry_input}    10s
    Click Element    ${credit_card_expiry_input}
    Input Text    ${credit_card_expiry_input}    ${expiry}
    Click Element    ${cvc_input}
    Input Text    ${cvc_input}    ${cvc}
    Click Button    ${submit_button}

Enter Card Number And Submit Payment
    [Arguments]    ${card_number}    ${expiry}    ${cvc}
    Wait Until Page Contains Element    ${payment_frame}     10s
    Scroll Element Into View            ${payment_frame}
    Select Frame    xpath=//iframe[contains(@src, 'elements-inner-card')]
    Wait Until Element Is Visible
    ...    ${credt_card_number_input}
    ...    10s
    ${el}=    Get WebElement    ${credt_card_number_input}
    Click Element    ${el}
    Input Text    ${credt_card_number_input}    ${card_number}
    Input Text    ${credit_card_expiry_input}    ${expiry}
    Input Text    ${cvc_input}   ${cvc}
    Unselect Frame
    Click Button    Submit
