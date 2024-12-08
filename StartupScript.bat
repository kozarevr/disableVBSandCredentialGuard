@echo off

REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f



REM Mount the EFI partition to X:
mountvol X: /s 

REM Copy SecConfig.efi to the EFI boot directory
copy %WINDIR%\System32\SecConfig.efi X:\EFI\Microsoft\Boot\SecConfig.efi /Y 

REM Create a new boot entry
bcdedit /create {0cb3b571-2f2e-4343-a879-d86a476d7215} /d "DebugTool" /application osloader 

REM Set the path for the new boot entry
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} path "\EFI\Microsoft\Boot\SecConfig.efi" 

REM Set the boot sequence
bcdedit /set {bootmgr} bootsequence {0cb3b571-2f2e-4343-a879-d86a476d7215} 

REM Configure load options for the new boot entry
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO 

REM Set the device partition for the boot entry
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} device partition=X: 

REM Unmount the EFI partition
mountvol X: /d 

REM Add additional load options for the boot entry
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO,DISABLE-VBS 

REM Disable VSM and hypervisor launch type
bcdedit /set vsmlaunchtype off 
bcdedit /set hypervisorlaunchtype off 

REM Disable Hyper-V
dism /online /disable-feature /featurename:Microsoft-hyper-v-all


Powershell -NoProfile -ExecutionPolicy Bypass -File C:\startup\disableVBSandCredentialGuard\dgreadiness_v3.6\DG_Readiness_Tool_v3.6.ps1 -Disable

PowerShell Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor


REM Script completed
echo Script execution completed.
REM pause
