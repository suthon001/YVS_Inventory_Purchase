/// <summary>
/// Page YVS API Transfer Order Subform (ID 75001).
/// </summary>
page 75001 "YVS API Transfer Order Subform"
{
    APIGroup = 'inventory';
    APIPublisher = 'yvs';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'API Transfer Order Subform';
    DelayedInsert = true;
    EntityName = 'transferline';
    EntitySetName = 'transferlines';
    PageType = API;
    SourceTable = "Transfer Line";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(qtyToShip; Rec."Qty. to Ship")
                {
                    Caption = 'Qty. to Ship';
                }
                field(qtyToReceive; Rec."Qty. to Receive")
                {
                    Caption = 'Qty. to Receive';
                }
                field(shipmentDate; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field(receiptDate; Rec."Receipt Date")
                {
                    Caption = 'Receipt Date';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
            }
            part(itemtrackingline; "YVS API Tracking Specification")
            {
                SubPageLink = "Ref. Journal Batch Name" = field("Document No."), "Ref. Line No." = field("Line No.");
                ApplicationArea = all;
                EntityName = 'trackingline';
                EntitySetName = 'trackinglines';

            }
        }
    }
    trigger OnInit()
    begin
        ISInsert := false;
        ItemTrackingBuffger.reset();
        ItemTrackingBuffger.DeleteAll();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ISInsert := true;
    end;

    trigger OnAfterGetRecord()
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if not ISInsert then begin
            ReservationEntry.Reset();
            ReservationEntry.SetRange("Source ID", rec."Document No.");
            ReservationEntry.SetRange("Source Ref. No.", rec."Line No.");
            ReservationEntry.SetRange(Positive, false);
            if ReservationEntry.FindSet() then
                repeat
                    ItemTrackingBuffger.Init();
                    ItemTrackingBuffger."Entry No." := ItemTrackingBuffger.getLastEntry();
                    ItemTrackingBuffger."Ref. Journal Batch Name" := rec."Document No.";
                    ItemTrackingBuffger."Ref. Line No." := rec."Line No.";
                    ItemTrackingBuffger."Lot No." := ReservationEntry."Lot No.";
                    ItemTrackingBuffger."Serial No." := ReservationEntry."Serial No.";
                    ItemTrackingBuffger."Warranty Date" := ReservationEntry."Warranty Date";
                    ItemTrackingBuffger.Quantity := ReservationEntry.Quantity;
                    ItemTrackingBuffger."Expiration Date" := ReservationEntry."Expiration Date";
                    ItemTrackingBuffger."New Expiration Date" := ReservationEntry."New Expiration Date";
                    ItemTrackingBuffger."New Lot No." := ReservationEntry."New Lot No.";
                    ItemTrackingBuffger."New Serial No." := ReservationEntry."New Serial No.";
                    ItemTrackingBuffger.Insert();
                until ReservationEntry.Next() = 0;
        end;
    end;

    var
        ItemTrackingBuffger: Record "YVS Tracking Speci. Buffer";
        ISInsert: Boolean;
}
