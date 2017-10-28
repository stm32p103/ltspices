VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TemplateProcessor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
' ������Ɋ܂܂��e���v���[�g(�f�t�H���g�ł� << >> �ň͂܂ꂽ����)������ꍇ�A
' << >> ���̕������Excel�̐����Ƃ��ĕ]���������ʂɒu��������
' �e���v���[�g�́u�J�n�v�Ɓu�I���v�̈͂ݕ����͕ύX�\�B
' �����Ƃ��ĕ]������ۂɃG���[�����������ꍇ�́A�G���[���b�Z�[�W���o��

Dim RegExp As Object
Const DefaultBeginClause = "<<"     '
Const DefaultEndClause = ">>"
Const MatchPattern = "(.+?)"        ' �ŏ��}�b�`

Private Sub Class_Initialize()
    Set RegExp = CreateObject("VBScript.RegExp")
    Call SetClause(DefaultBeginClause, DefaultEndClause)
    RegExp.Global = True
End Sub

' �e���v���[�g�u����������
Public Function Process(str As String) As String
    Dim matches As Object
    Set matches = RegExp.Execute(str)
    
    If matches.Count = 0 Then
        Process = str
    Else
        Dim tmpStr As String
        tmpStr = ""
        
        Dim cursor As Long
        cursor = 0
        
        Dim i As Long
        For i = 0 To matches.Count - 1
            tmpStr = tmpStr & TrailingString(str, cursor, matches.item(i)) & ReplacementString(matches.item(i))
            cursor = NextCursor(matches.item(i))
        Next i
        tmpStr = tmpStr & RemainingString(str, cursor)
        Process = tmpStr
    End If
End Function
' �͂ݕ�����ύX
Public Sub SetClause(beginClause As String, endClause As String)
    RegExp.Pattern = beginClause + MatchPattern + endClause
End Sub

' �ȉ��e���v���[�g�u�����������Ŏg�p����֐�
' �J�[�\���ʒu���玟�̃e���v���[�g���n�܂�܂ł̕������Ԃ�
Private Function TrailingString(str As String, cursor As Long, item As Variant)
    TrailingString = Mid(str, (cursor + 1), item.FirstIndex - cursor)
End Function

' �e���v���[�g���̕�����𐔎��Ƃ��ĕ]���������ʂ�Ԃ�
' ����������ɕ]���ł��Ȃ��ꍇ�G���[���o��
Private Function ReplacementString(item As Variant)
    Dim Result As Variant
    Dim Formula As String
    Formula = item.Submatches(0)
    
    Result = Application.Evaluate(Formula)
    If VBA.VarType(Result) = vbError Then
        Err.Raise vbObjectError, "ReplacementString", "�����̌v�Z�Ɏ��s : " & Formula
    End If
    ReplacementString = Result
End Function

' ���̃J�[�\���ʒu(�e���v���[�g�̎��̕������w��)��Ԃ�
Private Function NextCursor(item As Variant)
    NextCursor = item.FirstIndex + item.Length
End Function

' �Ō�̃e���v���[�g��������Ɏc�����������Ԃ�
Private Function RemainingString(str As String, cursor As Long)
    RemainingString = Right(str, Len(str) - cursor)
End Function

Private Sub Class_Terminate()
    Set RegExp = Nothing
End Sub