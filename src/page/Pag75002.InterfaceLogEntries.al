/// <summary>
/// Page YVS Interface Log Entries (ID 75002).
/// </summary>
page 75002 "YVS Interface Log Entries"
{
    ApplicationArea = All;
    Caption = 'Interface Log Entries';
    PageType = List;
    CardPageId = "YVS Interface Log Card";
    SourceTable = "YVS Interface Log Entry";
    UsageCategory = History;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    DataCaptionExpression = StrSubstNo('%1 %2', rec."Action Page", rec."Document No.");
    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
        }
    }
}
