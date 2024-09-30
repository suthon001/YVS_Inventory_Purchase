/// <summary>
/// PageExtension YVS Item Card (ID 75016) extends Record Item Card.
/// </summary>
pageextension 75016 "YVS Item Card 2" extends "Item Card"
{
    layout
    {
        addafter("Description 2")
        {
            field("YVS Description TH"; rec."YVS Description TH")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description TH field.';
            }
        }
    }
}
