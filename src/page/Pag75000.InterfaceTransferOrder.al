/// <summary>
/// Page Interface Transfer Order (ID 75000).
/// </summary>
page 75000 "YVS Interface Transfer Order"
{
    APIGroup = 'bc';
    APIPublisher = 'interface';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'interface Transfer Order';
    DelayedInsert = true;
    EntityName = 'transferOrder';
    EntitySetName = 'transferOrders';
    PageType = API;
    SourceTable = "YVS Trans. Transfer Buffer";
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            Group(General)
            {
                field(documentNo; rec."Document No.")
                {
                    Caption = 'Document No.';
                    trigger OnValidate()
                    begin
                        if rec."Document No." <> '' then
                            gvJsonObject.Add('documentNo', rec."Document No.");
                    end;
                }
                field(lineNo; rec."Line No.")
                {
                    Caption = 'Line No.';
                    trigger OnValidate()
                    begin
                        if rec."Line No." <> 0 then
                            gvJsonObject.Add('lineNo', rec."Line No.");
                    end;
                }
                field(itemNo; rec."Item No.")
                {
                    Caption = 'Item No.';
                    trigger OnValidate()
                    begin
                        if rec."Item No." <> '' then
                            gvJsonObject.Add('itemNo', rec."Item No.");
                    end;
                }
                field(quantityUpdate; rec.Quantity)
                {
                    Caption = 'Quantity';
                    trigger OnValidate()
                    begin
                        if rec.Quantity <> 0 then
                            gvJsonObject.Add('quantityUpdate', rec.Quantity);
                    end;
                }
                field(bcEntryRef; bcEntryRef)
                {
                    Caption = 'BC Entry Ref';

                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        EnvironmentInformation: Codeunit "Environment Information";
        InboundTransferOrder: Text;
        APIfunc: Codeunit "YVS Api Func";
        ISSuccess: Boolean;
        ltActionPage: Enum "YVS Interface Document Type";
        ltDicBatch: Dictionary of [code[20], List of [Integer]];
        ltDirection: Option "Inbound","Outbound";
        ltMethodType: Option " ","Insert","Update","Delete";
        JsonText: Text;
        ltListOfInteger: List of [Integer];

    begin
        if EnvironmentInformation.IsProduction() then
            InboundTransferOrder := 'https://api.businesscentral.dynamics.com/v2.0/4ef4cef4-feda-4adf-a799-109703e11237/production/api/interface/bc/v1.0/transferOrders?company=''' + CompanyName() + ''
        else
            InboundTransferOrder := 'https://api.businesscentral.dynamics.com/v2.0/4ef4cef4-feda-4adf-a799-109703e11237/' + EnvironmentInformation.GetEnvironmentName() + '/api/interface/bc/v1.0/transferOrders?company=''' + CompanyName() + '''';
        gvJsonObject.WriteTo(JsonText);
        ISSuccess := APIfunc.UpdateToTransferOrder(JsonText);
        ltListOfInteger.Add(rec."Line No.");
        ltDicBatch.Add(rec."Document No.", ltListOfInteger);
        if ISSuccess then
            APIfunc.InsertToInterfaceLog(0, ltActionPage::"Transfer Line", '', ltDicBatch, JsonText, ltDirection::Inbound, '', COPYSTR(InboundTransferOrder, 1, 250), ltMethodType::Update, rec."Document No.", bcEntryRef)
        else begin
            APIfunc.InsertToInterfaceLog(1, ltActionPage::"Transfer Line", '', ltDicBatch, JsonText, ltDirection::Inbound, GetLastErrorText(), COPYSTR(InboundTransferOrder, 1, 250), ltMethodType::Update, rec."Document No.", bcEntryRef);
            Commit();
            ERROR(GetLastErrorText());
        end;

    end;


    trigger OnOpenPage()
    begin
        Clear(gvJsonObject);
    end;

    var


        bcEntryRef: Integer;
        gvJsonObject: JsonObject;
}
