/// <summary>
/// TableExtension YVS Item Journal Line (ID 75000) extends Record Item Journal Line.
/// </summary>
tableextension 75000 "YVS Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(75000; "YVS Approve Status"; enum "YVS Item Journal Doc. Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75001; "YVS Is Batch"; Boolean)
        {
            Caption = 'Is Batch';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    trigger OnDelete()
    begin
        TestStatusRelease();
    end;
    /// <summary>
    /// TestStatusRelease.
    /// </summary>
    procedure TestStatusRelease()
    begin
        TESTFIELD("YVS Approve Status", "YVS Approve Status"::Open);
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendItemJournalforApproval(var ItemJournalLine: Record "Item Journal Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelItemJournalforApproval(var ItemJournalLine: Record "Item Journal Line");
    begin
    end;


    local procedure IsItemItemJournalEnabled(var ItemJournalLine: Record "Item Journal Line"): Boolean
    var
        WFMngt: Codeunit "Workflow Management";
        WFCode: Codeunit "YVS Inven & Purchase Func";
    begin
        exit(WFMngt.CanExecuteWorkflow(ItemJournalLine, WFCode.RunWorkflowOnSendItemJournalLineApprovalCode()))
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
        if rec."YVS Approve Status" = rec."YVS Approve Status"::"Pending Approval" then
            Error(Text003Msg);
    end;


    /// <summary>
    /// CheckWorkflowItemJournalEnabled.
    /// </summary>
    /// <param name="ItemJournalLine">VAR Record "Item Journal Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckWorkflowItemJournalEnabled(var ItemJournalLine: Record "Item Journal Line"): Boolean
    var
        NoWorkflowEnbMsg: Label 'No workflow Enabled for this Record type';
    begin
        ItemJournalLine.TestField("Posting Date");
        ItemJournalLine.TestField("Document Date");
        ItemJournalLine.TestField("Document No.");
        ItemJournalLine.TestField("Item No.");
        ItemJournalLine.TestField("Location Code");
        ItemJournalLine.TestField(Quantity);
        ItemJournalLine.TestField("YVS Approve Status", ItemJournalLine."YVS Approve Status"::Open);
        if not IsItemItemJournalEnabled(ItemJournalLine) then
            Error(NoWorkflowEnbMsg);
        exit(true);
    end;

    var
        Text002Msg: Label 'This document can only be released when the approval process is complete.';
        Text003Msg: Label 'The approval process must be cancelled or completed to reopen this document.';

}
