/// <summary>
/// TableExtension YVS Transfer Header (ID 75006) extends Record Transfer Header.
/// </summary>
tableextension 75006 "YVS Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(75000; "YVS Send By"; Code[50])
        {
            Caption = 'Send By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75001; "YVS Send DateTime"; DateTime)
        {
            Caption = 'Send DateTime';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75002; "YVS Send API"; Boolean)
        {
            Caption = 'Send API';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
