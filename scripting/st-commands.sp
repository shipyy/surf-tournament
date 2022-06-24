public void createCMDS()
{
    //COMMANDS
    RegConsoleCmd("sm_ready", Client_Ready, "[Tournament] Sets player as ready.");
}

public Action Client_Ready(int client, int args)
{
    if(!IsValidClient(client))
        return Plugin_Handled;

    //FIRST READY SLOT
    if(!g_bPlayers_Ready_Check[0]){

        g_bPlayers_Ready_Check[0] = true;

        g_iPlayers_Index[0] = client;

        GetClientAuthId(client, AuthId_Steam2, g_sPlayers_SteamID[0], sizeof(g_sPlayers_SteamID), true);

        GetClientName(g_iPlayers_Index[0], g_sPlayer_Name[0], MAX_NAME_LENGTH);

        CPrintToChatAll("%t", "Player1Ready", g_szChatPrefix, g_sPlayer_Name[0]);
    }
    //SECOND READY SLOT
    else{
        g_bPlayersReady = true;

        g_bPlayers_Ready_Check[1] = true;

        g_iPlayers_Index[1] = client;

        GetClientAuthId(client, AuthId_Steam2, g_sPlayers_SteamID[1], sizeof(g_sPlayers_SteamID), true);

        GetClientName(g_iPlayers_Index[1], g_sPlayer_Name[1], MAX_NAME_LENGTH);

        CPrintToChatAll("%t", "Player2Ready", g_szChatPrefix, g_sPlayer_Name[1]);

    }

    return Plugin_Handled;
}