library(httr)     # Cominucacao com API's
library(jsonlite) # Manipulacao de .json
library(ggplot2)  # graficos
library(plotly)   # graficos interativos
library(dplyr)

# Consultando dados de nº de casos confirmados
cov_br_conf <- GET(url = "https://api.covid19api.com/country/brazil/status/confirmed",
                   encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

# Consultando dados de nº de recuperados
cov_br_rec <- GET(url = "https://api.covid19api.com/country/brazil/status/recovered",
                  encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

# Consultando dados de nº de mortes
cov_br_dt <- GET(url = "https://api.covid19api.com/country/brazil/status/deaths",
                 encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

# Converte as datas
datas <- cov_br_conf$Date %>% unlist %>% as.Date()

# Cria um data.frame unificado
cov_br <- data.frame(
  
  dia = datas,
  confirmados = cov_br_conf$Cases %>% unlist,
  mortes      = cov_br_dt$Cases   %>% unlist,
  recuperados = cov_br_rec$Cases  %>% unlist
  
)

# Remove 35 linhas com dplyr
cov_br <- cov_br %>% slice(36:n())

