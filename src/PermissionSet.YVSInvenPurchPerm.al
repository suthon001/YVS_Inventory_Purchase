/// <summary>
/// Unknown YVS_Inven_Purch_Perm (ID 75000).
/// </summary>
permissionset 75000 YVS_Inven_Purch_Perm
{
    Assignable = true;
    Caption = 'YVS_Inven_Purch_Perm', MaxLength = 30;
    Permissions =
        table "YVS Tracking Speci. Buffer" = X,
        tabledata "YVS Tracking Speci. Buffer" = RMID,
        codeunit "YVS Inven & Purchase Func" = X,
        page "YVS API Transfer Order" = X,
        page "YVS API Tracking Specification" = X,
        page "YVS API Transfer Order Subform" = X;
}
