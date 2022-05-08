---
title: Combining **tidymodels** and **caret** for Machine Learning in R
date: 2022-05-07 10:30:00
tags:
    - Machine Learning
category: data-science
keywords:
    - Machine Learning
    - Data Science
    - R
    - Caret
    - tidymodels
---

The two main approaches to building machine learning models in R are [**caret**](https://github.com/topepo/caret/) and [**tidymodels**](https://www.tidymodels.org/). Having tried both, I found that I struggled to pick my favorite. There's elements of both that made more intuitive sense to me than the other. I think it's a product of having become very familiar with the **tidyverse**, particularly **dplyr**, for data wrangling, but still using a lot of Base R functions for statistical modeling.

The process for prepping the data for a machine learning model seems to make a ton of sense to me when done in **tidymodels** (using [**recipes**](https://recipes.tidymodels.org/) and [**rsample**](https://rsample.tidymodels.org/)), but the equivalent process using **caret** felt a little clunky. However, specifying and training models using **caret** made a lot of sense to my broken brain.

Anyway, I recently discovered something that is probably entirely unremarkable to everyone else, and that probably shouldn't have taken me by surprise... You can just combine the two! You can split and preprocess your data using the **tidymodels** framework before defecting to **caret** for the next steps. What a time to be alive.

## Training a Random Forest Model to Predict Diabetes

Because I'm not a savage, I won't leave you without a simple worked example. We'll use [Gary Hutson](https://hutsons-hacks.info/)'s really useful [**MLDataR**](https://cran.r-project.org/web/packages/MLDataR/vignettes/MLDataR.html) package to grab a toy diabetes dataset, cleaning the variable names using [**janitor**](http://sfirke.github.io/janitor/), and converting the target variable, *diabetic_class*, to a factor.

```R
# import packages
pacman::p_load(caret, recipes)

# load data
diabetes_raw <- MLDataR::diabetes_data

# clean data
df <-
  diabetes_raw %>%
  janitor::clean_names() %>%
  dplyr::mutate(diabetic_class = as.factor(diabetic_class))
```

Having done this, we can use **rsample** to split the data into a train and test set.

```R
# split train/test data
train_test_split <-
  rsample::initial_split(df,
    strata = diabetic_class,
    prop = 0.7
  )

# create train/test sets
train_df <- rsample::training(train_test_split)
test_df <- rsample::testing(train_test_split)
```

The next step is a little more involved, and is where I think **tidymodels** really excels. Using the **recipes** package, we can specify all the preprocessing steps needed for the dataset, such that the data will then be ready for training a machine learning model.

```R
# preprocessing
model_recipe <-
  recipe(diabetic_class ~ ., data = train_df) %>%
  # combine low frequency factor levels
  step_other(all_nominal(), threshold = 0.05) %>%
  # remove no variance predictors which provide no predictive information
  step_nzv(all_predictors()) %>%
  # normalize numeric variables to have a standard deviation of one and a mean of zero
  step_normalize(all_numeric()) %>%
  # convert nominal variables to numeric binary variables
  step_dummy(all_nominal(), -all_outcomes(), one_hot = TRUE)
```

You can check that all the preprocessing steps are working as expected by using *prep()* and *juice()*.

```R
# check preprocessing results
model_recipe %>%
  prep() %>%
  juice()

```

If everything looks alright, you can take the *model_recipe* object that you've created and use it as the model formula that you would otherwise have to specify in the **caret** *train()* function.

For the rest of the process, you can switch over to **caret**, first using the *trainControl()* function to specify the training parameters and then the *train()* function for the model training.

```R
# set random seed
set.seed(456)

# control parameters for model training
ctrl <-
  trainControl(
    method = "cv",
    number = 5,
    classProbs = TRUE,
    summaryFunction = twoClassSummary
  )

# train random forest model
rf_mod <-
  train(
    model_recipe,
    data = train_df,
    method = "rf",
    tunelength = 10,
    metric = "ROC",
    trControl = ctrl,
    importance = TRUE
  )
```

Having trained the random forest model, you can check the performance, and see what parameters were chosen in the tuning process.

```R
# check results
print(rf_mod)

Random Forest

364 samples
 16 predictor
  2 classes: 'Negative', 'Positive'

Recipe steps: other, nzv, normalize, dummy
Resampling: Cross-Validated (5 fold)
Summary of sample sizes: 291, 291, 292, 291, 291
Resampling results across tuning parameters:

  mtry  ROC        Sens       Spec
   2    0.9953968  0.9428571  0.9466667
  16    0.9962698  0.9785714  0.9776768
  31    0.9950722  0.9714286  0.9776768

ROC was used to select the optimal model using the largest value.
The final value used for the model was mtry = 16.
```

Not bad! The best performing model has an ROC of 0.996 and both the sensitivity and specificity are around 0.98. Pretty solid for a quick and easy model.

To really test the model's performance, we want to see how it copes with the test data that it hasn't seen.

```R
# make predictions on test data
rf_predict <- predict(rf_mod, newdata = test_df, type = "prob")
rf_class <- predict(rf_mod, newdata = test_df, type = "raw")

preds <-
  cbind(rf_predict, rf_class) %>%
  mutate(
    Positive = round(Positive, digits = 2),
    Negative = round(Negative, digits = 2)
  )
```

Finally, we can produce a confidence matrix for a more intuitive look at how the model is performing on the test set.

```R
cm_class <- test_df[, names(test_df) %in% c("diabetic_class")]


confusionMatrix(
    rf_class,
    as.factor(cm_class$diabetic_class),
    positive = "Positive"
  )

Confusion Matrix and Statistics

          Reference
Prediction Negative Positive
  Negative       59        6
  Positive        1       90

               Accuracy : 0.9551
                 95% CI : (0.9097, 0.9818)
    No Information Rate : 0.6154
    P-Value [Acc > NIR] : <2e-16

                  Kappa : 0.9067

 Mcnemar's Test P-Value : 0.1306

            Sensitivity : 0.9375
            Specificity : 0.9833
         Pos Pred Value : 0.9890
         Neg Pred Value : 0.9077
             Prevalence : 0.6154
         Detection Rate : 0.5769
   Detection Prevalence : 0.5833
      Balanced Accuracy : 0.9604

       'Positive' Class : Positive
```

The results are pretty good for a very quick model. How exciting. Lets pretend that it's because I'm a brilliant data scientist rather than it being due to the very clean, balanced toy dataset we used.

## Conclusion

So there you have it, if you're in the same position as me and you're struggling to pick between **tidymodels** and **caret**, because both frameworks offer something you like, you can just combine the two and make Frankenstein's framework.

Ultimately, despite this blog post, I'm probably going to stick with **tidymodels** (why am I like this?). I think that I'm going to force myself to get used to the **tidymodels** framework end-to-end because a) it is receiving tons of development so it's probably going to continue to get better and bigger, and will be leading the way for the foreseeable future, and b) because in reality I think the explicit way that you structure each step is probably sensible, even if it confuses me a bit.

But it's nice to know that I've got options.
