//RETRIEVED FROM https://github.com/surftimer/SurfTimer/blob/master/addons/sourcemod/scripting/surftimer/misc.sp
public void FormatTimeFloat(int client, float time, int type, char[] string, int length)
{
	char szMinutes[16];
	char szSeconds[16];
	char szMS[16];

	int minutes = view_as<int>(time / 60);
	int seconds = view_as<int>(time - minutes*60);
	int ms = view_as<int>((time - view_as<int>(time)) * 1000);

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
	
	Format(string, length, "%s:%s:%s", szMinutes, szSeconds, szMS);
}

stock bool IsValidClient(int client)
{   
    if (client >= 1 && client <= MaxClients && IsClientInGame(client))
        return true;
    return false;
}