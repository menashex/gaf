

Function Get-UcsConnection
{
 param(
            
        [parameter(Mandatory = $true,HelpMessage="Please specify using format: 'Name=<ipAddress> [`nNoSsl=<bool>][`nPort=<ushort>] [`nProxyAddress=<proxyAddress>] [`nUseProxyDefaultCredentials=<bool>]'")]
		[System.String]
		$UcsConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$UcsCredentials,

		[System.Management.Automation.PSCredential]
		$WebProxyCredentials
        
        ) 
    Write-Verbose("Started execution of Get-UcsConnection() method")
    $handle=$null
	Import-Module "Cisco.UCSManager"
    $connMap=  ConvertFrom-StringData -StringData $UcsConnectionString
   # Write-Host($connMap)

    $ipAddress = $null
    $noSsl = $false
    $port = $null
    $proxyAddress = $null
    $useProxyDefaultCredentials = $false
    #Write-Host("check name key")
    if($connMap.ContainsKey("Name"))
    {
    #    Write-Host("Name key is present")
        $ipAddress= $connMap["Name"]
    }
    if($connMap.ContainsKey("NoSsl"))
    {
        $noSsl=   [System.Boolean]::Parse($connMap["NoSsl"])
    }
    if($connMap.ContainsKey("Port"))
    {
        $port=$connMap["Port"] 
    }
    if($connMap.ContainsKey("ProxyAddress"))
    {
        $proxyAddress= $connMap["ProxyAddress"]
    }
    if($connMap.ContainsKey("UseProxyDefaultCredentials"))
    {
        $useProxyDefaultCredentials = [System.Boolean]::Parse($connMap["UseProxyDefaultCredentials"])
    }
  #  Write-Host("IPAddress"+ $ipAddress)

    if([string]::IsNullOrEmpty($proxyAddress))
     {
        if(-not($noSsl) -and [string]::IsNullOrEmpty($port))
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials.")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials
        }
        elseif($noSsl -and [string]::IsNullOrEmpty($port) )
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -NoSsl.")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -NoSsl
        }

        elseif(-not ($noSsl) -and (-not [string]::IsNullOrEmpty($port)) )
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port.")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port
        }

        elseif( $noSsl -and (-not [string]::IsNullOrEmpty($port)) )
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port -NoSsl")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port -NoSsl
        }
       
    }
    else 
   
    {
        $proxy= New-Object 'System.Net.WebProxy'
        $proxy.Address = $proxyAddress
		if($WebProxyCredentials -ne $null)
		{
		  $proxy.Credentials = $WebProxyCredentials
		}
	    if($useProxyDefaultCredentials)
        {
            $proxy.UseDefaultCredentials = $true
        }
        else
        {
            $proxy.UseDefaultCredentials = $false
        }
           
        if(-not($noSsl) -and [string]::IsNullOrEmpty($port))
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -Proxy $proxy.")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -Proxy $proxy
        }
        elseif($noSsl -and [string]::IsNullOrEmpty($port) )
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -NoSsl -Proxy $proxy.")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -NoSsl -Proxy $proxy
        }
        elseif(-not ($noSsl) -and (-not [string]::IsNullOrEmpty($port)) )
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port -Proxy $proxy.")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port -Proxy $proxy
        }
        elseif( $noSsl -and ($connMap.ContainsKey("Port")) )
        {
            Write-Verbose("Using cmdlet Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port -NoSsl -Proxy $proxy")
            $handle= Connect-Ucs $ipAddress -Credential $UcsCredentials -Port $port -NoSsl -Proxy $proxy
        }
    
    }
    

   
     Write-Verbose("Completed execution of Get-UcsConnection() method")

    return $handle
} 



Function Get-ImcConnection
{
 param(
            
        [parameter(Mandatory = $true,HelpMessage="Please specify using format: 'Name=<ipAddress> [`nNoSsl=<bool>][`nPort=<ushort>] [`nProxyAddress=<proxyAddress>] [`nUseProxyDefaultCredentials=<bool>]'")]
		[System.String]
		$ImcConnectionString,

		[parameter(Mandatory = $true)]
		[System.Management.Automation.PSCredential]
		$ImcCredentials,

		[System.Management.Automation.PSCredential]
		$WebProxyCredentials
        
        ) 
    Write-Verbose("Started execution of Get-ImcConnection() method")
    $handle=$null
	Import-Module "Cisco.IMC"
    $connMap=  ConvertFrom-StringData -StringData $ImcConnectionString
   # Write-Host($connMap)

    $ipAddress = $null
    $noSsl = $false
    $port = $null
    $proxyAddress = $null
    $useProxyDefaultCredentials = $false
    #Write-Host("check name key")
    if($connMap.ContainsKey("Name"))
    {
    #    Write-Host("Name key is present")
        $ipAddress= $connMap["Name"]
    }
    if($connMap.ContainsKey("NoSsl"))
    {
        $noSsl=   [System.Boolean]::Parse($connMap["NoSsl"])
    }
    if($connMap.ContainsKey("Port"))
    {
        $port=$connMap["Port"] 
    }
    if($connMap.ContainsKey("ProxyAddress"))
    {
        $proxyAddress= $connMap["ProxyAddress"]
    }
    if($connMap.ContainsKey("UseProxyDefaultCredentials"))
    {
        $useProxyDefaultCredentials = [System.Boolean]::Parse($connMap["UseProxyDefaultCredentials"])
    }
  #  Write-Host("IPAddress"+ $ipAddress)

    if([string]::IsNullOrEmpty($proxyAddress))
     {
        if(-not($noSsl) -and [string]::IsNullOrEmpty($port))
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials.")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials
        }
        elseif($noSsl -and [string]::IsNullOrEmpty($port) )
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -NoSsl.")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -NoSsl
        }

        elseif(-not ($noSsl) -and (-not [string]::IsNullOrEmpty($port)) )
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port.")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port
        }

        elseif( $noSsl -and (-not [string]::IsNullOrEmpty($port)) )
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port -NoSsl")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port -NoSsl
        }
       
    }
    else 
   
    {
        $proxy= New-Object 'System.Net.WebProxy'
        $proxy.Address = $proxyAddress
		if($WebProxyCredentials -ne $null)
		{
		  $proxy.Credentials = $WebProxyCredentials
		}
	    if($useProxyDefaultCredentials)
        {
            $proxy.UseDefaultCredentials = $true
        }
        else
        {
            $proxy.UseDefaultCredentials = $false
        }
           
        if(-not($noSsl) -and [string]::IsNullOrEmpty($port))
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -Proxy $proxy.")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -Proxy $proxy
        }
        elseif($noSsl -and [string]::IsNullOrEmpty($port) )
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -NoSsl -Proxy $proxy.")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -NoSsl -Proxy $proxy
        }
        elseif(-not ($noSsl) -and (-not [string]::IsNullOrEmpty($port)) )
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port -Proxy $proxy.")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port -Proxy $proxy
        }
        elseif( $noSsl -and ($connMap.ContainsKey("Port")) )
        {
            Write-Verbose("Using cmdlet Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port -NoSsl -Proxy $proxy")
            $handle= Connect-Imc $ipAddress -Credential $ImcCredentials -Port $port -NoSsl -Proxy $proxy
        }
    
    }
     Write-Verbose("Completed execution of Get-ImcConnection() method")

    return $handle
} 

# SIG # Begin signature block
# MIIYygYJKoZIhvcNAQcCoIIYuzCCGLcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB9jU1LF3GyQK/+
# GdcRzuJ7Wtd695CO7Mky+p5SHn5QvKCCEx0wggQVMIIC/aADAgECAgsEAAAAAAEx
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
# CSqGSIb3DQEJBDEiBCC7p3FXGRfhwdLAim1gIgXoyg/Vb2wXOSfc3IoEWQUzYDAN
# BgkqhkiG9w0BAQEFAASCAQAaqaogd40ZAZFpRk4VAx9/qXiJlz019ITIYFTCVq67
# HwsR3MLGNOqJDfoiwgK0lwx31nuBhDKLrpcK4vp8YS4Q2oQc1jzcQVMffbN0kasr
# VTqHm+dbq1d8ELmSl3qsavkq0qmJVTYTVpC+jY5cNZMurMeb7/mkIQMuMAFE3/Of
# GZu/7UWlupdsA3abSfCszYEKyro1ezh3mHtePVDhqljYkRiuzaFVWOAyMQrcvGcU
# 0L3JuII+y5NUDVsnd/410sovtdLkmMK7RsUogOkjbsqspSjSiNYvMWsinlNOx7OQ
# nZqyi1taPyP0sxd9B3bLdC1QZqgkPEYK9DgQu9b9GLZboYICuTCCArUGCSqGSIb3
# DQEJBjGCAqYwggKiAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
# bFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENB
# IC0gU0hBMjU2IC0gRzICDCRUuH8eFFOtN/qheDANBglghkgBZQMEAgEFAKCCAQww
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwNjE1
# MTUwMDQwWjAvBgkqhkiG9w0BCQQxIgQgY+zyU8mww0vL0ogyTQDHuqFg8NuVuaAH
# /ABaH6RhlgowgaAGCyqGSIb3DQEJEAIMMYGQMIGNMIGKMIGHBBQ+x2bV1NRy4hsf
# IUNSHDG3kNlLaDBvMF+kXTBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFs
# U2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0Eg
# LSBTSEEyNTYgLSBHMgIMJFS4fx4UU603+qF4MA0GCSqGSIb3DQEBAQUABIIBAGeP
# Q9B2Zf+Dn3VGlZcDQDt8gyWMTlxP3VfBcEUs0AeLV2ZyrP8Tx4ACmDq0RGFtm19u
# 90WoP1rOf/1TXlp3JHu+q0cS6CE1vanTMBTYRN+MBtiDjaF62HaTP11Dvw41Dn0v
# EyTR2HFWMSICMglmlXfEeFlrDESpSV4a7IQ49UQoUKKDSBMq0IykqWs841h3mpJn
# Nf3N2oNiIIXeBWe85wm6yA4cg0X8f3nWIO6D+hCaRjke9lNzy0+ImYgbY08mf4qF
# jzMoSiX0XhkDcV3zmUpRiqldoChdKKnwoBVExk9Z5IlQ6DHCXGPoT30rX/xtQte6
# pvO6TnSJpaBCeYa9r6k=
# SIG # End signature block
