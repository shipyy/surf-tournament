ConVar g_cvarRoundDuration;
ConVar g_cvarCountDownDuration;

void ConVars_Create()
{
    AutoExecConfig_SetCreateDirectory(true);
    AutoExecConfig_SetCreateFile(true);
    AutoExecConfig_SetFile("tournament");

    g_cvarRoundDuration = AutoExecConfig_CreateConVar("round_duration", "10", "specifies value of rounds duration", _, true, 0.0, true, 100.0);
    g_cvarCountDownDuration = AutoExecConfig_CreateConVar("countdown_duration", "10", "specifies value of countdown duration", _, true, 0.0, true, 100.0);

    g_CountDownDuration = g_cvarCountDownDuration.IntValue;
    g_RoundDuration = g_cvarRoundDuration.IntValue * 60 * 1.0; // convert to minutes

    AutoExecConfig_ExecuteFile();
    AutoExecConfig_CleanFile();
}

public void Convars_Get()
{
    g_CountDownDuration = GetConVarInt(g_cvarCountDownDuration);
    g_RoundDuration = GetConVarInt(g_cvarRoundDuration) * 60 * 1.0;
}