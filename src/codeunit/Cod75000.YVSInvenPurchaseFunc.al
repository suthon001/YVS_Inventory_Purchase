/// <summary>
/// Codeunit YVS Inven Purchase Func (ID 75000).
/// </summary>
codeunit 75000 "YVS Inven & Purchase Func"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCodeITemJournal(var ItemJournalLine: Record "Item Journal Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        Text002Msg: Label 'This document can only be released when the approval process is complete.';
    begin
        ItemJnlLine.LockTable();
        ItemJnlLine.SetRange("Journal Template Name", ItemJournalLine."Journal Template Name");
        ItemJnlLine.SetRange("Journal Batch Name", ItemJournalLine."Journal Batch Name");
        if ItemJnlLine.FindSet() then
            repeat
                if ItemJnlLine.IsItemItemJournalEnabled(ItemJnlLine) then
                    if ItemJnlLine."YVS Approve Status" <> ItemJnlLine."YVS Approve Status"::Released then
                        ERROR(Text002Msg);
            until ItemJnlLine.Next() = 0;
    end;

    /// <summary>
    /// CreateJsonItemJournal.
    /// </summary>
    /// <param name="pItemJournal">VAR Record "Item Journal Line".</param>
    procedure CreateJsonItemJournal(var pItemJournal: Record "Item Journal Line")
    var
        PageControlField: Record "Page Control Field";
        ltReservetionEntry: Record "Reservation Entry";
        ltField: Record Field;
        ltRecordRef: RecordRef;
        ltFieldRef: FieldRef;
        JsonArray, JsonArrayLineTrackingALL : JsonArray;
        JsonObjectHeader, JsonObject, JsonObjectTracking, JsonObjectAddALL : JsonObject;
        JsonResult: Text;
        ltInteger: Integer;
        ltDecimal: Decimal;
    begin
        if pItemJournal.FindSet() then
            repeat
                CLEAR(JsonObjectHeader);
                ltRecordRef.Get(pItemJournal.RecordId);
                PageControlField.Reset();
                PageControlField.SetCurrentKey(PageNo, FieldNo);
                PageControlField.SetRange(TableNo, Database::"Item Journal Line");
                PageControlField.SetRange(PageNo, Page::"Item Journal");
                PageControlField.SetRange(Visible, 'true');
                if PageControlField.FindSet() then begin
                    JsonObjectHeader.Add('Journal Template Name', pItemJournal."Journal Template Name");
                    JsonObjectHeader.Add('Journal Batch Name', pItemJournal."Journal Batch Name");
                    JsonObjectHeader.Add('Line No.', pItemJournal."Line No.");
                    repeat
                        if ltField.GET(PageControlField.TableNo, PageControlField.FieldNo) then
                            if not ltField.IsPartOfPrimaryKey then begin
                                ltFieldRef := ltRecordRef.Field(ltField."No.");
                                if ltField.Class = ltField.Class::FlowField then
                                    ltFieldRef.CalcField();
                                if ltField.Type in [ltField.Type::Decimal, ltField.Type::Integer] then begin
                                    if ltField.Type = ltField.Type::Integer then begin
                                        Evaluate(ltInteger, format(ltFieldRef.Value));
                                        JsonObjectHeader.Add(ltField."Field Caption", ltInteger);
                                    end;
                                    if ltField.Type = ltField.Type::decimal then begin
                                        Evaluate(ltDecimal, format(ltFieldRef.Value));
                                        JsonObjectHeader.Add(ltField."Field Caption", ltDecimal);
                                    end;
                                end else
                                    if ltField.Type = ltField.Type::Date then
                                        JsonObjectHeader.Add(ltField."Field Caption", format(ltFieldRef.Value, 0, '<year4>/<Month,2>/<Day,2>'))
                                    else
                                        JsonObjectHeader.Add(ltField."Field Caption", format(ltFieldRef.Value));
                            end;
                    until PageControlField.next() = 0;
                end;
                CLEAR(JsonObjectTracking);
                CLEAR(JsonArrayLineTrackingALL);
                ltReservetionEntry.reset();
                ltReservetionEntry.SetCurrentKey("Entry No.");
                ltReservetionEntry.SetRange("Source ID", pItemJournal."Journal Template Name");
                ltReservetionEntry.SetRange("Source Batch Name", pItemJournal."Journal Batch Name");
                ltReservetionEntry.SetRange("Source Ref. No.", pItemJournal."Line No.");
                if ltReservetionEntry.FindSet() then begin
                    repeat
                        CLEAR(JsonObjectTracking);
                        JsonObjectTracking.Add('Lot No.', ltReservetionEntry."Lot No.");
                        JsonObjectTracking.Add('Serial No.', ltReservetionEntry."Serial No.");
                        JsonObjectTracking.Add('Quantity', ltReservetionEntry.Quantity);
                        JsonObjectTracking.Add('Expiration Date', ltReservetionEntry."Expiration Date");
                        JsonObjectTracking.Add('Warranty Date', ltReservetionEntry."Warranty Date");
                        JsonArrayLineTrackingALL.Add(JsonObject);
                    until ltReservetionEntry.Next() = 0;
                    JsonObjectHeader.Add('reservetion', JsonArrayLineTrackingALL);
                end;
                JsonArray.Add(JsonObjectHeader);
                pItemJournal."YVS Send By" := COPYSTR(UserId(), 1, MaxStrLen(pItemJournal."YVS Send By"));
                pItemJournal."YVS Send DateTime" := CurrentDateTime();
                pItemJournal."YVS Send API" := true;
                pItemJournal.Modify();
            until pItemJournal.Next() = 0;
        JsonObjectAddALL.Add('itemjournals', JsonArray);
        JsonObjectAddALL.WriteTo(JsonResult);
        Message(JsonResult);
    end;

    /// <summary>
    /// CreateJsonTransferOrder.
    /// </summary>
    /// <param name="pTransferOrder">VAR Record "Transfer Header".</param>
    procedure CreateJsonTransferOrder(var pTransferOrder: Record "Transfer Header")
    var
        TransferLines: Record "Transfer Line";
        PageControlField: Record "Page Control Field";
        ltReservetionEntry: Record "Reservation Entry";
        ltField: Record Field;
        ltRecordRef: RecordRef;
        ltFieldRef: FieldRef;
        JsonArray, JsonArrayLine, JsonArrayLineTrackingALL : JsonArray;
        JsonObjectHeader, JsonObject, JsonObjectLine, JsonObjectTracking, JsonObjectAddALL : JsonObject;
        JsonResult: Text;
        ltInteger: Integer;
        ltDecimal: Decimal;
    begin
        if pTransferOrder.FindSet() then
            repeat
                JsonObjectHeader.Add('No', pTransferOrder."No.");
                JsonObjectHeader.Add('Transfer_from_Code', pTransferOrder."Transfer-from Code");
                JsonObjectHeader.Add('Transfer_to_Code', pTransferOrder."Transfer-to Code");
                JsonObjectHeader.Add('Retailer_No', pTransferOrder."Transfer-to Code");
                JsonObjectHeader.Add('Store_Location', pTransferOrder."Transfer-to Code");
                JsonObjectHeader.Add('Store_Contact', pTransferOrder."Transfer-to Code");
                JsonObjectHeader.Add('Order_No', pTransferOrder."Transfer-to Code");
                JsonObjectHeader.Add('Document_Date', format(pTransferOrder."Posting Date", 0, '<Day,2>/<Month,2>/<year4>'));
                TransferLines.reset();
                TransferLines.SetRange("Document No.", pTransferOrder."No.");
                TransferLines.SetRange("Derived From Line No.", 0);
                TransferLines.SetFilter("Item No.", '<>%1', '');
                if TransferLines.FindSet() then
                    repeat

                    until TransferLines.Next() = 0;
                JsonArrayLine.Add(JsonObjectLine);
                CLEAR(JsonObject);
                JsonObjectHeader.Add('lines', JsonArrayLine);
                JsonArray.Add(JsonObjectHeader);
                pTransferOrder."YVS Send By" := COPYSTR(UserId(), 1, MaxStrLen(pTransferOrder."YVS Send By"));
                pTransferOrder."YVS Send DateTime" := CurrentDateTime();
                pTransferOrder."YVS Send API" := true;
                pTransferOrder.Modify();
            until pTransferOrder.Next() = 0;
        JsonObjectAddALL.Add('transferorders', JsonArray);
        JsonObjectAddALL.WriteTo(JsonResult);
        Message(JsonResult);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdateDirectUnitCost', '', false, false)]
    local procedure OnBeforeUpdateDirectUnitCost(CalledByFieldNo: Integer; var Handled: Boolean; var PurchLine: Record "Purchase Line")
    begin
        if PurchLine."Document Type" = PurchLine."Document Type"::Order then
            if not CheckPermissionItemInVisible() then
                Handled := true;
    end;
    /// <summary>
    /// CheckPermissionCostInVisible.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckPermissionCostInVisible(): Boolean
    var
        PermissionMgt: Codeunit "User Permissions";
        ZeroGUID: Guid;
    begin
        if PermissionMgt.HasUserPermissionSetAssigned(UserSecurityId(), CompanyName, 'COSTINVISIBLE', 1, ZeroGUID) then
            exit(false);
        exit(true);
    end;

    /// <summary>
    /// CheckPermissionItemInVisible.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckPermissionItemInVisible(): Boolean
    var
        PermissionMgt: Codeunit "User Permissions";
        ZeroGUID: Guid;
    begin
        if PermissionMgt.HasUserPermissionSetAssigned(UserSecurityId(), CompanyName, 'ITEMINVISIBLE', 1, ZeroGUID) then
            exit(false);
        exit(true);
    end;


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
    /// RereleaseItemJoural.
    /// </summary>
    /// <param name="ItemJournalLine">Record "Item Journal Line".</param>
    procedure RereleaseItemJoural(var ItemJournalLine: Record "Item Journal Line")
    var
        JournalBatch: record "Item Journal Batch";
    begin
        IF ItemJournalLine."YVS Approve Status" IN [ItemJournalLine."YVS Approve Status"::Released] THEN
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
        ItemJournalLine."YVS Approve Status" := ItemJournalLine."YVS Approve Status"::Released;
        ItemJournalLine.MODIFY();
    end;


    /// <summary>
    /// ReopenBilling.
    /// </summary>
    /// <param name="ItemJournalLine">VAR Record "Item Journal Line".</param>
    procedure "ReopenItemJournal"(var ItemJournalLine: Record "Item Journal Line")
    begin
        IF ItemJournalLine."YVS Approve Status" in [ItemJournalLine."YVS Approve Status"::Open] THEN
            EXIT;

        ItemJournalLine.CheckbeforReOpen();
        ItemJournalLine."YVS Approve Status" := ItemJournalLine."YVS Approve Status"::Open;
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
                    ItemJournalLines."YVS Approve Status" := ItemJournalLines."YVS Approve Status"::"Pending Approval";
                    ItemJournalLines."YVS Is Batch" := false;
                    ItemJournalLines.Modify();
                    IsHandled := true;
                end;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ItemJournalLines.reset();
                    ItemJournalLines.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLines.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLines.SetFilter("Posting Date", '<>%1', 0D);
                    ItemJournalLines.SetFilter("Document Date", '<>%1', 0D);
                    ItemJournalLines.SetFilter("Document No.", '<>%1', '');
                    ItemJournalLines.SetFilter("Item No.", '<>%1', '');
                    ItemJournalLines.SetFilter("Location Code", '<>%1', '');
                    ItemJournalLines.SetFilter("Quantity", '<>%1', 0);
                    ItemJournalLines.SetRange("YVS Approve Status", ItemJournalLines."YVS Approve Status"::Open);
                    if ItemJournalLines.FindSet() then
                        repeat
                            ItemJournalLines."YVS Approve Status" := ItemJournalLines."YVS Approve Status"::"Pending Approval";
                            ItemJournalLines."YVS Is Batch" := true;
                            ItemJournalLines.Modify();
                        until ItemJournalLines.next() = 0;
                    IsHandled := true;
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
                    ItemJournalLines."YVS Approve Status" := ItemJournalLines."YVS Approve Status"::Released;
                    ItemJournalLines.Modify();
                    Handled := true;
                end;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ItemJournalLines.reset();
                    ItemJournalLines.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLines.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLines.SetRange("YVS Approve Status", ItemJournalLines."YVS Approve Status"::"Pending Approval");
                    ItemJournalLines.SetRange("YVS Is Batch", true);
                    if ItemJournalLines.FindSet() then
                        repeat
                            ItemJournalLines."YVS Approve Status" := ItemJournalLines."YVS Approve Status"::Released;
                            ItemJournalLines.Modify();
                        until ItemJournalLines.next() = 0;
                    Handled := true;
                end;
        end;

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
                    ItemJournalLines."YVS Approve Status" := ItemJournalLines."YVS Approve Status"::Open;
                    ItemJournalLines."YVS Is Batch" := false;
                    ItemJournalLines.Modify();
                    Handled := true;
                END;
            DATABASE::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJournalBatch);
                    ItemJournalLines.reset();
                    ItemJournalLines.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLines.SetRange("Journal Batch Name", ItemJournalBatch.Name);
                    ItemJournalLines.SetRange("YVS Approve Status", ItemJournalLines."YVS Approve Status"::"Pending Approval");
                    ItemJournalLines.SetRange("YVS Is Batch", true);
                    if ItemJournalLines.FindSet() then
                        repeat
                            ItemJournalLines."YVS Approve Status" := ItemJournalLines."YVS Approve Status"::Open;
                            ItemJournalLines."YVS Is Batch" := false;
                            ItemJournalLines.Modify();
                        until ItemJournalLines.next() = 0;
                    Handled := true;
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
                    ItemJournalLine.SetRange("YVS Approve Status", ItemJournalLine."YVS Approve Status"::Open);
                    ItemJournalLine.CalcSums(Quantity, Amount, "Amount (ACY)");
                    ApprovalEntryArgument."YVS Ref. Journal Quantity" := ItemJournalLine.Quantity;
                    ApprovalEntryArgument.Amount := ItemJournalLine.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := ItemJournalLine."Amount (ACY)";
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
      BuildItemJournalLineCondition(ItemJournalLine."YVS Approve Status"::Open),
      RunWorkflowOnSendItemJournalLineApprovalCode(),
       BuildItemJournalLineCondition(ItemJournalLine."YVS Approve Status"::"Pending Approval"),
       RunWorkflowOnCancelItemJournalLineApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;


    local procedure InsertItemJournalBatchDetailWOrkflow(var workflow: Record Workflow)
    var

        WorkflowSetpArgument: Record "Workflow Step Argument";
        blankDateFormula: DateFormula;
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildItemJournalBatchCondition(),
      RunWorkflowOnSendItemJournalBatchApprovalCode(),
       BuildItemJournalBatchCondition(),
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
        ItemJournalLine.SetRange("Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name");
        ItemJournalLine.SetRange("Entry Type");
        ItemJournalLine.SetRange("YVS Approve Status", Status);
        exit(StrSubstNo(ItemJournalLineConditionTxt, workflowSetup.Encode(ItemJournalLine.GetView(false))));
    end;

    local procedure BuildItemJournalBatchCondition(): Text
    var
        ItemJournalBatch: Record "Item Journal Batch";
        workflowSetup: Codeunit "Workflow Setup";
    begin
        ItemJournalBatch.SetRange("Journal Template Name");
        ItemJournalBatch.SetRange(Name);
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
