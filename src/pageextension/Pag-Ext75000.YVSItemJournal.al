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
        addafter(Description)
        {
            field("YVS Description TH"; rec."YVS Description TH")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description TH field.';
            }
            field("YVS Search Description"; rec."YVS Search Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Search Description field.';
            }
            field("YVS Address"; rec."YVS Address")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Address field.';
            }
            field("YVS Original Quantity"; rec."YVS Original Quantity")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Original Quantity field.';
            }
        }
        addlast(Control1)
        {
            field("YVS Ship-to Name"; Rec."YVS Ship-to Name")
            {
                ToolTip = 'Specifies the value of the Ship-to Name field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Address"; Rec."YVS Ship-to Address")
            {
                ToolTip = 'Specifies the value of the Ship-to Address field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to District"; Rec."YVS Ship-to District")
            {
                ToolTip = 'Specifies the value of the Ship-to District field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Post Code"; Rec."YVS Ship-to Post Code")
            {
                ToolTip = 'Specifies the value of the Ship-to Post Code field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Phone No."; Rec."YVS Ship-to Phone No.")
            {
                ToolTip = 'Specifies the value of the Ship-to Phone No. field.';
                ApplicationArea = all;
            }
            field("YVS Ship-to Mobile No."; Rec."YVS Ship-to Mobile No.")
            {
                ToolTip = 'Specifies the value of the Ship-to Mobile No. field.';
                ApplicationArea = all;
            }
            field("YVS Shipment Date"; rec."YVS Shipment Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shipment Date field.';
            }
            field("YVS Shipping Agent"; rec."YVS Shipping Agent")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Shipping Agent field.';
            }
            field("YVS Interface Completed"; rec."YVS Interface Completed")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Interface Completed field.';
            }
            field("YVS Send DateTime"; rec."YVS Send DateTime")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Send Date Time field.';
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
                    REPORT.RunModal(REPORT::"YVS Inventory Movement", true, true, ItemJnlLine);
                end;
            }
        }
        modify(YVSPrint)
        {
            Visible = false;
        }



        addfirst(processing)
        {
            action(InterfaceToPDA)
            {
                Caption = 'Submit to PDA';
                Image = Interaction;
                ApplicationArea = all;
                ToolTip = 'Executes the Submit to PDA action.';
                trigger OnAction()
                var
                    ItemJournalLine: Record "Item Journal Line";
                    YVSInterfaceLogEntry: Record "YVS Interface Log Entry";
                    YVSFunc: Codeunit "YVS Api Func";
                begin
                    ItemJournalLine.reset();
                    ItemJournalLine.copy(rec);
                    CurrPage.SetSelectionFilter(ItemJournalLine);
                    if ItemJournalLine.FindSet() then
                        repeat
                            ItemJournalLine.TestFieldAPI();
                        until ItemJournalLine.Next() = 0;
                    ItemJournalLine.reset();
                    ItemJournalLine.copy(rec);
                    CurrPage.SetSelectionFilter(ItemJournalLine);
                    if ItemJournalLine.FindSet() then
                        repeat
                            YVSFunc.InterfaceItemJournalToPDA(rec);
                        until ItemJournalLine.Next() = 0;

                    YVSInterfaceLogEntry.reset();
                    YVSInterfaceLogEntry.SetRange("Action Page", YVSInterfaceLogEntry."Action Page"::"Item Journal");
                    YVSInterfaceLogEntry.SetRange("Primary Key 1", rec."Journal Template Name");
                    YVSInterfaceLogEntry.SetRange("Primary Key 2", rec."Journal Batch Name");
                    YVSInterfaceLogEntry.SetRange("Document No.", rec."Document No.");
                    page.Run(0, YVSInterfaceLogEntry);
                end;
            }
            action(ClearInterface)
            {
                Caption = 'Clear Interface';
                Image = Cancel;
                ApplicationArea = all;
                ToolTip = 'Executes the Clear Interface  action.';
                trigger OnAction()
                var
                    ItemJournalLine: Record "Item Journal Line";
                begin
                    ItemJournalLine.reset();
                    ItemJournalLine.copy(rec);
                    CurrPage.SetSelectionFilter(ItemJournalLine);
                    if ItemJournalLine.FindSet() then
                        repeat
                            ItemJournalLine."YVS Interface Completed" := false;
                            ItemJournalLine."YVS Send DateTime" := 0DT;
                            ItemJournalLine.Modify();
                        until ItemJournalLine.Next() = 0;

                end;
            }
            action(LogInterfaceToPDA)
            {
                Caption = 'Log';
                Image = Log;
                ApplicationArea = all;
                ToolTip = 'Executes the Log action.';
                trigger OnAction()
                var
                    YVSInterfaceLogEntry: Record "YVS Interface Log Entry";
                begin
                    YVSInterfaceLogEntry.reset();
                    YVSInterfaceLogEntry.SetRange("Primary Key 1", rec."Journal Template Name");
                    YVSInterfaceLogEntry.SetRange("Primary Key 2", rec."Journal Batch Name");
                    YVSInterfaceLogEntry.SetRange("Document No.", rec."Document No.");
                    page.Run(0, YVSInterfaceLogEntry);
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
                            ITemJournalLine: Record "Item Journal Line";
                        begin
                            ITemJournalLine.copy(rec);
                            CurrPage.SetSelectionFilter(ITemJournalLine);
                            if ITemJournalLine.FindSet() then
                                repeat
                                    if not ITemJournalLine."YVS Is Batch" then
                                        ApprovalsMgmt.ApproveRecordApprovalRequest(ITemJournalLine.RecordId)
                                    else begin
                                        JournalBatch.reset();
                                        JournalBatch.SetRange("Journal Template Name", ITemJournalLine."Journal Template Name");
                                        JournalBatch.SetRange(Name, ITemJournalLine."Journal Batch Name");
                                        if JournalBatch.FindFirst() then
                                            ApprovalsMgmt.ApproveRecordApprovalRequest(JournalBatch.RecordId);
                                    end;
                                until ITemJournalLine.Next() = 0;
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
                            var
                                ItemJornaline: Record "Item Journal Line";
                                PendingApprovalMsg: Label 'An approval request has been sent.';
                                CheckMessage: Boolean;
                            begin
                                CheckMessage := false;
                                ItemJornaline.copy(Rec);
                                CurrPage.SetSelectionFilter(ItemJornaline);
                                ItemJornaline.SetRange("YVS Approve Status", ItemJornaline."YVS Approve Status"::Open);
                                ItemJornaline.SetFilter("Item No.", '<>%1', '');
                                ItemJornaline.SetFilter(quantity, '<>%1', 0);
                                if ItemJornaline.FindSet() then
                                    repeat
                                        if Rec.CheckWorkflowItemJournalEnabled(ItemJornaline) then begin
                                            Rec.OnSendItemJournalforApproval(ItemJornaline);
                                            CheckMessage := true;
                                        end;
                                    until ItemJornaline.Next() = 0;
                                if CheckMessage then
                                    Message(PendingApprovalMsg);
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
        addafter(Category_Category6)
        {
            group(InterfaceTOPDAPromote)
            {
                Caption = 'API Management';
                actionref(InterfaceToPDA_Promoted; InterfaceToPDA)
                {
                }
                actionref(ClearInterface_Promoted; ClearInterface)
                {
                }
                actionref(LogInterfaceToPDA_Promoted; LogInterfaceToPDA)
                {
                }
            }
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
