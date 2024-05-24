/// <summary>
/// TableExtension YVS Purch. Rcpt. Line (ID 75005) extends Record Purch. Rcpt. Line.
/// </summary>
tableextension 75005 "YVS Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(75000; "YVS Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DataClassification = CustomerContent;
        }
    }
}
