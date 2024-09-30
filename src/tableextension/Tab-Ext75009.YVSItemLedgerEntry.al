/// <summary>
/// TableExtension YVS Item Ledger Entry (ID 75009) extends Record Item Ledger Entry.
/// </summary>
tableextension 75009 "YVS Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(75000; "YVS Ship-to Name"; Text[200])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
        }
        field(75001; "YVS Ship-to Address"; Text[255])
        {
            Caption = 'Ship-to Address';
            DataClassification = CustomerContent;
        }
        field(75002; "YVS Ship-to District"; Text[50])
        {
            Caption = 'Ship-to District';
            DataClassification = CustomerContent;
        }
        field(75003; "YVS Ship-to Post Code"; Text[20])
        {
            Caption = 'Ship-to Post Code';
            DataClassification = CustomerContent;
        }
        field(75004; "YVS Ship-to Mobile No."; Text[50])
        {
            Caption = 'Ship-to Mobile No.';
            DataClassification = CustomerContent;
        }
        field(75005; "YVS Ship-to Phone No."; Text[20])
        {
            Caption = 'Ship-to Phone No.';
            DataClassification = CustomerContent;
        }
        field(75006; "YVS Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
        }
        field(75007; "YVS Shipping Agent"; code[10])
        {
            TableRelation = "Shipping Agent".Code;
            DataClassification = CustomerContent;
            Caption = 'Shipping Agent';
        }
        field(75008; "YVS Direction"; enum "YVS Direction")
        {
            Caption = 'Direction';
            DataClassification = CustomerContent;
        }
        field(75009; "YVS Transaction ID"; Integer)
        {
            Caption = 'Transaction ID';
            Editable = false;
        }
        field(75010; "YVS Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            DataClassification = CustomerContent;
        }
        field(75011; "YVS Address"; Text[250])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(75012; "YVS BC_Entry_Ref"; Integer)
        {
            Caption = 'BC_Entry_Ref';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
