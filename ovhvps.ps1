$link = "$env:URL"
$token = "$env:TELEGRAM"
$chatid = "$env:CHAT_ID"

$data = ((Invoke-Webrequest $link | ConvertFrom-Json).datacenters | Where-Object { $_.datacenter -in @("SBG", "GRA")})
$dispo = $data | Where-Object {$_.status -eq "available"} #out-of-stock

if ($dispo -eq $NULL) {
	
	"VPS indisponible"
	
} else {
	$message = "⚠ <b>VPS VLE-4 DISPO !</b> `n"
	
	foreach($datacenter in $dispo) {
	
		$name = $datacenter.datacenter
		$link = "https://www.ovh.com/fr/order/vps/?v=3`#/vps/build?selection=~(range~'VLE-4~pricingMode~'degressivity12~flavor~'vps-le-4-4-80~os~'debian_12~datacenters~($name~1))" 
		$message += "➔ <a href=`"$link`">$name</a> `n"
	
	}

	$url = "https://api.telegram.org/bot$token/sendMessage"

	$parameters = @{
		chat_id = $chatid
		text = $message
		parse_mode = "HTML"
	}

	$json = $parameters | ConvertTo-Json -Compress
	$utf8_txt = [System.Text.Encoding]::UTF8.GetBytes($json)

	Invoke-RestMethod -Uri $url -Method Post -ContentType "application/json" -Body $utf8_txt

}
