/// <summary>
/// PageExtension YVS Item Journal Templates (ID 75015) extends Record Item Journal Templates.
/// </summary>
pageextension 75015 "YVS Item Journal Templates" extends "Item Journal Templates"
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
