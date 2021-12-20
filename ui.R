# I. Setup -------------------------------------------------------------------
users <- c(" " = " ",
           "Adelle" = "12153873361",
           "Jyrus" = "husaymonji",
           "Meg" = "arbo.meg",
           "Nikki" = "cyoxmivcwl83tazeq920z7yoz",
           "Janine" = "yopotatooo"
)

metrics <- c(
  "Valence" = "valence",
  "Energy" = "energy",
  "Speechiness" = "speechiness",
  "Danceability" = "danceability",
  "Popularity" = "popularity"
)

metricslist <- c("danceability",
                 "energy",
                 "loudness",
                 "speechiness",
                 "acousticness",
                 "instrumentalness",
                 "liveness",
                 "valence",
                 "tempo",
                 "popularity")

years <- c(2018, 2019, 2020)

# II. Define UI ---------------------------------------------------------------
ui <- fluidPage(
  
  # App title ----
  titlePanel("Spotify MatchedR"),
  tags$head(tags$style(
    HTML('#title {
           font-size: 50px;
           font-style: bold;
          }'))),
  helpText("Find out your music taste compatibility!"),
  
  # App design ----
  theme = shinytheme("slate"), #"cerulean"
  #div(style = "background: 000026.jpg"),
  setBackgroundImage(
    src = "000026.JPG"
  ),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(width = 3,
                 
                 # Input: Select the userids and year 
                 h4("Input"),
                 selectInput("userid1", "Spotify User1", users, selected = " "),
                 selectInput("userid2", "Spotify User2", users, selected = " "),
                 selectInput("year", "Year", years, selected = " "),
                 
                 # br() element to introduce extra vertical spacing 
                 br(),
                 
                 actionButton("goButton", "MatchedR!"),
                 verbatimTextOutput("enter"),
                 
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ Welcome, compatibility, Metrics, and Top Tracks 
      tabsetPanel(type = "tabs",
                  tabPanel("Welcome",
                           icon = icon("star"),
                           br(),
                           p("The", strong("Spotify MatchedR"), "is MatcheR app that lets you and your friends measure your music taste compatibility based on the songs you listen to on Spotify!",
                             "The app is built through Shiny using R and Spotify for Developers by two aspiring data scientists post-graduate students at the Hertie School.", br(), br(),
                             
                             
                             "Using the 'Rspotify' package in R and Spotify Web API, the developers of this app can download the songs from “Your Top Songs” playlist,",
                             "which is the recap for any year from 2018-2020 of the user’s 100 most listened songs, upon giving us your consent.", 
                             "This app uses a matching algorithm in R that returns a compatibility score based on the songs, artists, and genres that the two users have in common.",
                             br(), br(),
                             strong("Let's get started!"), "First, you must add 'Your Top Songs' playlist for the chosen year to your Spotify library.",
                             "Since we are using the Spotify Web API to retrieve your data, please make sure that you make your playlist public for your Spotify data to be accessible by the app.", br(), br(),
                             
                             "Please note that app is still in its initial stage and we give you a demonstration of how it works using the Spotify data of four users.",
                             "If you want to be included in this demo, please contact us through our email address provided at the bottom of this page.", "Thank you!",
                             
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           br()
                  ),
                  tabPanel("Compatibility", 
                           icon = icon("heart"),
                           br(),
                           p("Welcome! In this tab you will see your music taste compatibility with another user. Compatibility is measured by comparing the key features of your Top 100 Songs and matched songs and artists.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           br(),
                           h3("Your Similarity Score"), 
                           p("The similarity score is determined by comparing 10 key metrics of the users' Top 100 tracks. 
                             The similarity/dissimilarity in the values of the metrics are measured using cosine distances. 
                             The distances are expressed as percentages and averaged to get an overall similarity score for two users.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           plotlyOutput("plot3"),
                           br(), br(), br(), 
                           h3("Matched Songs"),
                           p("These are songs that are in both users' Top 100 tracks.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           tableOutput("table4"),
                           br(),
                           h3("Matched Artists"),
                           p("These are artists that are in both users' Top 100 tracks.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           tableOutput("table5"),
                           br()
                  ),
                  tabPanel("Metrics",
                           icon = icon("music"),
                           br(),
                           p("Now that you know your music taste compatibility, let's dig in deeper and analyze your Spotify data!",br(),
                             "We analyzed five musical metrics of your top songs", "to compare with your friend!",
                             br(),br(),
                             em("1. Danceability"), "describes how suitable a track is for dancing based on a combination of musical elements,", 
                             "including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.",br(), br(),
                             em("2. Energy"), "is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity.", 
                             "Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale.", 
                             "Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.", br(), br(),
                             em("3. Popularity"), "The popularity of the artist. The value will be between 0 and 1, with 1 being the most popular. The artist's popularity is calculated from the popularity of all the artist's tracks.", br(), br(),
                             em("4. Speechiness")," detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value.", 
                             "Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered,", 
                             "including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.", br(), br(),
                             em("5. Valence"), "A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric),", 
                             "while tracks with low valence sound more negative (e.g. sad, depressed, angry).",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           
                           p("Source: Spotify for Developers, 2021", 
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px;font-size:10px"),
                           
                           br(),
                           h3("Average Values of Musical Metrics"),
                           p("The barplot below compares the average values of the five musical metrics of your Top 100 songs. Let's check how close or far the mean values are for the users.", 
                             "This gives us an overview of how similar the music taste of the users based on the five metrics.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           plotlyOutput("plot1"),
                           br(),
                           h3("Distribution of Musical Metrics"),
                           p("The boxplots below show the distribution of these metrics and compare the spread of the song features per user.",
                             "The box represents the interquartile range of the values and the line inside the box is the median value.",
                             "The end of the tails represent the minimum (right) and maximum (left) values of the data.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           plotlyOutput("plot2"),
                           br(),
                           h3("Correlation of Musical Metrics"),
                           p("We also calculate the correlation of the musical metrics of the two users.", 
                             "A correlation measures the strength or the extent to which each metric of the two users are linearly related and varies from 0 to 1.",
                             "A positive value means that there's a positive relatioship between a certain metric of your top 100 tracks, otherwise, it's negative!", 
                             "A positive correlation means that a certain metric of the two users tend to move in the same direction while a negative value means they move in the opposite direction.",
                             "We take values below 0.6 to have low correlations, and values of greater than or equal to 0.6 to have high correlations.",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           tableOutput("table3"),
                           br()),
                  tabPanel("Top Tracks",
                           icon = icon("table"),
                           br(),
                           p("Just in case you want to reminisce some songs from the past. We got you covered!", br(),
                             "We have compiled a list of your top songs! Here are the top 10 tracks you listened to on Spotify!",
                             style="text-align:justify;color:white;background-color:#141414;padding:15px;border-radius:10px"),
                           h3("Top 10 Tracks of User1"),
                           tableOutput("table1"),
                           br(),
                           h3("Top 10 Tracks of User2"),
                           tableOutput("table2"),
                           br())
      ),
      br(), br(), br(), br(),
      p(em("PRIVACY POLICY", br(),
           "This privacy policy will explain how Spotify matchedR uses the anonymized personal data we collect from you when you use our website. The Spotify MatchedR does not keep personally identifiable data.", br(),br(),
           
           "What data do we collect?", br(),
           "You directly provide The Spotify MatchedR with most of the data we collect. We collect data and process data when you:", br(),
           "•	Allow the program to access your Spotify data when you login. This is never personally identifiable", br(), br(),
           
           "We may also receive your data indirectly from the following sources:", br(),
           "•	Your browser’s cookies when you use or view our website", br(),
           "•	Third-party partners including Facebook and Twitter", br(),
           "•	Spotify, for our AI music project. No Spotify data is stored, and you can remove ties between your Spotify account and the project by clicking remove access for “Bad Music” on Spotify’s 3rd Party app page here.", br(),
           "•	Location information when we provide localized content (ex: Human Terrain, What City is the Microbrew Capital of the US?). Location data is no more granular than a reader’s city and is not tied to any other personal information.", br(),br(),
           
           "How will we use your data?", br(),
           "The Spotify matchedR project will only use the data you have provided in order to determine the compatibility of music tastes between two users and analyze specific metrices in the appetite of each consumer.", br(),br(),
           
           "Cookies", br(),
           "When you visit a website, the website logs information to the browser, creating a text file called a cookie. Cookies collect standard internet and visitor behavior information, such as whether you are logged in, what you’ve placed in your shopping cart, or what preferences you have set. The Spotify MatchedR may collect analytics information from you automatically through cookies or similar technology.", br(),
           "For further information, visit allaboutcookies.org. You can set your browser not to accept cookies, and the previously linked site tells you how to remove cookies from your browser. However, in a few cases, some of our website features may not function if you remove or disable cookies.", br(),br(),
           
           "Privacy policies of other websites", br(),
           "Our privacy policy only applies to our website. If you click on a link and get directed to another website, please read their privacy policy.", br(), br(),
           
           "Changes to our privacy policy", br(),
           "The Spotify MatchedR keeps its privacy policy under regular review and places any updates on this web page. This privacy policy was last updated on December 2021.", br(),br(),
           
           "How to contact us", br(),
           "If you have any questions about our privacy policy, the data we hold on you, or you would like to exercise one of your data protection rights, please do not hesitate to contact us.", br(), br(),
           
           "Email us at: 216132@hertie-school.org or 219848@hertie-school.org", br(),
           style = "font-size:11px"))
      
    )
  )
)
