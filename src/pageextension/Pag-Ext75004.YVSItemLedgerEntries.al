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
