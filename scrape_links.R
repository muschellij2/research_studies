rm(list = ls())
library(httr)
library(rvest)
library(dplyr)

css = ".column > p"
df = readr::read_rds("page_links.rds")
url = df$link[1]
get_link_info = function(url) {
  print(url)
  res = read_html(url)

  divs = res %>%
    html_nodes(css)
  info = divs %>% html_text() %>%
    paste(collapse = " ")
  return(info)
}

pages = 1:20
res = lapply(df$link, get_link_info)

stopifnot(all(sapply(res, length) == 1))
info = unlist(res)
df$info = info
readr::write_rds(df, path = "page_links_with_info.rds", compress = "xz")

