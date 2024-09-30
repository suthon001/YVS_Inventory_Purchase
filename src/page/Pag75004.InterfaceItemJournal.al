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
                }
                field(batchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(entryType; Rec."Entry Type")
                {
                    Caption = 'Entry Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(uom; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
            }
        }
    }
}
