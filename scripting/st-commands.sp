public void createCMDS()
{
    //COMMANDS
    RegConsoleCmd("sm_ready", Client_Ready, "[Tournament] Sets player as ready.");
    RegConsoleCmd("sm_r", Client_Ready, "[Tournament] Sets player as ready.");
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

        char player1_name[MAX_NAME_LENGTH];
        GetClientName(g_iPlayers_Index[0], player1_name, sizeof(player1_name));

        CPrintToChatAll("%t", "Player1Ready", g_szChatPrefix, g_sPlayers_SteamID[0]);
    }
    //SECOND READY SLOT
    else{
        g_bPlayersReady = true;

        g_bPlayers_Ready_Check[1] = true;

        g_iPlayers_Index[1] = client;

        GetClientAuthId(client, AuthId_Steam2, g_sPlayers_SteamID[1], sizeof(g_sPlayers_SteamID), true);

        char player2_name[MAX_NAME_LENGTH];
        GetClientName(g_iPlayers_Index[1], player2_name, sizeof(player2_name));

        CPrintToChatAll("%t", "Player2Ready", g_szChatPrefix, g_sPlayers_SteamID[1]);
    }

    return Plugin_Handled;
}