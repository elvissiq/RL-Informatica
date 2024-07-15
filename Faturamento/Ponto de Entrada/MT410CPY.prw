#Include "TOTVS.CH"

USER FUNCTION MT410CPY()

	Local aArea := FWGetArea()
	Local lRet := .T.
  Local nY := 1
  Local nPosNempem := Ascan(aHeader, {|x| AllTrim(x[2]) == "C6_PEDCLI"})

  C5_XNEMPEM := Space(FWTamSX3("C5_XNEMPEM")[1])
  C5_XCONTRA := Space(FWTamSX3("C5_XCONTRA")[1])
  C5_XLICITA := Space(FWTamSX3("C5_XLICITA")[1])
  C5_XSTATUS := Space(FWTamSX3("C5_XSTATUS")[1])


  For nY := 1 to Len(aCols)
    If nPosNempem > 0
      aCols[nY,nPosNempem] := Space(FWTamSX3("C6_PEDCLI")[1])
    EndIF 
  Next

	FWRestArea(aArea)

RETURN lRet
