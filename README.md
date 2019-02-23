# LensesPrescription
The current project consists of analysing a multivariate Lenses dataset (https://archive.ics.uci.edu/ml/datasets/lenses). It contains several classes of lenses receipts for the patients based on their characteristics. We aim to consider the data from two different points of view. First, we want to estimate the possibility to separate the data in order to be able to predict the receipt automatically. Second, we are interested in the inner relations within the dataset, whether the patients’ attributes associate to each other and how. The dataset is of a personal interest, due to the fact that I have been using lenses for several years already. 

## Description of the dataset
The data considered are complete and noise free. Also, they highly simplified the problem since the attributes do not fully describe all the factors affecting the decision as to which type, if any, to fit. The purpose of such data to analyze is to test different multivariate techniques without spending time on data preprocessing.

So, the chosen dataset contains ﬁve categorical variables:
1)  Possible classes of recommendation to a patient: 
- ’1’: the patient should be ﬁtted with hard contact lenses, 
- ’2’: the patient should be ﬁtted with soft contact lenses, 
- ’3’: the patient should not be ﬁtted with contact lenses. 
2) Age of the patient: 
- ’1’: young, 
- ’2’: pre-presbyopic, 
- ’3’: presbyopic. 
3) Spectacle prescription: 
- ’1’: myope, 
- ’2’: hypermetrope. 
4) Astigmatic: 
- ’1’: no, 
- ’2’: yes. 
5) Tear production rate: 
- ’1’: reduced, 
- ’2’: normal.

To visualize the data we build a set of piecharts presenting the distribution of different modalities of each variable.
```
columnNames<-c("Age of the patient","Spectacle prescription","Astigmatic","Tear production rate","Type of lense fit")
colors <- c("yellow","red","deeppink3","green2","yellow","pink","green4")
numberOfColumns = dim(data)[2] 

#draw piecharts in a loop
for (i in 1:numberOfColumns){
  #work with data
  currentColumn <- table(data[,i])
  percentages <- round(100*currentColumn/sum(currentColumn),0)
  #work with appearance
  pieLabels<- paste(percentages,"%",sep="")
  selectedColors <- colors[1:length(tmp)]
  ##main title of a piechart
  title <- columnNames[i] 
  ##names in a legend
  legend("topleft",names(percentages),fill=cols,cex=0.8)
  #do the plotting
  pie(currentColumn,main=title,col = selectedColors, labels = pieLabels,cex = 0.8)
}
```
From the gerenated picture below we might conclude that nearly all the variables have same proportion of modalities except ’Possible classes of recommendation’. More than a half of patients should not be ﬁtted with lenses, while the amount of ’hard-lenses’ and ’soft-lenses’ recommendations is nearly the same.

![](images\PieCharts.PNG)

As was mentioned before we want to analyse the data from two diﬀerent points of view. Taking into account the type of its variables, we might conclude that it might be analysed with the following methods:
1) Linear discriminant analysis. We might consider the task of predicting the recommendation for a patient based on his or her medical attributes. 
2) Multiple correspondence analysis. We also may try to determine ’within-dataset’ relations, which might explain the dataset from another point of view.

