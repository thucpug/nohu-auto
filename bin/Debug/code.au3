#Au3Stripper_Ignore_Funcs=_JS_Execute, _HttpRequest_BypassCloudflare, _HTMLEncode, __HTML_RegexpReplace, __IE_Init_GoogleBox, _Data2SendEncode
__HttpRequest_CheckUpdate(1406)
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Func _ArrayInsert(ByRef $aArray, $vRange, $vValue = "", $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $vValue = Default Then $vValue = ""
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
EndSwitch
Local $aSplit_1, $aSplit_2
If IsArray($vRange) Then
If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
Else
Local $iNumber
$vRange = StringStripWS($vRange, 8)
$aSplit_1 = StringSplit($vRange, ";")
$vRange = ""
For $i = 1 To $aSplit_1[0]
If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$aSplit_2 = StringSplit($aSplit_1[$i], "-")
Switch $aSplit_2[0]
Case 1
$vRange &= $aSplit_2[1] & ";"
Case 2
If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
$iNumber = $aSplit_2[1] - 1
Do
$iNumber += 1
$vRange &= $iNumber & ";"
Until $iNumber = $aSplit_2[2]
EndIf
EndSwitch
Next
$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
EndIf
If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
For $i = 2 To $vRange[0]
If $vRange[$i] < $vRange[$i - 1] Then Return SetError(3, 0, -1)
Next
Local $iCopyTo_Index = $iDim_1 + $vRange[0]
Local $iInsertPoint_Index = $vRange[0]
Local $iInsert_Index = $vRange[$iInsertPoint_Index]
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + $vRange[0] + 1]
For $iReadFromIndex = $iDim_1 To 0 Step -1
$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
$iCopyTo_Index -= 1
$iInsert_Index = $vRange[$iInsertPoint_Index]
While $iReadFromIndex = $iInsert_Index
$aArray[$iCopyTo_Index] = $vValue
$iCopyTo_Index -= 1
$iInsertPoint_Index -= 1
If $iInsertPoint_Index < 1 Then ExitLoop 2
$iInsert_Index = $vRange[$iInsertPoint_Index]
WEnd
Next
Return $iDim_1 + $vRange[0] + 1
EndIf
ReDim $aArray[$iDim_1 + $vRange[0] + 1]
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
$hDataType = 0
EndIf
$vValue = $aTmp
EndIf
For $iReadFromIndex = $iDim_1 To 0 Step -1
$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
$iCopyTo_Index -= 1
$iInsert_Index = $vRange[$iInsertPoint_Index]
While $iReadFromIndex = $iInsert_Index
If $iInsertPoint_Index <= UBound($vValue, $UBOUND_ROWS) Then
If IsFunc($hDataType) Then
$aArray[$iCopyTo_Index] = $hDataType($vValue[$iInsertPoint_Index - 1])
Else
$aArray[$iCopyTo_Index] = $vValue[$iInsertPoint_Index - 1]
EndIf
Else
$aArray[$iCopyTo_Index] = ""
EndIf
$iCopyTo_Index -= 1
$iInsertPoint_Index -= 1
If $iInsertPoint_Index = 0 Then ExitLoop 2
$iInsert_Index = $vRange[$iInsertPoint_Index]
WEnd
Next
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(6, 0, -1)
Local $iValDim_1, $iValDim_2
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(7, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
$aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
StringReplace($aSplit_1[0], $sDelim_Item, "")
$iValDim_2 = @extended + 1
Local $aTmp[$iValDim_1][$iValDim_2]
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
For $j = 0 To $iValDim_2 - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(8, 0, -1)
ReDim $aArray[$iDim_1 + $vRange[0] + 1][$iDim_2]
For $iReadFromIndex = $iDim_1 To 0 Step -1
For $j = 0 To $iDim_2 - 1
$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFromIndex][$j]
Next
$iCopyTo_Index -= 1
$iInsert_Index = $vRange[$iInsertPoint_Index]
While $iReadFromIndex = $iInsert_Index
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iCopyTo_Index][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iCopyTo_Index][$j] = ""
Else
If $iInsertPoint_Index - 1 < $iValDim_1 Then
If IsFunc($hDataType) Then
$aArray[$iCopyTo_Index][$j] = $hDataType($vValue[$iInsertPoint_Index - 1][$j - $iStart])
Else
$aArray[$iCopyTo_Index][$j] = $vValue[$iInsertPoint_Index - 1][$j - $iStart]
EndIf
Else
$aArray[$iCopyTo_Index][$j] = ""
EndIf
EndIf
Next
$iCopyTo_Index -= 1
$iInsertPoint_Index -= 1
If $iInsertPoint_Index = 0 Then ExitLoop 2
$iInsert_Index = $vRange[$iInsertPoint_Index]
WEnd
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS)
EndFunc
Func _ArrayToString(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
If $sDelim_Col = Default Then $sDelim_Col = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iStart_Row = Default Then $iStart_Row = -1
If $iEnd_Row = Default Then $iEnd_Row = -1
If $iStart_Col = Default Then $iStart_Col = -1
If $iEnd_Col = Default Then $iEnd_Col = -1
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
If $iStart_Row = -1 Then $iStart_Row = 0
If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, "")
If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
Local $sRet = ""
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
For $i = $iStart_Row To $iEnd_Row
$sRet &= $aArray[$i] & $sDelim_Col
Next
Return StringTrimRight($sRet, StringLen($sDelim_Col))
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
If $iStart_Col = -1 Then $iStart_Col = 0
If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
For $i = $iStart_Row To $iEnd_Row
For $j = $iStart_Col To $iEnd_Col
$sRet &= $aArray[$i][$j] & $sDelim_Col
Next
$sRet = StringTrimRight($sRet, StringLen($sDelim_Col)) & $sDelim_Row
Next
Return StringTrimRight($sRet, StringLen($sDelim_Row))
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return 1
EndFunc
Global Const $FILE_ATTRIBUTE_DIRECTORY = 0x00000010
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Func _WinAPI_DeleteObject($hObject)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SelectObject($hDC, $hGDIObj)
Local $aResult = DllCall("gdi32.dll", "handle", "SelectObject", "handle", $hDC, "handle", $hGDIObj)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_BitBlt($hDestDC, $iXDest, $iYDest, $iWidth, $iHeight, $hSrcDC, $iXSrc, $iYSrc, $iROP)
Local $aResult = DllCall("gdi32.dll", "bool", "BitBlt", "handle", $hDestDC, "int", $iXDest, "int", $iYDest, "int", $iWidth, "int", $iHeight, "handle", $hSrcDC, "int", $iXSrc, "int", $iYSrc, "dword", $iROP)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateCompatibleBitmap($hDC, $iWidth, $iHeight)
Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleBitmap", "handle", $hDC, "int", $iWidth, "int", $iHeight)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateCompatibleDC($hDC)
Local $aResult = DllCall("gdi32.dll", "handle", "CreateCompatibleDC", "handle", $hDC)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_DeleteDC($hDC)
Local $aResult = DllCall("gdi32.dll", "bool", "DeleteDC", "handle", $hDC)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_GetDC($hWnd)
Local $aResult = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetWindowDC($hWnd)
Local $aResult = DllCall("user32.dll", "handle", "GetWindowDC", "hwnd", $hWnd)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_ReleaseDC($hWnd, $hDC)
Local $aResult = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_CreatePen($iPenStyle, $iWidth, $iColor)
Local $aResult = DllCall("gdi32.dll", "handle", "CreatePen", "int", $iPenStyle, "int", $iWidth, "INT", $iColor)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_DrawLine($hDC, $iX1, $iY1, $iX2, $iY2)
_WinAPI_MoveTo($hDC, $iX1, $iY1)
If @error Then Return SetError(@error, @extended, False)
_WinAPI_LineTo($hDC, $iX2, $iY2)
If @error Then Return SetError(@error + 10, @extended, False)
Return True
EndFunc
Func _WinAPI_LineTo($hDC, $iX, $iY)
Local $aResult = DllCall("gdi32.dll", "bool", "LineTo", "handle", $hDC, "int", $iX, "int", $iY)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_MoveTo($hDC, $iX, $iY)
Local $aResult = DllCall("gdi32.dll", "bool", "MoveToEx", "handle", $hDC, "int", $iX, "int", $iY, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Global $__g_hGDIPDll = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_BitmapCreateFromHBITMAP($hBitmap, $hPal = 0)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBitmap, "handle", $hPal, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[3]
EndFunc
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return SetError(10, $aResult[0], 0)
Return $aResult[2]
EndFunc
Func _GDIPlus_GraphicsDispose($hGraphics)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $nX, $nY)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImage", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
Return True
EndFunc
Func _GDIPlus_Shutdown()
If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)
$__g_iGDIPRef -= 1
If $__g_iGDIPRef = 0 Then
DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
DllClose($__g_hGDIPDll)
$__g_hGDIPDll = 0
EndIf
Return True
EndFunc
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
$__g_iGDIPRef += 1
If $__g_iGDIPRef > 1 Then Return True
If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"
$__g_hGDIPDll = DllOpen($sGDIPDLL)
If $__g_hGDIPDll = -1 Then
$__g_iGDIPRef = 0
Return SetError(1, 2, False)
EndIf
Local $sVer = FileGetVersion($sGDIPDLL)
$sVer = StringSplit($sVer, ".")
If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False
Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
Local $tToken = DllStructCreate("ulong_ptr Data")
DllStructSetData($tInput, "Version", 1)
Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
If $aResult[0] Then Return SetError(10, $aResult[0], False)
$__g_iGDIPToken = DllStructGetData($tToken, "Data")
If $bRetDllHandle Then Return $__g_hGDIPDll
Return SetExtended($sVer[1], True)
EndFunc
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $g___ConsoleForceUTF8 = False
Global Const $g___ConsoleForceANSI = False
Global $dll_WinHttp = DllOpen('winhttp.dll')
Global $dll_User32 = DllOpen('user32.dll')
Global $dll_Kernel32 = DllOpen('kernel32.dll')
Global $dll_Gdi32, $dll_WinInet
Global $g___oError = ObjEvent("AutoIt.Error", "__ObjectErrDetect"), $g___oErrorStop = 0
Global $g___ChromeVersion = FileGetVersion(@ProgramFilesDir & ' (x86)\Google\Chrome\Application\chrome.exe')
If @error Then $g___ChromeVersion = FileGetVersion(@ProgramFilesDir & '\Google\Chrome\Application\chrome.exe')
If @error Then $g___ChromeVersion = FileGetVersion(@UserProfileDir & '\AppData\Local\Google\Chrome\Application\chrome.exe')
If @error Or $g___ChromeVersion = '' Or $g___ChromeVersion = '0.0.0.0' Then $g___ChromeVersion = '70.0.3538.102'
Global Const $g___UAHeader = 'Mozilla/5.0 (Windows NT ' & StringRegExpReplace(FileGetVersion('kernel32.dll'), '^(\d+\.\d+)(.*)$', '$1', 1) &((StringInStr(@OSArch, '64') And Not @AutoItX64) ? '; WOW64' :((StringInStr(@OSArch, '64') And @AutoItX64) ? '; Win64; x64' : '')) & ') '
Global Const $g___defUserAgent = $g___UAHeader & '_HttpRequest' & ' (WinHTTP/5.1) like Gecko'
Global Const $g___defUserAgentW = $g___UAHeader & 'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/' & $g___ChromeVersion & ' Safari/537.36'
Global Const $g___defUserAgentA = 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5 Build/MRA58N) AppleWebKit/537.36(KHTML, like Gecko) Chrome/61.0.3116.0 Mobile Safari/537.36'
Global Const $g___defUserAgentAO = 'Mozilla/5.0 (Linux; U; Android 4.2.2; en-us; SM-T217S Build/JDQ39) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30'
Global Const $g___defUserAgentGB = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
Global Const $g___defUserAgentIP = 'Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1'
Global $g___MaxSession_TT = 110, $g___MaxSession_USE = 106, $g___LastSession = 0
Global $g___sBaseURL[$g___MaxSession_TT], $g___UserAgent[$g___MaxSession_TT]
Global $g___retData[$g___MaxSession_TT][2]
Global $g___ftpOpen[$g___MaxSession_TT], $g___ftpConnect[$g___MaxSession_TT]
Global $g___hOpen[$g___MaxSession_TT], $g___hConnect[$g___MaxSession_TT], $g___hRequest[$g___MaxSession_TT], $g___hWebSocket[$g___MaxSession_TT]
Global $g___oWinHTTP[$g___MaxSession_TT]
Global $g___hProxy[$g___MaxSession_TT][5]
Global $g___hCredential[$g___MaxSession_TT][2]
Global $g___hCookie[$g___MaxSession_TT], $g___hCookieLast = '', $g___hCookieDomain = '', $g___hCookieRemember = False
Global $g___CookieJarPath = ''
Global $g___CookieJarINI = ObjCreate("Scripting.Dictionary")
$g___CookieJarINI.CompareMode = 1
Global Const $def___sChr64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
Global Const $def___aChr64 = StringSplit($def___sChr64, "", 2)
Global Const $def___sPadding = '='
Global $g___sChr64 = $def___sChr64
Global $g___aChr64 = $def___aChr64
Global $g___sPadding = $def___sPadding
Global $g___hWinHttp_StatusCallback, $g___pWinHttp_StatusCallback, $g___hWinInet_StatusCallback, $g___pWinInet_StatusCallback
Global $g___JsLibGunzip = '', $g___JsLibLZString, $g___JsLibJSON = '', $g___jQueryLib = '', $g___aMemJsonParse[4]
Global $g___aReadWriteData = [['char', 'byte'], [StringMid, BinaryMid], [StringLen, BinaryLen]]
Global $g___oDicEntity, $g___oDicHiddenSearch
Global $g___OnlineCompilerTimer = TimerInit()
Global $g___swCancelReadWrite = True
Global $g___swModeObject = False
Global $g___BytesPerLoop = 8192
Global $g___ErrorNotify = True
Global $g___LocationRedirect = ''
Global $g___CheckConnect = ''
Global $g___aVietPattern = ''
Global $g___sData2Send = ''
Global $g___OldConsole = ''
Global $g___iReadMode = 0
Global $g___MIMEData = ''
Global $g___Boundary = ''
Global $g___ServerIP = ''
Global $g___CertInfo = ''
Global $g___TimeOut = ''
Global $g___aChrEnt = ''
OnAutoItExitRegister('__HttpRequest_CloseAll')
__HttpRequest_CancelReadWrite()
__SciTE_ConsoleWrite_FixFont()
ConsoleWrite(@CRLF)
Func _HttpRequest($iReturn, $sURL = '', $sData2Send = '', $sCookie = '', $sReferer = '', $sAdditional_Headers = '', $sMethod = '', $CallBackFunc_Progress = '')
If StringRegExp($iReturn, '(?i)^\h*?curl\h+') Then
Local $vData = _HttpRequest_ParseCURL($iReturn)
Return SetError(@error, @extended, $vData)
ElseIf $g___swModeObject Then
Local $vRet = _oHttpRequest($iReturn, $sURL, $sData2Send, $sCookie, $sReferer, $sAdditional_Headers, $sMethod)
Return SetError(@error, @extended, $vRet)
EndIf
Local $aRetMode = __HttpRequest_iReturnSplit($iReturn)
If @error Then Return SetError(2, -1, '')
$g___LastSession = $aRetMode[8]
If StringRegExp($sURL, '^\h*?/\w?') And $g___sBaseURL[$g___LastSession] Then $sURL = $g___sBaseURL[$g___LastSession] & $sURL
Local $aURL = __HttpRequest_URLSplit($sURL)
If @error Then Return SetError(1, -1, '')
Local $vContentType = '', $vAcceptType = '', $vUserAgent = '', $vBoundary = '', $vConnectReset = 0, $vUpload = 0, $vWebsocket = 0
Local $sServerUserName = '', $sServerPassword = '', $sProxyUserName = '', $sProxyPassword = ''
$g___LocationRedirect = ''
$g___sData2Send = ''
$g___retData[$g___LastSession][0] = ''
$g___retData[$g___LastSession][1] = Binary('')
If $aURL[0] = 3 Then
Local $vRet = _FtpRequest($aRetMode, $aURL, $sData2Send, $CallBackFunc_Progress)
Return SetError(@error, @extended, $vRet)
EndIf
If $g___hRequest[$g___LastSession] Then $g___hRequest[$g___LastSession] = _WinHttpCloseHandle2($g___hRequest[$g___LastSession])
If $g___hWebSocket[$g___LastSession] Then $g___hWebSocket[$g___LastSession] = _WinHttpWebSocketClose2($g___hWebSocket[$g___LastSession])
If Not $g___hOpen[$g___LastSession] Then
If $g___hConnect[$g___LastSession] Then $g___hConnect[$g___LastSession] = _WinHttpCloseHandle2($g___hConnect[$g___LastSession])
$g___hOpen[$g___LastSession] = _WinHttpOpen2()
_WinHttpSetOption2($g___hOpen[$g___LastSession], 84, 0xA80)
_WinHttpSetOption2($g___hOpen[$g___LastSession], 88, 2)
If $aRetMode[17] Then _WinHttpSetOption2($g___hOpen[$g___LastSession], 118, 3)
$vConnectReset = 1
EndIf
If $vConnectReset = 1 Or $g___CheckConnect <> $g___LastSession & $aURL[2] & $aURL[1] Then
$vConnectReset = 0
$g___CheckConnect = $g___LastSession & $aURL[2] & $aURL[1]
If $g___hConnect[$g___LastSession] Then $g___hConnect[$g___LastSession] = _WinHttpCloseHandle2($g___hConnect[$g___LastSession])
$g___hConnect[$g___LastSession] = _WinHttpConnect2($g___hOpen[$g___LastSession], $aURL[2], $aURL[1])
EndIf
If IsArray($sData2Send) Then $sData2Send = _HttpRequest_DataFormCreate($sData2Send)
If $aURL[8] Or $aRetMode[13] Then $vWebsocket = 1
$sMethod =($vWebsocket ? 'GET' :($sMethod ? $sMethod :($sData2Send ? 'POST' : 'GET')))
$g___hRequest[$g___LastSession] = _WinHttpOpenRequest2($g___hConnect[$g___LastSession], $sMethod, $aURL[3],($aURL[0] - 1) * 0x800000)
_WinHttpSetOption2($g___hRequest[$g___LastSession], 31, 0x3300)
_WinHttpSetOption2($g___hRequest[$g___LastSession], 110, 1)
_WinHttpSetOption2($g___hRequest[$g___LastSession], 47, 0)
If $g___TimeOut Then _WinHttpSetTimeouts2($g___hRequest[$g___LastSession], $g___TimeOut, $g___TimeOut, $g___TimeOut)
If $vWebsocket And _WinHttpSetOptionEx2($g___hRequest[$g___LastSession], 114, 0, True) = 0 Then
Return SetError(113, __HttpRequest_ErrNotify('_HttpRequest', 'WebSocket đã upgrade thất bại', -1), '')
EndIf
If $aRetMode[3] Then _WinHttpSetOption2($g___hRequest[$g___LastSession], 63, 2)
If $aRetMode[5] Then
_WinHttpSetProxy2($g___hRequest[$g___LastSession], $aRetMode[5])
$sProxyUserName = $aRetMode[6]
$sProxyPassword = $aRetMode[7]
ElseIf $g___hProxy[$g___LastSession][0] Then
_WinHttpSetProxy2($g___hRequest[$g___LastSession], $g___hProxy[$g___LastSession][0], $g___hProxy[$g___LastSession][2])
$sProxyUserName = $g___hProxy[$g___LastSession][3]
$sProxyPassword = $g___hProxy[$g___LastSession][4]
EndIf
If $sProxyUserName Then _WinHttpSetCredentials2($g___hRequest[$g___LastSession], $sProxyUserName, $sProxyPassword, 1, 1)
If $aURL[4] Then
$sServerUserName = $aURL[4]
$sServerPassword = $aURL[5]
ElseIf $g___hCredential[$g___LastSession][0] Then
$sServerUserName = $g___hCredential[$g___LastSession][0]
$sServerPassword = $g___hCredential[$g___LastSession][1]
EndIf
If $sServerUserName Then _WinHttpSetCredentials2($g___hRequest[$g___LastSession], $sServerUserName, $sServerPassword, 0, 1)
If $sAdditional_Headers Then
Local $aAddition = StringRegExp($sAdditional_Headers, '(?i)\h*?([\w\-]+)\h*:\h*(.*?)(?:\||$)', 3)
$sAdditional_Headers = ''
For $i = 0 To UBound($aAddition) - 1 Step 2
Switch $aAddition[$i]
Case 'Accept'
$vAcceptType = $aAddition[$i + 1]
Case 'Content-Type'
$vContentType = $aAddition[$i] & ': ' & $aAddition[$i + 1]
Case 'Referer'
If Not $sReferer Then $sReferer = $aAddition[$i + 1]
Case 'Cookie'
If Not $sCookie Then $sCookie = $aAddition[$i + 1]
Case 'User-Agent'
$vUserAgent = $aAddition[$i + 1]
Case Else
$sAdditional_Headers &= $aAddition[$i] & ': ' & $aAddition[$i + 1] & @CRLF
EndSwitch
Next
EndIf
$sAdditional_Headers &= 'User-Agent: ' &($vUserAgent ? $vUserAgent :($g___UserAgent[$g___LastSession] ? $g___UserAgent[$g___LastSession] : $g___defUserAgentW)) & @CRLF
$sAdditional_Headers &= 'Accept: ' &($vAcceptType ? $vAcceptType : '*/*') & @CRLF
$sAdditional_Headers &= 'DNT: 1' & @CRLF
If $aRetMode[15] And Not StringRegExp($sAdditional_Headers, '(?im)^\h*?X-Forwarded-For\h*?:') Then $sAdditional_Headers &= 'X-Forwarded-For: ' & _HttpRequest_GenarateIP() & @CRLF
If $sReferer Then $sAdditional_Headers &= 'Referer: ' & StringRegExpReplace($sReferer, '(?i)^\h*?Referer\h*?:\h*', '', 1) & @CRLF
If $sCookie Then
If $sMethod = 'POST' And StringInStr($aURL[3], 'login', 0, 1) Then __HttpRequest_ErrNotify('_HttpRequest', 'Nạp Cookie vào request liên quan đến Login có thể khiến request thất bại', '', 'Warning')
If $sCookie == -1 Or $sCookie = 'CookieJar' Then
If Not $g___CookieJarPath Then Return SetError(9, __HttpRequest_ErrNotify('_HttpRequest', 'CookieJar chưa được active. Vui lòng khởi tạo _HttpRequest_CookieJarSet', -1), '')
$sCookie = _HttpRequest_CookieJarSearch($sURL)
Else
$sCookie = StringRegExpReplace($sCookie, '(?i)^\h*?Cookie\h*?:\h*', '', 1)
EndIf
If $g___hCookieRemember And($g___hCookieLast <> $sCookie Or $g___hCookieDomain <> $aURL[9]) Then
__CookieGlobal_Insert($aURL[9], $sCookie)
$g___hCookieDomain = $aURL[9]
$g___hCookieLast = $sCookie
EndIf
EndIf
If $g___hCookieRemember And $g___hCookie[$g___LastSession] Then $sCookie = __CookieGlobal_Search($sURL)
If $sCookie Then $sAdditional_Headers &= 'Cookie: ' & $sCookie & @CRLF
If $sData2Send Then
If Not $g___Boundary And StringInStr($vContentType, 'multipart', 0, 1) Then
$vBoundary = StringRegExp($vContentType, '(?i);\h*?boundary\h*?=\h*?([\w\-]+)', 1)
If Not @error Then
$g___Boundary = '--' & $vBoundary[0]
If Not StringRegExp($sData2Send, '(?is)^' & $g___Boundary) Then
Return SetError(22, __HttpRequest_ErrNotify('_HttpRequest', '$sData2Send có Boundary không khớp với khai báo ở header Content-Type', -1), '')
ElseIf Not StringRegExp($sData2Send, '(?is)' & $g___Boundary & '--\R*?$') Then
Return SetError(23, __HttpRequest_ErrNotify('_HttpRequest', 'Chuỗi Boundary ở cuối $sData2Send phải có -- ở cuối', -1), '')
EndIf
EndIf
EndIf
If $g___Boundary Then
If Not $vContentType Then $vContentType = 'Content-Type: multipart/form-data; boundary=' & StringTrimLeft($g___Boundary, 2)
$g___Boundary = ''
$vUpload = 1
Else
If Not $vContentType Then
If StringRegExp($sData2Send, '^\h*?[\{\[]') Then
$vContentType = 'Content-Type: application/json'
Else
$vContentType = 'Content-Type: application/x-www-form-urlencoded'
__Data2Send_CheckEncode($sData2Send)
EndIf
EndIf
EndIf
EndIf
If $g___hWinHttp_StatusCallback Then DllCallbackFree($g___hWinHttp_StatusCallback)
$g___hWinHttp_StatusCallback = DllCallbackRegister("__HttpRequest_StatusCallback", "none", "handle;dword_ptr;dword;ptr;dword")
_WinHttpSetStatusCallback2($g___hRequest[$g___LastSession], DllCallbackGetPtr($g___hWinHttp_StatusCallback), 0x00014002)
If Not _WinHttpSendRequest2($g___hRequest[$g___LastSession], $sAdditional_Headers & $vContentType, $vWebsocket ? '' : $sData2Send, $vUpload, $CallBackFunc_Progress) Then
If @error = 999 Then Return SetError(999, -1, '')
Return SetError(4, __HttpRequest_ErrNotify('_HttpRequest', 'Gửi request thất bại', -1), '')
EndIf
If $aRetMode[14] Then Return True
If Not _WinHttpReceiveResponse2($g___hRequest[$g___LastSession]) Then
Local $ErrorCode = DllCall($dll_Kernel32, "dword", "GetLastError")[0]
If $ErrorCode = 0 Then $ErrorCode = 12003
Local $ErrorString = _WinHttpGetResponseErrorCode2($ErrorCode)
Return SetError(5, __HttpRequest_ErrNotify('_HttpRequest', 'Không nhận được response từ Server. Mã lỗi: ' & $ErrorCode & ' (' & $ErrorString & ')', -1), '')
EndIf
$g___sData2Send = $sData2Send
Local $vResponse_StatusCode = _WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 19)
Switch $vResponse_StatusCode
Case 0
Return SetError(6, -1, '')
Case 404
Local $aURLwithHashTag = StringRegExp($sURL, '(?m)(.*)(\#[\w\.\-]+)$', 3)
If Not @error Then
__HttpRequest_ErrNotify('_HttpRequest', 'Vui lòng bỏ chỉ định mục con (HashTag) ở đuôi URL ( ' & $aURLwithHashTag[1] & ' ) để tránh lãng phí thời gian Redirect', '', 'Warning')
Local $sHeader = _WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 22)
Local $vReturn = _HttpRequest($iReturn, $aURLwithHashTag[0], $sData2Send, $sCookie, $sReferer, $sAdditional_Headers, $sMethod, $CallBackFunc_Progress)
Local $aExtraInfo = [@error, @extended]
$g___retData[$g___LastSession][0] = $sHeader & @CRLF & 'Redirect → [' & $aURLwithHashTag[0] & ']' & @CRLF & $g___retData[$g___LastSession][0]
If $iReturn = 1 Then
$vReturn = $g___retData[$g___LastSession][0]
ElseIf $iReturn = 4 Or $iReturn = 5 Then
$vReturn[0] = $g___retData[$g___LastSession][0]
EndIf
Return SetError($aExtraInfo[0], $aExtraInfo[1], $vReturn)
EndIf
Case 401, 407
If($vResponse_StatusCode = 401 And $sServerUserName = '') Then
__HttpRequest_ErrNotify('_HttpRequest', $aURL[2] & ' yêu cầu phải có quyền truy cập')
ElseIf($vResponse_StatusCode = 407 And $sProxyUserName = '') Then
__HttpRequest_ErrNotify('_HttpRequest', 'Proxy này yêu cầu quyền phải có truy cập')
Else
For $i = 1 To 3
_HttpRequest_ConsoleWrite('> Đang tiến hành Authentication ... (' & $i & ')' & @CRLF)
Local $aSchemes = _WinHttpQueryAuthSchemes2($g___hRequest[$g___LastSession])
If @error Then ContinueLoop(1 + 0 * __HttpRequest_ErrNotify('_WinHttpQueryAuthSchemes2', 'Không lấy được Authorization Schemes'))
If $aSchemes[1] = 0 Then
_WinHttpSetCredentials2($g___hRequest[$g___LastSession], $sServerUserName, $sServerPassword, 0, $aSchemes[0])
Else
_WinHttpSetCredentials2($g___hRequest[$g___LastSession], $sProxyUserName, $sProxyPassword, 1, $aSchemes[0])
EndIf
If @error Then ContinueLoop(1 + 0 * __HttpRequest_ErrNotify('_WinHttpSetCredentials2', 'Cài đặt Credentials thất bại'))
_WinHttpSendRequest2($g___hRequest[$g___LastSession])
_WinHttpReceiveResponse2($g___hRequest[$g___LastSession])
$vResponse_StatusCode = _WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 19)
If $vResponse_StatusCode <> 401 And $vResponse_StatusCode <> 407 Then ExitLoop
Next
If $i = 4 Then __HttpRequest_ErrNotify('_HttpRequest', 'Quá trình Authentication thất bại')
EndIf
Case 445
Local $iTimerInit = TimerInit()
Do
If TimerDiff($iTimerInit) > 20000 Then ExitLoop
Sleep(Random(100, 300, 1))
_WinHttpSendRequest2($g___hRequest[$g___LastSession])
_WinHttpReceiveResponse2($g___hRequest[$g___LastSession])
$vResponse_StatusCode = _WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 19)
Until $vResponse_StatusCode <> 445
Case 429
Local $aTimeLimit = StringRegExp(_WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 22), '(?i)Retry-After: (\d+)', 1)
If Not @error Then __HttpRequest_ErrNotify('_HttpRequest', 'Thực hiện quá nhiều request. Vui lòng chờ ' & $aTimeLimit[0] & 's mới thực hiện request tiếp hoặc thay đổi Proxy')
EndSwitch
$g___retData[$g___LastSession][0] &= __CookieJar_Insert($aURL[2], _WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 22))
If $vWebsocket Then
_WinHttpWebSocketRequest($sData2Send)
If @error Then Return SetError(@error, $vResponse_StatusCode, $aRetMode[0] = 1 ? $g___retData[$g___LastSession][0] : False)
Return SetError(0, $vResponse_StatusCode, $aRetMode[0] = 1 ? $g___retData[$g___LastSession][0] : True)
EndIf
If $g___hWinHttp_StatusCallback Then DllCallbackFree($g___hWinHttp_StatusCallback)
Switch $aRetMode[0]
Case 0, 1
If $aRetMode[2] Then
$sCookie = _GetCookie($g___retData[$g___LastSession][0])
Return SetError(@error ? 7 : 0, $vResponse_StatusCode, $sCookie)
Else
Return SetError(0, $vResponse_StatusCode, $g___retData[$g___LastSession][0])
EndIf
Case 2 To 5
If $aRetMode[9] Then
_WinHttpReadData_Ex($g___hRequest[$g___LastSession], $CallBackFunc_Progress, $aRetMode[9], $aRetMode[10])
Return SetError(@error, $vResponse_StatusCode, $g___retData[$g___LastSession][0])
EndIf
$g___retData[$g___LastSession][1] = _WinHttpReadData_Ex($g___hRequest[$g___LastSession], $CallBackFunc_Progress)
If @error Then Return SetError(@error, $vResponse_StatusCode, '')
If StringRegExp(BinaryMid($g___retData[$g___LastSession][1], 1, 1), '(?i)0x(1F|08|8B)') Then $g___retData[$g___LastSession][1] = __Gzip_Uncompress($g___retData[$g___LastSession][1])
If $aRetMode[2] = 1 Or $aRetMode[0] = 3 Or $aRetMode[0] = 5 Then
If $aRetMode[0] < 4 Then
Return SetError(0, $vResponse_StatusCode, $g___retData[$g___LastSession][1])
Else
Local $aRet = [$g___retData[$g___LastSession][0], $g___retData[$g___LastSession][1]]
Return SetError(0, $vResponse_StatusCode, $aRet)
EndIf
Else
Local $sRet = $g___retData[$g___LastSession][1]
$sRet = BinaryToString($sRet, $aRetMode[11])
If $aRetMode[12] Then
$sRet = _HTML_Execute($sRet)
ElseIf $aRetMode[4] Then
$sRet = _HTML_AbsoluteURL($sRet, $aURL[7] & '://' & $aURL[2] & $aURL[3], '', $aURL[7])
ElseIf $aRetMode[16] Then
$sRet = _HTMLDecode($sRet)
EndIf
If $aRetMode[0] < 4 Then
Return SetError(0, $vResponse_StatusCode, $sRet)
Else
Local $aRet = [$g___retData[$g___LastSession][0], $sRet]
Return SetError(0, $vResponse_StatusCode, $aRet)
EndIf
EndIf
Case 6
Local $aIPAndGeo = _GetIPAndGeoInfo()
Return SetError(@error ? 8 : 0, $vResponse_StatusCode, $aIPAndGeo)
Case 7, 8, 9
Exit MsgBox(4096, 'Thông báo', '$iReturn 7, 8, 9 đã bị loại bỏ, xin vui lòng sửa lại code')
EndSwitch
EndFunc
Func _HttpRequest_SessionList()
Local $aListSession[0], $iCounter = 0
For $i = 0 To $g___MaxSession_USE - 1
If $g___hOpen[$i] Then
ReDim $aListSession[$iCounter + 1]
$aListSession[$iCounter] = $i
$iCounter += 1
EndIf
Next
Return $aListSession
EndFunc
Func _HttpRequest_SessionClear($nSessionNumber = 0, $vClearProxy = False)
If $nSessionNumber = Default Then $nSessionNumber = 0
If $nSessionNumber < 0 Or $nSessionNumber > $g___MaxSession_USE - 1 Then Exit MsgBox(4096, 'Lỗi', '$nSessionNumber chỉ có thể từ số từ 0 đến ' & $g___MaxSession_USE - 1)
$g___hCookieLast = ''
$g___retData[$nSessionNumber][0] = ''
$g___retData[$nSessionNumber][1] = Binary('')
$g___hCookie[$nSessionNumber] = ''
If $g___hOpen[$nSessionNumber] Then $g___hOpen[$nSessionNumber] = 0 * _WinHttpCloseHandle2($g___hOpen[$nSessionNumber])
If $g___ftpOpen[$nSessionNumber] Then $g___ftpOpen[$nSessionNumber] = 0 * _FTP_CloseHandle2($g___ftpOpen[$nSessionNumber])
If $vClearProxy Then _HttpRequest_SetProxy()
If $g___CookieJarPath Then _HttpRequest_CookieJarUpdateToFile()
EndFunc
Func _HttpRequest_Test($sData, $FilePath = Default, $iEncoding = Default, $iShellExecute = True)
If Not $sData Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_Test', 'Không thể ghi dữ liệu vì $sData là rỗng'), '')
If Not $FilePath Or IsKeyword($FilePath) Then $FilePath = @TempDir & '\Test.html'
If StringRegExp($FilePath, '(?i)\.html$') Then $sData = StringRegExpReplace($sData, "(?i)<script>\h*?if \(document\.location\.protocol \!=\h*?[""']https:?[""']\h*?\).*?</script>", '', 1)
If $iEncoding = Default Then $iEncoding = 128
If IsBinary($sData) Or(StringRegExp($sData, '(?i)^0x[[:xdigit:]]+$') And Mod(StringLen($sData), 2) = 0) Then
$iEncoding = 16
ElseIf StringRegExp(_HttpRequest_DetectMIME($FilePath), '(?i)^(audio|image|video)\/') Then
Return SetError(2, __HttpRequest_ErrNotify('_HttpRequest_Test', 'Vui lòng dùng _HttpRequest ở mode $iReturn = -2 hoặc $iReturn = 3 để lấy dữ liệu dạng Binary mới ghi được loại tập tin này'))
EndIf
Local $l___hOpen = FileOpen($FilePath, 2 + 8 + $iEncoding)
FileWrite($l___hOpen, $sData)
FileClose($l___hOpen)
If $iShellExecute Or $iShellExecute = Default Then ShellExecute($FilePath)
EndFunc
Func _HttpRequest_DataFormCreate($a_FormItems, $sFilenameDefault = Default, $_Boundry = Default)
$g___Boundary =($_Boundry = Default Or $_Boundry = '') ? _BoundaryGenerator() : $_Boundry
Local $sData2Send = $g___Boundary & @CRLF, $vValue, $PatternError = 0, $isFilePathDeclare = 0
If Not IsArray($a_FormItems) Then
$PatternError = 1
ElseIf UBound($a_FormItems, 0) < 1 And UBound($a_FormItems, 0) > 2 Then
$PatternError = 1
ElseIf UBound($a_FormItems, 0) = 1 Then
For $i = 0 To UBound($a_FormItems) - 1
If Not StringRegExp($a_FormItems[$i], '^([^=]+=|[^:]+: )') Then
$PatternError = 1
ExitLoop
EndIf
Next
ElseIf UBound($a_FormItems, 0) = 2 And UBound($a_FormItems, 2) <> 2 Then
$PatternError = 1
EndIf
If $PatternError = 1 Then
Exit MsgBox(4096, 'Lỗi', 'Tham số của _HttpRequest_DataFormCreate phải là mảng có dạng như sau: [["key1", "value1"], ["key2", "value2"], ...] hoặc ["key1=value1", "key2=value2"], ...')
EndIf
If UBound($a_FormItems, 0) = 1 Then
Local $ArrayTemp = $a_FormItems, $uBound = UBound($ArrayTemp), $aRegExp
ReDim $a_FormItems[$uBound][2]
For $i = 0 To $uBound - 1
$ArrayTemp[$i] = StringRegExp($ArrayTemp[$i], '(?s)^([^\:\=]+)(?:\=|\:\s)(.*$)', 3)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_HttpRequest_DataFormCreate', 'Lỗi không xác định'), '')
$a_FormItems[$i][0] =($ArrayTemp[$i])[0]
$a_FormItems[$i][1] =($ArrayTemp[$i])[1]
Next
EndIf
If UBound($a_FormItems, 0) = 2 Then
Local $l__uBound = UBound($a_FormItems) - 1
For $i = 0 To $l__uBound
$isFilePathDeclare = StringRegExp($a_FormItems[$i][1], '^\@[^\r\n]{1,200}\.\w+$')
Select
Case StringLeft($a_FormItems[$i][0], 1) == '$' Or $isFilePathDeclare = 1
If $isFilePathDeclare Then $a_FormItems[$i][1] = StringTrimLeft($a_FormItems[$i][1], 1)
If StringLeft($a_FormItems[$i][0], 1) == '$' Then $a_FormItems[$i][0] = StringTrimLeft($a_FormItems[$i][0], 1)
If FileExists($a_FormItems[$i][1]) Then
If StringRegExp($a_FormItems[$i][1], '^[^\\]+\.?\w+?$') Then $a_FormItems[$i][1] = @ScriptDir & '\' & $a_FormItems[$i][1]
$vValue = _GetFileInfo($a_FormItems[$i][1])
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_HttpRequest_DataFormCreate', 'Không xác định được tập tin đầu vào'), '')
Else
Local $vValue[3] = ['unknown_name', 'application/octet-stream',(StringLeft($a_FormItems[$i][1], 2) = '0x' ? BinaryToString($a_FormItems[$i][1]) : $a_FormItems[$i][1])]
EndIf
If $sFilenameDefault And $sFilenameDefault <> Default Then
$vValue[0] = $sFilenameDefault
$vValue[1] = _HttpRequest_DetectMIME($vValue[0])
EndIf
If StringInStr($a_FormItems[$i][0], '/', 1, 1) Then
Local $a_FormItems_Split = StringRegExp($a_FormItems[$i][0], '^([^\/]+)\/(.+)$', 3)
If @error Then Return SetError(4, __HttpRequest_ErrNotify('_HttpRequest_DataFormCreate', 'Mẫu Key sai'), '')
$a_FormItems[$i][0] = $a_FormItems_Split[0]
$vValue[0] = $a_FormItems_Split[1]
$vValue[1] = _HttpRequest_DetectMIME($vValue[0])
EndIf
If $vValue[0] == 'unknown_name' Then __HttpRequest_ErrNotify('_HttpRequest_DataFormCreate', 'Dữ liệu cần upload không xác định được kiểu tập tin', '', 'Warning')
Case StringLeft($a_FormItems[$i][0], 1) == '~'
$a_FormItems[$i][0] = StringTrimLeft($a_FormItems[$i][0], 1)
$vValue = _Utf8ToAnsi($a_FormItems[$i][1])
Case Else
$vValue = $a_FormItems[$i][1]
EndSelect
$sData2Send &= 'Content-Disposition: form-data; name="' & $a_FormItems[$i][0] & '"'
If UBound($vValue) > 2 Then
$sData2Send &= '; filename="' & _Utf8ToAnsi($vValue[0]) & '"' & @CRLF & 'Content-Type: ' & $vValue[1] & @CRLF & @CRLF & $vValue[2]
Else
$sData2Send &= @CRLF & @CRLF & $vValue
EndIf
$sData2Send &= @CRLF & $g___Boundary & @CRLF
Next
Else
Return SetError(6, __HttpRequest_ErrNotify('_HttpRequest_DataFormCreate', '$a_FormItems phải là mảng 1D hoặc 2D Array'), '')
EndIf
Return StringTrimRight($sData2Send, 2) & '--'
EndFunc
Func _HttpRequest_SetProxy($__Proxy = '', $___ProxyUserName = '', $___ProxyPassword = '', $___ProxyBypass = '', $iSession = Default)
If IsKeyword($iSession) Or $iSession == '' Then $iSession = $g___LastSession
$__Proxy = StringStripWS($__Proxy, 8)
Local $BkProxy = [$g___hProxy[$iSession][0], $g___hProxy[$iSession][2], $g___hProxy[$iSession][3]]
If $__Proxy Then
If Not StringRegExp($__Proxy, '^(https?://)?[\d\.]+:\d+$') Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_SetProxy', 'Proxy sai định dạng. Ví dụ mẫu Proxy đúng: 127.0.0.1:80'), '')
$g___hProxy[$iSession][3] =(($___ProxyUserName And Not IsKeyword($___ProxyUserName)) ? $___ProxyUserName : '')
$g___hProxy[$iSession][4] =(($___ProxyPassword And Not IsKeyword($___ProxyPassword)) ? $___ProxyPassword : '')
$g___hProxy[$iSession][2] =(($___ProxyBypass And Not IsKeyword($___ProxyBypass)) ? $___ProxyBypass : '')
$g___hProxy[$iSession][0] =(($__Proxy And Not IsKeyword($__Proxy)) ? $__Proxy : '')
Else
$g___hProxy[$iSession][0] = ''
EndIf
Return $BkProxy
EndFunc
Func _HttpRequest_SetAuthorization($___sUserName = '', $___sPassword = '', $iSession = Default)
If IsKeyword($iSession) Or $iSession == '' Then $iSession = $g___LastSession
Local $___sbkUP = $g___hCredential[$iSession][0] & ':' & $g___hCredential[$iSession][1]
If IsKeyword($___sUserName) Then $___sUserName = ''
If IsKeyword($___sPassword) Then $___sPassword = ''
If $___sPassword == '' And StringInStr($___sUserName, ':', 1, 1) Then
Local $aSplitUP = StringSplit($___sUserName, ':')
$___sUserName = $aSplitUP[1]
$___sPassword = $aSplitUP[2]
EndIf
$g___hCredential[$iSession][0] = $___sUserName
$g___hCredential[$iSession][1] = $___sPassword
Return $___sbkUP
EndFunc
Func _HttpRequest_SearchHiddenValues($iSourceHtml_or_URL, $iKeySearch = '', $iURIEncodeValue = True, $iType = Default)
If $iType = Default Then $iType = 'hidden'
If Not $iKeySearch Or IsKeyword($iKeySearch) Then $iKeySearch = ''
If $iKeySearch Then $iKeySearch = StringSplit($iKeySearch, '|')
If StringRegExp($iSourceHtml_or_URL, '(?i)^https?://') And Not StringRegExp($iSourceHtml_or_URL, '[\r\n]') Then
$iSourceHtml_or_URL = _HttpRequest(2, $iSourceHtml_or_URL)
If @error Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_SearchHiddenValues', 'Request lấy source thất bại'), '')
EndIf
Local $aInput = StringRegExp($iSourceHtml_or_URL, '(?i)<input (.*?type=\\?["''](?:' & $iType & ')\\?[''"] [\S\s]*?)\/?>', 3)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_HttpRequest_SearchHiddenValues', 'Không tìm thấy Hidden Values'), '')
$aInput = __ArrayDuplicate($aInput)
Local $vName, $vValue, $_vName, $_vValue, $sRet, $isKeyExists, $aRet[0][2], $aCounter = 0
If IsObj($g___oDicHiddenSearch) Then
$g___oDicHiddenSearch.RemoveAll
Else
$g___oDicHiddenSearch = ObjCreate("Scripting.Dictionary")
$g___oDicHiddenSearch.CompareMode = 1
EndIf
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_HttpRequest_SearchHiddenValues', 'Không thể tạo Dictionary Object'), '')
With $g___oDicHiddenSearch
For $i = 0 To UBound($aInput) - 1
$isKeyExists = 0
$vName = StringRegExp($aInput[$i], '(?i)name\h*?=\h*?\\?[''"](.+?)\\?[''"]', 1)
If @error Then ContinueLoop
If($iURIEncodeValue = True And .Exists(_URIEncode($vName[0]))) Or($iURIEncodeValue = False And .Exists($vName[0])) Then
$isKeyExists = 1
For $k = 1 To 99
If($iURIEncodeValue = True And Not .Exists(_URIEncode($vName[0]) & '.' & $k)) Or($iURIEncodeValue = False And Not .Exists($vName[0] & '.' & $k)) Then
$vName[0] &= '.' & $k
ExitLoop
EndIf
Next
EndIf
If IsArray($iKeySearch) Then
For $k = 1 To $iKeySearch[0]
If StringRegExp($vName[0], '(?i)^\Q' & $iKeySearch[$k] & '\E\.?\d*?$') Then ExitLoop
Next
If $k > $iKeySearch[0] Then ContinueLoop
EndIf
$vValue = StringRegExp($aInput[$i], '(?i)value\h*?=\h*?\\?[''"](.*?)\\?[''"]', 1)
If @error Then ContinueLoop
$_vName =($iURIEncodeValue ? _URIEncode($vName[0]) : $vName[0])
$_vValue =($iURIEncodeValue ? _URIEncode($vValue[0]) : $vValue[0])
If $isKeyExists = 0 Then
$sRet &= $_vName & '=' & $_vValue & '&'
.Add($_vName & '.0', $_vValue)
If $_vName <> $vName[0] Then .Add($vName[0] & '.0', $_vValue)
EndIf
.Add($_vName, $_vValue)
If $_vName <> $vName[0] Then .Add($vName[0], $_vValue)
Next
Local $aRet[.Count][2], $aCounter = 0
For $oKey In $g___oDicHiddenSearch
$aRet[$aCounter][0] = $oKey
$aRet[$aCounter][1] = .Item($oKey)
$aCounter += 1
Next
.Add('all_array', $aRet)
.Add('all_string', StringTrimRight($sRet, 1))
EndWith
Return $g___oDicHiddenSearch
EndFunc
Func _HttpRequest_BypassCloudflare($URL_in, $iTimeout = Default, $iUselessParam = 0)
If $iUselessParam Then Return Asc(StringMid($URL_in, $iTimeout, 1))
If $iTimeout < 10000 Or $iTimeout = Default Or Not $iTimeout Then $iTimeout = 10000
If StringRight($URL_in, 1) <> '/' Then $URL_in &= '/'
Local $aURL_in = StringRegExp($URL_in, '(?i)^(https?://)([^\/]+)', 3)
If @error Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'URL đầu vào không chính xác'), '')
Local $sourceHtml = _HttpRequest(2, $URL_in, '', '', $URL_in, 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8|Accept-Language: en-GB,en;q=0.9')
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Request lấy Html thất bại'), '')
Local $tHidden = _HttpRequest_SearchHiddenValues($sourceHtml)
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Không tìm được các tham số hidden từ Html'), '')
Local $URL_out = '', $Bypass_CF, $jschl_answer, $rq
If StringInStr($sourceHtml, 'src="/cdn-cgi/scripts/cf.challenge.js"', 1, 1) Then
Local $id_data_ray = StringRegExp($sourceHtml, '(?i)data-ray="(.+?)"', 1)
If @error Then Return SetError(4, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Không tìm thấy data-ray từ Html'), '')
Local $g_recaptcha_response = _IE_RecaptchaBox($URL_in, Default, Default, Default, Default, StringRegExp($sourceHtml, 'sitekey\h*?=\h*?["''](.*?)["'']', 1)[0])
If @error Then Return SetError(5, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Giải ReCaptcha thất bại'), '')
_HttpRequest_ConsoleWrite('> [CloudFlare] Đã nhận được g-recaptcha-response: ' & $g_recaptcha_response & @CRLF & @CRLF)
$URL_out = $aURL_in[0] & $aURL_in[1] & '/cdn-cgi/l/chk_captcha?' & $tHidden('all_string') & '&id=' & $id_data_ray[0] & '&g-recaptcha-response=' & $g_recaptcha_response
Else
Local $cfDN = StringRegExp($sourceHtml, 'id="cf-dn-\w+">(.*?)</', 1), $isNewCF = Not @error
If $isNewCF Then
$sourceHtml = StringRegExpReplace($sourceHtml, 'function\((\w+)\)\{var \1\h*?=.*?;\h*?return \W\(\1\)\}\(\)', $cfDN[0])
$sourceHtml = StringRegExpReplace($sourceHtml, 'function\(\w+\)\{return\h+[^\}]+\}\(', '__StringCharCodeAt("' & $aURL_in[1] & '",')
EndIf
$sourceHtml = StringReplace(StringReplace($sourceHtml, '={"', '.', 1, 1), '":', '+=', 1, 1)
Local $number_jschl_math = StringRegExp($sourceHtml, '\.\w+([\+\-\*\/])=((?:[\!\+\-\*\/\[\]\(\)]|\Q__StringCharCodeAt("' & $aURL_in[1] & '",\E)+)', 3)
If @error Then Return SetError(6, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Không tìm được number_jschl_math từ Html'), '')
For $i = 1 To UBound($number_jschl_math) - 1 Step 2
$jschl_answer = '(' & $jschl_answer & $number_jschl_math[$i - 1] & $number_jschl_math[$i] & ')'
Next
$jschl_answer = Call('Execute', StringReplace(StringReplace(StringReplace(StringReplace($jschl_answer, '+!![]', '+1'), '!+[]', '+1'), '+[]', '+0'), '+(+', '+0&('))
$jschl_answer = Round(StringFormat('%.10f', $jschl_answer), 10)
$jschl_answer = $jschl_answer +($isNewCF ? 0 : StringLen($aURL_in[1]))
Local $tHidden = _HttpRequest_SearchHiddenValues($sourceHtml)
If @error Then Return SetError(7, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Không tìm được các tham số hidden từ Html'), '')
Local $challenge_form = StringRegExp($sourceHtml, '(?i)"challenge-form" action\h?=\h?"\/?([^"]+)"', 1)
If @error Then Return SetError(8, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Không tìm được challenge-form từ Html'), '')
$URL_out = $aURL_in[0] & $aURL_in[1] & '/' & $challenge_form[0] & '?' & $tHidden('all_string') & '&jschl_answer=' & $jschl_answer
_HttpRequest_ConsoleWrite('> [CloudFlare] Hãy chờ 5 giây ...')
For $i = 1 To 50
Sleep(100)
ConsoleWrite('.')
Next
ConsoleWrite(@CRLF & @CRLF)
EndIf
Local $sTimer = TimerInit()
Do
Sleep(200)
If TimerDiff($sTimer) > $iTimeout Then Return SetError(9, __HttpRequest_ErrNotify('_HttpRequest_BypassCloudflare', 'Timeout - Vượt CloudFlare thất bại'), '')
$rq = _HttpRequest(1, $URL_out, '', '', $URL_in, 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8|Accept-Language: en-GB,en;q=0.9')
$Bypass_CF = StringRegExp($rq, '(?i)(cf_clearance=[^;]+)', 1)
Until Not @error
ConsoleWrite('> [CloudFlare] Bypass Cookie : ' & $Bypass_CF[0] & @CRLF & @CRLF)
Return $Bypass_CF[0]
EndFunc
Func _HttpRequest_ConsoleWrite($sString)
ConsoleWrite($g___ConsoleForceANSI ? __RemoveVietMarktical($sString) : _Utf8ToAnsi($sString))
EndFunc
Func _HttpRequest_GenarateIP()
Return Random(1, 255, 1) & '.' & Random(1, 255, 1) & '.' & Random(1, 255, 1) & '.' & Random(1, 255, 1)
EndFunc
Func _Data2SendEncode($_Key1, $_Value1 = '', $_Key2 = '', $_Value2 = '', $_Key3 = '', $_Value3 = '', $_Key4 = '', $_Value4 = '', $_Key5 = '', $_Value5 = '', $_Key6 = '', $_Value6 = '', $_Key7 = '', $_Value7 = '', $_Key8 = '', $_Value8 = '', $_Key9 = '', $_Value9 = '', $_Key10 = '', $_Value10 = '', $_Key11 = '', $_Value11 = '', $_Key12 = '', $_Value12 = '', $_Key13 = '', $_Value13 = '', $_Key14 = '', $_Value14 = '', $_Key15 = '', $_Value15 = '', $_Key16 = '', $_Value16 = '', $_Key17 = '', $_Value17 = '', $_Key18 = '', $_Value18 = '', $_Key19 = '', $_Value19 = '', $_Key20 = '', $_Value20 = '')
Local $sResult = '', $sKey
If @NumParams = 1 Then
Local $sData2Send = $_Key1
Local $aData2Send = StringRegExp($sData2Send, '(?:^|\&)([^\=]+=?=?)(?:=)([^\&]*)', 3), $uBound = UBound($aData2Send)
If Mod($uBound, 2) Then Return $sData2Send
For $i = 0 To $uBound - 1 Step 2
If Not StringRegExp($aData2Send[$i], '\%\w\w?') Then $aData2Send[$i] = _URIEncode($aData2Send[$i])
If Not StringRegExp($aData2Send[$i + 1], '\%\w\w?') Then $aData2Send[$i + 1] = _URIEncode($aData2Send[$i + 1])
$sResult &= $aData2Send[$i] & '=' & $aData2Send[$i + 1] & '&'
Next
Else
Local $aParam = [$_Key1, $_Value1, $_Key2, $_Value2, $_Key3, $_Value3, $_Key4, $_Value4, $_Key5, $_Value5, $_Key6, $_Value6, $_Key7, $_Value7, $_Key8, $_Value8, $_Key9, $_Value9, $_Key10, $_Value10, $_Key11, $_Value11, $_Key12, $_Value12, $_Key13, $_Value13, $_Key14, $_Value14, $_Key15, $_Value15, $_Key16, $_Value16, $_Key17, $_Value17, $_Key18, $_Value18, $_Key19, $_Value19, $_Key20, $_Value20]
For $i = 0 To UBound($aParam) - 1 Step 2
If $aParam[$i] == '' Then ExitLoop
$sResult &= _URIEncode($aParam[$i]) & '=' & _URIEncode($aParam[$i + 1]) & '&'
Next
EndIf
Return StringTrimRight($sResult, 1)
EndFunc
Func _BoundaryGenerator()
Local $sData = ""
For $i = 1 To 12
$sData &= Random(1, 9, 1)
Next
Return('-----------------------------' & $sData)
EndFunc
Func _Utf8ToAnsi($sData)
Return BinaryToString(StringToBinary($sData, 4), 1)
EndFunc
Func _AnsiToUtf8($sData)
Return BinaryToString(StringToBinary($sData, 1), 4)
EndFunc
Func _URIEncode($sData, $vUTF8 = True, $iPassSpace = True)
If $sData == '' Then Return ''
If $vUTF8 = True Then $sData = _Utf8ToAnsi($sData)
$sData = _HTMLEncode($sData, '%', '', False, 2, False)
Return $iPassSpace ? StringReplace($sData, '%20', '+', 0, 1) : $sData
EndFunc
Func _URIDecode($sData, $vUTF8 = True, $iEntities = 0)
If $sData == '' Then Return ''
$sData = _HTMLDecode(StringReplace($sData, '+', ' ', 0, 1), '%', '', False, 2, True, $iEntities)
If $vUTF8 Then $sData = _AnsiToUtf8($sData)
Return $sData
EndFunc
Func _HTMLEncode($sData, $Escape_Character_Head = '\u', $Escape_Character_Tail = Default, $AnsiEncode = False, $iHexLength = Default, $iPassSpace = True)
If $sData == '' Then Return ''
If $iHexLength = Default Then $iHexLength = 4
If $Escape_Character_Tail = Default Then $Escape_Character_Tail = ''
Local $Asc_or_AscW =($iHexLength = 2 ? 'Asc' : 'AscW')
If $AnsiEncode Then
$sData = _Utf8ToAnsi($sData)
$Asc_or_AscW = 'Asc'
EndIf
Local $sResult = Call('Execute', '"' & StringReplace(StringRegExpReplace($sData, '([^\w\-\.\~' &($iPassSpace ? '\h' : '') & '])', '" & "\' & $Escape_Character_Head & '" & Hex(' & $Asc_or_AscW & '("${1}"), ' & $iHexLength & ') & "' & $Escape_Character_Tail), $Asc_or_AscW & '(""")', $Asc_or_AscW & '("""")', 0, 1) & '"')
If $sResult == '' Then Return SetError(1, __HttpRequest_ErrNotify('_HTMLEncode', 'Encode thất bại'), $sData)
Return $sResult
EndFunc
Func _HTMLDecode($sData, $Escape_Character_Head = '\u', $Escape_Character_Tail = Default, $AnsiDecode = False, $iHexLength = Default, $isHexNumber = True, $iEntities = 1)
If $sData == '' Then Return ''
Switch $iEntities
Case 1
$sData = __HTML_Entities_Decode($sData, False)
Case 2
$sData = __HTML_Entities_Decode($sData, True)
EndSwitch
If StringRegExp($sData, '&#[[:xdigit:]]{2};') Then $sData = __HTML_RegexpReplace($sData, '&#', ';', '2', False)
If StringRegExp($sData, '&#[[:xdigit:]]{3,4};') Then $sData = __HTML_RegexpReplace($sData, '&#', ';', '3,4', False)
If $iHexLength = Default Then
If StringRegExp($sData, '\Q' & $Escape_Character_Head & '\E\w{2}(\Q' & $Escape_Character_Head & '\E|$)') Then
$iHexLength = 2
ElseIf $Escape_Character_Tail And $Escape_Character_Tail <> Default Then
$iHexLength = '2,4'
Else
$iHexLength = '3,4'
EndIf
EndIf
If $Escape_Character_Tail = Default Then $Escape_Character_Tail = ';?'
Return __HTML_RegexpReplace($sData, $Escape_Character_Head, $Escape_Character_Tail, $AnsiDecode, $iHexLength, $isHexNumber)
EndFunc
Func _HttpRequest_DetectMIME($sFileName_Or_FilePath)
If $g___MIMEData = '' Then
$g___MIMEData &= ';ai|1/postscript;aif|2/x-aiff;aifc|2/x-aiff;aiff|2/x-aiff;asc|3/plain;atom|1/atom+xml;au|2/basic;avi|5/x-msvideo;bcpio|'
$g___MIMEData &= '4/bmp;cdf|1/x-netcdf;cgm|4/cgm;class|1/7/;cpio|1/x-bcpio;bin|1/7/;bmp|5/x-dv;dir|1/x-director;djv|4/vnd.djvu;djvu|'
$g___MIMEData &= '1/x-cpio;cpt|1/mac-compactpro;csh|1/x-csh;css|3/css;dcr|1/x-director;dif|4/vnd.djvu;dll|1/7/;dmg||1/msword;dtd|'
$g___MIMEData &= '3/x-setext;exe|1/7/;ez|1/andrew-inset;gif|4/gif;gram|2/midi;latex|1/x-latex;lha|1/7/;lzh|1/7/;m3u|2/mp4a-latm;m4b|'
$g___MIMEData &= '3/calendar;ief|4/ief;ifb|3/calendar;iges|6/iges;igs|6/iges;jnlp|1/x-java-jnlp-file;jp2|1/x-sv4cpio;sv4crc|1/x-sv4crc;svg|'
$g___MIMEData &= '3/vnd.wap.wmlscript;wmlsc|1/vnd.wap.wmlscriptc;wrl|6/vrml;xbm|4/svg+xml;swf|1/x-shockwave-flash;t|1/x-koan;skt|'
$g___MIMEData &= '4/pict;pict|4/pict;png|4/png;pnm|4/x-portable-anymap;pnt|4/x-macpaint;pntg|2/x-pn-realaudio;ras|4/x-cmu-raster;rdf|'
$g___MIMEData &= '4/x-macpaint;ppm|4/x-portable-pixmap;ppt|1/vnd.ms-powerpoint;ps|1/postscript;qt|1/rdf+xml;rgb|1/x-futuresplash;src|'
$g___MIMEData &= '5/quicktime;qti|4/x-quicktime;qtif|4/x-quicktime;ra|2/x-pn-realaudio;ram|1/vnd.rn-realmedia;roff|1/x-troff;rtf|3/rtf;rtx|'
$g___MIMEData &= '3/sgml;sh|1/x-sh;shar|1/x-shar;silo|6/mesh;sit|1/x-stuffit;skd|1/x-tcl;tex|1/x-tex;texi|1/x-texinfo;texinfo|1/x-texinfo;tif|'
$g___MIMEData &= '4/tiff;tiff|4/tiff;tr|1/x-troff;tsv|3/tab-separated-values;txt|3/plain;ustar|1/smil;snd|2/basic;so|1/x-ustar;vcd|6/vrml;vxml|'
$g___MIMEData &= '4/vnd.wap.wbmp;wbmxl|1/vnd.wap.wbxml;wml|3/vnd.wap.wml;wmlc|1/vnd.wap.wmlc;wmls|1/7/;spl|1/x-cdlink;vrml|'
$g___MIMEData &= '4/x-xbitmap;xht|1/xhtml+xml;xhtml|1/xhtml+xml;xls|1/vnd.ms-excel;xml|1/voicexml+xml;wav|2/wav;skm|1/xml;xpm|'
$g___MIMEData &= '1/xml-dtd;dv|5/x-dv;dvi|1/x-dvi;dxr|1/x-director;eps|1/postscript;etx|1/7/;dms|1/7/;doc|1/x-gtar;hdf|1/x-hdf;hqx|'
$g___MIMEData &= '1/mac-binhex40;htm|3/html;html|3/html;ice|x-conference/x-cooltalk;ico|4/x-icon;ics|1/srgs;grxml|1/srgs+xml;gtar|'
$g___MIMEData &= '4/jp2;jpe|4/jpeg;jpeg|4/jpeg;jpg|4/jpeg;js|1/x-javascript;kar|1/x-wais-source;sv4cpio|3/richtext;sgm|3/sgml;sgml|'
$g___MIMEData &= '2/x-mpegurl;m4a|2/mp4a-latm;m4p|2/mp4a-latm;m4u|5/vnd.mpegurl;m4v|1/x-troff;tar|1/x-tar;tcl|2/x-wav;wbmp|'
$g___MIMEData &= '5/x-m4v;mac|4/x-macpaint;man|1/x-troff-man;mathml|1/mathml+xml;me|1/xslt+xml;xul|1/vnd.mozilla.xul+xml;xwd|'
$g___MIMEData &= '1/x-troff-me;mesh|6/mesh;mid|2/midi;midi|2/midi;mif|1/vnd.mif;mov|4/x-portable-graymap;pgn|1/x-chess-pgn;pic|'
$g___MIMEData &= '5/quicktime;movie|5/x-sgi-movie;mp2|2/mpeg;mp3|2/mpeg;mp4|5/mp4;mpe|5/mpeg;mpeg|4/x-xwindowdump;xyz|'
$g___MIMEData &= '5/mpeg;mpg|5/mpeg;mpga|2/mpeg;ms|1/x-troff-ms;msh|6/mesh;mxu|5/vnd.mpegurl;nc|1/x-koan;smi|1/smil;smil|'
$g___MIMEData &= '1/x-netcdf;oda|1/oda;ogg|1/ogg;pbm|4/x-portable-bitmap;pct|4/pict;pdb|chemical/x-pdb;pdf|1/pdf;pgm|4/x-rgb;rm|'
$g___MIMEData &= '1/x-koan;skp|4/x-xpixmap;xsl|1/xml;xslt|chemical/x-xyz;zip|1/zip;xlsx|1/vnd.openxmlformats-officedocument.spread'
$g___MIMEData &= 'sheetml.sheet;doc|1/msword;dot|1/msword;docx|1/vnd.openxmlformats-officedocument.wordprocessingml.document;dotx|'
$g___MIMEData &= '1/vnd.openxmlformats-officedocument.wordprocessingml.template;docm|1/vnd.ms-word.document.macroEnabled.12;dotm|'
$g___MIMEData &= '1/vnd.ms-word.template.macroEnabled.12;xls|1/vnd.ms-excel;xlt|1/vnd.ms-excel;xla|1/vnd.ms-excel;xltx|1/vnd.openxml'
$g___MIMEData &= 'formats-officedocument.spreadsheetml.template;xlsm|1/vnd.ms-excel.sheet.macroEnabled.12;xltm|1/vnd.ms-excel.template.'
$g___MIMEData &= 'macroEnabled.12;xlam|1/vnd.ms-excel.addin.macroEnabled.12;xlsb|1/vnd.ms-excel.sheet.binary.macroEnabled.12;ppt|'
$g___MIMEData &= '1/vnd.ms-powerpoint;pot|1/vnd.ms-powerpoint;pps|1/vnd.ms-powerpoint;ppa|1/vnd.ms-powerpoint;pptx|1/vnd.openxmlfor'
$g___MIMEData &= 'mats-officedocument.presentationml.presentation;potx|1/vnd.openxmlformats-officedocument.presentationml.template;ppsx|'
$g___MIMEData &= '1/vnd.openxmlformats-officedocument.presentationml.slideshow;ppam|1/vnd.ms-powerpoint.addin.macroEnabled.12;pptm|'
$g___MIMEData &= '1/vnd.ms-powerpoint.presentation.macroEnabled.12;potm|1/vnd.ms-powerpoint.template.macroEnabled.12;ppsm|'
$g___MIMEData &= '1/vnd.ms-powerpoint.slideshow.macroEnabled.12;flac|2/flac;'
Local $aMshort = ['', 'application', 'audio', 'text', 'image', 'video', 'model', 'octet-stream']
For $i = 1 To 7
$g___MIMEData = StringReplace($g___MIMEData, $i & '/', $aMshort[$i] & '/', 0, 1)
Next
EndIf
Local $aArray = StringRegExp($g___MIMEData, "(?i)\Q;" & StringRegExpReplace($sFileName_Or_FilePath, "(.*?)\.(\w+)$", "$2") & "\E\|(.*?);", 1)
If @error Then
If FileExists($sFileName_Or_FilePath) Then
Local $fOpen = FileOpen($sFileName_Or_FilePath, 512)
Switch FileRead($fOpen, 4)
Case 'ÿØÿà'
Return 'image/jpg'
Case '‰PNG'
Return 'image/png'
Case 'BMN'
Return 'image/bmp'
EndSwitch
FileClose($fOpen)
EndIf
Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_DetectMIME', 'Không thể tra MIME của loại tập tin này. MIME sẽ được trả về mặc định là: application/octet-stream'), 'application/octet-stream')
Else
Return $aArray[0]
EndIf
EndFunc
Func _GetCertificateInfo($iSession = Default)
If IsKeyword($iSession) Or $iSession == '' Then $iSession = $g___LastSession
If Not $g___hRequest[$iSession] Then Return SetError(1, __HttpRequest_ErrNotify('_GetCertificateInfo', 'Phải thực hiện request đến trang đích trước'), '')
Local $tBuffer = _WinHttpQueryOptionEx2($g___hRequest[$iSession], 32)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_HttpRequest_CertificateInfo', 'Yêu cầu phải là https mới lấy được thông tin Certificate'), '')
Local $tCertInfo = DllStructCreate("dword ExpiryTime[2]; dword StartTime[2]; ptr SubjectInfo; ptr IssuerInfo; ptr ProtocolName; ptr SignatureAlgName; ptr EncryptionAlgName; dword KeySize", DllStructGetPtr($tBuffer))
Return DllStructGetData(DllStructCreate("wchar[256]", DllStructGetData($tCertInfo, "IssuerInfo")), 1)
EndFunc
Func _GetNameDNS($iSession = Default)
If IsKeyword($iSession) Or $iSession == '' Then $iSession = $g___LastSession
If Not $g___hRequest[$iSession] Then Return SetError(1, __HttpRequest_ErrNotify('_GetNameDNS', 'Phải thực hiện request đến trang đích trước'), '')
Local $tBuffer, $pCert_Context, $tCert_Info, $tCert_Encoding, $tCert_Ext, $aCall
$tBuffer = DllStructCreate("ptr")
DllCall($dll_WinHttp, "bool", 'WinHttpQueryOption', "handle", $g___hRequest[$iSession], "dword", 78, "struct*", $tBuffer, "dword*", DllStructGetSize($tBuffer))
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_GetNameDNS', 'Cài đặt option lấy DNS thất bại. Yêu cầu phải là https mới lấy được DNS'), '')
$pCert_Context = DllStructGetData($tBuffer, 1)
$tCert_Encoding = DllStructCreate("dword dwCertEncodingType; ptr pbCertEncoded; dword cbCertEncoded; ptr pCertInfo; handle hCertStore", $pCert_Context)
If $g___CertInfo = '' Then
$g___CertInfo = '«dw dwVersion; «dw SerialNumber_cbData; p SerialNumber_pbData»; «p SignatureAlgorithm_pszObjId; «dw SignatureAlgorithm_Parameters_cbData; p SignatureAlgorithm_Parameters_pbData»»; «dw Issuer_cbData; p Issuer_pbData»; «dw NotBefore_dwLowDateTime; dw NotBefore_dwHighDateTime»; «dw NotAfter_dwLowDateTime; dw NotAfter_dwHighDateTime»; «dw Subject_cbData; p Subject_pbData»; ««p SubjectPublicKeyInfo_Algorithm_pszObjId; «dw SubjectPublicKeyInfo_Parameters_cbData; p SubjectPublicKeyInfo_Parameters_pbData»»; «dw SubjectPublicKeyInfo_PublicKey_cbData; p ParametersSubjectPublicKeyInfo_pbData; dw SubjectPublicKeyInfo_PublicKey_cUnusedBits»»; «dw IssuerUniqueId_cbData; p IssuerUniqueId_pbData; dw IssuerUniqueId_cUnusedBits»; «dw dwSubjectUniqueId_cbData; p SubjectUniqueId_pbData; dw SubjectUniqueId_cUnusedBits»; dw cExtension; p rgExtension»;'
$g___CertInfo = StringReplace(StringReplace(StringReplace(StringReplace($g___CertInfo, 'dw ', 'dword '), 'p ', 'ptr '), '«', 'struct;'), '»', ';endstruct')
EndIf
$tCert_Info = DllStructCreate($g___CertInfo, DllStructGetData($tCert_Encoding, 'pCertInfo'))
$aCall = DllCall("Crypt32.dll", "ptr", "CertFindExtension", "str", "2.5.29.17", "dword", DllStructGetData($tCert_Info, 'cExtension'), "ptr", DllStructGetData($tCert_Info, 'rgExtension'))
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_GetNameDNS', 'Không tìm thấy Chứng nhận của DNS'), '')
$tCert_Ext = DllStructCreate("struct;ptr pszObjId;bool fCritical;struct;dword Value_cbData;ptr Value_pbData;endstruct;endstruct;", $aCall[0])
$aCall = DllCall("Crypt32.dll", "int", "CryptFormatObject", "dword", 1, "dword", 0, "dword", 1, "ptr", 0, "ptr", DllStructGetData($tCert_Ext, 'pszObjId'), "ptr", DllStructGetData($tCert_Ext, 'Value_pbData'), "dword", DllStructGetData($tCert_Ext, 'Value_cbData'), 'wstr', "", "dword*", 65536)
If @error Then Return SetError(4, __HttpRequest_ErrNotify('_GetNameDNS', 'Không định dạng được Chứng nhận của DNS'), '')
DllCall("Crypt32.dll", "dword", "CertFreeCertificateContext", "ptr", $pCert_Context)
Return StringReplace($aCall[8], 'DNS Name=', '')
EndFunc
Func _GetCookie($sHeader = '', $iSession = Default, $iTrimCookie = True, $Excluded_Values = '')
If IsKeyword($iSession) Or $iSession == '' Then $iSession = $g___LastSession
If $sHeader == '' Or $sHeader = Default Or($sHeader And StringLeft($sHeader, 5) <> 'HTTP/') Then
If $g___retData[$g___LastSession][0] Then
$sHeader = $g___retData[$g___LastSession][0]
ElseIf IsPtr($g___hRequest[$iSession]) Then
$sHeader = _WinHttpQueryHeaders2($g___hRequest[$iSession], 22)
If @error Or $sHeader == '' Then Return SetError(1, __HttpRequest_ErrNotify('_GetCookie', 'Không truy vấn được Response Headers'), '')
EndIf
EndIf
Local $__aRH = StringRegExp($sHeader, '(?im)^Set-Cookie:\h*?([^=]+)=(?!deleted;)(.*)$', 3)
If @error Or Not IsArray($__aRH) Then Return SetError(2, __HttpRequest_ErrNotify('_GetCookie', 'Không tìm thấy header Set-Cookie từ Response'), '')
Local $__sRH = '', $__uBound = UBound($__aRH)
For $i = $__uBound - 2 To 0 Step -2
If $__aRH[$i] == '' Or($Excluded_Values And StringInStr('|' & $Excluded_Values & '|', '|' & StringStripWS($__aRH[$i], 3) & '|')) Then ContinueLoop
$__sRH = $__aRH[$i] & '=' & $__aRH[$i + 1] & '; ' & $__sRH
For $k = 0 To $i Step 2
If $__aRH[$k] == $__aRH[$i] Then $__aRH[$k] = ''
Next
Next
If $iTrimCookie Then
Local $aOptionalFilter = 'priority\h*?=\h*?(?:high|low)|Expires\h*?=\h*?|Path\h*?=\h*?|Domain\h*?=\h*?|Max-age\h*?=\h*?|SameSite\h*?=\h*?|HttpOnly|Secure'
$__sRH = StringRegExpReplace(StringRegExpReplace($__sRH, '(?i);\h*?(' & $aOptionalFilter & ')([^;]*)', ';'), '(?:;\h?){2,}', ';')
EndIf
Return StringStripWS($__sRH, 3) & ' '
EndFunc
Func _GetIPAndGeoInfo($iIP = Default)
If $iIP = Default Then $iIP = $g___ServerIP
If $iIP = '' Then Return SetError(1, __HttpRequest_ErrNotify('_GetIPAndGeoInfo', 'Không tìm thấy IP - Phải request đến trang đích trước khi sử dụng hàm này hoặc nhập 1 IP bạn biết vào'), '')
Local $sHTML = _HttpRequest(2, 'https://gfx.robtex.com/ipinfo.js?ip=' & $iIP)
Local $aInfo = [$iIP, 'country', 'city', 'asname', 'net', 'netdescr', 'as'], $regSource
For $i = 1 To 6
$regSource = StringRegExp($sHTML, '(?i)\(m\h*?==?\h*?"' & $aInfo[$i] & '"\)\h*?a.innerHTML\h*?=\h*?"\,?\h?(.*?)"', 1)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_GetIPAndGeoInfo', 'Không tìm được thông tin từ IP'), $iIP)
$aInfo[$i] = $regSource[0]
Next
Return $aInfo
EndFunc
Func _GetFileInfo($sFilePath, $vDataTypeReturn = 1)
If Not FileExists($sFilePath) Then Return SetError(1, __HttpRequest_ErrNotify('_GetFileInfo', 'Đường dẫn tập tin không tồn tại'), '')
If $vDataTypeReturn = Default Or $vDataTypeReturn == '' Then $vDataTypeReturn = 1
Local $sFileName = StringRegExp($sFilePath, '[\\\/]([^\\\/]+\.\w+)$', 1)
If @error Then
$sFileName = StringRegExp($sFilePath, '^([^\\\/]+\.\w+)$', 1)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_GetFileInfo', 'Không tách được tên tập tin từ đường dẫn'), '')
$sFilePath = @ScriptDir & '\' & $sFileName[0]
EndIf
$sFileName = $sFileName[0]
Local $hFileOpen = FileOpen($sFilePath, 16)
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_GetFileInfo', 'Không thể mở tập tin'), '')
Local $sFileData = FileRead($hFileOpen)
FileClose($hFileOpen)
Local $sFileType = _HttpRequest_DetectMIME($sFileName)
Switch $vDataTypeReturn
Case 2
$sFileData = _B64Encode($sFileData, 0, True, True)
$sFileType &= ';base64'
Case 1
$sFileData = BinaryToString($sFileData)
EndSwitch
Local $aReturn[4] = [$sFileName, $sFileType, $sFileData, FileGetSize($sFilePath)]
Return $aReturn
EndFunc
Func _B64Encode($binaryData, $iLinebreak = 0, $safeB64 = False, $iRunByMachineCode = True, $iCompressData = False)
If $binaryData == '' Then Return SetError(1, __HttpRequest_ErrNotify('_B64Encode', '$binaryData rỗng'), '')
$iLinebreak = Number($iLinebreak)
If $iLinebreak = Default Then $iLinebreak = 0
If $safeB64 = Default Then $safeB64 = False
If $iRunByMachineCode = Default Then $iRunByMachineCode = False
If $iCompressData Then $binaryData = __LZNT_Compress($binaryData)
If Not $iRunByMachineCode Then
Local $lenData = StringLen($binaryData) - 2, $iOdd = Mod($lenData, 3), $spDec = '', $base64Data = ''
For $i = 3 To $lenData - $iOdd Step 3
$spDec = Dec(StringMid($binaryData, $i, 3))
$base64Data &= $g___aChr64[$spDec / 64] & $g___aChr64[Mod($spDec, 64)]
Next
If $iOdd Then
$spDec = BitShift(Dec(StringMid($binaryData, $i, 3)), -8 / $iOdd)
$base64Data &= $g___aChr64[$spDec / 64] &($iOdd = 2 ? $g___aChr64[Mod($spDec, 64)] & $g___sPadding & $g___sPadding : $g___sPadding)
EndIf
Else
Local $tStruct = DllStructCreate("byte[" & BinaryLen($binaryData) & "]")
DllStructSetData($tStruct, 1, $binaryData)
Local $tsInt = DllStructCreate("int")
Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", "ptr", DllStructGetPtr($tStruct), "int", DllStructGetSize($tStruct), "int", 1, "ptr", 0, "ptr", DllStructGetPtr($tsInt))
If @error Or Not $a_Call[0] Then Return SetError(2, __HttpRequest_ErrNotify('_B64Encode', 'Gọi chức năng CryptBinaryToString từ Crypt32.dll thất bại #1'), $binaryData)
Local $tsChr = DllStructCreate("char[" & DllStructGetData($tsInt, 1) & "]")
$a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", "ptr", DllStructGetPtr($tStruct), "int", DllStructGetSize($tStruct), "int", 1, "ptr", DllStructGetPtr($tsChr), "ptr", DllStructGetPtr($tsInt))
If @error Or Not $a_Call[0] Then Return SetError(3, __HttpRequest_ErrNotify('_B64Encode', 'Gọi chức năng CryptBinaryToString từ Crypt32.dll thất bại #2'), $binaryData)
Local $base64Data = StringStripWS(DllStructGetData($tsChr, 1), 8)
EndIf
If $iLinebreak Then
$base64Data = StringRegExpReplace($base64Data, '(.{' & $iLinebreak & '})', '${1}' & @LF)
If StringRight($base64Data, 1) == @LF Then $base64Data = StringTrimRight($base64Data, 1)
EndIf
If $safeB64 Then $base64Data = StringReplace(StringReplace($base64Data, '+', '-', 0, 1), '/', '_', 0, 1)
Return $base64Data
EndFunc
Func _B64Decode($base64Data, $iRunByMachineCode = True, $iUnCompressData = False)
If $base64Data == '' Then Return SetError(1, __HttpRequest_ErrNotify('_B64Decode', '$base64Data rỗng'), '')
If $iRunByMachineCode = Default Then $iRunByMachineCode = False
$base64Data = StringStripWS($base64Data, 8)
$base64Data = StringRegExpReplace($base64Data, '(\\r\\n|\%0D\%0A)', '')
If StringRight($base64Data, 3) = '%3D' Then $base64Data = _URIDecode($base64Data)
If Not $iRunByMachineCode Then
If Mod(StringLen($base64Data), 2) Then Return SetError(2, __HttpRequest_ErrNotify('_B64Decode', '$base64Data không phải là dữ liệu kiểu B64'), $base64Data)
Local $aData = StringSplit($base64Data, ''), $binaryData = '0x', $iOdd = UBound(StringRegExp($base64Data, $g___sPadding, 3))
For $i = 1 To $aData[0] - $iOdd * 2 Step 2
$binaryData &= Hex((StringInStr($g___sChr64, $aData[$i], 1, 1) - 1) * 64 + StringInStr($g___sChr64, $aData[$i + 1], 1, 1) - 1, 3)
Next
If $iOdd Then $binaryData &= Hex(BitShift((StringInStr($g___sChr64, $aData[$i], 1, 1) - 1) * 64 +($iOdd - 1) *(StringInStr($g___sChr64, $aData[$i + 1], 1, 1) - 1), 8 / $iOdd), $iOdd)
Else
Local $tStruct = DllStructCreate("int")
Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $base64Data, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($tStruct, 1), "ptr", 0, "ptr", 0)
If @error Or Not $a_Call[0] Then Return SetError(3, __HttpRequest_ErrNotify('_B64Decode', 'Gọi chức năng CryptStringToBinary từ Crypt32.dll thất bại #1'), $base64Data)
Local $tsByte = DllStructCreate("byte[" & DllStructGetData($tStruct, 1) & "]")
$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $base64Data, "int", 0, "int", 1, "ptr", DllStructGetPtr($tsByte), "ptr", DllStructGetPtr($tStruct, 1), "ptr", 0, "ptr", 0)
If @error Or Not $a_Call[0] Then Return SetError(4, __HttpRequest_ErrNotify('_B64Decode', 'Gọi chức năng CryptStringToBinary từ Crypt32.dll thất bại #2'), $base64Data)
Local $binaryData = DllStructGetData($tsByte, 1)
EndIf
If $iUnCompressData Then $binaryData = __LZNT_Decompress($binaryData)
Return $binaryData
EndFunc
Func __LZNT_Decompress($bBinary)
$bBinary = Binary($bBinary)
Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
DllStructSetData($tInput, 1, $bBinary)
Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]")
Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", "ushort", 2, "ptr", DllStructGetPtr($tBuffer), "dword", DllStructGetSize($tBuffer), "ptr", DllStructGetPtr($tInput), "dword", DllStructGetSize($tInput), "dword*", 0)
If @error Then Return SetError(1, __HttpRequest_ErrNotify('__LZNT_Decompress', ' Decompress Buffer thất bại'), '')
Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))
Return SetError(0, 0, DllStructGetData($tOutput, 1))
EndFunc
Func __LZNT_Compress($bBinary)
$bBinary = Binary($bBinary)
Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
DllStructSetData($tInput, 1, $bBinary)
Local $a_Call = DllCall("ntdll.dll", "int", "RtlGetCompressionWorkSpaceSize", "ushort", 2, "dword*", 0, "dword*", 0)
If @error Then Return SetError(1, __HttpRequest_ErrNotify('__LZNT_Compress', 'Tạo WorkSpace thất bại'), "")
Local $tWorkSpace = DllStructCreate("byte[" & $a_Call[2] & "]")
Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]")
Local $a_Call = DllCall("ntdll.dll", "int", "RtlCompressBuffer", "ushort", 2, "ptr", DllStructGetPtr($tInput), "dword", DllStructGetSize($tInput), "ptr", DllStructGetPtr($tBuffer), "dword", DllStructGetSize($tBuffer), "dword", 4096, "dword*", 0, "ptr", DllStructGetPtr($tWorkSpace))
If @error Then Return SetError(2, __HttpRequest_ErrNotify('__LZNT_Compress', 'Compress Buffer thất bại'), '')
Local $tOutput = DllStructCreate("byte[" & $a_Call[7] & "]", DllStructGetPtr($tBuffer))
Return SetError(0, 0, DllStructGetData($tOutput, 1))
EndFunc
Func __SciTE_ConsoleWrite_FixFont()
If @Compiled Or($CmdLine[0] > 0 And $CmdLine[1] = '--hh-multi-process') Or StringInStr(@AutoItExe, 'AutoItX', 0, 1) Then Return
Local $SciTE_Link_A = StringRegExpReplace(@AutoItExe, '(?i)\w+\.exe$', '') & 'SciTE\'
Local $SciTE_Link_B = StringRegExpReplace(__WinAPI_GetProcessFileName(ProcessExists('SciTE.exe')), '(?i)\w+\.exe$', '')
If $SciTE_Link_B = '' Then $SciTE_Link_B = $SciTE_Link_A
If $SciTE_Link_A = $SciTE_Link_B Then
Local $SciTEProp_Link = [@LocalAppDataDir & '\AutoIt v3\SciTE\SciTEUser.properties', $SciTE_Link_A & 'SciTEUser.properties', $SciTE_Link_A & 'SciTEGlobal.properties']
Else
Local $SciTEProp_Link = [@LocalAppDataDir & '\AutoIt v3\SciTE\SciTEUser.properties', $SciTE_Link_A & 'SciTEUser.properties', $SciTE_Link_A & 'SciTEGlobal.properties', $SciTE_Link_B & 'SciTEUser.properties', $SciTE_Link_B & 'SciTEGlobal.properties']
EndIf
For $i = 0 To UBound($SciTEProp_Link) - 1
Local $SciTEUserProp_Change = 0
If FileExists($SciTEProp_Link[$i]) Then
Local $SciTEUserProp_Data = FileRead($SciTEProp_Link[$i])
If Not StringRegExp($SciTEUserProp_Data, '(?im)^\h*?\Qoutput.code.page\E\h*?=\h*?65001') Or StringRegExp($SciTEUserProp_Data, '(?im)^\h*?\Qoutput.code.page\E\h*?=\h*?0') Then
$SciTEUserProp_Data = StringRegExpReplace($SciTEUserProp_Data, '(?im)^\h*?\Qoutput.code.page\E.*$\R', '')
$SciTEUserProp_Data &= @CRLF & 'output.code.page=65001'
$SciTEUserProp_Change = 1
EndIf
If Not StringRegExp($SciTEUserProp_Data, '(?im)^\h*?\Qcode.page\E\h*?=\h*?65001') Or StringRegExp($SciTEUserProp_Data, '(?im)^\h*?\Qoutput.code.page\E\h*?=\h*?0') Then
$SciTEUserProp_Data = StringRegExpReplace($SciTEUserProp_Data, '(?im)^\h*?\Qcode.page\E.*$\R', '')
$SciTEUserProp_Data &= @CRLF & 'code.page=65001'
$SciTEUserProp_Change = 1
EndIf
Else
$SciTEUserProp_Change = 1
$SciTEUserProp_Data = 'output.code.page=65001' & @CRLF & 'code.page=65001' & @CRLF
EndIf
If $SciTEUserProp_Change = 1 Then
Local $hOpen = FileOpen($SciTEProp_Link[$i], 2 + 8)
FileWrite($hOpen, $SciTEUserProp_Data)
FileClose($hOpen)
EndIf
Next
If $g___ConsoleForceUTF8 = True Then
Local $SciTEProp_Link = @ScriptDir & '\SciTE.properties'
If Not FileExists($SciTEProp_Link) Then
Local $hOpen = FileOpen($SciTEProp_Link, 2 + 8)
FileWrite($hOpen, 'output.code.page=65001' & @CRLF & 'code.page=65001' & @CRLF)
FileClose($hOpen)
EndIf
EndIf
EndFunc
Func __WinAPI_GetProcessFileName($iPID)
If $iPID = 0 Then Return SetError(1, __HttpRequest_ErrNotify('__WinAPI_GetProcessFileName', 'PID không tồn tại (PID = 0)'), '')
Local $__tOSVI__ = DllStructCreate('struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct')
DllStructSetData($__tOSVI__, 1, DllStructGetSize($__tOSVI__))
Local $aRet = DllCall($dll_Kernel32, 'bool', 'GetVersionExW', 'struct*', $__tOSVI__)
If @error Or Not $aRet[0] Then Return SetError(2, 0, '')
Local $__WINVER__ = BitOR(BitShift(DllStructGetData($__tOSVI__, 2), -8), DllStructGetData($__tOSVI__, 3))
Local $hProcess = DllCall($dll_Kernel32, 'handle', 'OpenProcess', 'dword', $__WINVER__ < 0x0600 ? 0x00000410 : 0x00001010, 'bool', 0, 'dword', $iPID)
If @error Or Not $hProcess[0] Then Return SetError(3, 0, '')
Local $aFileNameExW = DllCall('psapi.dll', 'dword', 'GetModuleFileNameExW', 'handle', $hProcess[0], 'handle', 0, 'wstr', '', 'int', 4096)
If @error Or Not $aFileNameExW[0] Then Return SetError(4, 0, '')
DllCall($dll_Kernel32, "bool", "CloseHandle", "handle", $hProcess[0])
Return $aFileNameExW[3]
EndFunc
Func __RemoveVietMarktical($sText)
If $g___aVietPattern = '' Then Global $g___aVietPattern = [['áàảãạăắằẳẵặâấầẩẫậ', 'a'], ['đ', 'd'], ['éèẻẽẹêếềểễệ', 'e'], ['íìỉĩị', 'i'], ['óòỏõọôốồổỗộơớờởỡợ', 'o'], ['úùủũụưứừửữự', 'u'], ['ýỳỷỹỵ', 'y']]
For $i = 0 To 6
$sText = StringRegExpReplace($sText, '[' & $g___aVietPattern[$i][0] & ']', $g___aVietPattern[$i][1])
$sText = StringRegExpReplace($sText, '[' & StringUpper($g___aVietPattern[$i][0]) & ']', StringUpper($g___aVietPattern[$i][1]))
Next
Return $sText
EndFunc
Func _WinHttpGetResponseErrorCode2($iErrorCode)
$iErrorCode = StringRegExp('OUT_OF_HANDLES12001,TIMEOUT12002,UNKNOWN12003,INTERNAL_ERROR12004,INVALID_URL12005,UNRECOGNIZED_SCHEME12006,NAME_NOT_RESOLVED12007,INVALID_OPTION12009,OPTION_NOT_SETTABLE12011,SHUTDOWN12012,LOGIN_FAILURE12015,OPERATION_CANCELLED12017,INCORRECT_HANDLE_TYPE12018,INCORRECT_HANDLE_STATE12019,CANNOT_CONNECT12029,CONNECTION_ERROR12030,RESEND_REQUEST12032,SECURE_CERT_DATE_INVALID12037,SECURE_CERT_CN_INVALID12038,CLIENT_AUTH_CERT_NEEDED12044,SECURE_INVALID_CA12045,SECURE_CERT_REV_FAILED12057,CANNOT_CALL_BEFORE_OPEN12100,CANNOT_CALL_BEFORE_SEND12101,CANNOT_CALL_AFTER_SEND12102,CANNOT_CALL_AFTER_OPEN12103,HEADER_NOT_FOUND12150,INVALID_SERVER_RESPONSE12152,INVALID_HEADER12153,INVALID_QUERY_REQUEST12154,HEADER_ALREADY_EXISTS12155,REDIRECT_FAILED12156,SECURE_CHANNEL_ERROR12157,BAD_AUTO_PROXY_SCRIPT12166,UNABLE_TO_DOWNLOAD_SCRIPT12167,SECURE_INVALID_CERT12169,SECURE_CERT_REVOKED12170,NOT_INITIALIZED12172,SECURE_FAILURE12175,AUTO_PROXY_SERVICE_ERROR12178,SECURE_CERT_WRONG_USAGE12179,AUTODETECTION_FAILED12180,HEADER_COUNT_EXCEEDED12181,HEADER_SIZE_OVERFLOW12182,CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW12183,RESPONSE_DRAIN_OVERFLOW12184,CLIENT_CERT_NO_PRIVATE_KEY12185,CLIENT_CERT_NO_ACCESS_PRIVATE_KEY12186', '(?:^|\,)([A-Z_]+)' & $iErrorCode, 1)
If @error Then Return 'ERROR_WINHTTP_UNKNOWN'
Return 'ERROR_WINHTTP_' & $iErrorCode[0]
EndFunc
Func _WinHttpQueryHeaders2($hRequest, $iInfoLevel = 22, $iIndex = 0, $vBuffer = 8192)
If $iInfoLevel = 19 Then $vBuffer = 8
Switch $iInfoLevel
Case 80
Local $vCert = _GetCertificateInfo()
Return SetError(@error, 0, $vCert)
Case 81
Local $vDS = _GetNameDNS()
Return SetError(@error, 0, $vDS)
Case Else
Local $aCall = DllCall($dll_WinHttp, "bool", 'WinHttpQueryHeaders', "handle", $hRequest, "dword", $iInfoLevel, 'wstr', '', 'wstr', "", "dword*", $vBuffer, "dword*", $iIndex)
If @error Or Not $aCall[0] Then
If $aCall[5] And $vBuffer < $aCall[5] Then
$aCall = DllCall($dll_WinHttp, "bool", 'WinHttpQueryHeaders', "handle", $hRequest, "dword", $iInfoLevel, 'wstr', '', 'wstr', "", "dword*", $aCall[5], "dword*", $iIndex)
If @error Or Not $aCall[0] Then Return SetError(2, 0, 0)
Return $aCall[4]
Else
Return SetError(1, 0, 0)
EndIf
EndIf
Return $aCall[4]
EndSwitch
EndFunc
Func _WinHttpOpen2($iAsync = 0, $iProxy = '', $iProxyBypass = '')
Local $aCall = DllCall($dll_WinHttp, "handle", "WinHttpOpen", 'wstr', '', "dword", $iProxy ? 3 : 1, 'wstr', $iProxy, 'wstr', $iProxyBypass, "dword", $iAsync * 0x10000000)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
If $iAsync Then _WinHttpSetOption2($aCall[0], 45, 0x10000000)
Return $aCall[0]
EndFunc
Func _WinHttpSendRequest2($hRequest, $sHeaders = '', $sData2Send = '', $iUpload = 0, $CallBackFunc_Progress = '')
Local $pData2Send = 0, $lData2Send = 0
If $sData2Send Then
$lData2Send = BinaryLen($sData2Send)
If $iUpload = 0 Then
Local $tData2Send = DllStructCreate('byte[' & $lData2Send & ']')
DllStructSetData($tData2Send, 1, $sData2Send)
$pData2Send = DllStructGetPtr($tData2Send)
EndIf
EndIf
Local $aCall = DllCall($dll_WinHttp, "bool", 'WinHttpSendRequest', "handle", $hRequest, 'wstr', $sHeaders, "dword", 0, "ptr", $pData2Send, "dword", $lData2Send, "dword", $lData2Send, "dword_ptr", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
If $iUpload Then
_WinHttpWriteData_Ex($hRequest, $sData2Send, $lData2Send, $CallBackFunc_Progress)
If @error Then Return SetError(@error, 0, 0)
EndIf
Return 1
EndFunc
Func _WinHttpWriteData_Ex($hRequest, $sData2Send, $lData2Send, $CallBackFunc_Progress = '', $iBytesPerLoop = $g___BytesPerLoop)
Local $tBuffer, $iDataMid, $iDataMidLen, $iCheckCallbackFunc = 0, $vNowSizeBytes = 0, $vTotalSizeBytes = -1, $aCall, $isBinData2Send = IsBinary($sData2Send)
If $CallBackFunc_Progress <> '' Then
$iCheckCallbackFunc = 1
$vTotalSizeBytes = $lData2Send
If $vTotalSizeBytes > 2147483647 Then Return SetError(101, __HttpRequest_ErrNotify('_WinHttpWriteData_Ex', 'Tập tin quá lớn', 101), 0)
EndIf
Do
$iDataMid = $g___aReadWriteData[1][$isBinData2Send]($sData2Send, $vNowSizeBytes + 1, $iBytesPerLoop)
$iDataMidLen = $g___aReadWriteData[2][$isBinData2Send]($iDataMid)
$tBuffer = DllStructCreate($g___aReadWriteData[0][$isBinData2Send] & "[" &($iDataMidLen + 1) & "]")
DllStructSetData($tBuffer, 1, $iDataMid)
$aCall = DllCall($dll_WinHttp, "bool", 'WinHttpWriteData', "handle", $hRequest, "struct*", $tBuffer, "dword", $iDataMidLen, "dword*", 0)
If @error Or Not $aCall[0] Then ExitLoop
$vNowSizeBytes += $iDataMidLen
$tBuffer = ''
If $g___swCancelReadWrite Then
$g___swCancelReadWrite = False
Return SetError(999, __HttpRequest_ErrNotify('_WinHttpWriteData_Ex', 'Đã huỷ request', 999), 0)
ElseIf $iCheckCallbackFunc Then
$CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
EndIf
Until $aCall[4] < $iBytesPerLoop
Return 1
EndFunc
Func _WinHttpReadData_Ex($hRequest, $CallBackFunc_Progress = '', $iFileSavePath = '', $iEncodingOfFileSave = 0, $iBytesPerLoop = $g___BytesPerLoop)
Local $vBinaryData = Binary(''), $aCall, $iCheckCallbackFunc = 0, $vNowSizeBytes = 1, $vTotalSizeBytes = -1
Local $tBuffer = DllStructCreate("byte[" & $iBytesPerLoop & "]")
If $CallBackFunc_Progress <> '' Then
$iCheckCallbackFunc = 1
$vTotalSizeBytes = Number(_WinHttpQueryHeaders2($hRequest, 5))
If $vTotalSizeBytes > 2147483647 Then Return SetError(102, __HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Tập tin quá lớn', -1), 0)
EndIf
If $iFileSavePath Then
If FileExists($iFileSavePath) Then
Switch $g___iReadMode
Case 0
__HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã ghi đè lên tập tin cũ tồn tại: "' & $iFileSavePath & '"', '', 'Warning')
Case 1
$iFileSavePath = StringRegExpReplace($iFileSavePath, '^(.+?)(\.\w+)$', '${1}' & TimerInit() & '${2}')
__HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã đổi tên $iFileSavePath vì tồn tại tập tin cùng tên trong thư mục muốn ghi', '', 'Warning')
Case 2
Switch MsgBox(4096 + 48 + 2, 'Chú ý', 'Đã tồn tại tập tin cùng tên tại thư mục muốn ghi.' & @CRLF & '- Nhấn Abort để huỷ tải xuống' & @CRLF & '- Nhấn Retry để đổi tên đường dẫn lưu tập tin trước khi tải' & @CRLF & '- Nhấn Ignore để tiếp tục tải và ghi đè')
Case 3
Return SetError(995, __HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã huỷ request #3', -1), 0)
Case 4
$iFileSavePath = StringRegExpReplace($iFileSavePath, '^(.+?)(\.\w+)$', '${1}' & TimerInit() & '${2}')
__HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã đổi tên $iFileSavePath vì tồn tại tập tin cùng tên trong thư mục muốn ghi', '', 'Warning')
Case 5
__HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã ghi đè lên tập tin cũ tồn tại: "' & $iFileSavePath & '"', '', 'Warning')
EndSwitch
EndSwitch
EndIf
FileOpen($iFileSavePath, 2 + 8)
If $iEncodingOfFileSave = 0 Then $iEncodingOfFileSave = 16
Local $hFileOpen = FileOpen($iFileSavePath, 1 + $iEncodingOfFileSave)
While 1
$aCall = DllCall($dll_WinHttp, "bool", 'WinHttpReadData', "handle", $hRequest, "struct*", $tBuffer, "dword", $iBytesPerLoop, 'dword*', 0)
If @error Or Not $aCall[0] Or Not $aCall[4] Then ExitLoop
$vNowSizeBytes += $aCall[4]
If $aCall[4] < $iBytesPerLoop Then
FileWrite($hFileOpen, BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]))
If $iCheckCallbackFunc Then $CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
ExitLoop
Else
FileWrite($hFileOpen, DllStructGetData($tBuffer, 1))
EndIf
If $g___swCancelReadWrite Then
$g___swCancelReadWrite = False
If $iFileSavePath Then FileClose($hFileOpen)
$tBuffer = ''
Return SetError(998, __HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã huỷ request #1', -1), 0)
ElseIf $iCheckCallbackFunc Then
$CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
EndIf
WEnd
$tBuffer = ''
FileClose($hFileOpen)
Else
While 1
$aCall = DllCall($dll_WinHttp, "bool", 'WinHttpReadData', "handle", $hRequest, "struct*", $tBuffer, "dword", $iBytesPerLoop, 'dword*', 0)
If @error Or Not $aCall[0] Or Not $aCall[4] Then ExitLoop
$vNowSizeBytes += $aCall[4]
If $aCall[4] < $iBytesPerLoop Then
$vBinaryData &= BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4])
If $iCheckCallbackFunc Then $CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
ExitLoop
Else
$vBinaryData &= DllStructGetData($tBuffer, 1)
EndIf
If $g___swCancelReadWrite Then
$g___swCancelReadWrite = False
If $iFileSavePath Then FileClose($hFileOpen)
$tBuffer = ''
Return SetError(998, __HttpRequest_ErrNotify('_WinHttpReadData_Ex', 'Đã huỷ request #2', -1), 0)
ElseIf $iCheckCallbackFunc Then
$CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
EndIf
WEnd
$tBuffer = ''
Return $vBinaryData
EndIf
EndFunc
Func _WinHttpConnect2($hSession, $sServerName, $iServerPort)
Local $aCall = DllCall($dll_WinHttp, "handle", 'WinHttpConnect', "handle", $hSession, 'wstr', $sServerName, "dword", $iServerPort, "dword", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _WinHttpSetTimeouts2($hInternet, $iConnectTimeout = 30000, $iSendTimeout = 30000, $iReceiveTimeout = 30000)
DllCall($dll_WinHttp, "bool", 'WinHttpSetTimeouts', "handle", $hInternet, "int", 0, "int", $iConnectTimeout, "int", $iSendTimeout, "int", $iReceiveTimeout)
EndFunc
Func _WinHttpCloseHandle2($hInternet)
DllCall($dll_WinHttp, "bool", 'WinHttpCloseHandle', "handle", $hInternet)
EndFunc
Func _WinHttpOpenRequest2($hConnect, $sVerb, $sObjectName = '', $iFlags = 0x40, $sVersion = 'HTTP/1.1')
Local $aCall = DllCall($dll_WinHttp, "handle", 'WinHttpOpenRequest', "handle", $hConnect, 'wstr', StringUpper($sVerb), 'wstr', $sObjectName, 'wstr', StringUpper($sVersion), 'wstr', '', "ptr", 0, "dword", $iFlags)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return $aCall[0]
EndFunc
Func _WinHttpReceiveResponse2($hRequest)
Local $aCall = DllCall($dll_WinHttp, 'bool', 'WinHttpReceiveResponse', 'handle', $hRequest, 'ptr', 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _WinHttpSetOptionEx2($hInternet, $iOption, $vBuffer = 0, $iNoParam = False)
Local $tBuffer, $iBuffer
If $iNoParam Then
Local $aCall = DllCall($dll_WinHttp, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, "ptr", 0, "dword", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, False)
Return True
ElseIf IsBinary($vBuffer) Or IsNumber($vBuffer) Then
$iBuffer = BinaryLen($vBuffer)
$tBuffer = DllStructCreate("byte[" & $iBuffer & "]")
DllStructSetData($tBuffer, 1, $vBuffer)
ElseIf IsDllStruct($vBuffer) Then
$tBuffer = $vBuffer
$iBuffer = DllStructGetSize($tBuffer)
Else
$tBuffer = DllStructCreate("wchar[" &(StringLen($vBuffer) + 1) & "]")
$iBuffer = DllStructGetSize($tBuffer)
DllStructSetData($tBuffer, 1, $vBuffer)
EndIf
Local $avResult = DllCall($dll_WinHttp, "bool", 'WinHttpSetOption', "handle", $hInternet, "dword", $iOption, "ptr", DllStructGetPtr($tBuffer), "dword", $iBuffer)
If @error Or Not $avResult[0] Then Return SetError(2, 0, False)
Return True
EndFunc
Func _WinHttpSetOption2($hInternet, $iOption, $vSetting, $iSize = -1)
Local $sType
If IsBinary($vSetting) Then
$iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
DllStructSetData($iSize, 1, $vSetting)
$vSetting = $iSize
$iSize = DllStructGetSize($vSetting)
EndIf
Switch $iOption
Case 2 To 7, 12, 13, 31, 36, 58, 63, 68, 73, 74, 77, 79, 80, 83 To 85, 88 To 92, 96, 100, 101, 110, 118
$sType = "dword*"
$iSize = 4
Case 1, 86
$sType = "ptr*"
$iSize = 4
If @AutoItX64 Then $iSize = 8
If Not IsPtr($vSetting) Then Return SetError(1, 0, 0)
Case 45
$sType = "dword_ptr*"
$iSize = 4
If @AutoItX64 Then $iSize = 8
Case 41, 0x1000 To 0x1003
$sType = "wstr"
If(IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(2, 0, 0)
If $iSize < 1 Then $iSize = StringLen($vSetting)
Case 38, 47, 59, 97, 98
$sType = "ptr"
If Not(IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
Case Else
Return SetError(4, 0, 0)
EndSwitch
If $iSize < 1 Then
If IsDllStruct($vSetting) Then
$iSize = DllStructGetSize($vSetting)
Else
Return SetError(5, 0, 0)
EndIf
EndIf
Local $aCall = DllCall($dll_WinHttp, "bool", 'WinHttpSetOption', "handle", $hInternet, "dword", $iOption, $sType, IsDllStruct($vSetting) ? DllStructGetPtr($vSetting) : $vSetting, "dword", $iSize)
If @error Or Not $aCall[0] Then Return SetError(6, 0, 0)
Return 1
EndFunc
Func _WinHttpQueryOptionEx2($hInternet, $iOption, $iBufferSize = 2048)
Local $tBufferLength = DllStructCreate("dword")
DllStructSetData($tBufferLength, 1, $iBufferSize)
Local $tBuffer = DllStructCreate("byte[" & $iBufferSize & "]")
Local $avResult = DllCall($dll_WinHttp, "bool", 'WinHttpQueryOption', "handle", $hInternet, "dword", $iOption, "ptr", DllStructGetPtr($tBuffer), "ptr", DllStructGetPtr($tBufferLength))
If @error Or Not $avResult[0] Then Return SetError(1, 0, "")
Return $tBuffer
EndFunc
Func _WinHttpSetProxy2($hInternet, $sProxy = "", $sProxyBypass = "")
Local $tProxy = DllStructCreate("wchar sProxy[" & StringLen($sProxy) + 1 & "];wchar sProxyBypass[" & StringLen($sProxyBypass) + 1 & "]")
$tProxy.sProxy = $sProxy
$tProxy.sProxyBypass = $sProxyBypass
Local $tProxyInfo = DllStructCreate("dword AccessType;ptr Proxy;ptr ProxyBypass")
$tProxyInfo.AccessType = 3
$tProxyInfo.Proxy = DllStructGetPtr($tProxy, 1)
$tProxyInfo.ProxyBypass = DllStructGetPtr($tProxy, 2)
_WinHttpSetOptionEx2($hInternet, 38, $tProxyInfo)
If @error Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _WinHttpSetStatusCallback2($hInternet, $pCallback, $nStatusRev)
DllCall($dll_WinHttp, "ptr", 'WinHttpSetStatusCallback', "handle", $hInternet, "ptr", $pCallback, "dword", $nStatusRev, "ptr", 0)
EndFunc
Func _WinHttpSetCredentials2($hRequest, $sUserName, $sPassword, $iAuthTargets, $iAuthScheme)
If $iAuthScheme = 0x4 Then
_WinHttpSetOption2($hRequest, 83, 0x10000000)
If $iAuthTargets = 0x0 Then
_WinHttpSetOption2($hRequest, 0x1000, $sUserName)
_WinHttpSetOption2($hRequest, 0x1001, $sPassword)
Else
_WinHttpSetOption2($hRequest, 0x1002, $sUserName)
_WinHttpSetOption2($hRequest, 0x1003, $sPassword)
EndIf
EndIf
Local $aCall = DllCall($dll_WinHttp, "bool", 'WinHttpSetCredentials', "handle", $hRequest, "dword", $iAuthTargets, "dword", $iAuthScheme, 'wstr', $sUserName, 'wstr', $sPassword, "ptr", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _WinHttpQueryAuthSchemes2($hRequest)
Local $aCall = DllCall($dll_WinHttp, "bool", "WinHttpQueryAuthSchemes", "handle", $hRequest, "dword*", 0, "dword*", 0, "dword*", 0)
If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
Local $aRet = [$aCall[3], $aCall[4], $aCall[2]]
Return $aRet
EndFunc
Func _JS_Execute($LibraryJS, $sCodeJS, $Name_Var_Return_Val, $ModeIE = False, $PathTempLibJS = Default)
If FileExists($PathTempLibJS) Then
If StringRight($PathTempLibJS, 1) <> '\' Then $PathTempLibJS &= '\'
Else
$PathTempLibJS = @TempDir & '\'
EndIf
Local $TempPath, $hOpen, $iError = 0, $sLibraryJS = ''
If FileExists($sCodeJS) Then $sCodeJS = FileRead($sCodeJS)
If StringInStr($Name_Var_Return_Val, '.', 1, 1) Then
Local $Name_Var_Return_Val_tmp = $Name_Var_Return_Val
$Name_Var_Return_Val = StringReplace($Name_Var_Return_Val, '.', '', 1, 1)
$sCodeJS = StringReplace($sCodeJS, $Name_Var_Return_Val_tmp, $Name_Var_Return_Val, 1, 1)
EndIf
$sCodeJS = StringRegExpReplace($sCodeJS, '(?i)(location.href=)(".*?"|''.*?'')', '')
If $LibraryJS Or IsArray($LibraryJS) Then
If Not IsArray($LibraryJS) Then $LibraryJS = StringSplit($LibraryJS, '|', 2)
For $i = 0 To UBound($LibraryJS) - 1
If StringRegExp($LibraryJS[$i], '(?i)^https?://') Then
$TempPath = $PathTempLibJS & StringRight(StringRegExpReplace($LibraryJS[$i], '(?i)(\.js|\W+)', '-'), 200) & '.js'
If FileExists($TempPath) And FileGetSize($TempPath) > 2 Then
$LibraryJS[$i] = FileRead($TempPath)
Else
$LibraryJS[$i] = _HttpRequest(2, $LibraryJS[$i])
If @error Or Not $LibraryJS[$i] Then $iError = 301
$hOpen = FileOpen($TempPath, 2 + 32 + 8)
FileWrite($hOpen, $LibraryJS[$i])
FileClose($hOpen)
EndIf
Else
$LibraryJS[$i] = FileRead($LibraryJS[$i])
EndIf
$sLibraryJS &= $LibraryJS[$i] & ';' & @CRLF
Next
EndIf
If Not $g___JsLibJSON Then
$g___JsLibJSON &= 'if(typeof JSON!=="object"){JSON={}}(function(){"use strict";var rx_one=/^[\],:{}\s]*$/;var rx_two=/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g;var rx_three=/'
$g___JsLibJSON &= '"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g;var rx_four=/(?:^|:|,)(?:\s*\[)+/g;var rx_escapable=/[\\"\u0000-\u001f\u007f-\u009f\'
$g___JsLibJSON &= 'u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;var rx_dangerous=/[\u0000\u00ad\u0600-\u0604\u070f\u'
$g___JsLibJSON &= '17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;function f(n){return(n<10)?"0"+n:n}function this_value(){return this.valueOf()'
$g___JsLibJSON &= '}if(typeof Date.prototype.toJSON!=="function"){Date.prototype.toJSON=function(){return isFinite(this.valueOf())?(this.getUTCFullYear()+"-"+f(this.getU'
$g___JsLibJSON &= 'TCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z"):null};Boolean.prototype.t'
$g___JsLibJSON &= 'oJSON=this_value;Number.prototype.toJSON=this_value;String.prototype.toJSON=this_value}var gap;var indent;var meta;var rep;function quote(string){rx_e'
$g___JsLibJSON &= 'scapable.lastIndex=0;return rx_escapable.test(string)?"\""+string.replace(rx_escapable,function(a){var c=meta[a];return typeof c==="string"?c:"\\u"+("'
$g___JsLibJSON &= '0000"+a.charCodeAt(0).toString(16)).slice(-4)})+"\"":"\""+string+"\""}function str(key,holder){var i;var k;var v;var length;var mind=gap;var partial;v'
$g___JsLibJSON &= 'ar value=holder[key];if(value&&typeof value==="object"&&typeof value.toJSON==="function"){value=value.toJSON(key)}if(typeof rep==="function"){value=re'
$g___JsLibJSON &= 'p.call(holder,key,value)}switch(typeof value){case"string":return quote(value);case"number":return(isFinite(value))?String(value):"null";case"boolean"'
$g___JsLibJSON &= ':case"null":return String(value);case"object":if(!value){return"null"}gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==="[object Arra'
$g___JsLibJSON &= 'y]"){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||"null"}v=partial.length===0?"[]":gap?("[\n"+gap+partial.join(",\n"+gap)+"\n"+'
$g___JsLibJSON &= 'mind+"]"):"["+partial.join(",")+"]";gap=mind;return v}if(rep&&typeof rep==="object"){length=rep.length;for(i=0;i<length;i+=1){if(typeof rep[i]==="stri'
$g___JsLibJSON &= 'ng"){k=rep[i];v=str(k,value);if(v){partial.push(quote(k)+((gap)?": ":":")+v)}}}}else{for(k in value){if(Object.prototype.hasOwnProperty.call(value,k))'
$g___JsLibJSON &= '{v=str(k,value);if(v){partial.push(quote(k)+((gap)?": ":":")+v)}}}}v=partial.length===0?"{}":gap?"{\n"+gap+partial.join(",\n"+gap)+"\n"+mind+"}":"{"+p'
$g___JsLibJSON &= 'artial.join(",")+"}";gap=mind;return v}}if(typeof JSON.stringify!=="function"){meta={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r","\"":"\\\"'
$g___JsLibJSON &= '","\\":"\\\\"};JSON.stringify=function(value,replacer,space){var i;gap="";indent="";if(typeof space==="number"){for(i=0;i<space;i+=1){indent+=" "}}els'
$g___JsLibJSON &= 'e if(typeof space==="string"){indent=space}rep=replacer;if(replacer&&typeof replacer!=="function"&&(typeof replacer!=="object"||typeof replacer.length'
$g___JsLibJSON &= '!=="number")){throw new Error("JSON.stringify");}return str("",{"":value})}}if(typeof JSON.parse!=="function"){JSON.parse=function(text,reviver){var j'
$g___JsLibJSON &= ';function walk(holder,key){var k;var v;var value=holder[key];if(value&&typeof value==="object"){for(k in value){if(Object.prototype.hasOwnProperty.cal'
$g___JsLibJSON &= 'l(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v}else{delete value[k]}}}}return reviver.call(holder,key,value)}text=String(text);rx_dangerous.'
$g___JsLibJSON &= 'lastIndex=0;if(rx_dangerous.test(text)){text=text.replace(rx_dangerous,function(a){return("\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4))})}if('
$g___JsLibJSON &= 'rx_one.test(text.replace(rx_two,"@").replace(rx_three,"]").replace(rx_four,""))){j=eval("("+text+")");return(typeof reviver==="function")?walk({"":j},'
$g___JsLibJSON &= '""):j}throw new SyntaxError("JSON.parse");}}}())'
EndIf
$sCodeJS = @CRLF & $sLibraryJS & ';' & @CRLF & $g___JsLibJSON & ';' & @CRLF & StringReplace($sCodeJS, 'document.write();', '', 1, 1) & '; document.write(' & $Name_Var_Return_Val & ');'
If $ModeIE Then
Local $oIE = ObjCreate("InternetExplorer.Application")
With $oIE
.navigate('about:blank')
.document.write('<script>' & $sCodeJS & '</script>')
.document.close()
While .busy()
Sleep(10)
WEnd
$sCodeJS = .document.body.innerText
If StringRight($sCodeJS, 1) == ' ' Then $sCodeJS = StringTrimRight($sCodeJS, 1)
.quit()
ProcessClose('ielowutil.exe')
EndWith
Else
$sCodeJS = _HTML_Execute($sCodeJS)
If @error Then $iError = 302
EndIf
Return SetError($iError, '', $sCodeJS)
EndFunc
Func __HTML_Entities_Decode($sHTML, $iModeIE = False)
If $iModeIE = Default Then $iModeIE = False
If $iModeIE Then
$sHTML = _HTML_Execute(StringReplace($sHTML, '&#xD;', '<hr>'))
Else
If Not IsObj($g___oDicEntity) Then
$g___oDicEntity = __HTML_Entities_Init()
If @error Then Return SetError(2, __HttpRequest_ErrNotify('__HTML_Entities_Decode', 'Khởi tạo __HTML_Entities_Init thất bại'), $sHTML)
EndIf
Local $aText = StringRegExp($sHTML, '\&\#(\d+)\;', 3)
If Not @error Then
For $i = 0 To UBound($aText) - 1
$sHTML = StringReplace($sHTML, '&#' & $aText[$i] & ';', ChrW($aText[$i]), 0, 1)
Next
EndIf
$aText = StringRegExp($sHTML, '\&([a-zA-Z]{2,10})\;', 3)
If Not @error Then
For $i = 0 To UBound($aText) - 1
$sHTML = StringReplace($sHTML, '&' & $aText[$i] & ';', $g___oDicEntity.item($aText[$i]), 0, 1)
Next
EndIf
EndIf
Return $sHTML
EndFunc
Func __HTML_Entities_Init()
If $g___aChrEnt == '' Then
Local $aisEntities[246][2] = [[34, 'quot'], [38, 'amp'], [39, 'apos'], [60, 'lt'], [62, 'gt'], [160, 'nbsp'], [161, 'iexcl'], [162, 'cent'], [163, 'pound'], [164, 'curren'], [165, 'yen'], [166, 'brvbar'], [167, 'sect'], [168, 'uml'], [169, 'copy'], [170, 'ordf'], [171, 'laquo'], [172, 'not'], [173, 'shy'], [174, 'reg'], [175, 'macr'], [176, 'deg'], [177, 'plusmn'], [180, 'acute'], [181, 'micro'], [182, 'para'], [183, 'middot'], [184, 'cedil'], [186, 'ordm'], [187, 'raquo'], [191, 'iquest'], [192, 'Agrave'], [193, 'Aacute'], [194, 'Acirc'], [195, 'Atilde'], [196, 'Auml'], [197, 'Aring'], [198, 'AElig'], [199, 'Ccedil'], [200, 'Egrave'], [201, 'Eacute'], [202, 'Ecirc'], [203, 'Euml'], [204, 'Igrave'], [205, 'Iacute'], [206, 'Icirc'], [207, 'Iuml'], [208, 'ETH'], [209, 'Ntilde'], [210, 'Ograve'], [211, 'Oacute'], [212, 'Ocirc'], [213, 'Otilde'], [214, 'Ouml'], [215, 'times'], [216, 'Oslash'], [217, 'Ugrave'], [218, 'Uacute'], [219, 'Ucirc'], [220, 'Uuml'], [221, 'Yacute'], [222, 'THORN'], [223, 'szlig'], [224, 'agrave'], [225, 'aacute'], [226, 'acirc'], [227, 'atilde'], [228, 'auml'], [229, 'aring'], [230, 'aelig'], [231, 'ccedil'], [232, 'egrave'], [233, 'eacute'], [234, 'ecirc'], [235, 'euml'], [236, 'igrave'], [237, 'iacute'], [238, 'icirc'], [239, 'iuml'], [240, 'eth'], [241, 'ntilde'], [242, 'ograve'], [243, 'oacute'], [244, 'ocirc'], [245, 'otilde'], [246, 'ouml'], [247, 'divide'], [248, 'oslash'], [249, 'ugrave'], [250, 'uacute'], [251, 'ucirc'], [252, 'uuml'], [253, 'yacute'], [254, 'thorn'], [255, 'yuml'], [338, 'OElig'], [339, 'oelig'], [352, 'Scaron'], [353, 'scaron'], [376, 'Yuml'], [402, 'fnof'], [710, 'circ'], [732, 'tilde'], [913, 'Alpha'], [914, 'Beta'], [915, 'Gamma'], [916, 'Delta'], [917, 'Epsilon'], [918, 'Zeta'], [919, 'Eta'], [920, 'Theta'], [921, 'Iota'], [922, 'Kappa'], [923, 'Lambda'], [924, 'Mu'], [925, 'Nu'], [926, 'Xi'], [927, 'Omicron'], [928, 'Pi'], [929, 'Rho'], [931, 'Sigma'], [932, 'Tau'], [933, 'Upsilon'], [934, 'Phi'], [935, 'Chi'], [936, 'Psi'], [937, 'Omega'], [945, 'alpha'], [946, 'beta'], [947, 'gamma'], [948, 'delta'], [949, 'epsilon'], [950, 'zeta'], [951, 'eta'], [952, 'theta'], [953, 'iota'], [954, 'kappa'], [955, 'lambda'], [956, 'mu'], [957, 'nu'], [958, 'xi'], [959, 'omicron'], [960, 'pi'], [961, 'rho'], [962, 'sigmaf'], [963, 'sigma'], [964, 'tau'], [965, 'upsilon'], [966, 'phi'], [967, 'chi'], [968, 'psi'], [969, 'omega'], [977, 'thetasym'], [978, 'upsih'], [982, 'piv'], [8194, 'ensp'], [8195, 'emsp'], [8201, 'thinsp'], [8204, 'zwnj'], [8205, 'zwj'], [8206, 'lrm'], [8207, 'rlm'], [8211, 'ndash'], [8212, 'mdash'], [8216, 'lsquo'], [8217, 'rsquo'], [8218, 'sbquo'], [8220, 'ldquo'], [8221, 'rdquo'], [8222, 'bdquo'], [8224, 'dagger'], [8225, 'Dagger'], [8226, 'bull'], [8230, 'hellip'], [8240, 'permil'], [8242, 'prime'], [8243, 'Prime'], [8249, 'lsaquo'], [8250, 'rsaquo'], [8254, 'oline'], [8260, 'frasl'], [8364, 'euro'], [8465, 'image'], [8472, 'weierp'], [8476, 'real'], [8482, 'trade'], [8501, 'alefsym'], [8592, 'larr'], [8593, 'uarr'], [8594, 'rarr'], [8595, 'darr'], [8596, 'harr'], [8629, 'crarr'], [8656, 'lArr'], [8657, 'uArr'], [8658, 'rArr'], [8659, 'dArr'], [8660, 'hArr'], [8704, 'forall'], [8706, 'part'], [8707, 'exist'], [8709, 'empty'], [8711, 'nabla'], [8712, 'isin'], [8713, 'notin'], [8715, 'ni'], [8719, 'prod'], [8721, 'sum'], [8722, 'minus'], [8727, 'lowast'], [8730, 'radic'], [8733, 'prop'], [8734, 'infin'], [8736, 'ang'], [8743, 'and'], [8744, 'or'], [8745, 'cap'], [8746, 'cup'], [8747, 'int'], [8764, 'sim'], [8773, 'cong'], [8776, 'asymp'], [8800, 'ne'], [8801, 'equiv'], [8804, 'le'], [8805, 'ge'], [8834, 'sub'], [8835, 'sup'], [8836, 'nsub'], [8838, 'sube'], [8839, 'supe'], [8853, 'oplus'], [8855, 'otimes'], [8869, 'perp'], [8901, 'sdot'], [8968, 'lceil'], [8969, 'rceil'], [8970, 'lfloor'], [8971, 'rfloor'], [9001, 'lang'], [9002, 'rang'], [9674, 'loz'], [9824, 'spades'], [9827, 'clubs'], [9829, 'hearts'], [9830, 'diams']]
$g___aChrEnt = $aisEntities
EndIf
$g___oDicEntity = ObjCreate("Scripting.Dictionary")
If @error Or Not IsObj($g___oDicEntity) Then Return SetError(1)
For $i = 0 To UBound($g___aChrEnt) - 1
$g___oDicEntity.Add($g___aChrEnt[$i][1], ChrW($g___aChrEnt[$i][0]))
Next
Return $g___oDicEntity
EndFunc
Func __HTML_RegexpReplace($sData, $Escape_Character_Head, $Escape_Character_Tail, $iForceANSI, $iHexLength, $isHexNumber = True)
Local $Chr_or_WChar =($iHexLength = 2 ? 'Chr' : 'ChrW')
If $Escape_Character_Tail And $Escape_Character_Tail <> Default Then $Chr_or_WChar = 'ChrW'
If $iForceANSI Then $Chr_or_WChar = 'Chr'
Local $sResult = Call('Execute', '"' & StringRegExpReplace(StringReplace($sData, '"', '""', 0, 1), '(?i)' & StringReplace($Escape_Character_Head, '\', '\\', 0, 1) & '([[:xdigit:]]{' & $iHexLength & '})' & $Escape_Character_Tail, '" & ' & $Chr_or_WChar & '(' &($isHexNumber ? '0x' : '') & '${1}) & "') & '"')
If $sResult == '' Then Return SetError(1, '', $sData)
Return StringRegExpReplace($sResult, '\\([\\/"''\?:])', '\1')
EndFunc
Func _HTML_AbsoluteURL($sSource, $sURL, $sAdditional_Pattern = '', $sProtocol = '')
If Not StringRegExp($sSource, '(?i)<\h*?base .*?href\h*?=') Then
$sSource = '<base href="' & $sURL & '"/><script>var _b = document.getElementsByTagName("base")[0], _bH = "' & $sURL & '";if (_b && _b.href != _bH) _b.href = _bH;</script>' & @CRLF & $sSource
EndIf
If $sAdditional_Pattern Then $sAdditional_Pattern &= '|'
Local $basePattern = '(?i)(' & $sAdditional_Pattern & '(?:window\.location|\W(?:src|href)|v-bind:src|param name\h*?=\h*?["'']movie["'']\h+value)\h*?=\h*?["'']*?|attr\([''"]src[''"]\h*?,\h*?[''"])(?!https?:|javascript:|\&|\#)'
$sURL = StringRegExpReplace($sURL, '(?i)^(.*?)/[^/]+\.(?:php|html|aspx).*$', '$1')
$sURL = StringRegExpReplace($sURL, '/$', '')
Local $aURL = StringRegExp($sURL, '(?i)^(https?://[^/]+)(/?)(.*)/?$', 3)
If @error Then Return SetError(1, '', $sSource)
$sSource = StringRegExpReplace($sSource, $basePattern & '//', '$1' & $sProtocol & '://')
$sSource = StringRegExpReplace($sSource, $basePattern & '/', '$1' & $aURL[0] & '/')
$sSource = StringRegExpReplace($sSource, $basePattern & '\./', '$1' & $sURL & '/')
Local $regSource = StringRegExp($sSource, $basePattern & '((?:\.\./)+)', 3), $memReg = '|', $sRegAttach
If Not @error Then
Local $baseURL = ''
For $i = 0 To UBound($regSource) - 1 Step 2
$sRegAttach = $regSource[$i] & $regSource[$i + 1]
If StringInStr($memReg, '|' & $sRegAttach & '|', 0, 1) Then ContinueLoop
$baseURL = $aURL[2]
For $j = 1 To(StringLen($regSource[$i + 1]) / 3) + 1
$baseURL = StringRegExpReplace($baseURL, '(?:/|^)[^/]+$', '')
Next
$sSource = StringRegExpReplace($sSource, '\Q' & $sRegAttach & '\E', $regSource[$i] & $aURL[0] & '/' &($baseURL ? $baseURL & '/' : ''))
$memReg &= $sRegAttach & '|'
Next
EndIf
Return $sSource
EndFunc
Func _HTML_Execute($sHTML, $iElement = '', $iAttribute = '', $iSpecifiedValue = '', $iReturnHTML = False)
If $sHTML == '' Then Return SetError(1, __HttpRequest_ErrNotify('_HTML_Execute', 'Tham số $sHTML đưa vào rỗng'), '')
Local $sResult = '', $oFind = 0, $l___iError = 0
Local $oHTML = ObjCreate("HTMLFILE")
If @error Or Not IsObj($oHTML) Then Return SetError(2, __HttpRequest_ErrNotify('_HTML_Execute', 'Tạo HTMLFile Object thất bại'), $sHTML)
If $iElement = Default Then $iElement = ''
If $iAttribute = Default Then $iAttribute = ''
If $iReturnHTML = Default Then $iReturnHTML = False
With $oHTML
.parentwindow.execScript($sHTML)
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_HTML_Execute', 'HTMLFile Object không thể truy vấn dữ liệu HTML đưa vào'), $sHTML)
Select
Case Not $iElement And Not $iAttribute
Local $oBody = .body
If @error Or Not IsObj($oBody) Then Return SetError(4, __HttpRequest_ErrNotify('_HTML_Execute', 'Không thể xử lý dữ liệu HTML đã nạp vào'), $sHTML)
$sResult =($iReturnHTML ? $oBody.innerHTML : $oBody.innerText)
Case $iElement And Not $iAttribute
__HttpRequest_ErrNotify('_HTML_Execute', 'Phải điền giá trị cho tham số $iAttribute')
$l___iError = 5
Case $iAttribute And Not $iSpecifiedValue
__HttpRequest_ErrNotify('_HTML_Execute', 'Phải điền giá trị cho tham số $iSpecifiedValue')
$l___iError = 6
Case Else
Local $oElements =($iElement ? .getElementsByTagName($iElement) : .All)
If Not @error And IsObj($oElements) Then
For $oElement In $oElements
Switch $iAttribute
Case 'class'
If $oElement.className = $iSpecifiedValue Then $oFind = 1
Case 'id'
If $oElement.id = $iSpecifiedValue Then $oFind = 1
Case 'name'
If $oElement.name = $iSpecifiedValue Then $oFind = 1
Case 'type'
If $oElement.type = $iSpecifiedValue Then $oFind = 1
Case 'href'
If $oElement.href = $iSpecifiedValue Then $oFind = 1
EndSwitch
If $oFind = 1 Then
$sResult =($iReturnHTML ? $oElement.innerHTML : $oElement.innerText)
ExitLoop
EndIf
Next
Else
$l___iError = 7
EndIf
EndSelect
.close()
EndWith
$oHTML = ''
If $l___iError Then Return SetError($l___iError, '', $sHTML)
Return StringStripWS($sResult, 2)
EndFunc
Func __Gzip_Uncompress($sBinaryData)
If Not StringRegExp(BinaryMid($sBinaryData, 1, 1), '(?i)0x(1F|08|8B)') Then Return SetError(1, __HttpRequest_ErrNotify('__Gzip_Uncompress', 'Chuỗi binary này không phải định dạng của nén Gzip'), $sBinaryData)
If Not $g___JsLibGunzip Then
$g___JsLibGunzip &= 'G7wAKGZ1bmN0aW8AbigpeyJ1c2UAIHN0cmljdCICOwW4IGsodCl7AHRocm93IHR9AHZhciBVPXZvAGlkIDAscz10CGhpcwdSdCh0LAhyKXsBRmUsaT0AdC5zcGxpdCgAIi4iKSxuPXMAOyEoaVswXWkAbiBuKSYmbi4AZXhlY1NjcmkkcHQLDSgiAUEiKwEBLCk7Zm9yKDsAaS5sZW5ndGgAJiYoZT1pLnMAaGlmdCgpKTsCKQUYfHxyPT09AFU/bj1uW2Vdij8BBDoBBD17fQMHAnICunIsRT0idQBuZGVmaW5lZAAiIT10eXBlbwBmIFVpbnQ4QUBycmF5JiaVDzESNhwQMzIYEERhdCBhVmlld4JnbmVQdyhFPwc6OgIcKQAoMjU2KSxyPRAwO3I8AAU7KysscikBfwKoPYB8cikAPj4+MTtlO2WhgAM9MSkwh713gb0ULGWDvmkAtyJudUBtYmVyIj2FcXI4P3I6gC2A2g4NZT8YZTp0hFgCKGk9LQIxwBA3JnM7bi0iLQIiaT1pAB04XgBhWzI1NSYoaYBedFtyXSldwzMgPXM+PjOCCnIrwD04KWk9KJEAEhCzgTRLFSsxwBWQBTKTBaozkwU0kwU1kwU2kwUCN4AFO3JldHVyAG4oNDI5NDk2QDcyOTVeaUEnMAFClGk9WzAsMTkAOTY5NTk4OTQALDM5OTM5MTkQNzg4LIBwNzUyBDQ3QAUxMjQ2MwA0MTM3LDE4OIA2MDU3NjE1gAoAMTU2MjE2ODUALDI2NTczOTIEMDOAAjQ5MjY4ADI3NCwyMDQ0IDUwODMyQBU3N4AyMTE1MjMwQBUANDcxNzc4NjS4LDE2gCTAHgANMQBlADYxMDIxLDM4ADg3NjA3MDQ3ACwyNDI4NDQ0ADA0OSw0OTg1ADM2NTQ4LDE3ADg5OTI3NjY2ACw0MDg5MDE2AjagAjIyMjcwNmAxMjE0LGAO4AQ4hDYxYBU0MzI14BUAMyw0MTA3NTgRYAAzLDIgETY3N9A2MzksoQM4IB4gIEA2ODQ3NzdAFCxANDI1MTEygBcyICwyMzIxoBk2MwA2LDMzNTYzM0Q0OCAgNjYxQRE2AjWgCjk1MzAyNwo1IBgzwAIxNTMxADcsOTk3MDczADA5NiwxMjgxQyAEQCYsMzU3QBg1lDMzoAo3oCk4OKAbACwxMDA2ODg4mDE0NWAFIRU3NiAMijOgLjEAGzI5LAAdQaAyMjQ0MyxAHTACOeAoMiwxMTE5BjAhBwArNjg2NTEANzIwNiwyODnEODDgMDI4LGAlYC+sNDVAIGADMiATMAArADcwNTAxNTc1u6AKoA82ACdAGKEHNkAToUAgMzczNSA4NIEdIcBBNTQzMAAMMjEQODEwNIBDLDU2ADU1MDcyNTMsJeAVNCA/NzOgCjQ4FcAlMWALLEAeOTQzADYzMDMsNjcxBaAOOYBAMTU5NDF7ABOBQDOANIAEgUBAJDMANDc4MTIsNzlANTgzNTUyACs0u2BFwCkyQEshHmBVN0ABwDA2MDE0OYAPwVSQN'
$g___JsLibGunzip &= 'DE0NkAyLDOgSaegHIBMwDI5MEA3MsBBtDIzQEs54AvgIzdgFmY0ABxgOTYzoE9ANDb2OOAfYD4zQFfgIyBGYSG6MMBaNyBRQVOhJTCgPUtAQEEGMwAYMzcARzMYMDA04AMgBTY1NqdARyAgYQE4McBJNABfV0FHwElgMTIgHzlgGTjJYFk5NaBXLDRgOkBUQeBVMjIzODDADTaSOGAVNjZgYzg3AFqhoCAzNzA5wB40oEmHYFvAKqEuNjI1MIECX8A9QDmAB2BfgCE4gF4ybwAg4GIgGCAgM8BsQCswSSAgMjTgCzc1gEwxejbASTXgcEA0YGWgbDcBAGozNjI2NzAzgjIAYjIyNDk5gGsDIE8gNjUzNTk2MIgsOThAhDE0OKBJUDc0NzDAcDlADTXwNjkwM6AKYBVggmA9ijigXDFAAjYwNAAxKYFUNTIAbDMAKzU1QDQwNzk5OcAKMYYzgFigcTYsODcAj0uAAsAKOQAdNDOgRywjAGZgKzE4NeBkMTQhwDQ0NDY3QFc1OEY04ESAFTg1MgA2NhmBTDcw4IVAADksMeIz4HMzMzlgfsCBYDxqM6AvM1BJM/ALQAEza1AsUB4xoSc0oEGwCDB0OSyAGDEwCOBJ8Aow7XBIOZAbUQg1gD6gTFAqgjEwKzA1NCw3gBvEMzjwQSwyOfADIA5UNTDRPzKQBDTwKjGGNfBI8AYwNyw3gSsIMTg3YA8wODI27wAZYDrAFQAZMsBUUCZwNpY5QB9hKjngHDQ2wDVcNjJAQmA/4Cw1EDAwe+AOkAIzoBegMlEqcTE2vUAfLHBBcCHRJHA1OKA5RXAbM0ABOTE4QS4y3DQ4QFtALeAFMgA0QELhMCowNTM34RpQPDAJ3DE3AD9ABaAQOYE0sDvSNkAHNjeQCjLgROA/v0AYoTNATLBSAASwXDQABPcwINBA4Vc3EEcAMtBDsAePME8AEHAyIEsyMTUQEdY50DtAUzagFDLgKgAd3XArNyAfQAFAIzHQTHAf/DMxYQ8gYnBKAFOBKOAs2bAcNTVwHlAFOCBB8AUbADXBHTdQZ7A/OTc5rbBiNlELYFs4wEU3cCN5UCc5MGBTgCexKmBJONYsYFagbTeRLzNAMPBhOjIQEDXQGaAvEWo3OXA3MzYwQChAVzBXMsY4kBRAVzE5NhBncECxEAk0NzTQCyAQObApbDc1sAVAVzYgAeEqMV4wMAdgaiAgYEE3wEkwGYBOMjjwUJAlNjks4DgyOTMycCWRL4BB2DM1MSBoQHMy0W6RVFQxNsBwNOEeNoAtOHuAMgA1M0AaIBvQQYAtMzgzNjlwBsA9gEI3OLXxMDWQVTawPyAQNCEmrDA4kXcQJDMQPjTAZIw5OQAokA04LDfAZXPAbDAsMTUAVXBSoDUze8B4ERo5cEAQHIACcCgsj3F90CYADCEcMzIw0BUbQHzwPjfQVfAuOTY1lfASMKJUNvB2MjlQIPmQPTM1kHiQAlB4QFXgHt/AGqBtgHOwZsAPMBBNgEYzQHWwDjcx0H5wHzQxR8CDgH0QQzQwNhBFMtWAeDIgPTLwCzEQCsAuQ5AAIIYyNzI2QAkzgDg1NTk5MDJxG34woD4xRfEF8C5gH1AFMtY2IAsAcTKQKzUxA7CDjeAkNZAOEB4yLDUgOLUwRTmwHDGgGiEcMTAm/jMSGvE+MBPQJMBSUAFhQntQXYCBOEBRoDUwhNA+MqPwHZBaMTcxII40cE3PkCsQSbAK4Cw0MNCEUDD+N/ADoCDAQyF8YA4wGxBtPCwzADMwE2B38Bc1MH8wN+CAURowVTAQYEywizE9QIoykCuATJAJAJc4MHGADzUxMJAvEG+AcTJXoS+AMxCIM7AEMVCRNE9AX3BMwiZQeTE4ADE17bBaM/AMoC04MEkgZKBcabEkOGXwNDiQjbAsOWMAaiAwODM3kCqQLzAqMkCEOAAGOHAMMzM7'
$g___JsLibGunzip &= '8DdwJzgwjqBcQAU0MLmQGzcxESCSZvFBLGCfDjjwgBFRgVgwNzQ548BPYGs0MjHQn2Bx0E54NTc0EJtRe5BC0Vsw9DA5UAc2sJkAMtCf4IQfMF8gFzFkEFEQFjkyOP9QkSCEkIyhmNAqsCDhciF8HyARcQlgD1AIgVoxN10ALGE9RT9uZXeDss+kyyhpKTppN8VqQTDhfXbgenHgochyAizQ3SxuLHMsYQAsaCxvLHUsZgwsY9DeI9osbD0wICxwPU510ccuUABPU0lUSVZFXwBJTkZJTklUWUXywm8gzm88Y3DFb4ApdFtvXT5sgN0kbD2hACksUQA8cA0AAXADARIDcj0xPOA8bCxlPRALpNM0Czm103IpIOdBy3HpMjuAaTw9bDspe+HTsdkGaWYo8QWw4mnDAYBoPW4sdT1hAAkIdTxpAAl1KWE9AGE8PDF8MSZoQCxoPj49MfIHZiQ9aUABNnzQDj1hADt1PHI7dSs9AHMpZVt1XT1mIWADbn0rK1DXPDxQPTEsc1EAfVPDWwBlLGwscF19QUAucHJvdG/h5i4AZ2V0TmFtZT2XlRVQFsMCIOH0Lm6wAbx9LAwD4eMPAwMDZKDljQsDR68CowJIfTsRHCBuLGg9W6Pbr7gAbj0wO248MjgAODtuKyspc3cAaXRjaCghMCkAe2Nhc2UgbjwAPTE0MzpoLnAAdXNoKFtuKzQAOCw4XSk7YnIQZWFrOwWIMjU1AQdELTE0NCs0MEgwLDkPTjc5CE4yQDU2KzAsNw8lOAI3CSU4MCsxOTIBCHVkZWZhdWx0ADprKCJpbnZhAGxpZCBsaXRlAHJhbDogIituACl9dmFyIG89AGZ1bmN0aW9uCCgpewUKIHQodAQpew3jMz09PXQAOnJldHVyblsAMjU3LHQtMyxUMF2DbjQLDjgADjRVBg41Cw45AA41Bg42qQoONjAADjYGDjcLDqoxAA43Bg44Cw4yAA6qOAYOOQsOMwAOOQYOlDEwiw40gA4xMAYPSnSA5jKGdDY1gQ4xrCwxhDpBBzRHBzZBB5ozSgc2RwdBSTE1SgemOEcHgUkxN0kHMsgdocFJMTksMscdMkcWkjcBSjIzSQczMEYWsjdBSjI3SgfHLDeBSlQzMUkHNMcdN8FKM2g1LDPHHTVIFsFKNJYzSgdHNDfBSjUxSQemNsgswUo1OUkHOMgdocFKNjcsNMcdOUgWycFKODNJBzExiDQBS6w5OYoHyEM4QUsxAGKpCBcxNsceOMFLMYBEUjUHHzE5hxc4QUwxaDYzLOgDMqgxABN0kC0xOTXqAzU35jGaOKEmMgAy5QcyNatXHjgBJ4ACYVARd2VuZ0R0aOF2dCl9AndyACxlLGk9W107AGZvcihyPTM7SHI8PeAHO3Kgk2UAPXQociksaVsAcl09ZVsyXTyAPDI0fGVbMQABRDE2AAEwXTvDeCAgaX0oKTvGfm0oCHQscgZ/dGhpcwouQQwsIgFqPTMyTDc2oDDBAmQ9YgJmHcMAY8MAQKRDBWlucAB1dD1FP25ldwAgVWludDhBckhyYXlgijp0AwRvjD0'
$g___JsLibGunzip &= 'hAC4BCWs9U0MCQndBAihyfHyAGXsAfSwwKSkmJiiAci5pbmRleCABCcINYz0EAiksci4AYnVmZmVyU2l0emXFA2rAA6cCZwRUdHlwZgRrZgShAmEEcjRlc2gId+ADIwIpKaUDE2tEvE46YhBhySBEYj1AHChFP4ccOilCHSkoYiUrIgZqK/vgMkrBU0UJoFKBINcIAwhXJBHAOqEFROMScYMuQTWjAWyjAUMkzkdIRXIGcgBEJsBpbmZsYQB0ZSBtb2RlIiIpYElFJibFNDMyEeM0byk7QcNOPTAALFM9MTttLnAgcm90b3SgKC5nE8rFAAs7IUIUbzspQnthBnQ9VCgBAiyIMyk75McxJnQFNAXAPjBgGT4+Pj0xaaQqMDrBBnKjF+JGLI3EHGPAW2ILYixuwwMoYSxzoDNsQmEsYYA9VSxoPWkuxAE4bz1VBQ6CBgZUMCwAczw9ZSsxJiaMayhsIQDfb21woD0Ac2VkIGJsb2MAayBoZWFkZXJgOiBMRU6gI4AMckBbZSsrXXzDADy8PDjfBLV13wTWBE7mBHA9PX4oLQWALq8Jbg5jrwmjCQMPIHZlcghpZnlBCmUrYT4ucnQQWg5AOCDzMCBpAHMgYnJva2Vu1wEDAhJnLWZhHG5ABMUUAbAcaWYoYS09bwA9aC1uLEUpaQguc2UQRS5zdWICYZI8ZSxlK28pRCxuIAArPW/AAD0wbztlbHCQsgRvLRAtOylpQJArXT1Fww47IgdhPW41HWWWKKADVB19SJJTOt8IBClpgwJlKHt0OvwyfZU0Ly5Eji0usAwvDBooIQxhQAggACs9YTUhDGEoDGEvDCIMYz2OZfM2sQwSAWI9aVmegjGjPWwoTSxqOj8CMoIudSxmLGMsSGwscHUyNSnQQTdELHn4ADEsYtUANGApKzQsZ09GREZHUVQfKSxk0DB2MAB3tTAAQTAAbeAwkRRtUKsAbTxiOysrbSmAZ1tHW21dXbUFoxA6kBEhRSlzAmJQBypn9AQ7LQMwUmZ1PTh6KGexBk9PUSEpKCBwK3kpLCAHLGwmPaAAUARsO5Wydj1CcYNBdSksdrQ/MUI20h5BPTMrVEMyiCk7QZEXZFttUDd0PXeaFTfdAhAM2QIwTDt30A7IJDE4FAMxOjEFBjcLBikD9SR3PRHUB3Z9ZgAPRT9kQXcvMCxwKTrwAGwQaWNlKMEAKSxjyz0CGAJwNWRsKGAfjysB9Eh1bmtub3duwCBCVFlQRTN+gFnDFHpCJnEoKX0yWfIjYD1bMTYsYaPQrixAOCw3LDks8AAwAixgpjEsNCwxMiYs4KiQoSwxwAAsMSA1XSxHPcd4MTaRU15jKTqQKD1bIJW1kAM2YAQ4gARQsDGgrp8ABNAEkKngp5AENyygkf8goXCfwJ0QnGCaII/wljGVvjHAAbGR8Y8xjuBuLDQAhl2QLq8HbCk6bCAvWlsQtyw5AIAHLDEAMl4sEwBQpqAMAQo0cA0072AKAJZQADIDXQArpwUkhtB5KTp5ADNbsK2QA/sRA9ERMeAMsLAgrbAEwBIINSw5oA0yOSwxVjnADZDMM+CXNVACN5I2MAEwMqAPNTMAA5QwNLCqMPCwNDAAA0A2MTQ1LDghAzEoMjI4gAI2YQMyNDA1NzddADhvDmcp4DpnLHY9Zg6lDWEN6wENwQw2oBs3shfRF9EHNiwkGNACMrEcwQszXQwsQygcxA52KTp2DCx430HUQTI4OClBdDswLGY9eMU9dQQ8ZvBAdSl4W3WIXT11gus/ODqAAAng6T85ggA3OT83BDo4EidELEksTWEwLngpLFqvBqQGM4owkwZEIINJPVqVBghEPEmQBkQpWltQRF09NeIEaqAEWvfAAtByQecggD8hpzFIgYCRMa10LmYRfy5k4H6OdACgYGyAeHQuY/B+AnOl'
$g___JsLibGunzip &= 'BW48cjspaHA8PWEmeX0fbxNvaSB8PXNbYSBFPDxAbixuKz049a9lAD1pJigxPDxyBCktAKkuZj1pPgA+PnIsdC5kPVRuLXEAY7FhfRCyVLgAY3Rpb24gcSgAdCxyKXtmb3IAKHZhciBlLGkALG49dC5mLHMRAChkLGEAFGlucBB1dCxoACRjLG8APWEubGVuZ3QAaCx1PXJbMF0ELGYADDFdO3M8AGYmJiEobzw9AGgpOylufD1hAFtoKytdPDxzACxzKz04O3JlAHR1cm4gczwoAGk9KGU9dVtuACYoMTw8ZiktADFdKT4+PjE2ACkmJmsoRXJyAQCJImludmFsaYBkIGNvZGUgA28AOiAiK2kpKSxBAJs9bj4+aQAIZAg9cy0BB2M9aCwANjU1MzUmZX0IZnVuA9hCKHQpQHt0aGlzLgK/PUR0LAIMYz0wAwhtCD1bXYMEcz0hMQB9bS5wcm90b4B0eXBlLmw9hSKLA44CjD0CH2IsaQMEhGE7ggdyPXQ7hZ2AbixzLGEsaICRAwAhgpEtMjU4OzIANTYhPT0obj0jALUARyx0KQCQaWYoKG48gAwpAJhpJgQmKAImYT1pLGURAy9lKCmGNCksZQBbaSsrXT1uOyBlbHNlIIE3aD0gcFtzPW4AMDddgCwwPGJbc12AItBoKz1UAiUsAQgAlokGOnIpAOVkW24BFvZDAAMAFmEGCwEEAAuhIkA7aC0tOynAI10iPQIlLWFdwj87OCI8Ay5kOynCMmQtND04g1djQAyFN30s3clZQ/9Zw4bjWG8BnkIibUBXKYSxP1dzwM8hV2m8K2hAXRMhv1WIr2WHVRwpe8GuQPjAlW5ldwAoRT9VaW50OEBBcnJheTqiACmBRE8tMzI3NjiHTifjAWGBQWhiOwBWRSkAZS5zZXQobi5Qc3ViYUEIKIIGLJfFXQBbBlR04GxyPSUDADt0PHI7Kyt0RSBHdOBYW3QrIgddA8EKIjJpLnB1c2hMKGXge+ENbitGByyMRSkADssOaSxpAwiXLA7ADOIKO0ENbltCDTBpK3RdpY9CDWE9aWIELG6LUUSIUcMmcmwsZaOhIRJpgaBkRi/B4ghjKzF8MMGkxgMboEAiA2LmDQA+Im51gG1iZXIiPT1hi8BvZiB0LnTAAoGsqHQpLLADeqEDK6CtgnoBeDwyP2U9YaYqc4QPLYMPKYMQclsgMl0vMirgjHwwFCk8ZbM/BQEraTpBRQE8PDE6Zaa3KoBuLEU/KHI9gEIWIEdC4C8pQjxhKTqIcj1h43diPXIrJe5x8ktBJaAhMIYgIcZCI1MAonpPbitrUCmhQjBQPT09aEQeKYTHRT4/wyvtT6ICQBalA2xpXGNlRFNEA2KUckBSZSGGCjtyPGXgRHIpBcGpaUADbj0odD0QaFtyXUWDO2k8Am4gBGkpb1t'
$g___JsLibGunzip &= 'zK9HAr3RbaYOdciRIZLW2YUYJBAVhgAhKTmlmzQBidWZmZXI9b30rKkEwKsOpYAsD52Qfd+Y/gBSMNnIpgzbFH4VzojAAkyk6dAMJYocmleECOkMuYhQWPnJAJ3v0AyNVPRBjpQNEObQLdOh9LELYRka5C4QakgRIc3x8cgBnKPQDbdQuc5IZKQsEZwkEwRgPIktTC1k3A3djPHQ7q+g5AixBYEpVsCdVsCeqVWAnVRAnVfCJVcCJSFUsY6gELGzDAGMAO3N3aXRjaCiAaS51PWNbbOAdECxpLnalACgzMYMge7ABfHwxMzmiAAJ274lkIGZpbGVAIHNpZ25hwI1lgjoAii51KyIscQAOdsA7QE3HBXApe2MAYXNlIDg6YnIAZWFrO2RlZmEQdWx0OjaPdW5rEG5vd24wj21wcghlc3PRmW1ldGgEb2Sijy5wKSl9UVBYaS5oRQVlhAB8kRMMPDw4lgAxNqYAFDI0oA1IghJEYXRAZSgxZTMqcFZpRC5OdQRpLk2lADBwPCg0JiAG0A6wEUkDZAG2BDgsbCs9acguSSkwhyg4ggKzo8J1ES5vPTA7AAT1CRFgjnVbb5EzU3RyAGluZy5mcm9toENoYXJDUJ0oYKIgaS5uYW2woC5qwG9pbigiIvINAAQ8MTafBZ8FnwWZBUo9NnVnBTAFMiIFUC5pLgRCPcOidyhjLDCkLGwwby5CMB4oUxQDtw4fH2QgaGVhZABlciBjcmMxNiwiKQFaIBJjVDQtNHZd0APWADPQrxEZBgEydwABghkWATEQAfAZ9gBsAC00LTQ8NTEyhCpuoAphPW4pYC0F4T5tsAp7aW5kZRB4OmwsgzhTaXoQZTphfeELZGF0QGE9cj1zLrE2bIVwAGMgH0s9Zj0+DQfWDQoiAbgwLHcocuAsVSxVKbAQsLx2KRG1uENSQ0CBIGNoAGVja3N1bTogEDB4Iis1Ay50b4VDHiiAvCsiIC/SAeZmagESMUw9cFadFl8JEDw8MjRTCSg0MgA5NDk2NzI5NfwmcoQWIQoAEi4K4kIAOUeAEdDCnwN0aCmyCSKsK27ACNJJbYOHaTRKMGM9bH1yAUDBMDsBkUhwLHksYixn0XNDbSxkkGJ2cC6BSiJwsAB5PWdECTtwBDx54GJwKXYrPeBnW3BdLlEZtQGAOxpFkmZigjgod3YpLB9wBMYDcFqwjvYDLGQp3Cxk/wSCwELbYoE3CgRjoAf3BztiPWKeCFtjAG9uY2F0LmFwAHBseShbXSxiBCl9ZFtifSx0KAAiWmxpYi5HdYBuemlwIixCcBHDKgGIBGRlY2+jSnACDXgBZz8DptVnZXRNamXxkHM7A0Y9A1MCIhwsQY8B4QPpBmV0Tr9gRKACTwHPA88DQFFhzgMHQQHPA88DTXRpbWUB2wNHKX0pLmNhVGxsInYpQiRn4hQgLD0gsTwIFigVFGVkc4MCNxVlZIIbMAPDAy5tpwEovwJgAiLwOHGOIMOC/BCNOyBpPP4EBSkAIGlOsAArKykge2RlYwBvbXByZXNzZUBkICs9ICgJgEEAcnJheVtpXSAAPCAxNiA/ICIAMCIgOiAiIikIICsgEZwudG9TAHRyaW5nKDE2ACk7fTs='
$g___JsLibGunzip = _B64Decode($g___JsLibGunzip, True, True)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('__Gzip_Uncompress', 'Khởi tạo thư viện Gzip thất bại'), $sBinaryData)
$g___JsLibGunzip = BinaryToString($g___JsLibGunzip)
EndIf
Local $sRet = _JS_Execute('', 'var compressed=[' & StringTrimLeft(StringRegExpReplace($sBinaryData, '(\w{2})', ',0x$1'), 6) & '];' & $g___JsLibGunzip, 'decompressed')
If @error Or $sRet = '' Then Return SetError(3, __HttpRequest_ErrNotify('__Gzip_Uncompress', 'Giải mã Gzip thất bại'), $sBinaryData)
Return StringStripWS($sRet, 3)
EndFunc
Func __ArrayDuplicate($aArray, $iCase = True, $iCount = False, $iCheckDulplicateNumber = False, $iBase = 0)
If Not IsArray($aArray) Or UBound($aArray) < $iBase Then Return SetError(1, 0, $aArray)
Local $oDictionary = ObjCreate("Scripting.Dictionary")
With $oDictionary
.CompareMode = Number(Not $iCase)
If $iCheckDulplicateNumber = False Then
For $i = $iBase To UBound($aArray) - 1
.Item($aArray[$i])
Next
$aArray = .Keys
If $iCount Then _ArrayInsert($aArray, 0, $oDictionary.Count)
$oDictionary = Null
Return $aArray
Else
For $i = $iBase To UBound($aArray) - 1
If .Exists($aArray[$i]) Then
.Item($aArray[$i]) = .Item($aArray[$i]) + 1
Else
.Add($aArray[$i], 1)
EndIf
Next
Local $aArray2 = [.Keys, .Items]
If $iCount Then
_ArrayInsert($aArray2[0], 0, $oDictionary.Count)
_ArrayInsert($aArray2[1], 0, $oDictionary.Count)
EndIf
$oDictionary = Null
Return $aArray2
EndIf
EndWith
EndFunc
Func __ObjectErrDetect()
If $g___oErrorStop = 0 Then
With $g___oError
Local $sErrDescription = .windescription & ' ' & .description
Local $sReport = StringReplace('<Error> COM [Error ' & Hex(.number) & '] (Line ' & .scriptline & ') ' & .source &(StringIsSpace($sErrDescription) ? '' : ' : ' & $sErrDescription), @CRLF, ' ')
EndWith
_HttpRequest_ConsoleWrite(@CRLF & $sReport & @CRLF)
EndIf
$g___oErrorStop = 0
Return SetError($g___oError.scriptline)
EndFunc
Func __HttpRequest_CancelReadWrite()
$g___swCancelReadWrite = Not $g___swCancelReadWrite
EndFunc
Func __Data2Send_CheckEncode($sData2Send)
Local $aPartData = StringRegExp($sData2Send, '(?:^|\&)(\w+)\h*?=\h*?([^\&]+)', 3)
For $i = 1 To UBound($aPartData) - 1 Step 2
If Not StringRegExp($aPartData[$i], '\%[0-9A-Z]') And StringRegExp($aPartData[$i], '[^\w\-\+\.\~\!]') Then
__HttpRequest_ErrNotify('__Data2Send_CheckEncode', 'Giá trị của Key "' & $aPartData[$i - 1] & '" trong POST data của _HttpRequest chưa Encode, điều đó có thể khiến request thất bại' & @CRLF, '', 'Warning')
EndIf
Next
EndFunc
Func __HttpRequest_CloseAll()
ConsoleWrite(@CRLF)
Local $aListSession = _HttpRequest_SessionList()
If Not @error Then
For $i = 0 To UBound($aListSession) - 1
If $g___hRequest[$i] Then $g___hRequest[$i] = _WinHttpCloseHandle2($g___hRequest[$i])
If $g___hWebSocket[$i] Then $g___hWebSocket[$i] = _WinHttpWebSocketClose2($g___hWebSocket[$i])
If $g___hConnect[$i] Then $g___hConnect[$i] = _WinHttpCloseHandle2($g___hConnect[$i])
_HttpRequest_SessionClear($aListSession[$i])
Next
EndIf
If $g___hWinHttp_StatusCallback Then DllCallbackFree($g___hWinHttp_StatusCallback)
If $dll_WinInet Then $dll_WinInet = DllClose($dll_WinInet)
If $dll_Gdi32 Then $dll_Gdi32 = DllClose($dll_Gdi32)
$dll_WinHttp = DllClose($dll_WinHttp)
$dll_User32 = DllClose($dll_User32)
$dll_Kernel32 = DllClose($dll_Kernel32)
$g___oDicEntity = Null
$g___retData = Null
$g___oError = Null
If $g___CookieJarPath Then _HttpRequest_CookieJarUpdateToFile()
EndFunc
Func __HttpRequest_ErrNotify($__TrueValue = '', $__ErrorNote = '', $__FalseValue = '', $iTypeWarning = Default)
If @Compiled Or $g___OldConsole = $__ErrorNote Then Return
$g___OldConsole = $__ErrorNote
If $g___ErrorNotify = True And $__ErrorNote Then
If $iTypeWarning = Default Then $iTypeWarning = 'Error'
If $iTypeWarning Then $iTypeWarning = '<' & $iTypeWarning
_HttpRequest_ConsoleWrite($iTypeWarning & '> [#' & $g___LastSession & '] ' & $__TrueValue & ' : ' & $__ErrorNote & @CRLF)
EndIf
Return $__FalseValue
EndFunc
Func __HttpRequest_CheckUpdate($iCurrentVersion)
If $CmdLine[0] > 0 And $CmdLine[1] = '--httprequest-update' Then
TraySetState(2)
Local $UpdateInfo = BinaryToString(InetRead('http://api.jsoneditoronline.org/v1/docs/39cf9a61c45c466880a2e4899bc293be'))
Local $sVersionHR = StringRegExp($UpdateInfo, 'version=(\d+)', 1)
If Not @error And Number($sVersionHR[0]) > $iCurrentVersion Then
If MsgBox(64 + 4096 + 4, 'Thông báo', '_HttpRequest có bản cập nhật mới (ver.' & $sVersionHR[0] & '). Bạn có muốn tải về ngay ?') = 6 Then
Local $LinkDownload = StringRegExp($UpdateInfo, '(?i)linkdownload=\[([^\]]*?)\]', 1)
If @error Then MsgBox(16 + 4096, 'Thông báo', 'Có lỗi trong khi thực hiện Update')
If $LinkDownload[0] = '' Then Exit
ShellExecute($LinkDownload[0])
MsgBox(16 + 4096, 'Thông báo', 'Vui lòng xem ChangeLog phiên bản ' & $sVersionHR[0] & ' trong tập tin Help để xem thông tin thay đổi cụ thể.')
Else
MsgBox(64 + 4096, 'Thông báo', 'Thông báo cập nhật sẽ hiển thị lại sau nửa tiếng')
EndIf
EndIf
Exit
Else
If @Compiled Or($CmdLine[0] > 0 And $CmdLine[1] = '--hh-multi-process') Then Return
Local $TimeInit = Number(RegRead('HKCU\Software\AutoIt v3\HttpRequest\AutoUpdate', 'Timer'))
If Not $TimeInit Or TimerDiff($TimeInit) > 30 * 60 * 1000 Then
RegWrite('HKCU\Software\AutoIt v3\HttpRequest\AutoUpdate', 'Timer', 'REG_SZ', TimerInit())
Run(FileGetShortName(@AutoItExe) & ' "' & @ScriptFullPath & '" --httprequest-update', @WorkingDir, @SW_HIDE)
EndIf
EndIf
EndFunc
Func __HttpRequest_StatusGetDataFromPointer($pInfo, $lInfo, $iReturnType = 'wchar')
Return DllStructGetData(DllStructCreate($iReturnType & '[' & $lInfo & ']', $pInfo), 1)
EndFunc
Func __HttpRequest_StatusCallback($hInternet, $iContext, $iInternetStatus, $pStatusInfo, $iStatusInfoLen)
#forceref $hInternet, $iContext, $iInternetStatus, $pStatusInfo, $iStatusInfoLen
Switch $iInternetStatus
Case 0x00000002
$g___ServerIP = __HttpRequest_StatusGetDataFromPointer($pStatusInfo, $iStatusInfoLen)
Return
Case 0x00004000
$g___LocationRedirect = DllStructGetData(DllStructCreate("wchar[" & $iStatusInfoLen & "]", $pStatusInfo), 1)
$g___retData[$g___LastSession][0] &= __CookieJar_Insert(StringRegExpReplace($g___LocationRedirect, '(?i)^https?://([^/]+).+', '${1}', 1), _WinHttpQueryHeaders2($g___hRequest[$g___LastSession], 22)) & @CRLF & 'Redirect → [' & $g___LocationRedirect & ']' & @CRLF
__HttpRequest_ErrNotify('Request đã redirect tới', $g___LocationRedirect, '', '')
Return
Case 0x00010000
Local $sStatus = ''
Local $aSSLError = [ [__HttpRequest_StatusGetDataFromPointer($pStatusInfo, $iStatusInfoLen, 'dword')], [0x00000001, 'CERT_REV_FAILED'], [0x00000002, 'INVALID_CERT'], [0x00000004, 'CERT_REVOKED'], [0x00000008, 'INVALID_CA'], [0x00000010, 'CERT_CN_INVALID'], [0x00000020, 'CERT_DATE_INVALID'], [0x00000040, 'CERT_WRONG_USAGE'], [0x80000000, 'SECURITY_CHANNEL_ERROR']]
For $i = 1 To 8
If BitAND($aSSLError[0][0], $aSSLError[$i][0]) = $aSSLError[$i][0] Then $sStatus &= ' ' & $aSSLError[$i][1]
Next
_HttpRequest_ConsoleWrite('<Error> [#' & $g___LastSession & '] SLL Certificate:' & $sStatus & ' - Kiểm tra lại URL là http hay https' & @CRLF)
Return
EndSwitch
EndFunc
Func __HttpRequest_iReturnSplit($iReturn)
Local $aRetMode[30]
$aRetMode[11] = 4
$aRetMode[8] = $g___LastSession
For $iReturn In StringSplit($iReturn, '|', 2)
If $iReturn == '' Then ContinueLoop
Local $iLocalMode = StringRegExp($iReturn, '^\h*?([\&\!\+\-\*\.\_\~\^\☺]*?)(\d+):?(\d{0,2})', 3)
If Not @error Then
$aRetMode[0] = Number($iLocalMode[1])
If $iLocalMode[2] Then
$aRetMode[0] = 1
$aRetMode[1] = Number($iLocalMode[2])
EndIf
If $iLocalMode[0] Then
For $iLocalMode In StringSplit($iLocalMode[0], '', 2)
Switch $iLocalMode
Case '-'
$aRetMode[2] = 1
Case '*'
$aRetMode[3] = 1
Case '+'
$aRetMode[4] = 1
Case '~'
$aRetMode[11] = 1
Case '_'
$aRetMode[12] = 1
Case '^'
$aRetMode[13] = 1
Case '.'
$aRetMode[14] = 1
Case '!'
$aRetMode[15] = 1
Case '&'
$aRetMode[16] = 1
Case '☺'
$aRetMode[17] = 1
Case Else
Return SetError(1, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Không nhận ra dấu hiệu đã cài đặt'), '')
EndSwitch
Next
EndIf
Else
Local $iLocalOption = StringRegExp($iReturn, '^\h*?([\$\#\%])(.+)', 3)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Sai pattern của Proxy'), '')
For $i = 0 To UBound($iLocalOption) - 1 Step 2
Switch $iLocalOption[$i]
Case '%'
Local $aProxy = StringRegExp($iLocalOption[$i + 1], '(?i)(https?://)?(?:(\w*):)?(?:(\w*)@)?((?:\d{1,3}\.){3}\d{1,3}:\d+)$', 3)
If @error Then Return SetError(3, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Sai pattern của Proxy'), '')
$aRetMode[5] = $aProxy[0] & $aProxy[3]
$aRetMode[6] = $aProxy[1]
$aRetMode[7] = $aProxy[2]
Case '#'
$g___hCookieLast = ''
If Not StringIsDigit($iLocalOption[$i + 1]) Then Return SetError(4, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Sai pattern của Session'), '')
If $iLocalOption[$i + 1] > $g___MaxSession_USE Then Return SetError(5, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Session vượt quá giới hạn. Max=' & $g___MaxSession_USE), '')
$aRetMode[8] = Number($iLocalOption[$i + 1])
Case '$'
Local $aPath = StringRegExp($iLocalOption[$i + 1], '(?i)^(?:([A-Z]:[\\\/].*?)|([^\Q\/*?"<>|\E]+\.\w+))(?:\:(\d+))?($)', 3)
If @error Then Return SetError(6, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Sai pattern của FilePath #1'), '')
$aRetMode[0] = 3
If $aPath[0] Then
$aRetMode[9] = $aPath[0]
ElseIf $aPath[1] Then
$aRetMode[9] = @ScriptDir & '\' & $aPath[1]
Else
Return SetError(7, __HttpRequest_ErrNotify('__HttpRequest_iReturnSplit', 'Sai pattern của FilePath #2'), '')
EndIf
$aRetMode[10] = Number($aPath[2])
EndSwitch
Next
EndIf
Next
Return $aRetMode
EndFunc
Func __HttpRequest_URLSplit($sURL)
Local $aResult[11] = [1, 80, '', '', '', '', '', 'http', '', '', '']
Local $aURL1 = StringRegExp($sURL, '(?i)^\h*(?:(?:(https?)|(ftp)|(wss?)):/{2,})?(www\.)?(.*?)\h*$', 3)
If @error Or Not $aURL1[4] Then Return SetError(1, __HttpRequest_ErrNotify('__HttpRequest_URLSplit', '$sURL sai định dạng chuẩn #1'), '')
If $aURL1[1] Then
$aResult[0] = 3
$aResult[1] = 0
ElseIf $aURL1[2] Then
If Not StringRegExp(@OSVersion, '^WIN_(10|81|8)$') Then Return SetError(2, __HttpRequest_ErrNotify('__HttpRequest_URLSplit', 'Websock chỉ áp dụng cho Win8 and Win10'), '')
$aResult[8] = 1
If $aURL1[2] = 'wss' Then
$aResult[0] = 2
$aResult[1] = 443
$aResult[7] = 'https'
EndIf
ElseIf $aURL1[0] = 'https' Then
$aResult[0] = 2
$aResult[1] = 443
$aResult[7] = 'https'
EndIf
Local $aURL2 = StringRegExp($aURL1[4], '^(?:([^\:\/]*?):([^\@\/]*?)@)?(.+)$', 3)
If @error Then Return SetError(4, __HttpRequest_ErrNotify('__HttpRequest_URLSplit', '$sURL sai định dạng User/Pass trong URL'), '')
$aResult[4] = $aURL2[0]
$aResult[5] = $aURL2[1]
Local $aURL3 = StringRegExp($aURL2[2], '^([^\/\:]+)(?::(\d+))?(/.*)?($)', 3)
If @error Then Return SetError(5, __HttpRequest_ErrNotify('__HttpRequest_URLSplit', '$sURL sai định dạng Host/Port trong URL'), '')
If $aURL1[0] == '' And Not(StringRegExp($aURL3[0], '\.\w+$') Or $aURL3[0] = 'localhost') Then Return SetError(3, __HttpRequest_ErrNotify('__HttpRequest_URLSplit', '$sURL sai định dạng chuẩn #2'), '')
$aResult[2] = StringRegExpReplace($aURL1[3] & $aURL3[0], '(\#[\w\-]+)$', '', 1)
$aResult[3] = $aURL3[2]
If $aURL3[1] Then $aResult[1] = Number($aURL3[1])
$aResult[9] = StringRegExpReplace($aResult[2], '.*?([\w\-]*?\.?[\w\-]*?\.?[\w\-]+\.[\w\-]+)$', '$1')
$aResult[10] =(StringLeft($aResult[2], 3) = 'www' ? 'www.' : '')
Return $aResult
EndFunc
Func _HttpRequest_ParseCURL($sCURL)
Local $iURL = '', $iHeaders = '', $iData, $iProxy = '', $iAuth = '', $iAuthBK = '', $iMethod = 'GET', $iSavePath = '', $iReferer = '', $iCookie = ''
Local $aURL, $aMethod, $aUserAgent, $aAuth, $aProxy, $aHeaders, $aData, $aSavePath, $aReferer, $aCookie, $iReturn = 2
$aURL = StringRegExp($sCURL, '\h+--url\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then
$iURL = $aURL[1]
Else
$aURL = StringRegExp($sCURL, '(?i)(?![''"])\h+(?![''"])((?:https?|ftp)://[^\s]+|localhost:?\d+?)(?:\h|$)', 1)
If @error Then
$aURL = StringRegExp($sCURL, '(?i)\h+["'']((?:https?|ftp)://[^\s]+|localhost:?\d+?)["''](?:\h+|$)', 1)
If @error Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_ParseCURL', 'Không thể parse URL từ chuỗi CURL đã nạp vào'), '')
EndIf
$iURL = $aURL[0]
EndIf
$aHeaders = StringRegExp($sCURL, '(?:--header|-H)\h+([''"])(.+?(?!\\))\1', 3)
If Not @error Then
For $i = 1 To UBound($aHeaders) - 1 Step 2
$iHeaders &= $aHeaders[$i] &($i < UBound($aHeaders) - 1 ? '|' : '')
Next
EndIf
If StringRegExp($sCURL, '\h+-k(\h+|$)') Then $iHeaders &= '|Upgrade-Insecure-Requests: 1'
If StringRegExp($sCURL, '\h+(-I|--head)(\h+|$)') Then
$iMethod = 'HEAD'
ElseIf StringRegExp($sCURL, '\h+-T(\h+|$)') Then
$iMethod = 'PUT'
EndIf
If StringRegExp($sCURL, '\h+-i(\h+|$)') Then $iReturn = 1
$aData = StringRegExp($sCURL, '(?:--data(?:-urlencode|-ascii|-binary)?|-d)\h+([''"])(.+?(?!\\))\1(?:\h|$)', 3)
If Not @error Then
For $i = 1 To UBound($aData) - 1 Step 2
$iData &= $aData[$i] &($i < UBound($aData) - 1 ? '&' : '')
Next
$iMethod = 'POST'
Else
$aData = StringRegExp($sCURL, '(?:--form|-F)\h+([''"])(.+?(?!\\))\1(?:\h|$)', 3)
If Not @error Then
Local $iData[UBound($aData) / 2], $iCount = 0
For $i = 1 To UBound($aData) - 1 Step 2
$iData[$iCount] = $aData[$i]
$iCount += 1
Next
$iMethod = 'POST'
EndIf
EndIf
$aMethod = StringRegExp($sCURL, '\h+(?:--request|-X)\h+(GET|POST|PUT|HEAD|DELETE|CONNECT|OPTIONS|TRACE|PATCH)(?:\h|$)', 1)
If Not @error Then $iMethod = $aMethod[0]
$aUserAgent = StringRegExp($sCURL, '\h+(?:--user-agent|-A)\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then $iHeaders =($iHeaders ? '|' : '') & 'User-Agent: ' & $aUserAgent[1]
$aReferer = StringRegExp($sCURL, '\h+(?:--referer|-e)\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then $iReferer = $aReferer[1]
$aAuth = StringRegExp($sCURL, '\h+(?:--user|-u)\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then $iAuth = $aAuth[1]
$aProxy = StringRegExp($sCURL, '\h+(?:--proxy|-x)\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then $iProxy = $aProxy[1]
$aCookie = StringRegExp($sCURL, '\h+(?:--cookie|-b)\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then $iCookie = $aCookie[1]
If Not StringInStr($iCookie, '=', 1, 1) And FileExists($iCookie) Then $iCookie = FileRead($iCookie)
$aSavePath = StringRegExp($sCURL, '\h+(?:--remote-name|-o)\h+([''"])?(.+?(?!\\))\1?(?:\h|$)', 1)
If Not @error Then $iSavePath = $aSavePath[1]
If $iAuth Then $iAuthBK = _HttpRequest_SetAuthorization($iAuth)
Local $vData = _HttpRequest($iReturn &($iProxy ? '|%' & $iProxy : '') &($iSavePath ? '|$' & $iSavePath : ''), $iURL, $iData, $iCookie, $iReferer, $iHeaders, $iMethod)
Local $vError = @error, $vExtended = @extended
If $iAuth Then _HttpRequest_SetAuthorization($iAuthBK)
Return SetError($vError, $vExtended, $vData)
EndFunc
Func __FTP_MakeQWord($iLoDWORD, $iHiDWORD)
Local $tInt64 = DllStructCreate("uint64")
Local $tDwords = DllStructCreate("dword;dword", DllStructGetPtr($tInt64))
DllStructSetData($tDwords, 1, $iLoDWORD)
DllStructSetData($tDwords, 2, $iHiDWORD)
Return DllStructGetData($tInt64, 1)
EndFunc
Func _FTP_Open2($sAgent, $iAccessType, $sProxyName = '', $sProxyBypass = '', $iFlags = 0)
Local $ai_InternetOpen = DllCall($dll_WinInet, 'handle', 'InternetOpenW', 'wstr', $sAgent, 'dword', $iAccessType, 'wstr', $sProxyName, 'wstr', $sProxyBypass, 'dword', $iFlags)
If @error Or $ai_InternetOpen[0] = 0 Then Return SetError(1)
Return $ai_InternetOpen[0]
EndFunc
Func _FTP_Connect2($hInternetSession, $sServerName, $sUserName, $sPassword, $iServerPort = 0)
Local $ai_InternetConnect = DllCall($dll_WinInet, 'hwnd', 'InternetConnectW', 'handle', $hInternetSession, 'wstr', $sServerName, 'ushort', $iServerPort, 'wstr', $sUserName, 'wstr', $sPassword, 'dword', 1, 'dword', 2, 'dword_ptr', 0)
If @error Or $ai_InternetConnect[0] = 0 Then Return SetError(1)
Return $ai_InternetConnect[0]
EndFunc
Func _FTP_CloseHandle2($hSession)
DllCall($dll_WinInet, 'bool', 'InternetCloseHandle', 'handle', $hSession)
EndFunc
Func _FTP_FileReadEx($hFTPConnect, $sRemoteFile, $CallBackFunc_Progress = '', $iBytesPerLoop = $g___BytesPerLoop)
Local $ai_FtpOpenfile = DllCall($dll_WinInet, 'handle', 'FtpOpenFileW', 'handle', $hFTPConnect, 'wstr', $sRemoteFile, 'dword', 0x80000000, 'dword', 2, 'dword_ptr', 0)
If @error Or $ai_FtpOpenfile[0] == 0 Then Return SetError(1, '', '')
Local $tBuffer = DllStructCreate("byte[" & $iBytesPerLoop & "]")
Local $vBinaryData = Binary(''), $vNowSizeBytes = 1, $vTotalSizeBytes = -1, $iCheckCallbackFunc = 0, $aCall
If $CallBackFunc_Progress <> '' Then
$iCheckCallbackFunc = 1
Local $ai_hSize = DllCall($dll_WinInet, 'dword', 'FtpGetFileSize', 'handle', $ai_FtpOpenfile[0], 'dword*', 0)
If @error Or $ai_hSize[0] = 0 Then Return SetError(103, __HttpRequest_ErrNotify('_FTP_FileReadEx', 'Không thể lấy được kích cỡ tập tin'), 0)
$vTotalSizeBytes = __FTP_MakeQWord($ai_hSize[0], $ai_hSize[2])
If $vTotalSizeBytes > 2147483647 Then Return SetError(102, __HttpRequest_ErrNotify('_FTP_FileReadEx', 'Tập tin quá lớn'), 0)
EndIf
For $i = 1 To 2147483647
If $g___swCancelReadWrite Then
$g___swCancelReadWrite = False
Return SetError(997, __HttpRequest_ErrNotify('_FTP_FileReadEx', 'Đã huỷ request'), 0)
EndIf
$aCall = DllCall($dll_WinInet, 'bool', 'InternetReadFile', 'handle', $ai_FtpOpenfile[0], 'struct*', $tBuffer, 'dword', $iBytesPerLoop, 'dword*', 0)
If @error Or $aCall[0] = 0 Or($aCall[0] = 1 And $aCall[4] = 0) Then ExitLoop
If $aCall[4] < $iBytesPerLoop Then
$vBinaryData &= BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4])
Else
$vBinaryData &= DllStructGetData($tBuffer, 1)
EndIf
$vNowSizeBytes += $aCall[4]
If $iCheckCallbackFunc Then $CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
Next
DllCall($dll_WinInet, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
Return $vBinaryData
EndFunc
Func _FTP_FileWriteEx($hFTPConnect, $sRemoteFile, $iData, $CallBackFunc_Progress = '', $iBytesPerLoop = $g___BytesPerLoop)
Local $ai_FtpOpenfile = DllCall($dll_WinInet, 'handle', 'FtpOpenFileW', 'handle', $hFTPConnect, 'wstr', $sRemoteFile, 'dword', 0x40000000, 'dword', 2, 'dword_ptr', 0)
If @error Or $ai_FtpOpenfile[0] = 0 Then Return SetError(1, '', '')
If Not IsBinary($iData) Then $iData = StringToBinary($iData, 4)
Local $vNowSizeBytes = 1, $vTotalSizeBytes = -1, $iCheckCallbackFunc = 0
Local $iDataMid, $iDataMidLen, $tBuffer, $aCall
If $CallBackFunc_Progress <> '' Then
$iCheckCallbackFunc = 1
$vTotalSizeBytes = BinaryLen($iData)
If $vTotalSizeBytes > 2147483647 Then Return SetError(101, __HttpRequest_ErrNotify('_FTP_FileWriteEx', 'Tập tin quá lớn'), 0)
EndIf
For $i = 1 To 2147483647
If $g___swCancelReadWrite Then
$g___swCancelReadWrite = False
Return SetError(996, __HttpRequest_ErrNotify('_FTP_FileWriteEx', 'Đã huỷ request'), 0)
EndIf
$iDataMid = BinaryMid($iData, $vNowSizeBytes, $iBytesPerLoop)
$iDataMidLen = BinaryLen($iDataMid)
If Not $iDataMidLen Then ExitLoop
$tBuffer = DllStructCreate("byte[" &($iDataMidLen + 1) & "]")
DllStructSetData($tBuffer, 1, $iDataMid)
$aCall = DllCall($dll_WinInet, 'bool', 'InternetWriteFile', 'handle', $ai_FtpOpenfile[0], 'struct*', $tBuffer, 'dword', $iDataMidLen, 'dword*', 0)
If @error Or $aCall[0] = 0 Then ExitLoop
$vNowSizeBytes += $iDataMidLen
If $iCheckCallbackFunc Then $CallBackFunc_Progress($vNowSizeBytes, $vTotalSizeBytes)
Next
DllCall($dll_WinInet, 'bool', 'InternetCloseHandle', 'handle', $ai_FtpOpenfile[0])
Return 1
EndFunc
Func _FTP_DirCreate2($hFTPConnect, $sRemoteDirPath)
Local $ai_FTPMakeDir = DllCall($dll_WinInet, 'bool', 'FtpCreateDirectoryW', 'handle', $hFTPConnect, 'wstr', $sRemoteDirPath)
If @error Or $ai_FTPMakeDir[0] = 0 Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _FTP_DirSetCurrent2($hFTPConnect, $sRemoteDirPath)
Local $ai_FTPSetCurrentDir = DllCall($dll_WinInet, 'bool', 'FtpSetCurrentDirectoryW', 'handle', $hFTPConnect, 'wstr', $sRemoteDirPath)
If @error Or $ai_FTPSetCurrentDir[0] = 0 Then Return SetError(1, 0, 0)
Return 1
EndFunc
Func _FTP_ListToArray2($hFTPConnect, $iReturnType = 0)
Local $asFileArray[1][3], $aDirectoryArray[1][3] = [[0, 'Size', 'Type']]
If $iReturnType < 0 Or $iReturnType > 2 Then Return SetError(1, 0, $asFileArray)
Local $tWIN32_FIND_DATA = DllStructCreate("DWORD dwFileAttributes; dword ftCreationTime[2]; dword ftLastAccessTime[2]; dword ftLastWriteTime[2]; DWORD nFileSizeHigh; DWORD nFileSizeLow; dword dwReserved0; dword dwReserved1; WCHAR cFileName[260]; WCHAR cAlternateFileName[14];")
Local $aCallFindFirst = DllCall($dll_WinInet, 'handle', 'FtpFindFirstFileW', 'handle', $hFTPConnect, 'wstr', "", 'struct*', $tWIN32_FIND_DATA, 'dword', 0x04000000, 'dword_ptr', 0)
If @error Or Not $aCallFindFirst[0] Then Return SetError(2, 0, '')
Local $iDirectoryIndex = 0, $sFileIndex = 0, $bIsDir, $aCallFindNext
Do
$bIsDir = BitAND(DllStructGetData($tWIN32_FIND_DATA, "dwFileAttributes"), $FILE_ATTRIBUTE_DIRECTORY) = $FILE_ATTRIBUTE_DIRECTORY
If $bIsDir And($iReturnType <> 2) Then
$iDirectoryIndex += 1
If UBound($aDirectoryArray) < $iDirectoryIndex + 1 Then ReDim $aDirectoryArray[$iDirectoryIndex * 2][3]
$aDirectoryArray[$iDirectoryIndex][0] = DllStructGetData($tWIN32_FIND_DATA, "cFileName")
$aDirectoryArray[$iDirectoryIndex][1] = __FTP_MakeQWord(DllStructGetData($tWIN32_FIND_DATA, "nFileSizeLow"), DllStructGetData($tWIN32_FIND_DATA, "nFileSizeHigh"))
$aDirectoryArray[$iDirectoryIndex][2] = 'Folder'
ElseIf Not $bIsDir And $iReturnType <> 1 Then
$sFileIndex += 1
If UBound($asFileArray) < $sFileIndex + 1 Then ReDim $asFileArray[$sFileIndex * 2][3]
$asFileArray[$sFileIndex][0] = DllStructGetData($tWIN32_FIND_DATA, "cFileName")
$asFileArray[$sFileIndex][1] = __FTP_MakeQWord(DllStructGetData($tWIN32_FIND_DATA, "nFileSizeLow"), DllStructGetData($tWIN32_FIND_DATA, "nFileSizeHigh"))
$asFileArray[$sFileIndex][2] = 'File'
EndIf
$aCallFindNext = DllCall($dll_WinInet, 'bool', 'InternetFindNextFileW', 'handle', $aCallFindFirst[0], 'struct*', $tWIN32_FIND_DATA)
If @error Then Return SetError(3, DllCall($dll_WinInet, 'bool', 'InternetCloseHandle', 'handle', $aCallFindFirst[0]), '')
Until Not $aCallFindNext[0]
DllCall($dll_WinInet, 'bool', 'InternetCloseHandle', 'handle', $aCallFindFirst[0])
$aDirectoryArray[0][0] = $iDirectoryIndex
$asFileArray[0][0] = $sFileIndex
Switch $iReturnType
Case 0
ReDim $aDirectoryArray[$aDirectoryArray[0][0] + $asFileArray[0][0] + 1][3]
For $i = 1 To $sFileIndex
For $j = 0 To 2
$aDirectoryArray[$aDirectoryArray[0][0] + $i][$j] = $asFileArray[$i][$j]
Next
Next
$aDirectoryArray[0][0] += $asFileArray[0][0]
Return $aDirectoryArray
Case 1
ReDim $aDirectoryArray[$iDirectoryIndex + 1][3]
Return $aDirectoryArray
Case 2
ReDim $asFileArray[$sFileIndex + 1][3]
Return $asFileArray
EndSwitch
EndFunc
Func _FtpRequest($aRetMode, $aURL, $sData2Send, $CallBackFunc_Progress)
If Not $dll_WinInet Then
$dll_WinInet = DllOpen('wininet.dll')
If @error Then Return SetError(1, __HttpRequest_ErrNotify('_FtpRequest', 'Gọi wininet.dll thất bại'), '')
EndIf
If Not IsArray($aRetMode) Then
$aRetMode = __HttpRequest_iReturnSplit($aRetMode)
If @error Then Return SetError(2, 0, '')
$g___LastSession = $aRetMode[8]
EndIf
If Not IsArray($aURL) Then
$aURL = __HttpRequest_URLSplit($aURL)
If @error Then Return SetError(3, 0, '')
EndIf
Local $iError = 0, $ReData, $iProxy = '', $iAccessType = 1, $iProxyBypass = ''
If $aRetMode[5] Then
$iProxy = $aRetMode[5]
$iAccessType = 3
ElseIf $g___hProxy[$g___LastSession][0] Then
$iProxy = $g___hProxy[$g___LastSession][0]
$iProxyBypass = $g___hProxy[$g___LastSession][2]
$iAccessType = 3
EndIf
If Not $g___ftpOpen[$g___LastSession] Then $g___ftpOpen[$g___LastSession] = _FTP_Open2($g___UserAgent[$g___LastSession], $iAccessType, $iProxy, $iProxyBypass)
$g___ftpConnect[$g___LastSession] = _FTP_Connect2($g___ftpOpen[$g___LastSession], $aURL[2], $aURL[4], $aURL[5], $aURL[1])
Local $sFileName = '', $sDirPath = ''
Switch $aURL[3]
Case '/', ''
$aRetMode[0] = 1
Case Else
Local $aRemotePath = StringSplit($aURL[3], '/')
If StringRegExp($aRemotePath[$aRemotePath[0]], '^[^\.]+\.\w+$') Then
$sFileName = $aRemotePath[$aRemotePath[0]]
EndIf
If $aRemotePath[0] > 1 Then
If _FTP_DirSetCurrent2($g___ftpConnect[$g___LastSession], '/') = 1 Then
For $i = 1 To $aRemotePath[0] -($sFileName ? 1 : 0)
If $aRemotePath[$i] == '' Then
If $i = 1 Then
ContinueLoop
Else
$iError = 4
ExitLoop
EndIf
EndIf
If _FTP_DirSetCurrent2($g___ftpConnect[$g___LastSession], $aRemotePath[$i]) = 0 Then
If _FTP_DirCreate2($g___ftpConnect[$g___LastSession], $aRemotePath[$i]) = 0 Then
$iError = 5
ExitLoop
Else
If _FTP_DirSetCurrent2($g___ftpConnect[$g___LastSession], $aRemotePath[$i]) = 0 Then
$iError = 6
ExitLoop
EndIf
EndIf
EndIf
Next
Else
$iError = 7
EndIf
EndIf
EndSwitch
If $iError = 0 Then
Select
Case $aRetMode[0] = 0 And $sData2Send == ''
Case $aRetMode[0] = 1 And $sData2Send == ''
$ReData = _FTP_ListToArray2($g___ftpConnect[$g___LastSession])
If @error Then $iError = 8
Case Else
If $sFileName Then
If $sData2Send Then
If StringRegExp($sData2Send, '(?i)^[A-Z]:\\') And FileExists($sData2Send) Then
$sData2Send = _GetFileInfo($sData2Send, 0)
If @error Then
$iError = 9
Else
$sData2Send = $sData2Send[2]
EndIf
EndIf
If $iError = 0 Then
_FTP_FileWriteEx($g___ftpConnect[$g___LastSession], $sFileName, $sData2Send, $CallBackFunc_Progress)
If @error Then $iError = 10
If $aRetMode[0] = 1 Then
$ReData = _FTP_ListToArray2($g___ftpConnect[$g___LastSession])
If @error Then $iError = 12
EndIf
EndIf
Else
$ReData = _FTP_FileReadEx($g___ftpConnect[$g___LastSession], $sFileName, $CallBackFunc_Progress)
If @error Then
$iError = 11
Else
If $aRetMode[0] = 2 Then $ReData = BinaryToString($ReData, 4)
EndIf
EndIf
EndIf
EndSelect
EndIf
Return SetError($iError, $iError ? __HttpRequest_ErrNotify('_FtpRequest', 'FTP request thất bại với $iError=' & $iError) : 0, $ReData)
EndFunc
Func _WinHttpWebSocketRequest($sData2Send)
$g___hWebSocket[$g___LastSession] = _WinHttpWebSocketCompleteUpgrade2($g___hRequest[$g___LastSession])
If Not $g___hWebSocket[$g___LastSession] Then Return SetError(114, __HttpRequest_ErrNotify('_WinHttpWebSocketRequest', 'WebSocket mở thất bại', -1), '')
_HttpRequest_ConsoleWrite('> [#' & $g___LastSession & '] WebSocket mở thành công' & @CRLF)
If $sData2Send Then
Local $iError = _WinHttpWebSocketSend2($g___hWebSocket[$g___LastSession], $sData2Send)
If @error Or $iError <> 0 Then Return SetError(115, __HttpRequest_ErrNotify('_WinHttpWebSocketRequest', 'WebSocket gửi dữ liệu thất bại', 101, 'Warning'), '')
_HttpRequest_ConsoleWrite('> [#' & $g___LastSession & '] WebSocket gửi dữ liệu thành công' & @CRLF)
EndIf
EndFunc
Func _WinHttpWebSocketCompleteUpgrade2($hRequest, $pContext = 0)
Local $aCall = DllCall($dll_WinHttp, "handle", "WinHttpWebSocketCompleteUpgrade", "handle", $hRequest, "dword_ptr", $pContext)
If @error Then Return SetError(@error, @extended, -1)
Return $aCall[0]
EndFunc
Func _WinHttpWebSocketSend2($hWebSocket, $vData, $iBufferType = 0)
Local $tBuffer = 0, $iBufferLen = 0
If Not IsBinary($vData) Then $vData = StringToBinary($vData, 4)
$iBufferLen = BinaryLen($vData)
If $iBufferLen > 0 Then
$tBuffer = DllStructCreate("byte[" & $iBufferLen & "]")
DllStructSetData($tBuffer, 1, $vData)
EndIf
Local $aCall = DllCall($dll_WinHttp, 'dword', "WinHttpWebSocketSend", "handle", $hWebSocket, "int", $iBufferType, "ptr", DllStructGetPtr($tBuffer), 'dword', $iBufferLen)
If @error Then Return SetError(@error, @extended, -1)
Return $aCall[0]
EndFunc
Func _WinHttpWebSocketClose2($hWebSocket, $iStatus = Default, $tReason = 0)
If $iStatus = Default Then $iStatus = 1000
Local $aCall = DllCall($dll_WinHttp, "handle", "WinHttpWebSocketClose", "handle", $hWebSocket, "ushort", $iStatus, "ptr", DllStructGetPtr($tReason), 'dword', DllStructGetSize($tReason))
EndFunc
Func __IE_Init_GoogleBox($sUser, $sPassword, $sURL = Default, $vFuncCallback = '', $vDebug = False, $vTimeOut = Default)
$sUser = StringRegExpReplace($sUser, '(?i)@gmail.com[\.\w]*?$', '', 1)
If $sURL = Default Then $sURL = ''
Local $sHTML = _HttpRequest(2, 'https://accounts.google.com/ServiceLogin?hl=en&passive=true&continue=' & _URIEncode($sURL), '', '', '', 'User-Agent: ' & $g___defUserAgent)
If @error Or $sHTML = '' Then Return SetError(-1, __HttpRequest_ErrNotify('_GoogleBox', 'Request đến trang đăng nhập thất bại'), '')
$sHTML = StringRegExpReplace($sHTML, '(?i)(<input.*?\h+?id="Email".*?\h+?value=")(")', '$1' & $sUser & '$2', 1)
$sHTML = StringReplace($sHTML, '<body', '<body onLoad="document.getElementById(''next'').click();"', 1, 1)
Local $oIE = ObjCreate("Shell.Explorer.2")
If Not IsObj($oIE) Then Return SetError(-2, __HttpRequest_ErrNotify('_GoogleBox', 'Không thể tạo IE Object'), '')
If $vTimeOut = Default Then $vTimeOut = 20000
If $vTimeOut < 10000 Then $vTimeOut = 10000
Local $vReturn = '', $vError = 0, $_oid_Pass, $_old_Locate
Local $GUI_EmbededGG = GUICreate("Google Box", 800, 600)
GUICtrlCreateObj($oIE, 0, 0, 800, 600)
If $vDebug Then GUISetState()
With $oIE
.navigate('about:blank')
Local $sTimer = TimerInit()
While .busy()
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(GUIDelete($GUI_EmbededGG) * -3, __HttpRequest_ErrNotify('_GoogleBox', 'TimeOut #1'), '')
Sleep(40)
WEnd
.document.write($sHTML)
.document.close()
_HttpRequest_ConsoleWrite('> [Google Login] Đang cài đặt Tài khoản ...')
For $i = 1 To 2
$sTimer = TimerInit()
Do
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(GUIDelete($GUI_EmbededGG) * -4, 0 * ConsoleWrite(@CRLF) + __HttpRequest_ErrNotify('_GoogleBox', 'TimeOut #2'), '')
$_oid_Pass = .document.getElementById('Passwd')
Sleep(40)
If $i = 1 Then ConsoleWrite('..')
Until IsObj($_oid_Pass)
$_oid_Pass.value = $sPassword
$_old_Locate = .locationName()
If $i = 1 Then
ConsoleWrite(' (' & Int(TimerDiff($sTimer)) & 'ms)' & @CRLF)
.document.getElementById('signIn').click()
EndIf
_HttpRequest_ConsoleWrite('> [Google Login] ' &($i = 1 ? 'Đang chuyển hướng tới địa chỉ đích ...' : 'Đang chờ giải Captcha'))
$sTimer = TimerInit()
Do
If TimerDiff($sTimer) > $vTimeOut * $i Then
ConsoleWrite(@CRLF)
Return SetError(GUIDelete($GUI_EmbededGG) * -5, 0 * ConsoleWrite(@CRLF) + __HttpRequest_ErrNotify('_GoogleBox', 'TimeOut #3'), '')
EndIf
Sleep(40)
ConsoleWrite('..')
Until .locationName() <> $_old_Locate
ConsoleWrite(' (' & Int(TimerDiff($sTimer)) & 'ms)' & @CRLF & @CRLF)
If Not StringRegExp(.document.body.innerHtml, '(?i)<div class="?captcha-box"?>') Then ExitLoop
_HttpRequest_ConsoleWrite('> [Google Login] Phát hiện Captcha' & @CRLF)
GUISetState()
Next
If $vFuncCallback Then
Local $aFuncCallback = StringSplit($vFuncCallback, '|')
Local $sFuncCallbackName = $aFuncCallback[1]
$aFuncCallback[0] = 'CallArgArray'
$aFuncCallback[1] = $oIE
$vReturn = Call($sFuncCallbackName, $aFuncCallback)
$vError = @error
EndIf
EndWith
If $vDebug Then
While GUIGetMsg() <> -3
Sleep(35)
WEnd
EndIf
Return SetError($vError * GUIDelete($GUI_EmbededGG), '', $vReturn)
EndFunc
Func __IE_Init_RecaptchaBox($sURL, $vAdvancedMode, $hGUI, $___GUI_Offset, $Custom_RegExp_GetDataSiteKey, $vTimeOut)
Local $oIE = ObjCreate("Shell.Explorer.2")
If Not IsObj($oIE) Then Return SetError(1, __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Không thể tạo IE Object'), '')
Local $sReCaptchaResponse = '', $iError = 0, $sDataSiteKey = '', $isInvisible = 0
GUICtrlSetDefBkColor(0x222222, $hGUI)
GUICtrlSetDefColor(0xFFFFFF, $hGUI)
GUISetFont(10, 600)
GUICtrlCreateLabel('ReCaptcha Box', 2, 2, 400 - 22, 22, 0x201, 0x100000)
Local $__idCloseButton = GUICtrlCreateLabel('X', 380, 2, 22, 22, 0x201)
GUICtrlSetBkColor(-1, 0xFF0011)
Local $__idGGLoginButton = GUICtrlCreateLabel('Google Login', 2, 606, 100, 22, 0x201)
GUICtrlSetBkColor(-1, 0x0099FF)
Local $__idAudioButton = GUICtrlCreateLabel('Audio', 104, 606, 49, 22, 0x201)
GUICtrlSetBkColor(-1, 0x0099FF)
Local $__idRefreshButton = GUICtrlCreateLabel('Refresh', 343, 606, 59, 22, 0x201)
GUICtrlSetBkColor(-1, 0x0099FF)
GUICtrlCreateObj($oIE, 2, 25, 400, 580)
With $oIE
.navigate($sURL)
TrayTip('ReCaptcha', 'Đang tải thông tin Recaptcha...', 0)
_HttpRequest_ConsoleWrite('> [reCAPTCHA] Đang tải trang ...')
Local $sTimer = TimerInit()
While .busy()
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(2, 0 * ConsoleWrite(@CRLF) + __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'TimeOut #1'), '')
Sleep(100)
ConsoleWrite('..')
WEnd
ConsoleWrite(' (' & Int(TimerDiff($sTimer)) & 'ms)' & @CRLF)
$sTimer = TimerInit()
Local $sPageTitle = .document.title
Local $sourceHtml = .document.body.innerHTML
If $Custom_RegExp_GetDataSiteKey Then
If StringRegExp($Custom_RegExp_GetDataSiteKey, '^[\w\-]+$') Then
$sDataSiteKey = $Custom_RegExp_GetDataSiteKey
Else
$sDataSiteKey = StringRegExp($Custom_RegExp_GetDataSiteKey, '(?i)["'']?siteKey[''"]?\s*?:\s*?[''"](.*?)[''"]', 1)
If Not @error And $sDataSiteKey[0] Then
$sDataSiteKey = $sDataSiteKey[0]
$isInvisible =(StringInStr($Custom_RegExp_GetDataSiteKey, 'invisible', 0, 1) > 0)
Else
$sDataSiteKey = ''
EndIf
EndIf
EndIf
If $sDataSiteKey == '' Then
Local $oiFrames = .document.GetElementsByTagName("iframe")
If @error Then
$iError = 1
Else
For $oiFrame In $oiFrames
$sDataSiteKey = StringRegExp($oiFrame.src, '(?i)^https://www.google.com/recaptcha/api2/.*?\&?k=([^\&]+)', 1)
If Not @error And $sDataSiteKey[0] Then
$sDataSiteKey = $sDataSiteKey[0]
$isInvisible =(StringInStr($oiFrame.src, 'size=invisible', 0, 1) > 0)
ExitLoop
Else
$sDataSiteKey = ''
EndIf
Next
EndIf
If $iError = 1 Or $sDataSiteKey == '' Then
If $sourceHtml = '' Then Return SetError(3, __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Đọc html thất bại'), '')
If $Custom_RegExp_GetDataSiteKey And $Custom_RegExp_GetDataSiteKey <> Default Then
Local $sDataSiteKey = StringRegExp($sourceHtml, $Custom_RegExp_GetDataSiteKey, 1)
If @error Then Return SetError(4, __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Không thể lấy data-sitekey #1'), '')
Else
Local $sDataSiteKey = StringRegExp($sourceHtml, '(?im)data-sitekey\h*?=\h*?["'']([\w\-]{20,})["'']', 1)
If @error Then $sDataSiteKey = StringRegExp($sourceHtml, '(?i)(?:\?|&amp;|&|;)k=([\w\-]{20,})(?:"|&amp;|&|;|''|$)', 1)
If @error Then $sDataSiteKey = StringRegExp($sourceHtml, '(?i)reCAPTCHA[^=]+=\h*?[''"]([\w\-]{20,})[''"]', 1)
If @error Then $sDataSiteKey = StringRegExp($sourceHtml, '(?i)["'']reCAPTCHA_?site_?key["'']\h*?:\h*?["'']([\w\-]{20,})["'']', 1)
If @error Then Return SetError(5, __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Không thể lấy data-sitekey #2 (Có thể sitekey nằm trong code js hoặc trang không chứa reCAPTCHA)'), '')
EndIf
$sDataSiteKey = $sDataSiteKey[0]
$isInvisible =(StringRegExp($sourceHtml, '(?i)data-sitekey="[^"]+" .*?data-size="invisible"|data-size="invisible" .*?data-sitekey="[^"]+"') > 0)
EndIf
EndIf
ConsoleWrite('> [reCAPTCHA] Data-SiteKey : ' & $sDataSiteKey & @CRLF)
Local $hIE = ControlGetHandle($hGUI, '', '[Classnn:Internet Explorer_Server1]')
ConsoleWrite('> [reCAPTCHA] Hwnd IE : ' & $hIE & @CRLF)
Local $sHTML = '<!DOCTYPE html>' & '<html>' & '<head>' & '	<title>' &($sPageTitle ? $sPageTitle : 'Google Recpatcha') & '</title>' & @CRLF & '	<base href="' & $sURL & '" />' & @CRLF & '	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />' & @CRLF & '	<script src="https://www.google.com/recaptcha/api.js?hl=vi&onload=onloadRecaptchaCallback&render=explicit" async defer></script>' & @CRLF & '</head>' & @CRLF & '<body bgcolor="#222222">#body#</body>' & @CRLF & '</html>'
If $isInvisible Then
Local $sBody = '<script src="https://www.google.com/recaptcha/api.js?hl=vi&onload=onloadCallback" async defer></script>' & @CRLF & '<script>var onloadCallback = function(){grecaptcha.execute()}</script>' & @CRLF & '<div style="padding: 50% 0" align="center" class="g-recaptcha" ' &($isInvisible ? 'data-size="invisible"' : '') & ' data-theme="dark" data-sitekey="' & $sDataSiteKey & '"></div>'
Else
Local $sBody = '<script src="https://www.google.com/recaptcha/api.js?hl=vi&onload=onloadCallback&render=explicit" async defer></script>' & @CRLF & '<script>var onloadCallback=function(){grecaptcha.render("gcaptcha",{sitekey:"' & $sDataSiteKey & '", theme:"dark", callback:function(t){$("#link-view .btn-captcha").removeAttr("disabled")}});}</script>' & @CRLF & '<div id="gcaptcha" style="padding: 50% 0" align="center"></div>'
EndIf
.document.write(StringReplace($sHTML, '#body#', @CRLF & $sBody & @CRLF, 1, 1))
.document.close()
_HttpRequest_ConsoleWrite('> [reCAPTCHA] Đang khởi tạo ReCaptcha ...')
While .busy()
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(6, 0 * ConsoleWrite(@CRLF) + __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'TimeOut #2'), '')
Sleep(100)
ConsoleWrite('..')
WEnd
ConsoleWrite(' (' & Int(TimerDiff($sTimer)) & 'ms)' & @CRLF)
$sTimer = TimerInit()
Local $oReCaptchaResponse
Do
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(7 + 0 * TrayTip('', '', 1), __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'TimeOut #3'), '')
Sleep(Random(500, 1500, 1))
$oReCaptchaResponse = .document.getElementById("g-recaptcha-response")
Until IsObj($oReCaptchaResponse)
If $isInvisible And $oReCaptchaResponse.value Then
$sReCaptchaResponse = $oReCaptchaResponse.value
GUISetState(@SW_HIDE, $hGUI)
Else
GUISetState(@SW_SHOW, $hGUI)
TrayTip('', '', 1)
If Not $isInvisible Then
If $hIE Then
__IE_MouseClick($hIE, 80, 260 - 25)
Else
Local $aPosMouse = MouseGetPos()
MouseClick('left', 80, 260, 1, 0)
MouseMove($aPosMouse[0], $aPosMouse[1], 0)
Sleep(Random(1000, 2000, 1))
EndIf
EndIf
_GDIPlus_Startup()
Local $vGDI_Startup_Error = @error
Local $___aMouseInfo, $___aMouseInfo_Old, $___aPosCurMem, $vClickDrag = False, $iTimerClickDrag
If Not $dll_Gdi32 Then
$dll_Gdi32 = DllOpen('gdi32.dll')
If @error Then $vGDI_Startup_Error = 1
EndIf
Do
Sleep(10)
Switch GUIGetMsg()
Case $__idGGLoginButton
GUICtrlSetData($__idGGLoginButton, 'Hoàn tất')
GUICtrlSetBkColor($__idGGLoginButton, 0xFF0011)
$sTimer = TimerInit()
Local $lSuccess = 1
_HttpRequest_ConsoleWrite('> [reCAPTCHA] Đang chuyển trang đăng nhập Google ...')
.navigate('https://accounts.google.com/ServiceLogin?hl=en&passive=true&continue=')
While .busy()
If TimerDiff($sTimer) > $vTimeOut Then
$lSuccess = 0
GUICtrlSetData($__idGGLoginButton, 'Google Login')
GUICtrlSetBkColor($__idGGLoginButton, 0x0099FF)
ExitLoop(1 + 0 * ConsoleWrite(@CRLF) * __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Không thể truy cập trang đăng nhập Google'))
EndIf
Sleep(100)
ConsoleWrite('..')
WEnd
If $lSuccess Then
While Sleep(20)
Switch GUIGetMsg()
Case $__idCloseButton
Return SetError(8, __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Đã huỷ việc giải Captcha'), '')
Case $__idGGLoginButton
ExitLoop
EndSwitch
WEnd
EndIf
GUICtrlSetData($__idGGLoginButton, 'Google Login')
GUICtrlSetBkColor($__idGGLoginButton, 0x0099FF)
.document.write(StringReplace($sHTML, '#body#', @CRLF & $sBody & @CRLF, 1, 1))
.document.close()
$sTimer = TimerInit()
Do
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(9 + 0 * TrayTip('', '', 1), __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'TimeOut #4'), '')
Sleep(Random(500, 1500, 1))
$oReCaptchaResponse = .document.getElementById("g-recaptcha-response")
Until IsObj($oReCaptchaResponse)
GUICtrlSetBkColor($__idRefreshButton, 0x0099FF)
__IE_MouseClick($hIE, 80, 260 - 25)
Case $__idCloseButton
Return SetError(6, __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'Đã huỷ việc giải Captcha'), '')
Case $__idAudioButton
GUICtrlSetBkColor($__idAudioButton, 0xFF0011)
Local $aCacheIE = _WinINet_CacheEntryInfoFind()
If @error Then ContinueLoop MsgBox(4096 + 16, 'Lỗi', 'Không thể kết nối IE Cache') * GUICtrlSetBkColor($__idAudioButton, 0x0099FF)
For $i = 0 To @extended - 1
If StringInStr(($aCacheIE[$i])[0], 'mms://www.google.com:443/recaptcha/api2/payload') Then ExitLoop
Next
If $i = UBound($aCacheIE) Then ContinueLoop MsgBox(4096 + 16, 'Lỗi', 'Không tìm thấy Recaptcha Audio trong IE Cache') * GUICtrlSetBkColor($__idAudioButton, 0x0099FF)
Local $sText = _HttpRequest_Speech2Text(StringReplace(($aCacheIE[$i])[0], 'mms://www.google.com:443', 'https://www.google.com', 1, 1))
If Not @error And $sText Then
Local $hDC = _WinAPI_GetWindowDC($hGUI)
Local $iTAB = Int(__IE_MemoryReadPixel(86, 126, $hDC) <> '0xFFFFFF')
_WinAPI_ReleaseDC($hGUI, $hDC)
ClipPut($sText)
ControlSend($hGUI, '', '', '{TAB ' &(1 + $iTAB) & '}')
Local $aASCII = StringToASCIIArray($sText)
For $i = 0 To UBound($aASCII) - 1
ControlSend($hGUI, '', '', '{ASC ' & $aASCII[$i] & '}')
Sleep(Random(25, 75, 1))
Next
Sleep(100)
ControlSend($hGUI, '', '', '{TAB 5}')
ControlSend($hGUI, '', '', '{ENTER}')
Else
MsgBox(4096, 'Giải Audio thất bại', 'Vui lòng bấm nút Refesh và tải về Audio mới')
EndIf
GUICtrlSetBkColor($__idAudioButton, 0x0099FF)
For $i = 0 To UBound($aCacheIE) - 1
If StringInStr(($aCacheIE[$i])[0], 'mms://www.google.com:443/recaptcha/api2/payload') Then _WinINet_CacheEntryInfoDelete(($aCacheIE[$i])[1])
Next
Case $__idRefreshButton
GUICtrlSetBkColor($__idRefreshButton, 0xFF0011)
.document.execCommand("Refresh")
$sTimer = TimerInit()
Do
If TimerDiff($sTimer) > $vTimeOut Then Return SetError(10 + 0 * TrayTip('', '', 1), __HttpRequest_ErrNotify('__IE_Init_RecaptchaBox', 'TimeOut #5'), '')
Sleep(Random(500, 1500, 1))
$oReCaptchaResponse = .document.getElementById("g-recaptcha-response")
Until IsObj($oReCaptchaResponse)
GUICtrlSetBkColor($__idRefreshButton, 0x0099FF)
__IE_MouseClick($hIE, 80, 260 - 25)
Case -7, -9
$___aMouseInfo_Old = GUIGetCursorInfo($hGUI)
If @error Then ContinueLoop
$vClickDrag = True
$iTimerClickDrag = TimerInit()
While __IE_IsMousePressed(1)
If TimerDiff($iTimerClickDrag) > 120 Then
$iTimerClickDrag = TimerInit()
ContinueCase
EndIf
WEnd
Case -11
If $vClickDrag And $vGDI_Startup_Error = 0 Then
$___aPosCurMem = $___aMouseInfo_Old[0] & '|' & $___aMouseInfo_Old[1]
Select
Case __IE_IsMousePressed(1)
__IE_RecaptchaBox_GuiOnDrawLine($hGUI, $___GUI_Offset, 2, $___aPosCurMem, $___aMouseInfo, $___aMouseInfo_Old, 25, True)
__IE_RecaptchaBox_CalculateRectClick($hGUI, $hIE, $___aPosCurMem)
Case Else
$vClickDrag = False
EndSelect
EndIf
EndSwitch
$sReCaptchaResponse = $oReCaptchaResponse.value
Until $sReCaptchaResponse
EndIf
EndWith
If $vAdvancedMode Then
Local $aResponse = [$sReCaptchaResponse, _IE_GetCookie($sURL), $sourceHtml, $oIE.document.body.innerHTML]
Return $aResponse
Else
Return $sReCaptchaResponse
EndIf
EndFunc
Func __IE_IsMousePressed($sHexKey)
Local $aReturn = DllCall($dll_User32, "short", "GetAsyncKeyState", "int", $sHexKey)
If @error Then Return False
Return BitAND($aReturn[0], 0x8000) <> 0
EndFunc
Func __IE_MouseClick($hwnd, $x, $y, $speed = 0, $left_or_right = 'left')
$left_or_right =($left_or_right = 'left' ? 0x201 : 0x204)
Local $lParam = $y * 65536 + $x
DllCall($dll_User32, "bool", "PostMessage", "hwnd", $hwnd, "uint", $left_or_right, "wparam", $left_or_right = 0x201 ? 0x1 : 0x2, "lparam", $lParam)
DllCall($dll_User32, "bool", "PostMessage", "hwnd", $hwnd, "uint", $left_or_right + 1, "wparam", 0x0, "lparam", $lParam)
Sleep($speed)
EndFunc
Func __IE_RecaptchaBox_GuiOnDrawLine($hGUI, $___GUI_Offset, $iMouseEvent, ByRef $___aPosCurMem, $___aMouseInfo, $___aMouseInfo_Old, $iSizePen, $iEasyModeGUI = True)
Local $posGUI = WinGetPos($hGUI)
If $iEasyModeGUI Then
Local $___GDI_DrawGUI = GUICreate("HH Draw GUI", $posGUI[2], $posGUI[3], $___GUI_Offset, $___GUI_Offset, 0x80000000, 0x80000 + 0x40 + 0x8, $hGUI)
GUISetBkColor(0x123456, $___GDI_DrawGUI)
DllCall($dll_User32, "bool", "SetLayeredWindowAttributes", "hwnd", $___GDI_DrawGUI, "INT", 0x563412, "byte", 255, "dword", 0x3)
GUISetState(@SW_SHOW, $___GDI_DrawGUI)
Else
Local $___WinAPI_hDDC = _WinAPI_GetDC($hGUI)
Local $___WinAPI_hCDC = _WinAPI_CreateCompatibleDC($___WinAPI_hDDC)
Local $___GDI_hCloneGUI = _WinAPI_CreateCompatibleBitmap($___WinAPI_hDDC, $posGUI[2], $posGUI[3])
_WinAPI_SelectObject($___WinAPI_hCDC, $___GDI_hCloneGUI)
_WinAPI_BitBlt($___WinAPI_hCDC, 0, 0, $posGUI[2], $posGUI[3], $___WinAPI_hDDC, 0, 0, 0x00CC0020)
_WinAPI_ReleaseDC($hGUI, $___WinAPI_hDDC)
_WinAPI_DeleteDC($___WinAPI_hCDC)
Local $___GDI_DrawGUI = GUICreate("HH Draw GUI", $posGUI[2], $posGUI[3], $___GUI_Offset, $___GUI_Offset, 0x80000000, 0x40 + 0x8, $hGUI)
GUISetState(@SW_SHOW, $___GDI_DrawGUI)
Local $___GDI_hGraphic = _GDIPlus_GraphicsCreateFromHWND($___GDI_DrawGUI)
Local $___GDI_hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($___GDI_hCloneGUI)
_GDIPlus_GraphicsDrawImage($___GDI_hGraphic, $___GDI_hBitmap, 0, 0)
_GDIPlus_BitmapDispose($___GDI_hBitmap)
_WinAPI_DeleteObject($___GDI_hCloneGUI)
_GDIPlus_GraphicsDispose($___GDI_hGraphic)
EndIf
GUISetCursor(0, 1, $___GDI_DrawGUI)
Local $___WinAPI_hWDC = _WinAPI_GetWindowDC($___GDI_DrawGUI)
Local $___WinAPI_hPen = _WinAPI_CreatePen(0, $iSizePen, 0x1100FF)
Local $___WinAPI_oSelect = _WinAPI_SelectObject($___WinAPI_hWDC, $___WinAPI_hPen)
Local $___WinAPI_hPen2 = _WinAPI_CreatePen(0, $iSizePen * 2, 0)
Local $___WinAPI_oSelect2 = _WinAPI_SelectObject($___WinAPI_hWDC, $___WinAPI_hPen2)
_WinAPI_DrawLine($___WinAPI_hWDC, $___aMouseInfo_Old[0], $___aMouseInfo_Old[1], $___aMouseInfo_Old[0], $___aMouseInfo_Old[1])
_WinAPI_SelectObject($___WinAPI_hWDC, $___WinAPI_oSelect2)
_WinAPI_DeleteObject($___WinAPI_hPen2)
Local $VectorX, $VectorY, $a, $B
Do
$___aMouseInfo = GUIGetCursorInfo($___GDI_DrawGUI)
If @error Or Not IsArray($___aMouseInfo) Then ExitLoop
$VectorX = $___aMouseInfo[0] - $___aMouseInfo_Old[0]
$VectorY = $___aMouseInfo[1] - $___aMouseInfo_Old[1]
If Abs($VectorX) > 5 Or Abs($VectorY) > 5 Then
$a = $VectorY / $VectorX
$B = $___aMouseInfo[1] - $___aMouseInfo[0] * $a
If Abs($VectorY) > 50 Then
For $k = $___aMouseInfo_Old[1] To $___aMouseInfo[1] Step 10 *($___aMouseInfo_Old[1] > $___aMouseInfo[1] ? -1 : 1)
If $VectorX = 0 Then
$___aPosCurMem &= '|' & $___aMouseInfo[0] & '|' & $k
Else
$___aPosCurMem &= '|' &($k - $B) / $a & '|' & $k
EndIf
Next
ElseIf Abs($VectorX) > 50 Then
For $k = $___aMouseInfo_Old[0] To $___aMouseInfo[0] Step 10 *($___aMouseInfo_Old[0] > $___aMouseInfo[0] ? -1 : 1)
If $VectorY = 0 Then
$___aPosCurMem &= '|' & $k & '|' & $___aMouseInfo[1]
Else
$___aPosCurMem &= '|' & $k & '|' & $a * $k + $B
EndIf
Next
Else
$___aPosCurMem &= '|' & $___aMouseInfo[0] & '|' & $___aMouseInfo[1]
EndIf
_WinAPI_DrawLine($___WinAPI_hWDC, $___aMouseInfo[0], $___aMouseInfo[1], $___aMouseInfo_Old[0], $___aMouseInfo_Old[1])
$___aMouseInfo_Old = $___aMouseInfo
EndIf
Until $___aMouseInfo[$iMouseEvent] = 0
_WinAPI_SelectObject($___WinAPI_hWDC, $___WinAPI_oSelect)
_WinAPI_DeleteObject($___WinAPI_hPen)
_WinAPI_ReleaseDC(0, $___WinAPI_hWDC)
GUIDelete($___GDI_DrawGUI)
EndFunc
Func __IE_RecaptchaBox_CalculateRectClick($hGUI, $hIE, $___asPosCurMem, $iDefaultReCaptDimensions = 4, $___offsetClick = 7, $___speedClick = 30)
Local $aCaptcha_Measure = __IE_ReCaptchaBox_Measure($hGUI)
If @error Or Not IsArray($aCaptcha_Measure) Then
$aCaptcha_Measure = StringSplit($iDefaultReCaptDimensions = 3 ? '17,163,118,118,4,3,3,367' : '19,163,88,88,2,4,4,363', ',', 2)
EndIf
Local $___aClickCurMem[8][8], $eCoordX, $eCoordY
Local $__X_offsetClick = $aCaptcha_Measure[0] + $aCaptcha_Measure[2] / 2 - $___offsetClick
Local $__Y_offsetClick = $aCaptcha_Measure[1] + $aCaptcha_Measure[3] / 2 - $___offsetClick
$___asPosCurMem = StringSplit($___asPosCurMem, '|')
If $___asPosCurMem[0] < 2 Then Return SetError(1)
For $i = 1 To $___asPosCurMem[0] Step 2
$eCoordX = Floor(($___asPosCurMem[$i + 0] - $aCaptcha_Measure[0]) / $aCaptcha_Measure[2])
$eCoordY = Floor(($___asPosCurMem[$i + 1] - $aCaptcha_Measure[1]) / $aCaptcha_Measure[3])
If $eCoordX < 0 Or $eCoordX >= $aCaptcha_Measure[5] Or $eCoordY < 0 Or $eCoordY >= $aCaptcha_Measure[6] Or $___aClickCurMem[$eCoordX][$eCoordY] Then ContinueLoop
If $hIE Then
__IE_MouseClick($hIE, $__X_offsetClick + $aCaptcha_Measure[2] * $eCoordX, $__Y_offsetClick + $aCaptcha_Measure[3] * $eCoordY - 25, $___speedClick)
Else
MouseClick('left', $__X_offsetClick + $aCaptcha_Measure[2] * $eCoordX, $__Y_offsetClick + $aCaptcha_Measure[3] * $eCoordY, 1, $___speedClick)
EndIf
$___aClickCurMem[$eCoordX][$eCoordY] = 1
Next
EndFunc
Func __IE_ReCaptchaBox_Measure($hGUI)
Local $hDC = _WinAPI_GetWindowDC($hGUI)
If @error Then Return SetError(1, _WinAPI_ReleaseDC($hGUI, $hDC), 0)
Local $iW = 404, $x = 10, $y = 200, $iStep = 0
Local $iXCaptchaPiece = 0, $iYCaptchaPiece = 0, $iWCaptchaPiece = 0, $iHCaptchaPiece = 0, $iWCaptchaPic = 0, $iNumCaptchaPieceW = 0, $iNumCaptchaPieceH = 0, $iDistCaptchaPiece = 0
For $x = 0 To $iW Step 2
Select
Case $iStep = 0
If $x > 30 Then
Return SetError(2, 0, 0)
ElseIf __IE_MemoryReadPixel($x, $y, $hDC) <> '0xFFFFFF' Then
$iStep = 1
EndIf
Case $iStep = 1 And __IE_MemoryReadPixel($x, $y, $hDC) == '0xFFFFFF'
$iStep = 2
Case $iStep = 2 And __IE_MemoryReadPixel($x, $y, $hDC) <> '0xFFFFFF'
$iStep = 3
$iXCaptchaPiece = $x
$x += 50
Case $iStep = 3
If __IE_MemoryReadPixel($x, $y, $hDC) == '0xFFFFFF' Then
For $vertY = 180 To 220 Step 2
If __IE_MemoryReadPixel($x, $vertY, $hDC) <> '0xFFFFFF' Then ExitLoop
Next
If $vertY = 222 Then
$iWCaptchaPiece = $x - $iXCaptchaPiece
$iStep = 4
EndIf
EndIf
Case $iStep = 4
For $y = 180 To 0 Step -2
If __IE_MemoryReadPixel($x, $y, $hDC) == '0x4A90E2' Then
$iYCaptchaPiece = $y + 7
ExitLoop 2
EndIf
Next
EndSelect
Next
_WinAPI_ReleaseDC($hGUI, $hDC)
$iWCaptchaPic = $iW -($iXCaptchaPiece - 1) * 2
$iNumCaptchaPieceW = Floor($iWCaptchaPic / $iWCaptchaPiece)
$iNumCaptchaPieceH =($iNumCaptchaPieceW = 2 ? 4 : $iNumCaptchaPieceW)
$iDistCaptchaPiece = Floor(($iWCaptchaPic - $iNumCaptchaPieceW * $iWCaptchaPiece) / $iNumCaptchaPieceW)
$iHCaptchaPiece = Floor($iWCaptchaPic / $iNumCaptchaPieceH) - $iDistCaptchaPiece
Local $aRet = [$iXCaptchaPiece, $iYCaptchaPiece, $iWCaptchaPiece, $iHCaptchaPiece, $iDistCaptchaPiece, $iNumCaptchaPieceW, $iNumCaptchaPieceH, $iWCaptchaPic]
Return $aRet
EndFunc
Func __IE_MemoryReadPixel($__x, $__y, $hDC)
Return BinaryMid(Binary(DllCall($dll_Gdi32, "int", "GetPixel", "int", $hDC, "int", $__x, "int", $__y)[0]), 1, 3)
EndFunc
Func _WinINet_CacheEntryInfoFind($iCacheEntryType = 0)
If Not $dll_WinInet Then
$dll_WinInet = DllOpen('wininet.dll')
If @error Then Return SetError(-1)
EndIf
Local $sUrlSearchPattern =($iCacheEntryType = 1 ? 'cookie:' :($iCacheEntryType = 2 ? 'visited:' : '*.*'))
Local $tCacheEntryInfo, $tCacheEntryInfoSize, $hUrlCacheEntry = 0, $aCall, $iFirst = 1, $aRet[0], $iCounter = 0
Do
$tCacheEntryInfoSize = DllStructCreate("dword")
If $iFirst Then
DllCall($dll_WinInet, "ptr", "FindFirstUrlCacheEntryW", 'wstr', $sUrlSearchPattern, "ptr", 0, "ptr", DllStructGetPtr($tCacheEntryInfoSize))
Else
DllCall($dll_WinInet, "int", "FindNextUrlCacheEntryW", "ptr", $hUrlCacheEntry, "ptr", 0, "ptr", DllStructGetPtr($tCacheEntryInfoSize))
EndIf
If @error Then ExitLoop
$tCacheEntryInfo = DllStructCreate('dword StructSize; ptr SourceUrlName; ptr LocalFileName; dword CacheEntryType; dword UseCount; dword HitRate; dword Size[2]; dword LastModifiedTime[2]; dword ExpireTime[2]; dword LastAccessTime[2]; dword LastSyncTime[2]; ptr HeaderInfo; dword HeaderInfoSize; ptr FileExtension; dword ReservedExemptDelta;byte[' &(DllStructGetData($tCacheEntryInfoSize, 1) + 1) & ']')
If $iFirst Then
$aCall = DllCall($dll_WinInet, "ptr", "FindFirstUrlCacheEntryW", 'wstr', $sUrlSearchPattern, "ptr", DllStructGetPtr($tCacheEntryInfo), "ptr", DllStructGetPtr($tCacheEntryInfoSize))
Else
$aCall = DllCall($dll_WinInet, "int", "FindNextUrlCacheEntryW", "ptr", $hUrlCacheEntry, "ptr", DllStructGetPtr($tCacheEntryInfo), "ptr", DllStructGetPtr($tCacheEntryInfoSize))
EndIf
If @error Or Not $aCall[0] Then ExitLoop
If $iFirst Then
$hUrlCacheEntry = $aCall[0]
$iFirst = 0
EndIf
ReDim $aRet[$iCounter + 1]
$aRet[$iCounter] = _WinINet_CacheEntryInfoStructToArray($tCacheEntryInfo)
$iCounter += 1
Until 0
DllCall($dll_WinInet, "int", "FindCloseUrlCache", "ptr", $hUrlCacheEntry)
Return SetError(Int(Not($iCounter > 0)), $iCounter, $aRet)
EndFunc
Func _WinINet_CacheEntryInfoDelete($sUrlName)
If Not $dll_WinInet Then
$dll_WinInet = DllOpen('wininet.dll')
If @error Then Return SetError(-1)
EndIf
Local $avResult = DllCall($dll_WinInet, "int", "DeleteUrlCacheEntryW", 'wstr', $sUrlName)
If @error Or $avResult[0] <> 0 Then Return SetError(1, 0, False)
Return True
EndFunc
Func _WinINet_CacheEntryInfoStructToArray($tCacheEntryInfo)
Local $avReturn[7] = ['SourceUrlName', 'LocalFileName', 'HeaderInfo'], $iPtr, $iStructEnd = Number(DllStructGetPtr($tCacheEntryInfo)) + DllStructGetSize($tCacheEntryInfo)
For $i = 0 To 2
$iPtr = DllStructGetData($tCacheEntryInfo, $avReturn[$i])
$avReturn[$i] = DllStructGetData(DllStructCreate("wchar[" & _WinINet_StringLenFromPtr($iPtr) & "]", $iPtr), 1)
Next
$avReturn[3] = DllStructGetData(DllStructCreate("int64", DllStructGetPtr($tCacheEntryInfo, "Size")), 1)
$avReturn[4] = DllStructGetData(DllStructCreate("int64", DllStructGetPtr($tCacheEntryInfo, "ExpireTime")), 1)
$avReturn[5] = DllStructGetData(DllStructCreate("int64", DllStructGetPtr($tCacheEntryInfo, "LastSyncTime")), 1)
$avReturn[6] = DllStructGetData($tCacheEntryInfo, "HitRate")
Return $avReturn
EndFunc
Func _WinINet_StringLenFromPtr($pString, $bUnicode = True)
Local $aRet = DllCall($dll_Kernel32, 'int', 'lstrlen' &($bUnicode ? 'W' : ''), 'struct*', $pString)
If @error Then Return SetError(1, 0, 0)
Return $aRet[0]
EndFunc
Func _IE_CheckCompatible($vCheckMode = True)
Local $_Reg_BROWSER_EMULATION = '\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION'
Local $_Reg_HKCU_BROWSER_EMULATION = 'HKCU\SOFTWARE' & $_Reg_BROWSER_EMULATION
Local $_Reg_HKLM_BROWSER_EMULATION = 'HKLM\SOFTWARE' & $_Reg_BROWSER_EMULATION
Local $_Reg_HKLMx64_BROWSER_EMULATION = 'HKLM\SOFTWARE\WOW6432Node' & $_Reg_BROWSER_EMULATION
Local $_IE_Mode, $_AutoItExe = StringRegExp(@AutoItExe, '(?i)\\([^\\]+.exe)$', 1)[0]
Local $_IE_Version = StringRegExp(FileGetVersion(@ProgramFilesDir & "\Internet Explorer\iexplore.exe"), '^\d+', 1)
If @error Then Return SetError(1, __HttpRequest_ErrNotify('_IE_CheckCompatible', 'Không lấy được version của IE'), False)
$_IE_Version = Number($_IE_Version[0])
Switch $_IE_Version
Case 7, 8, 9
$_IE_Mode = $_IE_Version * 1111
_HttpRequest_ConsoleWrite('! IE' & $_IE_Version & ' có thể không tương thích với HTML mới sau này gây ra không thể tải trang bình hường (blank page)' & @CRLF)
Case 10, 11
$_IE_Mode = $_IE_Version * 1000 + 1
Case Else
_HttpRequest_ConsoleWrite( '!!! Phiên bản Internet Explorer hiện tại trên máy bạn đã quá cũ (IE' & $_IE_Version & ').' & @CRLF & '!!! Điều này có thể khiến một số trang có ReCaptcha không thể hiển thị được.' & @CRLF & '!!! Nếu không nhúng ReCaptcha được, máy cần cài Win7 trở lên và IE version 10 hoặc 11.' & @CRLF)
Return SetError(2, '', False)
EndSwitch
If $vCheckMode Then
If RegRead($_Reg_HKCU_BROWSER_EMULATION, $_AutoItExe) <> $_IE_Mode Then RegWrite($_Reg_HKCU_BROWSER_EMULATION, $_AutoItExe, 'REG_DWORD', $_IE_Mode)
If RegRead($_Reg_HKLM_BROWSER_EMULATION, $_AutoItExe) <> $_IE_Mode Then RegWrite($_Reg_HKLM_BROWSER_EMULATION, $_AutoItExe, 'REG_DWORD', $_IE_Mode)
If @AutoItX64 And RegRead($_Reg_HKLMx64_BROWSER_EMULATION, $_AutoItExe) <> $_IE_Mode Then RegWrite($_Reg_HKLMx64_BROWSER_EMULATION, $_AutoItExe, 'REG_DWORD', $_IE_Mode)
Else
If RegRead($_Reg_HKCU_BROWSER_EMULATION, $_AutoItExe) <> $_IE_Mode Then RegDelete($_Reg_HKCU_BROWSER_EMULATION, $_AutoItExe)
If RegRead($_Reg_HKLM_BROWSER_EMULATION, $_AutoItExe) <> $_IE_Mode Then RegDelete($_Reg_HKLM_BROWSER_EMULATION, $_AutoItExe)
If @AutoItX64 And RegRead($_Reg_HKLMx64_BROWSER_EMULATION, $_AutoItExe) <> $_IE_Mode Then RegDelete($_Reg_HKLMx64_BROWSER_EMULATION, $_AutoItExe)
EndIf
Return True
EndFunc
Func _IE_RecaptchaBox($sURL, $vAdvancedMode = Default, $iX_GUI = Default, $iY_GUI = Default, $vTimeOut = Default, $Custom_RegExp_GetDataSiteKey = Default, $vCheckCompatible = True)
If $vTimeOut = Default Or $vTimeOut < 30000 Then $vTimeOut = 30000
If $vAdvancedMode = Default Then $vAdvancedMode = False
If $iX_GUI = Default Then $iX_GUI =(@DesktopWidth - 404) / 2
If $iY_GUI = Default Then $iY_GUI =(@DesktopHeight - 607) / 2 - 50
If $vCheckCompatible Then
_IE_CheckCompatible(True)
If @error Then Return SetError(-1, '', '')
EndIf
Local $___oldCursorMode = [Opt('MouseCoordMode', 0), Opt('MouseClickDelay', 0), Opt('MouseClickDownDelay', 0)]
Local $ie_GUI_EmbededCaptcha = GUICreate("Recaptcha Box", 404, 630, $iX_GUI, $iY_GUI, 0x80000000, 0x8)
Local $ie_GUI_SampleGetOffset = GUICreate("Recaptcha Box Sample", 0, 0, 0, 0, 0x80000000, 0x8 + 0x40, $ie_GUI_EmbededCaptcha)
Local $___GUI_Offset = WinGetPos($ie_GUI_EmbededCaptcha)[0] - WinGetPos($ie_GUI_SampleGetOffset)[0]
GUIDelete($ie_GUI_SampleGetOffset)
GUISetBkColor(0x222222, $ie_GUI_EmbededCaptcha)
Local $sRet = __IE_Init_RecaptchaBox($sURL, $vAdvancedMode, $ie_GUI_EmbededCaptcha, $___GUI_Offset, $Custom_RegExp_GetDataSiteKey, $vTimeOut)
Local $vErr = @error
$ie_GUI_EmbededCaptcha = GUIDelete($ie_GUI_EmbededCaptcha)
ConsoleWrite(@CRLF)
Opt('MouseCoordMode', $___oldCursorMode[0])
Opt('MouseClickDelay', $___oldCursorMode[1])
Opt('MouseClickDownDelay', $___oldCursorMode[2])
_GDIPlus_Shutdown()
If $vCheckCompatible Then _IE_CheckCompatible(False)
Return SetError($vErr, '', $sRet)
EndFunc
Func _IE_GetCookie($sURL, $iBufferSize = 2048)
If Not $dll_WinInet Then
$dll_WinInet = DllOpen('wininet.dll')
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_IE_GetCookieEx', 'Không thể mở wininet.dll'), '')
DllOpen('wininet.dll')
EndIf
Local $tSize = DllStructCreate("dword")
DllStructSetData($tSize, 1, $iBufferSize)
Local $tCookieData = DllStructCreate("wchar[" & $iBufferSize & "]")
Local $avResult = DllCall($dll_WinInet, "int", "InternetGetCookieExW", 'wstr', $sURL, 'wstr', Null, "ptr", DllStructGetPtr($tCookieData), "ptr", DllStructGetPtr($tSize), "dword", 0x2000, "ptr", 0)
If @error Then Return SetError(1, 0, "")
If Not $avResult[0] Then Return SetError(1, DllStructGetData($tSize, 1), "")
Return DllStructGetData($tCookieData, 1)
EndFunc
Func _HttpRequest_CookieJarSearch($sURL)
If $g___CookieJarPath = '' Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_CookieJarSearch', 'Vui lòng cài đặt _HttpRequest_CookieJarSet trước khi sử dụng hàm này'), '')
If Not $sURL Or IsKeyword($sURL) Or $sURL == -1 Then Return $g___CookieJarINI($g___CookieJarPath)
Local $aDomain = StringRegExp($g___CookieJarINI($g___CookieJarPath), '(?m)^\[([^\]]+)\]$', 3)
If @error Then Return SetError(1, 0, '')
Local $sCookie = ''
For $i = 0 To UBound($aDomain) - 1
If StringRegExp($sURL, '(?i)^(?:https?:\/.*?' & $aDomain[$i] & '|' & $aDomain[$i] & ')(?:\/|$)') Then
$sCookie &= __CookieJar_Read($aDomain[$i])
EndIf
Next
Return StringReplace($sCookie, @CRLF, '; ', 0, 1)
EndFunc
Func _HttpRequest_CookieJarUpdateToFile()
If $g___CookieJarPath = '' Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_CookieJarUpdateToFile', 'Vui lòng cài đặt _HttpRequest_CookieJarSet trước khi sử dụng hàm này'), False)
If Not $g___CookieJarINI($g___CookieJarPath) Then Return False
Local $hFileOpen = FileOpen($g___CookieJarPath, 2 + 8 + 32)
FileWrite($hFileOpen, $g___CookieJarINI($g___CookieJarPath))
$hFileOpen = FileClose($hFileOpen)
Return True
EndFunc
Func __CookieJar_Insert($sDomain, $iHeaders)
If Not $g___CookieJarPath Or Not $iHeaders Then Return $iHeaders
Local $aCookie = StringRegExp($iHeaders, '(?im)^Set-Cookie\h*:\h*([^=]+)=(?!deleted;)([^;]+)(?:.*?;\h*?domain=([^;\r\n]+))?()', 3)
If @error Or Mod(UBound($aCookie), 4) Then Return SetError(1, '', $iHeaders)
For $i = 0 To UBound($aCookie) - 1 Step 4
If $aCookie[$i + 2] == '' Then $aCookie[$i + 2] = $sDomain
__CookieJar_Write($aCookie[$i + 2], $aCookie[$i], $aCookie[$i + 1])
Next
Return $iHeaders
EndFunc
Func __CookieJar_Read($iSection, $iKey = '', $vDefault = '')
Local $sRegion = StringRegExp($g___CookieJarINI($g___CookieJarPath), '(?ims)^\Q[' & $iSection & ']\E$\R?(.*?)(?:\R?^\[[^\]]+\]$|\R?\z)', 1)
If @error Then Return SetError(1, '', $vDefault)
If $iKey == '' Then Return $sRegion[0]
Local $sKeyValue = StringRegExp($sRegion[0], '(?im)^\Q' & $iKey & '\E=(.*)$', 1)
If @error Then Return SetError(2, '', $vDefault)
Return $sKeyValue[0]
EndFunc
Func __CookieJar_Write($iSection, $iKey, $iValue)
If $iKey == '' Then Return SetError(1, '', False)
Local $vKeyValueOld = __CookieJar_Read($iSection, $iKey, False)
Switch @error
Case 0
$g___CookieJarINI($g___CookieJarPath) = StringRegExpReplace($g___CookieJarINI($g___CookieJarPath), '(?ims)^(\Q[' & $iSection & ']\E$.*?\R^\Q' & $iKey & '=\E)\Q' & $vKeyValueOld & '\E$', '${1}' & $iValue, 1)
Case 1
$g___CookieJarINI($g___CookieJarPath) = '[' & $iSection & ']' & @CRLF & $iKey & '=' & $iValue & @CRLF & @CRLF & $g___CookieJarINI($g___CookieJarPath)
Case 2
$g___CookieJarINI($g___CookieJarPath) = StringRegExpReplace($g___CookieJarINI($g___CookieJarPath), '(?im)^(\Q[' & $iSection & ']\E)$', '${1}' & @CRLF & $iKey & '=' & $iValue)
EndSwitch
If @error Then Return SetError(2, '', False)
Return True
EndFunc
Func __CookieGlobal_Insert($sDomain, $sCookie)
If Not $sCookie Then Return
Local $aCookie = StringRegExp($sCookie, '(?<=^|;)\h*([^=]+)=\h*([^;]+)(?:;|$)', 3)
If @error Or Mod(UBound($aCookie), 2) Then Return SetError(1, '', '')
For $i = 0 To UBound($aCookie) - 1 Step 2
If $aCookie[$i + 1] = 'deleted' Then
__CookieGlobal_Delete($sDomain, $aCookie[$i])
Else
__CookieGlobal_Write($sDomain, $aCookie[$i], $aCookie[$i + 1])
EndIf
Next
EndFunc
Func __CookieGlobal_Search($sURL)
Local $aDomain = StringRegExp($g___hCookie[$g___LastSession], '(?m)^\[([^\]]+)\]$', 3)
If @error Then Return SetError(1, 0, '')
Local $sCookie = ''
For $i = 0 To UBound($aDomain) - 1
If StringRegExp($sURL, '(?i)^https?:\/.*?' & $aDomain[$i] & '[^\/]*?(?:\/|$)') Then
$sCookie &= __CookieGlobal_Read($aDomain[$i])
EndIf
Next
Return StringReplace($sCookie, @CRLF, '; ', 0, 1)
EndFunc
Func __CookieGlobal_Read($iSection, $iKey = '', $vDefault = '')
Local $sRegion = StringRegExp($g___hCookie[$g___LastSession], '(?ims)^\Q[' & $iSection & ']\E$\R?(.*?)(?:\R?^\[[^\]]+\]$|\R?\z)', 1)
If @error Then Return SetError(1, '', $vDefault)
If $iKey == '' Then Return $sRegion[0]
Local $sKeyValue = StringRegExp($sRegion[0], '(?im)^\Q' & $iKey & '\E=(.*)$', 1)
If @error Then Return SetError(2, '', $vDefault)
Return $sKeyValue[0]
EndFunc
Func __CookieGlobal_Write($iSection, $iKey, $iValue)
If $iKey == '' Then Return SetError(1, '', False)
Local $vKeyValueOld = __CookieGlobal_Read($iSection, $iKey, False)
Switch @error
Case 0
$g___hCookie[$g___LastSession] = StringRegExpReplace($g___hCookie[$g___LastSession], '(?ims)^(\Q[' & $iSection & ']\E$.*?\R^\Q' & $iKey & '=\E)\Q' & $vKeyValueOld & '\E$', '${1}' & $iValue, 1)
Case 1
$g___hCookie[$g___LastSession] = '[' & $iSection & ']' & @CRLF & $iKey & '=' & $iValue & @CRLF & @CRLF & $g___hCookie[$g___LastSession]
Case 2
$g___hCookie[$g___LastSession] = StringRegExpReplace($g___hCookie[$g___LastSession], '(?im)^(\Q[' & $iSection & ']\E)$', '${1}' & @CRLF & $iKey & '=' & $iValue)
EndSwitch
If @error Then Return SetError(2, '', False)
Return True
EndFunc
Func __CookieGlobal_Delete($iSection, $iKey = '')
If $iKey == '' Then
$g___hCookie[$g___LastSession] = StringRegExpReplace($g___hCookie[$g___LastSession], '(?ims)^\Q[' & $iSection & ']\E$.*?\R(^\[[^\]]+\]$|\R?\z)', '${1}', 1)
Else
$g___hCookie[$g___LastSession] = StringRegExpReplace($g___hCookie[$g___LastSession], '(?ims)^(\Q[' & $iSection & ']\E$.*?)\R^\Q' & $iKey & '=\E.*?$', '${1}', 1)
EndIf
If @error Then Return SetError(1, '', False)
Return True
EndFunc
Func _HttpRequest_Speech2Text($sFilePath_or_URL, $iAccessToken = Default, $vHomoPhones = False, $vHomoPhonesComplex = False)
Local $aToken = ['5VJA67YGXNCSMNJ7CYNNVWZGYTS7F2SC', 'C4GAT5X7ADGEKZA5L2UJF3RUFNHO4RSK', '23NDEC2ABK5VMXYXW2HE2E6GSPSGHGGF']
Local $sTypeAudio = 'audio/wav'
If StringInStr($sFilePath_or_URL, 'http', 0, 1, 1, 4) Then
Local $bData = _HttpRequest(5, $sFilePath_or_URL)
If @error Or @extended > 300 Then Return SetError(1, __HttpRequest_ErrNotify('_HttpRequest_Speech2Text', 'Không thể tải về dữ liệu audio từ URL đã nạp'), '')
If StringInStr($bData[0], 'Content-Type: audio/mp3') Then $sTypeAudio = 'audio/mpeg'
$bData = $bData[1]
Else
Local $bData = _GetFileInfo($sFilePath_or_URL, 0)
If @error Then Return SetError(2, __HttpRequest_ErrNotify('_HttpRequest_Speech2Text', 'Không thể lấy dữ liệu audio từ File Path'), '')
$sTypeAudio = $bData[1]
$bData = $bData[2]
If $sTypeAudio <> 'audio/wav' And $sTypeAudio <> 'audio/mpeg' Then $sTypeAudio = 'audio/mpeg'
EndIf
If $iAccessToken = Default Or $iAccessToken = '' Then $iAccessToken = $aToken[Random(0, UBound($aToken) - 1)]
Local $rq = _HttpRequest(2, 'https://api.wit.ai/speech', $bData, '', '', 'Content-Type: ' & $sTypeAudio & '|Authorization: Bearer ' & $iAccessToken)
Local $sText = StringRegExp($rq, '"_text"\s?:\s?"(.*?)"', 1)
If @error Or $sText[0] == '' Then Return SetError(3, __HttpRequest_ErrNotify('_HttpRequest_Speech2Text', 'Chuyển đổi âm thanh thành text thất bại:' & @CRLF & @CRLF & $rq), '')
$sText = $sText[0]
If $vHomoPhones Then
If $vHomoPhonesComplex Then
Local $Str2Num = ['zero|a hero|the euro|the hero|Europe|yeah well|the o\.?|hey oh|hero|yeahhere|well|yeah well|euro|yo|hello|arrow|Arrow|they don''t|girl|bill|you know|\w*?ero', 'one|who won|won|juan|Warren|fun', 'two|too|to|who|true|so|you|hello|lou|\w*?do|\w*+?ew', 'three|during|tree|free|siri|very|be|wes|we|really|hurry|\w*?ee\w*?', 'four|for|fore|fourth|oar|or|more|porn|\w*?oor\w*?', 'five|hive|fight|fifth|why|find|\w*?ive\w*?', 'six|sex|big|sic|set|dicks|it|thank|\w*?icks?', 'seven|heaven|Frozen|Allen|send|weather|that in|ten|\w*?ven\w*?', 'eight|o\.\s?k\.?|eight|hate|fate|hey|\w*?ate', 'nine|yeah I|i''m|mine|brian|no i''m|no I|now I|night|eyes|none|non|bind|nice|\w*?ine']
Else
Local $Str2Num = ['zero', 'one|won', 'two|to|too', 'three', 'four|fourth|for|fore', 'five', 'six', 'seven', 'eight|ate', 'nine']
EndIf
For $i = 0 To 9
$sText = StringRegExpReplace($sText, '(?i)(^|\W)(' & $Str2Num[$i] & ')(\W|$)', '${1}' & $i & '${3}')
Next
$sText = StringRegExpReplace($sText, '\D', '')
EndIf
Return $sText
EndFunc
Func _oHttpRequest($iReturn, $sURL, $sData2Send = '', $sCookie = '', $sReferer = '', $sAdditional_Headers = '', $sMethod = '')
Local $vContentType = '', $vAcceptType = '', $vUserAgent = '', $vBoundary = '', $vUpload = 0
Local $sServerUserName = '', $sServerPassword = '', $sProxyUserName = '', $sProxyPassword = ''
If StringRegExp($sURL, '^\h*?/\w?') And $g___sBaseURL[$g___LastSession] Then $sURL = $g___sBaseURL[$g___LastSession] & $sURL
Local $aRetMode = __HttpRequest_iReturnSplit($iReturn)
If @error Then Return SetError(1, -1, '')
Local $aURL = __HttpRequest_URLSplit($sURL)
If @error Then Return SetError(2, -1, '')
If Not IsObj($g___oWinHTTP[$g___LastSession]) Then $g___oWinHTTP[$g___LastSession] = ObjCreate("WinHttp.WinHttpRequest.5.1")
If @error Then Return SetError(3, __HttpRequest_ErrNotify('_oHttpRequest', 'oWinHTTP Create Object Fail', -1), '')
With $g___oWinHTTP[$g___LastSession]
If IsArray($sData2Send) Then $sData2Send = _HttpRequest_DataFormCreate($sData2Send)
.Open(($sMethod ? $sMethod :($sData2Send ? "POST" : "GET")), $sURL, False)
If @error Then Return SetError(4, __HttpRequest_ErrNotify('_oHttpRequest', 'Xảy ra lỗi không thể thực hiện oHTTP.Open ', -1), '')
If $aRetMode[3] Then .Option(6) = False
.Option(4) = 0x3300
If $g___TimeOut Then .SetTimeouts(0, $g___TimeOut, $g___TimeOut, $g___TimeOut)
If $aRetMode[5] Then
$sProxyUserName = $aRetMode[6]
$sProxyPassword = $aRetMode[7]
.SetProxy(2, $aRetMode[5])
ElseIf $g___hProxy[$g___LastSession][0] Then
$sProxyUserName = $g___hProxy[$g___LastSession][3]
$sProxyPassword = $g___hProxy[$g___LastSession][4]
.SetProxy(2, $g___hProxy[$g___LastSession][0], $g___hProxy[$g___LastSession][2])
EndIf
If $sProxyUserName Then .SetCredentials($sProxyUserName, $sProxyPassword, 1)
If $aURL[4] Then
$sServerUserName = $aURL[4]
$sServerPassword = $aURL[5]
ElseIf $g___hCredential[$g___LastSession][0] Then
$sServerUserName = $g___hCredential[$g___LastSession][0]
$sServerPassword = $g___hCredential[$g___LastSession][1]
EndIf
If $sServerUserName Then .SetCredentials($sServerUserName, $sServerPassword, 0)
If $sData2Send Then
If Not $g___Boundary And StringInStr($vContentType, 'multipart', 0, 1) Then
$vBoundary = StringRegExp($vContentType, '(?i);\h*?boundary\h*?=\h*?([\w\-]+)', 1)
If Not @error Then
$g___Boundary = '--' & $vBoundary[0]
If Not StringRegExp($sData2Send, '(?is)^' & $g___Boundary) Then
Return SetError(5, __HttpRequest_ErrNotify('_oHttpRequest', '$sData2Send có Boundary không khớp với khai báo ở header Content-Type', -1), '')
ElseIf Not StringRegExp($sData2Send, '(?is)' & $g___Boundary & '--\R*?$') Then
Return SetError(6, __HttpRequest_ErrNotify('_oHttpRequest', 'Chuỗi Boundary ở cuối $sData2Send phải có -- ở cuối', -1), '')
EndIf
EndIf
EndIf
If $g___Boundary Then
If Not $vContentType Then $vContentType = 'multipart/form-data; boundary=' & StringTrimLeft($g___Boundary, 2)
$g___Boundary = ''
$vUpload = 1
$sData2Send = StringToBinary($sData2Send)
Else
If Not $vContentType Then
If StringRegExp($sData2Send, '^\h*?[\{\[]') Then
$vContentType = 'application/json'
Else
$vContentType = 'application/x-www-form-urlencoded'
__Data2Send_CheckEncode($sData2Send)
EndIf
If Not IsBinary($sData2Send) Then $sData2Send = StringToBinary($sData2Send, $aRetMode[11])
EndIf
EndIf
EndIf
Local $oAdditional_Headers = ObjCreate("Scripting.Dictionary")
With $oAdditional_Headers
.CompareMode = 1
.Item('Accept') = '*/*'
.Item('DNT') = '1'
.Item('User-Agent') = $g___UserAgent[$g___LastSession]
If $vContentType Then .Item('Content-Type') = $vContentType
If $sReferer Then .Item('Referer') = StringRegExpReplace($sReferer, '(?i)^\h*?Referer\h*?:\h*', '', 1)
If $sCookie Then .Item('Cookie') = StringRegExpReplace($sCookie, '(?i)^\h*?Cookie\h*?:\h*', '', 1)
If $sAdditional_Headers Then
Local $aAddition = StringRegExp($sAdditional_Headers, '(?i)\h*?([\w\-]+)\h*:\h*(.*?)(?:\||$)', 3)
For $i = 0 To UBound($aAddition) - 1 Step 2
.Item($aAddition[$i]) = $aAddition[$i + 1]
Next
EndIf
If $aRetMode[15] And Not StringRegExp($sAdditional_Headers, '(?im)(^|\|)\h*?X-Forwarded-For\h*?:') Then .Item('X-Forwarded-For') = _HttpRequest_GenarateIP()
Local $aHeaderName = .Keys
Local $aHeaderValue = .Items
For $i = 0 To UBound($aHeaderName) - 1
$g___oWinHTTP[$g___LastSession].SetRequestHeader($aHeaderName[$i], $aHeaderValue[$i])
Next
If $vUpload And Not $oAdditional_Headers.Exists('Content-Length') Then $g___oWinHTTP[$g___LastSession].SetRequestHeader('Content-Length', BinaryLen($sData2Send))
EndWith
.Send($sData2Send)
.WaitForResponse()
Local $vResponse_StatusCode = .Status
$g___retData[$g___LastSession][0] = .GetAllResponseHeaders()
Switch $aRetMode[0]
Case 0, 1
If $aRetMode[2] Then
$sCookie = _GetCookie($g___retData[$g___LastSession][0])
Return SetError(@error ? 7 : 0, $vResponse_StatusCode, $sCookie)
Else
Return SetError(0, $vResponse_StatusCode, $g___retData[$g___LastSession][0])
EndIf
Case 2 To 5
If Not $aRetMode[12] Then $g___retData[$g___LastSession][1] = .ResponseBody
If @error Then Return SetError(8, $vResponse_StatusCode, '')
If StringRegExp(BinaryMid($g___retData[$g___LastSession][1], 1, 1), '(?i)0x(1F|08|8B)') Then $g___retData[$g___LastSession][1] = __Gzip_Uncompress($g___retData[$g___LastSession][1])
If $aRetMode[2] = 1 Or $aRetMode[0] = 3 Or $aRetMode[0] = 5 Then
If $aRetMode[9] Then
_HttpRequest_Test($g___retData[$g___LastSession][1], $aRetMode[9], $aRetMode[10])
Return SetError(9 + @error, $vResponse_StatusCode, @error = 0)
ElseIf $aRetMode[0] < 4 Then
Return SetError(0, $vResponse_StatusCode, $g___retData[$g___LastSession][1])
Else
Local $aRet = [$g___retData[$g___LastSession][0], $g___retData[$g___LastSession][1]]
Return SetError(0, $vResponse_StatusCode, $aRet)
EndIf
Else
Local $sRet = $g___retData[$g___LastSession][1]
$sRet = BinaryToString($sRet, $aRetMode[11])
If $aRetMode[12] Then
$sRet = .ResponseText
ElseIf $aRetMode[4] Then
Local $aURL = __HttpRequest_URLSplit($sURL)
If Not @error Then $sRet = _HTML_AbsoluteURL($sRet, $aURL[7] & '://' & $aURL[2] & $aURL[3], '', $aURL[7])
ElseIf $aRetMode[16] Then
$sRet = _HTMLDecode($sRet)
EndIf
If $aRetMode[0] < 4 Then
Return SetError(0, $vResponse_StatusCode, $sRet)
Else
Local $aRet = [$g___retData[$g___LastSession][0], $sRet]
Return SetError(0, $vResponse_StatusCode, $aRet)
EndIf
EndIf
Case Else
Exit MsgBox(4096, 'Thông báo', 'Không có $iReturn này, xin vui lòng sửa lại code')
EndSwitch
EndWith
EndFunc
$RQ = FileRead('Code.html')
FileDelete(@ScriptDir & "\Link.txt")
FileDelete(@ScriptDir & "\Data.txt")
$text = StringRegExp($RQ, '(([\w]+)\=\{\"([\w]+)\":[^;]+;)', 3)
$Text2 = StringRegExp($RQ, '(' & $text[1] & '\.' & $text[2] & '.?\=[^;]+;)', 3)
$CodeJS = $text[0] & _ArrayToString($Text2, "")
$CodeJS &= 'a = (+' & $text[1] & '.' & $text[2] & ' + 12).toFixed(10);'
$KQ = _JS_Execute("", $CodeJS, "a")
$hiddens = _HttpRequest_SearchHiddenValues($RQ)
$link = "https://nohu365.club/" & StringRegExp($RQ, 'action\="([^"]+)"', 1)[0]
$data2send = "r=" & $hiddens("r") & "&jschl_vc=" & $hiddens("jschl_vc") & "&pass=" & $hiddens("pass") & "&jschl_answer=" & $KQ
FileWrite('Link.txt', $link)
FileWrite('Data.txt', $data2send)