/// <summary>
/// PageExtension YVS No. Series (ID 75017) extends Record No. Series.
/// </summary>
pageextension 75017 "YVS No. Series" extends "No. Series"
{
    layout
    {
        addlast(Control1)
        {
            field("YVS Interface"; rec."YVS Interface")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Interface field.';
            }
        }
    }
}
