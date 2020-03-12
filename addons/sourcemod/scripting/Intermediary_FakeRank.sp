#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name		= "Intermediary FakeRank",
	version		= "1.0",
	description	= "Mediator between fakeranks and a picture in a hint ",
	author		= "ღ λŌK0ЌЭŦ ღ ™",
	url			= "https://github.com/IL0co"
}

char FastDl_URL[256];

KeyValues kv;
bool g_mode;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{	
	if(GetEngineVersion() != Engine_CSGO)
	{
		Format(error, err_max, "This plugin works only on CS:GO");
		return APLRes_SilentFailure;
	}

	CreateNative("IFR_ShowHintFakeRank", Native_Intermediary_ShowHintFakeRank);
	MarkNativeAsOptional("IFR_ShowHintFakeRank");

	RegPluginLibrary("Intermediary_FakeRank");
	return APLRes_Success;
}

int Native_Intermediary_ShowHintFakeRank(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	int id = GetNativeCell(2);

	if(id)
	{
		ShowHintFakeRank(client, id);

		DataPack hPack = new DataPack();
		CreateTimer(0.3, Timer_DelayRepeater, hPack, TIMER_DATA_HNDL_CLOSE);
		hPack.WriteCell(client);
		hPack.WriteCell(id);

		return true;
	}
	return false;
}

public Action Timer_DelayRepeater(Handle hTimer, DataPack hPackEnt)
{  
	hPackEnt.Reset();
	int client = hPackEnt.ReadCell(); 
	int id = hPackEnt.ReadCell();
	ShowHintFakeRank(client, id);

	return Plugin_Stop;
}

stock void ShowHintFakeRank(int client, int id)
{
	if(g_mode)
	{
		char URL[256];
		Format(URL, sizeof(URL), "%i", id);
		kv.GetString(URL, URL, sizeof(URL));
		PrintHintText(client, "<font> <img src='%s' /></font>", URL);
	}
	else 
	{
		PrintHintText(client, "<font> <img src='%s%i.png' /></font>", FastDl_URL, id);
	}
}

public void OnPluginStart()
{
	LoadCfg();

	if(!g_mode)
	{
		ConVar cvar;
		cvar = FindConVar("sv_downloadurl");
		cvar.AddChangeHook(OnVarChanged);
		OnVarChanged(cvar, NULL_STRING, NULL_STRING);
	}
}

public void OnVarChanged(ConVar cvar, const char[] oldValue, const char[] newValue) 
{
	GetConVarString(cvar, FastDl_URL, sizeof(FastDl_URL));

	if(FastDl_URL[0])
	{
		if(FastDl_URL[strlen(FastDl_URL)-1] != '/')
			Format(FastDl_URL, sizeof(FastDl_URL), "%s/", FastDl_URL);

		Format(FastDl_URL, sizeof(FastDl_URL), "%smaterials/panorama/images/icons/skillgroups/skillgroup", FastDl_URL);
	}
}

stock void LoadCfg()
{
	kv = new KeyValues("FakeRank_Intermediary");
	
	char sBuffer[256];
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/Intermediary_FakeRank.txt");

	if (!FileToKeyValues(kv, sBuffer)) 
		SetFailState("Couldn't parse file %s", sBuffer);

	g_mode = view_as<bool>(kv.GetNum("mode", 0));
	
}
