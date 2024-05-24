/// <summary>
/// TableExtension YVS Transfer Header (ID 75006) extends Record Transfer Header.
/// </summary>
tableextension 75006 "YVS Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(75000; "Send By"; Code[50])
        {
            Caption = 'Send By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75001; "Send DateTime"; DateTime)
        {
            Caption = 'Send DateTime';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75002; "Send Transfer"; Boolean)
        {
            Caption = 'Send Transfer';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
