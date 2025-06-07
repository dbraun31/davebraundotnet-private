---
title: "How perceptions of community behavior improve COVID-19 predictions"
summary: "Can crowdsourced perceptions improve pandemic forecasting? In this project, I explore how reports of community compliance with public health measures shaped COVID-19 spread—and highlight a powerful Bayesian model we used to predict future case trends."
date: "2022-03-20"
image: "/images/metal_ball.png?v=2"
skills:
    - Time-series forecasting
    - Bayesian modeling
    - Multimodal data integration
    - R, Python
read_time: 10
output: bookdown::html_document2
---

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
📄 <a href="http://dx.doi.org/10.2196/39336" target="_blank">Read the Paper</a>  
🖼 <a href="/portfolio/Braun_MIDAS_2022.pdf" target="_blank">View the Poster</a>  
💾 <a href="https://osf.io/9khrq" target="_blank">Download the data</a>

### TL;DR

I built models that accurately predicted COVID-19 case numbers up to three weeks ahead—using not just case data, but also how well people thought their communities were following safety guidelines like social distancing. This approach shows how public perception can be used to improve real-time forecasting tools for organizations like the CDC.

### Key Skills

- 📈 **Time-Series Forecasting** – Applied epidemiological models to predict COVID-19
  cases using behavioral and clinical data

- 🧠 **Bayesian Modeling** – Leveraged probabilistic forecasts to support real-time
  public health decision-making

- 🔗 **Multimodal Data Integration** – Combined self-reported survey data with case count time series to enhance model accuracy

- 📊 **Communicating Uncertainty** – Created clear, decision-relevant visualizations for probabilistic outcomes and behavioral drivers

### What I Learned

How to turn crowdsourced human behavior data into probabilistic forecasts using Bayesian modeling—providing community leaders and health systems with more informative, uncertainty-aware predictions of epidemic spread.

{{% /highlightbox %}}

## <u>What we were interested in </u>

### What if we could improve pandemic forecasting by asking people how well their neighbors are following the rules?

Modeling the path of infectious diseases is a popular and important area of
research,[^1]<sup>,</sup>[^2] hugely supporting public health
situational awareness during a pandemic.[^3]<sup>,</sup>[^4]
Most models of infectious disease are purely *computational*, meaning they rely
only on existing data found on the internet to support their predictions.
[^5]<sup>,</sup>[^6] However, including data generated
by humans has been proven to enhance forecasting infectious
diseases.[^7]<sup>,</sup>[^8]<sup>,</sup>[^9]<sup>,</sup>[^10]

> <p style="font-size: 1.5em;">
>
> Can we identify the most effective non-pharmaceutical interventions by seeing which ones most improve a model’s ability to predict future cases?
> </p>

During the COVID-19 pandemic, the CDC issued many *non-pharmaceutical
interventions* (NPIs), or behavior-based ways of mitigating the spread of the
disease (eg, social distancing). During the pandemic, I’m sure we all had some
intuitions around whether people were adhering to these NPIs, how that adherence
changed throughout the course of the pandemic, and how effective that NPI might
have been for reducing the spread of the disease. In this study,
we wanted to know whether the degree to which people were adhering to NPIs could
improve predictions of infectious disease spread, and see which NPIs improved
predictions the most.

<div class="figure" style="text-align: center">

<img src="masked_crowd.jpg" alt="Can we better predict the spread of disease if we can measure how many people are wearing masks or social distancing?" width="100%" />
<p class="caption">

<span id="fig:unnamed-chunk-1"></span>Figure 1: Can we better predict the spread of disease if we can measure how many people are wearing masks or social distancing?
</p>

</div>

## <u> How we did it </u>

### We asked a crowd 21 questions about their community’s compliance with NPIs over 35 weeks and tested whether their responses improved COVID-19 case forecasts

Each week during the COVID-19 pandemic—from August 2020 through April
2021—we sent surveys to people across the US asking them 21 core questions
about how well their communities were complying with the CDC’s NPI regulations
(see *Figure <a href="#fig:survey">2</a>*).

<div class="figure">

<div class="reactable html-widget html-fill-item" id="htmlwidget-1" style="width:auto;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"Preface":["What percent of people in your community do you notice are usually","","","How common is it in your community for","","","","","","In your community, how common is it for people to follow recommendations or requirements to","","","","","","How many people in your community are aware of","","","In your state, what percent of","",""],"Question":["Wearing a mask in public","Maintaining social distance","Staying at home","Restaurants complying with CDC recommendations to have reduced seating","Businesses to be closed – work from home only","Hairdresser and barber complying with CDC restrictions","Visitors to senior living facilities to be restricted","Commonly touched surfaces to be sanitized","Special protection in hospital areas that treat COVID patients","Get tested for active virus","Get antibody testing to detect prior infection","Quarantine people who have been in close contact with people with positive tests","Quarantine people with positive tests","Quarantine travelers from higher infection places","Limit large gatherings of people","Local level of COVID infections","Statewide targets for reducing COVID spread","Local approach to limiting COVID spread","Colleges are closed or holding only remote classes","Schools (K-12) are closed or holding only remote classes","Violations of COVID restrictions result in fines or police enforcement"]},"columns":[{"id":"Preface","name":"Preface","type":"character"},{"id":"Question","name":"Question","type":"character"}],"sortable":false,"searchable":true,"defaultPageSize":10,"showPageSizeOptions":false,"paginationType":"numbers","highlight":true,"theme":{"color":"inherit","backgroundColor":"transparent","borderColor":"inherit","stripedColor":"rgba(0, 0, 0, 0.02)","highlightColor":"rgba(0, 0, 0, 0.05)","style":{"fontSize":"0.95em"},"pageButtonStyle":{"background":"transparent","color":"inherit","border":"1px solid #ccc","borderRadius":"4px","padding":"4px 8px","margin":"0 2px"},"pageButtonHoverStyle":{"background":"#ddd"},"pageButtonActiveStyle":{"background":"#bbb","fontWeight":"bold"}},"dataKey":"0be8f0afe6c228d6dc808107298789f4"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script>

<p class="caption">

<span id="fig:survey"></span>Figure 2: The 21 survey questions posed to the crowd. Responses were on a Likert scale from 0% to 100% in increments of 20. Participants also had the option of selecting ‘Don’t know’.
</p>

</div>

We collected a total of 10,852 survey responses across three different survey
platforms. These responses were evenly distributed over time and roughly
geographically representative of the US population (see *Figures
<a href="#fig:responses">3</a> and <a href="#fig:geography">4</a>*).

``` r

dates <- unique(d$year_month_day)
dates <- dates[order(unique(d$mw))]
dates <- ifelse((seq_along(dates)+3) %% 4 == 0, dates, "")

p1 <- d %>% 
    group_by(mw, survey_platform) %>% 
    summarize(year_month_day = unique(year_month_day),
              count = length(unique(id))) %>% 
    mutate(survey_platform = recode(survey_platform, `sm_volunteer` = 'Platform A',
                                    `sm_paid` = 'Platform B', `pollfish` = 'Platform C')) %>% 
    ggplot(aes(x = reorder(year_month_day, mw), y = count, 
               color=survey_platform, group=survey_platform,
           text=paste0('Date: ', year_month_day, '<br>Number of responses: ', count,
                       '<br>Survey platform: ', survey_platform))) + 
    geom_line() + 
    geom_point() +
    labs(
        x = 'Date',
        y = 'Number of responses',
        color = 'Survey platform'
    ) + 
    ylim(0, 450) +
    scale_x_discrete(labels = dates, breaks = dates) +
    scale_color_manual(values = qual[c(1, 4, 5)]) + 
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = 'bottom',
          text = element_text(size = 16))
## `summarise()` has grouped output by 'mw'. You can override using the `.groups`
## argument.


pp1 <- ggplotly(p1, tooltip='text')
pp1 %>%
    layout(
        legend = list(
          orientation = "h",  # horizontal legend
          x = 0.5,            # centered horizontally
          xanchor = "center",
          y = -0.5,           # move below the plot area
          yanchor = "top"
        )
      )
```

<div class="figure">

<div class="plotly html-widget html-fill-item" id="htmlwidget-2" style="width:100%;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"data":[{"x":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35],"y":[119,120,100,81,89,71,120,103,99,84,111,112,55,81,85,118,61,63,93,95,92,85,98,82,80,97,105,75,71,81,69,68,72,63,18],"text":["Date: 2020-09-05<br>Number of responses: 119<br>Survey platform: Platform A","Date: 2020-09-12<br>Number of responses: 120<br>Survey platform: Platform A","Date: 2020-09-19<br>Number of responses: 100<br>Survey platform: Platform A","Date: 2020-09-26<br>Number of responses: 81<br>Survey platform: Platform A","Date: 2020-10-03<br>Number of responses: 89<br>Survey platform: Platform A","Date: 2020-10-10<br>Number of responses: 71<br>Survey platform: Platform A","Date: 2020-10-17<br>Number of responses: 120<br>Survey platform: Platform A","Date: 2020-10-24<br>Number of responses: 103<br>Survey platform: Platform A","Date: 2020-10-31<br>Number of responses: 99<br>Survey platform: Platform A","Date: 2020-11-07<br>Number of responses: 84<br>Survey platform: Platform A","Date: 2020-11-14<br>Number of responses: 111<br>Survey platform: Platform A","Date: 2020-11-21<br>Number of responses: 112<br>Survey platform: Platform A","Date: 2020-11-28<br>Number of responses: 55<br>Survey platform: Platform A","Date: 2020-12-05<br>Number of responses: 81<br>Survey platform: Platform A","Date: 2020-12-12<br>Number of responses: 85<br>Survey platform: Platform A","Date: 2020-12-19<br>Number of responses: 118<br>Survey platform: Platform A","Date: 2020-12-26<br>Number of responses: 61<br>Survey platform: Platform A","Date: 2021-01-02<br>Number of responses: 63<br>Survey platform: Platform A","Date: 2021-01-09<br>Number of responses: 93<br>Survey platform: Platform A","Date: 2021-01-16<br>Number of responses: 95<br>Survey platform: Platform A","Date: 2021-01-23<br>Number of responses: 92<br>Survey platform: Platform A","Date: 2021-01-30<br>Number of responses: 85<br>Survey platform: Platform A","Date: 2021-02-06<br>Number of responses: 98<br>Survey platform: Platform A","Date: 2021-02-13<br>Number of responses: 82<br>Survey platform: Platform A","Date: 2021-02-20<br>Number of responses: 80<br>Survey platform: Platform A","Date: 2021-02-27<br>Number of responses: 97<br>Survey platform: Platform A","Date: 2021-03-06<br>Number of responses: 105<br>Survey platform: Platform A","Date: 2021-03-13<br>Number of responses: 75<br>Survey platform: Platform A","Date: 2021-03-20<br>Number of responses: 71<br>Survey platform: Platform A","Date: 2021-03-27<br>Number of responses: 81<br>Survey platform: Platform A","Date: 2021-04-03<br>Number of responses: 69<br>Survey platform: Platform A","Date: 2021-04-10<br>Number of responses: 68<br>Survey platform: Platform A","Date: 2021-04-17<br>Number of responses: 72<br>Survey platform: Platform A","Date: 2021-04-24<br>Number of responses: 63<br>Survey platform: Platform A","Date: 2021-05-01<br>Number of responses: 18<br>Survey platform: Platform A"],"type":"scatter","mode":"lines+markers","line":{"width":1.8897637795275593,"color":"rgba(191,97,106,1)","dash":"solid"},"hoveron":"points","name":"Platform A","legendgroup":"Platform A","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","marker":{"autocolorscale":false,"color":"rgba(191,97,106,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(191,97,106,1)"}},"frame":null},{"x":[4,5,8,12,13,14,15,16,17,18,19,20,21,22,23,24,25],"y":[244,263,248,320,330,308,291,227,213,226,221,304,262,235,140,121,18],"text":["Date: 2020-09-26<br>Number of responses: 244<br>Survey platform: Platform B","Date: 2020-10-03<br>Number of responses: 263<br>Survey platform: Platform B","Date: 2020-10-24<br>Number of responses: 248<br>Survey platform: Platform B","Date: 2020-11-21<br>Number of responses: 320<br>Survey platform: Platform B","Date: 2020-11-28<br>Number of responses: 330<br>Survey platform: Platform B","Date: 2020-12-05<br>Number of responses: 308<br>Survey platform: Platform B","Date: 2020-12-12<br>Number of responses: 291<br>Survey platform: Platform B","Date: 2020-12-19<br>Number of responses: 227<br>Survey platform: Platform B","Date: 2020-12-26<br>Number of responses: 213<br>Survey platform: Platform B","Date: 2021-01-02<br>Number of responses: 226<br>Survey platform: Platform B","Date: 2021-01-09<br>Number of responses: 221<br>Survey platform: Platform B","Date: 2021-01-16<br>Number of responses: 304<br>Survey platform: Platform B","Date: 2021-01-23<br>Number of responses: 262<br>Survey platform: Platform B","Date: 2021-01-30<br>Number of responses: 235<br>Survey platform: Platform B","Date: 2021-02-06<br>Number of responses: 140<br>Survey platform: Platform B","Date: 2021-02-13<br>Number of responses: 121<br>Survey platform: Platform B","Date: 2021-02-20<br>Number of responses: 18<br>Survey platform: Platform B"],"type":"scatter","mode":"lines+markers","line":{"width":1.8897637795275593,"color":"rgba(163,190,140,1)","dash":"solid"},"hoveron":"points","name":"Platform B","legendgroup":"Platform B","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","marker":{"autocolorscale":false,"color":"rgba(163,190,140,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(163,190,140,1)"}},"frame":null},{"x":[25,26,27,29,30,31,32,33,34,35],"y":[243,263,273,247,236,264,246,251,262,245],"text":["Date: 2021-02-20<br>Number of responses: 243<br>Survey platform: Platform C","Date: 2021-02-27<br>Number of responses: 263<br>Survey platform: Platform C","Date: 2021-03-06<br>Number of responses: 273<br>Survey platform: Platform C","Date: 2021-03-20<br>Number of responses: 247<br>Survey platform: Platform C","Date: 2021-03-27<br>Number of responses: 236<br>Survey platform: Platform C","Date: 2021-04-03<br>Number of responses: 264<br>Survey platform: Platform C","Date: 2021-04-10<br>Number of responses: 246<br>Survey platform: Platform C","Date: 2021-04-17<br>Number of responses: 251<br>Survey platform: Platform C","Date: 2021-04-24<br>Number of responses: 262<br>Survey platform: Platform C","Date: 2021-05-01<br>Number of responses: 245<br>Survey platform: Platform C"],"type":"scatter","mode":"lines+markers","line":{"width":1.8897637795275593,"color":"rgba(180,142,173,1)","dash":"solid"},"hoveron":"points","name":"Platform C","legendgroup":"Platform C","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","marker":{"autocolorscale":false,"color":"rgba(180,142,173,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(180,142,173,1)"}},"frame":null}],"layout":{"margin":{"t":26.228310502283104,"r":7.3059360730593621,"b":80.679354447930223,"l":57.716894977168948},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.40000000000000002,35.600000000000001],"tickmode":"array","ticktext":["2020-09-05","2020-10-03","2020-10-31","2020-11-28","2020-12-26","2021-01-23","2021-02-20","2021-03-20","2021-04-17"],"tickvals":[1,5,9,13,17,21,25,29,33],"categoryorder":"array","categoryarray":["2020-09-05","2020-10-03","2020-10-31","2020-11-28","2020-12-26","2021-01-23","2021-02-20","2021-03-20","2021-04-17"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029056},"tickangle":-45,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"Date","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-22.5,472.5],"tickmode":"array","ticktext":["0","100","200","300","400"],"tickvals":[0,100,200,300,400],"categoryorder":"array","categoryarray":["0","100","200","300","400"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029059},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"Number of responses","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(51,51,51,1)","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":17.002905770029056},"title":{"text":"Survey platform","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"orientation":"h","x":0.5,"xanchor":"center","y":-0.5,"yanchor":"top"},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"f1a83b01dc49":{"x":{},"y":{},"colour":{},"text":{},"type":"scatter"},"f1a8638660c0":{"x":{},"y":{},"colour":{},"text":{}}},"cur_data":"f1a83b01dc49","visdat":{"f1a83b01dc49":["function (y) ","x"],"f1a8638660c0":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

<p class="caption">

<span id="fig:responses"></span>Figure 3: Data collected across three survey platforms over time.
</p>

</div>

``` r
p2 <- census %>% 
    mutate(state_title = str_to_title(state),
           expected = pop_prop * N) %>% 
    relocate(expected, .after = observed) %>% 
    mutate(diff = abs(observed - expected)) %>% 
    mutate(outlier = ifelse(diff > quantile(diff, probs = .9), 'yes', 'no')) %>% 
    mutate(outlier_label = ifelse(outlier == 'yes', state_title, NA)) %>% 
    ggplot(aes(x = expected, y = observed)) + 
    geom_abline(slope = 1, intercept = 0, linetype = 'dashed') + 
    geom_point(aes(color = outlier,
                   text = paste0('Expected: ', round(expected), '<br>Observed: ', observed,
                                 '<br>State: ', state_title))) + 
    geom_text(aes(label = outlier_label, text = NULL), nudge_y = 40) +
    ylim(0, 1200) + 
    xlim(0, 1200) + 
    labs(
        x = 'Expected',
        y = 'Observed'
    ) +
    scale_color_manual(values = c(`no` = qual[1], `yes` = qual[3])) + 
    theme_bw() +
    theme(panel.grid = element_blank(),
          axis.ticks = element_blank(),
          legend.position = 'none',
          text = element_text(size = 16))
## Warning in geom_point(aes(color = outlier, text = paste0("Expected: ",
## round(expected), : Ignoring unknown aesthetics: text

pp2 <- ggplotly(p2, tooltip='text')
pp2
```

<div class="figure">

<div class="plotly html-widget html-fill-item" id="htmlwidget-3" style="width:100%;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-3">{"x":{"data":[{"x":[-60,1260],"y":[-60,1260],"text":"","type":"scatter","mode":"lines","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)","dash":"dash"},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[141.09384964964568,21.050908795395248,209.45206065859639,86.840203632557063,165.71314999454475,102.59455189552021,28.020992764955341,618.04247547107275,305.52652702859262,40.743074367200727,51.42450884968526,364.64379927765782,193.72605671507151,90.790164396021694,83.833403695395504,128.56157427178078,133.77350470932157,38.680989158118557,173.97023872235494,198.33838249866807,287.38138577893989,85.641541067886138,176.61037539222474,30.755111716333158,55.664444950184787,88.634442216937359,39.126987743878601,255.59353367649524,60.338264957780886,301.80467329069864,21.929064730722637,336.36506024954662,113.86563455019709,121.36942622800233,91.901607029507446,30.484128512119835,148.15918204290188,25.45691095424829,196.51602980252005,92.254515388482943,17.955881768489817,245.61774325620874,219.12584739106097,51.570748272411407,167.54612101949755,16.654345151035351],"y":[80,15,127,51,118,212,37,456,304,14,54,342,138,115,68,142,138,58,138,272,258,31,131,18,75,65,24,390,25,228,12,393,69,90,16,42,86,9,174,67,11,194,319,28,275,20],"text":["Expected: 141<br>Observed: 80<br>State: Alabama","Expected: 21<br>Observed: 15<br>State: Alaska","Expected: 209<br>Observed: 127<br>State: Arizona","Expected: 87<br>Observed: 51<br>State: Arkansas","Expected: 166<br>Observed: 118<br>State: Colorado","Expected: 103<br>Observed: 212<br>State: Connecticut","Expected: 28<br>Observed: 37<br>State: Delaware","Expected: 618<br>Observed: 456<br>State: Florida","Expected: 306<br>Observed: 304<br>State: Georgia","Expected: 41<br>Observed: 14<br>State: Hawaii","Expected: 51<br>Observed: 54<br>State: Idaho","Expected: 365<br>Observed: 342<br>State: Illinois","Expected: 194<br>Observed: 138<br>State: Indiana","Expected: 91<br>Observed: 115<br>State: Iowa","Expected: 84<br>Observed: 68<br>State: Kansas","Expected: 129<br>Observed: 142<br>State: Kentucky","Expected: 134<br>Observed: 138<br>State: Louisiana","Expected: 39<br>Observed: 58<br>State: Maine","Expected: 174<br>Observed: 138<br>State: Maryland","Expected: 198<br>Observed: 272<br>State: Massachusetts","Expected: 287<br>Observed: 258<br>State: Michigan","Expected: 86<br>Observed: 31<br>State: Mississippi","Expected: 177<br>Observed: 131<br>State: Missouri","Expected: 31<br>Observed: 18<br>State: Montana","Expected: 56<br>Observed: 75<br>State: Nebraska","Expected: 89<br>Observed: 65<br>State: Nevada","Expected: 39<br>Observed: 24<br>State: New Hampshire","Expected: 256<br>Observed: 390<br>State: New Jersey","Expected: 60<br>Observed: 25<br>State: New Mexico","Expected: 302<br>Observed: 228<br>State: North Carolina","Expected: 22<br>Observed: 12<br>State: North Dakota","Expected: 336<br>Observed: 393<br>State: Ohio","Expected: 114<br>Observed: 69<br>State: Oklahoma","Expected: 121<br>Observed: 90<br>State: Oregon","Expected: 92<br>Observed: 16<br>State: Puerto Rico","Expected: 30<br>Observed: 42<br>State: Rhode Island","Expected: 148<br>Observed: 86<br>State: South Carolina","Expected: 25<br>Observed: 9<br>State: South Dakota","Expected: 197<br>Observed: 174<br>State: Tennessee","Expected: 92<br>Observed: 67<br>State: Utah","Expected: 18<br>Observed: 11<br>State: Vermont","Expected: 246<br>Observed: 194<br>State: Virginia","Expected: 219<br>Observed: 319<br>State: Washington","Expected: 52<br>Observed: 28<br>State: West Virginia","Expected: 168<br>Observed: 275<br>State: Wisconsin","Expected: 17<br>Observed: 20<br>State: Wyoming"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(191,97,106,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(191,97,106,1)"}},"hoveron":"points","name":"no","legendgroup":"no","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1137.0021019572525,162.28581819517936,559.79487024948287,368.38950828541397,834.38427762220215],"y":[956,355,876,678,645],"text":["Expected: 1137<br>Observed: 956<br>State: California","Expected: 162<br>Observed: 355<br>State: Minnesota","Expected: 560<br>Observed: 876<br>State: New York","Expected: 368<br>Observed: 678<br>State: Pennsylvania","Expected: 834<br>Observed: 645<br>State: Texas"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(235,203,139,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(235,203,139,1)"}},"hoveron":"points","name":"yes","legendgroup":"yes","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[141.09384964964568,21.050908795395248,209.45206065859639,86.840203632557063,1137.0021019572525,165.71314999454475,102.59455189552021,28.020992764955341,618.04247547107275,305.52652702859262,40.743074367200727,51.42450884968526,364.64379927765782,193.72605671507151,90.790164396021694,83.833403695395504,128.56157427178078,133.77350470932157,38.680989158118557,173.97023872235494,198.33838249866807,287.38138577893989,162.28581819517936,85.641541067886138,176.61037539222474,30.755111716333158,55.664444950184787,88.634442216937359,39.126987743878601,255.59353367649524,60.338264957780886,559.79487024948287,301.80467329069864,21.929064730722637,336.36506024954662,113.86563455019709,121.36942622800233,368.38950828541397,91.901607029507446,30.484128512119835,148.15918204290188,25.45691095424829,196.51602980252005,834.38427762220215,92.254515388482943,17.955881768489817,245.61774325620874,219.12584739106097,51.570748272411407,167.54612101949755,16.654345151035351],"y":[120,55,167,91,996,158,252,77,496,344,54,94,382,178,155,108,182,178,98,178,312,298,395,71,171,58,115,105,64,430,65,916,268,52,433,109,130,718,56,82,126,49,214,685,107,51,234,359,68,315,60],"text":[null,null,null,null,"California",null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,"Minnesota",null,null,null,null,null,null,null,null,"New York",null,null,null,null,null,"Pennsylvania",null,null,null,null,null,"Texas",null,null,null,null,null,null,null],"hovertext":["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""],"textfont":{"size":14.66456692913386,"color":"rgba(0,0,0,1)"},"type":"scatter","mode":"text","hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":26.228310502283104,"r":7.3059360730593621,"b":52.137816521378163,"l":66.218347862183478},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-60,1260],"tickmode":"array","ticktext":["0","250","500","750","1000","1250"],"tickvals":[0,250,500,750,1000,1250],"categoryorder":"array","categoryarray":["0","250","500","750","1000","1250"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.6529680365296811,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029056},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"y","title":{"text":"Expected","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-60,1260],"tickmode":"array","ticktext":["0","250","500","750","1000","1250"],"tickvals":[0,250,500,750,1000,1250],"categoryorder":"array","categoryarray":["0","250","500","750","1000","1250"],"nticks":null,"ticks":"","tickcolor":null,"ticklen":3.6529680365296811,"tickwidth":0,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":17.002905770029059},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"x","title":{"text":"Observed","font":{"color":"rgba(0,0,0,1)","family":"","size":21.253632212536321}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(51,51,51,1)","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":17.002905770029056}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"f1a82ffb5b5a":{"intercept":{},"slope":{},"type":"scatter"},"f1a85ff4a8b9":{"x":{},"y":{},"colour":{},"text":{}},"f1a8777b5fe1":{"x":{},"y":{},"label":{}}},"cur_data":"f1a82ffb5b5a","visdat":{"f1a82ffb5b5a":["function (y) ","x"],"f1a85ff4a8b9":["function (y) ","x"],"f1a8777b5fe1":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

<p class="caption">

<span id="fig:geography"></span>Figure 4: Actual vs. expected number of responses by state.
</p>

</div>

[^1]: Chelsea S Lutz, Mimi P Huynh, Monica Schroeder, Sophia Anyatonwu, F Scott Dahlgren, Gregory Danyluk, Danielle Fernandez, Sharon K Greene, Nodar Kipshidze, Leann Liu, et al. Applying infectious disease forecasting to public health: a path forward using influenza forecasting examples. BMC Public Health, 19(1):1–12, 2019.

[^2]: Simon Pollett, Michael A Johansson, Nicholas G Reich, David Brett-Major, Sara Y Del Valle, Srinivasan Venkatramanan, Rachel Lowe, Travis Porco, Irina Maljkovic Berry, Alina Deshpande, et al. Recommended reporting items for epidemic forecasting and prediction research: The epiforge 2020 guidelines. PLoS medicine, 18(10):e1003793, 2021.

[^3]: Matthew Biggerstaff, Rachel B Slayton, Michael A Johansson, and Jay C Butler. Improving pandemic response: Employing mathematical modeling to confront coronavirus disease 2019. Clinical Infectious Diseases, 2021.

[^4]: Estee Y Cramer, Evan L Ray, Velma K Lopez, Johannes Bracher, Andrea Brennen, Alvaro J Castro Rivadeneira, Aaron Gerding, Tilmann Gneiting, Katie H House, Yuxin Huang, et al. Evaluation of individual and ensemble probabilistic forecasts of covid-19 mortality in the us. Medrxiv, 2021.

[^5]: Sara Y Del Valle, Benjamin H McMahon, Jason Asher, Richard Hatchett, Joceline C Lega, Heidi E Brown, Mark E Leany, Yannis Pantazis, David J Roberts, Sean Moore, et al. Summary results of the 2014-2015 darpa chikungunya challenge. BMC infectious diseases, 18(1):1–14, 2018.

[^6]: Michelle V Evans, Tad A Dallas, Barbara A Han, Courtney C Murdock, and John M Drake. Data-driven identification of potential zika virus vectors. elife, 6:e22053, 2017.

[^7]: Nikos I Bosse, Sam Abbott, Johannes Bracher, Habakuk Hain, Billy J Quilty, Mark Jit, Edwin van Leeuwen, Anne Cori, Sebastian Funk, et al. Comparing human and model-based forecasts of covid-19 in germany and poland. medRxiv, 2021.

[^8]: David C Farrow, Logan C Brooks, Sangwon Hyun, Ryan J Tibshirani, Donald S Burke, and Roni Rosenfeld. A human judgment approach to epidemiological forecasting. PLoS computational biology, 13(3):e1005248, 2017.

[^9]: Thomas McAndrew and Nicholas G Reich. An expert judgment model to predict early stages of the covid-19 outbreak in the united states. Medrxiv, 2020.

[^10]: Gabriel Recchia, Alexandra LJ Freeman, and David Spiegelhalter. How well did experts and laypeople forecast the size of the covid-19 pandemic? PloS one, 16(5):e0250935, 2021.
