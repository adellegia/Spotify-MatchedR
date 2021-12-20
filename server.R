# III. Define server logic for random distribution app ---------------------------------------------------------------
server <- function(input, output, session) {
  
  # Data ----
  #Read data into server not ui
  data<-read.csv("users_data_Spotify.csv")
  
  #Re-read data for any changes, write to csv new changes, ignore startup
  observeEvent(input$goButton,{
    data<-read.csv("users_data_Spotify.csv")
    write.csv(data,"users_data.csv")
    ignoreInit=T
  })
  
  #Reactive variable xchange that updates the values of data
  xchange<-reactive({
    data<-read.csv("users_data.csv") %>%
      filter(user_id == input$userid1 | user_id == input$userid2) %>%
      filter(year == input$year)
    data
  })
  
  # Tab 1: Compatibility ----
  c1 <- as.data.frame(metricslist)
  
  c2 <- reactive({
    value <- c()
    for(k in 1:length(metricslist)){
      x <- xchange() %>% 
        filter(user_id == input$userid1) %>% 
        select(metricslist[k])
      x <- as.vector(x[,1])
      
      y <- xchange() %>% 
        filter(user_id == input$userid2) %>% 
        select(metricslist[k]) 
      y <- as.vector(y[,1])
      
      dist <- cosine(x,y)
      value[k] <- dist * 100
      ave <- c("overall", mean(value))
    }
    
    score <- cbind(c1, value) %>% 
      rbind(., ave)
    score
    
  })
  
  c3 <- reactive({
    c2() %>% 
      rename(metrics = metricslist) %>% 
      mutate(avg = ifelse(metrics == "overall", 1, 0),
             metricslist = factor(metrics),
             metricslist = fct_relevel(metrics, "overall", after = 5),
             label = ifelse(avg == 1, paste0(round(as.numeric(value),2), "%"), ""),
             value = as.numeric(value))
  })
  
  observeEvent(input$goButton,{
    output$plot3 <- renderPlotly({
      p3 <- c3() %>%      
        ggplot(aes(x = value, y = metrics, label = label)) +
        geom_point(aes(color = as.character(avg), size = as.character(avg), alpha = as.character(avg))) + 
        geom_text(color = "white") +
        charts.theme + 
        theme(panel.grid.major = element_line(color = "transparent", linetype = 2),
              text = element_text(family = "Arial"),
              legend.position="none") + 
        scale_size_manual(values = c(10, 35)) + 
        scale_color_manual(values = c("#007db7", "#8dc63f")) +
        scale_alpha_manual(values = c(0.7, 0.9)) + 
        scale_x_continuous(limits = c(0,100), breaks = c(0, 10, 20, 30, 40, 50, 
                                                         60, 70, 80, 90, 100)) +
        guides(size = "none", fill = "none",  color = "none") + 
        xlab("similarity score (%)") +
        ylab("")
      
      ggplotly(p3, tooltip = c("x", "y"), height = 450)
    })
    
    br()
    
    output$table4 <- renderTable({
      intersect(
        (xchange() %>%
           mutate(songs = paste0(tracks, " by ", artist)) %>% 
           filter(user_id == input$userid1) %>% 
           select(songs) %>% rename(`Song Title` = songs)),
        (xchange() %>% 
           mutate(songs = paste0(tracks, " by ", artist)) %>% 
           filter(user_id == input$userid2) %>% 
           select(songs) %>% rename(`Song Title` = songs))
      )
    })
    
    output$table5 <- renderTable({
      intersect(
        (xchange() %>%
           filter(user_id == input$userid1) %>% 
           select(artist) %>% rename(`Artist` = artist)),
        (xchange() %>% 
           filter(user_id == input$userid2) %>% 
           select(artist) %>% rename(`Artist` = artist))
      )
    })
  })
  
  # Tab 2: Metrics Plots ----
  d1 <- reactive({
    xchange() %>%
      mutate(user_id = ifelse(user_id == input$userid1, "User1", "User2")) %>%
      group_by(user_id) %>%
      summarise(valence = mean(valence, na.rm = T),
                energy = mean(energy, na.rm = T),
                speechiness = mean(speechiness, na.rm = T),
                danceability = mean(danceability, na.rm = T),
                popularity = mean(popularity, na.rm = T)) %>%
      as.data.frame() %>%
      pivot_longer(cols = valence:popularity, names_to = "metric", values_to = "value")
  })
  
  d2 <- reactive({
    xchange() %>%
      mutate(user_id = ifelse(user_id == input$userid1, "User1", "User2")) %>%
      select(valence, energy, popularity, speechiness, danceability, user_id, display_name) %>%
      pivot_longer(cols = c(valence, energy, popularity, speechiness, danceability), names_to = "metric", values_to = "value")
  })
  
  s1 <- reactive({
    xchange() %>%
      select(valence, energy, popularity, speechiness, danceability, user_id, display_name) %>%
      filter(user_id == input$userid1) %>%
      rename(valence1 = valence, energy1 = energy, popularity1 = popularity,
             speechiness1 = speechiness, danceability1 = danceability) %>%
      #setnames(old = c("valence", "energy", "popularity", "speechiness", "danceability"), 
      #        new = c("valence1", "energy1", "popularity1", "speechiness1", "danceability1")) %>%
      select(-c(user_id, display_name))
  })
  
  s2 <- reactive({
    xchange() %>%
      select(valence, energy, popularity, speechiness, danceability, user_id, display_name) %>%
      filter(user_id == input$userid2) %>%
      rename(valence2 = valence, energy2 = energy, popularity2 = popularity,
             speechiness2 = speechiness, danceability2 = danceability) %>%
      #setnames(old = c("valence", "energy", "popularity", "speechiness", "danceability"), 
      #        new = c("valence2", "energy2", "popularity2", "speechiness2", "danceability2")) %>%
      select(-c(user_id, display_name))
  })
  
  d3 <- reactive({
    cbind(s1(), s2()) %>%
      mutate(valence = cor(valence1, valence2),
             energy = cor(energy1, energy2),
             popularity = cor(popularity1, popularity2),
             speechiness = cor(speechiness1, speechiness2),
             danceability = cor(danceability1, danceability2)) %>%
      select(valence, energy, popularity, speechiness, danceability) %>%
      pivot_longer(cols = c(valence, energy, popularity, speechiness, danceability), names_to = "metric", values_to = "Correlation") %>%
      head(5)
  })
  
  observeEvent(input$goButton,{
    output$plot1 <- renderPlotly({
      p1 <- d1() %>%      
        ggplot(aes(x=metric, y=value, group = user_id, fill = user_id)) +
        geom_bar(position="dodge", stat="identity", alpha = 0.9, width = 0.8) +
        scale_fill_manual(values = c("#007db7", "#8dc63f"), name = "") +
        charts.theme + 
        theme(axis.title = element_text(size = 9),
              axis.ticks = element_blank(),
              legend.title = element_blank(),
              legend.key.size = unit(.5, 'cm'),
              legend.position = "bottom",
              legend.direction = "horizontal", legend.text=element_text(size=6),
              panel.background = element_rect(fill = "white", colour = "white"),
              panel.grid = element_line(color = "gray84", size = .05, linetype = 1),
              text = element_text(family = "Arial")) +
        labs(x = "Musical Metrics", y = "Index",
             title = "") +
        ylim(0,1) +
        guides(fill = guide_legend(override.aes = list(size = 1)))
      
      ggplotly(p1, height = 400)
    })
    
    br()
    
    output$plot2 <- renderPlotly({
      p2 <- d2() %>%  
        ggplot(aes(x = metric, y = value, color = factor(user_id))) +
        scale_color_manual(values = c("#007db7", "#8dc63f")) +
        geom_boxplot(width = 0.50, color = "grey33", size = 0.4) +
        geom_jitter(alpha= 0.3) +
        coord_flip() +
        labs(y = "Index", x = "Musical Metric",
             title = "") +
        facet_wrap(~user_id) +
        charts.theme + 
        theme(axis.title = element_text(size = 9),
              axis.ticks = element_blank(),
              legend.title = element_blank(),
              legend.key.size = unit(.5, 'cm'),
              legend.position = "none",
              legend.direction = "horizontal", legend.text=element_text(size=6),
              text = element_text(family = "Arial")) +
        guides(color = guide_legend(override.aes = list(size = 2, alpha = 1)))
      
      ggplotly(p2, height = 400)
    })
    
    br()
    
    output$table3 <- renderTable({
      d3() %>% rename(`Musical Metric` = metric)
    })
    
  })
  
  
  # Tab 3: Top 10 Songs ----
  observeEvent(input$goButton,{
    output$table1 <- renderTable({
      xchange() %>%
        filter(user_id == input$userid1) %>%
        select(artist, tracks) %>%
        rename(Artist = artist, `Song Title` = tracks) %>% head(10)}
      #,caption = "Top 10 Songs of User1"
    )
    
    output$table2 <- renderTable({
      xchange() %>%
        filter(user_id == input$userid2) %>%
        select(artist, tracks) %>%
        rename(Artist = artist, `Song Title` = tracks) %>% head(10)}
      #,caption = "Top 10 Songs of User2"
    )
  })
  
}