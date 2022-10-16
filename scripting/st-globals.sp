//////
//VARIABLES
/////
int g_iPlayers_Index[2];
char g_sPlayers_SteamID[2][32];
char g_sPlayer_Name[2][MAX_NAME_LENGTH];
float g_fPlayers_BestRun[2];
float g_fPlayers_BestRun_CheckpointTimes[2][42];
float g_fPlayers_CurrentRun_CheckpointTimes[2][42];
float g_fLastDifferenceTime[2];
char g_szCPDifference[2][32];
float g_CPDifference[2];
int g_CPdisplayColor[2][3];
int	g_iCurrentCP[2];
bool g_bPlayers_Ready_Check[2];
bool g_bPlayersReady;

bool g_bPlayer_FinalRun[2];
bool g_bIsOnRun[2];
bool g_bPlayer_Finished[2];
bool g_bPrinted[2];
bool g_bMatchStarted;
bool g_bMatchFinished;

char g_szChatPrefix[64] = "TOURNAMENT";

int g_CountDownDuration;
float g_RoundDuration;

Handle PlayersReady_Timer = null;
Handle CountDown_Timer = null;
Handle Timeleft_Timer = null;
Handle Overtime1 = null;
Handle Overtime2 = null;
Handle Stopwatch_Timer = null;
Handle DisplayHUD_Timer = null;

float g_iOvertimeMessageTime;