﻿# DSC uses the Get-TargetResource function to fetch the status of the resource instance specified in the parameters for the target machine
function Get-TargetResource 
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param 
    (       
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Identifier,

        [parameter(Mandatory = $true)]
		[System.String]
		$ImcConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$ImcCredentials,

        [System.Management.Automation.PSCredential]
		$WebProxyCredentials,
        
		[string]$ClassId,

        [string]$PropertyMap,

        [parameter(Mandatory = $true)]
		[System.String] $Dn,
        
        [ValidateSet("Add", "Set")]
        [string]$Action = "Add"
                
    )
       try
       {
            Write-Verbose("Started execution of Get-TargetResource method")
            Write-Verbose("Connecting to Imc...")
            $handle=  Get-ImcConnection -ImcConnectionString $ImcConnectionString -ImcCredentials $ImcCredentials -WebProxyCredentials $WebProxyCredentials
            # $propMap=  ConvertFrom-StringData -StringData $PropertyMap
            if(![string]::IsNullOrEmpty($Dn))
            {
                Write-Verbose("Fetching Mo for Dn:$Dn")
                $mo= Get-ImcMo -Dn $Dn -Imc $handle
            }
            else
            {
                Write-Verbose("Dn  is null or empty. ")
            }
            Write-Verbose("Disconnecting Imc...")
            Disconnect-Imc -Imc $handle
            Write-Verbose("Imc Disconnected")
             <# #>
            if($mo -ne $null)
            {
                Write-Verbose("Ensure = Present")
                $Ensure = "Present"
            }
            else
            {   Write-Verbose("Ensure =Absent")
                $Ensure = "Absent"
            }  
            $result = @{
                          Identifier = $Identifier;
                          Ensure =$Ensure;
                          ClassId= $ClassId;
                          PropertyMap =$PropertyMap;
                          Dn= $Dn;
						  ImcConnectionString= $ImcConnectionString;
                          ImcCredentials=$null;
                          WebProxyCredentials=$null;
                          Action=$Action;
                        }
        }
        catch
        {
            Write-Verbose("Error occurred in Get-TargetResoucrce. Disconnecting Imc(s)...")
            if($handle -ne $null)
             {$temp = Disconnect-Imc -Imc $handle}

            throw
        }
        Write-Verbose("Completed execution of Get() method")
        $result;
} 

function Set-TargetResource 
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param 
    (       
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Identifier,

        [parameter(Mandatory = $true)]
		[System.String]
		$ImcConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$ImcCredentials,

        [System.Management.Automation.PSCredential]
		$WebProxyCredentials,

        [string]$ClassId,

        [string]$PropertyMap,

        [parameter(Mandatory = $true)]
		[System.String] $Dn,
        
        [ValidateSet("Add", "Set")]
        [string]$Action = "Add"
       
    )
    
    Write-Verbose("Started execution of Set() method")
    try
    {
        Write-Verbose("Connecting to Imc...")
        $handle=  Get-ImcConnection -ImcConnectionString $ImcConnectionString -ImcCredentials $ImcCredentials -WebProxyCredentials $WebProxyCredentials
       
        if($Ensure -eq "Present" )
        {
            $propMap=  ConvertFrom-StringData -StringData $PropertyMap
         
            if(![string]::IsNullOrEmpty($Dn))
            {
                if($Action -eq "Add")
                {
                    $parentDn =  $Dn.Substring(0, $Dn.LastIndexOf('/'))
                     Get-ImcMo -Dn $parentDn -Imc $handle | Add-ImcMo -ClassId $ClassId -PropertyMap $propMap
                }
                elseif($Action -eq "Set")
                {
                    Get-ImcMo -Dn $Dn -Imc $handle | Set-ImcMo -PropertyMap $propMap -Force
                }
            }
     
         }
        elseif($Ensure -eq "Absent" )
        {
             if(![string]::IsNullOrEmpty($Dn))
             {
                $temp= Get-ImcMo -Dn $Dn -Imc $handle | Remove-ImcMo -Force
             }
       
        }
        Write-Verbose("Disconnecting Imc...")
        Disconnect-Imc -Imc $handle
        Write-Verbose("Imc Disconnected")
    }
    catch
    {
        Write-Verbose("Error occurred in Set-TargetResoucrce. Disconnecting Imc(s)...")
        if($handle -ne $null)
            {$temp = Disconnect-Imc -Imc $handle}

        throw
    }       

    Write-Verbose("Completed execution of Set() method")
    }
   
function Test-TargetResource
{
[CmdletBinding()]
[OutputType([System.Boolean])]
param
(
        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Present",
        
        [parameter(Mandatory = $true)]
		[System.String]
		$Identifier,

        [parameter(Mandatory = $true)]
		[System.String]
		$ImcConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$ImcCredentials,

        [System.Management.Automation.PSCredential]
		$WebProxyCredentials,

        [string]$ClassId,

        [string]$PropertyMap,

        [parameter(Mandatory = $true)]
		[System.String] $Dn,
        
		[ValidateSet("Add", "Set")]
        [string]$Action = "Add"
)

        
        Write-Verbose("Started execution of Test-TargetResource method")

        $result = [System.Boolean]
      
        $getTargetResult= Get-TargetResource  -Identifier $Identifier -ImcConnectionString $ImcConnectionString -ImcCredentials $ImcCredentials -WebProxyCredentials $WebProxyCredentials -ClassId $ClassId -PropertyMap $PropertyMap -Dn $Dn -Action $Action
      
    <# #>
        if($Ensure -eq "Present" )
        {
            if(($Action -eq "Add" -and $getTargetResult.Ensure -eq "Absent" ) -or ($Action -eq "Set" -and $getTargetResult.Ensure -eq "Present" ))
            {
                $result =$false
            }
            else
            {
                $result= $true
            }
        }
        elseif($Ensure -eq "Absent" )
        {
            if( $getTargetResult.Ensure -eq "Present")
            {
                $result =$false
            }
            else
            {
                $result= $true
            }        
        }
        Write-Verbose("Completed  execution of Test-TargetResource method")

        Write-Verbose("Output: "+$result)
        return $result 

}


# SIG # Begin signature block
# MIIYygYJKoZIhvcNAQcCoIIYuzCCGLcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB2wOooloDwOBgQ
# QzsfzkbxaMRkg1uSuMBc6Sleh4vYm6CCEx0wggQVMIIC/aADAgECAgsEAAAAAAEx
# icZQBDANBgkqhkiG9w0BAQsFADBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3Qg
# Q0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2ln
# bjAeFw0xMTA4MDIxMDAwMDBaFw0yOTAzMjkxMDAwMDBaMFsxCzAJBgNVBAYTAkJF
# MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWdu
# IFRpbWVzdGFtcGluZyBDQSAtIFNIQTI1NiAtIEcyMIIBIjANBgkqhkiG9w0BAQEF
# AAOCAQ8AMIIBCgKCAQEAqpuOw6sRUSUBtpaU4k/YwQj2RiPZRcWVl1urGr/SbFfJ
# MwYfoA/GPH5TSHq/nYeer+7DjEfhQuzj46FKbAwXxKbBuc1b8R5EiY7+C94hWBPu
# TcjFZwscsrPxNHaRossHbTfFoEcmAhWkkJGpeZ7X61edK3wi2BTX8QceeCI2a3d5
# r6/5f45O4bUIMf3q7UtxYowj8QM5j0R5tnYDV56tLwhG3NKMvPSOdM7IaGlRdhGL
# D10kWxlUPSbMQI2CJxtZIH1Z9pOAjvgqOP1roEBlH1d2zFuOBE8sqNuEUBNPxtyL
# ufjdaUyI65x7MCb8eli7WbwUcpKBV7d2ydiACoBuCQIDAQABo4HoMIHlMA4GA1Ud
# DwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBSSIadKlV1k
# sJu0HuYAN0fmnUErTDBHBgNVHSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYm
# aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wNgYDVR0fBC8w
# LTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLm5ldC9yb290LXIzLmNybDAf
# BgNVHSMEGDAWgBSP8Et/qC5FJK5NUPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOC
# AQEABFaCSnzQzsm/NmbRvjWek2yX6AbOMRhZ+WxBX4AuwEIluBjH/NSxN8RooM8o
# agN0S2OXhXdhO9cv4/W9M6KSfREfnops7yyw9GKNNnPRFjbxvF7stICYePzSdnno
# 4SGU4B/EouGqZ9uznHPlQCLPOc7b5neVp7uyy/YZhp2fyNSYBbJxb051rvE9ZGo7
# Xk5GpipdCJLxo/MddL9iDSOMXCo4ldLA1c3PiNofKLW6gWlkKrWmotVzr9xG2wSu
# kdduxZi61EfEVnSAR3hYjL7vK/3sbL/RlPe/UOB74JD9IBh4GCJdCC6MHKCX8x2Z
# faOdkdMGRE4EbnocIOM28LZQuTCCBMYwggOuoAMCAQICDCRUuH8eFFOtN/qheDAN
# BgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2ln
# biBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBT
# SEEyNTYgLSBHMjAeFw0xODAyMTkwMDAwMDBaFw0yOTAzMTgxMDAwMDBaMDsxOTA3
# BgNVBAMMMEdsb2JhbFNpZ24gVFNBIGZvciBNUyBBdXRoZW50aWNvZGUgYWR2YW5j
# ZWQgLSBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANl4YaGWrhL/
# o/8n9kRge2pWLWfjX58xkipI7fkFhA5tTiJWytiZl45pyp97DwjIKito0ShhK5/k
# Ju66uPew7F5qG+JYtbS9HQntzeg91Gb/viIibTYmzxF4l+lVACjD6TdOvRnlF4RI
# shwhrexz0vOop+lf6DXOhROnIpusgun+8V/EElqx9wxA5tKg4E1o0O0MDBAdjwVf
# ZFX5uyhHBgzYBj83wyY2JYx7DyeIXDgxpQH2XmTeg8AUXODn0l7MjeojgBkqs2Iu
# YMeqZ9azQO5Sf1YM79kF15UgXYUVQM9ekZVRnkYaF5G+wcAHdbJL9za6xVRsX4ob
# +w0oYciJ8BUCAwEAAaOCAagwggGkMA4GA1UdDwEB/wQEAwIHgDBMBgNVHSAERTBD
# MEEGCSsGAQQBoDIBHjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
# aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMBYGA1UdJQEB/wQMMAoGCCsG
# AQUFBwMIMEYGA1UdHwQ/MD0wO6A5oDeGNWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5j
# b20vZ3MvZ3N0aW1lc3RhbXBpbmdzaGEyZzIuY3JsMIGYBggrBgEFBQcBAQSBizCB
# iDBIBggrBgEFBQcwAoY8aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNl
# cnQvZ3N0aW1lc3RhbXBpbmdzaGEyZzIuY3J0MDwGCCsGAQUFBzABhjBodHRwOi8v
# b2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3N0aW1lc3RhbXBpbmdzaGEyZzIwHQYDVR0O
# BBYEFNSHuI3m5UA8nVoGY8ZFhNnduxzDMB8GA1UdIwQYMBaAFJIhp0qVXWSwm7Qe
# 5gA3R+adQStMMA0GCSqGSIb3DQEBCwUAA4IBAQAkclClDLxACabB9NWCak5BX87H
# iDnT5Hz5Imw4eLj0uvdr4STrnXzNSKyL7LV2TI/cgmkIlue64We28Ka/GAhC4evN
# GVg5pRFhI9YZ1wDpu9L5X0H7BD7+iiBgDNFPI1oZGhjv2Mbe1l9UoXqT4bZ3hcD7
# sUbECa4vU/uVnI4m4krkxOY8Ne+6xtm5xc3NB5tjuz0PYbxVfCMQtYyKo9JoRbFA
# uqDdPBsVQLhJeG/llMBtVks89hIq1IXzSBMF4bswRQpBt3ySbr5OkmCCyltk5lXT
# 0gfenV+boQHtm/DDXbsZ8BgMmqAc6WoICz3pZpendR4PvyjXCSMN4hb6uvM0MIIE
# 2TCCA8GgAwIBAgIQIHWDPrOEReitUG9yJSUhQDANBgkqhkiG9w0BAQsFADB/MQsw
# CQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNV
# BAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMDAuBgNVBAMTJ1N5bWFudGVjIENs
# YXNzIDMgU0hBMjU2IENvZGUgU2lnbmluZyBDQTAeFw0xNjExMDkwMDAwMDBaFw0x
# OTExMjYyMzU5NTlaMHExCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlh
# MREwDwYDVQQHDAhTYW4gSm9zZTEcMBoGA1UECgwTQ2lzY28gU3lzdGVtcywgSW5j
# LjEcMBoGA1UEAwwTQ2lzY28gU3lzdGVtcywgSW5jLjCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBALLlVI4b5lGZi0ZHbXjIMlPDLvF6C7xjHJXtpR5zTvax
# nQNvjs+574jAE57yRjFxwmKqWqoyHKoSNO3YnlxjUk/buDk43m/QI1qtrs+14i4K
# ip3lmM2IOJeFsdLxpsPWSDdakvFqyz+H1W1266X42E5LtUk9KLqt/CP19tbA4kby
# EsSRjJfQ+ZvugUyk2NYTZ8GairJPr3ld9xls7GOI4JtCMfqv2elhUR50vM9Yec66
# il4GNgS4Af33Sz2O2XA3Ocz02km7XdS5sTIrHZSjpApQEmuugJBm2wYQ0lwOldNb
# MW61VA/vMsOR8Y0pAXb2hor9et2edDvY21GYQCo3kwUCAwEAAaOCAV0wggFZMAkG
# A1UdEwQCMAAwDgYDVR0PAQH/BAQDAgeAMCsGA1UdHwQkMCIwIKAeoByGGmh0dHA6
# Ly9zdi5zeW1jYi5jb20vc3YuY3JsMGEGA1UdIARaMFgwVgYGZ4EMAQQBMEwwIwYI
# KwYBBQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkM
# F2h0dHBzOi8vZC5zeW1jYi5jb20vcnBhMBMGA1UdJQQMMAoGCCsGAQUFBwMDMFcG
# CCsGAQUFBwEBBEswSTAfBggrBgEFBQcwAYYTaHR0cDovL3N2LnN5bWNkLmNvbTAm
# BggrBgEFBQcwAoYaaHR0cDovL3N2LnN5bWNiLmNvbS9zdi5jcnQwHwYDVR0jBBgw
# FoAUljtT8Hkzl699g+8uK8zKt4YecmYwHQYDVR0OBBYEFMJofs4grwKJnUFm8/jC
# hhSUyVqAMA0GCSqGSIb3DQEBCwUAA4IBAQAoAoTeg6dizssRJJ92t06YFEdI+Ozj
# v12Rw8Y1Q/SJ7emwiFqFypQ9Y/lPS9LkgXxzIFWBXmCxFsPPpGQh0SG+56om+2oZ
# kj26E2pou2382mBSRW/GbbRPoGGDPQ4H2uf5Hk4ru4Aq/RGakJYk3B10u0vMZAYK
# oo5qHPDIDdTPTaYOlPzyh+7THSJWCOqlCvSQsd4bAAwarJO/db7QvIDVEt3tAsll
# /zOAWTQVFu8rNjoaXWHFo8J2JuFrvcAgzoAz9Nsl8f/X/ZonY4O1FVeA+TYIdfpI
# PJlkR1tsJi1tJJ74usKT5V4Z0dX8JVgJ4gnTtjCn8YC9xWihUPDapcjQMIIFWTCC
# BEGgAwIBAgIQPXjX+XZJYLJhffTwHsqGKjANBgkqhkiG9w0BAQsFADCByjELMAkG
# A1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJp
# U2lnbiBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwNiBWZXJpU2lnbiwg
# SW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MUUwQwYDVQQDEzxWZXJpU2ln
# biBDbGFzcyAzIFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5
# IC0gRzUwHhcNMTMxMjEwMDAwMDAwWhcNMjMxMjA5MjM1OTU5WjB/MQswCQYDVQQG
# EwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5
# bWFudGVjIFRydXN0IE5ldHdvcmsxMDAuBgNVBAMTJ1N5bWFudGVjIENsYXNzIDMg
# U0hBMjU2IENvZGUgU2lnbmluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAJeDHgAWryyx0gjE12iTUWAecfbiR7TbWE0jYmq0v1obUfejDRh3aLvY
# NqsvIVDanvPnXydOC8KXyAlwk6naXA1OpA2RoLTsFM6RclQuzqPbROlSGz9BPMpK
# 5KrA6DmrU8wh0MzPf5vmwsxYaoIV7j02zxzFlwckjvF7vjEtPW7ctZlCn0thlV8c
# cO4XfduL5WGJeMdoG68ReBqYrsRVR1PZszLWoQ5GQMWXkorRU6eZW4U1V9Pqk2Jh
# IArHMHckEU1ig7a6e2iCMe5lyt/51Y2yNdyMK29qclxghJzyDJRewFZSAEjM0/il
# fd4v1xPkOKiE1Ua4E4bCG53qWjjdm9sCAwEAAaOCAYMwggF/MC8GCCsGAQUFBwEB
# BCMwITAfBggrBgEFBQcwAYYTaHR0cDovL3MyLnN5bWNiLmNvbTASBgNVHRMBAf8E
# CDAGAQH/AgEAMGwGA1UdIARlMGMwYQYLYIZIAYb4RQEHFwMwUjAmBggrBgEFBQcC
# ARYaaHR0cDovL3d3dy5zeW1hdXRoLmNvbS9jcHMwKAYIKwYBBQUHAgIwHBoaaHR0
# cDovL3d3dy5zeW1hdXRoLmNvbS9ycGEwMAYDVR0fBCkwJzAloCOgIYYfaHR0cDov
# L3MxLnN5bWNiLmNvbS9wY2EzLWc1LmNybDAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
# KwYBBQUHAwMwDgYDVR0PAQH/BAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQD
# ExFTeW1hbnRlY1BLSS0xLTU2NzAdBgNVHQ4EFgQUljtT8Hkzl699g+8uK8zKt4Ye
# cmYwHwYDVR0jBBgwFoAUf9Nlp8Ld7LvwMAnzQzn6Aq8zMTMwDQYJKoZIhvcNAQEL
# BQADggEBABOFGh5pqTf3oL2kr34dYVP+nYxeDKZ1HngXI9397BoDVTn7cZXHZVqn
# jjDSRFph23Bv2iEFwi5zuknx0ZP+XcnNXgPgiZ4/dB7X9ziLqdbPuzUvM1ioklbR
# yE07guZ5hBb8KLCxR/Mdoj7uh9mmf6RWpT+thC4p3ny8qKqjPQQB6rqTog5QIikX
# TIfkOhFf1qQliZsFay+0yQFMJ3sLrBkFIqBgFT/ayftNTI/7cmd3/SeUx7o1DohJ
# /o39KK9KEr0Ns5cF3kQMFfo2KwPcwVAB8aERXRTl4r0nS1S+K4ReD6bDdAUK75fD
# iSKxH3fzvc1D1PFMqT+1i4SvZPLQFCExggUDMIIE/wIBATCBkzB/MQswCQYDVQQG
# EwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5
# bWFudGVjIFRydXN0IE5ldHdvcmsxMDAuBgNVBAMTJ1N5bWFudGVjIENsYXNzIDMg
# U0hBMjU2IENvZGUgU2lnbmluZyBDQQIQIHWDPrOEReitUG9yJSUhQDANBglghkgB
# ZQMEAgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJ
# AzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8G
# CSqGSIb3DQEJBDEiBCDQ48n/wiZt7Umf5v1uHZkVD4FhJa6PQl2m6Cp1B0EG8zAN
# BgkqhkiG9w0BAQEFAASCAQBqZAelR3NeZwEBNMdfDpypPpBFHQIxOc9aakm3DGOQ
# /1VYfAH0i9CtFi8opNdSt8wr82ikAMBFLj5/t7KPeDpKDqH5fvbgOiS3zI9e9EEx
# 2u3mtChpOeKECcm7xSFG9W7AJExASJxsH/Mg595iaL7NZZsK+HJa9PN5BQpgL9AW
# BWsba0SrmT/lTk71dYwJ8jIxjDaZVmu2eZPwjlQcaDhtkrJPMMDosbswDEVgtwIy
# cP/D8lgPt0FMv0DqlmMn3kcJbLoGZ3pUPCkpA1whJTEm5seRDII0WyLqGHO4zARV
# cHkmDXHL8uZYjuEggcvQpcUpRrXonDlXIYwAKs/iinoEoYICuTCCArUGCSqGSIb3
# DQEJBjGCAqYwggKiAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
# bFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENB
# IC0gU0hBMjU2IC0gRzICDCRUuH8eFFOtN/qheDANBglghkgBZQMEAgEFAKCCAQww
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwNjE1
# MTUwMTQ1WjAvBgkqhkiG9w0BCQQxIgQgp8yMY2wcrhaFDobGK36fqZuQ6YCKVUP1
# 1pNReL5lnsEwgaAGCyqGSIb3DQEJEAIMMYGQMIGNMIGKMIGHBBQ+x2bV1NRy4hsf
# IUNSHDG3kNlLaDBvMF+kXTBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFs
# U2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0Eg
# LSBTSEEyNTYgLSBHMgIMJFS4fx4UU603+qF4MA0GCSqGSIb3DQEBAQUABIIBAIal
# 7On2R7D1kTMSR7+RFrQsfqn7Mzdo6s+Na+XSZW+3pXlixCzwjJgfUYRbOTTZR2p5
# 0uhLPN3QczYsTanBxYo5hR3rfxpmXZiQ70bA8+HJhzXkU97W3lDKG51/fvFvg3qJ
# l+1+8uo2yZt/IaVjDS3IgXPcMce3i8+cHLojYlf8on1mpdFlaLS/4bJ+GPDwzYu4
# 42fziwVWJcT75wet8FWY4HOCBTxrCzhRiI7FYsEw90DN0zq03s7qkVWrPZ24OzfB
# ALMnk58WP7z9CdP4rDzu8whHduVTm9gB+Te0GOwt50N06TURZ4iBuNUKhp/V6Xmm
# 52AlPnol0IGlG8bwWW8=
# SIG # End signature block