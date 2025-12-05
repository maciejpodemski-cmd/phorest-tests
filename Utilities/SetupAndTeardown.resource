*** Settings ***
Documentation       Setup and teardown keywords for test suites

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
    Call Method      ${chrome options}    add_argument   --headless
    ${window_size}=    Set Variable    --window-size=1920,1080
    Call Method    ${chrome options}    add_argument    ${window_size}
    Call Method      ${chrome options}    add_argument   --no-sandbox
    Call Method      ${chrome options}    add_argument   --disable-dev-shm-usage
    ${UA}=    Set Variable    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36
    ${UA_ARG}=    Catenate    SEPARATOR=    --user-agent=    ${UA}
    Call Method    ${chrome options}    add_argument     ${UA_ARG}
    Open Browser    ${url}    chrome    options=${chrome options}
    Set Window Size    1920    1080
    Wait For Condition	return document.readyState == "complete"