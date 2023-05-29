





#Model Building
#training the decision tree classifier
set.seed(123)
Dtree <- rpart(irradiat ~.,data = cancer.train.c)

# Reports the model
print(Dtree)


# Plotting tree structure
plot(Dtree, margin=c(.2))
title(main = "Decision Tree Model of Train Data")
text(Dtree, use.n = TRUE) #Tree looks a bit odd here, maybe due to types being set as factors instead of numeric?
## print the tree structure
summary(Dtree)

# make prediction using decision model
df.predictions <- predict(Dtree, cancer.test.c, type = "class")
head(df.predictions)

## Comparison table
df.comparison <- cancer.test.c
df.comparison$Predictions <- df.predictions
df.comparison[ , c("irradiat", "Predictions")]

disagreement.index <- df.comparison$irradiat != df.comparison$Predictions
df.comparison[disagreement.index,]

#Predictions
Dtree.irradiat.predicted <- predict(Dtree, cancer.test.c, type='class')

#Confusion Matrix for evaluating the model

confusionMatrix(Dtree.irradiat.predicted, cancer.test.c$irradiat)


#Vis the tree
prp(Dtree)

#Decision Tree 2 
D2train <- cancer.train.c
D2test <- cancer.test.c
D2train <-select(D2train, Age, 'tumor-size', 'node-caps', irradiat)

D2tree <- rpart(irradiat ~.,data = D2train)

# Reports the model
print(D2tree)


# Plotting tree structure
plot(D2tree, margin=c(.1))
title(main = "Decision Tree Model of Train Data")
text(D2tree, use.n = TRUE) #Tree looks a bit odd here, maybe due to types being set as factors instead of numeric?
## print the tree structure
summary(D2tree)

# make prediction using decision model
df.predictions <- predict(D2tree, D2test, type = "class")
head(df.predictions)

## Comparison table
df.comparison <- D2test
df.comparison$Predictions <- df.predictions
df.comparison[ , c("irradiat", "Predictions")]

disagreement.index <- df.comparison$irradiat != df.comparison$Predictions
df.comparison[disagreement.index,]

#Predictions
D2tree.irradiat.predicted <- predict(D2tree, D2test, type='class')

#Confusion Matrix for evaluating the model

confusionMatrix(D2tree.irradiat.predicted, D2test$irradiat)


#Vis the tree
prp(D2tree)


#Random Forest
# Grid search of hyperparameters for randomforest

tune.grid <- expand.grid(mtry = c(3:6))

View(tune.grid)
cl <- makePSOCKcluster(8)
registerDoParallel(cl)

# 10-fold CV repeated 3 times to train randomforest

caret.cv <- train(irradiat ~ ., 
                  data = cancer.train.c,
                  method = "rf",
                  tuneGrid = tune.grid,
                  trControl = train.control)
caret.cv

stopCluster(cl)


#Seriel backend
registerDoSEQ()


#Predictions on the test set using a randomForest model 
preds.rf.caret <- predict(caret.cv, cancer.test.c)
table(preds.rf.caret,cancer.test.c$irradiat)

#Accuracy calculation
prediction <- predict(caret.cv, cancer.test.c)
confusionMatrix(prediction, cancer.test.c$irradiat)

#Vis of result
varImp(caret.cv)

#Boosting
tune.grid.b <- expand.grid(n.trees = c(100,500), interaction.depth=c(1:3), shrinkage=c(0.01,0.1), n.minobsinnode=c(20))

View(tune.grid.b)

#Register parallel cores
cl <- makePSOCKcluster(8)
registerDoParallel(cl)

caret.cv.b <- train(irradiat ~ ., 
                    data = cancer.train.c,
                    method = "gbm",
                    tuneGrid = tune.grid.b,
                    trControl = train.control)

caret.cv.b

stopCluster(cl)

# insert serial backend, otherwise error in repetetive tasks
registerDoSEQ()


#Decision Tree 3
D3train <- cancer.train.c
D3test <- cancer.test.c
D3train <-select(D3train, Age, 'inv-nodes', 'node-caps', irradiat)

D3tree <- rpart(irradiat ~.,data = D3train)

# Reports the model
print(D3tree)


# Plotting tree structure
plot(D3tree, margin=c(.1))
title(main = "Decision Tree Model of Train Data")
text(D3tree, use.n = TRUE) #Tree looks a bit odd here, maybe due to types being set as factors instead of numeric?
## print the tree structure
summary(D3tree)

# make prediction using decision model
df.predictions <- predict(D3tree, D3test, type = "class")
head(df.predictions)

## Comparison table
df.comparison <- D3test
df.comparison$Predictions <- df.predictions
df.comparison[ , c("irradiat", "Predictions")]

disagreement.index <- df.comparison$irradiat != df.comparison$Predictions
df.comparison[disagreement.index,]

#Predictions
D3tree.irradiat.predicted <- predict(D3tree, D3test, type='class')

#Confusion Matrix for evaluating the model

confusionMatrix(D3tree.irradiat.predicted, D3test$irradiat)


#Vis the tree
prp(D3tree)




#Clustering
#Plot Number of clusters Elbow Method
wss <- (nrow(df_1train.norm)-1)*sum(apply(df_1train.norm,2,var))

for (i in 2:10) 
  wss[i] <- sum(kmeans(df_1train.norm, centers=i)$withinss)

plot(1:10, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# K-Means Cluster Analysis 
df_fit <- kmeans(df_1train.norm, 2) 
df_fit
str(df_fit)
plot(df_1, col = df_fit$cluster)

# get cluster means
aggregate(df_1train.norm,by=list(df_fit$cluster),FUN=mean)

# append cluster assignment
df_1train.norm <- data.frame(df_1train.norm, df_fit$cluster)
results <- kmeans(df_1train.norm, 2)
print(results)
results$size
results$cluster
fviz_cluster(results, data = df_1train.norm,
             ellipse.type = "convex",
             palette = "jco",
             ggtheme = theme_minimal())
table(results$cluster, df_1$irradiat) #cant be done yet as trying to compare numbers to factors

#Hierarchical Clustering - Ward
d <- dist(df_1train.norm, method = "euclidean") 
df_fitH <- hclust(d, method="ward.D2")

#Dendogram
plot(df_fitH) # display dendogram
groups <- cutree(df_fitH, k=2) 

#Create boarders on dendogram
rect.hclust(df_fitH, k=2, border="red")
sub_grp <- cutree(df_fitH, k =2)
fviz_cluster(list(data = df_1train.norm, cluster = sub_grp))

#DBScan
#Fitting DBScan to model training set
set.seed(123)
data("multishapes", package = "factoextra")
db <- fpc::dbscan(df_1train.norm, eps =.25, MinPts = 5)
fviz_cluster(db, data = df_1train.norm, stand = FALSE, ellipse = FALSE, show.clust.cent = FALSE, geom = "point", palette = "jco", ggtheme = theme_classic())
print(db)

dbscan::kNNdistplot(df_1train.norm, k = 2)
abline(h = 0.25, lty = 2)

#Checking cluster
db$cluster

#Table - Cant be done yet, df_1 needs numerical values the same as the normalized set
table(Db$cluster, df_1$irradiat)

#Divisive clustering
df_d <- df_1train.norm
df_d <- na.omit(df_d)
df_d <- scale(df_d)
head(df_d)

#Divisive cluster using complete linkage
df_hcd <- diana(df_d)
df_hcd$dc
pltree(df_hcd, cex = 0.6, hang = -1, main = "dendrogram of diana")
rect.hclust(df_hcd, k=3, border= "blue")
clust <- cutree(df_hcd, k = 3)
fviz_cluster(list(data = df_d, cluster = clust))

#bagging
df_bag <- df_1
df.bag <-  bagging(irradiat ~ ., df_bag)
predict_irradiat <- predict(df.bag, df_bag)
df_bag$prediction <- predict_irradiat
head(df_bag)
with(df_bag, table(irradiat, prediction))



