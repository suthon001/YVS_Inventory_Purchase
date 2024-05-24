/// <summary>
/// TableExtension YVS Permission Set Buffer (ID 75003) extends Record Permission Set Buffer.
/// </summary>
tableextension 75003 "YVS Permission Set Buffer" extends "Permission Set Buffer"
{
    fields
    {
        field(75000; "Cost Invisible"; Boolean)
        {
            Caption = 'Cost Invisible';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75001; "Item Invisible"; Boolean)
        {
            Caption = 'Item Invisible';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
