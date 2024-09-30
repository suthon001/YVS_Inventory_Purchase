/// <summary>
/// PageExtension YVS Transfer Order (ID 75010) extends Record Transfer Order.
/// </summary>
pageextension 75010 "YVS Transfer Order" extends "Transfer Order"
{
    layout
    {
        addlast(General)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("YVS Direction"; rec."YVS Direction")
            {
                ToolTip = 'Specifies the value of the Direction field.';
                ApplicationArea = all;
            }
            field("YVS Interface"; rec."YVS Interface")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Interface field.';
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
        addafter(TransferLines)
        {
            group(ShipToInformation)
            {
                Caption = 'Ship-to';
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
            }
        }
    }
    actions
    {
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
                    TransferLine: Record "Transfer Line";
                    YVSInterfaceLogEntry: Record "YVS Interface Log Entry";
                    YVSFunc: Codeunit "YVS Api Func";
                begin
                    rec.TestField("Transfer-to Code");
                    rec.TestField("Transfer-from Code");
                    TransferLine.reset();
                    TransferLine.SetRange("Document No.", rec."No.");
                    if TransferLine.FindSet() then
                        repeat
                            TransferLine.TestFieldAPI();
                        until TransferLine.Next() = 0
                    else
                        Error('Nothing to Send');

                    YVSFunc.InterfaceTransferToPDA(rec);
                    YVSInterfaceLogEntry.reset();
                    YVSInterfaceLogEntry.SetRange("Action Page", YVSInterfaceLogEntry."Action Page"::Transfer);
                    YVSInterfaceLogEntry.SetRange("Primary Key 1", rec."No.");
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
                begin
                    rec."YVS Interface Completed" := false;
                    rec."YVS Send DateTime" := 0DT;
                    rec.Modify();
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
                    YVSInterfaceLogEntry.SetRange("Action Page", YVSInterfaceLogEntry."Action Page"::Transfer);
                    YVSInterfaceLogEntry.SetRange("Primary Key 1", rec."No.");
                    page.Run(0, YVSInterfaceLogEntry);
                end;
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
    }
}


