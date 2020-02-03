<#
	Registry edit functions.
	Gabriel Polmar, Megaphat Networks
	https://www.megaphat.net
	gpolmar@megaphat.net

	By using these functions you AGREE to assign credit to the author listed above.

	This is a Windows PowerShell Module. 

	Use:
		First Import the module into your code by using:
		Import-Module Registry.psm1

		To set a registry value, use as follows:
		regSet <Path> <Item> <Value>
		Example: regSet "HKLM:\Software\MegaphatNetworks\Powershell\TestKey" "TestDWord" 1
		Example: regSet "HKLM:\Software\MegaphatNetworks\Powershell\TestKey" "TestString" "https://www.megaphat.net"
		Path always starts with the top-level Key such as:
		HKLM:	HKEY_LOCAL_MACHINE
		HKCU:	HKEY_CURRENT_USER
		HKCR:	HKEY_CLASS_ROOT
		If a path does not exist in the top-level key, the function will parse the string of the path and create the path and all levels.
		This function does not return a value nor does it display a response on the console.

		To get a registry value, use as follows:
		If (regGet <Path> <Item>) {#Registry Entry Exists}
		If (!(regGet <Path> <Item>)) {#Registry Entry Does Not Exist}
		$ThisVal = regGet <Path> <Item>
		$ThisVal = regGet "HKLM:\Software\MegaphatNetworks\Powershell\TestKey" "TestString"
		Write-Host "Value: $ThisVal"
#>

Function regSet ($KeyPath, $KeyItem, $KeyValue) {
	$Key = $KeyPath.Split("\")
	ForEach ($Level in $Key) {
		If (!($ThisKey)) {
			$ThisKey = "$Level"
		} Else {
			$ThisKey = "$ThisKey\$Level"
		}
		If (!(Test-Path $ThisKey)) {New-Item $ThisKey -Force | out-null}
	}
	Set-ItemProperty $KeyPath $KeyItem -Value $KeyValue
}

Function regGet($Key, $Item) {
	If (!(Test-Path $Key)) {
		Return
	} Else {
		If (!($Item)) {$Item = "(Default)"}
		$ret = (Get-ItemProperty -Path $Key -Name $Item).$Item
		Return $ret
	}
}
