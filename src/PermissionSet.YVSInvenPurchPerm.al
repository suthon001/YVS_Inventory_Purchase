/// <summary>
/// Unknown YVS_Inven_Purch_Perm (ID 75000).
/// </summary>
permissionset 75000 YVS_Inven_Purch_Perm
{
    Assignable = true;
    Caption = 'YVS_Inven_Purch_Perm', MaxLength = 30;
    Permissions =
        table "YVS Interface Log Entry" = X,
        tabledata "YVS Interface Log Entry" = RMID,
        table "YVS Posted Item Journal Line" = X,
        tabledata "YVS Posted Item Journal Line" = RMID,
        page "YVS Interface Transfer Order" = X,
        page "YVS Posted Item Journal Lines" = X,
        page "YVS Interface Log Entries" = X,
        page "YVS Interface Log Card" = X,
        page "Interface Item Journal" = X,
        report "MRC Inventory Movement" = X,
        codeunit "YVS Inven & Purchase Func" = X,
        codeunit "YVS Api Func" = X;
}
