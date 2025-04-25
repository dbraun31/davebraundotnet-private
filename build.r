path <- '~/'
if (getwd() != here::here()) {
    setwd(here::here())
}
blogdown::build_site()
