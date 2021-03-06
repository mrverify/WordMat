Attribute VB_Name = "WindowsFunctions"
Const SW_SHOW = 1
Const SW_SHOWMAXIMIZED = 3

#If Mac Then
#Else
Public Declare PtrSafe Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" _
  (ByVal hwnd As LongPtr, _
   ByVal lpOperation As String, _
   ByVal lpFile As String, _
   ByVal lpParameters As String, _
   ByVal lpDirectory As String, _
   ByVal nShowCmd As LongPtr) As LongPtr

Sub RunDefaultProgram(filepath As String, Optional Mappe As String = "c:\")
  On Error Resume Next
  retval = ShellExecute(0, "open", filepath, "", Mappe, SW_SHOWMAXIMIZED)

End Sub

Sub TestShellExecute()
  Dim retval As LongPtr
  
  On Error Resume Next
'  RetVal = ShellExecute(0, "open", "<full path to program>", "<arguments>", "<run in folder>", SW_SHOWMAXIMIZED)
  retval = ShellExecute(0, "open", Environ("TEMP") & "\" & "WordMatLaTex.pdf", "", "c:\", SW_SHOWMAXIMIZED)
End Sub
#End If
