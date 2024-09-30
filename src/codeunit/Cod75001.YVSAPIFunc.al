/// <summary>
/// Codeunit YVS Api Func (ID 75001).
/// </summary>
codeunit 75001 "YVS Api Func"
{

    /// <summary>
    /// JobQueueItemJournal.
    /// </summary>
    procedure JobQueueItemJournal()
    var
        ltITemJournalTemplate: Record "Item Journal Template";
        ltITemJournalLine: Record "Item Journal Line";
    begin
        ltITemJournalTemplate.reset();
        ltITemJournalTemplate.SetRange("YVS Interface", true);
        if ltITemJournalTemplate.FindSet() then
            repeat
                ltITemJournalLine.reset();
                ltITemJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
                ltITemJournalLine.SetRange("Journal Template Name", ltITemJournalTemplate.Name);
                ltITemJournalLine.SetRange("YVS Interface", false);
                ltITemJournalLine.SetFilter("Item No.", '<>%1', '');
                ltITemJournalLine.SetFilter("Quantity", '<>%1', 0);
                ltITemJournalLine.SetFilter("Location Code", '<>%1', '');
                ltITemJournalLine.SetRange("YVS Approve Status", ltITemJournalLine."YVS Approve Status"::Released);
                if ltITemJournalLine.FindSet() then
                    repeat
                        InterfaceItemJournalToPDA(ltITemJournalLine);
                    until ltITemJournalLine.Next() = 0;
            until ltITemJournalTemplate.Next() = 0;
    end;


    /// <summary>
    /// JobQueueTransferOrder.
    /// </summary>
    procedure JobQueueTransferOrder()
    var
        TransferOrder: Record "Transfer Header";
    begin
        TransferOrder.reset();
        TransferOrder.SetRange("YVS Interface", true);
        TransferOrder.SetRange("YVS Interface Completed", false);
        TransferOrder.SetFilter("Transfer-from Code", '<>%1', '');
        TransferOrder.SetFilter("Transfer-to Code", '<>%1', '');
        if TransferOrder.FindSet() then
            repeat
                if TransferOrder.TransferLinesExist() then
                    InterfaceTransferToPDA(TransferOrder);
            until TransferOrder.Next() = 0;
    end;

    /// <summary>
    /// InterfaceItemJournalToPDA.
    /// </summary>
    /// <param name="ItemJournal">Record "Item Journal Line".</param>
    procedure InterfaceItemJournalToPDA(ItemJournal: Record "Item Journal Line")
    var
        ltItem: Record Item;
        ltJsonObject: JsonObject;
        Result: Text;
        ltDocumentType: Enum "YVS Interface Document Type";
        DicBatch: Dictionary of [code[20], List of [Integer]];
        ListOfInteger: List of [Integer];
        ltDirection: Option "Inbound","Outbound";
    begin
        CLEAR(ltJsonObject);
        ltItem.GET(ItemJournal."Item No.");
        ltJsonObject.Add('templateName', itemJournal."Journal Template Name");
        ltJsonObject.Add('batchName', itemJournal."Journal Batch Name");
        ltJsonObject.Add('postingDate', itemJournal."Posting Date");
        ltJsonObject.Add('entryType', format(itemJournal."Entry Type"));
        ltJsonObject.Add('lineNo', itemJournal."Line No.");
        ltJsonObject.Add('documentNo', itemJournal."Document No.");
        ltJsonObject.Add('itemNo', itemJournal."Item No.");
        ltJsonObject.Add('description', itemJournal.Description);
        ltJsonObject.Add('descriptionTh', ltItem."YVS Description TH");
        ltJsonObject.Add('searchDescription', ltItem."Search Description");
        ltJsonObject.Add('address', itemJournal."YVS Address");
        ltJsonObject.Add('quantity', itemJournal.Quantity);
        ltJsonObject.Add('uom', itemJournal."Unit of Measure Code");
        ltJsonObject.Add('locationCode', itemJournal."Location Code");
        ltJsonObject.Add('shiptoName', itemJournal."YVS Ship-to Name");
        ltJsonObject.Add('shiptoAddress', itemJournal."YVS Ship-to Address");
        ltJsonObject.Add('shiptoDistrict', itemJournal."YVS Ship-to District");
        ltJsonObject.Add('shiptoPostcode', itemJournal."YVS Ship-to Post Code");
        ltJsonObject.Add('shiptoMobileno', itemJournal."YVS Ship-to Mobile No.");
        ltJsonObject.Add('shiptoPhoneno', itemJournal."YVS Ship-to Phone No.");
        ltJsonObject.Add('shipmentDate', itemJournal."YVS Shipment Date");
        ltJsonObject.Add('shippingAgent', itemJournal."YVS Shipping Agent");
        ListOfInteger.Add(itemJournal."Line No.");
        DicBatch.Add(itemJournal."Journal Batch Name", ListOfInteger);
        ltJsonObject.WriteTo(Result);
        CallWebService(ltDocumentType::"Item Journal", Result, ItemJournal."Journal Template Name", DicBatch, ltDirection::Outbound);
    end;

    /// <summary>
    /// InterfaceTransferToPDA.
    /// </summary>
    /// <param name="pTranferOrder">Record "Transfer Header".</param>
    procedure InterfaceTransferToPDA(pTranferOrder: Record "Transfer Header")
    var
        ltTransferLine: Record "Transfer Line";
        ltITem: Record Item;
        ltJsonObject, ltJsonObjectLine : JsonObject;
        ltJsonArray: JsonArray;
        Result: Text;
        ltDocumentType: Enum "YVS Interface Document Type";
        DicBatch: Dictionary of [code[20], List of [Integer]];
        ListOfInteger: List of [Integer];
        ltDirection: Option "Inbound","Outbound";
    begin
        ltJsonObject.Add('no', pTranferOrder."No.");
        ltJsonObject.Add('transferfromCode', pTranferOrder."Transfer-from Code");
        ltJsonObject.Add('transfertoCode', pTranferOrder."Transfer-to Code");
        ltJsonObject.Add('retailerNo', '');
        ltJsonObject.Add('retailerName', '');
        ltJsonObject.Add('storeLocation', '');
        ltJsonObject.Add('storeLocationName', '');
        ltJsonObject.Add('shiptoName', pTranferOrder."YVS Ship-to Name");
        ltJsonObject.Add('shiptoAddress', pTranferOrder."YVS Ship-to Address");
        ltJsonObject.Add('shiptoDistrict', pTranferOrder."YVS Ship-to District");
        ltJsonObject.Add('shiptoPostcode', pTranferOrder."YVS Ship-to Post Code");
        ltJsonObject.Add('shiptoMobileNo', pTranferOrder."YVS Ship-to Mobile No.");
        ltJsonObject.Add('shiptoPhoneNo', pTranferOrder."YVS Ship-to Phone No.");
        ltJsonObject.Add('storeContact', '');
        ltJsonObject.Add('orderNo', pTranferOrder."External Document No.");
        ltJsonObject.Add('documentDate', pTranferOrder."Posting Date");
        ltJsonObject.Add('shipmentDate', pTranferOrder."Shipment Date");
        ltJsonObject.Add('shippingAgent', pTranferOrder."Shipping Agent Code");
        ltJsonObject.Add('direction', format(pTranferOrder."YVS Direction"));
        ltTransferLine.reset();
        ltTransferLine.SetRange("Document No.", pTranferOrder."No.");
        ltTransferLine.SetRange("Derived From Line No.", 0);
        if ltTransferLine.FindSet() then
            repeat
                CLEAR(ltJsonObjectLine);
                ltITem.GET(ltTransferLine."Item No.");
                ltJsonObjectLine.Add('lineno', ltTransferLine."Line No.");
                ltJsonObjectLine.Add('documentNo', ltTransferLine."Document No.");
                ltJsonObjectLine.Add('itemNo', ltTransferLine."Item No.");
                ltJsonObjectLine.Add('description', ltTransferLine.Description);
                ltJsonObjectLine.Add('descriptionTH', ltITem."YVS Description TH");
                ltJsonObjectLine.Add('searchDescription', ltITem."Search Description");
                ltJsonObjectLine.Add('quantity', ltTransferLine.Quantity);
                ltJsonObjectLine.Add('uOM', ltTransferLine."Unit of Measure Code");
                ltJsonArray.Add(ltJsonObjectLine);
            until ltTransferLine.Next() = 0;
        ltJsonObject.Add('transferlines', ltJsonArray);
        ltJsonObject.WriteTo(Result);
        ListOfInteger.Add(10000);
        DicBatch.Add(pTranferOrder."No.", ListOfInteger);
        CallWebService(ltDocumentType::Transfer, Result, '', DicBatch, ltDirection::Outbound);
    end;

    local procedure CallWebService(pActionPage: Enum "YVS Interface Document Type"; pPayload: Text; pJournalTemplate: code[10]; pDicBatch: Dictionary of [code[20], List of [Integer]]; pDirection: Option "Inbound","Outbound")
    var
        ltInventorySetup: Record "Inventory Setup";
        JsonMgt: Codeunit "JSON Management";
        gvHttpHeadersContent, contentHeaders : HttpHeaders;
        gvHttpResponseMessage: HttpResponseMessage;
        gvHttpClient: HttpClient;
        gvHttpContent: HttpContent;
        ResponseText: Text;
        ltBearer: Text;
        Url: text[250];
        ltMethodType: Option " ","Insert","Update","Delete";
    begin
        ltInventorySetup.GET();
        if pActionPage = pActionPage::Transfer then begin
            ltInventorySetup.TestField("YVS To PDA URL (Transfer)");
            Url := ltInventorySetup."YVS To PDA URL (Transfer)";
        end else begin
            ltInventorySetup.TestField("YVS To PDA URL (Item Journal)");
            Url := ltInventorySetup."YVS To PDA URL (Item Journal)";
        end;
        gvHttpHeadersContent := gvHttpClient.DefaultRequestHeaders();
        gvHttpContent.WriteFrom(pPayload);
        gvHttpContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Authorization', 'Bearer ' + ltBearer);
        gvHttpClient.Post(Url, gvHttpContent, gvHttpResponseMessage);
        gvHttpResponseMessage.Content.ReadAs(ResponseText);
        JsonMgt.InitializeObject(ResponseText);
        if (gvHttpResponseMessage.IsSuccessStatusCode()) and (gvHttpResponseMessage.HttpStatusCode() = 200) then
            InsertToInterfaceLog(0, pActionPage, pJournalTemplate, pDicBatch, pPayload, pDirection, ResponseText, Url, ltMethodType::Insert)
        else
            InsertToInterfaceLog(1, pActionPage, pJournalTemplate, pDicBatch, pPayload, pDirection, ResponseText, Url, ltMethodType::" ");

    end;

    local procedure InsertToInterfaceLog(pStatus: Option "Success","Failed"; pActionPage: Enum "YVS Interface Document Type"; pJournalTemplate: code[10]; pDicBatch: Dictionary of [code[20], List of [Integer]];
                                                                                                pPayload: Text; pDirection: Option "Inbound","Outbound"; pResponse: Text; pInterfacePath: Text[250]; pMethodType: Option " ","Insert","Update","Delete")
    var
        InterfaceLogEntry: Record "YVS Interface Log Entry";
        ltTransferHeader: Record "Transfer Header";
        ltITemJournalLine: Record "Item Journal Line";
        ltOutStram, ltOutStramResponse : OutStream;
        DocNo: Code[20];
        ltLineLists: List of [Integer];
        LtLineNo: Integer;
    begin
        foreach DocNo in pDicBatch.Keys() do begin
            pDicBatch.Get(DocNo, ltLineLists);
            foreach LtLineNo in ltLineLists do begin
                InterfaceLogEntry.Init();
                InterfaceLogEntry."Entry No." := InterfaceLogEntry.GetLastTransactionID();
                InterfaceLogEntry."Action Page" := pActionPage;
                InterfaceLogEntry."Interface Path" := pInterfacePath;
                InterfaceLogEntry.Status := pStatus;
                InterfaceLogEntry.Direction := pDirection;
                InterfaceLogEntry."Method Type" := pMethodType;
                InterfaceLogEntry.Insert();
                if pActionPage = pActionPage::"Item Journal" then begin
                    ltITemJournalLine.GET(pJournalTemplate, DocNo, LtLineNo);
                    InterfaceLogEntry."Primary Key Caption" := COPYSTR(ltITemJournalLine.FieldCaption("Journal Template Name") + ',' + ltITemJournalLine.FieldCaption("Journal Batch Name") + ',' + ltITemJournalLine.FieldCaption("Line No."), 1, 250);
                    InterfaceLogEntry."Primary Key 1" := pJournalTemplate;
                    InterfaceLogEntry."Primary Key 2" := DocNo;
                    InterfaceLogEntry."Primary Key 3" := format(LtLineNo);
                    InterfaceLogEntry."Document No." := ltITemJournalLine."Document No.";
                    if pStatus = pStatus::Success then
                        ltITemJournalLine."YVS Interface Completed" := true;
                    ltITemJournalLine."YVS BC_Entry_Ref" := InterfaceLogEntry."Entry No.";
                    ltITemJournalLine."YVS Send DateTime" := CurrentDateTime();
                    ltITemJournalLine.Modify();
                end else begin
                    InterfaceLogEntry."Primary Key Caption" := COPYSTR(ltTransferHeader.FieldCaption("No."), 1, 250);
                    ltTransferHeader.GET(DocNo);
                    InterfaceLogEntry."Primary Key 1" := ltTransferHeader."No.";
                    InterfaceLogEntry."Document No." := ltTransferHeader."No.";

                    if pStatus = pStatus::Success then
                        ltTransferHeader."YVS Interface Completed" := true;
                    ltTransferHeader."YVS Send DateTime" := CurrentDateTime();
                    ltTransferHeader."YVS BC_Entry_Ref" := InterfaceLogEntry."Entry No.";
                    ltTransferHeader.Modify();
                end;
                CLEAR(InterfaceLogEntry."Json Log");
                Clear(InterfaceLogEntry."Response Log");
                InterfaceLogEntry."Json Log".CreateOutStream(ltOutStram, TextEncoding::UTF8);
                ltOutStram.WriteText(pPayload);
                InterfaceLogEntry."Response Log".CreateOutStream(ltOutStramResponse, TextEncoding::UTF8);
                ltOutStramResponse.WriteText(pResponse);
                InterfaceLogEntry.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeaderReceipt(TransferHeader: Record "Transfer Header"; var TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        TransferReceiptHeader."YVS Direction" := TransferHeader."YVS Direction";
        TransferReceiptHeader."YVS Ship-to Address" := TransferHeader."YVS Ship-to Address";
        TransferReceiptHeader."YVS Ship-to District" := TransferHeader."YVS Ship-to District";
        TransferReceiptHeader."YVS Ship-to Mobile No." := TransferHeader."YVS Ship-to Mobile No.";
        TransferReceiptHeader."YVS Ship-to Name" := TransferHeader."YVS Ship-to Name";
        TransferReceiptHeader."YVS Ship-to Phone No." := TransferHeader."YVS Ship-to Phone No.";
        TransferReceiptHeader."YVS Ship-to Post Code" := TransferHeader."YVS Ship-to Post Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeaderShipment(TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        TransferShipmentHeader."YVS Direction" := TransferHeader."YVS Direction";
        TransferShipmentHeader."YVS Ship-to Address" := TransferHeader."YVS Ship-to Address";
        TransferShipmentHeader."YVS Ship-to District" := TransferHeader."YVS Ship-to District";
        TransferShipmentHeader."YVS Ship-to Mobile No." := TransferHeader."YVS Ship-to Mobile No.";
        TransferShipmentHeader."YVS Ship-to Name" := TransferHeader."YVS Ship-to Name";
        TransferShipmentHeader."YVS Ship-to Phone No." := TransferHeader."YVS Ship-to Phone No.";
        TransferShipmentHeader."YVS Ship-to Post Code" := TransferHeader."YVS Ship-to Post Code";
        TransferShipmentHeader."YVS BC_Entry_Ref" := TransferHeader."YVS BC_Entry_Ref";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnAfterCreateItemJnlLineTransferShipment(TransferShipmentHeader: Record "Transfer Shipment Header"; var ItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine."YVS Direction" := TransferShipmentHeader."YVS Direction";
        ItemJournalLine."YVS Ship-to Address" := TransferShipmentHeader."YVS Ship-to Address";
        ItemJournalLine."YVS Ship-to District" := TransferShipmentHeader."YVS Ship-to District";
        ItemJournalLine."YVS Ship-to Mobile No." := TransferShipmentHeader."YVS Ship-to Mobile No.";
        ItemJournalLine."YVS Ship-to Name" := TransferShipmentHeader."YVS Ship-to Name";
        ItemJournalLine."YVS Ship-to Phone No." := TransferShipmentHeader."YVS Ship-to Phone No.";
        ItemJournalLine."YVS Ship-to Post Code" := TransferShipmentHeader."YVS Ship-to Post Code";
        ItemJournalLine."YVS BC_Entry_Ref" := TransferShipmentHeader."YVS BC_Entry_Ref";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure OnBeforePostItemJournalLineRecript(var ItemJournalLine: Record "Item Journal Line"; TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        ItemJournalLine."YVS Direction" := TransferReceiptHeader."YVS Direction";
        ItemJournalLine."YVS Ship-to Address" := TransferReceiptHeader."YVS Ship-to Address";
        ItemJournalLine."YVS Ship-to District" := TransferReceiptHeader."YVS Ship-to District";
        ItemJournalLine."YVS Ship-to Mobile No." := TransferReceiptHeader."YVS Ship-to Mobile No.";
        ItemJournalLine."YVS Ship-to Name" := TransferReceiptHeader."YVS Ship-to Name";
        ItemJournalLine."YVS Ship-to Phone No." := TransferReceiptHeader."YVS Ship-to Phone No.";
        ItemJournalLine."YVS Ship-to Post Code" := TransferReceiptHeader."YVS Ship-to Post Code";
        ItemJournalLine."YVS BC_Entry_Ref" := TransferReceiptHeader."YVS BC_Entry_Ref";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var ItemJournalLine: Record "Item Journal Line"; var NewItemLedgEntry: Record "Item Ledger Entry")
    begin
        NewItemLedgEntry."YVS Direction" := ItemJournalLine."YVS Direction";
        NewItemLedgEntry."YVS Ship-to Address" := ItemJournalLine."YVS Ship-to Address";
        NewItemLedgEntry."YVS Ship-to District" := ItemJournalLine."YVS Ship-to District";
        NewItemLedgEntry."YVS Ship-to Mobile No." := ItemJournalLine."YVS Ship-to Mobile No.";
        NewItemLedgEntry."YVS Ship-to Name" := ItemJournalLine."YVS Ship-to Name";
        NewItemLedgEntry."YVS Ship-to Phone No." := ItemJournalLine."YVS Ship-to Phone No.";
        NewItemLedgEntry."YVS Ship-to Post Code" := ItemJournalLine."YVS Ship-to Post Code";
        NewItemLedgEntry."YVS Shipment Date" := ItemJournalLine."YVS Shipment Date";
        NewItemLedgEntry."YVS Shipping Agent" := ItemJournalLine."YVS Shipping Agent";
        NewItemLedgEntry."YVS Address" := ItemJournalLine."YVS Address";
        NewItemLedgEntry."YVS Original Quantity" := ItemJournalLine."YVS Original Quantity";
        NewItemLedgEntry."YVS BC_Entry_Ref" := ItemJournalLine."YVS BC_Entry_Ref";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeUpdateDeleteLines', '', true, true)]
    local procedure "InsertPostedItemJournalLines"(var ItemJournalLine: Record "Item Journal Line")
    var
        PostedItemJournalLines: Record "YVS Posted Item Journal Line";
        ItemJnlLine2: Record "Item Journal Line";
    begin
        ItemJnlLine2.COPYFILTERS(ItemJournalLine);
        ItemJnlLine2.FINDSET();
        REPEAT
            PostedItemJournalLines.INIT();
            PostedItemJournalLines.TRANSFERFIELDS(ItemJnlLine2);
            PostedItemJournalLines."Entry No." := PostedItemJournalLines."LastPostedEntryNo"();
            PostedItemJournalLines.INSERT(true);
        until ItemJnlLine2.next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterSetupNewLine', '', True, true)]
    local procedure "AfterSetupNewLine"(var ItemJournalLine: Record "Item Journal Line"; var LastItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine."YVS Interface" := LastItemJournalLine."YVS Interface";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'BeforInsertDocumentAssignEdit', '', false, false)]
    local procedure BeforInsertDocumentAssignEdit(var pItemJournalLine: Record "Item Journal Line")
    var
        ltNoSeries: Record "No. Series";
    begin
        if ltNoSeries.GET(pItemJournalLine."YVS Document No. Series") then
            pItemJournalLine."YVS Interface" := ltNoSeries."YVS Interface";
    end;
}
