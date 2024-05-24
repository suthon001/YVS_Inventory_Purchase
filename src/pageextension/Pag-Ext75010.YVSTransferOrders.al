/// <summary>
/// PageExtension YVS Transfer Orders (ID 75010) extends Record Transfer Orders.
/// </summary>
pageextension 75010 "YVS Transfer Orders" extends "Transfer Orders"
{
    actions
    {
        addfirst(processing)
        {
            action(TESTJson)
            {
                Image = SendConfirmation;
                ApplicationArea = all;
                ToolTip = 'Executes the TESTJson action.';
                trigger OnAction()
                var
                    InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
                begin
                    InvenPurchFunc.CreateJsonTransferOrder(rec);
                end;
            }
        }
        addfirst(Category_Process)
        {
            actionref(TESTJson_Promoted; "TESTJson") { }
        }
    }
}
