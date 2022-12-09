@echo off
set "version=0.3"
title Revision Tool v%version%
call :IsAdmin

for /f "tokens=2 delims==" %%i in ('wmic os get BuildNumber /value ^| find "="') do set "build=%%i"
if %build% gtr 19045 (
	set "w11=y"
)
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:Start11
cls
echo.========================================================================================
echo.
echo.	Revision Tool - ReviOS 11
echo.
echo.	Press [1] to enable/disable Windows Defender
echo.	Press [2] to enable/disable Superfetch
echo.	Press [3] to enable/disable Windows Updates features
echo.
echo.	Press [4] to enable/disable UAC
echo.	Press [5] to enable/disable Notifications
echo.	Press [6] to enable/disable Inking And Typing Personalization
echo.
echo.	Press [7] to enable/disable Full Screen Optimizations
echo.	Press [8] to install VC Runtimes
echo.	Press [9] for additional Windows 11 tweaks
echo.
echo.	Press [X] to quit
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice:
if '%choice%'=='9' goto :Win11
if '%choice%'=='8' goto :VC
if '%choice%'=='7' goto :FSO
if '%choice%'=='6' goto :ITP
if '%choice%'=='5' goto :Notifications
if '%choice%'=='4' goto :UAC
if '%choice%'=='3' goto :WU
if '%choice%'=='2' goto :SF
if '%choice%'=='1' goto :WD
if '%choice%'=='' goto :Start11
if '%choice%'==' ' goto :Start11
if '%choice%'=='x' goto :Quit


:Start10
cls
echo.========================================================================================
echo.
echo.	Revision Tool - ReviOS 10
echo.
echo.	Press [1] to enable/disable Windows Defender
echo.	Press [2] to enable/disable Superfetch
echo.	Press [3] to enable/disable Windows Updates features
echo.
echo.	Press [4] to enable/disable UAC
echo.	Press [5] to enable/disable Notifications
echo.	Press [6] to enable/disable Inking And Typing Personalization
echo.
echo.	Press [7] to enable/disable Full Screen Optimizations
echo.	Press [8] to install VC Runtimes
echo.
echo.	Press [X] to quit
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='8' goto :VC
if '%choice%'=='7' goto :FSO
if '%choice%'=='6' goto :ITP
if '%choice%'=='5' goto :Notifications
if '%choice%'=='4' goto :UAC
if '%choice%'=='3' goto :WU
if '%choice%'=='2' goto :SF
if '%choice%'=='1' goto :WD
if '%choice%'=='' goto :Start10
if '%choice%'==' ' goto :Start10
if '%choice%'=='x' goto :Quit

:WD
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\ControlSet001\Services\WdBoot" /v "Start"') do (
		set "wdDwordStatus=%%i"
		if %%i==0x4 (
			set "wdStatus=Disabled"
		) else (
			set "wdStatus=Enabled"
		)
)
echo.========================================================================================
echo.	
echo.	Windows Defender
echo.	Current State: [%wdStatus%]
echo.
echo.	Press [1] to enable Windows Defender
echo.	Press [2] to disable Windows Defender [Default]
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='2' goto :DisableWD
if '%choice%'=='1' goto :EnableWD
if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:EnableWD
@start /b "Revision - Enable WinDefend - TrustedInstaller" "%~dp0bin\NSudoLG.exe" -U:T -P:E "%~dp0bin\EnableWD.bat"
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:DisableWD
@start /b "Revision - Disable WinDefend - TrustedInstaller" "%~dp0bin\NSudoLG.exe" -U:T -P:E "%~dp0bin\DisableWD.bat"
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:SF
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\ControlSet001\Services\rdyboost" /v "Start"') do (
		set "sfDwordStatus=%%i"
		if %%i==0x4 (
			set "sfStatus=Disabled"
		) else (
			set "sfStatus=Enabled"
		)
)

for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "isMemoryCompressionEnabled"') do (
		set "mcDwordStatus=%%i"
		if %%i==0x0 (
			set "mcState=enable"
			set "mcString=Disabled"
		) else (
			set "mcState=disable"
			set "mcString=Enabled"
		)
)
echo.========================================================================================
echo.
echo.	Superfetch is disabled in ReviOS, due to causing high latency issues
echo.
echo.	Enabling Superfetch is only recommended for HDD users
echo.	Memory Compression could be also useful for hardwares with low memory and HDD
echo.
echo.	Warning: Enabling Superfetch doesn't enable Memory Compression
echo.
echo.
echo.	Superfetch status: [%sfStatus%]
echo.	Press [1] to enable Superfetch
echo.	Press [2] to disable Superfetch [Default]
echo.
echo.	Press [3] to %mcState% Memory Compression [%mcString%]
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='3' (if %sfDwordStatus%==0x4 (
	cls
	echo Enable Superfetch first.
	pause
	goto :SF
) else (goto :MemoryCompression))
if '%choice%'=='2' goto :DisableSF
if '%choice%'=='1' goto :EnableSF
if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:EnableSF
cls
@start /b "Revision - Enable Superfetch - TrustedInstaller" "%~dp0bin\NSudoLG.exe" -U:T -P:E "%~dp0bin\EnableSF.bat"
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:DisableSF
cls
@start /b "Revision - Disable Superfetch - TrustedInstaller" "%~dp0bin\NSudoLG.exe" -U:T -P:E "%~dp0bin\DisableSF.bat"
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:MemoryCompression
cls
if %mcDwordStatus%==0x0 (
	::enable
	PowerShell -NonInteractive -NoLogo -NoProfile -Command "Enable-MMAgent -mc" >NUL 2>nul
	reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "isMemoryCompressionEnabled" /t REG_DWORD /d "1" /f
	echo Memory Compression has enabled successfuly.
) else (
	::disable
	PowerShell -NonInteractive -NoLogo -NoProfile -Command "Disable-MMAgent -mc" >NUL 2>nul
	reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "isMemoryCompressionEnabled" /t REG_DWORD /d "0" /f
	echo Memory Compression has disabled successfuly.
)
pause
goto :SF


:WU
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "IsWUHidden"') do (
		set "wuDwordStatus=%%i"
		
		if %%i==0x1 (
			set "wuString=Hidden"
			set "wuCurrentState=unhide"
		) else (
			set "wuString=Not hidden"
			set "wuCurrentState=hide"
		)
)
for /f "tokens=3*" %%i in ('reg query "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate"') do (
		set "wuDriversDwordStatus=%%i"
		
		if %%i==0x1 (
			set "wuDriversString=Disabled"
			set "wuDriversCurrentState=enable"
		) else (
			set "wuDriversString=Enabled"
			set "wuDriversCurrentState=disable"
		)
)
echo.========================================================================================
echo.
echo.	Windows Updates
echo.
echo.	Press [1] to %wuCurrentState% Windows Updates [%wuString%]
echo.	Press [2] to %wuDriversCurrentState% automatic drivers updating [%wuDriversString%]
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='2' goto :WUDriversMode
if '%choice%'=='1' goto :WUSettingsMode

if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:WUSettingsMode
cls
if %wuDwordStatus%==0x1 (
	::unhide
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:cortana;privacy-automaticfiledownloads;privacy-feedback" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "IsWUHidden" /t REG_DWORD /d "0" /f
	taskkill /im explorer.exe /f
	start explorer.exe
	echo Windows Updates is now available in Settings
) else (
	::hide
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "SettingsPageVisibility" /t REG_SZ /d "hide:cortana;privacy-automaticfiledownloads;privacy-feedback;windowsinsider;windowsupdate" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "IsWUHidden" /t REG_DWORD /d "1" /f
	taskkill /im explorer.exe /f
	start explorer.exe
	echo Windows Updates is now hidden!
)
pause
goto :WU

:WUDriversMode
cls
::Disable
if %wuDriversDwordStatus%==0x1 (
	if %wuDwordStatus%==0x0 (
	::enable
	reg add "HKCU\Software\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "0" /f
	reg add "HKLM\Software\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "0" /f
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "0" /f
	echo Automatic drivers installing has enabled successfuly!
	) else (
echo Somthing is wrong, Windows Updates section must be enabled
	)
	
) else (
	::disable
	reg add "HKCU\Software\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f
	reg add "HKLM\Software\Policies\Microsoft\Windows\DriverSearching" /v "DontPromptForWindowsUpdate" /t REG_DWORD /d "1" /f
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f
	echo Automatic drivers installing has disabled successfuly!
)
pause
goto :WU

:UAC
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA"') do (
		set "UACDwordStatus=%%i"
		if %%i==0x1 (
			set "UACString=Enabled"
		) else (
			set "UACString=Disabled"
		)
)
echo.========================================================================================
echo.
echo.	Disabling UAC results in all applications being run as admin at all times
echo.	and removes the elevation prompt that pops up, asking for your permissions.
echo.
echo.	Current State: [%UACString%]
echo.	
echo.	Press [1] to enable UAC [Default]
echo.	Press [2] to disable UAC
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='2' goto :DisableUAC
if '%choice%'=='1' goto :EnableUAC
if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:EnableUAC
cls
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableVirtualization" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableInstallerDetection" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableSecureUIAPaths" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ValidateAdminCodeSignatures" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableUIADesktopToggle" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "3" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d "0" /f
echo UAC has enabled successfuly. Please restart your PC.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:DisableUAC
cls
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableVirtualization" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableInstallerDetection" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableSecureUIAPaths" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ValidateAdminCodeSignatures" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableUIADesktopToggle" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "FilterAdministratorToken" /t REG_DWORD /d "0" /f
echo UAC has disabled successfuly. Please restart your PC.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:Notifications
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "IsNotificationsEnabled"') do (
		set "notifDwordStatus=%%i"
		if %%i==0x1 (
			set "notifString=Enabled"
		) else (
			set "notifString=Disabled"
		)
)
echo.========================================================================================
echo.
echo.	Disabling Push Notifications System will prevent programs from receiving notifications.
echo.
echo.	Current State: [%notifString%]
echo.
echo.	
echo.	Press [1] to enable Notifications [Default]
echo.	Press [2] to disable Notifications
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='2' goto :DisableNotifications
if '%choice%'=='1' goto :EnableNotifications
if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:EnableNotifications
cls
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_TOASTS_ENABLED" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /f
reg delete "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f
reg delete "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /f
::
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "IsNotificationsEnabled" /t REG_DWORD /d "1" /f
taskkill /im explorer.exe /f
start explorer.exe
echo Notifications has enabled successfuly.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:DisableNotifications
cls
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_TOASTS_ENABLED" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f
::
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "IsNotificationsEnabled" /t REG_DWORD /d "0" /f
taskkill /im explorer.exe /f
start explorer.exe
echo Notifications has disabled successfuly.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:ITP
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization"') do (
		set "itpDwordStatus=%%i"
		if %%i==0x1 (
			set "itpStatus=Enabled"
		) else (
			set "itpStatus=Disabled"
		)
)
echo.========================================================================================
echo.
echo.	This includes Automatic learning, user dictionary as well as the ability to toggle it in Windows Settings.
echo.
echo.	You may need to configure text/typing suggestions in Settings - Devices - Typing
echo.
echo.	Current State: [%itpStatus%]
echo.
echo.	Press [1] to enable Inking And Typing Personalization
echo.	Press [2] to disable Inking And Typing Personalization [Default]
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='2' goto :DisableITP
if '%choice%'=='1' goto :EnableITP
if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:EnableITP
cls
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "1" /f
echo Inking And Typing Personalization has enabled successfuly. Please restart your PC.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:DisableITP
cls
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f
echo Inking And Typing Personalization has disabled successfuly. Please restart your PC.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:FSO
cls
for /f "tokens=3*" %%i in ('reg query "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode"') do (
		set "fsoDwordStatus=%%i"
		if %%i==0x2 (
			set "fsoStatus=Disabled"
		) else (
			set "fsoStatus=Enabled"
		)
)
echo.========================================================================================
echo.
echo.	From ReviOS 10 22.06, FSO became enabled by default as it has
echo.	significant improvements in newer Windows 10 and 11 builds
echo.
echo.	If you find that you are having trouble with Full Screen Optimizations,
echo.	such as performance regression or input lag, we give you an opportunity to disable it
echo.
echo.	Current State: [%fsoStatus%]
echo.
echo.	Press [1] to enable Full Screen Optimizations
echo.	Press [2] to disable Full Screen Optimizations
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='2' goto :DisableFSO
if '%choice%'=='1' goto :EnableFSO
if '%choice%'=='' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'==' ' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))
if '%choice%'=='x' (if '%w11%'=='y' (goto :Start11) else (goto :Start10))

:EnableFSO
cls
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "0" /f
reg delete "HKCU\System\GameConfigStore" /v "Win32_AutoGameModeDefaultProfile" /f
reg delete "HKCU\System\GameConfigStore" /v "Win32_GameModeRelatedProcesses" /f
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /f
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /f
reg delete "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /f

reg add "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "0" /f
reg delete "HKU\.DEFAULT\System\GameConfigStore" /v "Win32_AutoGameModeDefaultProfile" /f
reg delete "HKU\.DEFAULT\System\GameConfigStore" /v "Win32_GameModeRelatedProcesses" /f
reg delete "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /f
reg delete "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /f
reg delete "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /f
echo FSO has enabled successfuly. Please restart your PC.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:DisableFSO
cls
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f
reg add "HKCU\System\GameConfigStore" /v "Win32_AutoGameModeDefaultProfile" /t REG_BINARY /d "01000100000000000000000000000000000000000000000000000000000000000000000000000000" /f
reg add "HKCU\System\GameConfigStore" /v "Win32_GameModeRelatedProcesses" /t REG_BINARY /d "010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "Win32_AutoGameModeDefaultProfile" /t REG_BINARY /d "01000100000000000000000000000000000000000000000000000000000000000000000000000000" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "Win32_GameModeRelatedProcesses" /t REG_BINARY /d "010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f
reg add "HKU\.DEFAULT\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f
echo FSO has disabled successfuly. Please restart your PC.
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)

:VC
cls
if exist "%localappdata%\Microsoft\WindowsApps\winget.exe" (
	winget install --id Microsoft.CLRTypesSQLServer.2019 -e
	winget install --id Microsoft.VC++2005Redist-x64 -e
	winget install --id Microsoft.VC++2005Redist-x86 -e
	winget install --id Microsoft.VC++2008Redist-x64 -e
	winget install --id Microsoft.VC++2008Redist-x86 -e
	winget install --id Microsoft.VC++2010Redist-x64 -e
	winget install --id Microsoft.VC++2010Redist-x86 -e
	winget install --id=Microsoft.VC++2012Redist-x86 -e
	winget install --id=Microsoft.VC++2012Redist-x64 -e
	winget install --id=Microsoft.VC++2013Redist-x86 -e
	winget install --id=Microsoft.VC++2013Redist-x64 -e
	winget install --id Microsoft.VC++2015-2022Redist-x64 -e
	winget install --id Microsoft.VC++2015-2022Redist-x86 -e
) else (
	echo Winget wasn't found. Open Microsoft Store, go to Library, check for updates and update App Installer.
)
pause
if '%w11%'=='y' (goto :Start11) else (goto :Start10)


:Win11
cls
for /f "tokens=3*" %%i in ('reg query "HKLM\Software\Classes\CLSID" /v "IsModernRCEnabled"') do (
		set "rcDwordStatus=%%i"
		
		if %%i==0x1 (
			set "rcString=Enabled"
			set "rclickCurrentState=disable"
		) else (
			set "rcString=Disabled"
			set "rclickCurrentState=enable"
		)
)
for /f "tokens=3*" %%i in ('reg query "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\1931258509" /v "EnabledState"') do (
		set "fetDwordStatus=%%i"
		
		if %%i==0x2 (
			set "fetString=Enabled"
			set "fetCurrentState=disable"
		) else (
			set "fetString=Disabled"
			set "fetCurrentState=enable"
		)
)
echo.========================================================================================
echo.
echo.	Additional Windows 11 tweaks
echo.
echo.	Press [1] to %rclickCurrentState% new right-click menu [%rcString%]
echo.	Press [2] to %fetCurrentState% tabs in File Explorer [%fetString%]
echo.
echo.	Press [X] to return to main menu
echo.
echo.========================================================================================
set choice=
set /p choice=Enter Your Choice: 
if '%choice%'=='x' goto :Start11
if '%choice%'=='2' goto :fet11
if '%choice%'=='1' goto :rcmenu11
if '%choice%'=='' goto :Start11
if '%choice%'==' ' goto :Start11


:rcmenu11
cls
if %rcDwordStatus%==0x1 (
	::disable
	reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f
	reg add "HKLM\Software\Classes\CLSID" /v "IsModernRCEnabled" /t REG_DWORD /d "0" /f
	taskkill /im explorer.exe /f
	start explorer.exe
	echo The new right-click menu has disabled successfuly
) else (
	::enable
	reg add "HKLM\Software\Classes\CLSID" /v "IsModernRCEnabled" /t REG_DWORD /d "1" /f
	reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
	taskkill /im explorer.exe /f
	start explorer.exe
	echo The new right-click menu has enabled successfuly
)
pause
goto :Win11

:fet11
cls
if %fetDwordStatus%==0x2 (
	::disable
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\1931258509" /v "EnabledState" /t REG_DWORD /d "1" /f
	reg delete "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\248140940" /f
	reg delete "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2733408908" /f
	echo The new file explorer tabs has disabled successfuly, please restart your PC!
) else (
	::enable
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\1931258509" /v "EnabledState" /t REG_DWORD /d "2" /f
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\1931258509" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\248140940" /v "EnabledState" /t REG_DWORD /d "2" /f
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\248140940" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2733408908" /v "EnabledState" /t REG_DWORD /d "2" /f
	reg add "HKLM\SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\4\2733408908" /v "EnabledStateOptions" /t REG_DWORD /d "1" /f
	echo The new file explorer tabs has enabled successfuly, please restart your PC!
)
pause
goto :Win11

:IsAdmin
reg query "HKU\S-1-5-19\Environment" >NUL
if not %errorlevel% equ 0 (
 cls & echo You must have administrator rights to continue ... 
 pause & exit
)
cls
goto :EOF


:EOF