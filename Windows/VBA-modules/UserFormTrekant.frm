VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} UserFormTrekant 
   Caption         =   "Trekantsl�ser"
   ClientHeight    =   6390
   ClientLeft      =   -30
   ClientTop       =   75
   ClientWidth     =   11115
   OleObjectBlob   =   "UserFormTrekant.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "UserFormTrekant"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

    Dim vA As Double
    Dim vB As Double
    Dim vC As Double
    Dim SA As Double
    Dim sb As Double
    Dim sc As Double
    Dim vA2 As Double
    Dim vB2 As Double
    Dim vC2 As Double
    Dim sa2 As Double
    Dim sb2 As Double
    Dim sc2 As Double
    Dim nv As Integer
    Dim ns As Integer
    Dim statustext As String
    Dim succes As Boolean
    Dim comtext As String
    Dim elabotext(10) As String
    Dim elabolign(10) As String
    Dim elaboindex As Integer
    Dim Bfejl As Boolean
    Dim inputtext As String

Private Sub CommandButton_nulstil_Click()
    TextBox_A.text = ""
    TextBox_B.text = ""
    TextBox_C.text = ""
    TextBox_sa.text = ""
    TextBox_sb.text = ""
    TextBox_sc.text = ""
    TextBox_captionA.text = "A"
    TextBox_captionB.text = "B"
    TextBox_captionC.text = "C"
    TextBox_captionsa.text = "a"
    TextBox_captionsb.text = "b"
    TextBox_captionsc.text = "c"
    
End Sub

Private Sub CommandButton_ok_Click()

'On Error GoTo fejl

    Dim cv As Shape
    Dim t As Table
    Dim r As Range
    Dim l As Shape
    Dim bc As Integer
    Dim i As Integer
    Dim gemsb As Integer, gemsa As Integer
    
    Application.ScreenUpdating = False
    
    FindSolutions True
    
    If Not succes Then Exit Sub
        
        
    '
    gemsb = Selection.ParagraphFormat.SpaceBefore
    gemsa = Selection.ParagraphFormat.SpaceAfter
            
    With Selection.ParagraphFormat
        .SpaceBefore = 0
        .SpaceBeforeAuto = False
        .SpaceAfter = 0
        .SpaceAfterAuto = False
'        .LineUnitBefore = 0
'        .LineUnitAfter = 0
    End With

    
    ' inds�t i Word
#If Mac Then
#Else
        Dim Oundo As UndoRecord
        Set Oundo = Application.UndoRecord
        Oundo.StartCustomRecord
#End If
    Selection.Collapse wdCollapseEnd
'    If MaximaForklaring Then
        Selection.TypeParagraph
        Selection.TypeText Sprog.TriangleSolverExplanation3 & inputtext
        Selection.TypeParagraph
'    End If
    Selection.TypeParagraph
    
    
    Set t = ActiveDocument.Tables.Add(Selection.Range, 1, 2)
'    t.Borders(wdBorderVertical).Visible = True
#If Mac Then
    t.Borders(wdBorderVertical).visible = False
    t.Borders(wdBorderBottom).visible = False
    t.Borders(wdBorderHorizontal).visible = False
    t.Borders(wdBorderRight).visible = False
    t.Borders(wdBorderLeft).visible = False
    t.Borders(wdBorderTop).visible = False
#End If
    


    Set r = t.Cell(1, 1).Range
    t.Cell(1, 2).Select
    TypeLine TextBox_captionA.text & " = " & ConvertNumberToStringBC(vA) & VBA.ChrW(176), Not (CBool(ConvertStringToNumber(TextBox_A.text)))
    TypeLine TextBox_captionB.text & " = " & ConvertNumberToStringBC(vB) & VBA.ChrW(176), Not (CBool(ConvertStringToNumber(TextBox_B.text)))
    TypeLine TextBox_captionC.text & " = " & ConvertNumberToStringBC(vC) & VBA.ChrW(176), Not (CBool(ConvertStringToNumber(TextBox_C.text)))
    Selection.TypeParagraph
    TypeLine TextBox_captionsa.text & " = " & ConvertNumberToStringBC(SA), Not (CBool(ConvertStringToNumber(TextBox_sa.text)))
    TypeLine TextBox_captionsb.text & " = " & ConvertNumberToStringBC(sb), Not (CBool(ConvertStringToNumber(TextBox_sb.text)))
    TypeLine TextBox_captionsc.text & " = " & ConvertNumberToStringBC(sc), Not (CBool(ConvertStringToNumber(TextBox_sc.text)))
#If Mac Then ' ensures that the bottom line remains in the table. The extra space is then removed after the triangle is inserted
    TypeLine vbCrLf, False
    TypeLine vbCrLf, False
    TypeLine vbCrLf, False
#End If
    

    If CheckBox_tal.Value Then
        bc = 3 ' antal betydende cifre p� sidel�ngde p� figur
        If Log10(SA) > bc Then bc = Int(Log10(SA)) + 1
        If Log10(sb) > bc Then bc = Int(Log10(sb)) + 1
        If Log10(sc) > bc Then bc = Int(Log10(sc)) + 1
        If bc > MaximaCifre Then bc = MaximaCifre
#If Mac Then
        InsertTriangle r, vA, sb, sc, ConvertNumberToStringBC(vA, 3) & ChrW(176), ConvertNumberToStringBC(vB, 3) & ChrW(176), ConvertNumberToStringBC(vC, 3) & ChrW(176), ConvertNumberToStringBC(SA, bc), ConvertNumberToStringBC(sb, bc), ConvertNumberToStringBC(sc, bc), t.Cell(1, 1).Range
#Else
        InsertTriangle r, vA, sb, sc, ConvertNumberToStringBC(vA, 3) & VBA.ChrW(176), ConvertNumberToStringBC(vB, 3) & VBA.ChrW(176), ConvertNumberToStringBC(vC, 3) & VBA.ChrW(176), ConvertNumberToStringBC(SA, bc), ConvertNumberToStringBC(sb, bc), ConvertNumberToStringBC(sc, bc)
#End If
    Else
#If Mac Then
        InsertTriangle r, vA, sb, sc, TextBox_captionA.text, TextBox_captionB.text, TextBox_captionC.text, TextBox_captionsa.text, TextBox_captionsb.text, TextBox_captionsc.text, t.Cell(1, 1).Range
#Else
        InsertTriangle r, vA, sb, sc, TextBox_captionA.text, TextBox_captionB.text, TextBox_captionC.text, TextBox_captionsa.text, TextBox_captionsb.text, TextBox_captionsc.text
#End If
    End If

#If Mac Then
    t.Cell(1, 2).Select
    Selection.Collapse wdCollapseEnd
    Selection.MoveLeft wdCharacter, 1
    i = 0
    Do While i < Int(vB / 4) And i < 6
        Selection.TypeBackspace
        i = i + 1
    Loop
#End If
    
    
    t.Range.Select
    Selection.Collapse wdCollapseEnd
    Selection.TypeParagraph
    
    'Hvis 2 l�sninger
    If vA2 > 0 Then
    MsgBox Sprog.TS2Solutions, vbOKOnly, Sprog.TS2Solutions2
    Set t = ActiveDocument.Tables.Add(Selection.Range, 1, 2)
'    t.Borders(wdBorderVertical).Visible = True
#If Mac Then
    t.Borders(wdBorderVertical).visible = False
    t.Borders(wdBorderBottom).visible = False
    t.Borders(wdBorderHorizontal).visible = False
    t.Borders(wdBorderRight).visible = False
    t.Borders(wdBorderLeft).visible = False
    t.Borders(wdBorderTop).visible = False
#End If
    
    Set r = t.Cell(1, 1).Range
    t.Cell(1, 2).Select
    TypeLine TextBox_captionA.text & " = " & ConvertNumberToStringBC(vA2) & VBA.ChrW(176), Not (CBool(ConvertStringToNumber(TextBox_A.text)))
    TypeLine TextBox_captionB.text & " = " & ConvertNumberToStringBC(vB2) & VBA.ChrW(176), Not (CBool(ConvertStringToNumber(TextBox_B.text)))
    TypeLine TextBox_captionC.text & " = " & ConvertNumberToStringBC(vC2) & VBA.ChrW(176), Not (CBool(ConvertStringToNumber(TextBox_C.text)))
    Selection.TypeParagraph
    TypeLine TextBox_captionsa.text & " = " & ConvertNumberToStringBC(sa2), Not (CBool(ConvertStringToNumber(TextBox_sa.text)))
    TypeLine TextBox_captionsb.text & " = " & ConvertNumberToStringBC(sb2), Not (CBool(ConvertStringToNumber(TextBox_sb.text)))
    TypeLine TextBox_captionsc.text & " = " & ConvertNumberToStringBC(sc2), Not (CBool(ConvertStringToNumber(TextBox_sc.text)))
#If Mac Then
    TypeLine vbCrLf, False
    TypeLine vbCrLf, False
    TypeLine vbCrLf, False
#End If
        
    If CheckBox_tal.Value Then
        bc = 3 ' antal betydende cifre p� sidel�ngde p� figur
        If Log10(sa2) > bc Then bc = Int(Log10(sa2)) + 1
        If Log10(sb2) > bc Then bc = Int(Log10(sb2)) + 1
        If Log10(sc2) > bc Then bc = Int(Log10(sc2)) + 1
        If bc > MaximaCifre Then bc = MaximaCifre
#If Mac Then
        InsertTriangle r, vA2, sb2, sc2, ConvertNumberToStringBC(vA2, 3) & ChrW(176), ConvertNumberToStringBC(vB2, 3) & ChrW(176), ConvertNumberToStringBC(vC2, 3) & ChrW(176), ConvertNumberToStringBC(sa2, bc), ConvertNumberToStringBC(sb2, bc), ConvertNumberToStringBC(sc2, bc), t.Cell(1, 1).Range
#Else
        InsertTriangle r, vA2, sb2, sc2, ConvertNumberToStringBC(vA2, 3) & VBA.ChrW(176), ConvertNumberToStringBC(vB2, 3) & VBA.ChrW(176), ConvertNumberToStringBC(vC2, 3) & VBA.ChrW(176), ConvertNumberToStringBC(sa2, bc), ConvertNumberToStringBC(sb2, bc), ConvertNumberToStringBC(sc2, bc)
#End If
    Else
#If Mac Then
        InsertTriangle r, vA2, sb2, sc2, TextBox_captionA.text, TextBox_captionB.text, TextBox_captionC.text, TextBox_captionsa.text, TextBox_captionsb.text, TextBox_captionsc.text, t.Cell(1, 1).Range
#Else
        InsertTriangle r, vA2, sb2, sc2, TextBox_captionA.text, TextBox_captionB.text, TextBox_captionC.text, TextBox_captionsa.text, TextBox_captionsb.text, TextBox_captionsc.text
#End If
    End If

#If Mac Then
    t.Cell(1, 2).Select
    Selection.Collapse wdCollapseEnd
    Selection.MoveLeft wdCharacter, 1
    i = 0
    Do While i < Int(vB / 4) And i < 6
        Selection.TypeBackspace
        i = i + 1
    Loop
#End If
    t.Range.Select
    Selection.Collapse wdCollapseEnd
    Selection.TypeParagraph
    End If
    
    Dim mo As Range
    If CheckBox_forklaring Then
    For i = 0 To elaboindex - 1
    If Len(elabotext(i)) > 0 Then
        Selection.TypeText elabotext(i) & vbCrLf
    End If
    If Len(elabolign(i)) > 0 Then
        Set mo = Selection.OMaths.Add(Selection.Range)
        Selection.TypeText elabolign(i)
        mo.OMaths.BuildUp
        Selection.TypeParagraph
    End If
    Next
    End If
    
    With Selection.ParagraphFormat
        .SpaceBefore = gemsb
'        .SpaceBeforeAuto = False
        .SpaceAfter = gemsa
'        .SpaceAfterAuto = False
    End With
    
#If Mac Then
#Else
        Oundo.EndCustomRecord
#End If
    
GoTo Slut
Fejl:
    MsgBox Sprog.TSNoSolution, vbOKOnly, Sprog.Error
    Exit Sub
Slut:
    SaveSettings
#If Mac Then
    Unload Me
#Else
    Me.hide
#End If

End Sub

Sub TypeLine(text As String, fed As Boolean)
    If fed Then
        Selection.Font.Bold = True
    Else
        Selection.Font.Bold = False
    End If
    Selection.TypeText text
    Selection.Font.Bold = False
    Selection.TypeParagraph

End Sub

Sub FindSolutions(Optional advarsler As Boolean = False)

    Dim tn As Double
    Dim d As Double
    Dim san As String
    Dim sbn As String
    Dim scn As String
    Dim vAn As String
    Dim vBn As String
    Dim vCn As String
    
    On Error GoTo Fejl
    
    san = TextBox_captionsa.text
    sbn = TextBox_captionsb.text
    scn = TextBox_captionsc.text
    vAn = TextBox_captionA.text
    vBn = TextBox_captionB.text
    vCn = TextBox_captionC.text
    
    vA = ConvertStringToNumber(TextBox_A.text)
    vB = ConvertStringToNumber(TextBox_B.text)
    vC = ConvertStringToNumber(TextBox_C.text)
    SA = ConvertStringToNumber(TextBox_sa.text)
    sb = ConvertStringToNumber(TextBox_sb.text)
    sc = ConvertStringToNumber(TextBox_sc.text)
    nv = 0
    ns = 0
    elaboindex = 0
    succes = False
    inputtext = ""
    
    If vA > 0 Then
        nv = nv + 1
        inputtext = inputtext & TextBox_captionA.text & " = " & TextBox_A.text & VBA.ChrW(176) & " , "
    End If
    If vB > 0 Then
        nv = nv + 1
        inputtext = inputtext & TextBox_captionB.text & " = " & TextBox_B.text & VBA.ChrW(176) & " , "
    End If
    If vC > 0 Then
        nv = nv + 1
        inputtext = inputtext & TextBox_captionC.text & " = " & TextBox_C.text & VBA.ChrW(176) & " , "
    End If
    If SA > 0 Then
        ns = ns + 1
        inputtext = inputtext & TextBox_captionsa.text & " = " & TextBox_sa.text & " , "
    End If
    If sb > 0 Then
        ns = ns + 1
        inputtext = inputtext & TextBox_captionsb.text & " = " & TextBox_sb.text & " , "
    End If
    If sc > 0 Then
        ns = ns + 1
        inputtext = inputtext & TextBox_captionsc.text & " = " & TextBox_sc.text & " , "
    End If
    If Len(inputtext) > 1 Then inputtext = Left(inputtext, Len(inputtext) - 2)
        
    ' vinkelsum over 180
    If vA + vB + vC > 180 Then
        statustext = Sprog.A(209) ' "Vinkelsummen er over 180"
        If advarsler Then MsgBox Sprog.A(209), vbOKOnly, Sprog.Error
        Exit Sub
    End If
    
    If nv + ns < 3 Then
        statustext = Sprog.TSMissingInfo
        If advarsler Then MsgBox Sprog.TSMissingInfo & vbCrLf & Sprog.A(210), vbOKOnly, Sprog.Error
        Exit Sub
    ElseIf nv + ns > 3 Then
        If nv = 3 And ns = 1 Then
            If vA > 0 And vB > 0 And vC > 0 And vA + vB + vC <> 180 Then
                statustext = Sprog.A(211) ' "Vinkelsummen er ikke 180"
                If advarsler Then MsgBox Sprog.A(211), vbOKOnly, Sprog.Error
                Exit Sub
            End If
        Else
            statustext = Sprog.A(212) ' "Du har indtastet for mange sider/vinkler."
            If advarsler Then MsgBox Sprog.A(212) & vbCrLf & Sprog.A(213), vbOKOnly, Sprog.Error
            Exit Sub
        End If
    Else
        If nv = 3 And ns = 0 Then
        statustext = Sprog.A(214) ' "Mindst en side skal v�re kendt. 3 vinkler er ikke nok."
        If advarsler Then MsgBox Sprog.A(214) & vbCrLf & Sprog.A(213), vbOKOnly, Sprog.Error
        Exit Sub
        End If
    End If
    
    
    ' 3. vinkel beregnes hvis 2 kendes
    If nv = 2 Then
    If vA > 0 And vB > 0 And vC = 0 Then
        vC = 180 - vA - vB
        AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
    ElseIf vA > 0 And vB = 0 And vC > 0 Then
        vB = 180 - vA - vC
        AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(216), vBn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vCn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
    ElseIf vA = 0 And vB > 0 And vC > 0 Then
        vA = 180 - vB - vC
        AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(216), vAn & "=180" & VBA.ChrW(176) & "-" & vBn & "-" & vCn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
    End If
    End If
    
    'retvinklede
    If vC = 90 Then
        If ns = 2 Then
            If SA > 0 And sb > 0 Then
                sc = Sqr(SA ^ 2 + sb ^ 2)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(218), scn & "=" & VBA.ChrW(8730) & "(" & san & "^2+" & sbn & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(SA) & "^2+" & ConvertNumberToStringBC(sb) & "^2)=" & ConvertNumberToStringBC(sc)
                vA = Atn(SA / sb) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(220), vAn & "=tan^-1 (" & san & "/" & sbn & ")=tan^-1 (" & ConvertNumberToStringBC(SA) & "/" & ConvertNumberToStringBC(sb) & ")=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            ElseIf SA > 0 And sc > 0 Then
                sb = Sqr(sc ^ 2 - SA ^ 2)
                AddElaborate Sprog.A(217) & sbn & " " & Sprog.A(218), sbn & "=" & VBA.ChrW(8730) & "(" & scn & "^2-" & san & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sc) & "^2-" & ConvertNumberToStringBC(SA) & "^2)=" & ConvertNumberToStringBC(sb)
                vA = Arcsin(SA / sc) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(221), vAn & "=sin^-1 (" & san & "/" & scn & ")=sin^-1 (" & ConvertNumberToStringBC(SA) & "/" & ConvertNumberToStringBC(sc) & ")=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            ElseIf sb > 0 And sc > 0 Then
                SA = Sqr(sc ^ 2 - sb ^ 2)
                AddElaborate Sprog.A(217) & san & " " & Sprog.A(218), san & "=" & VBA.ChrW(8730) & "(" & scn & "^2-" & sbn & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sc) & "^2-" & ConvertNumberToStringBC(sb) & "^2)=" & ConvertNumberToStringBC(SA)
                vA = Arccos(sb / sc) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(222), vAn & "=cos^-1 (" & sbn & "/" & scn & ")=cos^-1 (" & ConvertNumberToStringBC(sb) & "/" & ConvertNumberToStringBC(sc) & ")=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            End If
            vB = 90 - vA
            AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(216), vBn & "=180" & VBA.ChrW(176) & "-" & vCn & "-" & vAn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
        ElseIf ns = 1 Then
            If SA > 0 Then
                sb = SA / Tan(vA * PI / 180)
                sc = SA / sIn(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(220), sbn & "=" & san & "/tan(" & vAn & ")=" & ConvertNumberToStringBC(SA) & "/tan(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sb)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(221), scn & "=" & san & "/sin(" & vAn & ")=" & ConvertNumberToStringBC(SA) & "/sin(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sc)
            ElseIf sb > 0 Then
                SA = sb * Tan(vA * PI / 180)
                sc = sb / Cos(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(220), san & "=" & sbn & VBA.ChrW(183) & "tan(" & vAn & ")=" & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & "tan(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(222), scn & "=" & sbn & "/cos(" & vAn & ")=" & ConvertNumberToStringBC(sb) & "/cos(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sc)
            ElseIf sc > 0 Then
                SA = sc * sIn(vA * PI / 180)
                sb = sc * Cos(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(221), san & "=" & scn & VBA.ChrW(183) & "sin(" & vAn & ")=" & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(222), sbn & "=" & scn & VBA.ChrW(183) & "cos(" & vAn & ")=" & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "cos(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sb)
            End If
        End If
        GoTo Slut
    ElseIf vA = 90 Then
        If ns = 2 Then
            If SA > 0 And sb > 0 Then
                sc = Sqr(SA ^ 2 - sb ^ 2)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(218), scn & "=" & VBA.ChrW(8730) & "(" & san & "^2-" & sbn & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(SA) & "^2-" & ConvertNumberToStringBC(sb) & "^2)=" & ConvertNumberToStringBC(sc)
                vC = Arccos(sb / SA) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(222), vCn & "=cos^-1 (" & sbn & "/" & san & ")=cos^-1 (" & ConvertNumberToStringBC(sb) & "/" & ConvertNumberToStringBC(SA) & ")=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
            ElseIf SA > 0 And sc > 0 Then
                sb = Sqr(SA ^ 2 - sc ^ 2)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(218), sbn & "=" & VBA.ChrW(8730) & "(" & san & "^2-" & scn & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(SA) & "^2-" & ConvertNumberToStringBC(sc) & "^2)=" & ConvertNumberToStringBC(sb)
                vC = Arcsin(sc / SA) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(221), vCn & "=sin^-1 (" & scn & "/" & san & ")=sin^-1 (" & ConvertNumberToStringBC(sc) & "/" & ConvertNumberToStringBC(SA) & ")=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
            ElseIf sb > 0 And sc > 0 Then
                SA = Sqr(sc ^ 2 + sb ^ 2)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(218), san & "=" & VBA.ChrW(8730) & "(" & scn & "^2+" & sbn & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sc) & "^2+" & ConvertNumberToStringBC(sb) & "^2)=" & ConvertNumberToStringBC(SA)
                vC = Atn(sc / sb) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(220), vCn & "=tan^-1 (" & scn & "/" & sbn & ")=tan^-1 (" & ConvertNumberToStringBC(sc) & "/" & ConvertNumberToStringBC(sb) & ")=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
            End If
            vB = 90 - vC
            AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(216), vBn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vCn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
        ElseIf ns = 1 Then
            If sc > 0 Then
                SA = sc / sIn(vC * PI / 180)
                sb = sc / Tan(vC * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(221), san & "=" & scn & "/sin(" & vCn & ")=" & ConvertNumberToStringBC(sc) & "/sin(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(220), sbn & "=" & scn & "/tan(" & vCn & ")=" & ConvertNumberToStringBC(sc) & "/tan(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(sb)
            ElseIf sb > 0 Then
                SA = sb / Cos(vC * PI / 180)
                sc = sb * Tan(vC * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(222), san & "=" & sbn & "/cos(" & vCn & ")=" & ConvertNumberToStringBC(sb) & "/cos(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(220), scn & "=" & sbn & VBA.ChrW(183) & "tan(" & vCn & ")=" & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & "tan(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(sc)
            ElseIf SA > 0 Then
                sb = SA * Cos(vC * PI / 180)
                sc = SA * sIn(vC * PI / 180)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(222), sbn & "=" & san & VBA.ChrW(183) & "cos(" & vCn & ")=" & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & "cos(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(sb)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(221), scn & "=" & san & VBA.ChrW(183) & "sin(" & vCn & ")=" & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(sc)
            End If
        End If
        GoTo Slut
    ElseIf vB = 90 Then
        If ns = 2 Then
            If SA > 0 And sb > 0 Then
                sc = Sqr(sb ^ 2 - SA ^ 2)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(218), scn & "=" & VBA.ChrW(8730) & "(" & sbn & "^2-" & san & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sb) & "^2-" & ConvertNumberToStringBC(SA) & "^2)=" & ConvertNumberToStringBC(sc)
                vA = Arcsin(SA / sb) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(221), vAn & "=sin^-1 (" & san & "/" & sbn & ")=sin^-1 (" & ConvertNumberToStringBC(SA) & "/" & ConvertNumberToStringBC(sb) & ")=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            ElseIf SA > 0 And sc > 0 Then
                sb = Sqr(sc ^ 2 + SA ^ 2)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(218), sbn & "=" & VBA.ChrW(8730) & "(" & scn & "^2+" & san & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sc) & "^2+" & ConvertNumberToStringBC(SA) & "^2)=" & ConvertNumberToStringBC(sb)
                vA = Atn(SA / sc) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(220), vAn & "=tan^-1 (" & san & "/" & scn & ")=tan^-1 (" & ConvertNumberToStringBC(SA) & "/" & ConvertNumberToStringBC(sc) & ")=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            ElseIf sb > 0 And sc > 0 Then
                SA = Sqr(sb ^ 2 - sc ^ 2)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(218), san & "=" & VBA.ChrW(8730) & "(" & sbn & "^2-" & scn & "^2)=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sb) & "^2-" & ConvertNumberToStringBC(sc) & "^2)=" & ConvertNumberToStringBC(SA)
                vA = Arccos(sc / sb) * 180 / PI
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(222), vAn & "=cos^-1 (" & scn & "/" & sbn & ")=cos^-1 (" & ConvertNumberToStringBC(sc) & "/" & ConvertNumberToStringBC(sb) & ")=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            End If
            vC = 90 - vA
            AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vBn & "-" & vAn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
        ElseIf ns = 1 Then
            If SA > 0 Then
                sb = SA / sIn(vA * PI / 180)
                sc = SA / Tan(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(221), sbn & "=" & san & "/sin(" & vAn & ")=" & ConvertNumberToStringBC(SA) & "/sin(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sb)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(220), scn & "=" & san & "/tan(" & vAn & ")=" & ConvertNumberToStringBC(SA) & "/tan(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sc)
            ElseIf sc > 0 Then
                SA = sc * Tan(vA * PI / 180)
                sb = sc / Cos(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(220), san & "=" & scn & VBA.ChrW(183) & "tan(" & vAn & ")=" & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "tan(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(222), sbn & "=" & scn & "/cos(" & vAn & ")=" & ConvertNumberToStringBC(sc) & "/cos(" & ConvertNumberToStringBC(vA) & ")=" & ConvertNumberToStringBC(sb)
            ElseIf sb > 0 Then
                SA = sb * Cos(vC * PI / 180)
                sc = sb * sIn(vC * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(222), san & "=" & sbn & VBA.ChrW(183) & "cos(" & vCn & ")=" & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & "cos(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(221), scn & "=" & sbn & VBA.ChrW(183) & "sin(" & vCn & ")=" & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vC) & ")=" & ConvertNumberToStringBC(sc)
            End If
        End If
        GoTo Slut
    End If
    
    ' Vilk�rlig trekant
    If ns = 3 Then
        vA = Arccos((sc ^ 2 + sb ^ 2 - SA ^ 2) / (2 * sc * sb)) * 180 / PI
        vB = Arccos((SA ^ 2 + sc ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
        vC = 180 - vB - vA
        AddElaborate Sprog.A(215) & " " & vAn & " og " & vBn & " " & Sprog.A(223), vAn & "=cos^(-1) ((" & scn & "^2 + " & sbn & "^2 - " & san & "^2)/(2" & VBA.ChrW(183) & sbn & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sc) & "^2 + " & ConvertNumberToStringBC(sb) & "^2 - " & ConvertNumberToStringBC(SA) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
        AddElaborate "", vBn & "=cos^(-1) ((" & scn & "^2 + " & san & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & san & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sc) & "^2 + " & ConvertNumberToStringBC(SA) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
        AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
    ElseIf ns = 1 Then
        If SA > 0 Then
            sb = SA * sIn(vB * PI / 180) / sIn(vA * PI / 180)
            sc = SA * sIn(vC * PI / 180) / sIn(vA * PI / 180)
            AddElaborate Sprog.A(219) & " " & sbn & " og " & scn & " " & Sprog.A(224), sbn & "=" & san & VBA.ChrW(183) & "sin(" & vBn & ")/sin(" & vAn & ")=" & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & ")/sin(" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & ")=" & ConvertNumberToStringBC(sb)
            AddElaborate "", scn & "=" & san & VBA.ChrW(183) & "sin(" & vCn & ")/sin(" & vAn & ")=" & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & ")/sin(" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & ")=" & ConvertNumberToStringBC(sc)
        ElseIf sb > 0 Then
            SA = sb * sIn(vA * PI / 180) / sIn(vB * PI / 180)
            sc = sb * sIn(vC * PI / 180) / sIn(vB * PI / 180)
            AddElaborate Sprog.A(219) & " " & san & " og " & scn & " " & Sprog.A(224), san & "=" & sbn & VBA.ChrW(183) & "sin(" & vAn & ")/sin(" & vBn & ")=" & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & ")/sin(" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & ")=" & ConvertNumberToStringBC(SA)
            AddElaborate "", scn & "=" & sbn & VBA.ChrW(183) & "sin(" & vCn & ")/sin(" & vBn & ")=" & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & ")/sin(" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & ")=" & ConvertNumberToStringBC(sc)
        Else ' sc>0
            SA = sc * sIn(vA * PI / 180) / sIn(vC * PI / 180)
            sb = sc * sIn(vB * PI / 180) / sIn(vC * PI / 180)
            AddElaborate Sprog.A(219) & " " & san & " og " & sbn & " " & Sprog.A(224), san & "=" & scn & VBA.ChrW(183) & "sin(" & vAn & ")/sin(" & vCn & ")=" & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & ")/sin(" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & ")=" & ConvertNumberToStringBC(SA)
            AddElaborate "", sbn & "=" & scn & VBA.ChrW(183) & "sin(" & vBn & ")/sin(" & vCn & ")=" & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "sin(" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & ")/sin(" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & ")=" & ConvertNumberToStringBC(sb)
        End If
    ElseIf ns = 2 Then
        If vA > 0 Then
            If sb > 0 And sc > 0 Then ' sider om vinkel
                SA = Sqr(sb ^ 2 + sc ^ 2 - 2 * sb * sc * Cos(vA * PI / 180))
                vB = Arccos((SA ^ 2 + sc ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
                vC = 180 - vB - vA
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(223), san & "=" & VBA.ChrW(8730) & "(" & sbn & "^2 + " & scn & "^2 - 2" & VBA.ChrW(183) & sbn & VBA.ChrW(183) & scn & VBA.ChrW(183) & "cos(" & vAn & "))=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sb) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - 2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "cos(" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "))=" & ConvertNumberToStringBC(SA)
                AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(223), vBn & "=cos^(-1) ((" & san & "^2 + " & scn & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & san & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(SA) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
            ElseIf SA > 0 And sb > 0 Then ' sider ikke om vinkel
                d = SA ^ 2 - sb ^ 2 * sIn(vA * PI / 180) ^ 2
                If d < 0 Then ' ingen l�sning
                    GoTo Fejl
                End If
                sc = sb * Cos(vA * PI / 180) + Sqr(d)
                sc2 = sb * Cos(vA * PI / 180) - Sqr(d)
                vB = Arccos((SA ^ 2 + sc ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
                vC = 180 - vB - vA
'                sc = sa * Sin(vC * PI / 180) / Sin(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(223), san & "^2=" & sbn & "^2+" & scn & "^2-2" & sbn & VBA.ChrW(183) & scn & VBA.ChrW(183) & "cos(" & vAn & ")"
                AddElaborate Sprog.A(225) & " " & scn, scn & "=" & sbn & VBA.ChrW(183) & "cos(" & vAn & ")+" & VBA.ChrW(8730) & "(" & san & "^2-" & sbn & "^2" & VBA.ChrW(183) & "sin(" & vAn & ")^2)=" & ConvertNumberToStringBC(sc)
                If d > 0 Then AddElaborate Sprog.A(226), scn & "_2=" & sbn & VBA.ChrW(183) & "cos(" & vAn & ")-" & VBA.ChrW(8730) & "(" & san & "^2-" & sbn & "^2" & VBA.ChrW(183) & "sin(" & vAn & ")^2)=" & ConvertNumberToStringBC(sc2)
                If sc2 < 0 Then AddElaborate Sprog.A(227), ""
                AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(223), vBn & "=cos^(-1) ((" & san & "^2 + " & scn & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & san & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(SA) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
                If d > 0 And sc2 > 0.000000000000001 Then
                    vA2 = vA
                    sb2 = sb
                    sa2 = SA
                    vB2 = Arccos((sa2 ^ 2 + sc2 ^ 2 - sb2 ^ 2) / (2 * sa2 * sc2)) * 180 / PI
                    vC2 = 180 - vB2 - vA2
                    AddElaborate vbCrLf & Sprog.A(228) & " " & scn & " " & Sprog.A(229), ""
                    AddElaborate Sprog.A(215) & " " & vBn & VBA.ChrW(8322) & " findes vha. en cosinusrelation", vBn & "_2=cos^(-1) ((" & san & "^2 + " & scn & "_2^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & san & "" & VBA.ChrW(183) & scn & "_2))=cos^(-1) ((" & ConvertNumberToStringBC(sa2) & "^2 + " & ConvertNumberToStringBC(sc2) & "^2 - " & ConvertNumberToStringBC(sb2) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sa2) & VBA.ChrW(183) & ConvertNumberToStringBC(sc2) & "))=" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176)
                    AddElaborate Sprog.A(215) & " " & vCn & VBA.ChrW(8322) & " " & Sprog.A(216), vCn & "_2=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "_2=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC2) & VBA.ChrW(176)
                End If
            ElseIf SA > 0 And sc > 0 Then ' sider ikke om vinkel
                d = SA ^ 2 - sc ^ 2 * sIn(vA * PI / 180) ^ 2
                If d < 0 Then ' ingen l�sning
                    GoTo Fejl
                End If
                sb = sc * Cos(vA * PI / 180) + Sqr(d)
                sb2 = sc * Cos(vA * PI / 180) - Sqr(d)
                vB = Arccos((SA ^ 2 + sc ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
                vC = 180 - vB - vA
'                sc = sa * Sin(vC * PI / 180) / Sin(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(223), san & "^2=" & sbn & "^2+" & scn & "^2-2" & sbn & VBA.ChrW(183) & scn & VBA.ChrW(183) & "cos(" & vAn & ")"
                AddElaborate Sprog.A(225) & " " & sbn, sbn & "=" & scn & VBA.ChrW(183) & "cos(" & vAn & ")+" & VBA.ChrW(8730) & "(" & san & "^2-" & scn & "^2" & VBA.ChrW(183) & "sin(" & vAn & ")^2)=" & ConvertNumberToStringBC(sb)
                If d > 0 Then AddElaborate Sprog.A(226), sbn & "_2=" & scn & VBA.ChrW(183) & "cos(" & vAn & ")-" & VBA.ChrW(8730) & "(" & san & "^2-" & scn & "^2" & VBA.ChrW(183) & "sin(" & vAn & ")^2)=" & ConvertNumberToStringBC(sb2)
                If sb2 < 0 Then AddElaborate Sprog.A(227), ""
                AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(223), vBn & "=cos^(-1) ((" & san & "^2 + " & scn & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & san & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(SA) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
                If d > 0 And sb2 > 0.000000000000001 Then
                    vA2 = vA
                    sc2 = sc
                    sa2 = SA
                    vB2 = Arccos((sa2 ^ 2 + sc2 ^ 2 - sb2 ^ 2) / (2 * sa2 * sc2)) * 180 / PI
                    vC2 = 180 - vB2 - vA2
                    AddElaborate vbCrLf & Sprog.A(228) & " " & sbn & " " & Sprog.A(229), ""
                    AddElaborate Sprog.A(215) & " " & vBn & VBA.ChrW(8322) & " " & Sprog.A(223), vBn & "_2=cos^(-1) ((" & san & "^2 + " & scn & "^2 - " & sbn & "_2^2)/(2" & VBA.ChrW(183) & san & "" & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sa2) & "^2 + " & ConvertNumberToStringBC(sc2) & "^2 - " & ConvertNumberToStringBC(sb2) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sa2) & VBA.ChrW(183) & ConvertNumberToStringBC(sc2) & "))=" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176)
                    AddElaborate Sprog.A(215) & " " & vCn & VBA.ChrW(8322) & " " & Sprog.A(216), vCn & "_2=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "_2=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC2) & VBA.ChrW(176)
                End If
            End If
        ElseIf vB > 0 Then
            If SA > 0 And sc > 0 Then ' sider om vinkel
                sb = Sqr(SA ^ 2 + sc ^ 2 - 2 * SA * sc * Cos(vB * PI / 180))
                vA = Arccos((sb ^ 2 + sc ^ 2 - SA ^ 2) / (2 * sb * sc)) * 180 / PI
                vC = 180 - vB - vA
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(223), sbn & "=" & VBA.ChrW(8730) & "(" & san & "^2 + " & scn & "^2 - 2" & VBA.ChrW(183) & san & VBA.ChrW(183) & scn & VBA.ChrW(183) & "cos(" & vBn & "))=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(SA) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - 2" & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & "cos(" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "))=" & ConvertNumberToStringBC(sb)
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(223), vAn & "=cos^(-1) ((" & sbn & "^2 + " & scn & "^2 - " & san & "^2)/(2" & VBA.ChrW(183) & sbn & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sb) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - " & ConvertNumberToStringBC(SA) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
            ElseIf SA > 0 And sb > 0 Then ' sider ikke om vinkel
                d = sb ^ 2 - SA ^ 2 * sIn(vB * PI / 180) ^ 2
                If d < 0 Then ' ingen l�sning
                    GoTo Fejl
                End If
                sc = SA * Cos(vB * PI / 180) + Sqr(d)
                sc2 = SA * Cos(vB * PI / 180) - Sqr(d)
                vA = Arccos((sb ^ 2 + sc ^ 2 - SA ^ 2) / (2 * sb * sc)) * 180 / PI
                vC = 180 - vB - vA
'                sc = sa * Sin(vC * PI / 180) / Sin(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(223), sbn & "^2=" & san & "^2+" & scn & "^2-2" & san & VBA.ChrW(183) & scn & VBA.ChrW(183) & "cos(" & vAn & ")"
                AddElaborate Sprog.A(225) & " " & scn, scn & "=" & san & VBA.ChrW(183) & "cos(" & vBn & ")+" & VBA.ChrW(8730) & "(" & sbn & "^2-" & san & "^2" & VBA.ChrW(183) & "sin(" & vBn & ")^2)=" & ConvertNumberToStringBC(sc)
                If d > 0 Then AddElaborate Sprog.A(226), scn & "_2=" & san & VBA.ChrW(183) & "cos(" & vBn & ")-" & VBA.ChrW(8730) & "(" & sbn & "^2-" & san & "^2" & VBA.ChrW(183) & "sin(" & vBn & ")^2)=" & ConvertNumberToStringBC(sc2)
                If sc2 < 0 Then AddElaborate Sprog.A(227), ""
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(223), vAn & "=cos^(-1) ((" & sbn & "^2 + " & scn & "^2 - " & san & "^2)/(2" & VBA.ChrW(183) & sbn & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sb) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - " & ConvertNumberToStringBC(SA) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
                If d > 0 And sc2 > 0.000000000000001 Then
                    vB2 = vB
                    sb2 = sb
                    sa2 = SA
                    vA2 = Arccos((sb2 ^ 2 + sc2 ^ 2 - sa2 ^ 2) / (2 * sb2 * sc2)) * 180 / PI
                    vC2 = 180 - vB2 - vA2
                    AddElaborate vbCrLf & Sprog.A(228) & " " & scn & " " & Sprog.A(229), ""
                    AddElaborate Sprog.A(215) & " " & vAn & VBA.ChrW(8322) & " " & Sprog.A(223), vAn & "_2=cos^(-1) ((" & sbn & "^2 + " & scn & "_2^2 - " & san & "^2)/(2" & VBA.ChrW(183) & sbn & "" & VBA.ChrW(183) & scn & "_2))=cos^(-1) ((" & ConvertNumberToStringBC(sb2) & "^2 + " & ConvertNumberToStringBC(sc2) & "^2 - " & ConvertNumberToStringBC(sa2) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb2) & VBA.ChrW(183) & ConvertNumberToStringBC(sc2) & "))=" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176)
                    AddElaborate Sprog.A(215) & " " & vCn & VBA.ChrW(8322) & " " & Sprog.A(216), vCn & "_2=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "_2=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC2) & VBA.ChrW(176)
                End If
            ElseIf sb > 0 And sc > 0 Then ' sider ikke om vinkel
                d = sb ^ 2 - sc ^ 2 * sIn(vB * PI / 180) ^ 2
                If d < 0 Then ' ingen l�sning
                    GoTo Fejl
                End If
                SA = sc * Cos(vB * PI / 180) + Sqr(d)
                sa2 = sc * Cos(vB * PI / 180) - Sqr(d)
                vA = Arccos((sb ^ 2 + sc ^ 2 - SA ^ 2) / (2 * sb * sc)) * 180 / PI
                vC = 180 - vB - vA
'                sc = sa * Sin(vC * PI / 180) / Sin(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(223), sbn & "^2=" & san & "^2+" & scn & "^2-2" & san & VBA.ChrW(183) & scn & VBA.ChrW(183) & "cos(" & vBn & ")"
                AddElaborate Sprog.A(225) & " " & san, san & "=" & scn & VBA.ChrW(183) & "cos(" & vBn & ")+" & VBA.ChrW(8730) & "(" & sbn & "^2-" & scn & "^2" & VBA.ChrW(183) & "sin(" & vBn & ")^2)=" & ConvertNumberToStringBC(SA)
                If d > 0 Then AddElaborate Sprog.A(226), san & "_2=" & scn & VBA.ChrW(183) & "cos(" & vBn & ")-" & VBA.ChrW(8730) & "(" & sbn & "^2-" & scn & "^2" & VBA.ChrW(183) & "sin(" & vBn & ")^2)=" & ConvertNumberToStringBC(sa2)
                If sa2 < 0 Then AddElaborate Sprog.A(227), ""
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(223), vAn & "=cos^(-1) ((" & sbn & "^2 + " & scn & "^2 - " & san & "^2)/(2" & VBA.ChrW(183) & sbn & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sb) & "^2 + " & ConvertNumberToStringBC(sc) & "^2 - " & ConvertNumberToStringBC(SA) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & "))=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vCn & " " & Sprog.A(216), vCn & "=180" & VBA.ChrW(176) & "-" & vAn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC) & VBA.ChrW(176)
                If d > 0 And sa2 > 0.000000000000001 Then
                    vB2 = vB
                    sc2 = sc
                    sb2 = sb
                    vA2 = Arccos((sb2 ^ 2 + sc2 ^ 2 - sa2 ^ 2) / (2 * sb2 * sc2)) * 180 / PI
                    vC2 = 180 - vB2 - vA2
                    AddElaborate vbCrLf & Sprog.A(228) & " " & san & " " & Sprog.A(229), ""
                    AddElaborate Sprog.A(215) & " " & vAn & VBA.ChrW(8322) & " " & Sprog.A(223), vAn & "_2=cos^(-1) ((" & sbn & "^2 + " & scn & "^2 - " & san & "_2^2)/(2" & VBA.ChrW(183) & sbn & "" & VBA.ChrW(183) & scn & "))=cos^(-1) ((" & ConvertNumberToStringBC(sb2) & "^2 + " & ConvertNumberToStringBC(sc2) & "^2 - " & ConvertNumberToStringBC(sa2) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb2) & VBA.ChrW(183) & ConvertNumberToStringBC(sc2) & "))=" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176)
                    AddElaborate Sprog.A(215) & " " & vCn & VBA.ChrW(8322) & " " & Sprog.A(216), vCn & "_2=180" & VBA.ChrW(176) & "-" & vAn & "_2-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vC2) & VBA.ChrW(176)
                End If
            End If
        Else ' vc>0
            If sb > 0 And SA > 0 Then ' sider om vinkel
                sc = Sqr(sb ^ 2 + SA ^ 2 - 2 * sb * SA * Cos(vC * PI / 180))
                vB = Arccos((sc ^ 2 + SA ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
                vA = 180 - vB - vC
                AddElaborate Sprog.A(217) & " " & scn & " " & Sprog.A(223), scn & "=" & VBA.ChrW(8730) & "(" & sbn & "^2 + " & san & "^2 - 2" & VBA.ChrW(183) & sbn & VBA.ChrW(183) & san & VBA.ChrW(183) & "cos(" & vCn & "))=" & VBA.ChrW(8730) & "(" & ConvertNumberToStringBC(sb) & "^2 + " & ConvertNumberToStringBC(SA) & "^2 - 2" & VBA.ChrW(183) & ConvertNumberToStringBC(sb) & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & VBA.ChrW(183) & "cos(" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "))=" & ConvertNumberToStringBC(sc)
                AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(223), vBn & "=cos^(-1) ((" & scn & "^2 + " & san & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & scn & VBA.ChrW(183) & san & "))=cos^(-1) ((" & ConvertNumberToStringBC(sc) & "^2 + " & ConvertNumberToStringBC(SA) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(216), vAn & "=180" & VBA.ChrW(176) & "-" & vCn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
            ElseIf sc > 0 And sb > 0 Then ' sider ikke om vinkel
                d = sc ^ 2 - sb ^ 2 * sIn(vC * PI / 180) ^ 2
                If d < 0 Then ' ingen l�sning
                    GoTo Fejl
                End If
                SA = sb * Cos(vC * PI / 180) + Sqr(d)
                sa2 = sb * Cos(vC * PI / 180) - Sqr(d)
                vB = Arccos((sc ^ 2 + SA ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
                vA = 180 - vB - vC
'                sc = sa * Sin(vC * PI / 180) / Sin(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & san & " " & Sprog.A(223), scn & "^2=" & sbn & "^2+" & san & "^2-2" & sbn & VBA.ChrW(183) & san & VBA.ChrW(183) & "cos(" & vCn & ")"
                AddElaborate Sprog.A(225) & " " & san, san & "=" & sbn & VBA.ChrW(183) & "cos(" & vCn & ")+" & VBA.ChrW(8730) & "(" & scn & "^2-" & sbn & "^2" & VBA.ChrW(183) & "sin(" & vCn & ")^2)=" & ConvertNumberToStringBC(SA)
                If d > 0 Then AddElaborate Sprog.A(226), san & "_2=" & sbn & VBA.ChrW(183) & "cos(" & vCn & ")-" & VBA.ChrW(8730) & "(" & scn & "^2-" & sbn & "^2" & VBA.ChrW(183) & "sin(" & vCn & ")^2)=" & ConvertNumberToStringBC(sa2)
                If sa2 < 0 Then AddElaborate Sprog.A(227), ""
                AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(223), vBn & "=cos^(-1) ((" & scn & "^2 + " & san & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & scn & VBA.ChrW(183) & san & "))=cos^(-1) ((" & ConvertNumberToStringBC(sc) & "^2 + " & ConvertNumberToStringBC(SA) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(216), vAn & "=180" & VBA.ChrW(176) & "-" & vCn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
                If d > 0 And sa2 > 0.000000000000001 Then
                    vC2 = vC
                    sb2 = sb
                    sc2 = sc
                    vB2 = Arccos((sc2 ^ 2 + sa2 ^ 2 - sb2 ^ 2) / (2 * sa2 * sc2)) * 180 / PI
                    vA2 = 180 - vB2 - vC2
                    AddElaborate vbCrLf & Sprog.A(228) & " " & san & " " & Sprog.A(229), ""
                    AddElaborate Sprog.A(215) & " " & vBn & VBA.ChrW(8322) & " " & Sprog.A(223), vBn & "_2=cos^(-1) ((" & scn & "^2 + " & san & "_2^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & scn & "" & VBA.ChrW(183) & san & "_2))=cos^(-1) ((" & ConvertNumberToStringBC(sc2) & "^2 + " & ConvertNumberToStringBC(sa2) & "^2 - " & ConvertNumberToStringBC(sb2) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sc2) & VBA.ChrW(183) & ConvertNumberToStringBC(sa2) & "))=" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176)
                    AddElaborate Sprog.A(215) & " " & vAn & VBA.ChrW(8322) & " " & Sprog.A(216), vAn & "_2=180" & VBA.ChrW(176) & "-" & vCn & "-" & vBn & "_2=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC2) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176)
                End If
            ElseIf SA > 0 And sc > 0 Then ' sider ikke om vinkel
                d = sc ^ 2 - SA ^ 2 * sIn(vC * PI / 180) ^ 2
                If d < 0 Then ' ingen l�sning
                    GoTo Fejl
                End If
                sb = SA * Cos(vC * PI / 180) + Sqr(d)
                sb2 = SA * Cos(vC * PI / 180) - Sqr(d)
                vB = Arccos((sc ^ 2 + SA ^ 2 - sb ^ 2) / (2 * SA * sc)) * 180 / PI
                vA = 180 - vB - vC
'                sc = sa * Sin(vC * PI / 180) / Sin(vA * PI / 180)
                AddElaborate Sprog.A(217) & " " & sbn & " " & Sprog.A(223), scn & "^2=" & sbn & "^2+" & san & "^2-2" & sbn & VBA.ChrW(183) & san & VBA.ChrW(183) & "cos(" & vCn & ")"
                AddElaborate Sprog.A(225) & " " & sbn, sbn & "=" & san & VBA.ChrW(183) & "cos(" & vCn & ")+" & VBA.ChrW(8730) & "(" & scn & "^2-" & san & "^2" & VBA.ChrW(183) & "sin(" & vCn & ")^2)=" & ConvertNumberToStringBC(sb)
                If d > 0 Then AddElaborate Sprog.A(226), sbn & "_2=" & san & VBA.ChrW(183) & "cos(" & vCn & ")-" & VBA.ChrW(8730) & "(" & scn & "^2-" & san & "^2" & VBA.ChrW(183) & "sin(" & vCn & ")^2)=" & ConvertNumberToStringBC(sb2)
                If sb2 < 0 Then AddElaborate Sprog.A(227), ""
                AddElaborate Sprog.A(215) & " " & vBn & " " & Sprog.A(223), vBn & "=cos^(-1) ((" & scn & "^2 + " & san & "^2 - " & sbn & "^2)/(2" & VBA.ChrW(183) & scn & VBA.ChrW(183) & san & "))=cos^(-1) ((" & ConvertNumberToStringBC(sc) & "^2 + " & ConvertNumberToStringBC(SA) & "^2 - " & ConvertNumberToStringBC(sb) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sc) & VBA.ChrW(183) & ConvertNumberToStringBC(SA) & "))=" & ConvertNumberToStringBC(vB) & VBA.ChrW(176)
                AddElaborate Sprog.A(215) & " " & vAn & " " & Sprog.A(216), vAn & "=180" & VBA.ChrW(176) & "-" & vCn & "-" & vBn & "=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vA) & VBA.ChrW(176)
                If d > 0 And sb2 > 0.000000000000001 Then
                    vC2 = vC
                    sa2 = SA
                    sc2 = sc
                    vB2 = Arccos((sc2 ^ 2 + sa2 ^ 2 - sb2 ^ 2) / (2 * sa2 * sc2)) * 180 / PI
                    vA2 = 180 - vB2 - vC2
                    AddElaborate vbCrLf & Sprog.A(228) & " " & sbn & " " & Sprog.A(229), ""
                    AddElaborate Sprog.A(215) & " " & vBn & VBA.ChrW(8322) & " " & Sprog.A(223), vBn & "_2=cos^(-1) ((" & scn & "^2 + " & san & "^2 - " & sbn & "_2^2)/(2" & VBA.ChrW(183) & scn & "" & VBA.ChrW(183) & san & "))=cos^(-1) ((" & ConvertNumberToStringBC(sc2) & "^2 + " & ConvertNumberToStringBC(sa2) & "^2 - " & ConvertNumberToStringBC(sb2) & "^2)/(2" & VBA.ChrW(183) & ConvertNumberToStringBC(sc2) & VBA.ChrW(183) & ConvertNumberToStringBC(sa2) & "))=" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176)
                    AddElaborate Sprog.A(215) & " " & vAn & VBA.ChrW(8322) & " " & Sprog.A(216), vAn & "_2=180" & VBA.ChrW(176) & "-" & vCn & "-" & vBn & "_2=180" & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vC2) & VBA.ChrW(176) & "-" & ConvertNumberToStringBC(vB2) & VBA.ChrW(176) & "=" & ConvertNumberToStringBC(vA2) & VBA.ChrW(176)
                End If
            End If
        End If
    End If
GoTo Slut
Fejl:
    statustext = Sprog.TSMissingInfo
    If advarsler Then MsgBox statustext, vbOKOnly, Sprog.Error
    Exit Sub
Slut:
    If SA <= 0 Or sb <= 0 Or sc <= 0 Or vA <= 0 Or vB <= 0 Or vC <= 0 Then
        GoTo Fejl
    Else
        succes = True
        statustext = Sprog.TSInfoOK
    End If
    If vA2 > 0 Then statustext = statustext & vbCrLf & "(" & Sprog.TS2Solutions2 & ")."

End Sub

#If Mac Then
Sub InsertTriangle(r As Range, ByVal vA As Double, ByVal sb As Double, ByVal sc As Double, NameA As String, NameB As String, NameC As String, Namesa As String, Namesb As String, Namesc As String, Anch As Range)
#Else
Sub InsertTriangle(r As Range, ByVal vA As Double, ByVal sb As Double, ByVal sc As Double, NameA As String, NameB As String, NameC As String, Namesa As String, Namesb As String, Namesc As String)
#End If

' givet vinkel A og siderne b og c tegner trekanten skaleret
Dim norm As Double
Dim maxs As Double
Dim xmin As Double
Dim ymax As Double
Dim nsa As Double
Dim nsb As Double
Dim nsc As Double
Dim xa As Double
Dim ya As Double
Dim dxa As Double
Dim dya As Double
Dim xb As Double
Dim yb As Double
Dim dxb As Double
Dim dyb As Double
Dim xc As Double
Dim yc As Double
Dim dxc As Double
Dim dyc As Double
Dim f As Double
Dim SA As Double



f = 200

SA = Sqr(sb ^ 2 + sc ^ 2 - 2 * sb * sc * Cos(vA * PI / 180))

If SA <= 0 Or sb <= 0 Or sc <= 0 Then
    MsgBox "Der er sider der er 0", vbOKOnly, Sprog.Error
    GoTo Slut
End If

If SA > sb Then maxs = SA Else maxs = sb
If sc > maxs Then maxs = sc

nsa = SA / maxs * f
nsb = sb / maxs * f
nsc = sc / maxs * f

xb = nsc * Cos(vA * PI / 180)
yb = 0
xa = 0
ya = nsc * sIn(vA * PI / 180)
xc = nsb
yc = ya

If xb < xa Then xmin = -xb
xa = xa + xmin + 10
xb = xb + xmin + 10
xc = xc + xmin + 10

ya = ya + 15
yb = yb + 15
yc = yc + 15


    Dim cv As Shape
    Dim lbl As Shape
    Dim l As Shape
#If Mac Then
    Dim l2 As Shape
    Dim l3 As Shape
#Else
    Set cv = ActiveDocument.Shapes.AddCanvas(0, 0, CSng(Maks(xb, xc) + 30), CSng(yc + 30), r)
    cv.WrapFormat.Type = wdWrapInline
#End If


#If Mac Then
    ' sidel�ngder
    AddLabel Namesa, (xc + xb) / 2 + 7 + ActiveDocument.PageSetup.LeftMargin, yc / 2 - 4 + Anch.Information(wdVerticalPositionRelativeToPage), Anch
    AddLabel Namesb, (xc + xa) / 2 - 3 + ActiveDocument.PageSetup.LeftMargin, yc + Anch.Information(wdVerticalPositionRelativeToPage), Anch
    AddLabel Namesc, (xb + xa) / 2 - 10 + ActiveDocument.PageSetup.LeftMargin, yc / 2 - 4 + Anch.Information(wdVerticalPositionRelativeToPage), Anch
    
    ya = ya + Anch.Information(wdVerticalPositionRelativeToPage)
    yb = yb + Anch.Information(wdVerticalPositionRelativeToPage)
    yc = yc + Anch.Information(wdVerticalPositionRelativeToPage)
    xa = xa + ActiveDocument.PageSetup.LeftMargin
    xb = xb + ActiveDocument.PageSetup.LeftMargin
    xc = xc + ActiveDocument.PageSetup.LeftMargin

    'vinkler
    AddLabel NameA, xa - 10, yc, Anch  ' yc-5 fjernet for at ikke skal st� oveni figur
    AddLabel NameB, xb - 4, Anch.Information(wdVerticalPositionRelativeToPage), Anch
    AddLabel NameC, xc + 5, yc, Anch

    Set l = ActiveDocument.Shapes.AddLine(CSng(xa), CSng(ya), CSng(xb), CSng(yb), Anch)  'Selection.Range
    l.Line.Weight = 1
    l.Line.Style = msoLineSingle
    l.Shadow.visible = msoFalse
'    l.Line.ForeColor = RGB(0, 0, 0)
'    l.Left = CSng(xa)
'    l.Top = CSng(ya)
    Set l2 = ActiveDocument.Shapes.AddLine(CSng(xa), CSng(ya), CSng(xc), CSng(yc), Anch) 'Selection.Range
    l2.Line.Weight = 1
    l2.Line.Style = msoLineSingle
    l2.Shadow.visible = msoFalse
    Set l3 = ActiveDocument.Shapes.AddLine(CSng(xc), CSng(yc), CSng(xb), CSng(yb), Anch) 'Selection.Range
    l3.Line.Weight = 1
    l3.Line.Style = msoLineSingle
    l3.Shadow.visible = msoFalse
    On Error GoTo Slut

#Else

    AddLabel NameA, xa - 10, yc, cv  ' yc-5 fjernet for at ikke skal st� oveni figur
    AddLabel NameB, xb - 4, 0, cv
    AddLabel NameC, xc + 5, yc, cv
    
    AddLabel Namesa, (xc + xb) / 2 + 7, yc / 2 - 4, cv
    AddLabel Namesb, (xc + xa) / 2 - 3, yc, cv
    AddLabel Namesc, (xb + xa) / 2 - 10, yc / 2 - 4, cv

    If val(Application.Version) >= 14 Then
        On Error GoTo v12
        cv.CanvasItems.AddConnector msoConnectorStraight, CSng(xa), CSng(ya), CSng(xc), CSng(yc)
        cv.CanvasItems.AddConnector msoConnectorStraight, CSng(xa), CSng(ya), CSng(xb), CSng(yb)
        cv.CanvasItems.AddConnector msoConnectorStraight, CSng(xc), CSng(yc), CSng(xb), CSng(yb)
        cv.Select
        Selection.Cut
        r.Paste
        ClearClipBoard
    Else
v12:
        On Error GoTo Slut
        cv.CanvasItems.AddConnector msoConnectorStraight, CSng(xa), CSng(ya), CSng(xc - xa), 0
        cv.CanvasItems.AddConnector msoConnectorStraight, CSng(xa), CSng(ya), CSng(xb - xa), CSng(yb - ya)
        cv.CanvasItems.AddConnector msoConnectorStraight, CSng(xc), CSng(yc), CSng(xb - xc), CSng(yb - yc)
    End If
#End If
    
    
    


'    AddLabel VBA.LCase(NameB), xb - 4, 0, cv
'    AddLabel VBA.LCase(NameC), xc + 5, yc - 5, cv

Slut:


End Sub
#If Mac Then
    Function AddLabel(text As String, x As Double, Y As Double, Anch As Range) As Shape
    Dim lbl As Shape
    Set lbl = ActiveDocument.Shapes.AddLabel(msoTextOrientationHorizontal, CSng(x), CSng(Y), 8, 14, Anch)
#Else
    Function AddLabel(text As String, x As Double, Y As Double, s As Shape) As Shape
    Dim lbl As Shape
    Set lbl = s.CanvasItems.AddLabel(msoTextOrientationHorizontal, CSng(x), CSng(Y), 8, 14)
    lbl.TextFrame.AutoSize = msoTrue
#End If
'    lbl.Height = 18
'    lbl.Width = 8
#If Mac Then
    lbl.WrapFormat.Type = 3 'wdwrapfront
#End If

    lbl.TextFrame.WordWrap = False
    lbl.TextFrame.TextRange.text = text
    lbl.TextFrame.TextRange.Font.Size = 10
    lbl.TextFrame.MarginBottom = 0
    lbl.TextFrame.MarginTop = 0
    lbl.TextFrame.MarginLeft = 0
    lbl.TextFrame.MarginRight = 0
    lbl.Line.visible = msoFalse
'    lbl.Select
'    Selection.ShapeRange.Fill.Transparency = 0#
    Set AddLabel = lbl
End Function


Private Sub OptionButton_navngivstorlille_Change()
OpdaterNavngivning
End Sub
Private Sub OptionButton_reth_Click()
On Error Resume Next
TextBox_C.text = 90
If CSng(TextBox_A.text) >= 90 Then TextBox_A.text = ""
TextBox_C.Enabled = False
TextBox_A.Enabled = True
#If Mac Then
#Else
    ImageTrekant.Picture = LoadPicture(GetProgramFilesDir & "\WordMat\Images\trekantreth.emf")
#End If
TextBox_A.Left = 32
TextBox_A.top = 186
TextBox_B.Left = 318
TextBox_B.top = 24
TextBox_C.Left = 318
TextBox_C.top = 174
TextBox_captionA.Left = 48
TextBox_captionA.top = 174
TextBox_captionB.Left = 300
TextBox_captionB.top = 24
TextBox_captionC.Left = 300
TextBox_captionC.top = 174

TextBox_sa.Left = 320
TextBox_sa.top = 90
TextBox_sb.Left = 151
TextBox_sb.top = 192
TextBox_sc.Left = 120
TextBox_sc.top = 90
TextBox_captionsa.Left = 305
TextBox_captionsa.top = 90
TextBox_captionsb.Left = 162
TextBox_captionsb.top = 180
TextBox_captionsc.Left = 160
TextBox_captionsc.top = 90
Me.Repaint

End Sub

Private Sub OptionButton_retv_Click()
On Error Resume Next
TextBox_A.text = 90
If CSng(TextBox_C.text) >= 90 Then TextBox_C.text = ""
TextBox_A.Enabled = False
TextBox_C.Enabled = True
#If Mac Then
#Else
ImageTrekant.Picture = LoadPicture(GetProgramFilesDir & "\WordMat\Images\trekantretv.emf")
#End If

TextBox_A.Left = 32
TextBox_A.top = 186
TextBox_B.Left = 10
TextBox_B.top = 24
TextBox_C.Left = 318
TextBox_C.top = 174
TextBox_captionA.Left = 48
TextBox_captionA.top = 174
TextBox_captionB.Left = 48
TextBox_captionB.top = 24
TextBox_captionC.Left = 300
TextBox_captionC.top = 174

TextBox_sa.Left = 195
TextBox_sa.top = 90
TextBox_sb.Left = 151
TextBox_sb.top = 192
TextBox_sc.Left = 5
TextBox_sc.top = 88
TextBox_captionsa.Left = 180
TextBox_captionsa.top = 90
TextBox_captionsb.Left = 162
TextBox_captionsb.top = 180
TextBox_captionsc.Left = 41
TextBox_captionsc.top = 90
Me.Repaint

End Sub

Private Sub OptionButton_vilk_Click()
On Error Resume Next
TextBox_A.Enabled = True
TextBox_C.Enabled = True
#If Mac Then
#Else
ImageTrekant.Picture = LoadPicture(GetProgramFilesDir & "\WordMat\Images\trekantvilk.emf")
#End If

TextBox_A.Left = 32
TextBox_A.top = 186
TextBox_B.Left = 115
TextBox_B.top = 12
TextBox_C.Left = 318
TextBox_C.top = 174
TextBox_captionA.Left = 48
TextBox_captionA.top = 174
TextBox_captionB.Left = 126
TextBox_captionB.top = 24
TextBox_captionC.Left = 300
TextBox_captionC.top = 174

TextBox_sa.Left = 234
TextBox_sa.top = 84
TextBox_sb.Left = 151
TextBox_sb.top = 192
TextBox_sc.Left = 38
TextBox_sc.top = 90
TextBox_captionsa.Left = 216
TextBox_captionsa.top = 84
TextBox_captionsb.Left = 162
TextBox_captionsb.top = 180
TextBox_captionsc.Left = 78
TextBox_captionsc.top = 90
Me.Repaint

End Sub
Static Function Log10(x)
    Log10 = Log(x) / Log(10#)
End Function
Function Arcsin(x As Double)
'Arcsin(X) = Atn(X / Sqr(-X * X + 1))
    If x = 1 Then
        Arcsin = PI / 2
    ElseIf x = -1 Then
        Arcsin = 3 / 2 * PI
    Else
        Arcsin = Atn(x / Sqr(-x * x + 1))
    End If
End Function
Function Arccos(x As Double)
'Arccos(X) = Atn(-X / Sqr(-X * X + 1)) + 2 * Atn(1)
    If x = 1 Then
        Arccos = 0
    ElseIf x = -1 Then
        Arccos = PI
    Else
        Arccos = Atn(-x / Sqr(-x * x + 1)) + 2 * Atn(1)
    End If
End Function

Function Maks(A As Double, b As Double)
    If A < b Then
        Maks = b
    Else
        Maks = A
    End If
End Function
Sub UpdateSolution()
    FindSolutions
    If succes Then
        Label_status.ForeColor = RGB(0, 255, 0)
    Else
        Label_status.ForeColor = RGB(255, 0, 0)
    End If
    Label_status.Caption = statustext
End Sub
Private Sub TextBox_A_Change()
    UpdateSolution
End Sub
Private Sub TextBox_B_Change()
    UpdateSolution
End Sub
Private Sub TextBox_C_Change()
    UpdateSolution
End Sub
Private Sub OptionButton_navngivsiderAB_Change()
OpdaterNavngivning
End Sub
Sub OpdaterNavngivning()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionA.text = VBA.UCase(TextBox_captionA.text)
    TextBox_captionsa.text = VBA.LCase(TextBox_captionA.text)
    TextBox_captionB.text = VBA.UCase(TextBox_captionB.text)
    TextBox_captionsb.text = VBA.LCase(TextBox_captionB.text)
    TextBox_captionC.text = VBA.UCase(TextBox_captionC.text)
    TextBox_captionsc.text = VBA.LCase(TextBox_captionC.text)
ElseIf OptionButton_navngivsiderAB.Value = True Then
    TextBox_captionsa.text = TextBox_captionB.text & TextBox_captionC.text
    TextBox_captionsb.text = TextBox_captionA.text & TextBox_captionC.text
    TextBox_captionsc.text = TextBox_captionA.text & TextBox_captionB.text
End If
OptionButton_retv.Caption = TextBox_captionA.text & " " & Sprog.right
OptionButton_reth.Caption = TextBox_captionC.text & " " & Sprog.right
End Sub
Private Sub TextBox_captionA_Change()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionA.text = VBA.UCase(TextBox_captionA.text)
    TextBox_captionsa.text = VBA.LCase(TextBox_captionA.text)
ElseIf OptionButton_navngivsiderAB.Value = True Then
    OpdaterNavngivning
End If
OptionButton_retv.Caption = TextBox_captionA.text & " " & Sprog.right
End Sub

Private Sub TextBox_captionB_Change()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionB.text = VBA.UCase(TextBox_captionB.text)
    TextBox_captionsb.text = VBA.LCase(TextBox_captionB.text)
ElseIf OptionButton_navngivsiderAB.Value = True Then
    OpdaterNavngivning
End If
End Sub

Private Sub TextBox_captionC_Change()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionC.text = VBA.UCase(TextBox_captionC.text)
    TextBox_captionsc.text = VBA.LCase(TextBox_captionC.text)
ElseIf OptionButton_navngivsiderAB.Value = True Then
    OpdaterNavngivning
End If
OptionButton_reth.Caption = TextBox_captionC.text & " " & Sprog.right
End Sub

Private Sub TextBox_captionsa_Change()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionsa.text = VBA.LCase(TextBox_captionsa.text)
    TextBox_captionA.text = VBA.UCase(TextBox_captionsa.text)
End If
OpdaterNavngivning
End Sub

Private Sub TextBox_captionsb_Change()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionsb.text = VBA.LCase(TextBox_captionsb.text)
    TextBox_captionB.text = VBA.UCase(TextBox_captionsb.text)
End If
OpdaterNavngivning
End Sub

Private Sub TextBox_captionsc_Change()
If OptionButton_navngivstorlille.Value = True Then
    TextBox_captionsc.text = VBA.LCase(TextBox_captionsc.text)
    TextBox_captionC.text = VBA.UCase(TextBox_captionsc.text)
End If
OpdaterNavngivning
End Sub

Private Sub TextBox_sa_Change()
    UpdateSolution
End Sub
Private Sub TextBox_sb_Change()
    UpdateSolution
End Sub
Private Sub TextBox_sc_Change()
    UpdateSolution
End Sub

Sub AddElaborate(text As String, lign As String)

    elabotext(elaboindex) = text
    elabolign(elaboindex) = lign
    
    elaboindex = elaboindex + 1
End Sub

Private Sub UserForm_Activate()
    SaveBackup
    SetCaptions
#If Mac Then
    Frame1.visible = False
#End If
    TextBox_A.text = TriangleAV
    TextBox_B.text = TriangleBV
    TextBox_C.text = TriangleCV
    TextBox_sa.text = TriangleAS
    TextBox_sb.text = TriangleBS
    TextBox_sc.text = TriangleCS
    
    If TriangleSett1 = 1 Then
        OptionButton_retv.Value = True
    ElseIf TriangleSett1 = 2 Then
        OptionButton_reth.Value = True
    Else
        OptionButton_vilk.Value = True
    End If
    If TriangleSett2 = 1 Then
        OptionButton_navngivmanuel.Value = True
    ElseIf TriangleSett2 = 2 Then
        OptionButton_navngivstorlille.Value = True
    Else
        OptionButton_navngivsiderAB.Value = True
    End If
    

    If TriangleNAS = "" And TriangleNBS = "" And TriangleNCS = "" And TriangleNAV = "" And TriangleNBV = "" And TriangleNCV = "" Then
     TriangleNAS = "A"
     TriangleNBS = "B"
    TriangleNCS = "C"
    TriangleNAV = "a"
    TriangleNBV = "b"
    TriangleNCV = "c"
    TriangleSett1 = 3
    TriangleSett2 = 2
    TriangleSett3 = False
    TriangleSett4 = False
    End If
    TextBox_captionA.text = TriangleNAV
    TextBox_captionB.text = TriangleNBV
    TextBox_captionC.text = TriangleNCV
    TextBox_captionsa.text = TriangleNAS
    TextBox_captionsb.text = TriangleNBS
    TextBox_captionsc.text = TriangleNCS
    CheckBox_tal.Value = TriangleSett3
    CheckBox_forklaring.Value = TriangleSett4
    
    OpdaterNavngivning
End Sub

Private Sub SaveSettings()
    TriangleAV = TextBox_A.text
    TriangleBV = TextBox_B.text
    TriangleCV = TextBox_C.text
    TriangleAS = TextBox_sa.text
    TriangleBS = TextBox_sb.text
    TriangleCS = TextBox_sc.text
    TriangleNAV = TextBox_captionA.text
    TriangleNBV = TextBox_captionB.text
    TriangleNCV = TextBox_captionC.text
    TriangleNAS = TextBox_captionsa.text
    TriangleNBS = TextBox_captionsb.text
    TriangleNCS = TextBox_captionsc.text
    TriangleSett3 = CheckBox_tal.Value
    TriangleSett4 = CheckBox_forklaring.Value
    If OptionButton_retv.Value Then
        TriangleSett1 = 1
    ElseIf OptionButton_reth.Value = True Then
        TriangleSett1 = 2
    Else
        TriangleSett1 = 3
    End If
    If OptionButton_navngivmanuel.Value = True Then
        TriangleSett2 = 1
    ElseIf OptionButton_navngivstorlille.Value = True Then
        TriangleSett2 = 2
    Else
        TriangleSett2 = 3
    End If

End Sub


Private Sub SetCaptions()
    Me.Caption = Sprog.TriangleSolver
    CommandButton_ok.Caption = Sprog.OK
    Frame1.Caption = Sprog.RightAngled & "?"
    Frame2.Caption = Sprog.Naming
    OptionButton_navngivmanuel.Caption = Sprog.Manuel
    OptionButton_navngivstorlille.Caption = Sprog.AngleNaming1
    OptionButton_navngivsiderAB.Caption = Sprog.AngleNaming2
    CheckBox_tal.Caption = Sprog.InsertNumbers
    CheckBox_forklaring.Caption = Sprog.ShowCalculations
    Label1.Caption = Sprog.TriangleSolverExplanation1
    Label2.Caption = Sprog.TriangleSolverExplanation2
    OptionButton_vilk.Caption = Sprog.AnyTriangle
    CommandButton_nulstil.Caption = Sprog.Clear
    
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    SaveSettings
End Sub


