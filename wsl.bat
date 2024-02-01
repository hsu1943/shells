@echo on
REM 关闭子系统
wsl --shutdown
REM 配置IP
wsl -d Ubuntu-22.04 -u root ip addr del $(ip addr show eth0 ^| grep 'inet\b' ^| awk '{print $2}' ^| head -n 1) dev eth0
wsl -d Ubuntu-22.04 -u root ip addr add 192.168.60.2/24 broadcast 192.168.60.255 dev eth0
wsl -d Ubuntu-22.04 -u root ip route add 0.0.0.0/0 via 192.168.60.1 dev eth0

powershell -c "Get-NetAdapter 'vEthernet (WSL)' | Get-NetIPAddress | Remove-NetIPAddress -Confirm:$False; New-NetIPAddress -IPAddress 192.168.60.1 -PrefixLength 24 -InterfaceAlias 'vEthernet (WSL)'; Get-NetNat | ? Name -Eq WSLNat | Remove-NetNat -Confirm:$False; New-NetNat -Name WSLNat -InternalIPInterfaceAddressPrefix 192.168.60.0/24;"

REM 启动对应Linux系统
wt -p Ubuntu-22.04