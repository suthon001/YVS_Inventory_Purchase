/// <summary>
/// Table YVS Interface Log Entry (ID 70000).
/// </summary>
table 75001 "YVS Interface Log Entry"
{
    Caption = 'Interface Log Entry';
    DataClassification = CustomerContent;
    LookupPageId = "YVS Interface Log Entries";
    DrillDownPageId = "YVS Interface Log Entries";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Method Type"; Option)
        {
            Caption = 'Method Type';
            OptionMembers = " ","Insert","Update","Delete";
            OptionCaption = ' ,Insert,Update,Delete';
            Editable = false;
        }
        field(3; "Action Page"; Enum "YVS Interface Document Type")
        {
            Caption = 'Action Page';
        }
        field(4; "Direction"; Option)
        {
            Caption = 'Direction';
            OptionMembers = "Inbound","Outbound";
            OptionCaption = 'Inbound,Outbound';
        }
        field(6; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = "Success","Failed";
            OptionCaption = 'Success,Failed';
        }
        field(7; "Json Log"; Blob)
        {
            Caption = 'Json Format';
        }
        field(8; "Response Log"; Blob)
        {
            Caption = 'Response Log';
        }
        field(9; "Interface Path"; text[250])
        {
            Caption = 'Interface Path';
        }
        field(10; "Primary Key Caption"; text[250])
        {
            Caption = 'Primary Key Caption';
        }
        field(11; "Primary Key 1"; text[100])
        {
            Caption = 'Primary Key 1';
        }
        field(12; "Primary Key 2"; text[100])
        {
            Caption = 'Primary Key 2';
        }
        field(13; "Primary Key 3"; text[100])
        {
            Caption = 'Primary Key 3';
        }
        field(14; "Document No."; code[20])
        {
            Caption = 'Document No.';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    /// <summary>
    /// GetLastTransactionID.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastTransactionID(): Integer
    var
        ltInterfaceLog: Record "YVS Interface Log Entry";
    begin
        ltInterfaceLog.reset();
        ltInterfaceLog.SetCurrentKey("Entry No.");
        ltInterfaceLog.ReadIsolation := IsolationLevel::ReadCommitted;
        if ltInterfaceLog.FindLast() then
            exit(ltInterfaceLog."Entry No." + 1);
        exit(1);
    end;

    /// <summary>
    /// GetJsonLog.
    /// </summary>
    /// <returns>Return variable JsonLog of type Text.</returns>
    procedure GetJsonLog() JsonLog: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Json Log");
        "Json Log".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Json Log")));
    end;

    /// <summary>
    /// GetResponseLog.
    /// </summary>
    /// <returns>Return variable ResponseLog of type Text.</returns>
    procedure GetResponseLog() ResponseLog: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Response Log");
        "Response Log".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Response Log")));
    end;
}
