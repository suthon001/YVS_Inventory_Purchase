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
                    trigger OnValidate()
                    begin
                        if rec."Document No." <> '' then
                            gvJsonObject.Add('documentNo', rec."Document No.");
                    end;
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    trigger OnValidate()
                    begin
                        if Rec."Line No." <> 0 then
                            gvJsonObject.Add('lineNo', rec."Line No.");
                    end;
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    trigger OnValidate()
                    begin
                        if rec."Item No." <> '' then
                            gvJsonObject.Add('itemNo', rec."Item No.");
                    end;
                }
                field(quantityUpdate; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    trigger OnValidate()
                    begin
                        if rec.Quantity <> 0 then
                            gvJsonObject.Add('quantityUpdate', rec.Quantity);
                    end;
                }
                field(bcEntryRef; bcEntryRef)
                {
                    Caption = 'BC Entry Ref';

                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        APIfunc: Codeunit "YVS Api Func";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
    begin
        if APIfunc.TryUpdateToTransferOrder(gvJsonObject) then begin
            TransferHeader.GET(rec."Document No.");
            TransferLine.GET(rec."Document No.", rec."Line No.");
            rec := TransferLine;
            bcEntryRef := TransferHeader."YVS BC_Entry_Ref";
        end;
    end;

    trigger OnOpenPage()
    begin
        Clear(gvJsonObject);
    end;

    var
        bcEntryRef: Integer;
        gvJsonObject: JsonObject;
}
