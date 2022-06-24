public Action DisplayHUD(Handle timer)
{
    for(int i = 1; i <= MaxClients; i++)
    {
        if(IsValidClient(i) && IsClientObserver(i)){
            int timeleft;
            GetMapTimeLimit(timeleft)
            SetHudTextParams(-1.0, 0.8, 1.0, 255, 255, 255, 255, 0, 0.0, 0.0, 0.0);

            ShowHudText(i, -1, "%f", timeleft);
        }
    }

    return Plugin_Continue;
}