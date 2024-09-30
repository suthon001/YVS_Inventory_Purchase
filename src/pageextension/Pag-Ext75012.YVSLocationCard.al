/// <summary>
/// PageExtension YVS Location Card (ID 75012) extends Record Location Card.
/// </summary>
pageextension 75012 "YVS Location Card" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("YVS Main"; rec."YVS Main")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Main field.';
            }
        }
    }
}
