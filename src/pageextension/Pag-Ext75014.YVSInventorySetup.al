/// <summary>
/// PageExtension YVS Inventory Setup (ID 75014) extends Record Inventory Setup.
/// </summary>
pageextension 75014 "YVS Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        addafter(General)
        {
            group(YVSInterface)
            {
                Caption = 'Interface To PDA';
                field(InboundTransferOrder; InboundTransferOrder)
                {
                    Caption = 'URL Inbound Transfer Order';
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the URL Inbound Transfer Order field.';
                }
                field(InboundItemJournal; InboundItemJournal)
                {
                    Caption = 'URL Inbound Item Journal';
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the URL Inbound Item Journal field.';
                }
                field("YVS To PDA URL (Trans) Orders"; Rec."YVS To PDA URL (Trans) Orders")
                {
                    Caption = 'URL Outbound Transfer Order';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface To PDA URL (Transfer) field.';
                }
                field("YVS To PDA URL (Trans) Advice"; Rec."YVS To PDA URL (Trans) Advice")
                {
                    Caption = 'URL Outbound Transfer Advice';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface To PDA URL (Transfer) field.';
                }
                field("YVS To PDA URL (Item Journal)"; Rec."YVS To PDA URL (Item Journal)")
                {
                    Caption = 'URL Outbound Item Journal';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Interface To PDA URL (Item Journal) field.';
                }
                field("YVS PDA Token"; Rec."YVS PDA Token")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PDA Token field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        if EnvironmentInformation.IsProduction() then begin
            InboundItemJournal := 'https://api.businesscentral.dynamics.com/v2.0/4ef4cef4-feda-4adf-a799-109703e11237/production/api/interface/bc/v1.0/itemjournals?company=''' + CompanyName() + '';
            InboundTransferOrder := 'https://api.businesscentral.dynamics.com/v2.0/4ef4cef4-feda-4adf-a799-109703e11237/production/api/interface/bc/v1.0/transferOrders?company=''' + CompanyName() + '';
        end else begin
            InboundItemJournal := 'https://api.businesscentral.dynamics.com/v2.0/4ef4cef4-feda-4adf-a799-109703e11237/' + EnvironmentInformation.GetEnvironmentName() + '/api/interface/bc/v1.0/itemjournals?company=''' + CompanyName() + '''';
            InboundTransferOrder := 'https://api.businesscentral.dynamics.com/v2.0/4ef4cef4-feda-4adf-a799-109703e11237/' + EnvironmentInformation.GetEnvironmentName() + '/api/interface/bc/v1.0/transferOrders?company=''' + CompanyName() + '''';
        end;
    end;

    var
        InboundTransferOrder, InboundItemJournal : Text;
}


