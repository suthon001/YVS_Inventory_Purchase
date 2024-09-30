/// <summary>
/// Page YVS Interface Log Card (ID 70003).
/// </summary>
page 75003 "YVS Interface Log Card"
{
    ApplicationArea = All;
    Caption = 'Interface Log Card';
    PageType = Card;
    SourceTable = "YVS Interface Log Entry";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;
    DataCaptionExpression = StrSubstNo('%1 %2', rec."Action Page", rec."Document No.");
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Method Type"; Rec."Method Type")
                {
                    ToolTip = 'Specifies the value of the Method Type field.', Comment = '%';
                }
                field("Interface Path"; Rec."Interface Path")
                {
                    ToolTip = 'Specifies the value of the Interface Path field.', Comment = '%';
                }

                field("Action Page"; Rec."Action Page")
                {
                    ToolTip = 'Specifies the value of the Action Page field.', Comment = '%';
                }
                field(Direction; Rec.Direction)
                {
                    ToolTip = 'Specifies the value of the Direction field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Primary Key Caption"; Rec."Primary Key Caption")
                {
                    ToolTip = 'Specifies the value of the Primary Key Caption field.', Comment = '%';
                }
                field("Primary Key 1"; Rec."Primary Key 1")
                {
                    ToolTip = 'Specifies the value of the Primary Key 1 field.', Comment = '%';
                }
                field("Primary Key 2"; Rec."Primary Key 2")
                {
                    ToolTip = 'Specifies the value of the Primary Key 2 field.', Comment = '%';
                }
                field("Primary Key 3"; Rec."Primary Key 3")
                {
                    ToolTip = 'Specifies the value of the Primary Key 3 field.', Comment = '%';
                }
            }
            group(JsonLogInfor)
            {
                Caption = 'Json Log';
                field(JsonLog; JsonLog)
                {
                    Editable = false;
                    MultiLine = true;
                    ApplicationArea = all;
                    ShowCaption = false;
                }
            }
            group(ResponseLogInfor)
            {
                Caption = 'Response Log';
                field(ResponseLog; ResponseLog)
                {
                    Editable = false;
                    MultiLine = true;
                    ApplicationArea = all;
                    ShowCaption = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        JsonLog := rec.GetJsonLog();
        ResponseLog := rec.GetResponseLog();
    end;

    var
        JsonLog, ResponseLog : text;
}
