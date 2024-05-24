/// <summary>
/// PageExtension YVS Value Entries Preview (ID 75007) extends Record Value Entries Preview.
/// </summary>
pageextension 75007 "YVS Value Entries Preview" extends "Value Entries Preview"
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


