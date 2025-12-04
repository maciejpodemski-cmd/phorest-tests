*** Settings ***
Documentation       Setup and teardown keywords for test suites

# Library             RequestsLibrary
Library             Process
Library             String
Library             JSONLibrary
Library             Collections
Library             SeleniumLibrary

*** Keywords ***
Open URL in Browser
    [Documentation]    Open and maximize browser
    [Arguments]    ${url}
    ${chrome options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Call Method      ${chrome options}    add_argument   --headless
    Call Method      ${chrome options}    add_argument   --no-sandbox
    Call Method      ${chrome options}    add_argument   --disable-dev-shm-usage
    Open Browser    ${url}    chrome    options=${chrome options}
    Wait For Condition	return document.readyState == "complete"
    # Set Window Size    1920    1080
    Maximize Browser Window