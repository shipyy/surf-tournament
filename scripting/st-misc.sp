public void FormatTimeFloat(int client, float time, char[] string, int length)
{
	if (time <= 0.0) {
		Format(string, length, "00:00.000");
		return;
	}

	char szDays[16];
	char szHours[16];
	char szMinutes[16];
	char szSeconds[16];
	char szMS[16];

	int time_rounded = RoundToZero(time);

	int days = time_rounded / 86400;
	int hours = (time_rounded - (days * 86400)) / 3600;
	int minutes = (time_rounded - (days * 86400) - (hours * 3600)) / 60;
	int seconds = (time_rounded - (days * 86400) - (hours * 3600) - (minutes * 60));
	int ms = RoundToZero(FloatFraction(time) * 1000);

	// 00:00:00:00:000
	// 00:00:00:000
	// 00:00:000

	//MILISECONDS
	if (ms < 10)
		Format(szMS, 16, "00%d", ms);
	else
		if (ms < 100)
			Format(szMS, 16, "0%d", ms);
		else
			Format(szMS, 16, "%d", ms);

	//SECONDS
	if (seconds < 10)
		Format(szSeconds, 16, "0%d", seconds);
	else
		Format(szSeconds, 16, "%d", seconds);

	//MINUTES
	if (minutes < 10)
		Format(szMinutes, 16, "0%d", minutes);
	else
		Format(szMinutes, 16, "%d", minutes);

	//HOURS
	if (hours < 10)
		Format(szHours, 16, "0%d", hours);
	else
		Format(szHours, 16, "%d", hours);

	//DAYS
	if (days < 10)
		Format(szDays, 16, "0%d", days);
	else
		Format(szDays, 16, "%d", days);

	if (days > 0) {
		Format(string, length, "%s:%s:%s:%s.%s", szDays, szHours, szMinutes, szSeconds, szMS);
	}
	else {
		if (hours > 0) {
			Format(string, length, "%s:%s:%s.%s", szHours, szMinutes, szSeconds, szMS);
		}
		else {
			Format(string, length, "%s:%s.%s", szMinutes, szSeconds, szMS);
		}
	}

}

stock bool IsValidClient(int client)
{   
    if (client >= 1 && client <= MaxClients && IsClientInGame(client))
        return true;
    return false;
}

public void DeleteTimers()
{	
	delete PlayersReady_Timer;
	delete CountDown_Timer;
	delete Timeleft_Timer;
	delete Stopwatch_Timer;
}

public void SetDefaults()
{
	g_iPlayers_Index[0] = -1;
	g_iPlayers_Index[1] = -1;

	g_fPlayers_BestRun[0] = 0.0;
	g_fPlayers_BestRun[1] = 0.0;

	Format(g_sPlayers_SteamID[0], 32, "%s", "");
	Format(g_sPlayers_SteamID[1], 32, "%s", "");

	Format(g_sPlayer_Name[0], MAX_NAME_LENGTH, "%s", "");
	Format(g_sPlayer_Name[1], MAX_NAME_LENGTH, "%s", "");

	g_bPlayers_Ready_Check[0] = false;
	g_bPlayers_Ready_Check[1] = false;

	g_bPlayersReady = false;

	g_bPlayer_FinalRun[0] = false;
	g_bPlayer_FinalRun[1] = false;
	
	g_bPlayer_Finished[0] = false;
	g_bPlayer_Finished[1] = false;

	g_bMatchFinished = false;

	g_iCurrentCP[0] = 0;
	g_iCurrentCP[1] = 0;

	for (int i = 0; i < 42; i++) {
		g_fPlayers_BestRun_CheckpointTimes[0][1] = 0.0;
		g_fPlayers_BestRun_CheckpointTimes[1][1] = 0.0;
	}

	PlayersReady_Timer = CreateTimer(1.0, CheckPlayersReady, _, TIMER_REPEAT);
}