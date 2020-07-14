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

# Grafico do nº de casos confirmados

graph_conf <- cov_br %>%
  ggplot(aes(x=dia)) +
  geom_area( aes(y = confirmados), fill  = "#f25a5a", alpha = 0.4) +
  geom_line( aes(y = confirmados), color = "#f25a5a", size = 1) +
  geom_point(aes(y = confirmados), color = "#f25a5a", size = 2)

# Grafico do nº de mortes

graph_mort <- cov_br %>%
  ggplot(aes(x=dia)) +
  geom_area( aes(y = mortes), fill  = "#f28f5a", alpha = 0.4) +
  geom_line( aes(y = mortes), color = "#f28f5a", size = 1) +
  geom_point(aes(y = mortes), color = "#f28f5a", size = 2)

# Grafico do nº de recuperados

graph_rec <- cov_br %>%
  ggplot(aes(x=dia)) +
  geom_area( aes(y = recuperados), fill  = "#69b37b", alpha = 0.4) +
  geom_line( aes(y = recuperados), color = "#69b37b", size = 1) +
  geom_point(aes(y = recuperados), color = "#69b37b", size = 2)