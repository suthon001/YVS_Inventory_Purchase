/// <summary>
/// PageExtension YVS Item Lookup (ID 75008) extends Record Item Lookup.
/// </summary>
pageextension 75008 "YVS Item Lookup" extends "Item Lookup"
{
    layout
    {
        modify("Unit Cost")
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

