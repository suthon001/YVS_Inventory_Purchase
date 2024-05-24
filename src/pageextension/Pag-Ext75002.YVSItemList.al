/// <summary>
/// PageExtension YVS Item List (ID 75002) extends Record Item List.
/// </summary>
pageextension 75002 "YVS Item List" extends "Item List"
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
