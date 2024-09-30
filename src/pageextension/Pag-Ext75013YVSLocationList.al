/// <summary>
/// PageExtension YVS Location List (ID 75013) extends Record Location List.
/// </summary>
pageextension 75013 "YVS Location List" extends "Location List"
{
    layout
    {
        addlast(Control1)
        {
            field("YVS Main"; rec."YVS Main")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Main field.';
            }
        }
    }
}

