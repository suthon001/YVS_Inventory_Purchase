/// <summary>
/// TableExtension YVS Approval Entry (ID 75001) extends Record Approval Entry.
/// </summary>
tableextension 75001 "YVS Approval Entry" extends "Approval Entry"
{
    fields
    {
        field(75000; "YVS Ref. Journal Template Name"; Code[10])
        {
            Caption = 'Ref. Journal Template Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75001; "YVS Ref. Journal Batch Name"; Code[10])
        {
            Caption = 'Ref. Journal Batch Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75002; "YVS Ref. Journal Line No."; Integer)
        {
            Caption = 'Ref. Journal Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75003; "YVS Ref. Journal Document No."; Code[20])
        {
            Caption = 'Ref. Journal Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75004; "YVS Ref. Journal Item No."; Code[20])
        {
            Caption = 'Ref. Journal Item No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75005; "YVS Ref. Journal Quantity"; Decimal)
        {
            Caption = 'Ref. Journal Quantity';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75006; "YVS Ref. Journal Location Code"; Code[20])
        {
            Caption = 'Ref. Journal Location Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75007; "YVS Is Batch"; Boolean)
        {
            Caption = 'Is Batch';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
