/// <summary>
/// PageExtension YVS Order Processor Role Cente (ID 75018) extends Record Order Processor Role Center.
/// </summary>
pageextension 75018 "YVS Order Processor Role Cente" extends "Order Processor Role Center"
{
    actions
    {
        addlast(Action62)
        {
            action(PostedItemJournal)
            {
                ApplicationArea = Location;
                Caption = 'Posted Item Journal';
                RunObject = Page "YVS Posted Item Journal Lines";
                ToolTip = 'Executes the Posted Item Journal action.';

            }
        }
    }
}
