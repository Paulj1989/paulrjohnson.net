---
title: Combining Tidymodels & Caret for Machine Learning in R
summary: How to combine the functionality from both the Tidymodels framework and Caret to build a machine learning solution in R that is the best of both worlds.
date: 2022-05-07
tags:
    - Machine Learning
    - R
    - Data Science
category: data-science
keywords:
    - machine learning
    - data science
    - r
    - rlang
    - caret
    - tidymodels
---

The two main approaches to building machine learning models in R are [**caret**](https://github.com/topepo/caret/) and [**tidymodels**](https://www.tidymodels.org/). Having tried both, I found that I struggled to pick my favorite. There's elements of both that made more intuitive sense to me than the other. I think it's a product of having become very familiar with the **tidyverse**, particularly **dplyr**, for data wrangling, but still using a lot of Base R functions for statistical modeling.

The process for prepping the data for a machine learning model seems to make a ton of sense to me when done in **tidymodels** (using [**recipes**](https://recipes.tidymodels.org/) and [**rsample**](https://rsample.tidymodels.org/)), but the equivalent process using **caret** felt a little clunky. However, specifying and training models using **caret** made a lot of sense to my broken brain.

Anyway, I recently discovered something that is probably entirely unremarkable to everyone else, and that probably shouldn't have taken me by surprise... You can just combine the two! You can split and preprocess your data using the **tidymodels** framework before defecting to **caret** for the next steps. What a time to be alive.

## Training a Random Forest Model to Predict Diabetes

Because I'm not a savage, I won't leave you without a simple worked example. We'll use [Gary Hutson](https://hutsons-hacks.info/)'s really useful [**MLDataR**](https://cran.r-project.org/web/packages/MLDataR/vignettes/MLDataR.html) package to grab a toy diabetes dataset, cleaning the variable names using [**janitor**](http://sfirke.github.io/janitor/), and converting the target variable, *diabetic_class*, to a factor.

``` r
# import packages
suppressPackageStartupMessages({
  library(dplyr)
  library(caret)
  library(recipes)
  library(randomForest)
})

# load data
diabetes_raw <- MLDataR::diabetes_data

# clean data
df <-
  diabetes_raw %>%
  janitor::clean_names() %>%
  mutate(diabetic_class = as.factor(diabetic_class))
```

Having done this, we can use **rsample** to split the data into a train and test set.

``` r
# set random seed
set.seed(456)

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

``` r
# preprocessing
model_recipe <-
  recipe(diabetic_class ~ ., data = train_df) %>%
  # combine low frequency factor levels
  step_other(all_nominal(), threshold = 0.05) %>%
  # remove predictors with zero variance
  step_nzv(all_predictors()) %>%
  # normalize numeric variables (sigma = 1, mu = 0)
  step_normalize(all_numeric()) %>%
  # convert nominal variables to numeric binary variables
  step_dummy(all_nominal(), -all_outcomes(), one_hot = TRUE)
```

You can check that all the preprocessing steps are working as expected by using *prep()* and *juice()*.

``` r
# check preprocessing results
model_recipe %>%
  prep() %>%
  juice() %>%
  head()
```

    # A tibble: 6 × 32
         age diabe…¹ gende…² gende…³ exces…⁴ exces…⁵ polyd…⁶ polyd…⁷ weigh…⁸ weigh…⁹
       <dbl> <fct>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    1 -0.677 Negati…       0       1       1       0       0       1       0       1
    2 -1.19  Negati…       0       1       1       0       1       0       1       0
    3 -1.53  Negati…       0       1       1       0       1       0       1       0
    4  1.62  Negati…       0       1       0       1       1       0       1       0
    5  1.02  Negati…       0       1       1       0       1       0       1       0
    6  0.854 Negati…       0       1       1       0       1       0       1       0
    # … with 22 more variables: fatigue_No <dbl>, fatigue_Yes <dbl>,
    #   polyphagia_No <dbl>, polyphagia_Yes <dbl>, genital_thrush_No <dbl>,
    #   genital_thrush_Yes <dbl>, blurred_vision_No <dbl>,
    #   blurred_vision_Yes <dbl>, itching_No <dbl>, itching_Yes <dbl>,
    #   irritability_No <dbl>, irritability_Yes <dbl>, delay_healing_No <dbl>,
    #   delay_healing_Yes <dbl>, partial_psoriasis_No <dbl>,
    #   partial_psoriasis_Yes <dbl>, muscle_stiffness_No <dbl>, …

If everything looks alright, you can take the *model_recipe* object that you've created and use it as the model formula that you would otherwise have to specify in the **caret** *train()* function.

For the rest of the process, you can switch over to **caret**, first using the *trainControl()* function to specify the training parameters and then the *train()* function for the model training.

``` r
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

``` r
# check results
print(rf_mod)
```

    Random Forest 

    364 samples
     16 predictor
      2 classes: 'Negative', 'Positive' 

    Recipe steps: other, nzv, normalize, dummy 
    Resampling: Cross-Validated (5 fold) 
    Summary of sample sizes: 292, 291, 291, 291, 291 
    Resampling results across tuning parameters:

      mtry  ROC        Sens       Spec     
       2    0.9947186  0.9500000  0.9372727
      16    0.9873918  0.9428571  0.9281818
      31    0.9850108  0.9428571  0.9235354

    ROC was used to select the optimal model using the largest value.
    The final value used for the model was mtry = 2.

Not bad! The best performing model has an ROC of 0.995 and both the sensitivity and specificity are \~0.95. Pretty solid for a quick and easy model.

To really test the model's performance, we want to see how it copes with the test data that it hasn't seen.

``` r
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

``` r
cm_class <- test_df[, names(test_df) %in% c("diabetic_class")]

confusionMatrix(
    rf_class,
    as.factor(cm_class$diabetic_class),
    positive = "Positive"
  )
```

    Confusion Matrix and Statistics

              Reference
    Prediction Negative Positive
      Negative       57        1
      Positive        3       95
                                             
                   Accuracy : 0.9744         
                     95% CI : (0.9357, 0.993)
        No Information Rate : 0.6154         
        P-Value [Acc > NIR] : <2e-16         
                                             
                      Kappa : 0.9455         
                                             
     Mcnemar's Test P-Value : 0.6171         
                                             
                Sensitivity : 0.9896         
                Specificity : 0.9500         
             Pos Pred Value : 0.9694         
             Neg Pred Value : 0.9828         
                 Prevalence : 0.6154         
             Detection Rate : 0.6090         
       Detection Prevalence : 0.6282         
          Balanced Accuracy : 0.9698         
                                             
           'Positive' Class : Positive       
                                             

The results are pretty good for a very quick model. How exciting. Lets pretend that it's because I'm a brilliant data scientist rather than it being due to the very clean, balanced toy dataset we used.

## Conclusion

So there you have it, if you're in the same position as me and you're struggling to pick between **tidymodels** and **caret**, because both frameworks offer something you like, you can just combine the two and make Frankenstein's framework.

Ultimately, despite this blog post, I'm probably going to stick with **tidymodels** (why am I like this?). I think that I'm going to force myself to get used to the **tidymodels** framework end-to-end because a) it is receiving tons of development so it's probably going to continue to get better and bigger, and will be leading the way for the foreseeable future, and b) because in reality I think the explicit way that you structure each step is probably sensible, even if it confuses me a bit.

But it's nice to know that I've got options.
