<a href="https://github.com/kopoli/robot-mode"><img src="https://www.gnu.org/software/emacs/images/emacs.png" alt="Emacs Logo" width="80" height="80" align="right"></a>
## robot-mode.el
*Major-mode for Robot Framework files*

---
[![License GPLv3](https://img.shields.io/badge/license-GPL_v3-green.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

### Description

A Robot Framework major mode for Emacs. Robot Framework is a framework for
acceptance testing.

- https://robotframework.org
- https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html

This major mode provides the following:
- Syntax highlighting.
- Indentation.
- Alignment of keyword contents.
- Line continuation in Robot Framework syntax.
- A helper for adding necessary spaces between arguments.

#### Alignment of keyword contents

Align the contents of a keyword, test or task with `C-c C-a'. It changes the
following code:

    Example Keyword
        [Documentation]    Documents the keyword
        [Arguments]    ${arg1}    ${arg2}
        Log    ${arg1}            ${arg2}

To:

    Example Keyword
        [Documentation]    Documents the keyword
        [Arguments]        ${arg1}    ${arg2}
        Log                ${arg1}    ${arg2}

#### Line continuation

Insert a newline, indentation, ellipsis and necessary spaces at current
point with `C-c C-j'. For example (| denotes the cursor):

    Another Keyword
        [Documentation]    A very long text| that describes the keyword.

To:

    Another Keyword
        [Documentation]    A very long text
        ...    | that describes the keyword.

#### Add spacing for an argument

Robot framework separates arguments to keywords with 2 or more spaces. The
`C-c C-SPC' sets the whitespace amount around point to exactly
`robot-mode-argument-separator`. For example (| denotes the cursor):

    Example Keyword
        [Arguments]    ${first}|${second}

To:

    Example Keyword
        [Arguments]    ${first}    |${second}

### Limitations

- Currently supports only the Space separated format:
  https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#space-separated-format
- Does NOT support the Pipe separated format or the reStructuredText
  format.

### Function Documentation


#### `(robot-mode-syntax-propertize START END)`

Propertize text between START and END.

#### `(robot-mode-indent-line)`

Indent current line in Robot mode.

Used as `indent-line-function` of the mode.

#### `(robot-mode-beginning-of-defun)`

Move the point to the beginning of the current defun.

Defuns are the steps of a keyword, test or task. This is used as
`beginning-of-defun-function` of the mode.

#### `(robot-mode-end-of-defun)`

Move the point to the end of the current defun.

Defuns are the steps of a keyword, test or task. This is used as
`end-of-defun-function` of the mode.

#### `(robot-mode-align BEG END)`

Align the contents of the region between BEG and END.

#### `(robot-mode-align-defun)`

Align the contents current defun.

#### `(robot-mode-align-region-or-defun)`

Call `robot-mode-align` if region is active, otherwise call `robot-mode-align-defun`.

#### `(robot-mode-split-continuation)`

Split current line at point and continue in the next line.

Prefix the continuation with indentation, ellipsis and spacing.

#### `(robot-mode-add-argument)`

Add exactly `robot-mode-argument-separator` spaces to point.

-----
<div style="padding-top:15px;color: #d0d0d0;">
Markdown README file generated by
<a href="https://github.com/mgalgs/make-readme-markdown">make-readme-markdown.el</a>
</div>
