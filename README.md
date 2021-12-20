# Final data science project: Spotify-matchedR


## Summary

<b>Spotify-matchedR</b> aims to measure the music taste compatibility of two people based on the songs they listen to on Spotify.    

Using the "Rspotify” package and Spotify Web API, we will download the songs from “Your Top Songs” playlist, which is the recap for any year from 2018-2020 of the user’s 100 most listened songs. We will then build a matching algorithm in R that returns a compatibility score based on the songs, artists, and genres that the two users have in common.   

Using the “plotly” package, we will visualize five musical metrics available on Spotify track audio features, which are:

- <i>danceability</i> or the measure of how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity;
- <i>energy</i> which is the perceptual measure of intensity and activity; 
- <i>popularity</i> of the matched tracks;
- <i>speechiness</i> which is understood by the presence of spoken words in a song, and;
- <i>valence</i> or the measure of musical positivity.

Finally, we will use the "Shiny" package, to deploy the <b>Spotify-matchedR</b> app!

To view and use the app, click [Spotify-MatchedR](https://adellegia.shinyapps.io/data-project-spotify-matchedr/) now!

## Contributors

- Ma. Adelle Gia Arbo ([GitHub](https://github.com/adellegia), [LinkedIn](https://www.linkedin.com/in/ma-adelle-gia-arbo/))
- Janine De Vera ([GitHub](https://github.com/janinepdevera),
[LinkedIn](https://www.linkedin.com/in/janinepdevera/))

## References

- [Rspotify documentation](https://rdrr.io/cran/Rspotify/man/)
- [Shiny Tutorials](https://shiny.rstudio.com/)
- [Spotify for Developers](https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features)

## License

The material in this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). 

## Statement of Contributions

Ma. Adelle Gia Arbo and Janine De Vera worked cooperatively to develop the Spotify MatchedR app.
