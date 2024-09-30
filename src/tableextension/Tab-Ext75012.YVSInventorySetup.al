/// <summary>
/// TableExtension YVS Inventory Setup (ID 75012) extends Record Inventory Setup.
/// </summary>
tableextension 75012 "YVS Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(75000; "YVS To PDA URL (Transfer)"; Text[250])
        {
            Caption = 'Interface To PDA URL (Transfer)';
            DataClassification = CustomerContent;
        }
        field(75001; "YVS To PDA URL (Item Journal)"; Text[250])
        {
            Caption = 'Interface To PDA URL (Item Journal)';
            DataClassification = CustomerContent;
        }
    }
}
