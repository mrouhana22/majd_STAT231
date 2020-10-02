quotes_html2 <- read_html("https://www.brainyquote.com/authors/hayao-miyazaki-quotes")

quotes2 <- quotes_html2 %>%
  html_nodes(".oncl_q") %>%
  html_text()

person2 <- quotes_html2 %>%
  html_nodes(".oncl_a") %>%
  html_text()

quotes_dat2 <- data.frame(person = person2, quote = quotes2
                          , stringsAsFactors = FALSE) %>%
  mutate(together = paste('"', as.character(quote), '" --'
                          , as.character(person), sep=""))

write_csv(quotes_dat2, "/home/class22/mrouhana22/git/majd_STAT231/homework/quotes.csv")