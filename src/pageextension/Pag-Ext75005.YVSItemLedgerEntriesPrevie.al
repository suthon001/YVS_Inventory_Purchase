/// <summary>
/// PageExtension YVS Item Ledger Entries Previe (ID 75005) extends Record Item Ledger Entries Preview.
/// </summary>
pageextension 75005 "YVS Item Ledger Entries Previe" extends "Item Ledger Entries Preview"
{
    layout
    {
        modify(CostAmountActual)
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify(CostAmountExpected)
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify(CostAmountNonInvtbl)
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

