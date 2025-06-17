---
title: "Random forest fraud"
summary: "Description pending"
date: "2025-06-16"
#image: "/images/metal_ball.png?v=2"
skills:
    - Machine learning
    - Python
    - Anomaly detection
read_time: 5
output: bookdown::html_document2
---

<script src="{{< blogdown/postref >}}index_files/core-js/shim.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/react/react.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/react/react-dom.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/reactwidget/react-tools.js"></script>

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>

<link href="{{< blogdown/postref >}}index_files/reactable/reactable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/reactable-binding/reactable.js"></script>

<script src="{{< blogdown/postref >}}index_files/core-js/shim.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/react/react.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/react/react-dom.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/reactwidget/react-tools.js"></script>

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>

<link href="{{< blogdown/postref >}}index_files/reactable/reactable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/reactable-binding/reactable.js"></script>

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>

<script src="{{< blogdown/postref >}}index_files/plotly-binding/plotly.js"></script>

<script src="{{< blogdown/postref >}}index_files/typedarray/typedarray.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/jquery/jquery.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/plotly-htmlwidgets-css/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/plotly-main/plotly-latest.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>

<script src="{{< blogdown/postref >}}index_files/plotly-binding/plotly.js"></script>

<script src="{{< blogdown/postref >}}index_files/typedarray/typedarray.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/jquery/jquery.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/plotly-htmlwidgets-css/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/plotly-main/plotly-latest.min.js"></script>

{{% highlightbox %}}
💾 <a href="https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud?resource=download" target="_blank">Download the data</a>

### TL;DR

I trained a model to detect fraudulent credit card transactions, even though fraud made up less than 1% of the data. By carefully adjusting decision thresholds and evaluating metrics like precision and recall, I built a classifier that caught 80% of fraud cases while keeping false alarms low—showing how machine learning can support real-world risk detection where class imbalance is a major challenge.

### Key Skills

- 🌲 **Ensemble Learning with Random Forests** – Trained and tuned a Random Forest classifier to detect rare fraud cases in heavily imbalanced data

- ⚖️ **Imbalanced Classification** – Used precision–recall curves and threshold tuning to optimize detection of minority-class events

- 📉 **Classifier Evaluation** – Interpreted ROC AUC, F1, and confusion matrices to balance recall and false positive rate in a high-stakes context

- 🧪 **Model Transparency & Risk Tradeoffs** – Explored threshold-setting as a policy lever, connecting model outputs to real-world operational goals
  \### What I Learned

{{% /highlightbox %}}

## <u>What I did</u>

## <u>How I did it</u>

For the full Python script, see [here](https://gist.github.com/dbraun31/63b629d5e932d48770c0a00c82f09683).

First, we load the relevant libraries and the data

<div class="show-default">

</div>

``` python
# Import libraries
import numpy as np
import pandas as pd
import joblib
import os
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.metrics import roc_auc_score, confusion_matrix, f1_score, classification_report

# Import data
d = pd.read_csv('post_data/creditcard.csv')
```

<div class="reactable html-widget html-fill-item" id="htmlwidget-1" style="width:auto;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"Time":[0,0,1,406,472,4462],"V1":[-1.3598071336738,1.19185711131486,-1.35835406159823,-2.3122265423263,-3.0435406239976,-2.30334956758553],"V2":[-0.0727811733098497,0.26615071205963,-1.34016307473609,1.95199201064158,-3.15730712090228,1.759247460267],"V3":[2.53634673796914,0.16648011335321,1.77320934263119,-1.60985073229769,1.08846277997285,-0.359744743330052],"V28":[-0.0210530534538215,0.0147241691924927,-0.0597518405929204,-0.143275874698919,0.0357642251788156,-0.153028796529788],"Amount":[149.62,2.69,378.66,0,529,239.93],"Class":[0,0,0,1,1,1]},"columns":[{"id":"Time","name":"Time","type":"numeric"},{"id":"V1","name":"V1","type":"numeric"},{"id":"V2","name":"V2","type":"numeric"},{"id":"V3","name":"V3","type":"numeric"},{"id":"V28","name":"V28","type":"numeric"},{"id":"Amount","name":"Amount","type":"numeric"},{"id":"Class","name":"Class","type":"numeric"}],"sortable":false,"defaultPageSize":10,"showPageSizeOptions":false,"paginationType":"numbers","highlight":true,"theme":{"color":"inherit","backgroundColor":"transparent","borderColor":"inherit","stripedColor":"rgba(0, 0, 0, 0.02)","highlightColor":"rgba(0, 0, 0, 0.05)","style":{"fontSize":"0.95em"},"pageButtonStyle":{"background":"transparent","color":"inherit","border":"1px solid #ccc","borderRadius":"4px","padding":"4px 8px","margin":"0 2px"},"pageButtonHoverStyle":{"background":"#ddd"},"pageButtonActiveStyle":{"background":"#bbb","fontWeight":"bold"}},"dataKey":"e164eedf1638d6b5eacfd92d07d8e3ae"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script>

<div class="show-default">

</div>

``` python

# --- FORMAT DATA --- #

# Leave out time
features = [x for x in d.columns if x not in ['Time', 'Class']]

X = d[features].to_numpy()
y = d['Class'].to_numpy()

# Stratify y to ensure that the very few positive observations are balanced 
# across train and test
X_train_full, X_test, y_train_full, y_test = train_test_split(
        X, y, stratify=y, random_state=42
)
```

The table above suggests that fraud and non-fraud are equally prevalent, but they’re not. Only 0.1727486% of `nrow(py$d)` transactions are fradulent.

To control for this, we need to artificially rebalance the classes by undersampling legitimate transactions.

<div class="show-default">

</div>

``` python
# --- RESAMPLE --- #

# Separate legit and fraud classes
idx_legit = np.where(y_train_full==0)[0]
idx_fraud = np.where(y_train_full==1)[0]

# Choose only the number of legit observations as there are fraudulent cases
idx_legit_sampled = np.random.choice(idx_legit, size=len(idx_fraud),
                                     replace=False)

# Put the indices back together and shuffle
idx = np.concat([idx_legit_sampled, idx_fraud])
np.random.shuffle(idx)

# Subsample to make balanced training data
X_train = X_train_full[idx]
y_train = y_train_full[idx]
```

Now it’s time to fit, baby.

<div class="show-default">

</div>

``` python

# --- FIT RANDOM FOREST WITH GRID SEARCH CV --- #

param_grid = {
    'max_depth': [5, 10, 20, None],
    'min_samples_leaf': [1, 5, 10]
}

grid = GridSearchCV(RandomForestClassifier(n_estimators=300),
                    param_grid,
                    scoring='roc_auc',
                    cv=5)


# Load from file if it exists to reduce processing time
if not os.path.exists('post_data/grid.pkl'):
    grid.fit(X_train, y_train)
    joblib.dump(grid, 'post_data/grid.pkl')
else:
    grid = joblib.load('post_data/grid.pkl')


# --- PREDICT ON TEST DATA --- #

# Both classification and probabilities
y_pred = grid.predict(X_test)
y_proba = grid.predict_proba(X_test)[:, 1]
```

## <u>What I found</u>

Making my own metric functions

<div class="show-default">

</div>

``` r
get_f1 <- function(precision, recall) {
    # Compute F1 score
    out <- 2 * ((precision * recall) / (precision + recall))
    return(out)
}

get_metrics <- function(y_test, y_pred) {
    # Obtain a variety of performance metrics
    
    # Performance on positive cases
    tp <- sum(y_test == 1 & y_pred == 1)
    fn <- sum(y_test == 1 & y_pred == 0)
    
    # Performance on negative cases
    tn <- sum(y_test == 0 & y_pred == 0)
    fp <- sum(y_test == 0 & y_pred == 1)
    
    # cOMPUTE PRECISION, RECALL, FALSE POSITIVE RATE
    # Of all categorized positive, how many were correct?
    precision <- tp / (tp + fp)
    # Of all actual positives, how many were correctly classified?
    recall <- tp / (tp + fn)
    # Of all actual negatives, how many were correctly classified?
    fpr <- fp / (fp + tn)
    
    f1 <- get_f1(precision, recall)
    
    out <- list(precision=precision, recall=recall, fpr=fpr, f1=f1)
    return(out)
}

get_curve <- function(threshold, preds, score='roc') {
    y_test <- preds$y_test
    y_proba <- preds$y_proba
    y_pred <- ifelse(y_proba > threshold, 1, 0)
    
    # Compute and extract metrics
    metrics = get_metrics(y_test, y_pred)
    precision <- metrics$precision
    recall <- metrics$recall
    fpr <- metrics$fpr
    
    
    if (score == 'roc') {
        out <- data.frame(threshold=threshold, recall=recall, fpr=fpr)
    } else {
        out <- data.frame(threshold=threshold, precision=precision, recall=recall)
    }
}


trapz_auc <- function(y_test, y_pred) {
  # x: FPR (x-axis), y: TPR/Recall (y-axis)
  idx <- order(y_test)  # Make sure x is sorted
  y_test <- y_test[idx]
  y_pred <- y_pred[idx]
  return(sum((y_test[-1] - y_test[-length(y_test)]) * (y_pred[-1] + y_pred[-length(y_pred)]) / 2))
}


get_confusion <- function(y_test, y_pred) {
    
    # Performance on positive cases
    tp <- sum(y_test == 1 & y_pred == 1)
    fn <- sum(y_test == 1 & y_pred == 0)
    
    # Performance on negative cases
    tn <- sum(y_test == 0 & y_pred == 0)
    fp <- sum(y_test == 0 & y_pred == 1)
    
    out <- data.frame(detected_legit=c(tn, fn), detected_fraud=c(fp, tp))
    rownames(out) <- c('actually_legit', 'actually_fraud')
    
    return(out)
    
}
```

<div class="reactable html-widget html-fill-item" id="htmlwidget-2" style="width:auto;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"tag":{"name":"Reactable","attribs":{"data":{".rownames":["actually_legit","actually_fraud"],"detected_legit":[69028,13],"detected_fraud":[2051,110]},"columns":[{"id":".rownames","name":"","type":"character","sortable":false,"filterable":false,"rowHeader":true},{"id":"detected_legit","name":"detected_legit","type":"numeric"},{"id":"detected_fraud","name":"detected_fraud","type":"numeric"}],"sortable":false,"defaultPageSize":10,"showPageSizeOptions":false,"paginationType":"numbers","highlight":true,"theme":{"color":"inherit","backgroundColor":"transparent","borderColor":"inherit","stripedColor":"rgba(0, 0, 0, 0.02)","highlightColor":"rgba(0, 0, 0, 0.05)","style":{"fontSize":"0.95em"},"pageButtonStyle":{"background":"transparent","color":"inherit","border":"1px solid #ccc","borderRadius":"4px","padding":"4px 8px","margin":"0 2px"},"pageButtonHoverStyle":{"background":"#ddd"},"pageButtonActiveStyle":{"background":"#bbb","fontWeight":"bold"}},"dataKey":"6f0d65d0ea7c1a6f53ff3714c5e222b9"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script>

``` r
thresholds <- seq(0, 1, .01)

roc <- do.call(rbind, lapply(thresholds, get_curve, preds))

green <- qual[4]

auc <- trapz_auc(roc$fpr, roc$recall)

p <- roc %>% 
    ggplot(aes(x = fpr, y = recall)) + 
    geom_point(color = green, aes(text = paste0('FPR: ', round(fpr,2), '\nTPR: ', round(recall, 2),
                '\nThreshold: ', threshold, '\nAUC: ', round(auc, 2)))) + 
    labs(
        x = 'False positive rate',
        y = 'True positive rate (Recall)'
    ) + 
    annotate('text', x = .5, y = .5, label = paste0('AUC: ', round(auc, 3)), size = 6) + 
    theme_bw() + 
    theme(axis.ticks = element_blank(),
          text = element_text(size = text_size))
## Warning in geom_point(color = green, aes(text = paste0("FPR: ", round(fpr, :
## Ignoring unknown aesthetics: text

ggplotly(p, tooltip = 'text')
```

<div class="plotly html-widget html-fill-item" id="htmlwidget-3" style="width:100%;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-3">{"x":{"data":[{"x":[1,0.91357503622729641,0.78412752008328757,0.66732790275608833,0.57507843385528779,0.50567678217194956,0.45297485895974904,0.41109188367872368,0.37760801361864965,0.34909044865572109,0.32601752979079618,0.30488611263523685,0.28528820045301706,0.26736448177380095,0.25124157627428634,0.23631452327691724,0.2225692539287272,0.20944301411105953,0.19703428579467916,0.18514610503805626,0.17389102266492212,0.16397248132359768,0.15432124818863519,0.14530311343716146,0.13663670000984821,0.12847676528932597,0.1214142011001843,0.11401398443984861,0.10752824322233008,0.10143642988787124,0.095597855906807916,0.089801488484643852,0.084919596505296929,0.080009566820017169,0.075732635518226205,0.07130094683380464,0.06769932047440172,0.064210244938730149,0.060904064491622001,0.057808916839010113,0.054685631480465395,0.051576414974887096,0.049001814882032667,0.045836322964588699,0.042924070400540242,0.040504227690316412,0.037957765303394814,0.035397234063506804,0.033244699559644902,0.031064027349850167,0.028855217434122594,0.026899646871790542,0.025098833692089085,0.023480915600951054,0.021961479480577948,0.020399836801305589,0.019203984299160089,0.018064407208880261,0.016882623559701177,0.015714908763488512,0.014617538232107936,0.013674925083357953,0.012619761110876631,0.011888180756622912,0.011086256137537106,0.010340606930316971,0.0096371642819960881,0.0088633773688431179,0.0078644888082274652,0.0073580101014364295,0.0067811871298133061,0.0061058821874252593,0.0054024395391043768,0.0050366493619775181,0.0046708591848506594,0.0043332067136566356,0.0039392788305969411,0.0035453509475372471,0.0031232853585447177,0.0027152886225186063,0.0024620492691230884,0.0021384656508954825,0.0018711574445335472,0.0016882623559701178,0.0013928164436753472,0.0011677147962126648,0.00095668200171640007,0.00081599347205222358,0.00071751150128730008,0.00064716723645521178,0.00061902953052237646,0.00057682297162312359,0.0005064787067910353,0.00047834100085820003,0.00042206558899252945,0.00036579017712685887,0.00029544591229477063,0.00022510164746268236,0.00021103279449626473,0.00018289508856342943,0],"y":[1,0.99186991869918695,0.99186991869918695,0.99186991869918695,0.98373983739837401,0.98373983739837401,0.98373983739837401,0.98373983739837401,0.98373983739837401,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.96747967479674801,0.96747967479674801,0.96747967479674801,0.96747967479674801,0.96747967479674801,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95121951219512191,0.95121951219512191,0.94308943089430897,0.94308943089430897,0.93495934959349591,0.92682926829268297,0.92682926829268297,0.92682926829268297,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91056910569105687,0.91056910569105687,0.91056910569105687,0.91056910569105687,0.91056910569105687,0.89430894308943087,0.88617886178861793,0.88617886178861793,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.86991869918699183,0.86991869918699183,0.86991869918699183,0.86991869918699183,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.84552845528455289,0.84552845528455289,0.83739837398373984,0.81300813008130079,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.78861788617886175,0.78861788617886175,0.75609756097560976,0.73170731707317072,0.70731707317073167,0.64227642276422769,0.5934959349593496,0],"text":["FPR: 1<br />TPR: 1<br />Threshold: 0<br />AUC: 0.98","FPR: 0.91<br />TPR: 0.99<br />Threshold: 0.01<br />AUC: 0.98","FPR: 0.78<br />TPR: 0.99<br />Threshold: 0.02<br />AUC: 0.98","FPR: 0.67<br />TPR: 0.99<br />Threshold: 0.03<br />AUC: 0.98","FPR: 0.58<br />TPR: 0.98<br />Threshold: 0.04<br />AUC: 0.98","FPR: 0.51<br />TPR: 0.98<br />Threshold: 0.05<br />AUC: 0.98","FPR: 0.45<br />TPR: 0.98<br />Threshold: 0.06<br />AUC: 0.98","FPR: 0.41<br />TPR: 0.98<br />Threshold: 0.07<br />AUC: 0.98","FPR: 0.38<br />TPR: 0.98<br />Threshold: 0.08<br />AUC: 0.98","FPR: 0.35<br />TPR: 0.98<br />Threshold: 0.09<br />AUC: 0.98","FPR: 0.33<br />TPR: 0.98<br />Threshold: 0.1<br />AUC: 0.98","FPR: 0.3<br />TPR: 0.98<br />Threshold: 0.11<br />AUC: 0.98","FPR: 0.29<br />TPR: 0.98<br />Threshold: 0.12<br />AUC: 0.98","FPR: 0.27<br />TPR: 0.98<br />Threshold: 0.13<br />AUC: 0.98","FPR: 0.25<br />TPR: 0.98<br />Threshold: 0.14<br />AUC: 0.98","FPR: 0.24<br />TPR: 0.98<br />Threshold: 0.15<br />AUC: 0.98","FPR: 0.22<br />TPR: 0.97<br />Threshold: 0.16<br />AUC: 0.98","FPR: 0.21<br />TPR: 0.97<br />Threshold: 0.17<br />AUC: 0.98","FPR: 0.2<br />TPR: 0.97<br />Threshold: 0.18<br />AUC: 0.98","FPR: 0.19<br />TPR: 0.97<br />Threshold: 0.19<br />AUC: 0.98","FPR: 0.17<br />TPR: 0.97<br />Threshold: 0.2<br />AUC: 0.98","FPR: 0.16<br />TPR: 0.96<br />Threshold: 0.21<br />AUC: 0.98","FPR: 0.15<br />TPR: 0.96<br />Threshold: 0.22<br />AUC: 0.98","FPR: 0.15<br />TPR: 0.96<br />Threshold: 0.23<br />AUC: 0.98","FPR: 0.14<br />TPR: 0.96<br />Threshold: 0.24<br />AUC: 0.98","FPR: 0.13<br />TPR: 0.96<br />Threshold: 0.25<br />AUC: 0.98","FPR: 0.12<br />TPR: 0.96<br />Threshold: 0.26<br />AUC: 0.98","FPR: 0.11<br />TPR: 0.96<br />Threshold: 0.27<br />AUC: 0.98","FPR: 0.11<br />TPR: 0.96<br />Threshold: 0.28<br />AUC: 0.98","FPR: 0.1<br />TPR: 0.95<br />Threshold: 0.29<br />AUC: 0.98","FPR: 0.1<br />TPR: 0.95<br />Threshold: 0.3<br />AUC: 0.98","FPR: 0.09<br />TPR: 0.94<br />Threshold: 0.31<br />AUC: 0.98","FPR: 0.08<br />TPR: 0.94<br />Threshold: 0.32<br />AUC: 0.98","FPR: 0.08<br />TPR: 0.93<br />Threshold: 0.33<br />AUC: 0.98","FPR: 0.08<br />TPR: 0.93<br />Threshold: 0.34<br />AUC: 0.98","FPR: 0.07<br />TPR: 0.93<br />Threshold: 0.35<br />AUC: 0.98","FPR: 0.07<br />TPR: 0.93<br />Threshold: 0.36<br />AUC: 0.98","FPR: 0.06<br />TPR: 0.92<br />Threshold: 0.37<br />AUC: 0.98","FPR: 0.06<br />TPR: 0.92<br />Threshold: 0.38<br />AUC: 0.98","FPR: 0.06<br />TPR: 0.92<br />Threshold: 0.39<br />AUC: 0.98","FPR: 0.05<br />TPR: 0.92<br />Threshold: 0.4<br />AUC: 0.98","FPR: 0.05<br />TPR: 0.92<br />Threshold: 0.41<br />AUC: 0.98","FPR: 0.05<br />TPR: 0.92<br />Threshold: 0.42<br />AUC: 0.98","FPR: 0.05<br />TPR: 0.92<br />Threshold: 0.43<br />AUC: 0.98","FPR: 0.04<br />TPR: 0.92<br />Threshold: 0.44<br />AUC: 0.98","FPR: 0.04<br />TPR: 0.91<br />Threshold: 0.45<br />AUC: 0.98","FPR: 0.04<br />TPR: 0.91<br />Threshold: 0.46<br />AUC: 0.98","FPR: 0.04<br />TPR: 0.91<br />Threshold: 0.47<br />AUC: 0.98","FPR: 0.03<br />TPR: 0.91<br />Threshold: 0.48<br />AUC: 0.98","FPR: 0.03<br />TPR: 0.91<br />Threshold: 0.49<br />AUC: 0.98","FPR: 0.03<br />TPR: 0.89<br />Threshold: 0.5<br />AUC: 0.98","FPR: 0.03<br />TPR: 0.89<br />Threshold: 0.51<br />AUC: 0.98","FPR: 0.03<br />TPR: 0.89<br />Threshold: 0.52<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.53<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.54<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.55<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.56<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.57<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.58<br />AUC: 0.98","FPR: 0.02<br />TPR: 0.88<br />Threshold: 0.59<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.87<br />Threshold: 0.6<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.87<br />Threshold: 0.61<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.87<br />Threshold: 0.62<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.87<br />Threshold: 0.63<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.64<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.65<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.66<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.67<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.68<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.69<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.7<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.71<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.72<br />AUC: 0.98","FPR: 0.01<br />TPR: 0.86<br />Threshold: 0.73<br />AUC: 0.98","FPR: 0<br />TPR: 0.86<br />Threshold: 0.74<br />AUC: 0.98","FPR: 0<br />TPR: 0.86<br />Threshold: 0.75<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.76<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.77<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.78<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.79<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.8<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.81<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.82<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.83<br />AUC: 0.98","FPR: 0<br />TPR: 0.85<br />Threshold: 0.84<br />AUC: 0.98","FPR: 0<br />TPR: 0.84<br />Threshold: 0.85<br />AUC: 0.98","FPR: 0<br />TPR: 0.81<br />Threshold: 0.86<br />AUC: 0.98","FPR: 0<br />TPR: 0.8<br />Threshold: 0.87<br />AUC: 0.98","FPR: 0<br />TPR: 0.8<br />Threshold: 0.88<br />AUC: 0.98","FPR: 0<br />TPR: 0.8<br />Threshold: 0.89<br />AUC: 0.98","FPR: 0<br />TPR: 0.8<br />Threshold: 0.9<br />AUC: 0.98","FPR: 0<br />TPR: 0.8<br />Threshold: 0.91<br />AUC: 0.98","FPR: 0<br />TPR: 0.8<br />Threshold: 0.92<br />AUC: 0.98","FPR: 0<br />TPR: 0.79<br />Threshold: 0.93<br />AUC: 0.98","FPR: 0<br />TPR: 0.79<br />Threshold: 0.94<br />AUC: 0.98","FPR: 0<br />TPR: 0.76<br />Threshold: 0.95<br />AUC: 0.98","FPR: 0<br />TPR: 0.73<br />Threshold: 0.96<br />AUC: 0.98","FPR: 0<br />TPR: 0.71<br />Threshold: 0.97<br />AUC: 0.98","FPR: 0<br />TPR: 0.64<br />Threshold: 0.98<br />AUC: 0.98","FPR: 0<br />TPR: 0.59<br />Threshold: 0.99<br />AUC: 0.98","FPR: 0<br />TPR: 0<br />Threshold: 1<br />AUC: 0.98"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(163,190,140,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(163,190,140,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[0.5],"y":[0.5],"text":"AUC: 0.976","hovertext":"","textfont":{"size":22.677165354330711,"color":"rgba(0,0,0,1)"},"type":"scatter","mode":"text","hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.228310502283104,"r":7.3059360730593621,"b":52.137816521378163,"l":66.218347862183478},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.050000000000000003,1.05],"tickmode":"array","ticktext":["0.00","0.25","0.50","0.75","1.00"],"tickvals":[0,0.25,0.5,0.75,1],"categoryorder":"array","categoryarray":["0.00","0.25","0.50","0.75","1.00"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.6529680365296811,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029056},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"False positive rate","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.050000000000000003,1.05],"tickmode":"array","ticktext":["0.00","0.25","0.50","0.75","1.00"],"tickvals":[0,0.25,0.5,0.75,1],"categoryorder":"array","categoryarray":["0.00","0.25","0.50","0.75","1.00"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.6529680365296811,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029059},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"True positive rate (Recall)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(51,51,51,1)","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":17.002905770029056}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"6fc3131bb8c35":{"x":{},"y":{},"text":{},"type":"scatter"},"6fc316d90d477":{"x":{},"y":{}}},"cur_data":"6fc3131bb8c35","visdat":{"6fc3131bb8c35":["function (y) ","x"],"6fc316d90d477":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

This AUC is killer

``` r
pr <- do.call(rbind, lapply(thresholds, get_curve, preds, score='pr'))

labels <- seq(0, 1, .1)
labels[seq(2, length(labels), 2)] <- ''

p <- pr %>% 
    ggplot(aes(x = recall, y = precision)) + 
    geom_point(color = green, aes(text = paste0('Precision: ', precision,
                                                '\nRecall: ', recall,
                                                '\nThreshold: ', threshold))) + 
    scale_x_continuous(breaks = seq(0, 1, .1)) +
    scale_y_continuous(breaks = seq(0, 1, .1), limits = c(0, 1)) +
    labs(
        x = 'Proportion of true fraud detected (Recall)',
        y = 'Proportion of correct\nfraud detections (Precision)'
    ) +
    theme_bw() + 
    theme(axis.ticks = element_blank(),
          text = element_text(size = text_size))
## Warning in geom_point(color = green, aes(text = paste0("Precision: ",
## precision, : Ignoring unknown aesthetics: text
    
ggplotly(p, tooltip = 'text')
```

<div class="plotly html-widget html-fill-item" id="htmlwidget-4" style="width:100%;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-4">{"x":{"data":[{"x":[1,0.99186991869918695,0.99186991869918695,0.99186991869918695,0.98373983739837401,0.98373983739837401,0.98373983739837401,0.98373983739837401,0.98373983739837401,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.97560975609756095,0.96747967479674801,0.96747967479674801,0.96747967479674801,0.96747967479674801,0.96747967479674801,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95934959349593496,0.95121951219512191,0.95121951219512191,0.94308943089430897,0.94308943089430897,0.93495934959349591,0.92682926829268297,0.92682926829268297,0.92682926829268297,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91869918699186992,0.91056910569105687,0.91056910569105687,0.91056910569105687,0.91056910569105687,0.91056910569105687,0.89430894308943087,0.88617886178861793,0.88617886178861793,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.87804878048780488,0.86991869918699183,0.86991869918699183,0.86991869918699183,0.86991869918699183,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.86178861788617889,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.85365853658536583,0.84552845528455289,0.84552845528455289,0.83739837398373984,0.81300813008130079,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.80487804878048785,0.78861788617886175,0.78861788617886175,0.75609756097560976,0.73170731707317072,0.70731707317073167,0.64227642276422769,0.5934959349593496,0],"y":[0.0017274795651807534,0.0018752497771219528,0.0021841488085647277,0.0025654505309641467,0.0029514354708881137,0.0033551464063886426,0.0037440435670524166,0.0041239221567090419,0.0044879640962872296,0.0048128985681626761,0.0051517623320310822,0.0055068606305355419,0.005882929698990097,0.0062748379000209164,0.006674824785849371,0.0070934562865756336,0.007465963987703118,0.0079301612688258034,0.0084253752478051537,0.0089615181866104371,0.0095360205144643002,0.010022933831648687,0.010643095517272482,0.011296189929159487,0.012004069175991861,0.012756756756756757,0.013488797439414724,0.014351739236195572,0.015204226259502641,0.015968336290432646,0.016927083333333332,0.017848899830743191,0.018855656697009102,0.019820751465012065,0.020738584682554122,0.021999228097259745,0.023142509135200974,0.024160786829163994,0.025438991445294913,0.026764566556134534,0.028250000000000001,0.02990209050013231,0.031423804226918796,0.033521210323346186,0.035714285714285712,0.037445670344366432,0.039857651245551601,0.042617960426179602,0.045252525252525252,0.048275862068965517,0.050902360018509951,0.053933696190004946,0.057580559957739037,0.060776589758019132,0.064709406830437383,0.069319640564826701,0.073319755600814662,0.077586206896551727,0.082568807339449546,0.088163265306122451,0.093368237347294936,0.099165894346617239,0.10657370517928287,0.11239495798319328,0.11856823266219239,0.12604042806183116,0.13400758533501897,0.14402173913043478,0.15939849624060151,0.16852146263910969,0.18027210884353742,0.1962962962962963,0.21632653061224491,0.22844827586206898,0.24200913242009131,0.2560386473429952,0.27272727272727271,0.29411764705882354,0.32110091743119268,0.3523489932885906,0.375,0.40856031128404668,0.44117647058823528,0.4642857142857143,0.51231527093596063,0.55376344086021501,0.59523809523809523,0.63057324840764328,0.66000000000000003,0.6827586206896552,0.69230769230769229,0.70714285714285718,0.73333333333333328,0.74045801526717558,0.76377952755905509,0.78151260504201681,0.81081081081081086,0.84466019417475724,0.84042553191489366,0.84883720930232553,null],"text":["Precision: 0.00172747956518075<br />Recall: 1<br />Threshold: 0","Precision: 0.00187524977712195<br />Recall: 0.991869918699187<br />Threshold: 0.01","Precision: 0.00218414880856473<br />Recall: 0.991869918699187<br />Threshold: 0.02","Precision: 0.00256545053096415<br />Recall: 0.991869918699187<br />Threshold: 0.03","Precision: 0.00295143547088811<br />Recall: 0.983739837398374<br />Threshold: 0.04","Precision: 0.00335514640638864<br />Recall: 0.983739837398374<br />Threshold: 0.05","Precision: 0.00374404356705242<br />Recall: 0.983739837398374<br />Threshold: 0.06","Precision: 0.00412392215670904<br />Recall: 0.983739837398374<br />Threshold: 0.07","Precision: 0.00448796409628723<br />Recall: 0.983739837398374<br />Threshold: 0.08","Precision: 0.00481289856816268<br />Recall: 0.975609756097561<br />Threshold: 0.09","Precision: 0.00515176233203108<br />Recall: 0.975609756097561<br />Threshold: 0.1","Precision: 0.00550686063053554<br />Recall: 0.975609756097561<br />Threshold: 0.11","Precision: 0.0058829296989901<br />Recall: 0.975609756097561<br />Threshold: 0.12","Precision: 0.00627483790002092<br />Recall: 0.975609756097561<br />Threshold: 0.13","Precision: 0.00667482478584937<br />Recall: 0.975609756097561<br />Threshold: 0.14","Precision: 0.00709345628657563<br />Recall: 0.975609756097561<br />Threshold: 0.15","Precision: 0.00746596398770312<br />Recall: 0.967479674796748<br />Threshold: 0.16","Precision: 0.0079301612688258<br />Recall: 0.967479674796748<br />Threshold: 0.17","Precision: 0.00842537524780515<br />Recall: 0.967479674796748<br />Threshold: 0.18","Precision: 0.00896151818661044<br />Recall: 0.967479674796748<br />Threshold: 0.19","Precision: 0.0095360205144643<br />Recall: 0.967479674796748<br />Threshold: 0.2","Precision: 0.0100229338316487<br />Recall: 0.959349593495935<br />Threshold: 0.21","Precision: 0.0106430955172725<br />Recall: 0.959349593495935<br />Threshold: 0.22","Precision: 0.0112961899291595<br />Recall: 0.959349593495935<br />Threshold: 0.23","Precision: 0.0120040691759919<br />Recall: 0.959349593495935<br />Threshold: 0.24","Precision: 0.0127567567567568<br />Recall: 0.959349593495935<br />Threshold: 0.25","Precision: 0.0134887974394147<br />Recall: 0.959349593495935<br />Threshold: 0.26","Precision: 0.0143517392361956<br />Recall: 0.959349593495935<br />Threshold: 0.27","Precision: 0.0152042262595026<br />Recall: 0.959349593495935<br />Threshold: 0.28","Precision: 0.0159683362904326<br />Recall: 0.951219512195122<br />Threshold: 0.29","Precision: 0.0169270833333333<br />Recall: 0.951219512195122<br />Threshold: 0.3","Precision: 0.0178488998307432<br />Recall: 0.943089430894309<br />Threshold: 0.31","Precision: 0.0188556566970091<br />Recall: 0.943089430894309<br />Threshold: 0.32","Precision: 0.0198207514650121<br />Recall: 0.934959349593496<br />Threshold: 0.33","Precision: 0.0207385846825541<br />Recall: 0.926829268292683<br />Threshold: 0.34","Precision: 0.0219992280972597<br />Recall: 0.926829268292683<br />Threshold: 0.35","Precision: 0.023142509135201<br />Recall: 0.926829268292683<br />Threshold: 0.36","Precision: 0.024160786829164<br />Recall: 0.91869918699187<br />Threshold: 0.37","Precision: 0.0254389914452949<br />Recall: 0.91869918699187<br />Threshold: 0.38","Precision: 0.0267645665561345<br />Recall: 0.91869918699187<br />Threshold: 0.39","Precision: 0.02825<br />Recall: 0.91869918699187<br />Threshold: 0.4","Precision: 0.0299020905001323<br />Recall: 0.91869918699187<br />Threshold: 0.41","Precision: 0.0314238042269188<br />Recall: 0.91869918699187<br />Threshold: 0.42","Precision: 0.0335212103233462<br />Recall: 0.91869918699187<br />Threshold: 0.43","Precision: 0.0357142857142857<br />Recall: 0.91869918699187<br />Threshold: 0.44","Precision: 0.0374456703443664<br />Recall: 0.910569105691057<br />Threshold: 0.45","Precision: 0.0398576512455516<br />Recall: 0.910569105691057<br />Threshold: 0.46","Precision: 0.0426179604261796<br />Recall: 0.910569105691057<br />Threshold: 0.47","Precision: 0.0452525252525253<br />Recall: 0.910569105691057<br />Threshold: 0.48","Precision: 0.0482758620689655<br />Recall: 0.910569105691057<br />Threshold: 0.49","Precision: 0.05090236001851<br />Recall: 0.894308943089431<br />Threshold: 0.5","Precision: 0.0539336961900049<br />Recall: 0.886178861788618<br />Threshold: 0.51","Precision: 0.057580559957739<br />Recall: 0.886178861788618<br />Threshold: 0.52","Precision: 0.0607765897580191<br />Recall: 0.878048780487805<br />Threshold: 0.53","Precision: 0.0647094068304374<br />Recall: 0.878048780487805<br />Threshold: 0.54","Precision: 0.0693196405648267<br />Recall: 0.878048780487805<br />Threshold: 0.55","Precision: 0.0733197556008147<br />Recall: 0.878048780487805<br />Threshold: 0.56","Precision: 0.0775862068965517<br />Recall: 0.878048780487805<br />Threshold: 0.57","Precision: 0.0825688073394495<br />Recall: 0.878048780487805<br />Threshold: 0.58","Precision: 0.0881632653061225<br />Recall: 0.878048780487805<br />Threshold: 0.59","Precision: 0.0933682373472949<br />Recall: 0.869918699186992<br />Threshold: 0.6","Precision: 0.0991658943466172<br />Recall: 0.869918699186992<br />Threshold: 0.61","Precision: 0.106573705179283<br />Recall: 0.869918699186992<br />Threshold: 0.62","Precision: 0.112394957983193<br />Recall: 0.869918699186992<br />Threshold: 0.63","Precision: 0.118568232662192<br />Recall: 0.861788617886179<br />Threshold: 0.64","Precision: 0.126040428061831<br />Recall: 0.861788617886179<br />Threshold: 0.65","Precision: 0.134007585335019<br />Recall: 0.861788617886179<br />Threshold: 0.66","Precision: 0.144021739130435<br />Recall: 0.861788617886179<br />Threshold: 0.67","Precision: 0.159398496240602<br />Recall: 0.861788617886179<br />Threshold: 0.68","Precision: 0.16852146263911<br />Recall: 0.861788617886179<br />Threshold: 0.69","Precision: 0.180272108843537<br />Recall: 0.861788617886179<br />Threshold: 0.7","Precision: 0.196296296296296<br />Recall: 0.861788617886179<br />Threshold: 0.71","Precision: 0.216326530612245<br />Recall: 0.861788617886179<br />Threshold: 0.72","Precision: 0.228448275862069<br />Recall: 0.861788617886179<br />Threshold: 0.73","Precision: 0.242009132420091<br />Recall: 0.861788617886179<br />Threshold: 0.74","Precision: 0.256038647342995<br />Recall: 0.861788617886179<br />Threshold: 0.75","Precision: 0.272727272727273<br />Recall: 0.853658536585366<br />Threshold: 0.76","Precision: 0.294117647058824<br />Recall: 0.853658536585366<br />Threshold: 0.77","Precision: 0.321100917431193<br />Recall: 0.853658536585366<br />Threshold: 0.78","Precision: 0.352348993288591<br />Recall: 0.853658536585366<br />Threshold: 0.79","Precision: 0.375<br />Recall: 0.853658536585366<br />Threshold: 0.8","Precision: 0.408560311284047<br />Recall: 0.853658536585366<br />Threshold: 0.81","Precision: 0.441176470588235<br />Recall: 0.853658536585366<br />Threshold: 0.82","Precision: 0.464285714285714<br />Recall: 0.845528455284553<br />Threshold: 0.83","Precision: 0.512315270935961<br />Recall: 0.845528455284553<br />Threshold: 0.84","Precision: 0.553763440860215<br />Recall: 0.83739837398374<br />Threshold: 0.85","Precision: 0.595238095238095<br />Recall: 0.813008130081301<br />Threshold: 0.86","Precision: 0.630573248407643<br />Recall: 0.804878048780488<br />Threshold: 0.87","Precision: 0.66<br />Recall: 0.804878048780488<br />Threshold: 0.88","Precision: 0.682758620689655<br />Recall: 0.804878048780488<br />Threshold: 0.89","Precision: 0.692307692307692<br />Recall: 0.804878048780488<br />Threshold: 0.9","Precision: 0.707142857142857<br />Recall: 0.804878048780488<br />Threshold: 0.91","Precision: 0.733333333333333<br />Recall: 0.804878048780488<br />Threshold: 0.92","Precision: 0.740458015267176<br />Recall: 0.788617886178862<br />Threshold: 0.93","Precision: 0.763779527559055<br />Recall: 0.788617886178862<br />Threshold: 0.94","Precision: 0.781512605042017<br />Recall: 0.75609756097561<br />Threshold: 0.95","Precision: 0.810810810810811<br />Recall: 0.731707317073171<br />Threshold: 0.96","Precision: 0.844660194174757<br />Recall: 0.707317073170732<br />Threshold: 0.97","Precision: 0.840425531914894<br />Recall: 0.642276422764228<br />Threshold: 0.98","Precision: 0.848837209302326<br />Recall: 0.59349593495935<br />Threshold: 0.99","Precision: NaN<br />Recall: 0<br />Threshold: 1"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(163,190,140,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(163,190,140,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.228310502283104,"r":7.3059360730593621,"b":52.137816521378163,"l":57.716894977168948},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.050000000000000003,1.05],"tickmode":"array","ticktext":["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"],"tickvals":[0,0.10000000000000002,0.20000000000000001,0.30000000000000004,0.40000000000000002,0.5,0.60000000000000009,0.70000000000000007,0.80000000000000004,0.90000000000000002,1],"categoryorder":"array","categoryarray":["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.6529680365296811,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029056},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"Proportion of true fraud detected (Recall)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.050000000000000003,1.05],"tickmode":"array","ticktext":["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"],"tickvals":[0,0.10000000000000002,0.20000000000000001,0.30000000000000004,0.40000000000000002,0.5,0.60000000000000009,0.70000000000000007,0.80000000000000004,0.90000000000000002,1],"categoryorder":"array","categoryarray":["0.0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.6529680365296811,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029059},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"Proportion of correct<br />fraud detections (Precision)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(51,51,51,1)","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":17.002905770029056}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"6fc3146850dd":{"x":{},"y":{},"text":{},"type":"scatter"}},"cur_data":"6fc3146850dd","visdat":{"6fc3146850dd":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

Double check that this is actually right…
eh chat bot thinks it’s okay
small change
the DTs are messed up now…

## <u>What it means</u>
