# Shiny_Response_Rate_Dashboard

[View ETS2 Dashboard](https://jakemsnyder.shinyapps.io/ets2_response_rate_dashboard/)

### Purpose
This repo demonstrates how to create a response rate dashboard for Qualtrics. The base platform can provide distribution
summaries to view response counts, but not by demographic information and not response rates.

Using this dashboard, you can create a shareable dashboard so that stakeholders can view survey progress and whether
certain demographic groups are not taking the survey.


### Setup
You will need to set up a workflow to allow you to download Qualtrics responses using the Qualtrics API. This project uses the qualtRics package.

You also will need a csv of the recipient list used to send out the survey, stored in a folder that is **not** in the Shiny dashboard folder. This is done to avoid publishing sensitive information such as names and emails.

### What information is published?
Using the R script to collect and combine data, you will need response data, specifically what surveys have been
completed and who have completed them. However, during this script, after the data is merged the only fields that 
are saved are the demographic fields and a binary `Finished` field indicating whether the survey has been completed.

In the ETS2 example, the demographic information is `Agency` and `Vendor System`. Note that this information cannot be tied 
to any individual, as that information has been removed from the data altogether.
