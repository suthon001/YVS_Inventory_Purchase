/// <summary>
/// Enum Item Journal Document Status (ID 75000).
/// </summary>
enum 75000 "YVS Item Journal Doc. Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Open) { Caption = 'Open'; }
    value(1; Released) { Caption = 'Released'; }
    value(2; "Pending Approval") { Caption = 'Pending Approval'; }
}