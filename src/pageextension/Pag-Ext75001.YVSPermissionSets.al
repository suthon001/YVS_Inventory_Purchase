/// <summary>
/// PageExtension YVS Permission Sets (ID 75001) extends Record Permission Sets.
/// </summary>
pageextension 75001 "YVS Permission Sets" extends "Permission Sets"
{
    trigger OnOpenPage()
    var
        TenantPermissionSet: Record "Tenant Permission Set";
        TenantPermission: record "Tenant Permission";
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

            TenantPermission.Init();
            TenantPermission."App ID" := TenantPermissionSet."App ID";
            TenantPermission."Role ID" := TenantPermissionSet."Role ID";
            TenantPermission."Object Type" := TenantPermission."Object Type"::System;
            TenantPermission."Object ID" := 1350;
            TenantPermission."Read Permission" := TenantPermission."Read Permission"::" ";
            TenantPermission."Insert Permission" := TenantPermission."Insert Permission"::" ";
            TenantPermission."Modify Permission" := TenantPermission."Modify Permission"::" ";
            TenantPermission."Delete Permission" := TenantPermission."Delete Permission"::" ";
            TenantPermission."Execute Permission" := TenantPermission."Execute Permission"::Yes;
            TenantPermission.Type := TenantPermission.Type::Include;
            TenantPermission.Insert();

            TenantPermission.Init();
            TenantPermission."App ID" := TenantPermissionSet."App ID";
            TenantPermission."Role ID" := TenantPermissionSet."Role ID";
            TenantPermission."Object Type" := TenantPermission."Object Type"::System;
            TenantPermission."Object ID" := 5330;
            TenantPermission."Read Permission" := TenantPermission."Read Permission"::" ";
            TenantPermission."Insert Permission" := TenantPermission."Insert Permission"::" ";
            TenantPermission."Modify Permission" := TenantPermission."Modify Permission"::" ";
            TenantPermission."Delete Permission" := TenantPermission."Delete Permission"::" ";
            TenantPermission."Execute Permission" := TenantPermission."Execute Permission"::Yes;
            TenantPermission.Type := TenantPermission.Type::Include;
            TenantPermission.Insert();

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
}
