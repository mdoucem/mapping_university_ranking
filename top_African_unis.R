###
# The following script extracts the top ranked African universities
# as listed on the topuniversities.com rankings. Using the extracted university name, the script
# then extracts the country using the Location information in Wikipedia
# departments around the world to be mapped on a world map.
###
library(XML)
library(RCurl)

## Read the lines from the url
con<-url("https://www.topuniversities.com/university-rankings-articles/world-university-rankings/top-universities-africa")
qs_code<-readLines(con)
close(con)

## Find out where the university name is mentioned in the link and remove unneccessary characters
uni_line<-qs_code[grep('<a href="https://www.topuniversities.com/node/' , qs_code)]
uni_line<-gsub("<h2>|</h2>|<a href=\"", "", uni_line)
uni_line<-gsub("Â|</a>|=|\\.", "", uni_line)
uni_line<-gsub("?(f|ht)(tp)(s?)(://)(.*)[.|/]", "", uni_line)
uni_line<-gsub("#wur\"> | \">", "", uni_line)
#uni_line

## Extract the position and the university name
num_line<-uni<-c()
for (i in 1:length(uni_line)){
  num<-substr(uni_line[i], 1, 2)
  num_line<-c(num_line, num)
  line_index<-regexpr(">", uni_line[i])
  #uni_l<-uni_line[i][[line_index:]]
  uni_l<-substr(uni_line[i], line_index+1, nchar(uni_line[i]))
  uni<-c(uni, uni_l)
}
## Tried to automactically extract the country location of the university from Wikiperdia with the following:
## url(paste("https://en.wikipedia.org/wiki/", uni[i], sep=""))
## wiki_lines<-readLines(query)
## close(query)
## loc_line<-wiki_lines[grep('<span class=\"country-name\"><a href=\"/wiki/' , wiki_lines)]
## But the abpve did not work as the wiki source files were not consistent. Thus I just added the country names myself to a list
countries<-c("South Africa", "South Africa", "South Africa", "Egypt", "Egypt", "South Africa",
             "South Africa", "Egypt", "South Africa", "Egypt", "Egypt", "Uganda" , "South African", "Ghana" , "Kenya")

df<-cbind(uni, countries)
colnames(df)<-c("University Name", "Location")
#View(df)

# save dataframe as pdf
library(gridExtra)
pdf("top15African.pdf", height = 11, width = 8.5)
grid.table(df)
dev.off()
