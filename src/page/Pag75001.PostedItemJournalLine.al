/// <summary>
/// Page YVS Posted Item Journal Lines (ID 75001).
/// </summary>
page 75001 "YVS Posted Item Journal Lines"
{
    Caption = 'Posted Item Journal Lines';
    SourceTable = "YVS Posted Item Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = History;
    PageType = List;
    ApplicationArea = all;
    layout
    {
        area(Content)
        {
            repeater("General")
            {
                Caption = 'Lines';
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Entry Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("YVS Description TH"; rec."YVS Description TH")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description TH field.';
                }
                field("YVS Search Description"; rec."YVS Search Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Search Description field.';
                }
                field("YVS Address"; rec."YVS Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("YVS Original Quantity"; rec."YVS Original Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Quantity field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Location Code field.';
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Amount (ACY)"; Rec."Amount (ACY)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount (ACY) field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bin Code field.';
                }
                field("New Bin Code"; Rec."New Bin Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the New Bin Code field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
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
                field("YVS Interface"; rec."YVS Interface")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface field.';
                }
                field("YVS Interface Completed"; rec."YVS Interface Completed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface Completed field.';
                }
                field("YVS Send DateTime"; rec."YVS Send DateTime")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Send Date Time field.';
                }
            }
        }
    }

}