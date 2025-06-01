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

Modeling the path of an infectious disease is a popular and important area of
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

<div class="figure">

<div class="reactable html-widget html-fill-item" id="htmlwidget-1" style="width:auto;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"tag":{"name":"Reactable","attribs":{"data":{"Preface":["What percent of people in your community do you notice are usually","","","How common is it in your community for","","","","","","In your community, how common is it for people to follow recommendations or requirements to","","","","","","How many people in your community are aware of","","","In your state, what percent of","",""],"Question":["Wearing a mask in public","Maintaining social distance","Staying at home","Restaurants complying with CDC recommendations to have reduced seating","Businesses to be closed – work from home only","Hairdresser and barber complying with CDC restrictions","Visitors to senior living facilities to be restricted","Commonly touched surfaces to be sanitized","Special protection in hospital areas that treat COVID patients","Get tested for active virus","Get antibody testing to detect prior infection","Quarantine people who have been in close contact with people with positive tests","Quarantine people with positive tests","Quarantine travelers from higher infection places","Limit large gatherings of people","Local level of COVID infections","Statewide targets for reducing COVID spread","Local approach to limiting COVID spread","Colleges are closed or holding only remote classes","Schools (K-12) are closed or holding only remote classes","Violations of COVID restrictions result in fines or police enforcement"]},"columns":[{"id":"Preface","name":"Preface","type":"character"},{"id":"Question","name":"Question","type":"character"}],"sortable":false,"searchable":true,"defaultPageSize":10,"showPageSizeOptions":false,"paginationType":"numbers","highlight":true,"theme":{"color":"inherit","backgroundColor":"transparent","borderColor":"inherit","stripedColor":"rgba(0, 0, 0, 0.02)","highlightColor":"rgba(0, 0, 0, 0.05)","style":{"fontSize":"0.95em"},"pageButtonStyle":{"background":"transparent","color":"inherit","border":"1px solid #ccc","borderRadius":"4px","padding":"4px 8px","margin":"0 2px"},"pageButtonHoverStyle":{"background":"#ddd"},"pageButtonActiveStyle":{"background":"#bbb","fontWeight":"bold"}},"dataKey":"0be8f0afe6c228d6dc808107298789f4"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}</script>

<p class="caption">

<span id="fig:unnamed-chunk-2"></span>Figure 2: The 21 survey questions posed to the crowd. Responses were on a Likert scale from 0% to 100% in increments of 20. Participants also had the option of selecting ‘Don’t know’.
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
