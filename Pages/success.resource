*** Settings ***
Documentation       Complete page elements and keywords
Library             SeleniumLibrary
Resource            ../Utilities/Common.resource
*** Variables ***
${success_icon}            //svg[@data-icon='check-circle']
${payment_accepted_msg}    //p[@class='text-xl font-medium mb-8' and normalize-space()='Payment accepted, thank you!']
${information_msg}         //p[normalize-space()="Your gift card has been sent. We've also sent you a receipt."]
${voucher_number}          //p[@data-target='stripe-serial.serialSpan']
${done_button}             //button[@data-action='application#doneAction']
${success_page}            //div[@data-controller='success' and contains(@class,'container')] 

*** Keywords ***
Get Voucher Number
    [Documentation]    Get the voucher number from the complete page
    Wait Until Page Contains Element    xpath=//p[@data-target='stripe-serial.serialSpan']    15s
    Wait Until Keyword Succeeds    15s    1s    Voucher Number Should Not Be Empty
    ${voucher_num}=    Get Text    xpath=//p[@data-target='stripe-serial.serialSpan']
    ${voucher_num}=    Strip String    ${voucher_num}

    RETURN    ${voucher_num}

Voucher Number Should Not Be Empty
    ${text}=    Get Text    xpath=//p[@data-target='stripe-serial.serialSpan']
    ${text}=    Strip String    ${text}
    Should Not Be Empty    ${text}