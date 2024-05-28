#Include "Protheus.ch"
 
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MSC1110D                                                                                              |
 | Desc:  Antes da apresenta�ao da dialog de exclus�o da SC possibilita validar a solicita��o posicionada para  |
 |        continuar e executar a exclus�o ou n�o.                                                               |
 | Link:  https://tdn.totvs.com/pages/releaseview.action?pageId=6085367                                         |
 *--------------------------------------------------------------------------------------------------------------*/
 
User Function MSC1110D()
    Local aArea := FWGetArea()
    Local lRet := Empty(SC1->C1_ORIGEM)
    
    If !lRet
        FWAlertError("Esta Solicita��o n�o poder� ser exclu�da, pois a mesma foi gerada por outra rotina."+(Chr(10)+Chr(13))+;
                     "Solicita��o gerada pela rotina: "+Alltrim(SC1->C1_ORIGEM),"ATEN��O")
    EndIF 
     
    FWRestArea(aArea)
Return lRet
