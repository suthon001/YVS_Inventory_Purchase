/// <summary>
/// PageExtension YVS Transfer Orders (ID 75010) extends Record Transfer Orders.
/// </summary>
pageextension 75010 "YVS Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("YVS Send API"; Rec."YVS Send API")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Send API field.';
            }
            field("YVS Send By"; Rec."YVS Send By")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Send By field.';
            }
            field("YVS Send DateTime"; Rec."YVS Send DateTime")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Send DateTime field.';
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action(TESTJson)
            {
                Image = SendConfirmation;
                ApplicationArea = all;
                ToolTip = 'Executes the TEST Json action.';
                Caption = 'Send API';
                trigger OnAction()
                var
                    TransferOrder: Record "Transfer Header";
                    InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
                begin
                    TransferOrder.Copy(rec);
                    CurrPage.SetSelectionFilter(TransferOrder);
                    InvenPurchFunc.CreateJsonTransferOrder(TransferOrder);
                end;
            }
        }
        modify(Category_Category11)
        {
            Caption = 'API';
        }
        addfirst(Category_Category11)
        {
            actionref(TESTJson_Promoted; "TESTJson") { }
        }
    }
}
