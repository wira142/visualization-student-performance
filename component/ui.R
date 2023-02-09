library(shiny)
library(shinythemes)
library(ggplot2)
library(DT)

shinyUI(fluidPage(theme = shinytheme("cerulean"),
  titlePanel("Visualisasi Data Progres Murid"),
    navbarPage("Progress Murid",
      tabPanel("HOME",
        fluidRow(
          style="background-color:#232946;",
          column(5,
            style="margin-bottom:5rem;margin-top:5rem;",
            h2(style="color:white;" ,"Student value record"),
            p(style="color:#B8C1EC;","Pada aplikasi ini memuat sekumpulan data “hasil progres murid” berdasarkan grup yang sudah ditentukan. Data tersebut masih cukup susah dipahami jika dilihat secara langsung. Pada aplikasi ini data tersebut akan diolah terlebih dahulu, kemudian dibuatkan visualisasi dengan berbagai macam bentuk diagram sesuai dengan data yang akan digunakan.")
          ),
          column(12,
            style="margin-bottom:5rem;background-color:#B8C1EC;padding-bottom:3rem;",
            h2(style="color:#232946;","Dataset yang digunakan"),
            DT::dataTableOutput("mytable"),
          ),
          column(12,
            fluidRow(
              style = "background:white;display:flex;align-items:center;justify-content:center;",
              column(4,
                h3("Pilih group untuk melihat perbandingan jumlah murid perempuan dan laki-laki"),
                selectInput("precented_group", 
                  h5("Percentage gender in group"), 
                  choices = list(
                    "Group A" = "group A", 
                    "Group B" = "group B", 
                    "Group C" = "group C", 
                    "Group D" = "group D", 
                    "Group E" = "group E" 
                  ), 
                  selected = "group A")
              ),
              column(6,
                  plotOutput("genderGroup")
              ),
            )
          ),
          column(12,
            fluidRow(
              style = "display:flex;align-items:center;justify-content:center;",
              column(4,
                h3(style="color:#ffffff;","Pilih group untuk melihat presentase murid yang melakukan tes persiapan"),
                selectInput("test_preparation", 
                  h5("Percentage preparation in group"), 
                  choices = list(
                    "Group A" = "group A", 
                    "Group B" = "group B", 
                    "Group C" = "group C", 
                    "Group D" = "group D", 
                    "Group E" = "group E" 
                  ), 
                  selected = "group A")
              ),
              column(6,
              style="padding:3rem 0;",
               plotOutput("testPreparation")
              )
            )
          ),
          column(12,
            style="margin-bottom:5rem",
            fluidRow(
              style = "background:white;display:flex;align-items:center;justify-content:center;",
              column(4,
                h3(style="margin-bottom:4rem","Lihat perbandingan nilai dari setiap kelompok"),
                sliderInput(inputId = "bins",
                  label = "Batas nilai terendah",
                  min = 5,
                  max = 100,
                  value = 70),
                selectInput("scoreTarget", 
                  h5(style="font-weight:bold;color:black","Pilih nilai penentu"), 
                  choices = list(
                    "Math" = "math", 
                    "Reading" = "reading", 
                    "Writing" = "writing"
                  ), 
                  selected = "group A")
              ),
              column(6,
                style="padding:3rem 0;",
                plotOutput("scoreExamp")
              )
            )
          ),
          column(12,
            style="margin-top:2rem;margin-bottom:2rem;text-align:center;",
            h5("Created by Wira & team | 2023"),
          br()
          ),
         )
        )
    )
  )
)