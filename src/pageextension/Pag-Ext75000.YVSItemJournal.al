/// <summary>
/// PageExtension YVS Item Journal (ID 75000) extends Record Item Journal.
/// </summary>
pageextension 75000 "YVS Item Journal2" extends "Item Journal"
{
    layout
    {
        modify("Unit Amount")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify(Amount)
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Discount Amount")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        modify("Unit Cost")
        {
            Visible = IsHideValue;
            HideValue = NOT IsHideValue;
        }
        addfirst(Control1)
        {
            field("YVS Approve Status"; Rec."YVS Approve Status")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
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

        addafter("&Print")
        {
            action("InventoryMovementPrint")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    REPORT.RunModal(REPORT::"MRC Inventory Movement", true, true, ItemJnlLine);
                end;
            }
        }


        addfirst(processing)
        {
            action(TESTJson)
            {
                Image = SendConfirmation;
                ApplicationArea = all;
                ToolTip = 'Executes the TEST Json action.';
                Caption = 'Send API';
                Visible = false;
                trigger OnAction()
                var
                    ItemJournalLine: Record "Item Journal Line";
                    InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
                begin
                    ItemJournalLine.Copy(rec);
                    CurrPage.SetSelectionFilter(ItemJournalLine);
                    InvenPurchFunc.CreateJsonItemJournal(ItemJournalLine);
                end;
            }
            group("ReleaseReOpen")
            {
                Caption = 'Release&ReOpen';
                action("Release")
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Release action.';
                    trigger OnAction()
                    var
                        ReleaseBillDoc: Codeunit "YVS Inven & Purchase Func";
                    begin
                        ReleaseBillDoc.RereleaseItemJoural(Rec);
                    end;
                }
                action("Open")
                {
                    Caption = 'ReOpen';
                    Image = ReOpen;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Open action.';
                    trigger OnAction()
                    var
                        ReleaseBillDoc: Codeunit "YVS Inven & Purchase Func";
                    begin

                        ReleaseBillDoc.ReopenItemJournal(Rec);
                    end;
                }
                group(ApproveEntries)
                {
                    Caption = 'Approve Entries';
                    action("Approve Entries")
                    {
                        Caption = 'Approve Entries';
                        Image = Approvals;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Approve Entries action.';
                        trigger OnAction()
                        var
                            JournalBatch: Record "Item Journal Batch";
                        begin
                            if not rec."YVS Is Batch" then
                                ApprovalsMgmt.OpenApprovalEntriesPage(rec.RecordId)
                            else begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    ApprovalsMgmt.OpenApprovalEntriesPage(JournalBatch.RecordId);
                            end;
                        end;
                    }
                }
                group("Approval")
                {
                    Caption = 'Approval';
                    action("Approve")
                    {
                        Caption = 'Approve';
                        Visible = OpenApprovalEntriesExistForCurrUser;
                        Image = Approve;
                        ApplicationArea = all;
                        ToolTip = 'Executes the Approve action.';
                        trigger OnAction()
                        var
                            JournalBatch: Record "Item Journal Batch";
                        begin
                            if not rec."YVS Is Batch" then
                                ApprovalsMgmt.ApproveRecordApprovalRequest(rec.RecordId)
                            else begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    ApprovalsMgmt.ApproveRecordApprovalRequest(JournalBatch.RecordId);
                            end;
                        end;
                    }
                    action(Reject)
                    {
                        ApplicationArea = All;
                        Caption = 'Reject';
                        Image = Reject;
                        ToolTip = 'Reject the approval request.';
                        Visible = OpenApprovalEntriesExistForCurrUser;
                        trigger OnAction()
                        var
                            JournalBatch: Record "Item Journal Batch";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            if not rec."YVS Is Batch" then
                                ApprovalsMgmt.RejectRecordApprovalRequest(rec.RecordId)
                            else begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    ApprovalsMgmt.RejectRecordApprovalRequest(JournalBatch.RecordId);
                            end;

                        end;
                    }
                    action(Delegate)
                    {
                        ApplicationArea = All;
                        Caption = 'Delegate';
                        Image = Delegate;
                        ToolTip = 'Delegate the approval to a substitute approver.';
                        Visible = OpenApprovalEntriesExistForCurrUser;

                        trigger OnAction()
                        var
                            JournalBatch: Record "Item Journal Batch";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            if not rec."YVS Is Batch" then
                                ApprovalsMgmt.DelegateRecordApprovalRequest(rec.RecordId)
                            else begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    ApprovalsMgmt.DelegateRecordApprovalRequest(JournalBatch.RecordId);
                            end;
                        end;
                    }
                    action(Comment)
                    {
                        ApplicationArea = All;
                        Caption = 'Comments';
                        Image = ViewComments;
                        ToolTip = 'View or add comments for the record.';
                        Visible = OpenApprovalEntriesExistForCurrUser;

                        trigger OnAction()
                        var
                            JournalBatch: Record "Item Journal Batch";
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            if not rec."YVS Is Batch" then
                                ApprovalsMgmt.GetApprovalComment(rec)
                            else begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    ApprovalsMgmt.GetApprovalComment(JournalBatch);
                            end;

                        end;
                    }
                }
                group("Request to Approval")
                {
                    Caption = 'Request to Approval';
                    Group("Send A&pproval Requst")
                    {
                        Caption = 'Send A&pproval Requst';
                        action("Journal Batch")
                        {

                            Enabled = NOT OpenApprovalEntriesExistBatch AND CanRequstApprovelForFlowBatch;
                            Image = SendApprovalRequest;
                            ApplicationArea = all;
                            Caption = 'Journal Batch';
                            ToolTip = 'Executes the Send A&pproval Requst action.';
                            trigger OnAction()
                            var
                                JournalBatch: Record "Item Journal Batch";
                            begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    if JournalBatch.CheckWorkflowItemJournalEnabled(JournalBatch) then
                                        JournalBatch.OnSendItemJournalBatchforApproval(JournalBatch);
                            end;
                        }
                        action("Journal by Line")
                        {

                            Enabled = NOT OpenApprovalEntriesExist AND CanRequstApprovelForFlow;
                            Image = SendApprovalRequest;
                            ApplicationArea = all;
                            Caption = 'Journal by Line';
                            ToolTip = 'Executes the Send A&pproval Requst action.';
                            trigger OnAction()
                            begin
                                if Rec.CheckWorkflowItemJournalEnabled(Rec) then
                                    Rec.OnSendItemJournalforApproval(rec);
                            end;
                        }
                    }
                    group("Cancel Approval Request")
                    {
                        Caption = 'Cancel Approval Request';
                        action("CancelJournal Batch")
                        {
                            Enabled = (CancancelApprovalForrecordBatch OR CanRequstApprovelForFlowBatch) AND (OpenApprovalEntriesExistBatch);
                            Image = CancelApprovalRequest;
                            ApplicationArea = all;
                            Caption = 'Journal Batch';
                            ToolTip = 'Executes the Cancel Approval Request action.';
                            trigger OnAction()
                            var
                                JournalBatch: Record "Item Journal Batch";
                            begin
                                JournalBatch.reset();
                                JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
                                JournalBatch.SetRange(Name, rec."Journal Batch Name");
                                if JournalBatch.FindFirst() then
                                    JournalBatch.OnCancelItemJournalBatchforApproval(JournalBatch);
                            end;
                        }
                        action("CancelJournal by Line")
                        {
                            Enabled = (CancancelApprovalForrecord OR CanRequstApprovelForFlow) AND (OpenApprovalEntriesExist);
                            Image = CancelApprovalRequest;
                            ApplicationArea = all;
                            Caption = 'Journal by Line';
                            ToolTip = 'Executes the Cancel Approval Request action.';
                            trigger OnAction()
                            begin
                                Rec.OnCancelItemJournalforApproval(rec);
                            end;
                        }
                    }
                }
            }
        }
        addfirst(Category_Category8)
        {


            actionref(Release_promted; Release)
            {
            }
            actionref(Open_promted; Open)
            {
            }


        }
        addafter("&Print_Promoted")
        {
            actionref(InventoryMovementPrint_Promote; "InventoryMovementPrint") { }
        }
        addfirst(Category_Category12)
        {

            actionref(Approve_Entries_Promoted; "Approve Entries") { }

        }
        addfirst(Category_Category9)
        {

            actionref(Approve_Promoted; "Approve") { }
            actionref(Reject_Promoted; "Reject") { }
            actionref(Delegate_Promoted; "Delegate") { }
            actionref(Comment_Promoted; "Comment") { }


        }
        addfirst(Category_Category10)
        {
            Group("Send A&pproval Requst Promoted")
            {
                Caption = 'Send A&pproval Requst';
                actionref(Journal_Batch_Promoted; "Journal Batch") { }
                actionref(Journal_Line_Promoted; "Journal by Line") { }
            }
            Group("Cancel Approval Request Promoted")
            {
                Caption = 'Cancel Approval Request';
                actionref(CancelJournal_Promoted; "CancelJournal Batch") { }
                actionref(CancelJournalLine_Promoted; "CancelJournal by Line") { }
            }
        }
        modify(Category_Category13)
        {
            Caption = 'API';
        }
        addfirst(Category_Category13)
        {
            actionref(TESTJson_Promoted; "TESTJson") { }
        }
        modify(Category_Category8)
        {
            Caption = 'Release';
        }
        modify(Category_Category10)
        {
            Caption = 'Request to Approval';
        }
        modify(Category_Category9)
        {
            Caption = 'Approval';
        }
        modify(Category_Category12)
        {
            Caption = 'Approve Entries';
        }


    }

    trigger OnOpenPage()
    begin
        if not gvIsBatch then
            if gvDocument <> '' then
                rec.SetRange("Line No.", gvLineNo);

        IsHideValue := InvenPurchFunc.CheckPermissionItemInVisible();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        rec.TestField("YVS Approve Status", rec."YVS Approve Status"::Open);
    end;
    /// <summary>
    /// SetDocumnet.
    /// </summary>
    /// <param name="pTemplateName">code[10].</param>
    /// <param name="pBatchName">code[10].</param>
    /// <param name="pDocument">code[20].</param>
    /// <param name="pLineNo">Integer.</param>
    /// <param name="pIsBatch">Boolean.</param>
    procedure SetDocumnet(pTemplateName: code[10]; pBatchName: code[10]; pDocument: code[20]; pLineNo: Integer; pIsBatch: Boolean)
    begin
        gvTemplateName := pTemplateName;
        gvBatchName := pBatchName;
        gvDocument := pDocument;
        gvLineNo := pLineNo;
        gvIsBatch := pIsBatch;
        rec.SetRange("Journal Template Name", gvTemplateName);
        rec.SetRange("Journal Batch Name", gvBatchName);
        rec.SetRange("YVS Approve Status", rec."YVS Approve Status"::"Pending Approval");
    end;


    trigger OnAfterGetRecord()
    var
        JournalBatch: Record "Item Journal Batch";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForrecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        workflowWebhoolMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequstApprovelForFlow, CancancelApprovalForrecord);

        JournalBatch.reset();
        JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
        JournalBatch.SetRange(name, rec."Journal Batch Name");
        if JournalBatch.FindFirst() then begin
            OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(JournalBatch.RecordId);
            OpenApprovalEntriesExistBatch := ApprovalsMgmt.HasOpenApprovalEntries(JournalBatch.RecordId);
            CancancelApprovalForrecordBatch := ApprovalsMgmt.CanCancelApprovalForRecord(JournalBatch.RecordId);
            workflowWebhoolMgt.GetCanRequestAndCanCancel(JournalBatch.RecordId, CanRequstApprovelForFlowBatch, CancancelApprovalForrecordBatch);
        end
    end;

    trigger OnAfterGetCurrRecord()
    var
        JournalBatch: Record "Item Journal Batch";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForrecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        workflowWebhoolMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequstApprovelForFlow, CancancelApprovalForrecord);
        JournalBatch.reset();
        JournalBatch.SetRange("Journal Template Name", rec."Journal Template Name");
        JournalBatch.SetRange(name, rec."Journal Batch Name");
        if JournalBatch.FindFirst() then begin
            OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(JournalBatch.RecordId);
            OpenApprovalEntriesExistBatch := ApprovalsMgmt.HasOpenApprovalEntries(JournalBatch.RecordId);
            CancancelApprovalForrecordBatch := ApprovalsMgmt.CanCancelApprovalForRecord(JournalBatch.RecordId);
            workflowWebhoolMgt.GetCanRequestAndCanCancel(JournalBatch.RecordId, CanRequstApprovelForFlowBatch, CancancelApprovalForrecordBatch);
        end
    end;


    var

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        workflowWebhoolMgt: Codeunit "Workflow Webhook Management";
        InvenPurchFunc: Codeunit "YVS Inven & Purchase Func";
        OpenApprovalEntriesExistForCurrUser, CancancelApprovalForrecord, OpenApprovalEntriesExist, CanRequstApprovelForFlow : Boolean;
        OpenApprovalEntriesExistForCurrUserBatch, CancancelApprovalForrecordBatch, OpenApprovalEntriesExistBatch, CanRequstApprovelForFlowBatch : Boolean;
        gvDocument: code[20];
        gvBatchName, gvTemplateName : code[10];
        gvLineNo: Integer;
        gvIsBatch: Boolean;
        IsHideValue: Boolean;
}
