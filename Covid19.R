library(httr)     # Cominucacao com API's
library(jsonlite) # Manipulacao de .json
library(ggplot2)  # graficos
library(plotly)   # graficos interativos
library(dplyr)
library(hrbrthemes)

# Consultando dados de n� de casos confirmados

cov_br_conf <- GET(url = "https://api.covid19api.com/country/brazil/status/confirmed",
                   encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

# Consultando dados de n� de recuperados

cov_br_rec <- GET(url = "https://api.covid19api.com/country/brazil/status/recovered",
                  encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

# Consultando dados de n� de mortes

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

cov_br
# Remove 35 linhas com dplyr

cov_br <- cov_br %>% slice(36:n())

# Grafico do n� de casos confirmados

graph_conf <- cov_br %>%
  ggplot(aes(x=dia)) +
  geom_area( aes(y = confirmados/1000), fill  = "#93c9ff", alpha = 0.4) +
  geom_line( aes(y = confirmados/1000), color = "#93c9ff", size = 1) +
 # geom_point(aes(y = confirmados), color = "#93c9ff", size = 2) +
  theme_modern_rc()
# graph_conf

# Grafico do n� de mortes

graph_mort <- cov_br %>%
  ggplot(aes(x=dia)) +
  geom_area( aes(y = mortes), fill  = "#f25a5a", alpha = 0.4) +
  geom_line( aes(y = mortes), color = "#f25a5a", size = 1) +
 # geom_point(aes(y = mortes), color = "#f2a55a", size = 2) +
  theme_modern_rc()
#graph_mort

# Grafico do n� de recuperados

graph_rec <- cov_br %>%
  ggplot(aes(x=dia)) +
  geom_area( aes(y = recuperados/1000), fill  = "#69b37b", alpha = 0.4) +
  geom_line( aes(y = recuperados/1000), color = "#69b37b", size = 1) +
 # geom_point(aes(y = recuperados), color = "#69b37b", size = 1) + 
  theme_modern_rc()

# graph_rec


# Total de casos no mundo
cov_wrl_tt <- GET(url = "https://api.covid19api.com/world/total",
                  encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

cov_wrl_tt

# Percentual de mortos

perc_mort <- (cov_wrl_tt$TotalDeaths / cov_wrl_tt$TotalConfirmed)*100 

perc_mort

# Total de novos casos por pa�s
cov_coun_new <- GET(url = "https://api.covid19api.com/summary",
                    encode = 'json') %>%
  content %>%
  toJSON %>%
  fromJSON

cov_coun_new

cov_coun_br <- ((cov_br$mortes / cov_br$confirmados)*100)
cov_coun_br

