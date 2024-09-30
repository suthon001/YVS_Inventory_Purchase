/// <summary>
/// Page Interface Transfer Order (ID 75000).
/// </summary>
page 75000 "YVS Interface Transfer Order"
{
    APIGroup = 'bc';
    APIPublisher = 'interface';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'interface Transfer Order';
    DelayedInsert = true;
    EntityName = 'transferOrder';
    EntitySetName = 'transferOrders';
    PageType = API;
    SourceTable = "Transfer Line";
    SourceTableTemporary = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(quantityUpdate; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }

            }
        }
    }
}
