Attribute VB_Name = "Grafer"
Option Explicit
Public UF2Dgraph As UserForm2DGraph
Public ReplacedVar As String  ' contains var which was replaced by x by replaceindepvarx
Public Sub StandardPlot()
    If GraphApp = 0 Then
        Plot2DGraph
    ElseIf GraphApp = 1 Then
        InsertGraphOleObject
    ElseIf GraphApp = 2 Then
        GeoGebra
    ElseIf GraphApp = 3 Then
        InsertChart
    End If
End Sub
Public Sub Plot2DGraph()
'    Dim omax As New CMaxima
    Dim forskrifter As String
    Dim arr As Variant
    Dim i As Integer
    Dim j As Integer
    On Error GoTo Fejl
    Dim sstart As Long, sslut As Long
    sstart = Selection.start
    sslut = Selection.End

    PrepareMaxima
    omax.ReadSelection
'    If UF2Dgraph Is Nothing Then
       Set UF2Dgraph = New UserForm2DGraph
'    End If
    
'    forskrifter = omax.FindDefinitions
'    If Len(forskrifter) > 3 Then
'    forskrifter = Mid(forskrifter, 2, Len(forskrifter) - 3)
'    arr = Split(forskrifter, ",")
'    forskrifter = ""
    
'    For i = 0 To UBound(arr)
'        If InStr(arr(i), "):") > 0 Then
'            forskrifter = forskrifter & omax.ConvertToWordSymbols(arr(i)) & ListSeparator
'        End If
'    Next
'    End If
    
'    If forskrifter <> "" Then
'        forskrifter = Left(forskrifter, Len(forskrifter) - 1)
'    End If
'    forskrifter = omax.KommandoerStreng & ListSeparator & forskrifter
    
    forskrifter = omax.KommandoerStreng
    
    If Len(forskrifter) > 1 Then
    arr = Split(forskrifter, ListSeparator)
    For i = 0 To UBound(arr)
        arr(i) = Trim(Replace(arr(i), "  ", " ")) ' m� ikke fjerne alle mellemrum da f.eks 1/x 3 s� bliver 1/x3 hvor x3 er variabel
        If arr(i) <> "" Then InsertNextEquation (arr(i))
    Next
    End If
    
    'datapunkter
    If Selection.Tables.Count > 0 Then
        Dim Cregr As New CRegression, xmin As Double, xmax As Double
        Cregr.GetTableData
        If UF2Dgraph.TextBox_punkter.text <> "" Then UF2Dgraph.TextBox_punkter.text = UF2Dgraph.TextBox_punkter.text & VbCrLfMac
        xmin = Cregr.XValues(1)
        xmax = Cregr.XValues(1)
        For j = 1 To UBound(Cregr.XValues)
'            UF2Dgraph.TextBox_punkter.text = UF2Dgraph.TextBox_punkter.text & CStr(Cregr.XValues(j)) & ListSeparator & CStr(Cregr.YValues(j)) & vbCrLf
            UF2Dgraph.TextBox_punkter.text = UF2Dgraph.TextBox_punkter.text & ConvertNumber(Cregr.XValues(j)) & ListSeparator & ConvertNumber(Cregr.YValues(j)) & VbCrLfMac
            If Cregr.XValues(j) > xmax Then xmax = Cregr.XValues(j)
            If Cregr.XValues(j) < xmin Then xmin = Cregr.XValues(j)
        Next
        UF2Dgraph.TextBox_xmin = xmin
        UF2Dgraph.TextBox_xmax = xmax
    End If
    
'    UserForm2DGraph.Show vbModeless
    Selection.End = sslut ' slut skal v�re f�rst ellers g�r det galt
    Selection.start = sstart
    UF2Dgraph.Show vbModeless
    
    GoTo Slut
Fejl:
    MsgBox Sprog.ErrorGeneral, vbOKOnly, Sprog.Error
Slut:
End Sub
Sub InsertNextEquation(Ligning As String)
Dim arr As Variant
On Error GoTo Fejl
Ligning = Replace(Ligning, VBA.ChrW(8788), "=") ' :=
Ligning = Replace(Ligning, VBA.ChrW(8797), "=") ' tripel =
Ligning = Replace(Ligning, VBA.ChrW(8801), "=") ' def =

arr = Split(Ligning, "=")

If Not (InStr(Ligning, VBA.ChrW(9608)) > 0 And InStr(Ligning, VBA.ChrW(9508)) > 0) Then ' tuborg
   arr = Split(arr(UBound(arr)), VBA.ChrW(8776)) ' til inds�ttelse af selve forskrift i stedet for f(x)
   Ligning = omax.ConvertToAscii(arr(UBound(arr)))
End If
Ligning = omax.ConvertToAscii(Trim(Replace(Replace(Replace(Replace(arr(0), "Definer:", ""), "Define:", ""), "definer:", ""), "define:", "")))

If UF2Dgraph.TextBox_ligning1.text = Ligning Then
    Exit Sub
ElseIf UF2Dgraph.TextBox_ligning2.text = Ligning Then
    Exit Sub
ElseIf UF2Dgraph.TextBox_ligning3.text = Ligning Then
    Exit Sub
ElseIf UF2Dgraph.TextBox_ligning4.text = Ligning Then
    Exit Sub
ElseIf UF2Dgraph.TextBox_ligning5.text = Ligning Then
    Exit Sub
ElseIf UF2Dgraph.TextBox_ligning6.text = Ligning Then
    Exit Sub
End If

If UF2Dgraph.TextBox_ligning1.text = "" Then
    UF2Dgraph.TextBox_ligning1.text = Ligning
ElseIf UF2Dgraph.TextBox_ligning2.text = "" Then
    UF2Dgraph.TextBox_ligning2.text = Ligning
ElseIf UF2Dgraph.TextBox_ligning3.text = "" Then
    UF2Dgraph.TextBox_ligning3.text = Ligning
ElseIf UF2Dgraph.TextBox_ligning4.text = "" Then
    UF2Dgraph.TextBox_ligning4.text = Ligning
ElseIf UF2Dgraph.TextBox_ligning5.text = "" Then
    UF2Dgraph.TextBox_ligning5.text = Ligning
ElseIf UF2Dgraph.TextBox_ligning6.text = "" Then
    UF2Dgraph.TextBox_ligning6.text = Ligning
End If
GoTo Slut
Fejl:
    MsgBox Sprog.ErrorGeneral, vbOKOnly, Sprog.Error
Slut:
End Sub

Sub Inds�t2DPlot(ByVal udtryk As String, x() As Double, Y() As Double)
    Dim MathSyntax As String
    Dim objEq As OMath
    Dim objRange As Range
    Dim i As Integer

    Set objRange = Selection.Range
    MathSyntax = "show("
    
    If udtryk <> "" Then
        If Len(MathSyntax) > 5 Then MathSyntax = MathSyntax + ","
        If InStr(udtryk, "=") Then
            MathSyntax = MathSyntax & "ploteq("
        Else
            MathSyntax = MathSyntax & "plot("
        End If
        MathSyntax = MathSyntax & udtryk
        MathSyntax = MathSyntax + ")"
    End If
    
    'datapunkter
    If UBound(x) > 1 Then
        If Len(MathSyntax) > 5 Then MathSyntax = MathSyntax + ","
        MathSyntax = MathSyntax + "plotdataset({"
        For i = 1 To UBound(x)
            MathSyntax = MathSyntax + "{" & Replace(x(i), ",", ".") & "," & Replace(Y(i), ",", ".") & "},"
        Next
        MathSyntax = Left(MathSyntax, Len(MathSyntax) - 1)
        
        MathSyntax = MathSyntax + "})"
    End If
    
       
    
    MathSyntax = MathSyntax + ")"
'    Selection.Range.Collapse (wdCollapseEnd)
'    Selection.MoveRight Unit:=wdWord, Count:=1
'    Selection.TypeParagraph
    
   Selection.OMaths.Add Range:=Selection.Range
     Selection.TypeText text:=MathSyntax
    Selection.OMaths.BuildUp
'    Set objEq = objRange.OMaths(1)
'    objEq.BuildUp
    Selection.TypeParagraph

'    UserForm2DGraph.Hide
    
Slut:

End Sub
Sub PlotDF()
' plot retningsfelt
    Dim forskrifter As String
    Dim arr As Variant
    Dim i As Integer
    Dim j As Integer
    Dim ea As New ExpressionAnalyser
  '  On Error GoTo fejl
    Dim sstart As Long, sslut As Long
    sstart = Selection.start
    sslut = Selection.End
        
    PrepareMaxima
    omax.ReadSelection
    Set UF2Dgraph = New UserForm2DGraph
       
'    forskrifter = omax.KommandoerStreng
    
        
    If Len(omax.Kommando) > 0 Then
    arr = Split(omax.Kommando, "=")
    omax.Kommando = arr(UBound(arr))
    End If
    UF2Dgraph.TextBox_dfligning.text = omax.ConvertToAscii(omax.Kommando)
    
    omax.FindVariable
    If InStr(omax.vars, "x") > 0 Then
        UF2Dgraph.TextBox_dfx.text = "x"
    ElseIf InStr(omax.vars, "t") > 0 Then
        UF2Dgraph.TextBox_dfx.text = "t"
    Else
        UF2Dgraph.TextBox_dfx.text = "x"
    End If
    If InStr(omax.vars, "y") > 0 Then
        UF2Dgraph.TextBox_dfy.text = "y"
    ElseIf InStr(omax.vars, "N") > 0 Then
        UF2Dgraph.TextBox_dfy.text = "N"
    Else
        ea.text = omax.vars
        UF2Dgraph.TextBox_dfy.text = ea.GetNextVar
        If UF2Dgraph.TextBox_dfy.text = "" Then UF2Dgraph.TextBox_dfy.text = "y"
    End If



    Selection.End = sslut ' slut skal v�re f�rst ellers g�r det galt
    Selection.start = sstart
    UF2Dgraph.MultiPage1.Value = 5
    UF2Dgraph.MultiPage1.SetFocus
    UF2Dgraph.Show vbModeless

    GoTo Slut
Fejl:
    MsgBox Sprog.ErrorGeneral, vbOKOnly, Sprog.Error
Slut:
End Sub

Sub InsertEmptyGraphOleObject()
' inds�tter graph object www.padowan.dk
Dim path As String
Dim ils As InlineShape
Application.ScreenUpdating = False

If Not FileExists(GetProgramFilesDir & "\Graph\graph.exe") Then
    Dim Result As VbMsgBoxResult
    Result = MsgBox(Sprog.A(366), vbOKCancel, Sprog.Error)
    If Result = vbOK Then
        OpenLink ("http://www.padowan.dk/graph/Download.php")
    End If
    Exit Sub
End If

'path = """" & GetProgramFilesDir & "\WordMat\graphtemplate.grf"""

' inds�t vha. classname
Set ils = ActiveDocument.InlineShapes.AddOLEObject(ClassType:="GraphFile", FileName:="", Range:=Selection.Range, LinkToFile:=False, DisplayAsIcon:=False)

'inds�t vha. tom graphfil. Nok lidt langsommere, men kan p� et tidspunkt m�ske bruges til kommunikation
'Set ils = ActiveDocument.InlineShapes.AddOLEObject(FileName:=path, LinkToFile:=False, DisplayAsIcon:=False, Range:=Selection.Range)
'ils.OLEFormat.DoVerb (wdOLEVerbShow)

Application.ScreenUpdating = True

End Sub
Sub InsertGraphOleObject()
' inds�tter graph object www.padowan.dk
#If Mac Then
    MsgBox "Sorry. Graph is not supported on Mac. There is a beta version you could try though. You will now be forwarded to the download page", vbOKOnly, Sprog.Error
    OpenLink "http://www.padowan.dk/mac/"
#Else
Dim path As String
Dim ils As InlineShape
Dim fkt As String
Dim arr As Variant
Dim fktnavn As String, udtryk As String, lhs As String, RHS As String, varnavn As String, fktudtryk As String
Dim dd As New DocData
Dim listform As String
Dim ea As New ExpressionAnalyser
Dim p As Integer
    Dim sslut As Long
    sslut = Selection.End

ea.SetNormalBrackets
    Dim ufwait As New UserFormWaitForMaxima
    ufwait.Label_tip.Caption = Sprog.A(371)
    ufwait.Label_progress.Caption = "***"
    ufwait.CommandButton_stop.visible = False
    ufwait.Show vbModeless
On Error GoTo Fejl
Application.ScreenUpdating = False

If Not FileExists(GetProgramFilesDir & "\Graph\graph.exe") Then
    Dim Result As VbMsgBoxResult
    Result = MsgBox(Sprog.A(366), vbOKCancel, Sprog.Error)
    If Result = vbOK Then
        OpenLink ("http://www.padowan.dk/graph/Download.php")
    End If
    Exit Sub
End If

'path = """" & GetProgramFilesDir & "\WordMat\graphtemplate.grf"""
path = Environ("TEMP") & "\" & "wordmatgraph.grf"
'path = "c:\wordmatgraph.grf" ' til test

Dim graphfil As New CGraphFile
Dim deflist As String, deflist2 As String
Dim i As Integer
    PrepareMaxima
    omax.ConvertLnLog = False
    omax.FindDefinitions
    omax.ReadSelection
    omax.ConvertLnLog = True
        
    For i = omax.defindex - 1 To 0 Step -1
        deflist = deflist & "," & omax.DefName(i)
    Next
    
    For i = omax.defindex - 1 To 0 Step -1
'        graphfil.InsertFunction omax.DefValue(i)
        If InStr(omax.DefValue(i), "matrix") < 1 Then ' matricer og vektorer er ikke implementeret endnu
            If Not (InStr(deflist2, omax.DefName(i)) > 0) Then ' hvis ikke allerede defineret
               deflist2 = deflist2 & "," & omax.DefName(i)
               graphfil.AddCustomFunction omax.DefName(i) & "=" & omax.DefValue(i)
                p = InStr(omax.DefName(i), "(")
                If p > 0 Then
                    graphfil.InsertFunction Left(omax.DefName(i), p - 1) & "(x)", 0
                Else
                    graphfil.InsertFunction omax.DefName(i), 0
                End If
                DefinerKonstanterGraph omax.DefValue(i), deflist, graphfil
            End If
        End If
    Next
    
    ' funktioner der markeres
    For i = 0 To omax.KommandoArrayLength
        udtryk = omax.KommandoArray(i)
        udtryk = Replace(udtryk, "definer:", "")
        udtryk = Replace(udtryk, "Definer:", "")
        udtryk = Replace(udtryk, "define:", "")
        udtryk = Replace(udtryk, "Define:", "")
        udtryk = Trim(udtryk)
        udtryk = Replace(udtryk, VBA.ChrW(8788), "=") ' :=
        udtryk = Replace(udtryk, VBA.ChrW(8797), "=") ' tripel =
        udtryk = Replace(udtryk, VBA.ChrW(8801), "=") ' def =
        If Len(udtryk) > 0 Then
            If InStr(udtryk, "matrix") < 1 Then ' matricer og vektorer er ikke implementeret endnu
                If InStr(udtryk, "=") > 0 Then
                    arr = Split(udtryk, "=")
                    lhs = arr(0)
                    RHS = arr(1)
                    ea.text = lhs
                    fktnavn = ea.GetNextVar(1)
                    varnavn = ea.GetNextBracketContent(1)
                    If lhs = fktnavn & "(" & varnavn & ")" Then
                        ea.text = RHS
                        ea.pos = 1
                        ea.ReplaceVar varnavn, "x"
                        fktudtryk = ea.text
                        DefinerKonstanterGraph fktudtryk, deflist, graphfil
                        graphfil.InsertFunction fktudtryk
                    Else
                        DefinerKonstanterGraph udtryk, deflist, graphfil, True
                        graphfil.InsertRelation udtryk
                        ' blev brugt f�r relation
'                        fktudtryk = ReplaceIndepvarX(rhs)
'                        DefinerKonstanterGraph fktudtryk, deflist, graphfil
'                        graphfil.InsertFunction fktudtryk
                    End If
                ElseIf InStr(udtryk, ">") > 0 Or InStr(udtryk, "<") > 0 Or InStr(udtryk, VBA.ChrW(8804)) > 0 Or InStr(udtryk, VBA.ChrW(8805)) > 0 Then
                    DefinerKonstanterGraph udtryk, deflist, graphfil, True
                    graphfil.InsertRelation udtryk
                Else
                    udtryk = ReplaceIndepvarX(udtryk)
                    DefinerKonstanterGraph udtryk, deflist, graphfil
                    graphfil.InsertFunction udtryk
               End If
            End If
        End If
    Next
    
    'datapunkter
    If Selection.Tables.Count > 0 Then
        Dim Cregr As New CRegression, setdata As String, j As Integer
        Cregr.GetTableData
        For j = 1 To UBound(Cregr.XValues)
'            UF2Dgraph.TextBox_punkter.text = UF2Dgraph.TextBox_punkter.text & CStr(Cregr.XValues(j)) & ListSeparator & CStr(Cregr.YValues(j)) & vbCrLf
'            setdata = setdata & ConvertNumber(Cregr.XValues(j)) & "," & ConvertNumber(Cregr.YValues(j)) & ";" '
            setdata = setdata & Replace(Cregr.XValues(j), ",", ".") & "," & Replace(Cregr.YValues(j), ",", ".") & ";"
        Next
        If Len(setdata) > 0 Then
            setdata = Left(setdata, Len(setdata) - 1)
            graphfil.InsertPointSeries setdata
        End If
    End If
    
' dette virker kun hvis punkterne er i lodret tabel
'    dd.ReadSelection
'    If Len(dd.GetSetForm) > 4 Then
'        listform = dd.GetSetForm
'        listform = Mid(listform, 4, Len(listform) - 4)
'        listform = Replace(listform, "),(", ";")
'        listform = Replace(listform, ")", ";")
'        graphfil.InsertPointSeries listform
'    End If
    
    Selection.start = sslut
    Selection.End = sslut
    
    
    If Selection.OMaths.Count > 0 Then
        omax.GoToEndOfSelectedMaths
    End If
    If Selection.Tables.Count > 0 Then
        Selection.Tables(Selection.Tables.Count).Select
        Selection.Collapse wdCollapseEnd
    End If
    Selection.MoveRight wdCharacter, 1
    Selection.TypeParagraph
    
    
    ufwait.Label_progress.Caption = "******"

    If graphfil.funkno > 0 Or Len(graphfil.CustomFunctions) > 0 Or graphfil.relationno > 0 Or graphfil.pointno > 0 Then
        graphfil.Save path

        'inds�t vha. tom graphfil. Nok lidt langsommere, men kan p� et tidspunkt m�ske bruges til kommunikation
        Set ils = ActiveDocument.InlineShapes.AddOLEObject(FileName:=path, LinkToFile:=False, DisplayAsIcon:=False, Range:=Selection.Range)
        ils.OLEFormat.DoVerb (wdOLEVerbShow)

    Else
        ' inds�t vha. classname
        Set ils = ActiveDocument.InlineShapes.AddOLEObject(ClassType:="GraphFile", FileName:="", Range:=Selection.Range, LinkToFile:=False, DisplayAsIcon:=False)
    End If

    DoEvents
    Unload ufwait

Application.ScreenUpdating = True
GoTo Slut
Fejl:
    MsgBox Sprog.A(97), vbOKOnly, Sprog.Error
    omax.ConvertLnLog = True
    Unload ufwait
Slut:
    omax.ConvertLnLog = True
    
#End If
End Sub
#If Mac Then
#Else
Sub DefinerKonstanterGraph(Expr As String, deflist As String, ByRef graphfil As CGraphFile, Optional noty As Boolean = False)
' definer variable der ikke er defineret i expr
' deflist er en liste af variable der er defineret
Dim ea As New ExpressionAnalyser
Dim ea2 As New ExpressionAnalyser
Dim var As String
    ea.text = deflist
    If noty Then ea.text = ea.text & ",y"
    ea2.text = Expr
    ea2.pos = 0
    Do
        var = ea2.GetNextVar
        ea2.pos = ea2.pos + 1
        If Not (ea2.ChrByIndex(ea2.pos) = "(") And Not (ea.IsFunction(var)) And Not (ea.ContainsVar(var)) And var <> "" And var <> "x" And var <> "y" And var <> "e" And var <> "pi" And var <> "matrix" Then ' m�ske ikke y? kopieret fra geogebra
            graphfil.AddCustomFunction var & "=" & InputBox(Sprog.A(363) & " " & var & vbCrLf & vbCrLf & Sprog.A(367), Sprog.A(365), "1")
            deflist = deflist & "," & var
        End If
    Loop While var <> ""

End Sub
#End If
Function ReplaceIndepvarX(fkt As String) As String
' s�rger for at inds�tte x som uafh variabel
' hvis den ikke er i udtrykket sp�rges
Dim ea As New ExpressionAnalyser
Dim var As String
Dim uvar As String
ea.text = fkt
var = ea.GetNextVar
ReplacedVar = "x"
If Not (ea.ContainsVar("x")) And var <> "" Then
    If ea.ContainsVar("t") Then
        uvar = "t"
    Else
        uvar = var
    End If
    uvar = InputBox(Sprog.A(368) & vbCrLf & vbCrLf & "   " & fkt & vbCrLf & vbCrLf, Sprog.A(369), uvar)
    If uvar = "" Then uvar = "x"
    If uvar <> "x" Then
        ea.ReplaceVar uvar, "x"
    End If
    ReplacedVar = uvar
End If

ReplaceIndepvarX = ea.text
End Function
Sub InsertChart()
Dim path As String
Dim ils As InlineShape
'Dim ws As Worksheet
'Dim wb As Workbook
Dim wb As Object
Dim ws As Object
'Dim xlap As Excel.Application
Dim xlap As Object 'Excel.Application
Dim tb As TextBox
Dim forskrift As String
Dim xmin As Double, xmax As Double
Dim plinjer As Variant
Dim linje As Variant
Dim i As Integer
Dim fktnavn As String, udtryk As String, lhs As String, RHS As String, varnavn As String, fktudtryk As String
Dim arr As Variant
Dim dd As New DocData
Dim ea As New ExpressionAnalyser
Dim srange As Range
On Error GoTo Fejl
ea.SetNormalBrackets
    Dim sstart As Long, sslut As Long
    sstart = Selection.start
    sslut = Selection.End
    Set srange = Selection.Range

Application.DisplayAlerts = Word.WdAlertLevel.wdAlertsNone

'PrepareMaxima
'omax.ReadSelection
dd.ReadSelection

'cxl.PrePareExcel
    DoEvents

Application.ScreenUpdating = False
    Dim ufwait2 As New UserFormWaitForMaxima
    ufwait2.Show vbModeless
    DoEvents
    ufwait2.Label_progress = "***"

If Not ExcelIndlejret Then ' �ben i excel
    If cxl Is Nothing Then Set cxl = New CExcel
    cxl.LoadFile ("Graphs.xltm")
    ufwait2.Label_progress = ufwait2.Label_progress & "***"
    Set wb = cxl.xlwb
'    Set ws = cxl.xlwb.worksheets(1)
    Set ws = cxl.XLapp.ActiveSheet

    Set xlap = cxl.XLapp
Else ' indlejret
    GoToInsertPoint
    Selection.TypeParagraph
'    Set xlap = New Excel.Application
    Set wb = InsertIndlejret("Graphs.xltm", Sprog.A(633)) ' "tabel"
    Set ws = wb.Sheets(1)
    Set xlap = wb.Application
End If
    

'excel.Application.EnableEvents = False
'excel.Application.ScreenUpdating = False

    ufwait2.Label_progress = ufwait2.Label_progress & "*****"

' indstillinger
If Radians Then
    ws.Range("A4").Value = "rad"
Else
    ws.Range("A4").Value = "grad"
End If

    ' funktioner der markeres
    For i = 0 To dd.AntalMathBoxes - 1
        udtryk = dd.MathBoxes(i)
        udtryk = Replace(udtryk, "definer:", "")
        udtryk = Replace(udtryk, "Definer:", "")
        udtryk = Replace(udtryk, "define:", "")
        udtryk = Replace(udtryk, "Define:", "")
        udtryk = Trim(udtryk)
        udtryk = Replace(udtryk, VBA.ChrW(8788), "=") ' :=
        udtryk = Replace(udtryk, VBA.ChrW(8797), "=") ' tripel =
        udtryk = Replace(udtryk, VBA.ChrW(8801), "=") ' def =
        udtryk = Replace(udtryk, vbCrLf, "") '
        udtryk = Replace(udtryk, vbCr, "") '
        udtryk = Replace(udtryk, vbLf, "") '
        If Len(udtryk) > 0 Then
            If InStr(udtryk, "matrix") < 1 Then ' matricer og vektorer er ikke implementeret endnu
                If InStr(udtryk, "=") > 0 Then
                    arr = Split(udtryk, "=")
                    lhs = arr(0)
                    RHS = arr(1)
                    ea.text = lhs
                    fktnavn = ea.GetNextVar(1)
                    varnavn = ea.GetNextBracketContent(1)
'                    If varnavn = "" And fktnavn = Y Then varnavn = X
                    If lhs = fktnavn & "(" & varnavn & ")" Then
                        ws.Range("B4").Offset(0, i).Value = RHS
                        ws.Range("B1").Offset(0, i).Value = varnavn
                    Else
'                        DefinerKonstanterGraph udtryk, deflist, graphfil, True
                        ws.Range("B4").Offset(0, i).Value = RHS
                        ws.Range("B1").Offset(0, i).Value = "x"
                        ' blev brugt f�r relation
'                        fktudtryk = ReplaceIndepvarX(rhs)
'                        DefinerKonstanterGraph fktudtryk, deflist, graphfil
'                        graphfil.InsertFunction fktudtryk
                    End If
                ElseIf InStr(udtryk, ">") > 0 Or InStr(udtryk, "<") > 0 Or InStr(udtryk, VBA.ChrW(8804)) > 0 Or InStr(udtryk, VBA.ChrW(8805)) > 0 Then
                Else
                    udtryk = ReplaceIndepvarX(udtryk)
'                    DefinerKonstanterGraph udtryk, deflist, graphfil
                    ws.Range("b4").Offset(0, i).Value = udtryk
                    ws.Range("B1").Offset(0, i).Value = "x"
               End If
            End If
        End If
    Next

'    Selection.start = sstart
'    Selection.End = sslut
    srange.Select

    'datapunkter
    If Selection.Tables.Count > 0 Then
        Dim Cregr As New CRegression, setdata As String
        Cregr.GetTableData
        xmin = Cregr.XValues(1)
        xmax = Cregr.XValues(1)
        For i = 1 To UBound(Cregr.XValues)
            ws.Range("Q6").Offset(i, 0).Value = val(Replace(Cregr.XValues(i), ",", "."))
            ws.Range("R6").Offset(i, 0).Value = val(Replace(Cregr.YValues(i), ",", "."))
'            ws.Range("H6").Offset(i, 0).Value = ConvertNumber(Cregr.XValues(i))
'            ws.Range("I6").Offset(i, 0).Value = ConvertNumber(Cregr.YValues(i))
            If Cregr.XValues(i) > xmax Then xmax = Cregr.XValues(i)
            If Cregr.XValues(i) < xmin Then xmin = Cregr.XValues(i)
        Next
        ws.Range("W3").Value = xmin
        ws.Range("X3").Value = xmax
    End If

' virker kun med lodret tabel
'    If dd.nrows > 1 And dd.ncolumns > 1 Then
'        For i = 1 To dd.nrows
'            ws.Range("H6").Offset(i, 0).Value = dd.TabelCelle(i, 1)
'            ws.Range("I6").Offset(i, 0).Value = dd.TabelCelle(i, 2)
'        Next
'    End If

'    Selection.start = sslut
'    Selection.End = sslut
    srange.Select
    Selection.Collapse wdCollapseEnd

GoTo Slut:
Fejl:
    MsgBox Sprog.A(98), vbOKOnly, Sprog.Error
Slut:
On Error GoTo slut2
    ufwait2.Label_progress = ufwait2.Label_progress & "**"
    xlap.Run ("Auto_open")
xlap.Run ("UpDateAll")
'excel.Run ("UpDateAll")
ufwait2.Label_progress = ufwait2.Label_progress & "***"

'If Not wb Is Nothing Then ' start p� tabel sheet, ikke graph
'    wb.Charts(1).Activate
'End If

slut2:
    On Error Resume Next
'    excel.Application.EnableEvents = True
'    excel.Application.ScreenUpdating = True
'    excel.Application.DisplayAlerts = True
    Unload ufwait2
    xlap.EnableEvents = True
    xlap.ScreenUpdating = True

'Excel.Application.ScreenUpdating = True

'excel.ActiveSheet.ChartObjects(1).Copy
'Selection.Collapse Direction:=wdCollapseStart
'Selection.Paste
'Selection.PasteSpecial DataType:=wdPasteOLEObject
'Selection.PasteSpecial DataType:=wdPasteShape
End Sub
Sub InsertChartG()
'inds�tter exceldokument som indlejret dokument
'Dim wb As Workbook
'Dim ws As Worksheet
Dim wb As Object 'Workbook
Dim ws As Object
Dim fktnavn As String, udtryk As String, lhs As String, RHS As String, varnavn As String, fktudtryk As String
Dim dd As New DocData
Dim listform As String
Dim i As Integer
Dim arr As Variant
Dim ea As New ExpressionAnalyser
Dim path As String
Dim ils As InlineShape
Application.ScreenUpdating = False
ea.SetNormalBrackets

PrepareMaxima
omax.ReadSelection
'    dd.ReadSelection

    MsgBox Sprog.Wait

If ExcelIndlejret Then
    GoToInsertPoint
    Selection.TypeParagraph
path = """" & GetProgramFilesDir & "\WordMat\ExcelFiles\Graphs.xltm"""

EnableExcelMacros

Set ils = ActiveDocument.InlineShapes.AddOLEObject(FileName:=path, LinkToFile:=False, _
DisplayAsIcon:=False, Range:=Selection.Range)

ils.OLEFormat.DoVerb (wdOLEVerbShow)
Set wb = ils.OLEFormat.Object
DisableExcelMacros



Else
    Set wb = InsertOpenExcel("Graphs.xltm", "Tabel")
End If
Set ws = wb.Sheets("Tabel")
'Excel.Application.EnableEvents = False
'Excel.Application.ScreenUpdating = False
XLapp.Application.EnableEvents = False
XLapp.Application.ScreenUpdating = False

GoTo hop

If Radians Then
    ws.Range("A4").Value = "rad"
Else
    ws.Range("A4").Value = "grad"
End If


    ' funktioner der markeres
    For i = 0 To omax.KommandoArrayLength
        udtryk = omax.KommandoArray(i)
        udtryk = Replace(udtryk, "definer:", "")
        udtryk = Replace(udtryk, "Definer:", "")
        udtryk = Replace(udtryk, "define:", "")
        udtryk = Replace(udtryk, "Define:", "")
        udtryk = Trim(udtryk)
        udtryk = Replace(udtryk, VBA.ChrW(8788), "=") ' :=
        udtryk = Replace(udtryk, VBA.ChrW(8797), "=") ' tripel =
        udtryk = Replace(udtryk, VBA.ChrW(8801), "=") ' def =
        If Len(udtryk) > 0 Then
            If InStr(udtryk, "matrix") < 1 Then ' matricer og vektorer er ikke implementeret endnu
                If InStr(udtryk, "=") > 0 Then
                    arr = Split(udtryk, "=")
                    lhs = arr(0)
                    RHS = arr(1)
                    ea.text = lhs
                    fktnavn = ea.GetNextVar(1)
                    varnavn = ea.GetNextBracketContent(1)
                    If lhs = fktnavn & "(" & varnavn & ")" Then
                        ea.text = RHS
                        ea.pos = 1
'                        ea.ReplaceVar varnavn, "x"
                        fktudtryk = ea.text
'                        DefinerKonstanterGraph fktudtryk, deflist, graphfil
                        ws.Range("b4").Offset(0, i).Value = fktudtryk
                        ws.Range("B1").Offset(0, i).Value = varnavn
                    Else
'                        DefinerKonstanterGraph udtryk, deflist, graphfil, True
                        ws.Range("b4").Offset(0, i).Value = udtryk
                        ws.Range("B1").Offset(0, i).Value = "x"
                        ' blev brugt f�r relation
'                        fktudtryk = ReplaceIndepvarX(rhs)
'                        DefinerKonstanterGraph fktudtryk, deflist, graphfil
'                        graphfil.InsertFunction fktudtryk
                    End If
                ElseIf InStr(udtryk, ">") > 0 Or InStr(udtryk, "<") > 0 Or InStr(udtryk, VBA.ChrW(8804)) > 0 Or InStr(udtryk, VBA.ChrW(8805)) > 0 Then
                Else
                    udtryk = ReplaceIndepvarX(udtryk)
'                    DefinerKonstanterGraph udtryk, deflist, graphfil
                    ws.Range("b4").Offset(0, i).Value = udtryk
                    ws.Range("B1").Offset(0, i).Value = "x"
               End If
            End If
        End If
    Next
    
    If dd.nrows > 1 And dd.ncolumns > 1 Then
        For i = 1 To dd.nrows
            ws.Range("H6").Offset(i, 0).Value = dd.TabelCelle(i, 1)
            ws.Range("I6").Offset(i, 0).Value = dd.TabelCelle(i, 2)
        Next
    End If


hop:
' Opdater Excel med �ndringer
On Error Resume Next
'wb.Application.Run ("UpDateAll")
wb.Charts(1).Activate
'Excel.Application.EnableEvents = True
'Excel.Application.ScreenUpdating = True
'Excel.Run ("UpDateAll")
XLapp.Application.EnableEvents = True
XLapp.Application.ScreenUpdating = True
XLapp.Run ("UpDateAll")

Exit Sub

'On Error GoTo slut
'Dim path As String
'Dim ils As InlineShape
'Dim wb As Variant
'Dim ws As Variant
EnableExcelMacros
Application.ScreenUpdating = False
path = """" & GetProgramFilesDir & "\WordMat\ExcelFiles\Graphs.xltm"""

'Application.DisplayAlerts = Word.WdAlertLevel.wdAlertsNone
Set ils = ActiveDocument.InlineShapes.AddOLEObject( _
FileName:=path, LinkToFile:=False, _
DisplayAsIcon:=False, Range:=Selection.Range)
'Ils.Height = 300
'Ils.Width = 500

'ils.OLEFormat.DoVerb (wdOLEVerbShow)
ils.OLEFormat.DoVerb (wdOLEVerbInPlaceActivate)

Set wb = ils.OLEFormat.Object
Set ws = wb.Sheets("Tabel")
ws.Activate


'Ils.OLEFormat.DoVerb (wdOLEVerbOpen)
'Ils.OLEFormat.DoVerb (wdOLEVerbShow)
'Ils.OLEFormat.DoVerb (wdOLEVerbUIActivate)
'Ils.OLEFormat.DoVerb (wdOLEVerbInPlaceActivate)
'Ils.OLEFormat.DoVerb (wdOLEVerbHide)

'DoEvents
'Application.ScreenUpdating = True
'Dim wb As excel.Workbook
'Dim excel As excel.Application
'Set excel = CreateObject("Excel.Application")
'Set wb = excel.Workbooks(excel.Workbooks.Count)
Slut:
DisableExcelMacros
End Sub

Sub InsertGeoGeobraObject()
Dim ils As InlineShape
#If Mac Then
    MsgBox "This function is not supported on Mac", vbOKOnly, "Mac"
#Else
    If InStr(GeoGebraPath, AppNavn) > 0 Then
        MsgBox "Denne funktion kr�ver at GeoGebra installeres separat", vbOKOnly, Sprog.Error
        UserFormGeoGebra.Show
    Else
        CreateGeoGebraFil GetTempDir()
        Application.ScreenUpdating = False
        If Selection.Range.Tables.Count > 0 Then
            Selection.Tables(Selection.Tables.Count).Select
            Selection.Collapse (wdCollapseEnd)
            Selection.TypeParagraph
        End If
        If Selection.OMaths.Count > 0 Then
            Selection.OMaths(Selection.OMaths.Count).Range.Select
            Selection.Collapse (wdCollapseEnd)
            Selection.TypeParagraph
        End If
        Set ils = ActiveDocument.InlineShapes.AddOLEObject(ClassType:="Package", _
        FileName:=GetTempDir() & "geogebra.ggb", LinkToFile:=False, DisplayAsIcon:=False, Range:=Selection.Range)
'        ils.OLEFormat.DoVerb (wdOLEVerbOpen)
    End If
#End If
End Sub

Function ReadTextFile(fil As String) As String
Dim filno As Integer
Dim linje, text As String
filno = FreeFile

Open fil For Input As filno
Do While Not EOF(filno) ' Loop until end of file.
  Line Input #filno, linje
   text = text & vbCrLf & linje
Loop
Close filno

ReadTextFile = text
End Function
Sub TestEmbed()
Dim path As String
Dim ils As InlineShape
path = """" & GetProgramFilesDir & "\WordMat\ExcelFiles\Graphs.xltm"""

Set ils = ActiveDocument.InlineShapes.AddOLEObject(FileName:=path, LinkToFile:=False, _
DisplayAsIcon:=False, Range:=Selection.Range)

End Sub
Function InsertIndlejret(filnavn As String, Optional startark As String) As Object
'inds�tter exceldokument som indlejret dokument
' bem�rk fejler hvis google cloud connect installeret
Dim path As String
Dim ils As InlineShape
Dim vers As String
On Error GoTo Fejl
Application.ScreenUpdating = False
EnableExcelMacros
    
    Dim ufwait2 As New UserFormWaitForMaxima
    ufwait2.CommandButton_stop.visible = False
    ufwait2.Label_tip.Caption = "      " & Sprog.A(372) & "..."
    ufwait2.Label_progress.Caption = Sprog.A(373) ' "Inds�tning af indlejrede objekter kan tage tid. Dobbeltklik p� objektet for at redigere det."
    ufwait2.Show vbModeless
        DoEvents
        ufwait2.Label_progress = "***"
#If Mac Then
path = GetWordMatDir() & "Excelfiles/" & filnavn
#Else
path = """" & GetProgramFilesDir & "\WordMat\ExcelFiles\" & filnavn & """"
#End If
    If Selection.Range.Tables.Count > 0 Then
'        Selection.Copy
        Selection.Tables(Selection.Tables.Count).Select
        Selection.Collapse (wdCollapseEnd)
        Selection.TypeParagraph
'        startark = "Data"
    End If
    If Selection.OMaths.Count > 0 Then
        Selection.OMaths(Selection.OMaths.Count).Range.Select
        Selection.Collapse (wdCollapseEnd)
        Selection.TypeParagraph
    End If
If val(Application.Version) = 12 Then
    vers = ".12"
Else
    vers = ""
End If

'Set ils = ActiveDocument.InlineShapes.AddOLEObject(FileName:=path, LinkToFile:=False, _
'DisplayAsIcon:=False, Range:=Selection.Range)
' fors�g uden classtype. pr�v evt med classtype:=Excel.SheetMacroEnabled.12
'Set ils = ActiveDocument.InlineShapes.AddOLEObject(ClassType:="Excel.Sheet" & vers & Application.Version, _
'FileName:=path, LinkToFile:=False, DisplayAsIcon:=False, Range:=Selection.Range)
Set ils = ActiveDocument.InlineShapes.AddOLEObject(ClassType:="Excel.SheetMacroEnabled" & vers & Application.Version, _
FileName:=path, LinkToFile:=False, DisplayAsIcon:=False, Range:=Selection.Range)
        
        ufwait2.Label_progress = "***************************************"
'Ils.OLEFormat.DoVerb (wdOLEVerbOpen)
'ils.OLEFormat.DoVerb (wdOLEVerbInPlaceActivate)
'ils.OLEFormat.DoVerb (wdOLEVerbShow)
If startark <> "" Then
    ils.OLEFormat.DoVerb (wdOLEVerbInPlaceActivate)
    DoEvents
    Set InsertIndlejret = ils.OLEFormat.Object

'    Dim oWS As Object ' Worksheet Object
'    Set oWS = ils.OLEFormat.Object
'    ils.OLEFormat.Object.Sheets(startark).Activate
'    oWS.ActiveSheet.Cells(4, 1).Activate
'    oWS.ActiveSheet.Application.Selection.Paste ' virker ikke
'    oWS.Selection.Paste
End If
Unload ufwait2
'Ils.OLEFormat.DoVerb (wdOLEVerbUIActivate)
'Ils.OLEFormat.DoVerb (wdOLEVerbInPlaceActivate)
'Ils.OLEFormat.DoVerb (wdOLEVerbHide)
DisableExcelMacros
GoTo Slut
Fejl:
    On Error Resume Next
    MsgBox Sprog.ErrorGeneral, vbOKOnly, Sprog.Error
    Unload ufwait2
Slut:
End Function

Sub InsertPindeDiagram()
    InsertOpenExcel "Pindediagram.xltm"
End Sub
Sub InsertBoksplot()
    InsertOpenExcel "Boksplot.xltm"
End Sub
Sub InsertHistogram()
    InsertOpenExcel "Histogram.xltm"
End Sub
Sub InsertSumkurve()
    InsertOpenExcel "Sumkurve.xltm"
End Sub
Sub InsertUGrupObs()
'    InsertOpenExcel "UGrupperedeObservationer.xltm"
Dim s As String
If Sprog.SprogNr = 1 Then
    s = "Ugrup"
Else
    s = "Ungroup"
End If
    InsertOpenExcel "statistik.xltm", s
End Sub
Sub InsertGrupObs()
'    InsertOpenExcel "GrupperedeObservationer.xltm"
Dim s As String
If Sprog.SprogNr = 1 Then
    s = "Grup"
Else
    s = "Group"
End If
    InsertOpenExcel "statistik.xltm", s
End Sub
Sub InsertTrappediagram()
    InsertOpenExcel "TrappeDiagram.xltm"
End Sub
Function ConvertDrawLabel(text As String) As String
' konverterer tegn til draw2d plot
'text = Replace(text, "", "")
'text = Replace(text, "", "")
'text = Replace(text, "", "")

    text = Replace(text, VBA.ChrW(916), "{/Symbol D}")
    text = Replace(text, VBA.ChrW(948), "{/Symbol d}")
    text = Replace(text, VBA.ChrW(945), "{/Symbol a}")
    text = Replace(text, VBA.ChrW(946), "{/Symbol b}")
    text = Replace(text, VBA.ChrW(947), "{/Symbol g}")
    text = Replace(text, VBA.ChrW(952), "{/Symbol t}") 'theta
    text = Replace(text, VBA.ChrW(920), "{/Symbol T}")
    text = Replace(text, VBA.ChrW(955), "{/Symbol l}")
    text = Replace(text, VBA.ChrW(923), "{/Symbol L}")
    text = Replace(text, VBA.ChrW(956), "{/Symbol m}")
    text = Replace(text, VBA.ChrW(961), "{/Symbol r}") ' rho
    text = Replace(text, VBA.ChrW(963), "{/Symbol s}")
    text = Replace(text, VBA.ChrW(931), "{/Symbol S}")
    text = Replace(text, VBA.ChrW(981), "{/Symbol p}") ' phi
    text = Replace(text, VBA.ChrW(934), "{/Symbol P}")
    text = Replace(text, VBA.ChrW(949), "{/Symbol v}") 'varepsilon
    text = Replace(text, VBA.ChrW(1013), "{/Symbol e}") 'epsilon
    text = Replace(text, VBA.ChrW(968), "{/Symbol p}") 'psi
    text = Replace(text, VBA.ChrW(936), "{/Symbol P}")
    text = Replace(text, VBA.ChrW(926), "{/Symbol X}") 'xi
    text = Replace(text, VBA.ChrW(958), "{/Symbol x}")
    text = Replace(text, VBA.ChrW(935), "{/Symbol C}") 'chi
    text = Replace(text, VBA.ChrW(967), "{/Symbol c}")
    text = Replace(text, VBA.ChrW(928), "{/Symbol Pi}")
    text = Replace(text, VBA.ChrW(964), "{/Symbol t}") 'tau
    text = Replace(text, VBA.ChrW(957), "{/Symbol n}") 'greeknu
    text = Replace(text, VBA.ChrW(954), "{/Symbol k}") 'kappa
    text = Replace(text, VBA.ChrW(951), "{/Symbol e}") 'eta
    text = Replace(text, VBA.ChrW(950), "{/Symbol z}") 'zeta


ConvertDrawLabel = text
End Function




