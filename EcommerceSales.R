# ============================================================
#   Click "Run App" in RStudio OR run:
# ============================================================


# ── LIBRARIES ────────────────────────────────────────────────
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(lubridate)
library(scales)
library(DT)
library(plotly)


# ── LOAD & CLEAN DATA ────────────────────────────────────────
salesdata <- read.csv("C:/Users/vivek/Desktop/R presentation/data.csv", stringsAsFactors = FALSE)

salesdata$InvoiceDate <- mdy_hm(salesdata$InvoiceDate)
salesdata$CustomerID  <- as.character(salesdata$CustomerID)
salesdata$CustomerID[is.na(salesdata$CustomerID)] <- "Unknown"

salesdata <- salesdata %>%
  distinct() %>%
  filter(!grepl("^C", InvoiceNo), Quantity > 0) %>%
  mutate(
    TotalAmount = Quantity * UnitPrice,
    Month       = floor_date(InvoiceDate, "month"),
    MonthName   = format(InvoiceDate, "%b %Y"),
    YearNum     = year(InvoiceDate)
  )

# All countries for filter dropdown
all_countries <- c("All", sort(unique(salesdata$Country)))

# Shared ggplot theme
dt <- theme_minimal(base_size = 13) +
  theme(
    plot.title       = element_text(face = "bold", size = 14),
    plot.subtitle    = element_text(color = "grey55", size = 11),
    axis.text        = element_text(color = "grey45", size = 10),
    axis.title       = element_text(color = "grey35", size = 11),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    plot.margin      = margin(10, 14, 10, 14)
  )


# ============================================================
#  UI
# ============================================================
ui <- dashboardPage(
  skin = "blue",
  
  # ── Header ─────────────────────────────────────────────────
  dashboardHeader(
    title = tags$span(
      style = "font-weight:600; font-size:15px;",
      "E-Commerce Sales | Group K"
    )
  ),
  
  # ── Sidebar ────────────────────────────────────────────────
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Overview",           tabName = "overview",  icon = icon("gauge")),
      menuItem("Revenue Trend",      tabName = "revenue",   icon = icon("chart-line")),
      menuItem("Country Sales",      tabName = "country",   icon = icon("globe")),
      menuItem("Product Analysis",   tabName = "products",  icon = icon("boxes-stacked")),
      menuItem("Order Distribution", tabName = "orders",    icon = icon("chart-bar")),
      menuItem("Raw Data",           tabName = "rawdata",   icon = icon("table"))
    ),
    
    hr(),
    
    # Global filter — Country
    tags$div(
      style = "padding: 0 14px;",
      tags$p(
        style = "color:#aaa; font-size:12px; margin-bottom:4px;",
        "Filter by Country"
      ),
      selectInput("sel_country", label = NULL,
                  choices = all_countries, selected = "All",
                  width = "100%")
    ),
    
    tags$div(
      style = "padding: 6px 14px 0;",
      tags$p(
        style = "color:#aaa; font-size:12px; margin-bottom:4px;",
        "Top N Products / Countries"
      ),
      sliderInput("top_n", label = NULL,
                  min = 5, max = 20, value = 10, step = 1,
                  width = "100%")
    ),
    
    tags$div(
      style = "padding: 18px 14px 6px; color:#888; font-size:11px;",
      "Galgotias University",
      tags$br(), "MCA — Data Science with R",
      tags$br(), "May 2026"
    )
  ),
  
  # ── Body ───────────────────────────────────────────────────
  dashboardBody(
    
    # Custom CSS
    tags$head(tags$style(HTML("
      .skin-blue .main-header .logo {
        background-color: #1a3a5c !important;
        font-weight: 600;
      }
      .skin-blue .main-header .navbar {
        background-color: #1a3a5c !important;
      }
      .skin-blue .main-sidebar {
        background-color: #1e2a38 !important;
      }
      .skin-blue .main-sidebar .sidebar .sidebar-menu > li.active > a {
        border-left: 3px solid #1D9E75;
      }
      .small-box { border-radius: 8px !important; }
      .box       { border-radius: 8px !important; border-top: 0 !important; }
      body, .content-wrapper { background-color: #f4f6f9 !important; }
      .box-title { font-weight: 600 !important; font-size: 13px !important; }
    "))),
    
    tabItems(
      
      # ════════════════════════════════════════════════════════
      # TAB 1 — OVERVIEW
      # ════════════════════════════════════════════════════════
      tabItem(tabName = "overview",
              
              # KPI row
              fluidRow(
                valueBoxOutput("kpi_revenue",   width = 2),
                valueBoxOutput("kpi_orders",    width = 2),
                valueBoxOutput("kpi_aov",       width = 2),
                valueBoxOutput("kpi_customers", width = 2),
                valueBoxOutput("kpi_products",  width = 2),
                valueBoxOutput("kpi_countries", width = 2)
              ),
              
              # Charts row 1
              fluidRow(
                box(
                  title = "Revenue Trend (Monthly)", status = "primary",
                  solidHeader = TRUE, width = 8, height = 320,
                  plotlyOutput("ov_revenue", height = 265)
                ),
                box(
                  title = "Top Countries", status = "info",
                  solidHeader = TRUE, width = 4, height = 320,
                  plotlyOutput("ov_country", height = 265)
                )
              ),
              
              # Charts row 2
              fluidRow(
                box(
                  title = "Best-Selling Products", status = "success",
                  solidHeader = TRUE, width = 6, height = 320,
                  plotlyOutput("ov_products", height = 265)
                ),
                box(
                  title = "Order Value Distribution", status = "warning",
                  solidHeader = TRUE, width = 6, height = 320,
                  plotlyOutput("ov_orders", height = 265)
                )
              )
      ),
      
      # ════════════════════════════════════════════════════════
      # TAB 2 — REVENUE TREND
      # ════════════════════════════════════════════════════════
      tabItem(tabName = "revenue",
              fluidRow(
                box(
                  title = "Monthly Revenue (£)", status = "primary",
                  solidHeader = TRUE, width = 12,
                  plotlyOutput("rev_line", height = 380)
                )
              ),
              fluidRow(
                box(
                  title = "Monthly Transaction Volume", status = "info",
                  solidHeader = TRUE, width = 12,
                  plotlyOutput("rev_bar", height = 300)
                )
              )
      ),
      
      # ════════════════════════════════════════════════════════
      # TAB 3 — COUNTRY SALES
      # ════════════════════════════════════════════════════════
      tabItem(tabName = "country",
              fluidRow(
                box(
                  title = "Revenue by Country", status = "primary",
                  solidHeader = TRUE, width = 8,
                  plotlyOutput("cty_bar", height = 420)
                ),
                box(
                  title = "Country Summary Table", status = "info",
                  solidHeader = TRUE, width = 4,
                  DTOutput("cty_table")
                )
              )
      ),
      
      # ════════════════════════════════════════════════════════
      # TAB 4 — PRODUCT ANALYSIS
      # ════════════════════════════════════════════════════════
      tabItem(tabName = "products",
              fluidRow(
                box(
                  title = "Best-Selling Products (£)", status = "success",
                  solidHeader = TRUE, width = 6,
                  plotlyOutput("prod_best", height = 400)
                ),
                box(
                  title = "Worst-Performing Products (£)", status = "danger",
                  solidHeader = TRUE, width = 6,
                  plotlyOutput("prod_worst", height = 400)
                )
              ),
              fluidRow(
                box(
                  title = "Full Product Table", status = "primary",
                  solidHeader = TRUE, width = 12,
                  DTOutput("prod_table")
                )
              )
      ),
      
      # ════════════════════════════════════════════════════════
      # TAB 5 — ORDER DISTRIBUTION
      # ════════════════════════════════════════════════════════
      tabItem(tabName = "orders",
              fluidRow(
                box(
                  title = "Order Value Distribution (Histogram)", status = "warning",
                  solidHeader = TRUE, width = 8,
                  plotlyOutput("ord_hist", height = 380)
                ),
                box(
                  title = "Order Value Summary", status = "info",
                  solidHeader = TRUE, width = 4,
                  verbatimTextOutput("ord_summary"),
                  tags$hr(),
                  tags$p(style = "font-size:12px; color:grey;",
                         "Most orders fall in the £10–£100 range.",
                         tags$br(),
                         "Large outliers (>£500) indicate B2B bulk buyers.",
                         tags$br(),
                         "Upselling from £10–50 to £50–100 can significantly",
                         "lift total revenue without new customer acquisition."
                  )
                )
              ),
              fluidRow(
                box(
                  title = "Order Value Boxplot (top 1% removed)", status = "primary",
                  solidHeader = TRUE, width = 12,
                  plotlyOutput("ord_box", height = 280)
                )
              )
      ),
      
      # ════════════════════════════════════════════════════════
      # TAB 6 — RAW DATA
      # ════════════════════════════════════════════════════════
      tabItem(tabName = "rawdata",
              fluidRow(
                box(
                  title = "Cleaned Dataset — All Transactions",
                  status = "primary", solidHeader = TRUE, width = 12,
                  DTOutput("raw_table")
                )
              )
      )
      
    ) # end tabItems
  )   # end dashboardBody
)     # end dashboardPage


# ============================================================
#  SERVER
# ============================================================
server <- function(input, output, session) {
  
  # ── Reactive filtered data ──────────────────────────────────
  # Re-runs whenever the country dropdown changes
  dat <- reactive({
    if (input$sel_country == "All") {
      salesdata
    } else {
      salesdata %>% filter(Country == input$sel_country)
    }
  })
  
  # ── Reactive top-N ──────────────────────────────────────────
  top_n_val <- reactive({ input$top_n })
  
  
  # ════════════════════════════════════════════════════════════
  # KPI VALUE BOXES
  # ════════════════════════════════════════════════════════════
  output$kpi_revenue <- renderValueBox({
    rev <- sum(dat()$TotalAmount, na.rm = TRUE)
    valueBox(
      paste0("£", format(round(rev / 1e6, 2), nsmall = 2), "M"),
      "Total Revenue", icon = icon("sterling-sign"), color = "blue"
    )
  })
  
  output$kpi_orders <- renderValueBox({
    valueBox(
      format(n_distinct(dat()$InvoiceNo), big.mark = ","),
      "Total Orders", icon = icon("receipt"), color = "green"
    )
  })
  
  output$kpi_aov <- renderValueBox({
    aov_val <- dat() %>%
      group_by(InvoiceNo) %>%
      summarise(ov = sum(TotalAmount), .groups = "drop") %>%
      summarise(m = mean(ov)) %>% pull(m)
    valueBox(
      paste0("£", format(round(aov_val), big.mark = ",")),
      "Avg Order Value", icon = icon("calculator"), color = "yellow"
    )
  })
  
  output$kpi_customers <- renderValueBox({
    valueBox(
      format(n_distinct(dat()$CustomerID), big.mark = ","),
      "Unique Customers", icon = icon("users"), color = "aqua"
    )
  })
  
  output$kpi_products <- renderValueBox({
    valueBox(
      format(n_distinct(dat()$StockCode), big.mark = ","),
      "Unique Products", icon = icon("boxes-stacked"), color = "purple"
    )
  })
  
  output$kpi_countries <- renderValueBox({
    valueBox(
      n_distinct(dat()$Country),
      "Countries", icon = icon("globe"), color = "orange"
    )
  })
  
  
  # ════════════════════════════════════════════════════════════
  # OVERVIEW TAB CHARTS
  # ════════════════════════════════════════════════════════════
  
  # Overview — Revenue trend (compact)
  output$ov_revenue <- renderPlotly({
    df <- dat() %>%
      group_by(Month) %>%
      summarise(Revenue = sum(TotalAmount), .groups = "drop")
    p <- ggplot(df, aes(x = Month, y = Revenue)) +
      geom_area(fill = "#1D9E75", alpha = 0.15) +
      geom_line(color = "#1D9E75", linewidth = 1.2) +
      geom_point(color = "#1D9E75", size = 2.5) +
      scale_y_continuous(labels = label_dollar(prefix = "£", scale = 1e-3, suffix = "K")) +
      scale_x_datetime(date_labels = "%b %y") +
      labs(x = NULL, y = "Revenue (£)") + dt
    ggplotly(p, tooltip = c("x","y")) %>%
      layout(showlegend = FALSE, margin = list(l=40,r=10,t=10,b=40))
  })
  
  # Overview — Top countries (compact)
  output$ov_country <- renderPlotly({
    df <- dat() %>%
      group_by(Country) %>%
      summarise(TotalSales = sum(TotalAmount), .groups = "drop") %>%
      arrange(desc(TotalSales)) %>% head(5)
    p <- ggplot(df, aes(x = reorder(Country, TotalSales), y = TotalSales)) +
      geom_col(fill = "#185FA5") + coord_flip() +
      scale_y_continuous(labels = label_dollar(prefix = "£", scale = 1e-3, suffix = "K")) +
      labs(x = NULL, y = NULL) + dt
    ggplotly(p, tooltip = c("y")) %>%
      layout(showlegend = FALSE, margin = list(l=10,r=10,t=10,b=10))
  })
  
  # Overview — Best products (compact)
  output$ov_products <- renderPlotly({
    df <- dat() %>%
      group_by(Description) %>%
      summarise(TotalSales = sum(TotalAmount), .groups = "drop") %>%
      arrange(desc(TotalSales)) %>% head(8)
    p <- ggplot(df, aes(x = reorder(Description, TotalSales), y = TotalSales)) +
      geom_col(fill = "#1D9E75") + coord_flip() +
      scale_y_continuous(labels = label_dollar(prefix = "£", scale = 1e-3, suffix = "K")) +
      labs(x = NULL, y = "Revenue (£)") + dt +
      theme(axis.text.y = element_text(size = 9))
    ggplotly(p, tooltip = c("x","y")) %>%
      layout(showlegend = FALSE, margin = list(l=10,r=10,t=10,b=40))
  })
  
  # Overview — Order distribution (compact)
  output$ov_orders <- renderPlotly({
    df <- dat() %>%
      group_by(InvoiceNo) %>%
      summarise(OrderValue = sum(TotalAmount), .groups = "drop") %>%
      mutate(Band = cut(OrderValue,
                        breaks = c(0,10,50,100,250,500,1000,2000,Inf),
                        labels = c("<£10","£10-50","£50-100","£100-250",
                                   "£250-500","£500-1k","£1k-2k",">£2k"),
                        right  = TRUE)) %>%
      count(Band) %>% filter(!is.na(Band))
    p <- ggplot(df, aes(x = Band, y = n, fill = Band)) +
      geom_col(show.legend = FALSE) +
      scale_fill_brewer(palette = "Purples", direction = -1) +
      scale_y_continuous(labels = comma) +
      labs(x = NULL, y = "Orders") + dt +
      theme(axis.text.x = element_text(angle = 25, hjust = 1, size = 9))
    ggplotly(p, tooltip = c("x","y")) %>%
      layout(showlegend = FALSE, margin = list(l=40,r=10,t=10,b=50))
  })
  
  
  # ════════════════════════════════════════════════════════════
  # REVENUE TREND TAB
  # ════════════════════════════════════════════════════════════
  
  output$rev_line <- renderPlotly({
    df <- dat() %>%
      group_by(Month) %>%
      summarise(Revenue = sum(TotalAmount), .groups = "drop")
    p <- ggplot(df, aes(x = Month, y = Revenue,
                        text = paste0(format(Month,"%b %Y"),
                                      "<br>Revenue: £",
                                      format(round(Revenue), big.mark=",")))) +
      geom_area(fill = "#185FA5", alpha = 0.12) +
      geom_line(color = "#185FA5", linewidth = 1.5) +
      geom_point(color = "#185FA5", size = 3.5) +
      scale_y_continuous(labels = label_dollar(prefix = "£", scale = 1e-3, suffix = "K")) +
      scale_x_datetime(date_labels = "%b %Y", date_breaks = "1 month") +
      labs(title = "Monthly Revenue Trend",
           subtitle = "Total revenue earned per month — peaks indicate seasonal demand",
           x = "Month", y = "Revenue (£)") +
      dt + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    ggplotly(p, tooltip = "text") %>%
      layout(showlegend = FALSE)
  })
  
  output$rev_bar <- renderPlotly({
    df <- dat() %>%
      group_by(Month) %>%
      summarise(Txns = n_distinct(InvoiceNo), .groups = "drop")
    p <- ggplot(df, aes(x = Month, y = Txns,
                        text = paste0(format(Month,"%b %Y"),
                                      "<br>Transactions: ", Txns))) +
      geom_col(fill = "#BA7517", alpha = 0.85, width = 20*24*3600) +
      scale_x_datetime(date_labels = "%b %Y", date_breaks = "1 month") +
      scale_y_continuous(labels = comma) +
      labs(title = "Monthly Transaction Volume",
           subtitle = "Number of unique invoices per month",
           x = "Month", y = "Transactions") +
      dt + theme(axis.text.x = element_text(angle = 45, hjust = 1))
    ggplotly(p, tooltip = "text") %>%
      layout(showlegend = FALSE)
  })
  
  
  # ════════════════════════════════════════════════════════════
  # COUNTRY TAB
  # ════════════════════════════════════════════════════════════
  
  output$cty_bar <- renderPlotly({
    df <- dat() %>%
      group_by(Country) %>%
      summarise(TotalSales = sum(TotalAmount), .groups = "drop") %>%
      arrange(desc(TotalSales)) %>% head(top_n_val())
    p <- ggplot(df, aes(x = reorder(Country, TotalSales), y = TotalSales,
                        text = paste0(Country, "<br>Revenue: £",
                                      format(round(TotalSales), big.mark=",")))) +
      geom_col(fill = "#185FA5") + coord_flip() +
      scale_y_continuous(labels = label_dollar(prefix = "£", scale = 1e-3, suffix = "K"),
                         expand = expansion(mult = c(0, 0.12))) +
      labs(title = paste("Top", top_n_val(), "Countries by Revenue"),
           subtitle = "UK dominates; strong EU markets offer expansion potential",
           x = NULL, y = "Total Revenue (£)") + dt
    ggplotly(p, tooltip = "text") %>% layout(showlegend = FALSE)
  })
  
  output$cty_table <- renderDT({
    dat() %>%
      group_by(Country) %>%
      summarise(
        Orders   = n_distinct(InvoiceNo),
        Revenue  = paste0("£", format(round(sum(TotalAmount)), big.mark=",")),
        .groups  = "drop"
      ) %>%
      arrange(desc(Orders)) %>%
      datatable(rownames = FALSE,
                options = list(pageLength = 12, dom = "tp",
                               scrollY = "380px", scrollCollapse = TRUE))
  })
  
  
  # ════════════════════════════════════════════════════════════
  # PRODUCT TAB
  # ════════════════════════════════════════════════════════════
  
  output$prod_best <- renderPlotly({
    df <- dat() %>%
      group_by(Description) %>%
      summarise(TotalSales = sum(TotalAmount), .groups = "drop") %>%
      arrange(desc(TotalSales)) %>% head(top_n_val())
    p <- ggplot(df, aes(x = reorder(Description, TotalSales), y = TotalSales,
                        text = paste0(Description, "<br>Revenue: £",
                                      format(round(TotalSales), big.mark=",")))) +
      geom_col(fill = "#1D9E75") + coord_flip() +
      scale_y_continuous(labels = label_dollar(prefix = "£", scale = 1e-3, suffix = "K"),
                         expand = expansion(mult = c(0, 0.12))) +
      labs(title = paste("Top", top_n_val(), "Best-Selling Products"),
           x = NULL, y = "Revenue (£)") + dt +
      theme(axis.text.y = element_text(size = 9))
    ggplotly(p, tooltip = "text") %>% layout(showlegend = FALSE)
  })
  
  output$prod_worst <- renderPlotly({
    df <- dat() %>%
      group_by(Description) %>%
      summarise(TotalSales = sum(TotalAmount), .groups = "drop") %>%
      arrange(TotalSales) %>% head(top_n_val())
    p <- ggplot(df, aes(x = reorder(Description, -TotalSales), y = TotalSales,
                        text = paste0(Description, "<br>Revenue: £",
                                      format(round(TotalSales), big.mark=",")))) +
      geom_col(fill = "#D85A30") + coord_flip() +
      scale_y_continuous(labels = label_dollar(prefix = "£"),
                         expand = expansion(mult = c(0, 0.12))) +
      labs(title = paste("Top", top_n_val(), "Worst-Performing Products"),
           subtitle = "Consider removing or replacing these items",
           x = NULL, y = "Revenue (£)") + dt +
      theme(axis.text.y = element_text(size = 9))
    ggplotly(p, tooltip = "text") %>% layout(showlegend = FALSE)
  })
  
  output$prod_table <- renderDT({
    dat() %>%
      group_by(StockCode, Description) %>%
      summarise(
        Units_Sold = sum(Quantity),
        Revenue    = paste0("£", format(round(sum(TotalAmount)), big.mark=",")),
        Customers  = n_distinct(CustomerID),
        .groups    = "drop"
      ) %>%
      arrange(desc(Units_Sold)) %>%
      datatable(rownames = FALSE,
                options = list(pageLength = 10, scrollX = TRUE))
  })
  
  
  # ════════════════════════════════════════════════════════════
  # ORDER DISTRIBUTION TAB
  # ════════════════════════════════════════════════════════════
  
  order_vals_r <- reactive({
    dat() %>%
      group_by(InvoiceNo) %>%
      summarise(OrderValue = sum(TotalAmount), .groups = "drop")
  })
  
  output$ord_hist <- renderPlotly({
    df <- order_vals_r() %>%
      mutate(Band = cut(OrderValue,
                        breaks = c(0,10,50,100,250,500,1000,2000,Inf),
                        labels = c("<£10","£10–50","£50–100","£100–250",
                                   "£250–500","£500–1k","£1k–2k",">£2k"),
                        right  = TRUE)) %>%
      count(Band) %>% filter(!is.na(Band))
    p <- ggplot(df, aes(x = Band, y = n, fill = Band,
                        text = paste0(Band, "<br>Orders: ", n))) +
      geom_col(show.legend = FALSE) +
      scale_fill_brewer(palette = "Purples", direction = -1) +
      scale_y_continuous(labels = comma,
                         expand = expansion(mult = c(0, 0.1))) +
      labs(title = "Distribution of Order Values",
           subtitle = "Most customers spend between £10 and £100 per order",
           x = "Order Value Band", y = "Number of Orders") + dt +
      theme(axis.text.x = element_text(angle = 20, hjust = 1))
    ggplotly(p, tooltip = "text") %>% layout(showlegend = FALSE)
  })
  
  output$ord_summary <- renderPrint({
    ov <- order_vals_r()$OrderValue
    cat("Order Value Statistics\n")
    cat("======================\n")
    cat(sprintf("Min    : £%s\n", format(round(min(ov)),    big.mark=",")))
    cat(sprintf("Q1     : £%s\n", format(round(quantile(ov,0.25)), big.mark=",")))
    cat(sprintf("Median : £%s\n", format(round(median(ov)), big.mark=",")))
    cat(sprintf("Mean   : £%s\n", format(round(mean(ov)),   big.mark=",")))
    cat(sprintf("Q3     : £%s\n", format(round(quantile(ov,0.75)), big.mark=",")))
    cat(sprintf("Max    : £%s\n", format(round(max(ov)),    big.mark=",")))
    cat("======================\n")
    cat(sprintf("Orders > £500 : %d\n", sum(ov > 500)))
    cat(sprintf("Orders < £10  : %d\n", sum(ov < 10)))
  })
  
  output$ord_box <- renderPlotly({
    ov <- order_vals_r() %>%
      filter(OrderValue < quantile(OrderValue, 0.99, na.rm = TRUE))
    p <- ggplot(ov, aes(x = "", y = OrderValue,
                        text = paste0("Order Value: £",
                                      format(round(OrderValue), big.mark=",")))) +
      geom_boxplot(fill = "#7F77DD", alpha = 0.65,
                   outlier.color = "#D85A30", outlier.size = 1.5) +
      scale_y_continuous(labels = label_dollar(prefix = "£")) +
      labs(title = "Spread of Order Values",
           subtitle = "Red dots = outliers (likely bulk/B2B orders)",
           x = NULL, y = "Order Value (£)") + dt +
      theme(axis.text.x = element_blank())
    ggplotly(p, tooltip = "text") %>% layout(showlegend = FALSE)
  })
  
  
  # ════════════════════════════════════════════════════════════
  # RAW DATA TAB
  # ════════════════════════════════════════════════════════════
  
  output$raw_table <- renderDT({
    dat() %>%
      select(InvoiceNo, StockCode, Description,
             Quantity, InvoiceDate, UnitPrice,
             CustomerID, Country, TotalAmount) %>%
      mutate(
        InvoiceDate = format(InvoiceDate, "%Y-%m-%d %H:%M"),
        UnitPrice   = round(UnitPrice,   2),
        TotalAmount = round(TotalAmount, 2)
      ) %>%
      datatable(
        rownames = FALSE,
        filter   = "top",
        options  = list(
          pageLength = 15,
          scrollX    = TRUE,
          autoWidth  = TRUE
        )
      )
  })
  
}


# ============================================================
#  RUN THE APP
# ============================================================
shinyApp(ui = ui, server = server)