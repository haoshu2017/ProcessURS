library(pdftools)
library(tidyverse)
library(rJava)
library(tabulizer)
library(tabulizerjars)

pdf <-'/Users/haoshu/Desktop/URS/'
data <-paste0(pdf, 'Raw Data/')
setwd(pdf)

# Read-in pdfs in a folder: 
files = list.files(data)

# Loop through all pdf files: 

pg2.final <-data.frame()  ## initiate a new empty dataframe for storage

for (file in files) {
   filetxt <- pdftools::pdf_text(paste0(data, file))
   # create a state indicator 
   state <-str_extract(file, '(?<=URS_).*(?=\\.pdf)')
   # Extract page 2's texts
   pg2_txt <-filetxt[[2]]

   pg2.split <-str_split(pg2_txt,'\\n', simplify = T )%>% 
        as.vector()
    
   pg2.tibble <-tibble(pg2.split) %>%
        filter(row_number()>=5 & row_number()<=8) %>% 
        #mutate(text.squish=str_replace_all(pg2.split, "(\\.\\s)+", "\\.")) %>% 
        separate(pg2.split, into=c('rownames',"U.S.", "State", "U.S.Rate", 'States'), 
                 sep="\\s{2,}", convert = TRUE) %>% 
        mutate(state = state)

   pg2.final <-rbind(pg2.final, pg2.tibble)

}        
        
        
        
        
