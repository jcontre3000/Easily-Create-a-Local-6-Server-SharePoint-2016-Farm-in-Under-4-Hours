﻿# *************************************************************************
#
# Script Name: Add External Adapter back.ps1
# PS Version: 5.1
# Author: Ron Davis
# 
# Last Modified: 1/13/2017
# 
# Description: This script creates an array of virtual machine names, adds an External Network Adapter,
# and attaches the SQL ISO file to the SQL VM.           
#
# *************************************************************************

#Verify PowerShell is running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
	Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Sleep -Seconds 1
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
	exit
}
#Create an array of virtual machine names
$VMs = @('dc01','SPApp','SPcache','SPSearch','SPweb','SQLSvr')

#TASK: SHUT DOWN ALL VIRTUAL MACHINES
$VMs | Stop-vm 

#TASK: ADDING AN EXTERNAL NETWORK ADAPTER
$VMs | Add-VMNetworkAdapter -SwitchName VMExternalNetwork

#TASK: ATTACH SQL SERVER 2016 ISO
$SQLISOName = Get-ChildItem -Path 'C:\ISO\SQL\SQL 2016'
Set-VMDvdDrive -VMName SQLSvr -Path $SQLISOName.Name
