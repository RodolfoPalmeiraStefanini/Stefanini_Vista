@md "%programfiles%\UHG\UHG_CC_Config"
@md "c:\users\Default\Appdata\Roaming\avaya"
@md "C:\Users\Default\AppData\Roaming\avaya\Avaya Agent"
@md "C:\Users\Default\AppData\Roaming\avaya\one-X Agent"

@cls
@ECHO INSTALADOR DE APLICATIVOS PERFIL AGENTE
@ECHO CRIADO POR SANDRO GOBI DOS SANTOS
@ECHO CONTATO: SAGOBI@UHGBRASIL.COM.BR
@ECHO DATA DE CRIACAO: 30/06/2016
@ECHO DATA DE MODIFICACAO: 29/05/2022
@ECHO VERSAO 4 (WINDOWS 10 - OFFLINE VERSION)

@ECHO PARTE 1 DE 3 - INSTALANDO OS PRE-REQUISITOS

@cd\temp\AGENTE4
@msiexec /i "C:\Temp\AGENTE4\PREREQ\jre1.8.0_171.msi" /qb
@"C:\Temp\AGENTE4\PREREQ\Runtime C2010 x86.exe" /passive /norestart
@"C:\Temp\AGENTE4\PREREQ\Runtime C2012 x86.exe" /install /passive /quiet
@Wusa "C:\Temp\AGENTE4\PREREQ\Windows6.1-KB2653312-x64.msu" /norestart /quiet
@echo Instalando .Net Framework
dism.exe /online /enable-feature /featurename:NetFX3 /All /Source:C:\Temp\AGENTE4\AJUSTES\NF3 /LimitAccess
@c:\Temp\AGENTE4\PREREQ\OpenOffice.exe /S /v /qb
@msiexec /i c:\Temp\AGENTE4\PREREQ\MsgViewer.msi /qn


@ECHO PARTE 2 DE 3 - INSTALANDO ONE-X, AGENT FOR DESKTOP E WFO

@C:\Temp\AGENTE4\AAFD\AAFD.exe /silent
@msiexec.exe /i "C:\Temp\AGENTE4\ONEX\OneXAgentWIXSetup.msdb" INSTALL_PT_BR=1 TRANSFORMS="C:\Temp\AGENTE4\ONEX\pt-BR.mst" /norestart /qb
@msiexec.exe /update "C:\Temp\AGENTE4\ONEX\PATCH.msp" /qb

REM WFO ANTIGO
rem @msiexec /i "C:\Temp\AGENTE4\WFO\DesktopResourcesAvaya.msi" /qb
rem @msiexec /i "C:\Temp\AGENTE4\WFO\DesktopConnectionManager.msi" SERVERADDR=AMLAPSW0PR0002 /qb
rem @msiexec /i "C:\Temp\AGENTE4\WFO\DMSClientInstall.msi" /qb
rem @msiexec /i "C:\Temp\AGENTE4\WFO\Screen_Capture_Module.msi" INTG_SERVERS=AMLAPSL0PR0021:29522,AMLAPSL0PR0023:29522 CONN_INTG_SVC=TRUE /qb
rem @msiexec /i "C:\Temp\AGENTE4\WFO\PlaybackInstallation.msi" ADDSOURCE=MultimediaSupportPackage,Playback /qb

REM NOVO WFO - CCaaS
@msiexec.exe /i "C:\Temp\AGENTE4\1_Desktop_Resources.msi" /qb
@msiexec.exe /i "C:\Temp\AGENTE4\2_Screen_Capture.msi" INTG_CLOUD=10.160.0.27:29435,10.160.0.32:29436 SEC_INTG_CLOUD=10.160.0.27:29436,10.160.0.32:29436 CONN_INTG_CLD=TRUE CONN_SEC_INTG_CLD=TRUE /qb
@msiexec.exe /i "C:\Temp\AGENTE4\3_Desktop Messaging Connection Manager.msi" SERVERADDR=10.160.3.60 USEHTTPS=Y /qb
@msiexec.exe /i "C:\Temp\AGENTE4\4_Desktop Messaging Client.msi" /qb


@ECHO PARTE 3 DE 3 - AJUSTES FINAIS

@CSCRIPT /nologo C:\WINDOWS\SYSTEM32\SLMGR.VBS -upk
@CSCRIPT /nologo C:\WINDOWS\SYSTEM32\SLMGR.VBS -ipk TNKFF-8GB9Y-M7TG9-DB444-369TY
@CSCRIPT /nologo C:\WINDOWS\SYSTEM32\SLMGR.VBS -ato
@xcopy /y C:\Temp\AGENTE4\AJUSTES\ATALHOS c:\Users\public\desktop
@xcopy /y C:\Temp\AGENTE4\AJUSTES\UHG\UTILITARIOS "%programfiles%\UHG\UTILITARIOS"
@msiexec /i c:\temp\AGENTE4\AJUSTES\LAPSx64.msi /qn
@xcopy /y C:\temp\AGENTE4\AJUSTES\americas_hospitais.ps1 c:\windows
@attrib -r -s c:\windows\Media
@ren C:\windows\Media Media.Disable
@attrib +r +s c:\windows\Media.Disable
@reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /t REG_DWORD /v dontdisplaylastusername /d 1 /f
@reg add "hklm\SOFTWARE\Wow6432Node\Avaya\Avaya one-X Agent\Settings" /v EnableHotkeys  /d false /f
@reg import c:\temp\AGENTE4\AJUSTES\ajuste.reg
@"C:\ProgramData\Citrix\Citrix WorkSpace 2009\TrolleyExpress.exe" /uninstall 

@ECHO CONFIGURANDO PERFIL AVAYA
@xcopy /e /y "C:\Temp\AGENTE4\AJUSTES\UHG\UHG_CC_Config" "%programfiles%\UHG\UHG_CC_Config"
@sc create UHG_CC_Config_App binpath= "C:\Program Files\UHG\UHG_CC_Config\UHG_CC_Config_App.exe" start= auto
@sc create UHG_CC_Config_Updater binpath= "C:\Program Files\UHG\UHG_CC_Config\UHG_CC_Config_Updater.exe" start= auto
@sc stop "UHG_CC_Config_Updater"
@sc start "UHG_CC_Config_Updater"
@xcopy /e /y "C:\Temp\AGENTE4\Onex_Config\one-X Agent" "C:\Users\Default\AppData\Roaming\avaya\one-X Agent"
@xcopy /e /y "C:\Temp\AGENTE4\Onex_Config\Avaya Agent" "C:\Users\Default\AppData\Roaming\avaya\Avaya Agent"
@certutil -addstore -f "root" "C:\TEMP\AGENTE4\WFO\SystemManager.cer"