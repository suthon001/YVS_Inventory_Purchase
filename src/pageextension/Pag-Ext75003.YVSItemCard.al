/// <summary>
/// PageExtension YVS Item Card (ID 75003) extends Record Item Card.
/// </summary>
pageextension 75003 "YVS Item Card" extends "Item Card"
{
    layout
    {
        modify("Standard Cost")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Unit Cost")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Indirect Cost %")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Last Date Modified")
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
