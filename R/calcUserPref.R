## Squared Euclidean distance for each school from the user's prefs
## http://en.wikipedia.org/wiki/Euclidean_distance#Squared_Euclidean_distance
calcUserPref = function(mydf, U_ENROLL = 975, 
                        U_YIELD = .30, 
                        U_IGRNT = 70, 
                        U_NPG = 21000, 
                        U_RET = 95, 
                        U_SF = 12, 
                        U_GR = 90) 
{
  ## calc the sum of squares 
  ss =  (mydf$ENRLT - U_ENROLL)^2 + 
    (mydf$yield - U_YIELD)^2 +
    (mydf$IGRNT_P - U_IGRNT)^2 + 
    (mydf$NPGRN2 - U_NPG)^2 + 
    (mydf$RET_PCF - U_RET)^2 + 
    (mydf$STUFACR - U_SF)^2 + 
    (mydf$gradrate6 - U_GR)^2
  
  ed = sqrt(ss)
  
  ## add the column to the dataframe
  mydf$dist = ed
  
  ## create the rank, smaller values first
  mydf = transform(mydf, rank = rank(dist))
  
  return(mydf)
}