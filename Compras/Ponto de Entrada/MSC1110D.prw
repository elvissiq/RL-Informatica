#Include "Protheus.ch"
 
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MSC1110D                                                                                              |
 | Desc:  Antes da apresentaçao da dialog de exclusão da SC possibilita validar a solicitação posicionada para  |
 |        continuar e executar a exclusão ou não.                                                               |
 | Link:  https://tdn.totvs.com/pages/releaseview.action?pageId=6085367                                         |
 *--------------------------------------------------------------------------------------------------------------*/
 
User Function MSC1110D()
    Local aArea := FWGetArea()
    Local lRet := Empty(SC1->C1_ORIGEM)
    
    If !lRet
        FWAlertError("Esta Solicitação não poderá ser excluída, pois a mesma foi gerada por outra rotina."+(Chr(10)+Chr(13))+;
                     "Solicitação gerada pela rotina: "+Alltrim(SC1->C1_ORIGEM),"ATENÇÃO")
    EndIF 
     
    FWRestArea(aArea)
Return lRet
