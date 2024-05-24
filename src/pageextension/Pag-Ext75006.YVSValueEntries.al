/// <summary>
/// PageExtension YVS Value Entries (ID 75006) extends Record Value Entries.
/// </summary>
pageextension 75006 "YVS Value Entries" extends "Value Entries"
{
    layout
    {
        modify("Cost Amount (Actual)")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Cost Amount (Expected)")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Cost Amount (Non-Invtbl.)")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
    }
    trigger OnOpenPage()
    begin
        IsHideValue := InvenPurchFunc.CheckPermissionCostInVisible();
    end;

    var
        InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
        IsHideValue: Boolean;
}

