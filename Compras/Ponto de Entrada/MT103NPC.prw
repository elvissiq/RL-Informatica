#Include "Protheus.ch"
 
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT103NPC                                                                                              |
 | Desc:  Preenchimento de campos customizados na SD1, como o campo descrição do produto que não vem automático quando é feito o vínculo com pedido de compra | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085416                                          |
 *--------------------------------------------------------------------------------------------------------------*/
 
User Function MT103NPC()
    Local aArea     := GetArea()
    Local nPosCod   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD" })
    Local nPosCampo := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_XDESC" })
    Local nAtual    := 0
     
    //Percorrendo os acols
    For nAtual := 1 To Len(aCols)
        aCols[nAtual][nPosCampo] := Posicione('SB1', 1, FWxFilial('SB1')+aCols[nAtual][nPosCod], "B1_DESC")
    Next
     
    RestArea(aArea)
Return
