# Load required libraries
library(randomForest)
library(caret)
library(ggplot2)
library(readr)
library(dplyr)

# Load dataset
data <- read_csv("I:/DS/mods/Extract.csv")

# Fill missing values
data[is.na(data)] <- "Missing"

# Feature engineering
data <- data %>%
  mutate(
    utm_campaign_category = paste(ssi_utm_campaign, ssl_typeoffeaturedname, sep="_"),
    decisiontimefrom_binned = cut(Sum_of_ssl_decisiontimefrom, breaks=4, labels=FALSE, include.lowest=TRUE)
  )

# Define predictors and target
predictors <- data %>% select(utm_campaign_category, decisiontimefrom_binned, ssl_utm_source, ssl_utm_medium, ssl_utm_term)
target <- data$ssl_firstTrue

# Train-test split
set.seed(42)
trainIndex <- createDataPartition(target, p=0.7, list=FALSE)
trainData <- predictors[trainIndex, ]
testData <- predictors[-trainIndex, ]
trainLabels <- target[trainIndex]
testLabels <- target[-trainIndex]

# Train Random Forest Model
rf_model <- randomForest(x=trainData, y=trainLabels, ntree=100, importance=TRUE)

# Print model summary
print(rf_model)

# Feature Importance Visualization
importance_df <- as.data.frame(importance(rf_model))
importance_df$Feature <- rownames(importance_df)

ggplot(importance_df, aes(x=reorder(Feature, MeanDecreaseGini), y=MeanDecreaseGini)) +
  geom_bar(stat="identity", fill="skyblue") +
  coord_flip() +
  labs(title="Feature Importance", x="Feature", y="Importance") +
  theme_minimal()

# Save results
write_csv(importance_df, "I:/DS/mods/feature_importance.csv")
