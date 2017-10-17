$regex=("dns name=$($env:computername).$($env:userdnsdomain)").tostring() -replace '\.','\.'
$certs=ls cert:\localmachine\my | select *, `
	@{name='SAN';expression={($_.Extensions | Where-Object {$_.Oid.FriendlyName -eq "subject alternative name"}).Format(1)}}
$d=get-date
# $iss is the variable for the full issuer string, for example "CN=Me First Issuing CA, DC=me, DC=ca"
$iss=''
$validcerts=$certs | ? {$_.NotBefore -lt $d -and $_.NotAfter -gt $d -and $_.Issuer -eq $iss `
	-and $_.SAN -match $regex}
$c=($validcerts | measure).count
if ($c -gt 1) {$thecert=$validcerts | sort notafter | select -Last 1}
elseif ($c -eq 1) {$thecert=$validcerts[0]}
else {exit}
$rdp=gwmi -Namespace root\cimv2\TerminalServices -Class Win32_TSGeneralSetting
if ($thecert.thumbprint -eq $rdp.SSLCertificateSHA1Hash) {exit}
$rdp.SSLCertificateSHA1Hash=$thecert.thumbprint
$rdp.put()