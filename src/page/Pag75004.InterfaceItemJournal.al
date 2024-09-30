/// <summary>
/// Page Interface Item Journal (ID 75004).
/// </summary>
page 75004 "Interface Item Journal"
{
    APIGroup = 'bc';
    APIPublisher = 'interface';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'interface Item Journal';
    DelayedInsert = true;
    EntityName = 'itemjournal';
    EntitySetName = 'itemjournals';
    PageType = API;
    SourceTable = "Item Journal Line";
    SourceTableTemporary = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(templateName; Rec."Journal Template Name")
                {
                    Caption = 'Journal Template Name';
                    trigger OnValidate()
                    begin
                        if Rec."Journal Template Name" <> '' then
                            gvJsonObject.Add('templateName', Rec."Journal Template Name");
                    end;
                }
                field(batchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                    trigger OnValidate()
                    begin
                        if Rec."Journal Batch Name" <> '' then
                            gvJsonObject.Add('batchName', Rec."Journal Batch Name");
                    end;
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    trigger OnValidate()
                    begin
                        if Rec."Line No." <> 0 then
                            gvJsonObject.Add('lineNo', Rec."Line No.");
                    end;
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                    trigger OnValidate()
                    begin
                        if rec."Posting Date" <> 0D then
                            gvJsonObject.Add('postingDate', rec."Posting Date");
                    end;
                }
                field(entryType; Rec."Entry Type")
                {
                    Caption = 'Entry Type';
                    trigger OnValidate()
                    begin

                        gvJsonObject.Add('entryType', format(Rec."Entry Type"));
                    end;
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                    trigger OnValidate()
                    begin
                        if Rec."Document No." <> '' then
                            gvJsonObject.Add('documentNo', Rec."Document No.");
                    end;
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                    trigger OnValidate()
                    begin
                        if Rec."Item No." <> '' then
                            gvJsonObject.Add('itemNo', Rec."Item No.");
                    end;
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    trigger OnValidate()
                    begin
                        if Rec.Quantity <> 0 then
                            gvJsonObject.Add('quantity', Rec.Quantity);
                    end;
                }
                field(uom; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                    trigger OnValidate()
                    begin
                        if Rec."Unit of Measure Code" <> '' then
                            gvJsonObject.Add('uom', Rec."Unit of Measure Code");
                    end;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    trigger OnValidate()
                    begin
                        if Rec."Location Code" <> '' then
                            gvJsonObject.Add('locationCode', Rec."Location Code");
                    end;
                }
                field(bcEntryRef; Rec."YVS BC_Entry_Ref")
                {
                    Caption = 'BC Entry Ref';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        APIfunc: Codeunit "YVS Api Func";
        ItemJournalLine: Record "Item Journal Line";
    begin
        if APIfunc.TryUpdateToItemJournal(gvJsonObject) then begin
            ItemJournalLine.GET(rec."Journal Template Name", rec."Journal Batch Name", rec."Line No.");
            rec := ItemJournalLine;
        end;
    end;

    trigger OnOpenPage()
    begin
        Clear(gvJsonObject);
    end;

    var
        gvJsonObject: JsonObject;
}
