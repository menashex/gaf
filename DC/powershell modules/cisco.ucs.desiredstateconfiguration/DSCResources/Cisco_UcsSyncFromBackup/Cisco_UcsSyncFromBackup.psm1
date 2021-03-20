# DSC uses the Get-TargetResource function to fetch the status of the resource instance specified in the parameters for the target machine
function Get-TargetResource 
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param 
    (       
        [parameter(Mandatory = $true)]
		[System.String]
		$UcsConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$UcsCredentials,

        [System.Management.Automation.PSCredential]
		$WebProxyCredentials,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Absent",
		
		[parameter(Mandatory = $true)]
		[System.String]$Identifier,
      
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [bool]$Merge
              
    )
       $result = @{     UcsConnectionString = $UcsConnectionString;
		                UcsCredentials = $null;
                        WebProxyCredentials=$null;
                        Ensure=$Ensure;
                        Identifier = $Identifier; 
                        LiteralPath = $LiteralPath;
                        Merge= $Merge;

                  }

        Write-Verbose("Completed execution of Get() method")
        $result;
} 


# The Set-TargetResource function. 
function Set-TargetResource 
{
    [CmdletBinding(SupportsShouldProcess=$true)]
  param 
    (       
        [parameter(Mandatory = $true)]
		[System.String]
		$UcsConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$UcsCredentials,

        [System.Management.Automation.PSCredential]
		$WebProxyCredentials,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Absent",
		
		[parameter(Mandatory = $true)]
		[System.String] $Identifier,

        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [bool]$Merge
              
    )

    Write-Verbose("Started execution of Set() method")
    try
    {
        <# #>
        if($Ensure -eq "Present" )
        {
            Write-Verbose("Connection to target UCS...")
            $handle=  Get-UcsConnection -UcsConnectionString $UcsConnectionString -UcsCredentials $UcsCredentials -WebProxyCredentials $WebProxyCredentials

            if($Merge)
            {
                Write-Verbose("Executing cmdlet: Import-UcsBackup -LiteralPath $LiteralPath -Merge")
                Import-UcsBackup -LiteralPath $LiteralPath -Merge -Ucs $handle
            }
            else
            {
                Write-Verbose("Executing cmdlet: Import-UcsBackup -LiteralPath $LiteralPath")
                Import-UcsBackup -LiteralPath $LiteralPath -Ucs $handle
            }



         }
         elseif($Ensure -eq "Absent" )
        {
            Write-Verbose("Ensure ='Absent'. No further processing required.")
        }
    }
    catch
    {
        Write-Verbose("Error occurred in Set-TargetResoucrce. Disconnecting UCS(s)...")
        if($handle -ne $null)
            {$temp = Disconnect-Ucs -Ucs $handle}

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
        [parameter(Mandatory = $true)]
		[System.String]
		$UcsConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$UcsCredentials,

        [System.Management.Automation.PSCredential]
		$WebProxyCredentials,

        [ValidateSet("Present", "Absent")]
        [string]$Ensure = "Absent",
		
		[parameter(Mandatory = $true)]
		[System.String] $Identifier,

        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [bool]$Merge
              
    )
       Write-Verbose("Started execution of Test-TargetResource method")

        $result = $false
         
        Write-Verbose("Completed  execution of Test-TargetResource method")

        return $result 
} 

# SIG # Begin signature block
# MIIYygYJKoZIhvcNAQcCoIIYuzCCGLcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBiQuwdSctlvXp1
# T9xZ7MjwpbI4p6vcOEjnwMMpTidKYaCCEx0wggQVMIIC/aADAgECAgsEAAAAAAEx
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
# CSqGSIb3DQEJBDEiBCBedzuXKKPbQ95KSWidZd0gR46a+R1N7KwtMnj/iX0e+DAN
# BgkqhkiG9w0BAQEFAASCAQBq4N0dKIXAZlTAk9LW1KFiKCcMVFC4StwfjR8IpFDT
# 5bN8Ko32jQg86t3eeyhc1/l2BdTKUD8p1c4dh1PVSS7S1k9bfw4hGZSLPhpSTom7
# 5HT21dzU65qoJKdAIbKerAVaUQzIuuRaaPm95ynf2wTgr7jXmKYbKjrhbAHr3OmP
# Q/ksjSuTtD2BEien6h9gRCCMpA++jD+xP4GU7zE8W5p7KKNz0J9roVky2wWzGURN
# 7374eOxATrFoHqLAFr8TUxeuhkf40MzAYs4dZv35xYU2E/XDiNbTBFzhWovFG5GJ
# tHI7F0uKt9TNt5DWtz5I/Ktu7Afw7uOTn1NpgQ78GItPoYICuTCCArUGCSqGSIb3
# DQEJBjGCAqYwggKiAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
# bFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENB
# IC0gU0hBMjU2IC0gRzICDCRUuH8eFFOtN/qheDANBglghkgBZQMEAgEFAKCCAQww
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwNjE1
# MTUwMzQwWjAvBgkqhkiG9w0BCQQxIgQgFFqiXrxMOBzbSyoq4/cHd6eTdYODVChl
# Jfx8KUkg5eAwgaAGCyqGSIb3DQEJEAIMMYGQMIGNMIGKMIGHBBQ+x2bV1NRy4hsf
# IUNSHDG3kNlLaDBvMF+kXTBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFs
# U2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0Eg
# LSBTSEEyNTYgLSBHMgIMJFS4fx4UU603+qF4MA0GCSqGSIb3DQEBAQUABIIBABaM
# pEw3kJzs0e96Q430QsCgJc4zhfNZ/wytWi8KCdV1beF3DRwd/FjV9aP41LHfEQzH
# 04YMj/vK+gHWawSjoHEFlyWtfQ+DATjYO90ozEzsBjCNZ2ex/smQWDwIkN51Ckd3
# rXGKXIzNv3Tc50Bgbp4JQz3rDCrZA70Li4R7G/7tXMR+T0WekEPY2lOWpm8PmDsq
# FP6CO35Au56VGUReRdc1OPkaARn0LvXpnW6I7CFI9v7IfAd07uD9u0EnrhJULt9J
# Xk8CluykTjmoBIYafzRqBQ5+yyFVLelFW/sd6F51uktVo0+RB3e6cg3Kq/UwV5Hn
# ZGMsybjISNtzbYYfrYc=
# SIG # End signature block
