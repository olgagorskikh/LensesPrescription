#Data source https://archive.ics.uci.edu/ml/datasets/GPS+Trajectories
data <- read.table("Lenses.txt",header=T,sep="\t")

library(ggplot2)
library(scales)
library(gridExtra)
library(MASS)
library(ca)

#-- 3 Classes of fit
#1 : the patient should be fitted with hard contact lenses, 
#2 : the patient should be fitted with soft contact lenses, 
#3 : the patient should not be fitted with contact lenses. 

#1. age of the patient: (1) young, (2) pre-presbyopic, (3) presbyopic 
#2. spectacle prescription: (1) myope, (2) hypermetrope 
#3. astigmatic: (1) no, (2) yes 
#4. tear production rate: (1) reduced, (2) normal


#----Building Univariate plots---------------------------------

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

#----Linear Discriminant Analysis------------------------------

for (i in 1:dim(data)[1])
{
  if (data[i,"type"]==1) data[i,"type"] = "Hard lenses"
  if (data[i,"type"]==2) data[i,"type"] = "Soft lenses"
  if (data[i,"type"]==3) data[i,"type"] = "No lenses"
}

lda <- lda(formula = type ~ ., 
           data = data, 
           prior = c(1,1,1)/3)

#the singular values, which give the ratio of the between- and within-group
#standard deviations on the linear discriminant variables. 
#Their squares are the canonical F-statistics.
lda$svd 

lda # show results

#----Plot the results of analysis-----------------------------------

predictions <- predict(object = lda, newdata = data[,1:4])
updatedDataset = data.frame(type = data[,"type"], lda = predictions$x)
propoptionsOfLDs = lda$svd^2/sum(lda$svd^2)

plot <- ggplot(updatedDataset) + geom_point(aes(lda.LD1, lda.LD2, colour = type, shape = type), size = 2.5) + 
  
  labs(x = paste("LD1 (", percent(propoptionsOfLDs[1]), ")", sep=""),
       y = paste("LD2 (", percent(propoptionsOfLDs[2]), ")", sep=""))
grid.arrange(plot)

#----Predict new object------------------------------------------

newObject <- matrix(c(1,1,2,2),nrow=1)
dimnames(newObject) <- list(NULL, c("age","prescription","astigmatic","tear_rate"))

newObject <- data.frame(newObject)
predict(lda, newdata=newObject)


#----Multiple correspondence analysis----------------------------

#run the estimation itself
data.mca<-mjca(data,lambda="indicator")

#all summary parameters
names(data.mca)

#here data.mca$sv[1] is the eigenvalue of PC1

# PC1+PC2 overall contribution
((data.mca$sv[1])^2+(data.mca$sv[2])^2) / sum(data.mca$sv^2)
#exact contributions of each PC
propoptionsOfPCs = data.mca$sv^2/sum(data.mca$sv^2)

#get the number of modalities for each column
categories <- apply(data,2,function(x) nlevels(as.factor(x))) 

#dataset where each item is a separate modality (now we have 12 of those)
data.vars <- data.frame(data.mca$colcoord,Variable=rep(names(categories),categories))

#assign names for all modalities like "name:value" e.g. "astigmatic:1"
rownames(data.vars) <- data.mca$levelnames

#plot the items in a PC1-PC2 plane
ggplot(data=data.vars,
       aes(x=X1,y=X2,label = rownames(data.vars))) +
  
  geom_hline(yintercept = 0, color = "gray70")+
  geom_vline(xintercept = 0, color = "gray70")+
  geom_text(aes(color=Variable))+
  ggtitle("MCA plot of Lenses dataset")+ 
  labs(x = paste("PC1(", percent(propoptionsOfPCs[1]), ")", sep=""),
       y = paste("PC2(", percent(propoptionsOfPCs[2]), ")", sep=""))+
  theme(
    axis.title.x = element_text(face="bold",size=10),
    axis.title.y = element_text(face="bold",size=10),
    axis.text = element_text(size = 10),
    
    legend.key = element_rect(fill = "navy"),
    legend.background = element_rect(fill = "white"),
    
    panel.grid.major = element_line(colour = "grey"),
    panel.grid.minor = element_blank()
  ) 

#another way to plot the data which is less fancy
data.obs <- data.frame(data.mca$rowcoord)q
plot(data.mca)
points(data.mca$rowcoord)