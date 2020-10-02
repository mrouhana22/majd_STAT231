url <- "https://en.wikipedia.org/wiki/List_of_justices_of_the_Supreme_Court_of_the_United_States"

tables <- url %>%               
  read_html() %>%
  html_nodes("table")

justices <- html_table(tables[[2]], fill = TRUE)

write_csv(justices, "/home/class22/mrouhana22/git/majd_STAT231/homework/justices.csv")
