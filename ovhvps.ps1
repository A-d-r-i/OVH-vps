$link = "$env:URL"

$data = ((Invoke-Webrequest $link | ConvertFrom-Json).datacenters | Where-Object { $_.datacenter -in @("SBG", "GRA")})
$dispo = $data | Where-Object {$_.status -eq "available"} #out-of-stock

if ($dispo -eq $NULL) {
	
	"VPS indisponible"
	
} else {
	$message = "⚠ *VPS VLE\-4 DISPO \!* `n"
	
	foreach($datacenter in $dispo) {
		$name = $datacenter.datacenter
		$link = "https://www.ovh.com/fr/order/vps/"
		$message += "➔ [$name]($link) `n"
	}
}


$token = "$env:TELEGRAM"
$chatid = "$env:CHAT_ID"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid&parse_mode=MarkdownV2&text=$message"
