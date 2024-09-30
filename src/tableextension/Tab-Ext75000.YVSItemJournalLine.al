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
        field(75002; "YVS Ship-to Name"; Text[200])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
        }
        field(75003; "YVS Ship-to Address"; Text[255])
        {
            Caption = 'Ship-to Address';
            DataClassification = CustomerContent;
        }
        field(75004; "YVS Ship-to District"; Text[50])
        {
            Caption = 'Ship-to District';
            DataClassification = CustomerContent;
        }
        field(75005; "YVS Ship-to Post Code"; Text[20])
        {
            Caption = 'Ship-to Post Code';
            DataClassification = CustomerContent;
        }
        field(75006; "YVS Ship-to Mobile No."; Text[50])
        {
            Caption = 'Ship-to Mobile No.';
            DataClassification = CustomerContent;
        }
        field(75007; "YVS Ship-to Phone No."; Text[20])
        {
            Caption = 'Ship-to Phone No.';
            DataClassification = CustomerContent;
        }
        field(75008; "YVS Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
        }
        field(75009; "YVS Shipping Agent"; code[10])
        {
            TableRelation = "Shipping Agent".Code;
            DataClassification = CustomerContent;
            Caption = 'Shipping Agent';
        }
        field(75010; "YVS Direction"; enum "YVS Direction")
        {
            Caption = 'Direction';
            DataClassification = CustomerContent;
        }
        field(75011; "YVS Interface Completed"; Boolean)
        {
            Caption = 'Interface Completed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75012; "YVS Send DateTime"; DateTime)
        {
            Caption = 'Send Date Time';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(75013; "YVS Interface"; Boolean)
        {
            Caption = 'Interface';
            DataClassification = CustomerContent;
        }
        field(75014; "YVS Search Description"; Text[100])
        {
            Caption = 'Search Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Search Description" where("No." = field("Item No.")));
        }
        field(75015; "YVS Description TH"; Text[100])
        {
            Caption = 'Description TH';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."YVS Description TH" where("No." = field("Item No.")));
        }
        field(75016; "YVS Original Quantity"; Decimal)
        {
            Caption = 'Original Quantity';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                rec.Validate(Quantity, rec."YVS Original Quantity");
            end;
        }
        field(75017; "YVS Address"; Text[250])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(75018; "YVS BC_Entry_Ref"; Integer)
        {
            Caption = 'BC_Entry_Ref';
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


    /// <summary>
    /// IsItemItemJournalEnabled.
    /// </summary>
    /// <param name="ItemJournalLine">VAR Record "Item Journal Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsItemItemJournalEnabled(var ItemJournalLine: Record "Item Journal Line"): Boolean
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

    /// <summary>
    /// TestFieldAPI.
    /// </summary>
    procedure TestFieldAPI()
    begin
        rec.TestField("Posting Date");
        rec.TestField("Document No.");
        rec.TestField("Item No.");
        rec.TestField("Unit of Measure Code");
        rec.TestField(Quantity);
        rec.TestField("Location Code");
        rec.TestField("YVS Interface Completed", false);
    end;

    var
        Text002Msg: Label 'This document can only be released when the approval process is complete.';
        Text003Msg: Label 'The approval process must be cancelled or completed to reopen this document.';

}
