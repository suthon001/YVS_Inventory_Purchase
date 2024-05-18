/// <summary>
/// Codeunit YVS Inven Purchase Func (ID 75000).
/// </summary>
codeunit 75000 "YVS Inven & Purchase Func"
{

    [EventSubscriber(ObjectType::table, database::"Approval Entry", 'OnBeforeShowRecord', '', false, false)]
    local procedure OnBeforeShowRecord(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournal: Page "Item Journal";
    begin
        if ApprovalEntry."YVS Ref. Journal Template Name" <> '' then begin
            CLEAR(ItemJournal);
            ItemJournalLine.reset();
            ItemJournalLine.SetFilter("Journal Template Name", ApprovalEntry."YVS Ref. Journal Template Name");
            ItemJournalLine.SetFilter("Journal Batch Name", ApprovalEntry."YVS Ref. Journal Batch Name");
            if ItemJournalLine.FindFirst() then begin
                ItemJournal.SetRecord(ItemJournalLine);
                ItemJournal.SetDocumnet(ApprovalEntry."YVS Ref. Journal Template Name", ApprovalEntry."YVS Ref. Journal Batch Name", ApprovalEntry."YVS Ref. Journal Document No.",
                ApprovalEntry."YVS Ref. Journal Line No.", ApprovalEntry."YVS Is Batch");
                ItemJournal.Run();
                CLEAR(ItemJournal);
            end;
            IsHandled := true;
        end;
    end;


    /// <summary>
    /// RereleaseBilling.
    /// </summary>
    /// <param name="ItemJournalLine">Record "Item Journal Line".</param>
    procedure RereleaseBilling(var ItemJournalLine: Record "Item Journal Line")
    var
        JournalBatch: record "Item Journal Batch";
    begin
        IF ItemJournalLine."YVS Status" IN [ItemJournalLine."YVS Status"::Released] THEN
            EXIT;
        JournalBatch.reset();
        JournalBatch.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
        JournalBatch.SetRange(Name, ItemJournalLine."Journal Batch Name");
        if JournalBatch.FindFirst() then
            JournalBatch.CheckBeforRelease();

        ItemJournalLine.CheckBeforRelease();
        ItemJournalLine.TestField("Posting Date");
        ItemJournalLine.TestField("Document Date");
        ItemJournalLine.TestField("Document No.");
        ItemJournalLine.TestField("Item No.");
        ItemJournalLine.TestField("Location Code");
        ItemJournalLine.TestField(Quantity);
        ItemJournalLine."YVS Status" := ItemJournalLine."YVS Status"::Released;
        ItemJournalLine.MODIFY();
    end;


    /// <summary>
    /// ReopenBilling.
    /// </summary>
    /// <param name="ItemJournalLine">VAR Record "Item Journal Line".</param>
    procedure "ReopenBilling"(var ItemJournalLine: Record "Item Journal Line")
    var
        JournalBatch: record "Item Journal Batch";
    begin
        IF ItemJournalLine."YVS Status" in [ItemJournalLine."YVS Status"::Open] THEN
            EXIT;
        JournalBatch.reset();
        JournalBatch.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
        JournalBatch.SetRange(Name, ItemJournalLine."Journal Batch Name");
        if JournalBatch.FindFirst() then
            JournalBatch.CheckbeforReOpen();

        ItemJournalLine.CheckbeforReOpen();
        ItemJournalLine."YVS Status" := ItemJournalLine."YVS Status"::Open;
        ItemJournalLine."YVS Is Batch" := false;
        ItemJournalLine.MODIFY();
    end;



    /// <summary>
    /// RunWorkflowOnSendItemJournalBatchApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnSendItemJournalBatchApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendItemJournalBatchApproval'))
    end;

    /// <summary>
    /// RunWorkflowOnCancelItemJournalBatchApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnCancelItemJournalBatchApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelItemJournalBatchApproval'));
    end;

    /// <summary>
    /// RunWorkflowOnApproveItemJournalBatchApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnApproveItemJournalBatchApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveItemJournalBatchApproval'))
    end;


    /// <summary>
    /// RunWorkflowOnRejectItemJournalBatchApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnRejectItemJournalBatchApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectItemJournalBatchApproval'))
    end;
    /// <summary>
    /// RunWorkflowOnDelegateItemJournalBatchApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnDelegateItemJournalBatchApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateItemJournalBatchApproval'))
    end;



    /// <summary>
    /// RunWorkflowOnSendItemJournalLineApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnSendItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendItemJournalLineApproval'))
    end;
    /// <summary>
    /// RunWorkflowOnCancelItemJournalLineApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnCancelItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelItemJournalLineApproval'));
    end;

    /// <summary>
    /// RunWorkflowOnApproveItemJournalLineApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnApproveItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveItemJournalLineApproval'))
    end;
    /// <summary>
    /// RunWorkflowOnRejectItemJournalLineApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnRejectItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectItemJournalLineApproval'))
    end;

    /// <summary>
    /// RunWorkflowOnDelegateItemJournalLineApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnDelegateItemJournalLineApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateItemJournalLineApproval'))
    end;


    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnSendItemJournalforApproval', '', false, false)]
    local procedure RunWorkflowOnSendItemJournalLineApproval(var ItemJournalLine: Record "Item Journal Line")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendItemJournalLineApprovalCode(), ItemJournalLine);
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnCancelItemJournalforApproval', '', false, false)]
    local procedure OnCancelItemJournalLineforApproval(var ItemJournalLine: Record "Item Journal Line")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelItemJournalLineApprovalCode(), ItemJournalLine);
    end;


    [EventSubscriber(ObjectType::Table, database::"Item Journal Batch", 'OnSendItemJournalBatchforApproval', '', false, false)]
    local procedure RunWorkflowOnSendItemJournalBatchApproval(var ItemJournalBatch: Record "Item Journal Batch")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendItemJournalBatchApprovalCode(), ItemJournalBatch);
    end;

    [EventSubscriber(ObjectType::Table, database::"Item Journal Batch", 'OnCancelItemJournalBatchforApproval', '', false, false)]
    local procedure OnCancelItemJournalBatchforApproval(var ItemJournalBatch: Record "Item Journal Batch")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelItemJournalBatchApprovalCode(), ItemJournalBatch);
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnApproveItemJournalLineApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"Item Journal Line" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if ApprovalEntry."Table ID" = Database::"Item Journal Batch" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveItemJournalBatchApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnRejectApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"Item Journal Line" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if ApprovalEntry."Table ID" = Database::"Item Journal Batch" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectItemJournalBatchApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnDelegateApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"Item Journal Line" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        if ApprovalEntry."Table ID" = Database::"Item Journal Batch" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateItemJournalLineApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure "OnSetStatusToPendingApproval"(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    var
        ItemJournalLines: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        case RecRef.Number of
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLines);
                    ItemJournalLines."YVS Status" := ItemJournalLines."YVS Status"::"Pending Approval";
                    ItemJournalLines.Modify();
                    IsHandled := true;
                end;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ItemJournalBatch."YVS Status" := ItemJournalBatch."YVS Status"::"Pending Approval";
                    ItemJournalBatch.Modify();
                    ItemJournalLines.reset();
                    ItemJournalLines.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLines.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLines.SetRange("YVS Status", ItemJournalLines."YVS Status"::Open);
                    if ItemJournalLines.FindFirst() then begin
                        ItemJournalLines.ModifyALL("YVS Is Batch", true);
                        ItemJournalLines.ModifyALL("YVS Status", ItemJournalLines."YVS Status"::"Pending Approval");
                    end;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure "OnReleaseDocument"(RecRef: RecordRef; var Handled: Boolean);
    var
        ItemJournalLines: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        case RecRef.Number of
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLines);
                    ItemJournalLines."YVS Status" := ItemJournalLines."YVS Status"::Released;
                    ItemJournalLines.Modify();
                end;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ItemJournalBatch."YVS Status" := ItemJournalBatch."YVS Status"::Open;
                    ItemJournalBatch.Modify();
                    ItemJournalLines.reset();
                    ItemJournalLines.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLines.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLines.SetRange("YVS Status", ItemJournalLines."YVS Status"::"Pending Approval");
                    ItemJournalLines.SetRange("YVS Is Batch", true);
                    if ItemJournalLines.FindFirst() then
                        ItemJournalLines.ModifyALL("YVS Status", ItemJournalLines."YVS Status"::Released);
                end;
        end;
        Handled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean);
    var
        ItemJournalLines: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";

    begin
        case RecRef.Number of
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLines);
                    ItemJournalLines."YVS Status" := ItemJournalLines."YVS Status"::Open;
                    ItemJournalLines.Modify();
                    Handled := true;
                END;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ItemJournalBatch."YVS Status" := ItemJournalBatch."YVS Status"::Open;
                    ItemJournalBatch.Modify();
                    ItemJournalLines.reset();
                    ItemJournalLines.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLines.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLines.SetRange("YVS Status", ItemJournalLines."YVS Status"::"Pending Approval");
                    ItemJournalLines.SetRange("YVS Is Batch", true);
                    if ItemJournalLines.FindFirst() then begin
                        ItemJournalLines.ModifyALL("YVS Status", ItemJournalLines."YVS Status"::Open);
                        ItemJournalLines.ModifyAll("YVS Is Batch", false);
                    end;
                end;
        end;
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure "AddItemJournalLineEventToLibrary"()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemJournalLineApprovalCode(), Database::"Item Journal Line", SendItemJournalLineReqLbl, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemJournalLineApprovalCode(), Database::"Item Journal Line", CancelReqItemJournalLineLbl, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemJournalBatchApprovalCode(), Database::"Item Journal Batch", SendItemJournalBatchReqLbl, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemJournalBatchApprovalCode(), Database::"Item Journal Batch", CancelReqItemJournalBatchLbl, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]

    local procedure "OnPopulateApprovalEntryArgument"(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
    begin
        case RecRef.Number OF
            DATABASE::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJournalLine);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Item Journal Line";
                    ApprovalEntryArgument."Document No." := ItemJournalLine."Document No.";
                    ApprovalEntryArgument.Amount := ItemJournalLine.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := ItemJournalLine."Amount (ACY)";
                    ApprovalEntryArgument."YVS Ref. Journal Batch Name" := ItemJournalLine."Journal Batch Name";
                    ApprovalEntryArgument."YVS Ref. Journal Template Name" := ItemJournalLine."Journal Template Name";
                    ApprovalEntryArgument."YVS Ref. Journal Document No." := ItemJournalLine."Document No.";
                    ApprovalEntryArgument."YVS Ref. Journal Line No." := ItemJournalLine."Line No.";
                    ApprovalEntryArgument."YVS Ref. Journal Quantity" := ItemJournalLine.Quantity;
                    ApprovalEntryArgument."YVS Ref. Journal Location Code" := ItemJournalLine."Location Code";
                    ApprovalEntryArgument."YVS Is Batch" := false;
                end;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Item Journal Batch";
                    ApprovalEntryArgument."Document No." := ItemJournalBatch.Name;
                    ApprovalEntryArgument."YVS Ref. Journal Batch Name" := ItemJournalBatch.Name;
                    ApprovalEntryArgument."YVS Ref. Journal Template Name" := ItemJournalBatch."Journal Template Name";
                    ApprovalEntryArgument."YVS Is Batch" := true;
                    ItemJournalLine.reset();
                    ItemJournalLine.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLine.SetRange("YVS Status", ItemJournalLine."YVS Status"::Open);
                    ItemJournalLine.CalcSums(Quantity);
                    ApprovalEntryArgument."YVS Ref. Journal Quantity" := ItemJournalLine.Quantity;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure "OnGetDocumentTypeAndNumber"(var RecRef: RecordRef; var IsHandled: Boolean; var DocumentNo: Text; var DocumentType: Text);
    var
        FieldRef: FieldRef;
    begin
        IF RecRef.Number = DATABASE::"Item Journal Line" then begin
            FieldRef := RecRef.FieldIndex(1);
            DocumentType := Format(FieldRef.Value);
            FieldRef := RecRef.FieldIndex(20);
            DocumentNo := Format(FieldRef.Value);
            IsHandled := true;
        end;
        IF RecRef.Number = DATABASE::"Item Journal Batch" then begin
            FieldRef := RecRef.FieldIndex(1);
            DocumentType := Format(FieldRef.Value);
            FieldRef := RecRef.FieldIndex(2);
            DocumentNo := Format(FieldRef.Value);
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure "OnAddWorkflowCategoriesToLibrary"();
    var
        workflowSetup: Codeunit "Workflow Setup";
    begin
        workflowSetup.InsertWorkflowCategory('ITEMJOURNAL', 'Item Journal Workflow');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInitWorkflowTemplates', '', false, false)]
    local procedure "OnAfterInitWorkflowTemplates"()
    var
        Workflow: Record Workflow;
        workflowSetup: Codeunit "Workflow Setup";
        ApprovalEntry: Record "Approval Entry";

    begin
        Workflow.reset();
        Workflow.SetRange(Category, 'ITEMJOURNAL');
        Workflow.SetRange(Template, true);
        if Workflow.IsEmpty then begin
            workflowSetup.InsertTableRelation(Database::"Item Journal Line", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
            workflowSetup.InsertTableRelation(Database::"Item Journal Batch", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
            InsertWorkflowItemJournalLineTemplate();
            InsertWorkflowItemJournalBatchTemplate();
        end;

    end;


    local procedure InsertWorkflowItemJournalLineTemplate()
    var
        Workflow: Record Workflow;
        workflowSetup: Codeunit "Workflow Setup";
    begin
        workflowSetup.InsertWorkflowTemplate(Workflow, ItemJournalLineCatLbl, 'Item Journal Line Workflow', 'ITEMJOURNAL');
        InsertItemJournalLineDetailWOrkflow(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertWorkflowItemJournalBatchTemplate()
    var
        Workflow: Record Workflow;
        workflowSetup: Codeunit "Workflow Setup";
    begin
        workflowSetup.InsertWorkflowTemplate(Workflow, ItemJournalBatchCatLbl, 'Item Journal Batch Workflow', 'ITEMJOURNAL');
        InsertItemJournalBatchDetailWOrkflow(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;


    local procedure InsertItemJournalLineDetailWOrkflow(var workflow: Record Workflow)
    var

        WorkflowSetpArgument: Record "Workflow Step Argument";
        blankDateFormula: DateFormula;
        ItemJournalLine: Record "Item Journal Line";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildItemJournalLineCondition(ItemJournalLine."YVS Status"::Open),
      RunWorkflowOnSendItemJournalLineApprovalCode(),
       BuildItemJournalLineCondition(ItemJournalLine."YVS Status"::"Pending Approval"),
       RunWorkflowOnCancelItemJournalLineApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;


    local procedure InsertItemJournalBatchDetailWOrkflow(var workflow: Record Workflow)
    var

        WorkflowSetpArgument: Record "Workflow Step Argument";
        blankDateFormula: DateFormula;
        ItemJournalBatch: Record "Item Journal Batch";
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildItemJournalBatchCondition(ItemJournalBatch."YVS Status"::Open),
      RunWorkflowOnSendItemJournalBatchApprovalCode(),
       BuildItemJournalBatchCondition(ItemJournalBatch."YVS Status"::"Pending Approval"),
       RunWorkflowOnCancelItemJournalBatchApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowEventPredecessorsToLibrary"(EventFunctionName: Code[128]);
    var
        WorkflowEventHadning: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            RunWorkflowOnCancelItemJournalLineApprovalCode():
                begin
                    WorkflowEventHadning.AddEventPredecessor(RunWorkflowOnCancelItemJournalLineApprovalCode(), RunWorkflowOnSendItemJournalLineApprovalCode());
                    WorkflowEventHadning.AddEventPredecessor(RunWorkflowOnCancelItemJournalBatchApprovalCode(), RunWorkflowOnSendItemJournalBatchApprovalCode());
                end;
            WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode():
                begin
                    WorkflowEventHadning.AddEventPredecessor(WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendItemJournalLineApprovalCode());
                    WorkflowEventHadning.AddEventPredecessor(WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendItemJournalBatchApprovalCode());
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowResponsePredecessorsToLibrary"(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHanding: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of

            WorkflowResponseHanding.SetStatusToPendingApprovalCode():
                begin

                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SetStatusToPendingApprovalCode(),
                    RunWorkflowOnSendItemJournalLineApprovalCode());
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SetStatusToPendingApprovalCode(),
                  RunWorkflowOnSendItemJournalBatchApprovalCode());
                end;

            WorkflowResponseHanding.SendApprovalRequestForApprovalCode():
                begin
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SendApprovalRequestForApprovalCode(),
                    RunWorkflowOnSendItemJournalLineApprovalCode());
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SendApprovalRequestForApprovalCode(),
                 RunWorkflowOnSendItemJournalBatchApprovalCode());
                end;
            WorkflowResponseHanding.RejectAllApprovalRequestsCode():
                begin
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.RejectAllApprovalRequestsCode(),
                    RunWorkflowOnRejectItemJournalLineApprovalCode());
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.RejectAllApprovalRequestsCode(),
                RunWorkflowOnRejectItemJournalBatchApprovalCode());
                end;
            WorkflowResponseHanding.CancelAllApprovalRequestsCode():
                begin
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.CancelAllApprovalRequestsCode(),
                    RunWorkflowOnCancelItemJournalLineApprovalCode());
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.CancelAllApprovalRequestsCode(),
                RunWorkflowOnCancelItemJournalBatchApprovalCode());
                end;
            WorkflowResponseHanding.OpenDocumentCode():
                begin
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.OpenDocumentCode(),
                    RunWorkflowOnCancelItemJournalLineApprovalCode());
                    WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.OpenDocumentCode(),
                RunWorkflowOnCancelItemJournalBatchApprovalCode());
                end;
        end;

    end;

    local procedure BuildItemJournalLineCondition(Status: Enum "YVS Item Journal Doc. Status"): Text
    var
        ItemJournalLine: Record "Item Journal Line";
        workflowSetup: Codeunit "Workflow Setup";
    begin
        ItemJournalLine.SetRange("YVS Status", Status);
        exit(StrSubstNo(ItemJournalLineConditionTxt, workflowSetup.Encode(ItemJournalLine.GetView(false))));
    end;

    local procedure BuildItemJournalBatchCondition(Status: Enum "YVS Item Journal Doc. Status"): Text
    var
        ItemJournalBatch: Record "Item Journal Batch";
        workflowSetup: Codeunit "Workflow Setup";
    begin
        ItemJournalBatch.SetRange("YVS Status", Status);
        exit(StrSubstNo(ItemJournalBatchConditionTxt, workflowSetup.Encode(ItemJournalBatch.GetView(false))));
    end;

    var


        ItemJournalLineCatLbl: Label 'ITEMJOURNALLINE';
        ItemJournalBatchCatLbl: Label 'ITEMJOURNALBATCH';
        WFMngt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SendItemJournalLineReqLbl: Label 'Approval Request for ItemJournalLine is requested';
        CancelReqItemJournalLineLbl: Label 'Approval of a ItemJournalLine is canceled';
        SendItemJournalBatchReqLbl: Label 'Approval Request for ItemJournalBatch is requested';
        CancelReqItemJournalBatchLbl: Label 'Approval of a ItemJournalBatch is canceled';
        ItemJournalLineConditionTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Item Journal Line">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        ItemJournalBatchConditionTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Item Journal Batch">%1</DataItem></DataItems></ReportParameters>', Locked = true;
}
