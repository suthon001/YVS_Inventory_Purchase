/// <summary>
/// TableExtension YVS Purchase Line (ID 75004) extends Record Purchase Line.
/// </summary>
tableextension 75004 "YVS Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(75000; "YVS Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            DataClassification = CustomerContent;

        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                rec."YVS Direct Unit Cost" := rec."Direct Unit Cost";
            end;
        }
    }
}
