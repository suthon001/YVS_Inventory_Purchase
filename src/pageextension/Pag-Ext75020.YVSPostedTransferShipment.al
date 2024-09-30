/// <summary>
/// PageExtension YVS Posted Transfer Shipment (ID 75020) extends Record Posted Transfer Shipment.
/// </summary>
pageextension 75020 "YVS Posted Transfer Shipment" extends "Posted Transfer Shipment"
{
    layout
    {
        addlast(General)
        {
            field("YVS Direction"; rec."YVS Direction")
            {
                ToolTip = 'Specifies the value of the Direction field.';
                ApplicationArea = all;
            }
        }
        addafter(TransferShipmentLines)
        {
            group(ShipToInformation)
            {
                Caption = 'Ship-to';
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
            }
        }
    }
}




