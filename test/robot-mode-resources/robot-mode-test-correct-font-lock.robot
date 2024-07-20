*** Settings ***
# ^ font-lock-keyword-face
Documentation     Example using the space separated format.
# ^ font-lock-preprocessor-face
#                 ^ font-lock-doc-face
Metadata          Something
# ^ font-lock-preprocessor-face
#                 ^ font-lock-doc-face
Force Tags        tag
# ^ font-lock-preprocessor-face
#                 ^ font-lock-doc-face
Default Tags      tag
Library           OperatingSystem  arg1  arg2
# ^ font-lock-preprocessor-face
#                 ^ font-lock-constant-face
Resource          Something
# ^ font-lock-preprocessor-face
#                 ^ font-lock-constant-face
Test Setup        Setup keyword
# ^ font-lock-preprocessor-face
#                 ^ font-lock-constant-face
Variables         Something
# ^ font-lock-preprocessor-face
#                 ^ font-lock-constant-face

# Comment
# ^ font-lock-comment-face

*** Variables ***
# ^ font-lock-keyword-face
${MESSAGE}        Hello, world!
# ^ font-lock-variable-name-face

*** Keywords ***
# ^ font-lock-keyword-face

My Keyword
# ^ font-lock-function-name-face
    [Arguments]    ${path}
    # ^ font-lock-constant-face
    #              ^ font-lock-variable-name-face
    Directory Should Exist    ${path}
    # ^ ! font-lock-function-name-face
    #                         ^ font-lock-variable-name-face
    Something Else    Argument
    # ^ ! font-lock-function-name-face

*** Test Cases ***
# ^ font-lock-keyword-face

My Test
    [Documentation]  Example test.    Something here.
    # ^ font-lock-constant-face
    ...                Something else.
    # ^ font-lock-constant-face
    My Keyword    ${CURDIR}  ...
    #                         ^ ! font-lock-constant-face
    Log    ${MESSAGE}
    Something else    ${2}
    #                 ^ font-lock-constant-face
    Something else    ${true}
    #                 ^ font-lock-constant-face
    Something else    ${NONE}
    #                 ^ font-lock-constant-face

    IF              ${NULL}
    # <- font-lock-builtin-face
    #               ^ font-lock-constant-face
        Set Variable    ${ARG}
    ELSE IF         "a" == "b"
    # <- font-lock-builtin-face
    #                ^ font-lock-string-face
        Set Variable    ${ARG2}
    ELSE
    # <- font-lock-builtin-face
        Set Variable    ${ARG3}
    END
    # <- font-lock-builtin-face

    FOR    ${letter}    IN    a    b
    # <- font-lock-builtin-face
        Log    ${letter}
    END

    TRY
    # <- font-lock-builtin-face
        WHILE    ${true}
            # <- font-lock-builtin-face
            BREAK
            # <- font-lock-builtin-face
            CONTINUE
            # <- font-lock-builtin-face
        END
    EXCEPT    abc
        # <- font-lock-builtin-face
        Something
    END
