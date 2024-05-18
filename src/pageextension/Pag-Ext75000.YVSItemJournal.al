/// <summary>
/// PageExtension YVS Item Journal (ID 75000) extends Record Item Journal.
/// </summary>
pageextension 75000 "YVS Item Journal" extends "Item Journal"
{
    layout
    {
        addfirst(Control1)
        {
            field("YVS Status"; Rec."YVS Status")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Status field.';
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
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
                        ReleaseBillDoc.RereleaseBilling(Rec);
                    end;
                }
                action("Open")
                {
                    Caption = 'Open';
                    Image = ReOpen;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Open action.';
                    trigger OnAction()
                    var
                        ReleaseBillDoc: Codeunit "YVS Inven & Purchase Func";
                    begin
                        ReleaseBillDoc.ReopenBilling(Rec);
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
                        begin
                            ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
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
                        begin
                            ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
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
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.RejectRecordApprovalRequest(rec.RecordId);
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
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.DelegateRecordApprovalRequest(rec.RecordId);
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
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.GetApprovalComment(Rec);
                        end;
                    }
                }
                group("Request to Approval")
                {
                    Caption = 'Request to Approval';
                    action("Send A&pproval Requst")
                    {
                        Enabled = NOT OpenApprovalEntriesExist AND CanRequstApprovelForFlow;
                        Image = SendApprovalRequest;
                        ApplicationArea = all;
                        Caption = 'Send A&pproval Requst';
                        ToolTip = 'Executes the Send A&pproval Requst action.';
                        trigger OnAction()
                        begin
                            if Rec.CheckWorkflowItemJournalEnabled(Rec) then
                                Rec.OnSendItemJournalforApproval(rec);
                        end;
                    }
                    action("Cancel Approval Request")
                    {
                        Enabled = (CancancelApprovalForrecord OR CanRequstApprovelForFlow) AND (OpenApprovalEntriesExist);
                        Image = CancelApprovalRequest;
                        ApplicationArea = all;
                        Caption = 'Cancel Approval Request';
                        ToolTip = 'Executes the Cancel Approval Request action.';
                        trigger OnAction()
                        begin
                            Rec.OnCancelItemJournalforApproval(rec);
                        end;
                    }
                }
            }
        }
        addfirst(Category_Category8)
        {
            group("ReleaseReOpen_Promoted")
            {
                Caption = 'Release&ReOpen';
                ShowAs = SplitButton;

                actionref(Release_promted; Release)
                {
                }
                actionref(Open_promted; Open)
                {
                }

            }
        }
        addfirst(Category_Category12)
        {
            group(ApproveEntries_Promoted)
            {
                Caption = 'Approve Entries';
                actionref(Approve_Entries_Promoted; "Approve Entries") { }
            }
        }
        addfirst(Category_Category9)
        {
            group("Approval_Promoted")
            {
                Caption = 'Approval';
                actionref(Approve_Promoted; "Approve") { }
                actionref(Reject_Promoted; "Reject") { }
                actionref(Delegate_Promoted; "Delegate") { }
                actionref(Comment_Promoted; "Comment") { }

            }

        }
        addfirst(Category_Category10)
        {
            group("Request to Approval_Promoted")
            {
                Caption = 'Request to Approval';
                actionref(SendApprovalRequst_Promoted; "Send A&pproval Requst") { }
                actionref(CancelApprovalRequest_Promoted; "Cancel Approval Request") { }

            }
        }

    }
    trigger OnOpenPage()
    begin
        if gvDocument <> '' then
            rec.SetRange("Line No.", gvLineNo);
    end;
    /// <summary>
    /// SetDocumnet.
    /// </summary>
    /// <param name="pTemplateName">code[10].</param>
    /// <param name="pBatchName">code[10].</param>
    /// <param name="pDocument">code[20].</param>
    /// <param name="pLineNo">Integer.</param>
    procedure SetDocumnet(pTemplateName: code[10]; pBatchName: code[10]; pDocument: code[20]; pLineNo: Integer)
    begin
        gvTemplateName := pTemplateName;
        gvBatchName := pBatchName;
        gvDocument := pDocument;
        gvLineNo := pLineNo;
        rec.SetRange("Journal Template Name", gvTemplateName);
        rec.SetRange("Journal Batch Name", gvBatchName);
    end;

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForrecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        workflowWebhoolMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequstApprovelForFlow, CancancelApprovalForrecord);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CancancelApprovalForrecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        workflowWebhoolMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequstApprovelForFlow, CancancelApprovalForrecord);

    end;


    var
        OpenApprovalEntriesExistForCurrUser, CancancelApprovalForrecord, OpenApprovalEntriesExist, CanRequstApprovelForFlow : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        workflowWebhoolMgt: Codeunit "Workflow Webhook Management";
        gvDocument: code[20];
        gvBatchName, gvTemplateName : code[10];
        gvLineNo: Integer;
}
