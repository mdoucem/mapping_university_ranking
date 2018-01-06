###
# The following script takes the names of the top 5 ranked Universities and Computer Science
# departments around the world and maps them on a world map.
###

library(ggmap)
library(maptools)
library(maps)
library(RColorBrewer)
library(SDMTools)

## Create color palette for the maps based on population. 
## Purples for the universities, and blues for the Computer Science departments

data("world.cities")
# Calculate world population by country
world.pop = aggregate(x=world.cities$pop, by=list(world.cities$country.etc),
                      FUN=sum)
world.pop = setNames(world.pop, c('Country', 'Population'))

# Create a color palette
paletteP = colorRampPalette(brewer.pal(n=9, name='Purples'))(nrow(world.pop))
paletteB = colorRampPalette(brewer.pal(n=9, name='Blues'))(nrow(world.pop))

# Sort the colors in the same order as the countries' populations
paletteP = paletteP[rank(-world.pop$Population)]
paletteB = paletteB[rank(-world.pop$Population)]


##-----------top 5 Universities' locations-----------##
#1 top 5 unis in North America
uniAm<-c("Cambridge, Massachusetts", "Stanford, California", "Cambridge, Massachusetts",
         "Pasadena, California", "Chicago, Illinois")
#2 top 5 unis in Europe
uniEu<-c("Cambridge, England", "Oxford, England", "London", "London", "Zurich, Switzerland")

#3 top 5 unis in Asia
uniAs<-c("Singapore", "Singapore", "Beijing", "Pokfulam, Hong Kong", "Tokyo")

#4 top 5 unis in Oceania
uniOc<-c("Canberra", "Melbourne", "Melbourne", "Auckland", "Perth, Western Australia")

#5 top 5 unis in Middle East - excluding the African ones
uniAr<-c("Jerusalem, Israel", "Dhahran, Saudi Arabia", "Tel Aviv, Israel", "Riyadh, Saudi Arabia", "Haifa, Israel")

#6 top 5 unis in Africa
uniAf<-c("Cape Town, SA", "Stellenbosch, SA", "Johannesburg, SA", "New Cairo, Egypt", "Giza, Egypt")

#7top 5 unis in South America
uniSA<-c("Buenos Aires, Argentina", "Sao Paulo, Brazil", "Santiago, Chile", "Bogota, Colombia", "Rio de Janeiro, Brazil")

# You many need to split the geocoding below as many calls can result in a limit error
ll.university<-geocode(c(uniAm, uniEu, uniAs, uniOc, uniAr, uniAf, uniSA))  

uni.x<-ll.university$lon
uni.y<-ll.university$lat


#Map the universities locations and save in a pdf
pdf("topuniversities.pdf")
map("world", fill = TRUE, col = paletteP, bg = "white",
    ylim = c(-60, 90), mar = c(0,0,0,0))
x = c(-20, -15, -15, -20)
y = c(0, 60, 60, 0)
legend.gradient(cbind(x = x - 150, y = y - 40), 
                cols = brewer.pal(n=9, name='Purples'), title = "Population", limits = "")
points(uni.x, uni.y, col = "red", pch = 19, cex=0.8)
title(main = "Top 5 Universities Around the World")
## Uncomment 'pointLabel() below for automatically adding labels using a vector list of corresponding university names. 
## But I couldn't get them to look nice, thus I added them only afterwards.
#pointLabel(uni.x, uni.y, labels = uniNames, cex = 0.7, allowSmallOverlap = FALSE, pos=3, col="yellow") 
dev.off()



##-----------top 5 CS department's locations-----------##

#1 top 5 in North America
uniCSAm<-c("Cambridge, Massachusetts", "Stanford, California", "Pittsburgh, Pennsylvania", "Berkeley, California", "Cambridge, Massachusetts")
#2 top 5 unis in Europe
uniCSEu<-c("Cambridge, England", "Oxford, England", "Zurich, Switzerland", "London", "Edinburgh, Scotland")

#3 top 5 in Asia
uniCSAs<-c("Singapore", "Beijing", "Beijing", "Tokyo", "Hong Kong")

#4 top 5 in Oceania
uniCSOcs<-c("Melbourne", "Canberra, Australia", "Sydney", "Sydney", "Melbourne, Victoria")

#5 top 5 in Middle East - excluding the African ones
uniCSAr<-c("Haifa, Israel", "Tel Aviv, Israel", "Jerusalem, Israel", "Dhahran, Saudi Arabia", "Riyadh, Saudi Arabia")

#6 top 5 in Africa
uniCSAf<-c("Cape Town, SA", "Pretoria, SA")

#7top 5 in South America
uniCSSA<-c("Sao Paulo, Brazil", "Sao Paulo, Brazil", "Santiago, Chile", "Santiago, Chile", "Belo Horizonte, Brazil")

# You many need to split the geocoding below as many calls can result in a limit error
cs.university<-geocode(uniCSAm, uniCSEu, uniCSAs, uniCSOcs, uniCSAr, uniCSAf, uniCSSA)

uniCS.x<-cs.university$lon
uniCS.y<-cs.university$lat

#Map the Computer Science department locations and save as pdf
pdf("csdepartments.pdf")
map("world", fill = TRUE, col = paletteB, bg = "white",
    ylim = c(-60, 90), mar = c(0,0,0,0))
x = c(-20, -15, -15, -20)
y = c(0, 60, 60, 0)
legend.gradient(cbind(x = x - 150, y = y - 40), 
                cols = brewer.pal(n=9, name='Blues'), title = "Population", limits = "")
points(uniCS.x, uniCS.y, col = "red", pch = 19, cex=0.8)
title(main = "Top 5 Computer Science Departments Around the World")
dev.off()
