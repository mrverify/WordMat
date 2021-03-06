VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} UserFormOmskriv 
   Caption         =   "Omskriv"
   ClientHeight    =   5470
   ClientLeft      =   -30
   ClientTop       =   75
   ClientWidth     =   9480.001
   OleObjectBlob   =   "UserFormOmskriv.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "UserFormOmskriv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Public annuller As Boolean
Public tempDefs As String
Public vars As String
Public SammeLinje As Boolean

Private Sub CommandButton_annuller_Click()
    annuller = True
    Me.hide
End Sub
Sub ExecuteOK()
    If OptionButton_numonly.Value = True Then
        MaximaExact = 2
    ElseIf OptionButton_exactonly.Value = True Then
        MaximaExact = 1
    Else
        MaximaExact = 0
    End If
'    MaximaVidNotation = CheckBox_vidnotation.value
    MaximaCifre = ComboBox_cifre.Value
    If MaximaUnits Then
        If OutUnits <> TextBox_outunits.text Then
            OutUnits = TextBox_outunits.text
            omax.MaximaInputStreng = omax.MaximaInputStreng & "uforget(append(globalbaseunitlisting,globalderivedunitlisting))$"
            If TextBox_outunits.text <> "" Then omax.MaximaInputStreng = omax.MaximaInputStreng & "setunits(" & omax.ConvertUnits(TextBox_outunits.text) & ")$"
        End If
    End If

    If OptionButton_logauto.Value = True Then
        MaximaLogOutput = 0
    ElseIf OptionButton_log10.Value = True Then
        MaximaLogOutput = 2
    Else
        MaximaLogOutput = 1
    End If


    tempDefs = TextBox_def.text
    tempDefs = Trim(tempDefs)
    If Len(tempDefs) > 2 Then
    tempDefs = Replace(tempDefs, ",", ".")
    arr = Split(tempDefs, VbCrLfMac)
    tempDefs = ""
    For i = 0 To UBound(arr)
        If Len(arr(i)) > 2 And Not right(arr(i), 1) = "=" Then
            tempDefs = tempDefs & arr(i) & ListSeparator
        End If
    Next
    If right(tempDefs, 1) = ListSeparator Then
        tempDefs = Left(tempDefs, Len(tempDefs) - 1)
    End If
    End If


    Me.hide
    Application.ScreenUpdating = falses

End Sub
Private Sub CommandButton_ok_Click()
    SammeLinje = False
    ExecuteOK
End Sub

Private Sub CommandButton_oksammelinje_Click()
    SammeLinje = True
    ExecuteOK
End Sub

Private Sub UserForm_Activate()
Dim arr As Variant
    SetCaptions
    If MaximaUnits Then
        Label_enheder.visible = True
        TextBox_outunits.visible = True
        TextBox_outunits.text = OutUnits
    Else
        Label_enheder.visible = False
        TextBox_outunits.visible = False
    End If
    
    If MaximaExact = 1 Then
        OptionButton_exactonly.Value = True
    ElseIf MaximaExact = 2 Then
        OptionButton_numonly.Value = True
    Else
        OptionButton_exactandnum.Value = True
    End If

    If MaximaLogOutput = 0 Then
        OptionButton_logauto.Value = True
    ElseIf MaximaLogOutput = 2 Then
        OptionButton_log10.Value = True
    Else
        OptionButton_ln.Value = True
    End If

    CheckBox_vidnotation.Value = MaximaVidNotation
    ComboBox_cifre.Value = MaximaCifre

    
    
    arr = Split(vars, ";")
    ' definitioner vises
    
    For i = 0 To UBound(arr)
        If arr(i) <> "" Then
            TextBox_def.text = TextBox_def.text & arr(i) & "=" & VbCrLfMac    ' midlertidige definitioner
        End If
    Next
    Application.ScreenUpdating = True

End Sub
Sub FillComboBoxCifre()
Dim i As Integer
    For i = 2 To 16
        ComboBox_cifre.AddItem i
    Next

End Sub

Private Sub UserForm_Initialize()
    FillComboBoxCifre
End Sub

Private Sub SetCaptions()
    Me.Caption = Sprog.RibReduce
    Label5.Caption = Sprog.tempDefs
    Frame6.Caption = Sprog.Logarithm & " output"
    CommandButton_annuller.Caption = Sprog.Cancel
    Label_enheder.Caption = Sprog.OutputUnits
    Label6.Caption = Sprog.SignificantFigures
    CheckBox_vidnotation.Caption = Sprog.ScientificNotation
    Frame5.Caption = Sprog.Exact & "?"
    OptionButton_exactonly.Caption = Sprog.Exact
    OptionButton_numonly.Caption = Sprog.Numeric
    Label8.Caption = Sprog.TempSettings
    CheckBox_auto.Caption = Sprog.AutoReduce
    Label_omskriv.Caption = Sprog.AutoReduceExplain
    CheckBox_factor.Caption = Sprog.Factor
    Label_factor.Caption = Sprog.FactorExplain
    CheckBox_expand.Caption = Sprog.Expand
    Label_expand.Caption = Sprog.ExpandExplain
    CheckBox_rationaliser.Caption = Sprog.Rationalize
    Label_rationaliser.Caption = Sprog.RationalizeExplain
    CheckBox_trigreduce.Caption = Sprog.TrigReduce
    Label_trigreduce.Caption = Sprog.TrigReduceExplain
    CommandButton_oksammelinje.Caption = Sprog.OKSame
    CommandButton_ok.Caption = Sprog.OKNew
    
End Sub
