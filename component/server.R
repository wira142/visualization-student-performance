library(shiny)
library(shinythemes)
library(ggplot2)
library(DT)
library(scales)

db <- read.csv('../dataset.csv', sep = ',')

shinyServer(function(input, output) {
 output$mytable = DT::renderDataTable(
  DT::datatable({
   db
  },
  options = list(lengthMenu=list(c(5,15,25),c(5,15,25)),pageLength=5,
                 initComplete = JS(
                  "function(settings, json) {",
                  "$(this.api().table().header()).css({'background-color': 'moccasin', 'color': '1c1b1b'});",
                  "}"),
                 columnDefs=list(list(className='dt-center',targets="_all"))
  )),
 )
group <- reactive({
    gender <- data.frame(
        gender=c("male","female"),
        value=c(
            length(db[which(db$race.ethnicity == as.character(input$precented_group) & db$gender == "male"),2]),
            length(db[which(db$race.ethnicity == as.character(input$precented_group) & db$gender == "female"),2])
            )
        )
})
testPreparation <- reactive({
    gender <- data.frame(
        status=c("Tidak Persiapan","Melakukan Persiapan"),
        value=c(
            length(db[which(db$test.preparation.course == "none" & db$race.ethnicity == as.character(input$test_preparation)),5]),
            length(db[which(db$test.preparation.course == "completed" & db$race.ethnicity == as.character(input$test_preparation)),2])
            )
        )
})
mathScore <- reactive({
    value <-  c(
        length(db[which(db$gender == "female" & db$race.ethnicity == "group A" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group A" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group B" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group B" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group C" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group C" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group D" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group D" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group E" & db$math.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group E" & db$math.score >= input$bins),2])
    )
    value
})
readingScore <- reactive({
    value <-  c(
        length(db[which(db$gender == "female" & db$race.ethnicity == "group A" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group A" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group B" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group B" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group C" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group C" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group D" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group D" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group E" & db$reading.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group E" & db$reading.score >= input$bins),2])
    )
    value
})
writingScore <- reactive({
    value <-  c(
        length(db[which(db$gender == "female" & db$race.ethnicity == "group A" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group A" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group B" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group B" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group C" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group C" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group D" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group D" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "female" & db$race.ethnicity == "group E" & db$writing.score >= input$bins),2]),
        length(db[which(db$gender == "male" & db$race.ethnicity == "group E" & db$writing.score >= input$bins),2])
    )
    value
})
score <- reactive ({
    group <- c(rep("group A", 2),rep("group B", 2),rep("group C", 2),rep("group D", 2),rep("group E", 2))
    gender <- rep(c("female" , "male"), 5)   
    value <- if (as.character(input$scoreTarget) == "reading") {
       readingScore()
    }else if (as.character(input$scoreTarget) == "math") {
       mathScore()
    }else if (as.character(input$scoreTarget) == "writing") {
       writingScore()
    }
    data <- data.frame(group, gender,value)
})
 
 output$genderGroup =renderPlot(
  ggplot(group(), aes(x = "", y = value, fill = gender)) +
  geom_col(color = "white") +
  geom_text(aes(label = percent(floor(value/sum(value)*100)/100)),
            size=6,
            position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y")+ theme_void() +
  guides(fill = guide_legend(title = "Jenis Kelamin"))+
  scale_fill_discrete(labels = c("Perempuan", "Laki-Laki"))
 )
 output$testPreparation =renderPlot(
  ggplot(testPreparation(), aes(x = "", y = value, fill = status)) +
  geom_col(color = "white") +
  geom_text(aes(label = percent(floor(value/sum(value)*100)/100)),
            size=6,
            position = position_stack(vjust = 0.5)) +
  coord_polar(theta = "y")+ theme_void() + 
  guides(fill = guide_legend(title = "Staus Persiapan"))+
  scale_fill_discrete(labels = c("Tidak persiapan", "Melakukan persiapan"))
 )
output$scoreExamp = renderPlot(
    ggplot(score(), aes(fill=gender, y=value, x=group)) + 
    geom_bar(position="dodge", stat="identity")
)

})