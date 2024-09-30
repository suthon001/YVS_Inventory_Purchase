/// <summary>
/// TableExtension YVS Transfer Line (ID 75014) extends Record Transfer Line.
/// </summary>
tableextension 75014 "YVS Transfer Line" extends "Transfer Line"
{
    /// <summary>
    /// TestFieldAPI.
    /// </summary>
    procedure TestFieldAPI()
    begin
        rec.TestField("Document No.");
        rec.TestField("Item No.");
        rec.TestField("Unit of Measure Code");
        rec.TestField(Quantity);
    end;
}
