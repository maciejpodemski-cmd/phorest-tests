*** Settings ***
Documentation       This is the Mail workflow.
...                 Keywords for mail checks are here.
Resource    vars.resource        
Library    MailosaurLibrary.py    api_key=${MAILOSAUR_API_KEY}

*** Keywords ***
Generate Random Email Address
    [Documentation]    Generate a random email address using Mailosaur
    ${email}=    Generate Email Address    ${MAILOSAUR_SERVER_ID}
    RETURN    ${email}

Check Receipt Email Received To Recipient
    [Documentation]    Check if the receipt email has been sent to the specified email address
    [Arguments]    ${recipient_email}    ${email_subject}
    ${message}=    Wait For Message With Subject    server_id=${MAILOSAUR_SERVER_ID}    subject=${email_subject}   sent_to=${recipient_email}
    RETURN    ${message}

Delete All Emails In Mailosaur Server
    [Documentation]    Delete all emails in the specified Mailosaur server
    [Arguments]    ${server_id}=${MAILOSAUR_SERVER_ID}
    Delete All Messages    ${server_id}

Check Email Contains Voucher Number
    [Documentation]    Check if the email contains the specified voucher number
    [Arguments]    ${message}    ${voucher_number}
    Email Body Should Contain    ${message}    ${voucher_number}

