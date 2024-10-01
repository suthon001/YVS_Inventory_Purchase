/// <summary>
/// Table YVS Trans. Transfer (ID 75003).
/// </summary>
table 75003 "YVS Trans. Transfer Buffer"
{
    Caption = 'API Transaction Transfer Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(5; Uom; Code[20])
        {
            Caption = 'Uom';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
