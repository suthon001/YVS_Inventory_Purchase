/// <summary>
/// PageExtension YVS Item Ledger Entries (ID 75004) extends Record Item Ledger Entries.
/// </summary>
pageextension 75004 "YVS Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        modify("Cost Amount (Actual) (ACY)")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Cost Amount (Expected) (ACY)")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Cost Amount (Non-Invtbl.)(ACY)")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
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
