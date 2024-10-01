/// <summary>
/// Table YVS Trans. Transfer (ID 75004).
/// </summary>
table 75004 "YVS Trans. Journal Buffer"
{
    Caption = 'API Trans. Journal Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;
    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Entry Type"; text[50])
        {
            Caption = 'Entry Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(9; "Unit of Measure Code"; code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
    }
    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }
}
