'==================================================================
' HOLLOW RING MACRO — SolidWorks VBA
' Creates: an annular ring (hollow center bore) with a small
' rectangular slot cutout at the top (12 o'clock) and bottom
' (6 o'clock), matching the sketch's outer ring + inner bore +
' top/bottom bracket-slot detail.
'
' HOW TO USE:
'   1. In SolidWorks: Tools > Macro > New... save as RingMacro.swp
'   2. In the VBA editor that opens, delete the default empty Sub
'      and paste this entire file in its place.
'   3. Edit the PARAMETERS block below to your real dimensions.
'   4. Press F5 (Run) with no part open — it creates a new part.
'
' NOTE: This is a starting parametric scaffold, not a finished
' production macro. FeatureExtrusion2 / FeatureCut4 parameter
' counts vary slightly by SolidWorks version — if either line
' throws a compile error, open the VBA Object Browser (F2), search
' the method name, and match the parameter order shown there.
'==================================================================

' ---------------- PARAMETERS (edit these, all in mm) ----------------
Const OUTER_DIA   As Double = 120#   ' overall outer diameter of the ring
Const INNER_DIA   As Double = 60#    ' bore diameter — the hollow center
Const THICKNESS   As Double = 15#    ' extrude depth (ring thickness)
Const SLOT_WIDTH  As Double = 14#    ' width of each top/bottom slot
Const SLOT_DEPTH  As Double = 10#    ' radial length of each slot cut
Const SLOT_INSET  As Double = 4#     ' gap between slot and outer edge
' ----------------------------------------------------------------------

Dim swApp           As SldWorks.SldWorks
Dim swModel         As SldWorks.ModelDoc2
Dim swModelDocExt   As SldWorks.ModelDocExtension
Dim swSketchMgr     As SldWorks.SketchManager
Dim swFeatMgr       As SldWorks.FeatureManager
Dim swFeat          As SldWorks.Feature
Dim boolstatus      As Boolean
Dim mmToM           As Double

Sub main()

    mmToM = 0.001   ' SolidWorks API works in meters internally

    Set swApp = Application.SldWorks
    Set swModel = swApp.NewDocument(swApp.GetUserPreferenceStringValue( _
        swUserPreferenceStringValue_e.swDefaultTemplatePart), 0, 0, 0)

    If swModel Is Nothing Then
        MsgBox "Could not create a new part — make sure a default part template is set (Tools > Options > Default Templates)."
        Exit Sub
    End If

    Set swModelDocExt = swModel.Extension
    Set swSketchMgr = swModel.SketchManager
    Set swFeatMgr = swModel.FeatureManager

    '--------------------------------------------------------------
    ' SKETCH 1: outer + inner concentric circles on the Front Plane
    ' SolidWorks automatically treats the inner circle as a hole
    ' when both are extruded together, giving the hollow center.
    '--------------------------------------------------------------
    boolstatus = swModelDocExt.SelectByID2("Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0)
    swSketchMgr.InsertSketch True

    swSketchMgr.CreateCircleByRadius 0, 0, 0, (OUTER_DIA / 2) * mmToM
    swSketchMgr.CreateCircleByRadius 0, 0, 0, (INNER_DIA / 2) * mmToM

    swSketchMgr.InsertSketch True   ' exit the sketch

    '--------------------------------------------------------------
    ' EXTRUDE: turn the ring sketch into a solid of THICKNESS depth
    '--------------------------------------------------------------
    boolstatus = swModelDocExt.SelectByID2("Sketch1", "SKETCH", 0, 0, 0, False, 0, Nothing, 0)

    Set swFeat = swFeatMgr.FeatureExtrusion2( _
        True, False, False, _
        swEndCondBlind, swEndCondBlind, _
        THICKNESS * mmToM, 0, _
        False, False, False, False, _
        0, 0, _
        False, False, False, False, _
        True, True, True, _
        0, 0, False)

    If swFeat Is Nothing Then
        MsgBox "Extrude failed — check Sketch1 selection and try again from the VBA editor."
        Exit Sub
    End If

    '--------------------------------------------------------------
    ' SKETCH 2: top (12 o'clock) and bottom (6 o'clock) slot cutouts
    '--------------------------------------------------------------
    boolstatus = swModelDocExt.SelectByID2("Front Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0)
    swSketchMgr.InsertSketch True

    Dim slotY As Double
    slotY = (OUTER_DIA / 2 - SLOT_INSET) * mmToM

    ' Top slot: centered rectangle just inside the outer edge at 12 o'clock
    swSketchMgr.CreateCenterRectangle _
        0, slotY, 0, _
        (SLOT_WIDTH / 2) * mmToM, (slotY - SLOT_DEPTH * mmToM), 0

    ' Bottom slot: mirrored at 6 o'clock
    swSketchMgr.CreateCenterRectangle _
        0, -slotY, 0, _
        (SLOT_WIDTH / 2) * mmToM, (-slotY + SLOT_DEPTH * mmToM), 0

    swSketchMgr.InsertSketch True   ' exit the sketch

    '--------------------------------------------------------------
    ' CUT: punch both slots all the way through the ring
    '--------------------------------------------------------------
    boolstatus = swModelDocExt.SelectByID2("Sketch2", "SKETCH", 0, 0, 0, False, 0, Nothing, 0)

    Set swFeat = swFeatMgr.FeatureCut4( _
        True, False, False, _
        swEndCondThroughAll, swEndCondThroughAll, _
        0, 0, _
        False, False, False, False, _
        0, 0, _
        False, False, False, False, _
        False, True, True, False, False, False, _
        0, 0, False)

    If swFeat Is Nothing Then
        MsgBox "Slot cut failed — Sketch2 may need both rectangles fully closed. Check in the sketch editor."
    End If

    swModel.ViewZoomtofit2

    MsgBox "Ring created:" & vbCrLf & _
        "Outer dia: " & OUTER_DIA & " mm" & vbCrLf & _
        "Bore dia: " & INNER_DIA & " mm" & vbCrLf & _
        "Thickness: " & THICKNESS & " mm"

End Sub
