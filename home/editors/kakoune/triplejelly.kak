# triplejelly.kak
#
# This is a port of my triplejelly.vim, albeit with a lot less to it
# since kakoune filetypes just don't highlight nearly as much as other
# editors.
#
# This is based on the dracula color scheme, which can be found at
# https://github.com/dracula/kakoune/blob/master/colors/dracula.kak
# and its license, the MIT license, is reproduced below:
#
#     The MIT License (MIT)
#
#     Copyright (c) 2020 Dracula Theme
#
#     Permission is hereby granted, free of charge, to any person obtaining a copy
#     of this software and associated documentation files (the "Software"), to deal
#     in the Software without restriction, including without limitation the rights
#     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#     copies of the Software, and to permit persons to whom the Software is
#     furnished to do so, subject to the following conditions:
#
#     The above copyright notice and this permission notice shall be included in all
#     copies or substantial portions of the Software.
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#     SOFTWARE.

# Standard
declare-option str tj_background      '151515'
declare-option str tj_background_dark '000000'
declare-option str tj_foreground      'C6CFD2'
declare-option str tj_cursor          '0CA4C3'
declare-option str tj_selection       '0CA4C3'
declare-option str tj_selection_sec   '8100FF'
declare-option str tj_comment         '74737E'
declare-option str tj_type            'FB97D2'
declare-option str tj_func            'FB97D2'
declare-option str tj_func_name       'FB97D2'
declare-option str tj_call            'BB95EF'
declare-option str tj_namespace       'FB97D2'
declare-option str tj_operator        '3D8F9A'
declare-option str tj_keyword         '00D2E5'
declare-option str tj_control         'DBCD5D'
declare-option str tj_import          'E160B4'
declare-option str tj_storage         'EC7967'
declare-option str tj_number          '99CC66'
declare-option str tj_quote           'FF91C5'
declare-option str tj_string          'BBE16C'
declare-option str tj_interp          '797BE6'
declare-option str tj_var             '47AEE8'
declare-option str tj_const           '34A2D9'
declare-option str tj_lib_func        'BB95EF'
declare-option str tj_lib_type        '6E9CBE'
declare-option str tj_lib_const       '99CC33'
declare-option str tj_highlight       'FCFF5B'

declare-option str tj_diff_add        'D2EBBE'
declare-option str tj_diff_del        '700009'
declare-option str tj_diff_mod        '2B5B77'
declare-option str tj_diff_text       '8FBFDC'

declare-option str tj_line_nr         '909090'
declare-option str tj_statusline      '3EB2FC'
declare-option str tj_statusline_nc   '757575'

declare-option str tj_title           '70B950'

# ANSI
declare-option str cyan               '8BE9FD'
declare-option str green              '50FA7B'
declare-option str purple             'BD93F9'
declare-option str red                'FF5555'

# Alpha blending
declare-option str cursor_alpha       '99'
declare-option str selection_alpha    '64'

# Other
declare-option str non_text           '303030'

# Code
set-face global value "rgb:%opt{tj_number}" # C++ ⇒ int number = [42];
set-face global type "rgb:%opt{tj_type}" # C++ ⇒ [int] main() { ... }
set-face global variable "rgb:%opt{tj_var}" # Makefile ⇒ [install]:
set-face global module "rgb:%opt{tj_namespace}" # C++ ⇒ #include [<stdio.h>]
set-face global function "rgb:%opt{tj_func}"
set-face global string "rgb:%opt{tj_string}"
set-face global keyword "rgb:%opt{tj_keyword}"
set-face global operator "rgb:%opt{tj_operator}" # Shell ⇒ true [&&] false
set-face global attribute "rgb:%opt{tj_storage}" # C++ ⇒ [enum] Color { ... };
set-face global comment "rgb:%opt{tj_comment}"
set-face global documentation comment # Rust ⇒ /// Returns `true`.
set-face global meta "rgb:%opt{tj_import}" # C++ ⇒ [#include] <stdio.h>
set-face global builtin "rgb:%opt{tj_control}"

# Diffs
set-face global DiffText "rgb:%opt{tj_diff_text}"
set-face global DiffHeader "rgb:%opt{tj_comment}"
set-face global DiffInserted "rgb:%opt{tj_diff_add},rgba:%opt{tj_diff_add}20"
set-face global DiffDeleted "rgb:%opt{tj_diff_del},rgba:%opt{tj_diff_del}50"
set-face global DiffChanged "rgb:%opt{tj_diff_mod}"

# Markup
set-face global title "rgb:%opt{tj_func_name}+b" # AsciiDoc ⇒ = Document title
set-face global header "rgb:%opt{tj_func_name}+b" # AsciiDoc ⇒ == Section title
set-face global mono "rgb:%opt{tj_interp}" # AsciiDoc ⇒ `code`
set-face global block "rgb:%opt{tj_control}" # AsciiDoc ⇒ [----][code][----]
set-face global link "rgb:%opt{cyan}" # Markdown
set-face global bullet "rgb:%opt{cyan}"
set-face global list "rgb:%opt{tj_foreground}" # AsciiDoc ⇒ - [item]

# Builtin faces
set-face global Default "rgb:%opt{tj_foreground},rgb:%opt{tj_background}" # Editor background
set-face global PrimarySelection "default,rgba:%opt{tj_selection}%opt{selection_alpha}" # Pink (alpha-blended)
set-face global SecondarySelection "default,rgba:%opt{tj_selection_sec}%opt{selection_alpha}" # Purple (alpha-blended)
set-face global PrimaryCursor "default,rgba:%opt{tj_selection}%opt{cursor_alpha}" # Pink (alpha-blended)
set-face global SecondaryCursor "default,rgba:%opt{tj_selection_sec}%opt{cursor_alpha}" # Purple (alpha-blended)
set-face global PrimaryCursorEol "rgb:%opt{tj_background},rgb:%opt{tj_foreground}+fg" # White (full block)
set-face global SecondaryCursorEol "rgb:%opt{tj_background},rgb:%opt{tj_foreground}+fg" # White (full block)
set-face global MenuForeground "rgb:%opt{tj_foreground},rgb:%opt{tj_selection}"
set-face global MenuBackground "rgb:%opt{tj_foreground},rgb:%opt{tj_background_dark}"
set-face global MenuInfo "rgb:%opt{tj_comment}" # IntelliSense suggestions
set-face global Information Default # Contextual help blends with the editor background.
set-face global Error "rgb:%opt{tj_foreground},rgb:%opt{red}"
set-face global DiagnosticError "rgb:%opt{red}"
set-face global DiagnosticWarning "rgb:%opt{cyan}"
set-face global StatusLine "rgb:%opt{tj_background},rgb:%opt{tj_statusline}"
set-face global StatusLineMode "rgb:%opt{green}" # [insert]
set-face global StatusLineInfo "rgb:%opt{purple}" # 1 sel
set-face global StatusLineValue "rgb:%opt{green}" # 1 sel param=[42] reg=[y]
set-face global StatusCursor "rgb:%opt{tj_background},rgb:%opt{tj_foreground}" # Cursor in command mode
set-face global Prompt StatusLine # Same as the status line, since they live at the same place.
set-face global BufferPadding "rgb:%opt{non_text}" # Kakoune ⇒ set-option global ui_options terminal_padding_fill=yes

# Builtin highlighter faces
set-face global LineNumbers "rgb:%opt{tj_line_nr}" # Kakoune ⇒ add-highlighter -override global/number-lines number-lines — Prefer non-text here
set-face global LineNumberCursor "rgb:%opt{tj_foreground}" # Kakoune ⇒ add-highlighter -override global/number-lines number-lines -hlcursor
set-face global LineNumbersWrapped "rgba:%opt{tj_line_nr}7f" # Kakoune ⇒ add-highlighter -override global/number-lines number-lines; add-highlighter -override global/wrap wrap
set-face global MatchingChar "rgb:%opt{tj_highlight}+uf" # Kakoune ⇒ add-highlighter -override global/show-matching show-matching
set-face global Whitespace "rgb:%opt{non_text}+f" # Kakoune ⇒ add-highlighter -override global/show-whitespaces show-whitespaces
set-face global WrapMarker "rgb:%opt{non_text}" # Kakoune ⇒ add-highlighter -override global/wrap wrap -marker '↪'
