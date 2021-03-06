; YUMI (Your Universal Multiboot Installer) Copyright �2011-2014 Lance http://www.pendrivelinux.com (See YUMI-Copying.txt and YUMI-Readme.txt for more information, Credits, and Licensing)
; 7-Zip Copyright � Igor Pavlovis http://7-zip.org (unmodified binaries were used)
; Syslinux � H. Peter Anvin http://syslinux.zytor.com (unmodified binary used)
; Firadisk.img � Panot Joonkhiaw Karyonix http://reboot.pro/8804/ (unmodified binary used)
; grub.exe Grub4DOS � the Gna! people + Chenall https://code.google.com/p/grub4dos-chenall/ (unmodified binary used) : Official Grub4DOS: http://gna.org/projects/grub4dos/
; Fat32format.exe � Tom Thornhill Ridgecorp Consultants http://www.ridgecrop.demon.co.uk (unmodified binary used)
; NSIS Installer � Contributors http://nsis.sourceforge.net - Install NSIS to compile this script. http://nsis.sourceforge.net/Download
; YUMI may contain remnants of Cedric Tissieres's Tazusb.exe for Slitaz (slitaz@objectif-securite.ch), as his work was used as a base for singular distro installers that preceded YUMI.

!define NAME "YUMI"
!define FILENAME "YUMI"
!define VERSION "2.0.0.1"
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\nsis1-install.ico"

; MoreInfo Plugin - Adds Version Tab fields to Properties. Plugin created by onad http://nsis.sourceforge.net/MoreInfo_plug-in
VIProductVersion "${VERSION}"
VIAddVersionKey CompanyName "pendrivelinux.com"
VIAddVersionKey LegalCopyright "Copyright �2010-2013 Lance Pendrivelinux.com"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription "Automated Universal MultiBoot UFD Creation Tool"
VIAddVersionKey License "GPL Version 2"

Name "${NAME} ${VERSION}"
OutFile "${FILENAME}-${VERSION}.exe"
RequestExecutionLevel admin ;highest
SetCompressor LZMA
CRCCheck On
XPStyle on
ShowInstDetails show
BrandingText "${NAME} ${VERSION}"
CompletedText "All Finished, Process is Complete!"
InstallButtonText "Create"

!include WordFunc.nsh
!include nsDialogs.nsh
!include MUI2.nsh
!include FileFunc.nsh
!include LogicLib.nsh
;!include TextFunc.nsh
!AddPluginDir "plugins"

; Variables
Var Capacity
Var VolName
Var Checker
Var FileFormat
Var Format 
Var FormatMe
Var BlockSize
Var Dialog
Var LabelDrivePage
Var Distro
Var DistroName
Var ISOFileName
Var DestDriveTxt
Var JustDrive
Var DestDrive
Var BootDir
Var LinuxDistroSelection
Var LabelISOSelection
Var ISOFileTxt
Var TheISO
Var IsoFile
Var ISOSelection
Var ISOTest
Var JustISO
Var JustISOName
Var JustISOPath
Var ConfigFile
Var ConfigPath
Var CopyPath
Var SearchDir
Var SearchFile
Var DestDisk
Var DownloadISO
Var DownloadMe
Var Link
Var Links
Var Auth
Var DownLink
Var LocalSelection
Var Letters
Var Config2Use
Var SomeFileExt
Var AllDriveOption
Var DisplayAll
Var DistroLink
Var Homepage
Var OfficialSite
Var OfficialName
Var NameThatISO
Var OnlyVal
Var Uninstaller
Var Removal
Var InUnStall
Var SUSEDIR
Var RepeatInstall
Var ShowAll

Var SizeOfCasper 
Var Casper
Var CasperSlider
Var CasperSelection
Var SlideSpot
Var RemainingSpace
Var MaxPersist
Var Persistence

!include DiskVoodoo.nsh ; DiskVoodoo Script created by Lance http://www.pendrivelinux.com

; Interface settings
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "usb-logo-nsis.bmp" 
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_HEADERIMAGE_RIGHT

; Comment out licensing page for less clicks on load
; License Agreement Page
; !define MUI_TEXT_LICENSE_SUBTITLE $(License_Subtitle)
; !define MUI_LICENSEPAGE_TEXT_TOP $(License_Text_Top)
; !define MUI_LICENSEPAGE_TEXT_BOTTOM $(License_Text_Bottom)
; !define MUI_PAGE_CUSTOMFUNCTION_PRE License_PreFunction
; !insertmacro MUI_PAGE_LICENSE "YUMI-Copying.txt"

; Distro Selection Page
Page custom SelectionsPage

; Install Files Page
!define MUI_INSTFILESPAGE_COLORS "00FF00 000000" ;Green and Black
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT $(Finish_Install)
!define MUI_TEXT_INSTALLING_TITLE $(Install_Title)
!define MUI_TEXT_INSTALLING_SUBTITLE $(Install_SubTitle)
!define MUI_TEXT_FINISH_SUBTITLE $(Install_Finish_Sucess)
!define MUI_PAGE_CUSTOMFUNCTION_PRE InstFiles_PreFunction
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!define MUI_FINISHPAGE_TITLE $(Finish_Title)
!define MUI_FINISHPAGE_TEXT $(Finish_Text)
!define MUI_FINISHPAGE_LINK $(Finish_Link)
!define MUI_FINISHPAGE_LINK_LOCATION "http://www.pendrivelinux.com/boot-multiple-iso-from-usb-multiboot-usb/"
!define MUI_WELCOMEFINISHPAGE_BITMAP "finish.bmp"
!define MUI_PAGE_CUSTOMFUNCTION_PRE Finish_PreFunction
!insertmacro MUI_PAGE_FINISH

; English Language files
!insertmacro MUI_LANGUAGE "English" ; first language is the default language
LangString License_Subtitle ${LANG_ENGLISH} "Please review the license terms before proceeding"
LangString License_Text_Top ${LANG_ENGLISH} "The software within this program falls under the following Licenses."
LangString License_Text_Bottom ${LANG_ENGLISH} "You must accept the terms of this License agreement to run this ${NAME}. If you agree, Click I Agree to Continue."
LangString SelectDist_Title ${LANG_ENGLISH} "Drive Selection and Distro Options Page"
LangString SelectDist_Subtitle ${LANG_ENGLISH} "Choose your Flash Drive, and a Distro, ISO/ZIP file.$\r$\nAdditional Distributions can be added each time this tool is run."
LangString DrivePage_Text ${LANG_ENGLISH} "Step 1: Select the drive letter of your USB device."
LangString Distro_Text ${LANG_ENGLISH} "Step 2: Select a Distribution from the list to put on your USB."
LangString IsoPage_Text ${LANG_ENGLISH} "Step 3: Select the $FileFormat (Name must be the same as above)."
LangString IsoPage_Title ${LANG_ENGLISH} "Select Your $FileFormat"
LangString Casper_Text ${LANG_ENGLISH} "Step 4: Set a Persistent file size for storing changes (Optional)."
LangString IsoFile ${LANG_ENGLISH} "$FileFormat file|$ISOFileName" ;$ISOFileName variable previously *.iso
LangString Extract ${LANG_ENGLISH} "Extracting the $FileFormat: The progress bar will not move until finished. Please be patient..."
LangString CreateSysConfig ${LANG_ENGLISH} "Creating configuration files for $DestDisk"
LangString ExecuteSyslinux ${LANG_ENGLISH} "Executing syslinux on $BootDir"
LangString SkipSyslinux ${LANG_ENGLISH} "Good Syslinux Exists..."
LangString WarningSyslinux ${LANG_ENGLISH} "An error ($R8) occurred while executing syslinux.$\r$\nYour USB drive won't be bootable..."
LangString Install_Title ${LANG_ENGLISH} "$InUnStall $ISOFileName"
LangString Install_SubTitle ${LANG_ENGLISH} "Please wait while we $InUnStall $DistroName on $JustDrive"
LangString Install_Finish_Sucess ${LANG_ENGLISH} "${NAME} sucessfully $InUnStalled $DistroName on $JustDrive"
LangString Finish_Install ${LANG_ENGLISH} "$InUnStallation is Complete."
LangString Finish_Title ${LANG_ENGLISH} "${NAME} has completed the $InUnStallation."
LangString Finish_Text ${LANG_ENGLISH} "Your Selections have been $InUnStalled on your USB drive.$\r$\n$\r$\nFeel Free to run this tool again to $InUnStall more Distros.$\r$\n$\r$\nYUMI will keep track of selections you have already $InUnStalled."
LangString Finish_Link ${LANG_ENGLISH} "Visit the YUMI Tutorial Page"

!include FileManipulation.nsh ; Text File Manipulation
!include FileNames.nsh ; Macro for FileNames
!include DistroList.nsh ; List of Distributions
!include "CasperScript.nsh" ; For creation of Persistent Casper-rw files

; Comment out the Licensing page for less clicks on load
;Function License_PreFunction
;  StrCpy $R8 1 ;This is the 1st page
;FunctionEnd

Function SelectionsPage
  StrCpy $R8 2
 !insertmacro MUI_HEADER_TEXT $(SelectDist_Title) $(SelectDist_Subtitle) 
  nsDialogs::Create 1018
  Pop $Dialog 

 ${If} $RepeatInstall == "YES"   
 ${NSD_SetText} $DestDriveTxt "$DestDrive"

; To Install or Uninstall? That is the question!  
  ${NSD_CreateCheckBox} 60% 0 44% 15 "View or Remove Installed Distros?"
  Pop $Uninstaller
  ${NSD_OnClick} $Uninstaller Uninstall  

 ; Distro Selection Starts
  ${NSD_CreateLabel} 0 50 50% 15 $(Distro_Text) 
  Pop $LinuxDistroSelection   

  ${NSD_CreateDroplist} 0 70 55% 95 "" ; was  ${NSD_CreateListBox} ; Enable For DropBox
  Pop $Distro
  ${NSD_OnChange} $Distro OnSelectDistro
  ${NSD_CB_SelectString} $Distro $DistroName ; Was ${NSD_LB_SelectString} $Distro $DistroName  ; Enable For DropBox 

; ISO Download Option
  ${NSD_CreateCheckBox} 60% 60 40% 15 "Download the ISO (Optional)."
  Pop $DownloadISO
  ${NSD_OnClick} $DownloadISO DownloadIt  
  
; Clickable Link to Distribution Homepage  
  ${NSD_CreateLink} 60% 80 40% 15 "Visit the $OfficialName HomePage"
  Pop $DistroLink
  ${NSD_OnClick} $DistroLink onClickLinuxSite    

; ISO Selection Starts  
  ${NSD_CreateLabel} 0 100 100% 15 $(IsoPage_Text)
  Pop $LabelISOSelection
  ${NSD_CreateText} 0 120 83% 20 "Browse to and select the $FileFormat"
  Pop $ISOFileTxt 
  ${NSD_CreateBrowseButton} 85% 120 60 20 "Browse"
  Pop $ISOSelection 
  ${NSD_OnClick} $ISOSelection ISOBrowse   
  
; Casper-RW Selection Starts
  ${NSD_CreateLabel} 0 150 75% 15 $(Casper_Text)
  Pop $CasperSelection  
  
; CasperSlider - TrackBar
  !define TBM_SETPOS 0x0405
  !define TBM_GETPOS 0x0400
  !define TBM_SETRANGEMIN 0x0407
  !define TBM_SETRANGEMAX 0x0408

  ${NSD_CreateLabel} 52% 178 25% 25 ""
  Pop $SlideSpot  

  nsDialogs::CreateControl "msctls_trackbar32" "0x50010000|0x00000018" "" 0 174 50% 25 ""
  Pop $CasperSlider

  SendMessage $CasperSlider ${TBM_SETRANGEMIN} 1 0 ; Min Range Value 0
  SendMessage $CasperSlider ${TBM_SETRANGEMAX} 1 $RemainingSpace ; Max Range Value $RemainingSpace
  ${NSD_OnNotify} $CasperSlider onNotify_CasperSlider    

; Drive Pre-Selection  
  ${NSD_CreateLabel} 0 0 58% 15 ""
  Pop $LabelDrivePage 
  ${NSD_SetText} $LabelDrivePage "Step 1: YUMI Summoned $DestDisk as your USB Device"  
; Droplist for Drive Selection  
  ${NSD_CreateDropList} 0 20 28% 15 "" ; was 0 20 15% 15
  Pop $DestDriveTxt 
  
   ${If} $ShowAll == "YES"
   ${GetDrives} "ALL" DrivesList ; All Drives Listed
   ${ElseIf} $ShowAll == "NO"
   ${GetDrives} "FDD" DrivesList ; FDD+HDD reduced to FDD for removable media only
   ${EndIf}
  
  ${NSD_CB_SelectString} $DestDriveTxt "$DestDrive"
  StrCpy $JustDrive $DestDrive 3
  StrCpy $BootDir $DestDrive 2 ;was -1 
  StrCpy $DestDisk $DestDrive 2 ;was -1
  SendMessage $Distro ${CB_RESETCONTENT} 0 0 ; was ${NSD_LB_Clear} $Distro "" ; Clear all distro entries because a new drive may have been chosen ; Enable for DropBox
  StrCpy $Checker "Yes"  
  Call InstallorRemove
  Call CheckSpace
  Call FormatIt 
  Call EnableNext 
  ${NSD_OnChange} $DestDriveTxt OnSelectDrive 
  
; All Drives Option
  ${NSD_CreateCheckBox} 30% 23 30% 15 "Show All Drives?" ; was 17% 23 41% 15
  Pop $AllDriveOption
  ${NSD_OnClick} $AllDriveOption ListAllDrives   
  
; Format Drive Option
  ${NSD_CreateCheckBox} 60% 23 100% 15 "Format $DestDisk Drive (Erase Content)?"
  Pop $Format
  ${NSD_OnClick} $Format FormatIt     
 
; Add Help Link
  ${NSD_CreateLink} 0 215 65% 15 "Click HERE to visit the YUMI page for additional Help!"
  Pop $Link
  ${NSD_OnClick} $LINK onClickMyLink 
 
; Disable Next Button until a selection is made for all 
  GetDlgItem $6 $HWNDPARENT 1
  EnableWindow $6 0 
; Remove Back Button
  GetDlgItem $6 $HWNDPARENT 3
  ShowWindow $6 0 
; Hide or disable steps until we state to display them 
  EnableWindow $LabelISOSelection 0
  EnableWindow $ISOFileTxt 0
  ShowWindow $ISOSelection 0
  EnableWindow $DownloadISO 0
  ShowWindow $DistroLink 0
  StrCpy $JustISOName "NULL" ; Set to NULL until something is selected
  nsDialogs::Show  
  
 ${Else}
  
; To Install or Uninstall? That is the question!  
  ${NSD_CreateCheckBox} 60% 0 44% 15 "View or Remove Installed Distros?"
  Pop $Uninstaller
  ${NSD_OnClick} $Uninstaller Uninstall  
  
; Drive Selection Starts  
  ${NSD_CreateLabel} 0 0 58% 15 ""    
  Pop $LabelDrivePage
  ${NSD_SetText} $LabelDrivePage "Step 1: Select the Drive Letter of your USB Device."    
  
; Droplist for Drive Selection
  ${NSD_CreateDropList} 0 20 28% 15 "" ; was 0 20 15% 15
  Pop $DestDriveTxt
  Call ListAllDrives
  ${NSD_OnChange} $DestDriveTxt OnSelectDrive
 
; All Drives Option
  ${NSD_CreateCheckBox} 30% 23 30% 15 "Show All Drives?" ; was 17% 23 41% 15
  Pop $AllDriveOption
  ${NSD_OnClick} $AllDriveOption ListAllDrives 
  
; Format Drive Option
  ${NSD_CreateCheckBox} 60% 23 100% 15 "Format $DestDisk Drive (Erase Content)?"
  Pop $Format
  ${NSD_OnClick} $Format FormatIt    
 
; Distro Selection Starts
  ${NSD_CreateLabel} 0 50 50% 15 $(Distro_Text) 
  Pop $LinuxDistroSelection   

  ${NSD_CreateDropList} 0 70 55% 95 "" ; was ${NSD_CreateListBox} ; Enable for Dropbox
  Pop $Distro
  ${NSD_OnChange} $Distro OnSelectDistro
  ${NSD_CB_SelectString} $Distro $DistroName ; Was ${NSD_LB_SelectString} $Distro $DistroName  ; Enable For DropBox

; ISO Download Option
  ${NSD_CreateCheckBox} 60% 60 40% 15 "Download the ISO (Optional)."
  Pop $DownloadISO
  ${NSD_OnClick} $DownloadISO DownloadIt  
  
; Clickable Link to Distribution Homepage  
  ${NSD_CreateLink} 60% 80 40% 15 "Visit the $OfficialName HomePage"
  Pop $DistroLink
  ${NSD_OnClick} $DistroLink onClickLinuxSite    

; ISO Selection Starts  
  ${NSD_CreateLabel} 0 100 100% 15 $(IsoPage_Text)
  Pop $LabelISOSelection
  ${NSD_CreateText} 0 120 83% 20 "Browse to and select the $FileFormat"
  Pop $ISOFileTxt 
  ${NSD_CreateBrowseButton} 85% 120 60 20 "Browse"
  Pop $ISOSelection 
  ${NSD_OnClick} $ISOSelection ISOBrowse

; Casper-RW Selection Starts
  ${NSD_CreateLabel} 0 150 75% 15 $(Casper_Text)
  Pop $CasperSelection  
  
; CasperSlider - TrackBar
  ; !define TBM_SETPOS 0x0405
  ; !define TBM_GETPOS 0x0400
  ; !define TBM_SETRANGEMIN 0x0407
  ; !define TBM_SETRANGEMAX 0x0408

  ${NSD_CreateLabel} 52% 178 25% 25 ""
  Pop $SlideSpot  

  nsDialogs::CreateControl "msctls_trackbar32" "0x50010000|0x00000018" "" 0 174 50% 25 ""
  Pop $CasperSlider

  SendMessage $CasperSlider ${TBM_SETRANGEMIN} 1 0 ; Min Range Value 0
  SendMessage $CasperSlider ${TBM_SETRANGEMAX} 1 $RemainingSpace ; Max Range Value $RemainingSpace
  ${NSD_OnNotify} $CasperSlider onNotify_CasperSlider    
  
; Add Help Link
  ${NSD_CreateLink} 0 215 65% 15 "Click HERE to visit the YUMI page for additional Help!"
  Pop $Link
  ${NSD_OnClick} $LINK onClickMyLink  

;; Add a custom donate button
;   ${NSD_CreateBitmap} 80% 125 20% 50 "PayPal Donation"
;   Var /Global Donate
;   Var /Global DonateHandle  
;   Pop $Donate
;   ${NSD_SetImage} $Donate $PLUGINSDIR\paypal.bmp $DonateHandle 
;  GetFunctionAddress $DonateHandle OnClickDonate
;  nsDialogs::OnClick $Donate $DonateHandle  
  
; Disable Next Button until a selection is made for all 
  GetDlgItem $6 $HWNDPARENT 1
  EnableWindow $6 0 
; Remove Back Button
  GetDlgItem $6 $HWNDPARENT 3
  ShowWindow $6 0 
; Hide or disable steps until we state to display them 
  EnableWindow $LabelISOSelection 0
  EnableWindow $ISOFileTxt 0
  ShowWindow $ISOSelection 0
  EnableWindow $LinuxDistroSelection 0
  EnableWindow $Distro 0
  EnableWindow $DownloadISO 0
  ShowWindow $DistroLink 0
  ShowWindow $CasperSelection 0 
  ShowWindow $CasperSlider 0 
  ShowWindow $SlideSpot 0  
  ShowWindow $Format 0
  ShowWindow $Uninstaller 0
  nsDialogs::Show 
;  ${NSD_FreeImage} $DonateHandle
 ${EndIf}
FunctionEnd

; Function OnClickDonate
;   ExecShell "open" "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T6K3C62LC5TCG"
; FunctionEnd 

Function InstFiles_PreFunction
  StrCpy $R8 3
FunctionEnd

Function Finish_PreFunction
  StrCpy $R8 4
  Call NoQuit
FunctionEnd

Function ListAllDrives ; Set to Display All Drives
  SendMessage $DestDriveTxt ${CB_RESETCONTENT} 0 0 
  ${NSD_GetState} $AllDriveOption $DisplayAll
  ${If} $DisplayAll == ${BST_CHECKED}
  ${NSD_Check} $AllDriveOption
  ${NSD_SetText} $AllDriveOption "Showing All Drives" 
    StrCpy $ShowAll "YES"
    ${GetDrives} "ALL" DrivesList ; All Drives Listed  
  ${ElseIf} $DisplayAll == ${BST_UNCHECKED}
  ${NSD_Uncheck} $AllDriveOption
  ${NSD_SetText} $AllDriveOption "Show All Drives?"  
	${GetDrives} "FDD" DrivesList ; FDD+HDD reduced to FDD for removable media only
	StrCpy $ShowAll "NO"
  ${EndIf}
FunctionEnd

Function onClickMyLink
  Pop $Links ; pop something to prevent corruption
  ExecShell "open" "http://www.pendrivelinux.com/yumi-multiboot-usb-creator/"
FunctionEnd

Function onClickLinuxSite
  Pop $OfficialSite 
  ExecShell "open" "$Homepage"
FunctionEnd

Function DownloadIt ; Set Download Option
  ${NSD_GetState} $DownloadISO $DownloadMe
  ${If} $DownloadMe == ${BST_CHECKED}
  ${NSD_Check} $DownloadISO
  ${NSD_SetText} $DownloadISO "Opened Download Link"
  Call DownloadLinks
  ${ElseIf} $DownloadMe == ${BST_UNCHECKED}
  ${NSD_Uncheck} $DownloadISO 
  ${NSD_SetText} $DownloadISO "Download Link" 
  ${EndIf}  
FunctionEnd

Function EnableNext ; Enable Install Button
  ${If} $Blocksize >= 4 
  ${AndIf} $Removal != "Yes"
  ShowWindow $Format 1 
  ${Else}
  ShowWindow $Format 0
  ${EndIf}
  ${If} $Removal != "Yes"    
   ${AndIf} $ISOFileName != ""
    ${AndIf} $ISOFile != ""
     ${AndIf} $DestDrive != "" 
	  ${AndIf} $ISOTest != ""
  StrCpy $InUnStall "Install"	  
  GetDlgItem $6 $HWNDPARENT 1 ; Get "Install" control handle
   SendMessage $6 ${WM_SETTEXT} 0 "STR:Create"
    EnableWindow $6 1 ; Enable "Install" control button

  ${ElseIf} $Removal == "Yes"
   ${AndIf} $ISOFileName != ""
     ${AndIf} $DestDrive != "" 
	  ${AndIf} $ISOTest != ""
  StrCpy $InUnStall "UnInstall"	  
  GetDlgItem $6 $HWNDPARENT 1 ; Get "Install" control handle
   SendMessage $6 ${WM_SETTEXT} 0 "STR:Remove"
    EnableWindow $6 1 ; Enable "Install" control button
  ${EndIf}
  
; Test if ISO has been Selected. If not, disable Install Button
  ${If} $ISOTest == ""
  GetDlgItem $6 $HWNDPARENT 1
  EnableWindow $6 0 ; Disable "Install" if ISO not set 
  ${EndIf}
  
; Show Steps in progression
  ${If} $DestDrive != ""  
  EnableWindow $LinuxDistroSelection 1
  EnableWindow $Distro 1
  ${EndIf}  
  
  ${If} $ISOFileName != "" 
  ${AndIf} $Removal != "Yes"
  EnableWindow $LabelISOSelection 1 
  EnableWindow $ISOFileTxt 1  
  ShowWindow $ISOSelection 1
  
  ${AndIf} $Removal == "Yes"
  EnableWindow $LabelISOSelection 0  
  EnableWindow $ISOFileTxt 0 
  ShowWindow $ISOSelection 0
  ${EndIf}  
  
; Disable Window if ISO was downloaded
  ${If} $TheISO == "$EXEDIR\$ISOFileName"
  ${AndIf} $ISOTest != ""  
  EnableWindow $ISOSelection 0
  SetCtlColors $ISOFileTxt 009900 FFFFFF  
  ${EndIf}

; If using Casper Persistence...  
  ${If} $Persistence == "casper" ; If can use Casper Persistence... 
  ${AndIf} $TheISO != ""
  ${AndIf} $BootDir != "" 
  ShowWindow $CasperSelection 1
  ShowWindow $CasperSlider 1
  ShowWindow $SlideSpot 1
  ;${NSD_SetText} $Format "Format $JustDrive Drive (Erases Content)"  
	
; Else If not using Casper Persistence...  
  ${ElseIf} $Persistence != "casper" ; Eventually change to "NULL"
  ${OrIf} $Removal == "Yes"  
  ShowWindow $CasperSelection 0
  ShowWindow $CasperSlider 0 
  ShowWindow $SlideSpot 0
  ;${NSD_SetText} $Format "Format $JustDrive Drive (Erases Content)" 
  ${EndIf}    
FunctionEnd

Function DownloadLinks
MessageBox MB_YESNO|MB_ICONQUESTION "Launch the Download Link?$\r$\nLet the download finish before moving to step 2." IDYES DownloadIt IDNO Skip
  Skip: ; Reset Download Checkbox Options 
  ${NSD_Uncheck} $DownloadISO 
  ${NSD_SetText} $DownloadISO "Download Link"  
  EnableWindow $DownloadISO 1
  Goto end
  DownloadIt:
  ${NSD_SetText} $LabelISOSelection "Step 3: Once your download has finished, Browse to and select the ISO."  
  EnableWindow $DownloadISO 0
  ExecShell "open" "$DownLink"    
  end:
FunctionEnd

Function LocalISODetected ; The script autodetected the ISO, so let's do the following
 ${If} $DownloadMe != ${BST_CHECKED}
 ${AndIf} $LocalSelection != "Yes"
 StrCpy $ISOFile "$EXEDIR\$ISOFileName"
 ${EndIf}
FunctionEnd

; get only the filename
Function GrabNameOnly
  Exch $4 ; count to get part
  Exch
  Exch $0 ; input string
  Push $1
  Push $2
  Push $3
  StrCpy $1 0
  StrCpy $3 1
  loop:
    IntOp $1 $1 - 1
    StrCpy $2 $0 1 $1
    StrCmp $2 "" exit2
    StrCmp $2 "\" next ; grab text to the right of "\"
    Goto loop
  next:
    StrCmp $3 $4 exit
    IntOp $3 $3 + 1
  Goto loop
  exit2:
    IntOp $1 $1 - 1
  exit:
    IntOp $1 $1 + 1
    StrCpy $0 $0 "" $1
    Pop $3
    Pop $2
    Pop $1
    Exch $0 ; output string
FunctionEnd

 !include StrContains.nsh ; Let's check if a * wildcard exists
 
; On Selection of Linux Distro
Function OnSelectDistro
  Pop $Distro
  ${NSD_GetText} $Distro $DistroName ; Was ${NSD_LB_GetSelection} $Distro $DistroName 
  StrCpy $DistroName "$DistroName"   
  StrCpy $Checker "No" 
  ${If} $Removal == "Yes"
  StrCpy $ISOFileName "$DistroName" 
  StrCpy $ISOTest "$DistroName"  
  ${Else} 
  Call SetISOFileName
  StrCpy $ISOFileName "$ISOFileName" 
  StrCpy $SomeFileExt "$ISOFileName" "" -3 ; Grabs the last 3 characters of the file name... zip or iso?
  StrCpy $FileFormat "$SomeFileExt" ; Set file type to look for zip, tar, iso etc...
  ${NSD_SetText} $LabelISOSelection "Step 3: Browse and Select your $ISOFileName"
  ${NSD_SetText} $ISOFileTxt "Browse to your $ISOFileName  -->"
  SetCtlColors $ISOFileTxt FF0000 FFFFFF  
  StrCpy $ISOTest "" ; Set to null until a new ISO selection is made
  ${EndIf}
  
; Redraw Home page Links as necessary
  ${NSD_SetText} $DistroLink "Visit the $OfficialName Home Page" 
  ShowWindow $DistroLink 0
  ${If} $OfficialName == ""
   ${OrIf} $Removal == "Yes"
  ShowWindow $DistroLink 0
  ${Else}
  ShowWindow $DistroLink 1
  ${EndIf}    
  
; Autodetect ISO's in same folder and select if they exist  
 ${If} ${FileExists} "$EXEDIR\$ISOFileName"
 ${AndIf} $Removal != "Yes"
 ${StrContains} $WILD "*" "$ISOFileName" ; Check for Wildcard and force Browse if * exists.
 ${AndIf} $WILD != "*"  
  StrCpy $TheISO "$EXEDIR\$ISOFileName"
  StrCpy $ISOFile "$TheISO"  
  ${GetFileName} "$TheISO" $JustISO
  ${GetBaseName} "$JustISO" $JustISOName
  ${GetParent} "$TheISO" $JustISOPath  
  EnableWindow $DownloadISO 0
  ${NSD_SetText} $DownloadISO "We Found and Selected the $SomeFileExt."    
  EnableWindow $ISOSelection 0 
  SetCtlColors $ISOFileTxt 009900 FFFFFF  
  ${NSD_SetText} $ISOFileTxt $ISOFile 
  ${NSD_SetText} $LabelISOSelection "Step 3 DONE: $ISOFileName Found and Selected!"  
  StrCpy $ISOTest "$TheISO" ; Populate ISOTest so we can enable Next    
  Call EnableNext  
  
 ${ElseIf} ${FileExists} "$EXEDIR\$ISOFileName"
 ${AndIf} $Removal != "Yes"
 ${AndIf} $WILD == "*" 
  EnableWindow $DownloadISO 1
  EnableWindow $ISOSelection 1
  ${NSD_Uncheck} $DownloadISO  
  ${NSD_SetText} $DownloadISO "Download Link"       
  SetCtlColors $ISOFileTxt FF9B00 FFFFFF  
  ${NSD_SetText} $ISOFileTxt "Browse to and select the $ISOFileName" 
  ${NSD_SetText} $LabelISOSelection "Step 3 PENDING: Browse to your $ISOFileName"    
  Call EnableNext  
  
 ${Else}
  Call EnableNext
  EnableWindow $DownloadISO 1
  EnableWindow $ISOSelection 1
  ${NSD_Uncheck} $DownloadISO  
  ${NSD_SetText} $DownloadISO "Download Link"   
 ${EndIf}  
 
 ${If} $DownLink == "NONE"
  ${OrIf} $Removal == "Yes"
  ShowWindow $DownloadISO 0
 ${Else}
  ShowWindow $DownloadISO 1
 ${EndIf}
  
FunctionEnd 

; On Selection of ISO File
Function ISOBrowse
 nsDialogs::SelectFileDialog open "" $(IsoFile)
 Pop $TheISO  
 ${NSD_SetText} $ISOFileTxt $TheISO
 SetCtlColors $ISOFileTxt 009900 FFFFFF
 EnableWindow $DownloadISO 0
 ${NSD_SetText} $DownloadISO "Local $SomeFileExt Selected." 
 StrCpy $ISOTest "$TheISO" ; Populate ISOTest so we can enable Next 
 StrCpy $ISOFile "$TheISO" 
 ${GetFileName} "$TheISO" $JustISO
 ${GetBaseName} "$JustISO" $JustISOName
 ${GetParent} "$TheISO" $JustISOPath
 StrCpy $LocalSelection "Yes"
 Call SetISOSize
 ${If} $JustISOName == "" 
 StrCpy $JustISOName "NULL" ; Set to NULL until something is selected
 ${EndIf}
 
 ${If} ${FileExists} "$BootDir\multiboot\$JustISOName\*.*"
 ${AndIf} $JustISOName != ""
 ${AndIf} $FormatMe != "Yes"
 MessageBox MB_OK "$JustISOName is already on $DestDisk$\r$\nPlease Remove it first!"
 ${Else}
 ${EndIf}
 Call EnableNext
 ; Uncomment for Testing --> MessageBox MB_ICONQUESTION|MB_OK 'Removal: "$Removal"  ISOFileName: "$ISOFileName" ISOFile "$ISOFile" BootDir: "$BootDir" DestDisk: "$DestDisk" DestDrive: "$DestDrive" ISOTest: "$ISOTest"'
 FunctionEnd

Function ClearAll
StrCpy $ISOTest ""
StrCpy $DistroName "" ; Clear Distro Name
StrCpy $ISOFileName "" ; Clear ISO Selection
StrCpy $SomeFileExt ""
StrCpy $FileFormat ""
FunctionEnd

Function InstallorRemove ; Populate DistroName based on Install/Removal option
  ${If} $Removal == "Yes" 
  Call RemovalList
  ${Else}
   ${NSD_SetText} $LinuxDistroSelection "Step 2: Select a Distribution to put on $DestDisk" 
  Call SetISOFileName
  ${EndIf}
FunctionEnd  

; On Selection of Uninstaller Option
Function Uninstall
  ${NSD_GetState} $Uninstaller $Removal
  ${If} $Removal == ${BST_CHECKED}
  ShowWindow $Format 0
    ShowWindow $LabelISOSelection 0 
	Call ClearAll	
    EnableWindow $ISOFileTxt 0
	ShowWindow $ISOFileTxt 0
	ShowWindow $ISOSelection 0
	
    ShowWindow $CasperSelection 0
    ShowWindow $CasperSlider 0 
    ShowWindow $SlideSpot 0	
	StrCpy $Persistence "NULL" 
	
  ${NSD_Check} $Uninstaller 
  StrCpy $Removal "Yes"
  ShowWindow $DistroLink 0
  ShowWindow $DownloadISO 0
   GetDlgItem $6 $HWNDPARENT 1 ; Get "Install" control handle
	SendMessage $6 ${WM_SETTEXT} 0 "STR:Remove"
	EnableWindow $6 0 ; Disable "Install" control button
  ${NSD_SetText} $Uninstaller "You're in Uninstaller Mode!"
   ${NSD_SetText} $LinuxDistroSelection "Step 2: Select a Distribution to remove from $DestDisk"  
    SendMessage $Distro ${CB_RESETCONTENT} 0 0 ; was ${NSD_LB_Clear} $Distro "" ; Clear all distro entries because a new option may have been chosen ; Enable for DropBox
     StrCpy $Checker "Yes"   
	 Call RemovalList

  ${ElseIf} $Removal == ${BST_UNCHECKED}
   ShowWindow $Format 1  
    ShowWindow $LabelISOSelection 1 
    ShowWindow $ISOFileTxt 1
	ShowWindow $ISOSelection 0
	Call ClearAll
    ${NSD_SetText} $LabelISOSelection "Step 3: Select your $ISOFileName"
	${NSD_SetText} $ISOFileTxt "Disabled until step 2 is complete"
     GetDlgItem $6 $HWNDPARENT 1 ; Get "Install" control handle
	  SendMessage $6 ${WM_SETTEXT} 0 "STR:Create"
	  EnableWindow $6 0 ; Disable "Install" control button
  ${NSD_Uncheck} $Uninstaller  
  StrCpy $Removal "No"  
  ${NSD_SetText} $Uninstaller "View or Remove Installed Distros?" 
   ${NSD_SetText} $LinuxDistroSelection "Step 2: Select a Distribution to put on $DestDisk" 
     SendMessage $Distro ${CB_RESETCONTENT} 0 0  ; was ${NSD_LB_Clear} $Distro "" ; Clear all distro entries because a new option may have been chosen ; Enable for DropBox
     StrCpy $Checker "Yes"         
     Call SetISOFileName
  ${EndIf}  
FunctionEnd

; On Selection of USB Drive
Function OnSelectDrive
  Pop $DestDriveTxt
  ${NSD_GetText} $DestDriveTxt $Letters
  StrCpy $DestDrive "$Letters"
  StrCpy $JustDrive $DestDrive 3  
  StrCpy $BootDir $DestDrive 2 ;was -1 
  StrCpy $DestDisk $DestDrive 2 ;was -1
  SendMessage $Distro ${CB_RESETCONTENT} 0 0 ; was ${NSD_LB_Clear} $Distro "" ; Clear all distro entries because a new drive may have been chosen ; Enable for DropBox
  StrCpy $Checker "Yes" 
  Call InstallorRemove
  Call SetSpace
  Call CheckSpace
  Call FormatIt  
  Call EnableNext
 
  ${NSD_SetText} $LabelDrivePage "Step 1: You Selected $DestDisk as your USB Device"   
  
;  ${If} ${FileExists} $BootDir\menu.lst
;  ${AndIf} ${FileExists} $BootDir\syslinux.cfg
;  MessageBox MB_ICONQUESTION|MB_OK "It appears MultibootISOs was previously used on this drive? To use YUMI on this device, you must format the drive."
;  ${EndIf}
FunctionEnd

Function GetDiskVolumeName
;Pop $1 ; get parameter
System::Alloc 1024 ; Allocate string body
Pop $0 ; Get the allocated string's address

!define GetVolumeInformation "Kernel32::GetVolumeInformation(t,t,i,*i,*i,*i,t,i) i"
System::Call '${GetVolumeInformation}("$9",.r0,1024,,,,,1024)' ;

;Push $0 ; Push result
${If} $0 != ""
 StrCpy $VolName "$0"
${Else}
 StrCpy $VolName ""
${EndIf}
FunctionEnd ; GetDiskVolumeName

Function DiskSpace
${DriveSpace} "$9" "/D=T /S=G" $1 ; used to find total space of each drive
${If} $1 > "0"
 StrCpy $Capacity "$1GB"
${Else}
 StrCpy $Capacity ""
${EndIf}
FunctionEnd

Function DrivesList
 Call GetDiskVolumeName
 Call DiskSpace
 SendMessage $DestDriveTxt ${CB_ADDSTRING} 0 "STR:$9 $VolName $Capacity" 
 Push 1 ; must push something - see GetDrives documentation
FunctionEnd

Function FormatYes ; If Format is checked, do something
  ${If} $FormatMe == "Yes"
 
; Close All Open Explorer Windows 
  DetailPrint "Closing All Open Explorer Windows" 
  FindWindow $R0 CabinetWClass
  IsWindow $R0 0 +3
  SendMessage $R0 ${WM_SYSCOMMAND} 0xF060 0
  Goto -3
  
  SetShellVarContext all
  InitPluginsDir
  File /oname=$PLUGINSDIR\fat32format.exe "fat32format.exe"  
  DetailPrint "Formatting $DestDisk as Fat32 using Fat32format.exe"
  nsExec::ExecToLog '"cmd" /c "echo y|$PLUGINSDIR\fat32format -c$BlockSize $DestDisk"' ;/Q /y
  ${EndIf} 
FunctionEnd

Function FormatIt ; Set Format Option
  ${NSD_GetState} $Format $FormatMe
  ${If} $FormatMe == ${BST_CHECKED}
  ${NSD_Check} $Format
  StrCpy $FormatMe "Yes"
  ${NSD_SetText} $Format "We Will Fat32 Format $DestDisk Drive!"
    SendMessage $Distro ${CB_RESETCONTENT} 0 0 ; was ${NSD_LB_Clear} $Distro "" ; Clear all distro entries because a new format option may have been chosen ; Enable for DropBox
	ShowWindow $Uninstaller 0 ; Disable Uninstaller option because we will be formatting the drive.
    StrCpy $Checker "Yes"	
  
  ${ElseIf} $FormatMe == ${BST_UNCHECKED}
  ${NSD_Uncheck} $Format 
  ${NSD_SetText} $Format "Format $DestDisk Drive (Erase Content)?"  
    SendMessage $Distro ${CB_RESETCONTENT} 0 0 ; was ${NSD_LB_Clear} $Distro "" ; Clear all distro entries because a new format option may have been chosen ; Enable for DropBox
    ShowWindow $Uninstaller 1 ; Re-enable Uninstaller option.
	StrCpy $Checker "Yes" 
	Call SetSpace
  ${EndIf}  
    Call InstallorRemove
FunctionEnd

Function CheckSpace ; Check total available space so we can set block size
  Call TotalSpace
  ${If} $1 <= 511
  StrCpy $BlockSize 1
  ${ElseIf} $1 >= 512
  ${AndIf} $1 <= 8191
  StrCpy $BlockSize 4
  ${ElseIf} $1 >= 8192 
  ${AndIf} $1 <= 16383
  StrCpy $BlockSize 8
  ${ElseIf} $1 >= 16384
  ${AndIf} $1 <= 32767
  StrCpy $BlockSize 16
  ${ElseIf} $1 > 32768
  StrCpy $BlockSize 32
  ${EndIf}
 ; MessageBox MB_ICONSTOP|MB_OK "$0 Drive is $1 MB in size, blocksize = $BlockSize KB."  
FunctionEnd

Function TotalSpace
${DriveSpace} "$JustDrive" "/D=T /S=M" $1 ; used to find total space of select disk
 StrCpy $Capacity "$1"
FunctionEnd

Function FreeDiskSpace
${If} $FormatMe == "Yes"
${DriveSpace} "$JustDrive" "/D=T /S=M" $1
${Else}
${DriveSpace} "$JustDrive" "/D=F /S=M" $1
${EndIf}
FunctionEnd

Function SetSpace ; Set space available for persistence
  ;StrCpy $0 '$0'
  Call FreeDiskSpace
  IntOp $MaxPersist 4090 + $CasperSize ; Space required for distro and 4GB max persistent file
 ${If} $1 > $MaxPersist ; Check if more space is available than we need for distro + 4GB persistent file
  StrCpy $RemainingSpace 4090 ; Set maximum possible value to 4090 MB (any larger wont work on fat32 Filesystem)
 ${Else}
  StrCpy $RemainingSpace "$1"
  IntOp $RemainingSpace $RemainingSpace - $SizeOfCasper ; Remaining space minus distro size
 ${EndIf}
  IntOp $RemainingSpace $RemainingSpace - 1 ; Subtract 1MB so that we don't error for not having enough space
  SendMessage $CasperSlider ${TBM_SETRANGEMAX} 1 $RemainingSpace ; Re-Setting Max Value
FunctionEnd

Function HaveSpace ; Check space required
  Call CasperSize
  Call FreeDiskSpace
  System::Int64Op $1 > $SizeOfCasper ; Compare the space available > space required
  Pop $3 ; Get the result ...
  IntCmp $3 1 okay ; ... and compare it
  MessageBox MB_ICONSTOP|MB_OK "Oops: There is not enough disk space! $1 MB Free, $SizeOfCasper MB Needed on $JustDrive Drive."
  quit ; Close the program if the disk space was too small...
  okay: ; Proceed to execute...
  ;MessageBox MB_OK "ISO + Persistence will use $SizeOfCasper MB of the $1 MB Free disk space on $JustDrive Drive."  
  ;quit ; enable for testing message above
FunctionEnd

!macro DeleteMenuEntry file start stop
Push "${FILE}" ; File to search in
Push "${START}$\r$\n" ; text to start deleting from 
Push "${STOP}$\r$\n" ; text to stop at
Call DeleteMenuEntry
!macroend
!define DeleteMenuEntry "!insertmacro DeleteMenuEntry"

; DeleteMenuEntry function is based on RemoveAfterLine function, by Afrow UK http://nsis.sourceforge.net/Delete_lines_from_one_line_to_another_line_inclusive, I (Lance), simply created a macro for it.
Function DeleteMenuEntry
 Exch $1 ;end string
 Exch
 Exch $2 ;begin string
 Exch 2
 Exch $3 ;file
 Exch 2
 Push $R0
 Push $R1
 Push $R2
 Push $R3
  GetTempFileName $R2
  FileOpen $R1 $R2 w
  FileOpen $R0 $3 r
  ClearErrors
  FileRead $R0 $R3
  IfErrors Done
  StrCmp $R3 $2 +3
  FileWrite $R1 $R3
  Goto -5
  ClearErrors
  FileRead $R0 $R3
  IfErrors Done
  StrCmp $R3 $1 +4 -3
  FileRead $R0 $R3
  IfErrors Done
  FileWrite $R1 $R3
  ClearErrors
  Goto -4
Done:
   FileClose $R0
   FileClose $R1
   SetDetailsPrint none
   Delete $3
   Rename $R2 $3
   SetDetailsPrint both
 Pop $R3
 Pop $R2
 Pop $R1
 Pop $R0
 Pop $3
 Pop $2
 Pop $1
FunctionEnd

; Custom Distros Installer - Uninstaller Include
!include "InstallDistro.nsh" ; ##################################### ADD NEW DISTRO ########################################
!include "RemoveDistro.nsh" ; ##################################### ADD NEW DISTRO ########################################

Function DoSyslinux ; Install Syslinux on USB
  IfFileExists "$BootDir\multiboot\ldlinux.sys" SkipSyslinux CreateSyslinux
  CreateSyslinux:
  CreateDirectory $BootDir\multiboot\menu ; recursively create the directory structure if it doesn't exist
  CreateDirectory $BootDir\multiboot\ISOS ; create ISOS folder  
  DetailPrint $(ExecuteSyslinux)
  ExecWait '$PLUGINSDIR\syslinux.exe -maf -d /multiboot $BootDir' $R8
  DetailPrint "Syslinux Errors $R8"
  Banner::destroy
  ${If} $R8 != 0
  MessageBox MB_ICONEXCLAMATION|MB_OK $(WarningSyslinux)
  ${EndIf} 
  DetailPrint "Creating Label MULTIBOOT on $DestDisk"
  nsExec::ExecToLog '"cmd" /c "LABEL $DestDiskMULTIBOOT"'
  
  SkipSyslinux: 
  DetailPrint $(SkipSyslinux)
  
  ${If} ${FileExists} $BootDir\multiboot\syslinux.cfg  
   DetailPrint "A Previous MultiBoot Installation was detected... proceeding to add your new selections."
   Call AddDir
  ${Else}
; Create and Copy files to your destination
  DetailPrint "Adding required files to the $BootDir\multiboot directory..." 
  CopyFiles "$PLUGINSDIR\syslinux.cfg" "$BootDir\multiboot\syslinux.cfg"
  CopyFiles "$PLUGINSDIR\yumi.png" "$BootDir\multiboot\yumi.png"
  CopyFiles "$PLUGINSDIR\YUMI-Copying.txt" "$BootDir\multiboot\YUMI-Copying.txt" 
  CopyFiles "$PLUGINSDIR\YUMI-Readme.txt" "$BootDir\multiboot\YUMI-Readme.txt" 
  CopyFiles "$PLUGINSDIR\license.txt" "$BootDir\multiboot\license.txt"   
  CopyFiles "$PLUGINSDIR\vesamenu.c32" "$BootDir\multiboot\vesamenu.c32"
  CopyFiles "$PLUGINSDIR\menu.c32" "$BootDir\multiboot\menu.c32"  
  CopyFiles "$PLUGINSDIR\chain.c32" "$BootDir\multiboot\chain.c32"
  CopyFiles "$PLUGINSDIR\memdisk" "$BootDir\multiboot\memdisk"   
  CopyFiles "$PLUGINSDIR\libcom32.c32" "$BootDir\multiboot\libcom32.c32"	
  CopyFiles "$PLUGINSDIR\libutil.c32" "$BootDir\multiboot\libutil.c32"	
; Copy these files to multiboot\menu
  DetailPrint "Adding required files to the $BootDir\multiboot\menu directory..." 
  CopyFiles "$PLUGINSDIR\vesamenu.c32" "$BootDir\multiboot\menu\vesamenu.c32"
  CopyFiles "$PLUGINSDIR\menu.c32" "$BootDir\multiboot\menu\menu.c32"  
  CopyFiles "$PLUGINSDIR\chain.c32" "$BootDir\multiboot\menu\chain.c32"
  CopyFiles "$PLUGINSDIR\memdisk" "$BootDir\multiboot\menu\memdisk"   
  CopyFiles "$PLUGINSDIR\libcom32.c32" "$BootDir\multiboot\menu\libcom32.c32"	
  CopyFiles "$PLUGINSDIR\libutil.c32" "$BootDir\multiboot\menu\libutil.c32"
  
  Call AddDir    
  ${EndIf}  
  
  ${IfNot} ${FileExists} $BootDir\multiboot\menu\vesamenu.c32
; Copy these files to multiboot\menu
  DetailPrint "Adding required files to the $BootDir\multiboot\menu directory..." 
  CopyFiles "$PLUGINSDIR\vesamenu.c32" "$BootDir\multiboot\menu\vesamenu.c32"
  CopyFiles "$PLUGINSDIR\menu.c32" "$BootDir\multiboot\menu\menu.c32"  
  CopyFiles "$PLUGINSDIR\chain.c32" "$BootDir\multiboot\menu\chain.c32"
  CopyFiles "$PLUGINSDIR\memdisk" "$BootDir\multiboot\menu\memdisk"
  CopyFiles "$PLUGINSDIR\libcom32.c32" "$BootDir\multiboot\menu\libcom32.c32"	
  CopyFiles "$PLUGINSDIR\libutil.c32" "$BootDir\multiboot\menu\libutil.c32"  
  ${EndIf}    

; Check to ensure menu.c32 exists... now required for YUMI V2
  ${IfNot} ${FileExists} $BootDir\multiboot\menu.c32
   DetailPrint "Adding menu.c32. Required for YUMI V2"
   CopyFiles "$PLUGINSDIR\menu.c32" "$BootDir\multiboot\menu.c32"
   CopyFiles "$PLUGINSDIR\libcom32.c32" "$BootDir\multiboot\menu\libcom32.c32"	
   CopyFiles "$PLUGINSDIR\libutil.c32" "$BootDir\multiboot\menu\libutil.c32" 
  ${EndIf}	  
FunctionEnd

Function AddDir ; changes to check if user had a version prior to 0.0.0.3 which now includes grub.exe 
 ${IfNotThen} ${FileExists} "$BootDir\multiboot\grub.exe" 'CopyFiles "$PLUGINSDIR\grub.exe" "$BootDir\multiboot\grub.exe"' 
; Windows/Ubuntu SOURCES conflict fix
 ${IfNot} ${FileExists} $BootDir\.disk\info 
  CreateDirectory $BootDir\.disk 
  CopyFiles "$PLUGINSDIR\info" "$BootDir\.disk\info"
 ${EndIf} 
FunctionEnd

; ---- Let's Do This Stuff ----
Section  ; This is the only section that exists
; Get just the name of the ISO file 
Push "$ISOFile"
Push 1
Call GrabNameOnly
Pop $NameThatISO

 ${If} ${FileExists} "$BootDir\windows\system32" ; additional safeguard to protect from potential user ignorance. 
 MessageBox MB_ICONSTOP|MB_OK "ABORTING! ($DestDisk) contains a WINDOWS/SYSTEM32 Directory."
 Quit
 ${EndIf}
 
 ${If} $FormatMe == "Yes" 
 MessageBox MB_YESNO|MB_ICONEXCLAMATION "${NAME} is Ready to perform the following actions:$\r$\n$\r$\n1. Close Open Explorer Windows - Allows ($DestDisk) to be Fat32 Formatted!$\r$\n$\r$\n2. Fat32 Format ($DestDisk) - All Data will be Irrecoverably Deleted!$\r$\n$\r$\n3. Create a Syslinux MBR on ($DestDisk) - Existing MBR will be Overwritten!$\r$\n$\r$\n4. Create MULTIBOOT Label on ($DestDisk) - Existing Label will be Overwritten!$\r$\n$\r$\n5. Install ($DistroName) on ($DestDisk)$\r$\n$\r$\nAre you absolutely positive Drive ($DestDisk) is your USB Device?$\r$\nDouble Check with Windows (My Computer) to make sure!$\r$\n$\r$\nClick YES to perform these actions on ($DestDisk) or NO to Go Back!" IDYES proceed
 Quit
 ${ElseIf} $FormatMe != "Yes" 
 ${AndIfNot} ${FileExists} $BootDir\multiboot\syslinux.cfg
 MessageBox MB_YESNO|MB_ICONEXCLAMATION "${NAME} is Ready to perform the following actions:$\r$\n$\r$\n1. Create a Syslinux MBR on ($DestDisk) - Existing MBR will be Overwritten!$\r$\n$\r$\n2. Create MULTIBOOT Label on ($DestDisk) - Existing Label will be Overwritten!$\r$\n$\r$\n3. Install ($DistroName) on ($DestDisk)$\r$\n$\r$\nAre you absolutely positive Drive ($DestDisk) is your USB Device?$\r$\nDouble Check with Windows (My Computer) to make sure!$\r$\n$\r$\nClick YES to perform these actions on ($DestDisk) or NO to Go Back!" IDYES proceed
 Quit
 ${EndIf}

proceed: 
 ${IfThen} $Removal == "Yes" ${|} Goto removeonly ${|}
 Call HaveSpace ; Got enough Space? Lets Check!
 Call FormatYes ; Format the Drive?
 Call DoSyslinux ; Run Syslinux on the Drive to make it bootable
 Call LocalISODetected
 
; Copy the config file if it doesn't exist and create the entry in syslinux.cfg 
 ${IfNot} ${FileExists} "$BootDir\multiboot\menu\$Config2Use" 
 CopyFiles "$PLUGINSDIR\$Config2Use" "$BootDir\multiboot\menu\$Config2Use"
 Call Config2Write
 ${EndIf} 
 
removeonly:
 ${If} $Removal != "Yes"
 !insertmacro Install_Distros ; Install those distros
 ${ElseIf} $Removal == "Yes"
  Call ConfigRemove
 !insertmacro Uninstall_Distros ; Remove those distros
 ${EndIf}
 
SectionEnd

Function ConfigRemove ; Find and Set Removal Configuration file
  ${If} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\linux.cfg"
  StrCpy $Config2Use "linux.cfg"
  ${ElseIf} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\system.cfg"
  StrCpy $Config2Use "system.cfg"
  ${ElseIf} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\antivirus.cfg"
  StrCpy $Config2Use "antivirus.cfg"
  ${ElseIf} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\netbook.cfg"
  StrCpy $Config2Use "netbook.cfg"
  ${ElseIf} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\other.cfg"
  StrCpy $Config2Use "other.cfg"
  ${ElseIf} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\unlisted.cfg"
  StrCpy $Config2Use "unlisted.cfg"  
  ${ElseIf} ${FileExists} "$BootDir\multiboot\$DistroName\YUMI\menu.lst"
  StrCpy $Config2Use "menu.lst"
  ${EndIf}
  ; MessageBox MB_OK "$Config2Use"
FunctionEnd

Function Config2Write
 ${If} $Config2Use == "linux.cfg"
  ${WriteToSysFile} "label Linux Distributions$\r$\nmenu label Linux Distributions ->$\r$\nMENU INDENT 1$\r$\nCONFIG /multiboot/menu/linux.cfg" $R0 
 ${ElseIf} $Config2Use == "system.cfg"
  ${WriteToSysFile} "label System Tools$\r$\nmenu label System Tools ->$\r$\nMENU INDENT 1$\r$\nCONFIG /multiboot/menu/system.cfg" $R0
 ${ElseIf} $Config2Use == "antivirus.cfg"
  ${WriteToSysFile} "label Antivirus Tools$\r$\nmenu label Antivirus Tools ->$\r$\nMENU INDENT 1$\r$\nCONFIG /multiboot/menu/antivirus.cfg" $R0 
 ${ElseIf} $Config2Use == "netbook.cfg"
  ${WriteToSysFile} "label Netbook Distributions$\r$\nmenu label Netbook Distributions ->$\r$\nMENU INDENT 1$\r$\nCONFIG /multiboot/menu/netbook.cfg" $R0 
 ${ElseIf} $Config2Use == "other.cfg"
  ${WriteToSysFile} "label Other OS and Tools$\r$\nmenu label Other OS and Tools ->$\r$\nMENU INDENT 1$\r$\nCONFIG /multiboot/menu/other.cfg" $R0 
 ${ElseIf} $Config2Use == "unlisted.cfg"
  ${WriteToSysFile} "label Unlisted ISO (via SYSLINUX)$\r$\nmenu label  Unlisted ISO (via SYSLINUX) ->$\r$\nMENU INDENT 1$\r$\nCONFIG /multiboot/menu/unlisted.cfg" $R0  
 ${ElseIf} $Config2Use == "menu.lst"
  ${WriteToSysFile} "label GRUB Bootable ISOs$\r$\nmenu label GRUB Bootable ISOs or Windows XP ->$\r$\nMENU INDENT 1$\r$\nKERNEL /multiboot/grub.exe$\r$\nAPPEND --config-file=/multiboot/menu/menu.lst" $R0 
  CopyFiles "$PLUGINSDIR\yumi.xpm.gz" "$BootDir\multiboot\menu\yumi.xpm.gz" 
 ${EndIf} 
FunctionEnd

Function NoQuit
MessageBox MB_YESNO "Would you like to add more ISOs/Distros Now on $DestDisk?" IDYES noskip
    StrCmp $R8 3 0 End ;Compare $R8 variable with current page #
    StrCpy $R9 1 ; Goes to finish page
    Call RelGotoPage
    Abort
noskip:
StrCpy $ShowAll "$ShowAll" ; Retain Display All Drives
StrCpy $DestDrive "$DestDrive" ; Retain previously selected Drive Letter
StrCpy $RepeatInstall "YES" ; Set Repeat Install Option to YES
StrCpy $ISOTest "" ; Reset
StrCpy $ISOFile "" ; Reset
StrCpy $Removal "" ; Reset
StrCpy $Persistence "NULL" ; Reset
StrCpy $NameThatISO "" ; Reset NameThatISO ISO Name
StrCpy $Config2Use "" ; Clear Config File to create and write to
StrCpy $DistroName "" ; Clear Distro Name
StrCpy $ISOFileName "" ; Clear ISO Selection
StrCpy $FileFormat "" ; Clear File Format
StrCpy $DownloadMe 0 ; Ensure Uncheck of Download Option
StrCpy $LocalSelection "" ; Reset Local Selection
StrCpy $FormatMe "" ; Reset Format Option
    StrCmp $R8 4 0 End ;Compare $R8 variable with current page #
    StrCpy $R9 -3 ; Goes back to selections page
    Call RelGotoPage ; change pages
    Abort
End:
FunctionEnd

Function RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

; --- Stuff to do at startup of script ---
Function .onInit
StrCpy $R9 0 ; we start on page 0
;StrCpy $InstallButton ""
 StrCpy $FileFormat "ISO"
 userInfo::getAccountType
 Pop $Auth
 strCmp $Auth "Admin" done
 Messagebox MB_OK|MB_ICONINFORMATION "Currently you're trying to run this program as: $Auth$\r$\n$\r$\nYou must run this program with administrative rights...$\r$\n$\r$\nRight click the file and select Run As Administrator or Run As (and select an administrative account)!"
 Abort
 done:
 SetShellVarContext all
 InitPluginsDir
;  File /oname=$PLUGINSDIR\paypal.bmp "paypal.bmp"   
  File /oname=$PLUGINSDIR\syslinux.exe "syslinux.exe"  
  File /oname=$PLUGINSDIR\syslinux.cfg "syslinux.cfg"
  File /oname=$PLUGINSDIR\menu.lst "menu.lst" 
  File /oname=$PLUGINSDIR\yumi.xpm.gz "yumi.xpm.gz" 
  File /oname=$PLUGINSDIR\grub.exe "grub.exe"  
  File /oname=$PLUGINSDIR\info "menu\info"   
  File /oname=$PLUGINSDIR\antivirus.cfg "menu\antivirus.cfg" 
  File /oname=$PLUGINSDIR\system.cfg "menu\system.cfg" 
  File /oname=$PLUGINSDIR\netbook.cfg "menu\netbook.cfg"
  File /oname=$PLUGINSDIR\linux.cfg "menu\linux.cfg" 
  File /oname=$PLUGINSDIR\other.cfg "menu\other.cfg"   
  File /oname=$PLUGINSDIR\unlisted.cfg "menu\unlisted.cfg"   
  File /oname=$PLUGINSDIR\liveusb "liveusb"   
  File /oname=$PLUGINSDIR\7zG.exe "7zG.exe"
  File /oname=$PLUGINSDIR\7z.dll "7z.dll"  
  File /oname=$PLUGINSDIR\yumi.png "yumi.png"
  File /oname=$PLUGINSDIR\YUMI-Copying.txt "YUMI-Copying.txt" 
  File /oname=$PLUGINSDIR\YUMI-Readme.txt "YUMI-Readme.txt" 
  File /oname=$PLUGINSDIR\license.txt "license.txt"   
  File /oname=$PLUGINSDIR\vesamenu.c32 "vesamenu.c32" 
  File /oname=$PLUGINSDIR\menu.c32 "menu.c32"    
  File /oname=$PLUGINSDIR\memdisk "memdisk" 
  File /oname=$PLUGINSDIR\chain.c32 "chain.c32"
  File /oname=$PLUGINSDIR\libcom32.c32 "libcom32.c32" 
  File /oname=$PLUGINSDIR\libutil.c32 "libutil.c32" 
FunctionEnd

Function onNotify_CasperSlider
 Pop $Casper
 SendMessage $CasperSlider ${TBM_GETPOS} 0 0 $Casper ; Get Trackbar position
 ${NSD_SetText} $SlideSpot "$Casper MB"
FunctionEnd

Function SetISOSize ; Get size of ISO
 System::Call 'kernel32::CreateFile(t "$TheISO", i 0x80000000, i 1, i 0, i 3, i 0, i 0) i .r0'
 System::Call "kernel32::GetFileSizeEx(i r0, *l .r1) i .r2"
 System::Alloc $1
 System::Int64Op $1 / 1048576 ; convert to MB
 Pop $1
 StrCpy $SizeOfCasper "$1"
 ;MessageBox MB_OK|MB_ICONINFORMATION "ISO Size: $SizeOfCasper"
 System::Call 'kernel32::CloseHandle(i r0)'
FunctionEnd
