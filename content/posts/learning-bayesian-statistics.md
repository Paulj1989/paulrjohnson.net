---
title: Resources for Learning Bayesian Statistics
date: 2022-05-10
tags:
    - Statistics
    - Bayes
    - Data Science
category: statistics
keywords:
    - data science
    - statistics
    - bayes rule
    - bayesian statistics
    - probability
---

As a social scientist turned data scientist, my graduate school training taught me a lot of frequentist statistics that has served me well in my career since. However, there's one thing that frequentist statistics can't solve, and that's my lack of a personality. For that, we've got Bayesian statistics, the perfect substitute.

I've spent the last year or so gradually trying to become more Bayesian in my approach to statistical reasoning and analysis, and while there's quite a few really good resources for supporting that journey, it can be a little difficult to know where to start. I wanted someone to give me a short reading list that would save me trying to work out which books to use and in what order. In an attempt to fill that gap, I've put together a list of resources that I've come across and found to be pretty solid. I've not worked through each and every one of these cover to cover, but I've interacted with them enough to think they're useful and that someone might be able to learn a lot from them.

Where possible I've tried to find stuff that is free and open-source, but that hasn't been possible in every single case. But in each case I have at least found a freely available resource that is made available by the authors, whether it be the book itself, a video series, or a series of articles.

## Becoming More Bayesian

These first resources are good starting points for anyone looking to start learning more about Bayesian statistics. They've all got plenty of detail, but they focus on making the intuition of Bayesianism a little more approachable.

### Statistical Rethinking

I think the starting point for everybody, and an all-round great resource for anyone interested in statistics, is Richard McElreath's [_Statistical Rethinking_](https://xcelab.net/rm/statistical-rethinking/). If you read only one of these books, make it _Statistical Rethinking_. It's a great read for anybody interested in statistics and quantitative research.

The focus of _Statistical Rethinking_ is utilizing Bayesian statistics for scientific reasoning/thinking and causal inference. It's a really great read, in part because it is really accessible while also being pretty thorough too. I particularly like his consistent focus on how these tools apply to scientific models.

Not only is it available as a book, but Richard also makes a [lecture series](https://www.youtube.com/playlist?list=PLDcUM9US4XdMROZ57-OIRtIK0aOynbgZN) available on YouTube which can serve as an accompaniment to the book, or can even stand on its own as a good learning resource.

### Student's Guide to Bayesian Statistics

Ben Lambert's [_A Student's Guide to Bayesian Statistics_](https://ben-lambert.com/a-students-guide-to-bayesian-statistics/) is a really good dive into the statistics that underpin Bayesian analysis, and the implementation of the statistical methods. It's not light on notation, but it does introduce new concepts by first explaining the intuition before laying it out mathematically. I think this book pairs very well with _Statistical Rethinking_, as they take slightly different approaches, and between the two you cover tons of ground.

You can buy the book on [Amazon](https://www.amazon.co.uk/Students-Guide-Bayesian-Statistics/dp/1473916364/) but it isn't freely available anywhere (that I've found). Ben does offer a free [YouTube course](https://youtu.be/P_og8H-VkIY) and [lecture notes](https://ben-lambert.com/bayesian-lecture-slides/) that mirror the book's content though. The YouTube course doesn't offer the kind of detail that the book does, but it is still pretty good.

### Introduction to Empirical Bayes

If you're looking for something to help you apply Bayesian statistics to a real-world situation, or you're the kind of learner that needs a relatable hook to help you make sense of things (this is me), then David Robinson's [_Introduction to Empirical Bayes_](http://varianceexplained.org/r/empirical-bayes-book/) is the perfect starting point. David applies Empirical Bayes methods (Bayesian approaches where the prior is estimated from the data) in a baseball context, specifically simulating batting averages. Baseball isn't really the focus of David's work here, but it serves as a really good medium for couching some quite complicated concepts in terms that people can understand, and thanks to this (and David's excellent communication of the concepts), it is a really good opening gambit for anyone interested in Bayesian statistics.

The _Introduction to Empirical Bayes_ book started out as a series of [blog posts](http://varianceexplained.org/statistics/beta_distribution_and_baseball/) on David's website, [Variance Explained](varianceexplained.org), and those blog posts are all still freely available, but his e-book also includes an extra chapter, some additional materials across several other chapters, and some minor edits and changes to help simplify things. The book is also available at a "pay-what-you-want" price, which means you can choose to pay nothing, if you can't afford to pay more, but for those that can, the suggested price is $9.95 (~£8).

I don't think that David's e-book/blog posts are the most thorough of the resources listed here, but they're also not trying to be. Instead, they're a really good plain(ish)-English explanation of Bayesian concepts, applied to examples that should help a lot of people intuit them a little easier. The use of Empirical Bayes serves as a good first step in the direction of Bayesian approaches, and it is also a good way to learn some really useful methods in real-world data analysis. If you find that some of the other resources are a little hard to wrap your head round, I'd read all of his posts (or buy his book if you can afford to) first, because it might help lay the groundwork for your learning journey.

### Think Bayes

The vast majority of the resources listed here use R for implementation. I think that's because the packages for computing Bayesian models in R are much easier to navigate than their alternatives in Python. However, if you're coming at this as someone with limited or no knowledge of R and no interest in changing that, then [Allen Downey](https://www.allendowney.com/wp/)'s [_Think Bayes_](http://allendowney.github.io/ThinkBayes2/index.html) is worth a look. _Think Bayes_ takes a code-first approach to teaching Bayesian concepts, rather than using notation and illustrating ideas using concepts like calculus. For anyone that uses Python and would learn better through concepts being explained through code, this book is  a great start.

## Building a Stronger Understanding

The following resources would serve as great next steps for someone looking to build on their understanding of Bayesianism, whether it be an extremely thorough exploration of the mathematics underpinning the methods, or detailed documentation of the code for the computation of Bayesian methods.

### Bayesian Data Analysis

Everything [Andrew Gelman](https://statmodeling.stat.columbia.edu/) does is good, and [_Bayesian Data Analysis_](http://www.stat.columbia.edu/~gelman/book/) (co-authored with John B. Carlin, Hal S. Stern, David B. Dunson, Aki Vehtari, and Donald B. Rubin) is yet more proof of that. It's a really extensive book covering the fundamentals of Bayesian inference, analysis, and methods.

I think _Bayesian Data Analysis_ might be a little heavier going if you're just starting out, but the book is also supplemented by an [online course](https://avehtari.github.io/BDA_course_Aalto/) made available by [Aki Vehtari](https://users.aalto.fi/~ave/), with lecture slides and videos to help bridge any gaps in understanding.

The book and the course are excellent resources for those looking to build on foundational knowledge (perhaps developed using the earlier resources). It's probably the most thorough of all the resources here, so if you're comfortable with mathematical notation and only want to read one book, this might be your best bet.

### Stan Documentation

Stan is a probabilistic programming language for implementing Bayesian statistical models. It's the language that underpins the computation of Bayesian methods, and there are interfaces that make it accessible in a number of different languages, including R, Python, and Julia (for those of you looking to intimidate your peers).

The [Stan documentation](https://mc-stan.org/users/documentation/), and the documentation for the R interface to Stan, [RStan](https://mc-stan.org/rstan/), and the Python equivalent, [PyStan](https://pystan.readthedocs.io/en/latest/) are good resources for learning how to implement a variety of Bayesian models.

## Beyond Bayes

Finally, there are books that are worth a mention because they are really good resources that, while not focused entirely on Bayesian statistics, do a great job of placing Bayesian approaches in the context of wider statistical methods.

### Regression and Other Stories

More Gelman. I have no regrets! [_Regression and Other Stories_](https://avehtari.github.io/ROS-Examples/) is co-authored with Jennifer Hill and Aki Vehtari, and it will serve you brilliantly if you're looking to learn about Bayesian approaches while also covering the frequentist methods too. It is a book that focuses on the application of regression to real-world problems and the challenges users will face in the process.

While the focus of the book is regression, it incorporates Bayesian inference and methods across the book, and this might be useful to anyone wanting a broader education in statistical analysis that includes Bayesian approaches.

### Probabilistic Machine Learning

If you're looking to apply your newly developed Bayesian principles to machine learning, then [_Probabilistic Machine Learning: An Introduction_](https://probml.github.io/pml-book/book1.html) by [Kevin Patrick Murphy](https://www.cs.ubc.ca/~murphyk/) is a great start.

It's not specifically a Bayesian machine learning book, but probabilistic machine learning incorporates a lot of Bayesian principles, and there's plenty of explicitly Bayesian tools in the book too. If you've cracked several of the resources in this list and are looking to take your next step, I think this would be a great direction.

## Conclusion

I think that having a good understanding of Bayes rule is really important for anyone working in or around statistics, because it helps inform the way you reason about statistics, and it helps you interrogate your approach to analysis in a more thorough manner. Getting a good intuition for Bayesian thinking is relatively simple, but if you're looking to go a little further, it does require a bit of work. I think there are tons of really good resources out there to take those next steps, but I don't think they're as easy to track down as they could be. Hopefully this list will bridge that gap for a few people.
