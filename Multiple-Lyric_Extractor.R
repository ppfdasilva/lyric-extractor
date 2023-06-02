library(tidyverse)
library(rvest)

rm(list = ls())

## Extracting multiple lyrics from a source
site = 'https://www.vagalume.com.br/the-beatles/' # Specify lyric source, Example: lyrics from The Beatles

title = site %>% read_html() %>% html_nodes("#alfabetMusicList .nameMusic") %>% html_text() # specify CSS selector for title element as                                                                                                 # html_nodes argument
link = site %>% read_html() %>% html_nodes("#alfabetMusicList .nameMusic") %>% html_attr('href') # specify CSS selector for lyrics element
                                                                                                  # as html_nodes argument
link_table = tibble('title' = title, 'link' = link) # Table of titles and links
View(link_table)  

# Função para extrair letra de música
extract_link = function(x){
  tibble('title' = read_html(paste("https://www.vagalume.com.br", x, sep = "")) %>%
           html_nodes('#lyricContent h1') %>% html_text,
         'lyric' = read_html(paste("https://www.vagalume.com.br", x, sep = "")) %>%
           html_nodes('#lyrics') %>% html_text)
}

lyrics = map_df(link_table$link, extract_link)
