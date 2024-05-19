/// <summary>
/// Page YVS API Tracking Specification (ID 75002).
/// </summary>
page 75002 "YVS API Tracking Specification"
{
    ApplicationArea = All;
    Caption = 'API Tracking Specification';
    PageType = ListPart;
    SourceTable = "YVS Tracking Speci. Buffer";
    AutoSplitKey = true;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(lotNo; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the lot number of the item being handled for the associated document line.';
                }
                field(serialNo; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the serial number associated with the entry.';
                }
                field(quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the serial number Quantity with the entry.';
                }
                field(expirationDate; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies a new expiration date.';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (rec."Lot No." <> '') or (rec."Serial No." <> '') then
            InsertLot(rec);
    end;

    local procedure InsertLot(ItemTrackingCodeBuffer: Record "YVS Tracking Speci. Buffer")
    var
        ltItem: Record Item;
        TransferLine: Record "Transfer Line";
        TempReservEntry: Record "Reservation Entry" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        CurrentSourceRowID: Text[250];
        SecondSourceRowID: Text[250];
        ReservStatus: Enum "Reservation Status";
    begin
        TransferLine.reset();
        TransferLine.SetRange("Document No.", ItemTrackingCodeBuffer."Ref. Journal Batch Name");
        if TransferLine.FindLast() then begin
            ltItem.GET(TransferLine."Item No.");
            IF ltItem."Item Tracking Code" <> '' then
                if (ItemTrackingCodeBuffer."Lot No." <> '') or (ItemTrackingCodeBuffer."Serial No." <> '') then begin
                    TempReservEntry.Init();
                    TempReservEntry."Entry No." := GetLastReserveEntry();
                    TempReservEntry."Lot No." := ItemTrackingCodeBuffer."Lot No.";
                    TempReservEntry."Serial No." := ItemTrackingCodeBuffer."Serial No.";
                    TempReservEntry.Quantity := ItemTrackingCodeBuffer.Quantity;
                    if ItemTrackingCodeBuffer."Expiration Date" <> 0D then
                        TempReservEntry."Expiration Date" := ItemTrackingCodeBuffer."Expiration Date";
                    TempReservEntry.Insert();

                    CreateReservEntry.SetDates(0D, TempReservEntry."Expiration Date");
                    CreateReservEntry.CreateReservEntryFor(
                      Database::"Transfer Line", 0,
                      TransferLine."Document No.", '', TransferLine."Derived From Line No.", TransferLine."Line No.", TransferLine."Qty. per Unit of Measure",
                      TempReservEntry.Quantity, TempReservEntry.Quantity * TransferLine."Qty. per Unit of Measure", TempReservEntry);
                    CreateReservEntry.CreateEntry(
                      TransferLine."Item No.", TransferLine."Variant Code", TransferLine."Transfer-from Code", '', TransferLine."Receipt Date", 0D, 0, ReservStatus::Surplus);

                    CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(5741, 0, TransferLine."Document No.", '', 0, TransferLine."Line No.");

                    SecondSourceRowID := ItemTrackingMgt.ComposeRowID(5741, 1, TransferLine."Document No.", '', 0, TransferLine."Line No.");

                    ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID, SecondSourceRowID, '');
                end;
        end;
    end;

    local procedure GetLastReserveEntry(): Integer
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.reset();
        ReservationEntry.ReadIsolation := IsolationLevel::UpdLock;
        ReservationEntry.SetCurrentKey("Entry No.");
        if ReservationEntry.FindLast() then
            exit(ReservationEntry."Entry No." + 1);
        exit(1);
    end;
}
