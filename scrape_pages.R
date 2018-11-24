rm(list=ls())
library(httr)
library(rvest)
library(dplyr)
page = 2
root = paste0("https://hub.jhu.edu/announcements/",
              "students/research-participants-wanted/")

get_page_links = function(page) {
  print(page)
  url = paste0(root, page, "/")

  res = read_html(url)

  divs = res %>%
    html_nodes(xpath = "//div[contains(@class, 'announcement')]")
  summaries = divs %>%
    html_nodes(".summary") %>%
    html_text %>%
    trimws()
  teaser = divs %>%
    html_nodes("h5") %>%
    html_nodes(css = "a") %>%
    html_text() %>%
    trimws()
  refs = divs %>%
    html_nodes("h5") %>%
    html_nodes(css = "a") %>%
    html_attr("href")
  df = data_frame(title = teaser, summary = summaries, link = refs)
  return(df)
}

pages = 1:20

res = lapply(pages, get_page_links)
names(res) = pages

df = bind_rows(res, .id = "page")
readr::write_rds(df, path = "page_links.rds", compress = "xz")

