VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DocData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Tabel() As Double
Private tabels() As String
Private mboxes() As String
Private antalmboxes As Integer
Public nrows As Integer
Public ncolumns As Integer
Private Sub Class_Initialize()
    OpretTempdoc
End Sub

Public Function ReadSelection() As Boolean
Dim cellval As String
Dim r As Integer
Dim i As Integer, j As Integer, k As Integer, l As Integer, c As Integer
Dim startrow As Integer
Dim startcol As Integer
Dim d As Double
On Error GoTo Fejl

r = 1
c = 1
If Selection.OMaths.Count > 0 Then
    ReadMathBoxes
    If Selection.Tables.Count = 0 Then
        GetSetData
    End If
End If
If Selection.Tables.Count > 0 Then
On Error GoTo hop
r = Selection.Rows.Count
c = Selection.Columns.Count
hop:
On Error GoTo Fejl
If r < 2 Or c < 2 Then
    If Selection.Tables.Count < 1 Then GoTo Fejl
    Selection.Tables(1).Select
    r = Selection.Rows.Count
    c = Selection.Columns.Count
    If r < 2 Or c < 2 Then
        GoTo Fejl
    End If
End If
    On Error Resume Next
    startrow = 0
    startcol = Selection.Cells(1).Column.Index
    If c > 1 Then
        cellval = Selection.Rows(1).Cells(startcol + 1).Range.text
        cellval = Left(cellval, Len(cellval) - 1)
        cellval = Replace(cellval, "*10^", "E")
        d = CDbl(cellval)
        If Err.Number > 0 Then
            startrow = 1
            r = r - 1
            Err.Clear
        End If
    End If
    If r > 1 Then
        cellval = Selection.Rows(2).Cells(startcol).Range.text
        cellval = Left(cellval, Len(cellval) - 1)
        cellval = Replace(cellval, "*10^", "E")
        d = CDbl(cellval)
        If Err.Number > 0 Then
            startcol = startcol + 1
            c = c - 1
            Err.Clear
        End If
    End If
    
    ReDim Tabel(1 To r, 1 To c) As Double

    For j = 1 To r
        i = i + 1
        For k = 1 To c
        l = l + 1
        cellval = Replace(Selection.Rows(i + startrow).Cells(l + startcol - 1).Range.text, ",", ".")
        cellval = Left(cellval, Len(cellval) - 1)
        cellval = Replace(cellval, "*10^", "E")
        Tabel(i, l) = CDbl(cellval)
        Tabel(i, l) = val(cellval)
        If Err.Number > 0 Then
'           l = l - 1
           Err.Clear
        End If
        Next
        l = 0
    Next
    ReDim Preserve Tabel(1 To i, 1 To c) As Double
    nrows = i
    ncolumns = c
    Selection.Tables(1).Select
    Selection.Collapse (wdCollapseEnd)
    Selection.TypeParagraph
    ReadSelection = True ' ingen fejl
End If
GoTo Slut
Fejl:
'    Call MsgBox("Du skal v�lge en tabel. Bogstaver ignoreres.")
    ReadSelection = False
Slut:

End Function
Public Function ReadSelectionS() As Boolean
' l�ser som strenge
Dim cellval As String
Dim r As Integer
Dim i As Integer, j As Integer, k As Integer, l As Integer, c As Integer
Dim startrow As Integer
Dim startcol As Integer
Dim d As Double

r = 1
c = 1
If Selection.Tables.Count = 0 And Selection.OMaths.Count > 0 Then
    GetSetData
Else
On Error GoTo hop
r = Selection.Rows.Count
c = Selection.Columns.Count
hop:
On Error GoTo Fejl
If r < 1 Or c < 1 Or (r = 1 And c = 1) Then
    If Selection.Tables.Count < 1 Then GoTo Fejl
    Selection.Tables(1).Select
    r = Selection.Rows.Count
    c = Selection.Columns.Count
    If r < 1 Or c < 1 Then
        GoTo Fejl
    End If
End If
    On Error Resume Next
    startrow = 0
    startcol = Selection.Cells(1).Column.Index
    
    ReDim tabels(1 To r, 1 To c) As String

    For j = 1 To r
        i = i + 1
        For k = 1 To c
        l = l + 1
        cellval = Replace(Selection.Rows(i + startrow).Cells(l + startcol - 1).Range.text, ",", ".")
        cellval = Left(cellval, Len(cellval) - 1)
        cellval = Replace(cellval, vbCrLf, "")
        cellval = Replace(cellval, vbCr, "")
        cellval = Replace(cellval, vbLf, "")
        tabels(i, l) = cellval
        Next
        l = 0
    Next
    ReDim Preserve tabels(1 To i, 1 To c) As String
    nrows = i
    ncolumns = c
    Selection.Tables(1).Select
    Selection.Collapse (wdCollapseEnd)
    Selection.TypeParagraph
    ReadSelectionS = True ' ingen fejl
End If
GoTo Slut
Fejl:
'    Call MsgBox("Du skal v�lge en tabel. Bogstaver ignoreres.")
    ReadSelectionS = False
Slut:

End Function

Public Function TabelCelle(r, c) As Double
On Error GoTo Fejl
If c > ncolumns Or r > nrows Then GoTo Slut

TabelCelle = Tabel(r, c)

GoTo Slut
Fejl:
Slut:

End Function
Public Function TabelsCelle(r, c) As String
On Error GoTo Fejl
If c > ncolumns Or r > nrows Then GoTo Slut

TabelsCelle = tabels(r, c)

GoTo Slut
Fejl:
Slut:

End Function

Public Sub ShowTabelData()
Dim t As String
Dim i As Integer, j As Integer

For i = 1 To nrows
For j = 1 To ncolumns
    t = t & " ; " & Tabel(i, j)
Next
    t = t & vbCrLf
Next

MsgBox t

End Sub

Public Function GetSetForm(Optional separator As Integer = 0) As String
' returnerer data som m�ngde {(1,2),(3,4)}
' 0 punktum decseparator
' 1 komma decseparator

Dim t As String
Dim i As Integer, j As Integer
t = "{ "
For i = 1 To nrows
    t = t & "(" & ConvertSeparator(Tabel(i, 1), separator)
    For j = 2 To ncolumns
        t = t & " , " & ConvertSeparator(Tabel(i, j), separator)
    Next
    t = t & "),"
Next

If right(t, 1) = "," Then
    t = Left(t, Len(t) - 1)
End If
t = t & " }"

GetSetForm = t

End Function
Public Function GetSetFormS(Optional separator As Integer = 0) As String
' returnerer data som m�ngde {(1,2),(3,4)}
' 0 punktum decseparator
' 1 komma decseparator

Dim t As String
Dim i As Integer, j As Integer
t = "{ "
For i = 1 To nrows
    t = t & "(" & ConvertSeparator(tabels(i, 1), separator)
    For j = 2 To ncolumns
        t = t & " , " & ConvertSeparator(tabels(i, j), separator)
    Next
    t = t & "),"
Next

If right(t, 1) = "," Then
    t = Left(t, Len(t) - 1)
End If
t = t & " }"

GetSetFormS = t

End Function
Public Function GetListFormS(Optional separator As Integer = 0) As String
' returnerer data som m�ngde {(1,2),(3,4)}
' 0 punktum decseparator
' 1 komma decseparator

Dim t As String
Dim i As Integer, j As Integer
t = "[ "
For i = 1 To nrows
    t = t & "[" & ConvertSeparator(tabels(i, 1), separator)
    For j = 2 To ncolumns
        t = t & " , " & ConvertSeparator(tabels(i, j), separator)
    Next
    t = t & "],"
Next

If right(t, 1) = "," Then
    t = Left(t, Len(t) - 1)
End If
t = t & " ]"

GetListFormS = t

End Function
Function ConvertSeparator(ByVal t As String, n As Integer)
If n = 0 Then
    ConvertSeparator = ConvertToPunktum(t)
Else
    ConvertSeparator = ConvertToKomma(t)
End If
End Function

Function ConvertToPunktum(ByVal t As String) As String
    ConvertToPunktum = Replace(t, ",", ".")
End Function
Function ConvertToKomma(ByVal t As String) As String
    ConvertToKomma = Replace(t, ".", ",")
End Function

Public Sub GetSetData()
' l�ser m�ngde {(2,1),(3,4)} eller liste fra mathbox ind i tabel
Dim p As String
Dim xs As String
Dim ys As String
Dim text As String
Dim n As Integer
Dim ea As New ExpressionAnalyser
Dim ea2 As New ExpressionAnalyser
Dim r() As String
Dim arr As Variant
Dim i As Integer
On Error GoTo Slut

ReDim r(1 To 1000) As String
If Selection.OMaths.Count > 0 Then
    text = mboxes(0)
'    Selection.OMaths.Linearize
'    text = Selection.OMaths(1).Range.text
Else
    text = Selection.Range.text
End If
ea.text = Replace(text, VBA.ChrW(8722), "-") ' n�dvendigt

If InStr(text, "[") > 0 Then
    ea.SetSquareBrackets
    ea.text = ea.GetNextBracketContent()
ElseIf InStr(text, "{") > 0 Then
    ea.SetTuborgBrackets
    ea.text = ea.GetNextBracketContent()
Else
    ea.text = text
End If
ea.SetNormalBrackets
ea.pos = 1
nrows = 0
    ea.text = Replace(ea.text, ";", " , ")
    ea.ConvertDecSeparator


Do
'    If ea.WhatsNextBracket = "" Then
'        p = ea.text
'    Else
'        ea.SetToNextBracket
'        p = ea.GetNextBracketContent()
'    End If
    p = Trim(ea.GetNextListItem(ea.pos, ","))
    If Left(p, 1) = "[" And right(p, 1) = "]" Then
        If Len(p) > 2 Then p = Mid(p, 2, Len(p) - 2)
    End If
'    ea2.text = Replace(p, ";", " , ")
'    ea2.ConvertDecSeparator
    
    If Len(p) > 0 Then
        nrows = nrows + 1
        r(nrows) = p
    End If
Loop While Not (p = "") And nrows < 1000


'nrows = nrows - 1
If nrows > 0 Then
    ReDim tabels(1 To nrows, 1 To 100)
Else
    ReDim tabels(1 To 1, 1 To 100)
End If

For i = 1 To nrows
    ea.text = r(i)
    ea.pos = 1
    n = 0
    Do
        p = ea.GetNextListItem(0, ",")
        n = n + 1
        If p <> "" And n > ncolumns Then
            ncolumns = n
        End If
        If Not (MaximaSeparator) Then p = Replace(p, ".", ",")
        tabels(i, n) = omax.ConvertToAscii(p)
    Loop While ea.pos < Len(ea.text) And n < 1000
Next
    
If nrows = 1 And ncolumns = 1 Then ' hvis kun et felt s� er det formentlig kun et matematikfelt og ikke en liste eller tabel
    ReDim Preserve tabels(1 To 1, 1 To 1) As String
    nrows = 0
    ncolumns = 0
ElseIf nrows > 0 Then
    ReDim Preserve tabels(1 To nrows, 1 To ncolumns) As String
End If

Slut:
End Sub

Function ReadEquation(Optional ir As Range) As String
' bruger selection.copy som nok er langsommere end autotextentries og fylder clipboard
' Overs�tter selection der er omath til streng
    Dim sr As Range, r As Range
'    Dim t As Variant
'    t = Timer
    If ir Is Nothing Then
        
    End If
    
'    copytext = Selection.Range.text ' fors�g med ikke at klippe og kopiere problemet er at man er n�dt til at konvertere til text for at l�se ordentlig
    Set sr = Selection.Range
    
    Selection.Copy

    Set r = tempDoc.Range
    
    
    With r
    .Paste
    .OMaths.BuildUp
    .OMaths.Linearize
    .OMaths(1).ConvertToNormalText
    End With
    
    ReadEquation = r.text
    sr.Select

    r.Delete
'    ClearClipboard
    
'    tempDoc.Range.Delete ' dette afhj�lper muligvis at word bliver langsom
'    MsgBox Timer - t
End Function

Sub ReadMathBoxes()
' inds�tter de markerede ligningsfelter som mboxes array
Dim mtext As String, copytext As String
Dim antal As Integer
Dim sstart As Long
Dim sslut As Long
Dim j As Integer
On Error GoTo Slut

' hvis bold giver det buildup problemer
For j = 1 To Selection.OMaths.Count
    Selection.OMaths(j).Range.Font.Bold = False
Next

'sstart = Selection.start
'sslut = Selection.End
antal = Selection.OMaths.Count
Dim r As Range, sr As Range
'    With tempDoc
'        .Content.Font.Name = "Tahoma"
'        .SaveAs FileName:="Sample.doc"
'    End With
    
If antal = 0 Then
'    kommando = Selection.text
    Selection.Collapse (wdCollapseEnd)
Else
    ReDim mboxes(0 To 100)
    Set sr = Selection.Range
    
    If Len(Selection.text) < 3 Then
        Selection.OMaths(1).Range.Select
    End If
'    If Selection.OMaths(1).Range.End < Selection.Range.End Then
'        Selection.OMaths(1).Range.Select
'    End If
    Selection.Copy


'    Set tempDoc = Documents.Add(, , , False)
    Set r = tempDoc.Range
    r.Paste
    With r
    .OMaths.BuildUp
    .OMaths.Linearize
    End With
    
    Dim i As Integer
    Dim mathcol As OMaths
    Set mathcol = r.OMaths
    For j = 0 To antal - 1
        mathcol(j + 1).ConvertToNormalText
        mboxes(j) = Replace(mathcol(j + 1).Range.text, ChrW(11), "") ' fjern shift-enter
    Next
    ReDim Preserve mboxes(0 To antal - 1)
    antalmboxes = antal
    sr.Select
End If

Slut:
    
    sr.Select
' Selection.start = sstart
' Selection.End = sslut

End Sub


Public Property Get MathBoxes(Index As Integer) As String
    On Error Resume Next
    If Index <= UBound(mboxes) Then
        MathBoxes = mboxes(Index)
    Else
        MathBoxes = ""
    End If
End Property

Public Property Get AntalMathBoxes() As Variant
    On Error Resume Next
'    AntalMathBoxes = UBound(AntalMathBoxes)
    AntalMathBoxes = antalmboxes
End Property

