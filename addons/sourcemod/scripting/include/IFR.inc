 #if defined _IFR_included
 #endinput
#endif
#define _IFR_included

/*
 * Показать игроку в хинте иконку фейкранга
 *	
 * @param client 		    Индекс игрока.		
 * @param id 		        Id ранг
 *  
 * @return               	true если успех, или же false	  
*/
native bool IFR_ShowHintFakeRank(int client, int id);
