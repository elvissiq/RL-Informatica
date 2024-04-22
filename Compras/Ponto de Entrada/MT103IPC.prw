#Include "Protheus.ch"
 
/*---------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT103IPC                                                                                               |
 | Desc:  Preenchimento de campos customizados na SD1, como o campo descrição do produto que não vem automático  | 
 | quando é feito o vínculo com pedido de compra                                                                 | 
 | Link:https://tdn.totvs.com/display/public/PROT/MT103IPC+-+Atualiza+campos+customizados+no+Documento+de+Entrada|
 *---------------------------------------------------------------------------------------------------------------*/
 
User Function MT103IPC()
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
