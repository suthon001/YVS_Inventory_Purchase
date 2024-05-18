/// <summary>
/// TableExtension YVS Item Journal Batch (ID 75002) extends Record Item Journal Batch.
/// </summary>
tableextension 75002 "YVS Item Journal Batch" extends "Item Journal Batch"
{
    fields
    {
        field(75000; "YVS Status"; enum "YVS Item Journal Doc. Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    [IntegrationEvent(false, false)]
    PROCEDURE OnSendItemJournalBatchforApproval(var ItemJournalBatch: Record "Item Journal Batch");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelItemJournalBatchforApproval(var ItemJournalBatch: Record "Item Journal Batch");
    begin
    end;


    local procedure IsItemItemJournalEnabled(var ItemJournalBatch: Record "Item Journal Batch"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "YVS Inven & Purchase Func";
    begin
        exit(WFMngt.CanExecuteWorkflow(ItemJournalBatch, WFCode.RunWorkflowOnSendItemJournalBatchApprovalCode()))
    end;


    /// <summary>
    /// CheckRelease.
    /// </summary>
    procedure CheckBeforRelease()
    begin
        if IsItemItemJournalEnabled(rec) then
            Error(Text002Msg);
    end;

    /// <summary>
    /// CheckbeforReOpen.
    /// </summary>
    procedure CheckbeforReOpen()
    begin
        if rec."YVS Status" = rec."YVS Status"::"Pending Approval" then
            Error(Text003Msg);
    end;



    /// <summary>
    /// CheckWorkflowItemJournalEnabled.
    /// </summary>
    /// <param name="ItemJournalBatch">VAR Record "Item Journal Batch".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckWorkflowItemJournalEnabled(var ItemJournalBatch: Record "Item Journal Batch"): Boolean
    var
        ItemJournalLine: Record "Item Journal Line";
        NoWorkflowEnbMsg: Label 'No workflow Enabled for this Record type';
    begin
        ItemJournalLine.reset();
        ItemJournalLine.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.name);
        ItemJournalLine.SetRange("YVS Status", ItemJournalLine."YVS Status"::Open);
        if ItemJournalLine.FindSet() then
            repeat
                ItemJournalLine.TestField("Posting Date");
                ItemJournalLine.TestField("Document Date");
                ItemJournalLine.TestField("Document No.");
                ItemJournalLine.TestField("Item No.");
                ItemJournalLine.TestField("Location Code");
                ItemJournalLine.TestField(Quantity);
            until ItemJournalLine.Next() = 0
        else
            exit(false);
        if not IsItemItemJournalEnabled(ItemJournalBatch) then
            Error(NoWorkflowEnbMsg);
        exit(true);
    end;

    var
        Text002Msg: Label 'This document can only be released when the approval process is complete.';
        Text003Msg: Label 'The approval process must be cancelled or completed to reopen this document.';
}
