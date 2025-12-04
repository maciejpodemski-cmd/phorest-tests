*** Settings ***
Documentation       Sending a gift voucher tests

Library             SeleniumLibrary
Resource            ../Utilities/SetupAndTeardown.resource
Resource            ../Utilities/vars.resource
Resource            ../Pages/purchase.resource
Resource            ../Pages/summaryAndCheckout.resource
Resource            ../Pages/success.resource
Resource            ../Utilities/EmailWorkflow.resource

Test Setup         Run Keywords    Open URL in Browser    ${PHOREST_MAIN_PAGE}
...              AND    Delete All Emails In Mailosaur Server
Test Teardown      Close All Browsers

*** Variables ***


*** Test Cases ***
1. Sending Gift Voucher Via Email To Me With Fixed Amount
    [Documentation]    Test sending a gift voucher via email
    ${buyer_email}=    Generate Random Email Address
    Select Voucher Amount    250
    Type Purchaser Mail    ${buyer_email}
    Type Purchaser Names    John    Doe
    Checkout Purchase
    Wait Until Element Is Visible    ${summary_header}    10s
    Assert Purchase Details   $250.00   $0.00    $250.00    ${buyer_email}    ${buyer_email} 
    Confirm Summary
    Assert Purchase Details    $250.00   $0.00    $250.00    ${buyer_email}    ${buyer_email}
    Enter Card Number    ${CREDIT_CARD_NUMBER}    ${CREDIT_CARD_EXPIRY}    ${CVC}
    Wait Until Page Contains Element    ${success_page}    20s
    ${num}=    Get Voucher Number
    ${message}    Check Receipt Email Received To Recipient    ${buyer_email}    You've been sent a $250.00 gift voucher for Demo US!
    Check Email Contains Voucher Number    ${message}    ${num}
    Check Receipt Email Received To Recipient    ${buyer_email}    Your Receipt for Arden Courts


2.Sending Gift Voucher Via Email With Fixed Amount To Someone Else
    [Documentation]    Test sending a gift voucher via email to someone else
    ${buyer_email}=    Generate Random Email Address
    ${recpient_email}=    Generate Random Email Address
    Log To Console    Recipient email: ${recpient_email}
    Log To Console    Buyer email: ${buyer_email}
    Select Voucher Amount    300
    Select Send To Someone Else Tab
    Type Purchaser Mail    ${buyer_email}
    Type Purchaser Names    John    Doe
    Type Recipient Email And Message    ${recpient_email}    Happy Birthday!
    Checkout Purchase
    Wait Until Element Is Visible    ${summary_header}    10s
    Assert Purchase Details   $300.00   $0.00    $300.00    ${buyer_email}    ${recpient_email}
    Confirm Summary
    Assert Purchase Details    $300.00   $0.00    $300.00    ${buyer_email}    ${recpient_email}
    Enter Card Number    ${CREDIT_CARD_NUMBER}    ${CREDIT_CARD_EXPIRY}    ${CVC}
    Wait Until Page Contains Element    ${success_page}    20s
    ${num}=    Get Voucher Number
    ${message}    Check Receipt Email Received To Recipient    ${recpient_email}    You've been sent a $300.00 gift voucher for Demo US!
    Check Email Contains Voucher Number    ${message}    ${num}
    Check Receipt Email Received To Recipient    ${buyer_email}    Your Receipt for Arden Courts
    Log To Console    Email message received with id: ${message}

3. Sending Gift Voucher Via Email To Me With Other Amount
    [Documentation]    Test sending a gift voucher via email with other amount
    ${buyer_email}=    Generate Random Email Address
    Select And Type Other Voucher Value    175
    Type Purchaser Mail    ${buyer_email}
    Type Purchaser Names    John    Doe
    Checkout Purchase
    Wait Until Element Is Visible    ${summary_header}    10s
    Assert Purchase Details   $175.00   $0.00    $175.00    ${buyer_email}    ${buyer_email} 
    Confirm Summary
    Assert Purchase Details    $175.00   $0.00    $175.00    ${buyer_email}    ${buyer_email}
    Enter Card Number    ${CREDIT_CARD_NUMBER}    ${CREDIT_CARD_EXPIRY}    ${CVC}
    Wait Until Page Contains Element    ${success_page}    20s
    ${num}=    Get Voucher Number
    ${message}    Check Receipt Email Received To Recipient    ${buyer_email}    You've been sent a $175.00 gift voucher for Demo US!
    Check Email Contains Voucher Number    ${message}    ${num}
    Check Receipt Email Received To Recipient    ${buyer_email}    Your Receipt for Arden Courts

4. Sending Gift Voucher Via Email To Someone Else With Other Amount
    [Documentation]    Test sending a gift voucher via email to someone else with other amount
    ${buyer_email}=    Generate Random Email Address
    ${recpient_email}=    Generate Random Email Address
    Log To Console    Recipient email: ${recpient_email}
    Log To Console    Buyer email: ${buyer_email}
    Select And Type Other Voucher Value    225
    Select Send To Someone Else Tab
    Type Purchaser Mail    ${buyer_email}
    Type Purchaser Names    John    Doe
    Type Recipient Email And Message    ${recpient_email}    Happy Birthday!
    Checkout Purchase
    Wait Until Element Is Visible    ${summary_header}    10s
    Assert Purchase Details   $225.00   $0.00    $225.00    ${buyer_email}    ${recpient_email}
    Confirm Summary
    Assert Purchase Details    $225.00   $0.00    $225.00    ${buyer_email}    ${recpient_email}
    Enter Card Number    ${CREDIT_CARD_NUMBER}    ${CREDIT_CARD_EXPIRY}    ${CVC}
    Wait Until Page Contains Element    ${success_page}    20s
    ${num}=    Get Voucher Number
    ${message}    Check Receipt Email Received To Recipient    ${recpient_email}    You've been sent a $225.00 gift voucher for Demo US!
    Check Email Contains Voucher Number    ${message}    ${num}
    Check Receipt Email Received To Recipient    ${buyer_email}    Your Receipt for Arden Courts
    Log To Console    Email message received with id: ${message}
