tableextension 75003 "YVS Transfer Shipment Header" extends "Transfer Shipment Header"
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
        field(75006; "YVS Direction"; enum "YVS Direction")
        {
            Caption = 'Direction';
            DataClassification = CustomerContent;
        }
        field(75007; "YVS Interface Completed"; Boolean)
        {
            Caption = 'Interface Completed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75008; "YVS Send DateTime"; DateTime)
        {
            Caption = 'Send Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(75009; "YVS Interface"; Boolean)
        {
            Caption = 'Interface';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75020; "YVS BC_Entry_Ref"; Integer)
        {
            Caption = 'BC_Entry_Ref';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
