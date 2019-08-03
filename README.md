# Google App Store - Comparison of Imputation Methods
(project written in Polish as an assignment for Advanced Business Analytics course at Warsaw School of Economics)

# Summary
The goal of the project was to compare multiple and median imputation, as well as complete removal of missings and its' influence on
the Generalized Linear Models performance. For this case, web-scrapped data from Google App Store was used. It is available [here](https://www.kaggle.com/lava18/google-play-store-apps).

It turned out, that on this particular dataset, median and multiple imputation gave similar results. Data removal resulted in the highest
standard error, but better goodness-of-fit measures. To conclude, multiple imputation gave slightly better results than median
and ensured information retain.


## Contents
Project has 2 parts:

* Data preparation in Python, in which some EDA, cleaning, normalization were performed.
* Modelling and some EDA in SAS.
* Description of the analysis in PDF.