*** Settings ***
Library     SeleniumLibrary
Library    String
Test Setup    Open To Do List Website
Test Teardown    Close All Browsers

*** Keywords ***
Open To Do List Website
    Open Browser    https://abhigyank.github.io/To-Do-List/   headlesschrome
    Location Should Be  https://abhigyank.github.io/To-Do-List/
    Set Selenium Speed  0.1

Add Task
    [Arguments]    @{tasks}
    Element Should Be Visible  id:new-task
    FOR    ${task}  IN  @{tasks}
        Input Text  id:new-task     ${task}
        Click Element   //button/*[contains(text(),"add")]
    END

Go To
    [Arguments]    ${page}
    Wait Until Element Is Visible   //*[contains(text(),"${page}")]
    Click Element   //*[contains(text(),"${page}")]
    Wait Until Element Is Visible   //*[@class="mdl-tabs__tab is-active" and contains(text(),"${page}")]

Complete Task
    [Arguments]    ${page}      @{tasks}
    FOR     ${task}     IN  @{tasks}
        Wait Until Element Is Visible   //*[@id="${page}"]//*[contains(text(),"${task}")]
        Click Element   //*[@id="${page}"]//*[contains(text(),"${task}")]
    END

Task Should Not Display
    [Arguments]    ${page}      @{tasks}
    FOR     ${task}     IN  @{tasks}
        Wait Until Element Is Not Visible   //*[@id="${page}"]//*[contains(text(),"${task}")]
    END

Delete Tasks
    [Arguments]    @{tasks}
    ${length}=  Get Length  ${tasks}
    FOR     ${task}     IN    @{tasks}
        ${id}=  Get Element Attribute   //*[@id="incomplete-tasks"]//*[contains(text(),"${task}")]   id
        ${id}=  Remove String   ${id}   text-
        Click Element   //*[@id="incomplete-tasks"]//button[@id="${id}"]
    END

Clear All Task That Completed
    ${count}=   Get Element Count   //*[@id="completed-tasks"]//button[contains(text(),"Delete")]
    FOR     ${i}    IN RANGE    ${count}
        Wait Until Element Is Visible   //*[@id="completed-tasks"]//button
        Click Element   //*[@id="completed-tasks"]//button
    END
    Wait Until Element Is Not Visible   //*[@id="completed-tasks"]//button[contains(text(),"Delete")]

*** Test Cases ***
Add Task And Complete It
    Add Task    task1   task2
    Go To   To-Do Tasks
    Complete Task    incomplete-tasks   task1   task2
    Task Should Not Display    incomplete-tasks     task1   task2
    Go To   Completed
    Clear All Task That Completed

Add Task And Cancel task
    Add Task    task1   task2
    Go To   To-Do Tasks
    Delete Tasks    task1   task2
    Task Should Not Display     task1   task2
