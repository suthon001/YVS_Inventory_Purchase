/// <summary>
/// PageExtension YVS Purchase Order Subform (ID 75009) extends Record Purchase Order Subform.
/// </summary>
pageextension 75009 "YVS Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {

        modify("Direct Unit Cost")
        {
            Visible = IsHideValue;
            Style = Favorable;
            HideValue = NOT IsHideValue;
            trigger OnAfterValidate()
            begin
                rec."YVS Direct Unit Cost" := rec."Direct Unit Cost";
            end;
        }
        modify("Line Amount")
        {
            Visible = IsHideValue;
            Style = Favorable;
            HideValue = NOT IsHideValue;
        }
        modify("Line Discount Amount")
        {
            Visible = IsHideValue;
            Style = Favorable;
            HideValue = NOT IsHideValue;
        }
        modify("Line Discount %")
        {
            Visible = IsHideValue;
            Style = Favorable;
            HideValue = NOT IsHideValue;
        }
        addafter("Direct Unit Cost")
        {
            field("YVS Direct Unit Cost"; Rec."YVS Direct Unit Cost")
            {
                ApplicationArea = Suite;
                BlankZero = true;
                Editable = not IsBlankNumber;
                Enabled = not IsBlankNumber;
                ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                ToolTip = 'Specifies the value of the YVS Direct Unit Cost field.';
                Style = Favorable;
                Visible = NOT IsHideValue;
                trigger OnValidate()
                begin
                    rec.Validate("Direct Unit Cost", rec."YVS Direct Unit Cost");
                    DeltaUpdateTotals();
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        IsHideValue := InvenPurchFunc.CheckPermissionItemInVisible();
    end;

    var
        InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
        IsHideValue: Boolean;
}
