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
        addlast(Control1)
        {
            field("YVS Direction"; rec."YVS Direction")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Direction field.';
            }
            field("YVS Ship-to Name"; Rec."YVS Ship-to Name")
            {
                ToolTip = 'Specifies the value of the Ship-to Name field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Address"; Rec."YVS Ship-to Address")
            {
                ToolTip = 'Specifies the value of the Ship-to Address field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to District"; Rec."YVS Ship-to District")
            {
                ToolTip = 'Specifies the value of the Ship-to District field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Post Code"; Rec."YVS Ship-to Post Code")
            {
                ToolTip = 'Specifies the value of the Ship-to Post Code field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Phone No."; Rec."YVS Ship-to Phone No.")
            {
                ToolTip = 'Specifies the value of the Ship-to Phone No. field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Mobile No."; Rec."YVS Ship-to Mobile No.")
            {
                ToolTip = 'Specifies the value of the Ship-to Mobile No. field.';
                ApplicationArea = all;
            }
            field("YVS Shipment Date"; rec."YVS Shipment Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shipment Date field.';
            }
            field("YVS Shipping Agent"; rec."YVS Shipping Agent")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shipping Agent field.';
            }
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

