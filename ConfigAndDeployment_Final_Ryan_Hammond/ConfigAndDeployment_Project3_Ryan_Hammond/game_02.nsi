
;Simple Example 


;--------------------------------
;Include Modern UI

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"
!include "x64.nsh"

;--------------------------------
;General

;TODO: 
!define ProductName "Game_02"
Name "Config and Deployment Game_02"
Outfile "Game_02_Installer.exe"


;Default Installation Folder
InstallDir "C:\cnd\final\Hammond_Ryan\"




 
	

;--------------------------------
;Interface Settings
!insertmacro GetTime
;Show a message box with a warning when the user wants to close the installer.
!define MUI_ABORTWARNING

;Show a message box with a warning when the user wants to close the uninstaller.
!define MUI_UNABORTWARNING


  !define MUI_ICON "setup.ico"
  !define MUI_UNICON "setup.ico"

  !define MUI_PAGE_LICENSE
  
  
;--------------------------------
;Pages

!define MUI_PAGE_CUSTOMFUNCTION_PRE checkLastTime
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_FUNCTION_ABORTWARNING licenseCancel
!insertmacro MUI_PAGE_LICENSE "license.txt"
;Page custom nsDialogsPage nsDialogsPageLeave
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE displaySpace
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections
Var instDirRegKey
Section "Test" Test
${If} ${RunningX64}
;StrCpy $InstDir "$PROGRAMFILES64\Ryan_Hammond\"
SetRegView 64
WriteRegStr HKLM "SOFTWARE\CND\Hammond_Ryan" "INFO6026_Final_2017" "INFO6026_Final_2017"
WriteRegStr HKLM "Software\CND\Hammond_Ryan" "InstallDir" "$INSTDIR"
${Else}
;StrCpy $InstDir "C\Ryan_Hammond\"
SetRegView 32
WriteRegStr HKLM "SOFTWARE\CND\Hammond_Ryan" "INFO6026_Final_2017" "INFO6026_Final_2017"
WriteRegStr HKLM "Software\CND\Hammond_Ryan" "InstallDir" "$INSTDIR"

${EndIf}
SectionEnd

Section "Video Game 02" Game_02


;TODO
CreateDirectory $INSTDIR\Game_02

SetOutPath "$INSTDIR\Game_02"

File License.txt
File glfw3.dll
File particles.exe
;Create shortcut
CreateShortCut "$DESKTOP\Hammond_Ryan.lnk" "$INSTDIR\Game_02\particles.exe"
;CreateShortCut "$SMPROGRAMS\particles.lnk" "$InstDIR\Game_02\particles.exe"

;WriteRegStr HKLM "Software\CND\Ryan_Hammond" "InstallDir" $INSTDIR
;Registry
SetRegView 64
WriteRegStr HKLM "SOFTWARE\CND\Ryan_Hammond" "InstallDir" "$INSTDIR"
${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6

WriteRegStr HKLM "SOFTWARE\CND\Ryan_Hammond" "Date2Serial" "$2$1$0$4$5$6"
;WriteRegStr HKLM "SOFTWARE\Ryan_Hammond" "UserName" "Ryan_Hammond"
;Create uninstaller
WriteUninstaller "$INSTDIR\Uninstall_Game_02.exe"

SectionEnd



Function licenseCancel
 MessageBox MB_OK "You must accept license to continue!"
FunctionEnd

Function displaySpace
	
	${GetRoot} "$INSTDIR" $0
	
	${DriveSpace} "$0\" "/D=F /S=M" $R0
	MessageBox MB_OK "$R0 mb"
FunctionEnd

Function checkLastTime
${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
SetRegView 64
ReadRegStr $9 HKLM "SOFTWARE\CND\Ryan_Hammond" "Date2Serial"
Var /GLOBAL test
StrCpy $test "$2$1$0$4$5$6"
IntOP $test $test - $9
;${If} $9 S!= ""
;	${If} $test > 60
;		MessageBox MB_YESNO|MB_DEFBUTTON2|MB_ICONQUESTION "THIS INSTALLER HAS EXPIRED!"
;		Quit
;	${Else}
;	${EndIf}
;${EndIf}
${If} ${RunningX64}
;StrCpy $InstDir "$PROGRAMFILES64\Ryan_Hammond\"
SetRegView 64
${Else}
;StrCpy $InstDir "C\Ryan_Hammond\"
SetRegView 32
${EndIf}
ReadRegStr $8 HKLM "SOFTWARE\CND\Hammond_Ryan" "InstallDir"

${If} $8 S== "" 
${Else}
MessageBox MB_YESNO "Program already installed. Abort Install" IDYES true IDNO false

true:
	Quit
false:

${EndIf}


FunctionEnd


Var myTextBox
Var txt
Var text_state
Var attemptCount

Function nsDialogsPage

nsDialogs::Create 1018
Pop $myTextBox
${If} $myTextBox == error
	Abort
	${EndIf}
	
	${NSD_CreateLabel} 0 0 25% 24u "test"
	${NSD_CreateText} 0 20% 50% 24u $txt
	Pop $text_state
	
	nsDialogs::Show
	FunctionEnd
	
	Function nsDialogsPageLeave
	IntOp $attemptCount $attemptCount + 1
	${NSD_GetText} $text_state $txt
	${If} $txt S!= "123-456-789"
		MessageBox MB_OK|MB_DEFBUTTON2|MB_ICONQUESTION "Wrong Key. Attempts: $attemptCount /3"
		${If} $attemptCount S== "3"
		MessageBox MB_OK|MB_DEFBUTTON2|MB_ICONQUESTION "No more attempts."
		Quit
		${Else}
		
		Abort
		${EndIf}
	${EndIf}
	SetRegView 64
	WriteRegStr HKLM "SOFTWARE\CND\Ryan_Hammond" "ProductKey" "$txt"
	FunctionEnd


;--------------------------------
;Uninstaller Section

Section "Uninstall"

;TODO
Delete "$INSTDIR\Game_02\License.txt"
Delete "$INSTDIR\Game_02\glfw3.dll"
Delete "$INSTDIR\Game_02\particles.exe"

Delete "$INSTDIR\Uninstall_Game_02.exe"

;Remove Shortcut
Delete "$DESKTOP\Hammond_Ryan.lnk"
;Delete "$SMPROGRAMS\particles.lnk"

;Remove Directory
RMDir "$INSTDIR\Game_02"
RMDir "$INSTDIR"

${If} ${RunningX64}
;StrCpy $InstDir "$PROGRAMFILES64\Ryan_Hammond\"
SetRegView 64
${Else}
;StrCpy $InstDir "C\Ryan_Hammond\"
SetRegView 32
${EndIf}
;DeleteRegValue HKLM "SOFTWARE\CND\Ryan_Hammond" "InstallDir"
DeleteRegKey  HKLM "SOFTWARE\CND\Hammond_Ryan"
SectionEnd
