*** Settings ***
Documentation       Common utilities
Library             String
Library             SeleniumLibrary

*** Keywords ***
Generate Random String Example
    [Documentation]    Generate a random string of specified length
    [Arguments]    ${length}
    ${random}=    Generate Random String    ${length}    chars=[LETTERS]
    RETURN    ${random}

Get Locator Text
    [Documentation]    Get the any locator text from the purchase page
    [Arguments]    ${locator}        
    ${locator_txt}=    Get Text    ${locator}
    RETURN    ${locator_txt}