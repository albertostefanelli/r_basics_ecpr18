# creating the stock_data.csv

library(quantmod)
library(tidyverse)
library(hrbrthemes)

# arguments for getSymbols
start_date <- as.Date("2016-01-10")
end_date <- as.Date("2018-01-10")

# tesla and microsoft closing prices
ticker <- c("TSLA", "MSFT")

# load the data into the environment
getSymbols(ticker, src = "yahoo", from = start_date, to = end_date)

tech <- merge.xts(TSLA, MSFT)

tech_df <- as.data.frame(tech) %>% 
    rownames_to_column() %>% 
    rename(date = rowname) %>% 
    select(date, TSLA.Close, MSFT.Close)


write.csv(tech_df, file = "stock_data.csv", row.names = FALSE)



# additional companies
ticker2 <- c("AAPL", "F")

getSymbols(ticker2, src = "yahoo", from = start_date, to = end_date)

tech2 <- merge.xts(AAPL, `F`)

tech_df2 <- as.data.frame(tech2) %>% 
    rownames_to_column() %>% 
    rename(date = rowname) %>% 
    select(date, AAPL.Close, F.Close)

head(tech_df2, 5)

write.csv(tech_df2, file = "stock_data2.csv", row.names = FALSE)

p_stock <- ggplot(stock_tidy,
                  aes(date, stock_closing,
                      color = company))

p_stock +
    geom_line() +
    labs(x = "", y = "Prices (USD)",
         title = "Closing daily prices for MSFT and TSLA",
         subtitle = "Data from 2016-01-10 to 2018-01-10",
         caption = "source: Yahoo Finance") +
    scale_color_hue(labels = c("MSFT", "TSLA")) +
    theme_ipsum_rc() +
    theme(legend.position = c(0.1,0.9),
          legend.title=element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank())
          #plot.title = element_text(size = 14),

ggsave("stock_plot.png", dpi = 700)
          
