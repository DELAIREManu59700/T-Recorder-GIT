#cs --------------------------------------------------------------------------------------------------------------------------------------------------------
 Date 10/09/2010
 Error return code
 Author:	Ph. GARRIGUE
#ce --------------------------------------------------------------------------------------------------------------------------------------------------------

const $OK = 0

; DllStructCreate
const $DLLSTRUCTCREATE_BAD_STRING_ARG_   = 1 		; Variable passed to DllStructCreate was not a string.
const $DLLSTRUCTCREATE_UNKNOWN_DATA_TYPE = 2 		;There is an unknown Data Type in the string passed.
const $DLLSTRUCTCREATE_FAIL_ALLOC_MEM_STRUCT = 3 	; Failed to allocate the memory needed for the struct, or Pointer = 0.
const $DLLSTRUCTCREATE_FAIL_ALLOC_MEM_STRING = 4 	; Error allocating memory for the passed string.

;DllOpen
const $DLLOPEN_ERROR = 5 							; Impossible to return a dll handle.

;DllCall
const $DLLCALL_UNABLE_USE_FILE = 6 					; unable to use the DLL file,
const $DLLCALL_UNKNOWN_RETURN_TYPE = 7 				; unknown "return type"
const $DLLCALL_FUNCTION_NOT_FOUND = 8 				; "function" not found in the DLL file.

;DllStructCreate
const $DLLSTRUCTCREATE_NOT_STRING_ARG = 9			; Variable passed to DllStructCreate was not a string.
const $DLLSTRUCTCREATE_UNKNOW_TYPE_ARG = 10			; There is an unknown Data Type in the string passed.
const $DLLSTRUCTCREATE_MEM_ALLOC_FAILURE = 11		; Failed to allocate the memory needed for the struct, or Pointer = 0.
const $DLLSTRUCTCREATE_MEM_ALLOC_ERROR = 12			; Error allocating memory for the passed string.

;DllStructGetData
const $DLLSTRUCTGETDATA_INCORRECT_STRUCT = 13		; Struct not a correct struct returned by DllStructCreate.
const $DLLSTRUCTGETDATA_OUT_OF_RANGE = 14			; Element value out of range.
const $DLLSTRUCTGETDATA_OUTSIDE_INDEX = 15			; index would be outside of the struct.
const $DLLSTRUCTGETDATA_UNKNOWN_DATA_TYPE = 16		; Element data type is unknown
const $DLLSTRUCTGETDATA_NEGATIVE_INDEX = 17			; index <= 0.

;BinaryToString
const $BINARYTOSTRING_ZERO_LEN = 18					; Input string had zero length.
const $BINARYTOSTRING_ODD_NUMBER_STR = 19			; Input string had an odd number of bytes but was supposed to be UTF16 (must contain an even number of bytes to be valid UTF16).

;T_AssertFullWindow
const $T_ASSERTFULLWINDOW_NOT_EQUAL_CHECKSUM = 200	; Recorded and played are not identical

;T_AssertPartialWindow
const $T_ASSERTPARTIALWINDOW_NOT_EQUAL_CHECKSUM = 201	; Recorded and played are not identical

;T_AssertColor
const $T_ASSERTCOLOR_BAD_COLOR = 202				; Recorded and played pixel color are not identical

;T_AssertMenu
const $T_ASSERTMENU_NOT_EQUAL_CHECKSUM = 203		; Recorded and played are not identical for a menu

;T_FunctionMenu
const $T_FUNCTIONMENU_NOT_EQUAL_CHECKSUM = 204		; Recorded and played are not identical for a menu

;T_WaitFullWindow
const $T_WAITFULLWINDOW_TIME_ELAPSED = 205			; Timeout after waiting a window

;T_WaitPartialWindow
const $T_WAITPARTIALWINDOW_TIME_ELAPSED = 206			; Timeout after waiting a partial window

;T_WaitColor
const $T_WAITCOLOR_TIME_ELAPSED = 207							; Timeout after waiting a pixel color

;T_AssertClipboard
const $T_ASSERTCLIPBOARD_NOT_MATCH = 208						;	The clipboard content doesn't match the recorded String

;T_AssertClipboard
const $T_ASSERTCLIPBOARD_MATCH_SEVERAL_TIMES = 209						;	The clipboard content matches the recorded String but it matches it several times

;T_WinWaitActive
const $T_WINWAITACTIVE_TIME_ELAPSED = 210						;	The clipboard content matches the recorded String but it matches it several times

;T_WinWaitActive
const $T_WINWAITACTIVE_RESIZE_NOT_POSSIBLE = 211				;	Impossible to resize the window. The size must be equal to the record context.

;T_WinWaitClose
const $T_WINWAITCLOSE_TIME_ELAPSED = 212						; Timeout after waiting a window closing.

;T_Assert_OCR
const $T_ASSERTOCR_NOT_EQUAL_WORD = 213							; Recorded and played are not identical

;T_Function_OCR
const $T_FUNCTIONOCR_NOT_EQUAL_WORD = 214							; Recorded and played are not identical

;T_SelectItemInComboBox ou T_SelectItemInCB
const $T_SELECTITEMINCOMBOBOX_NOT_EQUAL_WORD = 215							; Recorded and played are not identical

;T_WinWaitStatus
const $T_WINWAITSTATUS_NOT_EQUAL_WORD = 216							; Recorded and played are not identical

;T_ClickWord
const $T_CLICKWORD_NOT_EQUAL_WORD = 217							; Recorded and played are not identical

