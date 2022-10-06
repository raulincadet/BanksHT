library(dplyr)
library(xts)
library(zoo)
##############################
df_bal=read.csv("BalanceSheet_withoutDuplicates.csv", fileEncoding = "UTF-8")

#### remove '-' in names of parts
df_bal$Parts1_en<-gsub('[-]',' ',df_bal$Parts1_en)
df_bal$Parts2_en<-gsub('[-]',' ',df_bal$Parts2_en)

### remove spaces before and after string
df_bal$Parts1_en<-stringr::str_trim(df_bal$Parts1_en,side='both')
df_bal$Parts2_en<-stringr::str_trim(df_bal$Parts2_en,side='both')

# remove the column "BHD.." which is empty, while column "BHD" does have data
#sum(df_bal$BHD..,na.rm = T)   # no value in that column
#sum(df_bal$BHD,na.rm = T)     # there are some data in that column
df_bal<-df_bal[,colnames(df_bal)[!colnames(df_bal)%in% c("BHD..","TOTAL")]]   # removing column "BHD.." and column "TOTAL"

# create a column for Total values of each indicator/row. There are some errors in Total of variables in income statement in files from the central bank
df_bal$System=rowSums(df_bal[,colnames(df_bal)[!colnames(df_bal) %in% c("Indicators","Date","Parts1_fr","Parts2_fr","Parts1_en","Parts2_en") ]],na.rm = T)

##############################################################################
## Creating several data frame of indicators to be merged in one data frame ##
# This is done since, filtering some elements in Parts1_en or Parts2_en can do the total of an indicators where the result should be one minus the other. It is the case for Loan portfolio and Non performing loan.
# some other unneccessary additions may happen if we do not create separate data frame
#unique(df_bal$Parts1_en)
#unique((df_bal%>%filter(Parts1_en=="Asset" ))$Indicators)
df_balP1=df_bal%>%filter(Parts1_en %in% c("Asset","Liability","Equity"))

##############
# create a function to summarise data of asset, liability and equidy

fsummarise_bal<-function(){
  banks=c(colnames(df_bal)[!colnames(df_bal) %in% c("Indicators","Date","Parts1_fr","Parts2_fr","Parts1_en","Parts2_en") ])
  y=NULL;df=data.frame()#;colnames(doo)=c("Date","Parts1_en","Values")
  for(i in 1:length(banks)){
    y[[i]]=df_balP1%>%group_by(Date,Parts1_en)%>%
      summarise(val=sum(get(banks[i]),na.rm = T))

  }
  df=cbind.data.frame(y)
  dff=df[,colnames(df)=="val"]
  colnames(dff)=banks
  dff2=cbind.data.frame(df[,c("Date","Parts1_en")],dff)
  # dff2=dff2[,c("Date",banks)]
  return(dff2)
}
df_balP1b=fsummarise_bal()
##############33
df_balP1b$Indicators_en=df_balP1b$Parts1_en
df_balP1b$Indicators=df_balP1b$Parts1_en
df_balP1b$Parts1_fr=df_balP1b$Parts1_en
df_balP1b$Parts2_fr=df_balP1b$Parts1_en
df_balP1b$Parts2_en=df_balP1b$Parts1_en
#doo=df_balP1%>%filter(Indicators_en=="Equity")%>%select("Date","BNC")
#unique(df_bal$Parts1_en)
#unique((df_bal%>%filter(Parts2_en=="Deposit in US converted in HTG" ))$Indicators)
df_balP2=df_bal%>%filter(Parts1_en %in% c("Liquid asset","Non liquid asset","Deposit","Demand bonds","Term bonds","Other liabilities","Loan portfolio","Allowance for bad debts","Non performing loan","Deposit in US converted in HTG" ))
df_balP2$Indicators_en=df_balP2$Parts2_en

#unique(df_bal$Parts2_en)
#unique((df_bal%>%filter(Parts2_en=="Off balance sheet" ))$Indicators)
df_balI=df_bal%>%filter(Indicators %in% c("ACTIF_LIQUIDE_encaisse","ACTIF_LIQUIDE_avoirs_a_la_brh","ACTIF_LIQUIDE_avoirs_a_l'etranger","ACTIF_LIQUIDE_avoirs_dans_les_banques_locales","ACTIF_LIQUIDE_autres_liquidites" ,"ACTIF_ILLIQUIDE_bons_b.r.h.","ACTIF_ILLIQUIDE_bons_du_tresor_/_m.e.f.","ACTIF_ILLIQUIDE_autres_placements","ACTIF_ILLIQUIDE_portefeuille_net","ACTIF_ILLIQUIDE_immobilisations","ACTIF_ILLIQUIDE_autres_actifs","ACTIF_ILLIQUIDE_bons_du_tresor/mef","DÉPÔT_a_vue","DÉPÔT_epargne","DÉPÔT_a_terme","OBLIGATIONS_À_VUE_banques_locales","OBLIGATIONS_À_VUE_banques_a_l'etranger","OBLIGATIONS_À_VUE_autres","OBLIGATIONS_À_TERME_banques_locales","OBLIGATIONS_À_TERME_banque_a_l'etranger","OBLIGATIONS_À_TERME_autres" ,"AUTRES_PASSIFS_autres_passifs", "HORS-BILAN_effets_a_l'encaissement","HORS-BILAN_credit_documentaire","HORS-BILAN_autres"   ))
#######
fdf_indicators_en<-function(){ # function to create a vector of indicators name in English for data frame df_balI
  dd=data.frame(c("ACTIF_LIQUIDE_encaisse","ACTIF_LIQUIDE_avoirs_a_la_brh","ACTIF_LIQUIDE_avoirs_a_l'etranger","ACTIF_LIQUIDE_avoirs_dans_les_banques_locales","ACTIF_LIQUIDE_autres_liquidites" ,"ACTIF_ILLIQUIDE_bons_b.r.h.","ACTIF_ILLIQUIDE_bons_du_tresor_/_m.e.f.","ACTIF_ILLIQUIDE_autres_placements","ACTIF_ILLIQUIDE_portefeuille_net","ACTIF_ILLIQUIDE_immobilisations","ACTIF_ILLIQUIDE_autres_actifs","ACTIF_ILLIQUIDE_bons_du_tresor/mef","DÉPÔT_a_vue","DÉPÔT_epargne","DÉPÔT_a_terme","OBLIGATIONS_À_VUE_banques_locales","OBLIGATIONS_À_VUE_banques_a_l'etranger","OBLIGATIONS_À_VUE_autres","OBLIGATIONS_À_TERME_banques_locales","OBLIGATIONS_À_TERME_banque_a_l'etranger","OBLIGATIONS_À_TERME_autres" ,"AUTRES_PASSIFS_autres_passifs", "HORS-BILAN_effets_a_l'encaissement","HORS-BILAN_credit_documentaire","HORS-BILAN_autres"   ),

                c("Cash","Assets at the central bank","assets abroad","Assets in local banks","Other liquid assets", "Central bank bills","Treasury bills", "other investments","Net loan portfolio","Fixed assets","Other assets","Treasury bills","Sight deposit","Savings deposit","Term deposit","Demand bonds in local banks","Demand bonds in banks abroad","Other demand bonds","Term bonds in local banks","Term bonds in foreign banks","Other term bonds","Other liabilities","Non cash items",
                  "Letter of credit","Other off balance sheet"))

  colnames(dd)<-c("Indicators_fr","Indicators_en")

  y=NULL
  for(i in 1:length(df_balI$Indicators)){
    for(j in 1:length(dd$Indicators_fr)){
      if(df_balI$Indicators[i]==dd$Indicators_fr[j]){
        y[[i]]=dd$Indicators_en[j]
      }
    }
  }
  return(unlist(y))
}
#fdf_indicators_en()
#(data.frame(df_balI$Indicators,fdf_indicators_en()))
#################
df_balI$Indicators_en=fdf_indicators_en()  # adding a column with indicators names in English
##################
# Merging the data frames of balance sheet
df_balance=rbind.data.frame(df_balP1b,df_balP2)
df_balance=rbind(df_balance,df_balI)
##########################




df_inc=read.csv("C:/Users/Diaraye/Documents/Raul/GitHub/BanksHT/IncomeStatement_withoutDuplicates.csv")
#sum(df_inc$BHD..,na.rm = T)   # no value in that column
#sum(df_inc$BHD,na.rm = T)     # there are some data in that column
df_inc<-df_inc[,colnames(df_inc)[!colnames(df_inc)%in% c("BHD..","TOTAL")]]   # removing column "BHD.." and column "TOTAL"

# create a column for Total values of each indicator/row. There are some errors in Total of variables in income statement in files from the central bank
df_inc$System=rowSums(df_inc[,colnames(df_inc)[!colnames(df_inc) %in% c("Indicators","Indicators_en","Date","Parts1_fr","Parts2_fr","Parts1_en","Parts2_en") ]],na.rm = T)
df_inc=df_inc[df_inc$Indicators_en!="Allowance for bad debts",] # remove this variable, available in the data frame related to the balance sheet

############# EMPLOYEES NUMBER ##############################
df_emp<-read.csv("C:/Users/Diaraye/Documents/Raul/GitHub/BanksHT/BanksEmployees_withoutDuplicates.csv")

# remove spaces before and after the name of each bank
df_emp$Banks=stringr::str_trim(df_emp$Banks,side='both')
df_emp<-df_emp%>%filter(Banks!="PROMOBK *") # to remove data
# related to that bank which are redundant compared to the name without asterisk.

# remove duplicated rows
df_emp<-df_emp[!duplicated(df_emp),]

df_emp$Banks<-gsub("UNIBK","UNIBNK",df_emp$Banks) # to harmonized the name of this bank to be the same in all data frame.

#################################
femployees<-function(){ # function to structured a new data frame of numbers
  # of employees to be merged with the other data frames
  banks_emp=unique(df_emp$Banks)
  bks=NULL
  do=data.frame()
  #colnames(do)=c("Date","Indicator")
  for (i in 1:length(banks_emp)) {
    bks[[i]]=df_emp%>%filter(Banks==banks_emp[i])%>%select(Date,Indicator)
    colnames(bks[[i]])=c("Date",banks_emp[i])
  }
  dat=bks[1]
  for(i in 2:length(banks_emp)){
    dat=merge.data.frame(dat,bks[i])
  }
  return(dat)
}


df_employees=femployees() # new data frame of numbers of employees by bank and by date

#sum(df_employees$BMH,na.rm = T)
df_employees<-df_employees[,colnames(df_employees)[!colnames(df_employees)%in% c("Var.2","TOTAL","BMH")]]   # removing column "BMH." and column "TOTAL". There is not any data in BMH column.

# create a column for Total values of each indicator/row. There are some errors in Total of variables in income statement in files from the central bank
df_employees$System=rowSums(df_employees[,colnames(df_employees)[!colnames(df_employees) %in% c("Date") ]],na.rm = T)

# Adding other columns so that this data frame could have the same columns than the others, before merging.
df_employees$Indicators=rep("Number of employees",dim(df_employees)[1])
df_employees$Parts1_en=rep("Number of employees",dim(df_employees)[1])
df_employees$Parts2_en=rep("Number of employees",dim(df_employees)[1])
df_employees$Indicators_en=rep("Number of employees",dim(df_employees)[1])
df_employees$Parts1_fr=rep("Number of employees",dim(df_employees)[1])
df_employees$Parts2_fr=rep("Number of employees",dim(df_employees)[1])

# Some indicators of df_inc are missed since they are not understandable, such as "loans", which should be "loan interest income". I am resolving this problem bellow:
fincome_indic<-function(){
  y=NULL
  for(i in 1:dim(df_inc)[1]){
    if(df_inc$Indicators_en[i]==df_inc$Parts2_en[i]){ # if indicators name are identical with Parts1_en, I do not merge them
      y[i]=df_inc$Indicators_en[i]
    }else{
      y[i]=paste(df_inc$Indicators_en[i]," (",df_inc$Parts2_en[i],")",sep="")
    }
  }
  y
}
df_inc$Indicators_en=fincome_indic()
df1=rbind(df_balance,df_inc)
df1=merge(df1,df_employees,all=T)
df1$Date1=as.yearqtr(as.yearmon(unlist(df1$Date)))

#save(df1,file = "C:/Users/Diaraye/Documents/Raul/GitHub/BanksHT_dashboard/banksHT.rda")
