public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if (g_bMatchStarted && !g_bMatchFinished)
        Checkpoints_Display();

	return Plugin_Continue;
}