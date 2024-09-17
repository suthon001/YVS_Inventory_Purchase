/// <summary>
/// PageExtension YVS Purchase Lines (ID 75011) extends Record Purchase Lines.
/// </summary>
pageextension 75011 "YVS Purchase Lines" extends "Purchase Lines"
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
        addafter("Direct Unit Cost")
        {
            field("YVS Direct Unit Cost"; Rec."YVS Direct Unit Cost")
            {
                ApplicationArea = Suite;
                BlankZero = true;
                ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                ToolTip = 'Specifies the value of the YVS Direct Unit Cost field.';
                Style = Favorable;
                Visible = NOT IsHideValue;
            }
        }

    }
    trigger OnOpenPage()
    var
        UserSetupMgt: Codeunit "User Setup Management";
    begin
        IsHideValue := InvenPurchFunc.CheckPermissionItemInVisible();
        if (UserSetupMgt.GetPurchasesFilter() <> '') then begin
            rec.FilterGroup(2);
            rec.SetRange("Responsibility Center", UserSetupMgt.GetPurchasesFilter());
            rec.FilterGroup(0);
        end;

    end;

    var
        InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
        IsHideValue: Boolean;
}

