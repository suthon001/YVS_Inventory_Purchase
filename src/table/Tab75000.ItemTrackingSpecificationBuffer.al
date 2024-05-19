/// <summary>
/// Table YVS Tracking Speci. Buffer (ID 75000).
/// </summary>
table 75000 "YVS Tracking Speci. Buffer"
{
    Caption = 'Item Tracking Specification Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Ref. Journal Template Name"; code[20])
        {
            Caption = 'Ref. Journal Template Name';
        }
        field(2; "Ref. Journal Batch Name"; code[20])
        {
            Caption = 'Ref. Journal Batch Name';
        }
        field(3; "Ref. Line No."; Integer)
        {
            Caption = 'Ref. Line No.';
        }
        field(4; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(5; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(6; "Serial No."; Code[50])
        {
            Caption = 'Series No.';
        }
        field(7; "New Lot No."; Code[50])
        {
            Caption = 'New Lot No.';
        }
        field(8; "New Serial No."; Code[50])
        {
            Caption = 'New Series No.';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(10; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(11; "New Expiration Date"; Date)
        {
            Caption = 'New Expiration Date';
        }
        field(12; "Warranty Date"; Date)
        {
            Caption = 'Expire Date';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    /// <summary>
    /// getLastEntry.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure getLastEntry(): Integer
    var
        ItemTrackingBuffger: Record "YVS Tracking Speci. Buffer";
    begin
        ItemTrackingBuffger.reset();
        ItemTrackingBuffger.SetCurrentKey("Entry No.");
        if ItemTrackingBuffger.FindLast() then
            exit(ItemTrackingBuffger."Entry No." + 1);
        exit(1);
    end;
}
