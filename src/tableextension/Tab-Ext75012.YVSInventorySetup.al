/// <summary>
/// TableExtension YVS Inventory Setup (ID 75012) extends Record Inventory Setup.
/// </summary>
tableextension 75012 "YVS Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(75000; "YVS To PDA URL (Trans) Orders"; Text[250])
        {
            Caption = 'Interface To PDA URL (Transfer) Orders';
            DataClassification = CustomerContent;
        }
        field(75001; "YVS To PDA URL (Trans) Advice"; Text[250])
        {
            Caption = 'Interface To PDA URL (Transfer) Advice';
            DataClassification = CustomerContent;
        }
        field(75002; "YVS To PDA URL (Item Journal)"; Text[250])
        {
            Caption = 'Interface To PDA URL (Item Journal)';
            DataClassification = CustomerContent;
        }
        field(75003; "YVS PDA Token"; Text[1024])
        {
            Caption = 'PDA Token';
            DataClassification = CustomerContent;
        }
    }
}
