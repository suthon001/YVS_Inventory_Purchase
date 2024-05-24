/// <summary>
/// PageExtension YVS Permission Sets (ID 75001) extends Record Permission Sets.
/// </summary>
pageextension 75001 "YVS Permission Sets" extends "Permission Sets"
{
    layout
    {
        addlast(Group)
        {
            field("Cost Invisible"; Rec."Cost Invisible")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Cost Invisible field.';
            }
            field("Item Invisible"; Rec."Item Invisible")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the ITem Invisible field.';
            }
        }
    }
    trigger OnOpenPage()
    var
        TenantPermissionSet: Record "Tenant Permission Set";
        PermissionPagesMgt: Codeunit "Permission Pages Mgt.";
        ZeroGUID: Guid;
    begin
        TenantPermissionSet.reset();
        TenantPermissionSet.SetRange("Role ID", 'COSTINVISIBLE');
        if TenantPermissionSet.IsEmpty() then begin
            PermissionPagesMgt.DisallowEditingPermissionSetsForNonAdminUsers();
            PermissionPagesMgt.VerifyPermissionSetRoleID('COSTINVISIBLE');
            TenantPermissionSet.Init();
            TenantPermissionSet."App ID" := ZeroGUID;
            TenantPermissionSet."Role ID" := 'COSTINVISIBLE';
            TenantPermissionSet.Name := 'Cost Invisible';
            TenantPermissionSet.Insert();
        end;
        TenantPermissionSet.reset();
        TenantPermissionSet.SetRange("Role ID", 'ITEMINVISIBLE');
        if TenantPermissionSet.IsEmpty() then begin
            PermissionPagesMgt.DisallowEditingPermissionSetsForNonAdminUsers();
            PermissionPagesMgt.VerifyPermissionSetRoleID('ITEMINVISIBLE');
            TenantPermissionSet.Init();
            TenantPermissionSet."App ID" := ZeroGUID;
            TenantPermissionSet."Role ID" := 'ITEMINVISIBLE';
            TenantPermissionSet.Name := 'Item Invisible';
            TenantPermissionSet.Insert();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        rec."Cost Invisible" := rec."Role ID" = 'COSTINVISIBLE';
        rec."Item Invisible" := rec."Role ID" = 'ITEMINVISIBLE'
    end;
}
