# Steps needed to disable DeviceGuard with UEFI lock

# Disable DeviceGuard in registry
cmd /c 'REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f'
cmd /c 'REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f'
cmd /c 'REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f'
cmd /c 'REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f'

# Change UEFI settings. Reboot and confirmation needed.
mountvol X: /s
copy-item c:\windows\System32\SecConfig.efi X:\EFI\Microsoft\Boot\SecConfig.efi
cmd /c 'bcdedit /create {0cb3b571-2f2e-4343-a879-d86a476d7215} /d "DebugTool" /application osloader'
cmd /c 'bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} path "\EFI\Microsoft\Boot\SecConfig.efi"'
cmd /c 'bcdedit /set {bootmgr} bootsequence {0cb3b571-2f2e-4343-a879-d86a476d7215}'
cmd /c 'bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO'
cmd /c 'bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} device partition=X:'
cmd /c 'bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO,DISABLE-VBS'
cmd /c 'bcdedit /set vsmlaunchtype off'
mountvol X: /d