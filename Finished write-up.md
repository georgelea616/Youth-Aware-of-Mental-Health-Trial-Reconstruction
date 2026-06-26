## **Effectiveness of the Youth Aware Mental Health programme in English secondary schools** 

## **A methods reconstruction** 

## **Summary:** 

This brief presents the methods, results and conclusions of a simulated reconstruction of a DfE study documenting a mental health intervention in English secondary schools. The original study presented the results of the Youth Aware Mental Health (YAM) programme, an already established mental health intervention developed and trialled elsewhere in the world **(3).** YAM was trialled across three waves between 2018 and 2024 as part of the Education for Wellbeing research programme. The trial documented the impact of YAM on young people’s self-reported emotional difficulties and intentions to seek help if experiencing future mental health problems **(3)** . The trial was conducted across 103 schools and 8169 pupils **(TR – cite).** 

There are a few key differences between the simulation and the original study. The most significant of these is the data: as the original data used in the study included sensitive personal information it is unavailable to the public. Demographic data for schools and pupils is also not available publicly for the same reasons. As the simulation is primarily a learning exercise, it simulates the characteristics of individual pupils and schools by using publicly available national aggregates. The scope of the simulation is also narrower and changed in some places: it analyses less variables than the original study and the variables it does analyse are slightly different. This is partially to keep the project manageable and partially because the original variable might not be publicly available (for example, the results of the original mental health survey the project used had to be replaced with publicly available figures, whose measurements and outcomes were different). Lastly, although the methods of the original study are replicated as closely as possible, the original report did not detail the entire construction of these methods, so a best guess has been implemented. Furthermore, the original study took place in MPlus while the simulation was conducted in R, which may have led to slight differences as the MPlus statistical functions could have been calculated differently. All these changes are marked in the report where appropriate. 

This simulation was primarily intended as a learning exercise to familiarise the author with the basics of handling large data and statistical analysis. Because the underlying data was inaccessible, the simulation cannot stress-test or validate the original results and methodology. It also does not validate whether the numbers in the report, sparse though they are, fully add up to the original results. This was to give the author experience in handling real DfE data. Because all of the data are simulated from national aggregates, the results of the simulation have no value in themselves. 

This simulation may still have value by ensuring transparency in the original methods and evaluating bias in the trial design. The original report did not entirely explain its analytical choices; by making these choices transparent and implementing a best guess where they are not the simulation helps 

the methods of the original study be critiqued and improved by others. The simulation also offers some recommendations on how the original study might have been improved, which are as follows: 

- The original study could have accounted for LGBTQ+ students, or uncertainty surrounding gender or sexual identity as a confounding factor for mental health. The political issues that might arise collecting these data in schools and the difficulties of measuring it accurately in young people make it easy to avoid. However, not balancing for it or controlling for it means the results of the overall study could be confounded. Including this would also help the visibility of these students to policymakers. 

- The original study could have published and discussed the composition and representativeness of the original sample. Although the assignment of schools to treatment and control groups was very careful, the process of drawing the original sample appears to have been random, restricted by the reach of DfE advertising and the ability of the schools to do the trial. This likely affected the school-level characteristics of the overall trial, and may have led to underrepresentation of certain categories of schools that could not complete the trial (likely schools with high levels of deprivation). To control the characteristics of the sample directly risks the introduction of bias and may not be feasible given trial funding. However, publication of the characteristics of the sample would give a useful idea of how representative the study is of the whole of England. 

- The original study could have also ensured consistency across the measures used in balancing and controlling the study, and provided evidence for how the measures are split. For example, when balancing the treatment and control arms of the study, the authors split region into North, South, and Midlands. However, when they controlled for the region of the school in the result, they split it into North East, North West, South East and South West. The problem comes because it is unclear which distinction has (or should have) the greatest impact on the outcome of interest, leaving one part of the analysis improperly balanced or factored out. 

- The original study could have provided some indication as to why the results for compliers of YAM are not considered to be robust. Those estimated to receive all sessions of YAM had a 33%point reduction in their experience of emotional difficulties, significantly higher than the average effect of receiving the treatment. However, the study does not recommend the programme due to the risk of it actually increasing emotional difficulties in certain school environments. It is unclear why they do not recommend a targeted implementation of YAM, given its record elsewhere in the world. 

- The original study could also have benefitted from situating the findings with the results of the programme elsewhere in the world as this would give a better indication of the problems with the trial in England. For example, the study could have evaluated if the estimated rate of compliance with the trial in England ( **51%)** was a typical or unusually low to diagnose if that was where the problem lay. 

- 

## **YAM in detail:** 

Youth Aware Mental Health (YAM) was originally trialled in England alongside other interventions also found to be effective in improving mental health outcomes in young people in other countries **(6)** . The trial was conducted in three waves between 2018 and 2024 (wave 1 beginning in 2018, wave 2 in 2019, and wave 3 in 2022). Baseline data for each wave were collected September to October, and after randomisation YAM was delivered between January and April. Follow up data were collected at a first follow-up point (3-6 months after the start of intervention delivery) and a second follow-up point (9-12 months post intervention) **(6).** 

As part of the trial, schools were allocated to one of the following groups: 

**Treatment, or YAM:** YAM is a set of five lessons delivered by a professional from outside the school. It uses role play designed to improve pupil understanding of mental health and reduce suicide rates. It also encourages pupils to share their own ideas about how to help each other maintain good mental health. It was originally developed in Sweden and America **(6).** 

**Usual practice:** Schools allocated to this group were asked to continue their current mental health practice and not to add anything new that resembled the intervention programmes. Existing practice was measured. These schools received free mental health training at the end of the trial **(6).** 

The YAM trial sought to answer the following questions: 

- Does participating in YAM improve emotional difficulties in young people, compared to a usual practice group that did not take part in YAM? (primary outcome) 

- To what extent does the impact of the intervention vary due to how it was implemented? 

- Does the impact of YAM or The Guide vary according to any pupil or school level factors? **(6)** 

This simulation split schools into treatment and usual practice groups and answered these questions for a simulated dataset. The following questions were also answered by the original study, but were excluded by the simulation to keep the project manageable: 

- Does participating in YAM or The Guide impact on any secondary outcomes? 

- Is YAM cost-effective? 

## **The Sample:** 

The original study drew pupils from year 9 across 103 schools, and 8169 pupils **(Technical Report – search allocation)** . It was conducted across three waves (2018, 2019, 2022) with the postintervention for the second wave interrupted by Covid-19. The primary findings of the study relate to waves 1 and 3 **(8).** 

The original sample contains personal data and is therefore inaccessible to the general public. The Department for Education generally presents data for schools and pupils in the aggregate and does not publish certain data, with pupil-level data often being more limited. The sample was therefore simulated differently between school-level data, which used an official DfE release **(cite)** , and pupillevel data, which used national aggregates where available, and made reasonable estimates where it was not. All the data the simulation drew from were aggregates, and each vector (e.g. region, free school meal status) was randomised independently of the others. Although the randomised dataset reflects no individual school it therefor resembles national averages. 

The simulation made changes to the parameters of the original study to keep the project manageable: 

- Instead of taking data from the two relevant years of the study (2018, 2022), the simulation analyses data from 2024-2025 only. This means also that any difference between the two completed waves of the study (wave one and wave three), is not simulated. This is because niche data (e.g. estimated provision of mental health in schools) is more easily accessible for 2024-2025. The difference between the waves was also marginal in the original study **(cite, I bet in TR).** 

- There is also no meaningful differences simulated between year 9 pupils and the rest of the pupil population and they are assumed to reflect national pupil demographics. 

The process of allocating recruited schools to the treatment and usual groups was carefully controlled in the original trial (see section: Randomisation). However, which schools were recruited depended on advertisement of the programme by DfE and the ability of the schools to actually carry out the trial **(TR 19).** 

This process was modelled as random in the simulation. The demographic data for all English secondary schools and pupils was generated and a sample of 103 schools and their pupils taken at random. Since the exact pupil numbers for each school had to be simulated care was taken that the number of pupils that could be sampled from any one school was not greater than the pupils available. 

## **Randomisation:** 

The simulation replicated the randomisation method of the original trial as closely as possible. In the original trial, schools were allocated on a 1:1 ratio between the usual practice and treatment (YAM) group **(8)** . It used a hybrid minimisation algorithm to ensure balance across the factors identified as possibly having an impact on the outcome (there were current levels of mental health provision, deprivation, region, and whether the school was urban or rural) **(TR 22).** The minimisation process was used to ensure balance across key factors that could influence the outcome of the trial. The steps in the process were as follows: 

_1. First Allocation_ 

One school was randomly selected from the sample and assigned to either treatment or usually practice using baseline probabilities (usual practice p=0.5, YAM p=0.5). This random seeding was a necessary starting point for the minimisation process **(TR 22).** This was true for the simulation. 

_2. Minimisation Algorithm_ 

After the first school was allocated, the remaining schools were entered sequentially in a random order into a minimisation algorithm. The algorithm calculates the level of imbalance across the four factors that would result from assigned the school to either the treatment or usual practice group. The algorithm forces allocation to the group that would minimise the imbalance across trial arms. **(TR 22).** For 90% of the data, this method was followed to ensure the factors remained balanced **(TR 23).** However, in 10% of cases schools were allocated using a ‘simple randomisation’. 

The simulation assumes each of the four factors was treated as having equal weight when calculating the imbalance. It also assumes that when schools were assigned using simple randomisation they were assigned using the baseline probabilities (p=0.5). A condition was added that in the rare case where the imbalances were perfectly equal, the school would be assigned using simple randomisation. 

_3. Results_ 

In the original trial, through this method, 52 schools and 4141 pupils were allocated to the usual practice group and 51 schools and 4028 pupils allocated to the treatment group **(TR 20).** 

The simulation replicated these results exactly. Although it allocated most of the data in the same way as the trial, it forced allocation to the other group when either the treatment or control group was full, and then sampled the correct number of pupils for each group after allocation. The schools of the original study had the pupils allocated and their baseline data collected before the schools were randomised **(TR 23).** This was done so that the results of the simulation and the original study can be more easily compared to identify any anomalies. This means the internal balance of the allocation may be forced by a school or two in the wrong direction but it is unlikely the effect will be large. By simulating the baseline data and pupil allocation after randomisation the simulation does not follow the steps of the trial also. 

## _4. Maintaining Balance and Bias._ 

The hybrid approach ensured that allocation was balanced and randomised. Minimisation ensured that the key factors were distributed evenly across each group, reducing the risk of overloading trial arms with factors that might distort the outcome. **(TR 23).** The 10% randomisation factor introduced a level of unpredictability, and reduces the risk of overfitting the allocation to the key factors, which would skew the allocation of the factors that aren’t minimised, or unknown confounders, even further. The randomisation in the original trial also helped protect the integrity of the allocation process from biased assignments. 

The simulation was undertaken by one person, responsible for both the allocation process and the validation of the results. Appropriate blinding to the allocation process therefore could not take place. 

## **Measures:** 

The simulation narrowed the scope of the original study to keep the project manageable. The original study measured the outcomes at three timepoints: baseline (prior to randomisation), 3-6 months from the start of intervention delivery (first follow up) and 9-12 months from the end of delivery (second follow up) **(8).** The second follow-up was not simulated. The original study also measured relevant secondary outcomes **(9),** largely through other mental health surveys, to validate the results. These were not simulated. 

## _Primary Outcome Measure:_ 

For YAM, the primary outcome measure was emotional difficulties (Short Mood and Feelings Questionnaire, SMFQ, Angold et al., 1995) at first follow-up **(8).** The SMFQ is a 13-item self report questionnaire assessing mental health in the last two weeks **(TR 44).** Respondents are given statements about their mental health and asked to assess them from 0, (“not true”) to 2 (“true”). Higher scores indicate greater depressive symptoms with a 12 or higher indicating symptoms of a depression **(TR 44).** 

The SMFQ baseline results are simulated through a normal distribution of results with a standard deviation of 5 and 20.3% of the results above the ‘depressive symptom’ threshold of 12. ‘Depressive symptoms’ are notoriously difficult to accurately measure; although clinical diagnoses of depression amongst young people are low (<3%) (Prevalence | Background informaton | Depression in children | CKS | NICE), reports of depressive symptoms in surveys are often much higher than 20.3% ( **Mental Health Statstcs UK | Young People | YoungMinds).** The figure of 20.3% is taken from the 2023 NHS 

survey of mental health in children and young people, and represents the proportion of 8- to 16year-olds with a probable mental disorder ( **Mental Health of Children and Young People in England, 2023 - wave 4 follow up to the 2017 survey - NHS England Digital** ). This figure covers other mental disorders (anxiety and behavioural disorders), but was chosen as a reasonable estimate. 

The SMFQ baseline results were simulated for the sample group after allocation had taken place, as mentioned above. The SMFQ follow-up results were simulated separately for the treatment group and for the control group, in order to distinguish a change between the two in the results. 

## _Implementation Measure:_ 

The original study also collected information on how much of a given intervention was delivered (dosage) via online teacher surveys. Intervention compliance was determined based on complete delivery (i.e., all sessions delivered) vs incomplete delivery (anything less than the required number of sessions). **(9).** The report claims for YAM, compliers were those who received all five sessions (78%), and non-compliers were those who received less than five sessions of YAM (22%) **(9) (11).** 

Compliance was simulated as a binary (complier/non-complier) across all YAM schools with these probabilities (complier p=0.78, non-complier p=22%) 

## _Effect modification:_ 

The original study used the following variables to understand if the impact of interventions varied according to any school or pupil-level factors from the original survey and demographic data collected **(9).** The simulation used a mix of DfE data and other sources to simulate each individual school’s characteristics from national aggregates. 

## _School-level characteristics._ 

The simulation drew many of the school-level characteristics from a recent DfE dataset, filtered by secondary schools and the year 2024-25. These variables were simulated according to their probabilities across the entire set of secondary schools before the sample was taken. Because deprivation, region, and the urban or rural status of the school are drawn from this dataset, and are the correct aggregates for secondary schools and the year 2024-2025, they are the most accurate data used. 

- _School-level deprivation:_ the original study measured this through the percentage of pupils eligible for free school meals at each school. It then factored these values into the lower, medium and higher tiers of deprivation. The simulation calculates the percentage of children in the relevant schools eligible for free school meals, simulates this on an individual level for each pupil, and then assigns each school to the lower, medium, or higher tier of deprivation. Each tier is equally weighted so as to receive 33% of the data. 

- _Region:_ the original study divided the regions of the schools into the North, the Midlands, and the South. The DfE data covered 10 original areas of England (e.g. Yorkshire, London) which the simulation sorted into these categories. 

- _Urban-Rural:_ the original study divided each school setting into Urban schools and Rural schools. The DfE data had several variables to describe this setting (e.g. urban hamlet), which the simulation sorted into Urban or Rural. 

- _Previous implementation of universal mental health programmes before involvement in the trial:_ the original study divided this into schools with prior support and schools with no prior support, while also measuring the level of mental health training staff had via a survey **(9)** . It uses prior support more consistently in the analysis. Publicly available proxies for prior mental 

health provision in schools (in particular, measuring which schools have received interventions before but do not receive them currently) are difficult to find. The simulation uses current levels of mental health support as a proxy, and estimates 52% of the schools have support while 48% do not. This reflects the coverage of the government’s Mental Health Support Teams across all English schools as of spring 2025, although the real number is likely higher due to other available programmes. 

## _Pupil-level characteristics_ 

The simulation drew many of the pupil-level characteristics from national statistics, which can include primary and secondary schools in their output as the figures are often not disaggregated. These figures also may not be recently updated. They are therefore less accurate than the simulated school-level characteristics. These variables were simulated according to their probabilities across the entire dataset of pupils before the sample was taken. 

- _Gender:_ the original study only distinguished between male and female pupils **(9)** . The simulation estimates 50% of pupils are male and 50% are female (p=0.5). 

- _Ethnicity:_ the original study placed pupils’ ethnicity into either broad white or minority ethnic groups **(9)** . The simulation estimates 60.3% of pupils are broad white ethnic groups (p=0.603), and 39.7% of pupils are from minority ethnic groups (p=0.397). This figure is an average across all state-funded schools (primary and secondary) for 2024-2025 (Release home - Schools, pupils and their characteristcs - Explore educaton statstcs - GOV.UK). 

- _SEN Status:_ the original study split pupils between SEN and no SEN. The simulation estimates 19.6% of pupils as having SEN status (p=0.196) and the remaining 80.4% as not having SEN status (p=0.804). This figure is an average across all English schools for 2024-2025 (Special Educatonal Needs: support in England - House of Commons Library). 

- _Free School Meal Status (yes/no):_ the simulation estimated the free school meal status of the pupil body from the total number of state secondary school pupils eligible for free school meals in the DfE dataset. 

- _Previous Poor Mental Health:_ the original study classified those with poor mental health as those who had answered the SMFQ at baseline with a score of 12 or higher (above cutoff) and the rest as below cutoff **(10).** For how the baseline data for SMFQ were simulated see the _Primary Outcome Measure_ heading in this section. 

The original study would have benefitted from introducing a sensitive measure for LGBTQ+ pupils to make them more visible to policymakers. These pupils could be also be a confounding factor in the results of the study as their mental health is likely poorer than the rest of the population. It is likely this was not included in the original survey to avoid political controversy during the making and disseminating of the report. The age of the children (13-14) also complicates the results as sexual and gender identity is likely to be unclear, which could leave the results open to misinterpretation. However, this does not change the fact gender and sexual identity are often sources of stress and uncertainty and should be visible in education policy. 

## **Analysis** 

## _Primary outcome analysis_ 

The simulation replicated the analysis methods of the original study as closely as possible. The original study measured the primary outcome (the SMFQ questionnaire after treatment) with an intent-to-treat approach, where outcomes were analysed for all participants of the trial, regardless of whether the individuals received the intervention **(10).** It used a technique called mixed linear 

models which compares the scores of those groups taking YAM to the usual practice group, and takes into consideration the impact of: 

- _Emotional difficulties at the start of the project:_ this was likely measured using the baseline scores of the SMFQ **(10).** 

- _Where in the country the school was located:_ the original study evaluates schools differently here than it does in the original region variable, splitting them into the North East, North West, South East and South West **(10).** The simulation used the original split of the schools region into the North, the Midlands, and the South for consistency and simplicity. 

- _Current mental health provision at the school:_ the original study determined baseline mental health provision over the current mental health provision survey for the staff **(TR - 140),** the results of which are inaccessible. The simulation estimated current mental health provision in the same way that it did previous mental health provision (see section: Measures). 

- _School-level deprivation:_ it is unclear whether the original study used each schools raw percentage of students with free school meal eligibility, or the tiers it had factored these into for the sake of balancing the data (lower, middle and higher tiers of deprivation) **(10)** . The simulation uses the individual percentages of students eligible for free school meals here, as there is no mathematical reason not to. 

- _Urban/Rural situation of the school_ (urban/rural): 

## _Moderator analysis_ 

The original study is vague when describing the moderator analysis. To understand whether the effects vary according to pupil or school level factors, it fits the same mixed linear model ‘adding in consideration of a range of different potential moderators of impact’. It considers each one separately **(10).** The simulation runs a separate model for each moderato. This model still uses the SMFQ follow-up as the outcome but tests whether the treatment effect varies by the moderator in question instead of testing the overall treatment effect as above. The moderators in both are as follows: 

- _Gender_ (male/female); 

- _Free school meal status of the pupil_ (yes/no); 

- _Ethnicity_ (broad white/minority ethnic groups); 

- _Previous Poor Mental Health_ (above/below SMFQ cutoff); 

- _SEN status_ (SEN/no SEN); 

School-level factors: 

- _School-level deprivation;_ the simulation estimates this as above. 

- _Urban/Rural situation of the school_ (urban/rural); 

- _Previous mental health interventions:_ the simulation estimates the extent of previous mental health interventions using figures from current mental health interventions (see section: Measures). 

The authors of the original study acknowledge that by splitting the analysis into subgroups the sample sizes are reduced and the findings are more exploratory in nature **(11).** 

## _Implementation Analysis:_ 

Both the original study and the simulation used a statistical method called Complier Average Causal Effect (CACE) estimation to test whether the dosage of the intervention impacted the primary outcome **(11).** CACE estimates which pupils in the usual practice schools would have been compliers 

to YAM (defined as receiving all five sessions of YAM in the original study), and which would have been non-compliers (defined as receiving no sessions of YAM in the original study. It does this by using information about the characteristics of compliers (predictors of compliance). The effect tells us the effect of the intervention in those who received all five sessions of it. 

In the original treatment group, 2,255 pupils were compliers and 636 non-compliers, with the rest receiving between one and four sessions of the intervention **(11).** These figures are less than the actual number of compliers and non-compliers, as anyone with missing information was removed from this estimate **(11).** 

It is likely that the CACE analysis in the original study did not return statistically significant predictors of compliance. Predictors of compliance indicate if someone is the usual practice group is likely to have complied with the intervention, and if these are not strong in a CACE model, then the results should be interpreted with caution **(12).** The trial and the original study used the following predictors of compliance **(12):** 

- _Gender_ 

- _Emotional difficulties at the start of the project_ 

- _Free school meal status of the pupil_ 

- _Previous mental health interventions_ 

It is likely that the CACE analyses used more for than these predictors for YAM pupils and it is not mentioned in the report. 

## **Findings** 

The purpose of reporting the findings of the simulation is to record that the mathematics of it are internally consistent. The data, although taken from national aggregates is inaccurate and the relationships between the raw data and the results of the study were not simulated. Some relationships were simulated to validate the findings below: 

## **Does participation in YAM improve emotional difficulties in young people?** 

The original study found there was no statistically significant effect on young people’s emotional difficulties from participating in YAM (effect size=0.02, 95%-confidence interval: -0.05, 0.10) **(12).** This represents the difference between the treatment and the usual practice groups at 3-6 months. 

The simulation, to validate the mathematics, randomised the mean of the treatment group (their mean SMFQ score) as **1** point lower than, or 1 point improved compared to the usual practice group. This was modelled as a change to their original scores rather than an entirely new distribution. The result was a similar effect size ( **effect size=XXX, 47%-confidence interval -0.05, 0.1).** 

The difference between the simulated score and the effect is the effect of taking into consideration the impact of other potential factors, which in the simulation, is random. The original study likely evaluated the impact of each individual moderator (the school’s urban-rural status, the relative deprivation), closely (see the below section) so that none of these results significantly changed the main result without good reason. 

## **To what extent does the impact of YAM vary according to how it was implemented?** 

In the original study, 51% of the 5408 were estimated to be compliers to YAM by the CACE model **(12).** This figure is significantly lower than the actual compliance data, where the compliers for YAM were estimated at **78% (11).** 

The original study also reports that compliance led to a significant decrease in emotional difficulties, and that the YAM trial, when fully received, led to a 33% percentile point reduction in emotional difficulties **(13).** Baseline emotional difficulties were found to be significant predictors of compliance, with lower levels of baseline emotional difficulties making compliance more likely. 

The estimated compliers of the simulation were necessarily going to be different: **XX** pupils were estimated as compliers by the simulation. The simulation randomised the change of SMFQ of the compliers as one point higher than the rest of the YAM group. The result was and effect of a the expected size between the compliers and non-compliers **(results)** . It did not simulate any significant predictors of compliance. 

## **Does the impact of YAM vary according to any pupil or school-level factors?** 

The original study confirmed an interaction between prior universal mental health provision in schools and YAM. Schools with less prior mental health provision showed higher levels of emotional difficulties at follow-up, suggesting the programme may have exacerbated awareness of or even caused emotional distress **(13).** 

The simulation, to validate the results of the moderator analysis, randomised the emotional difficulties at follow up of schools without prior mental health provision as one point above schools with prior mental health provision **(+0.5, -0.5),** modelled as a change to their original scores. The result was a similar effect size **(effect size XXX, XX% confidence interval, -0.04, 0.02)..** 

## **Conclusions** 

The original study concluded YAM did not, overall, have a positive effect and did not recommend it. It mentioned that it did have a positive effect on emotional difficulties but claims this result is not strong enough to recommend the programme. It also concluded YAM had a negative short-term interaction in schools with low mental health provision **(16).** It’s recommendations, that future interventions should be implemented fully and children should be monitored and supported throughout them, are tentative. 

The simulation is smaller in scope and limited by the choice of data and its status as a learning exercise. However, there are a number of recommendations which may be useful for future research. First, LGBTQ+ pupils could be accounted for more in mental health research as they are likely a confounding factor and could use more visibility with policymakers. The spread of defining characteristics (i.e. region, urban-rural location) in the samples of relatively small studies should be published to determine how representative they are (if GDPR allows). The measures used when balancing and controlling the study (i.e. the region split between North, the South, and the Midlands), should be split consistently across the study and in a way that is most consistent with previous evidence, unless the split of the data itself is being investigated. 

Lastly, the results of the original study should have been interpreted in the context of successful trials in other countries. It is entirely possible that the reason the study was ineffective lies in the implementation and the schools chosen rather than an inherent incompatibility between the trial and the rest of English schools. The simulation has not also evaluated the noted differences between 

the original implementation of YAM and the adjustments made for English schools. It is important to be critical and ensure the evidence base for any mental health policy is robust, however, it is just as important to leave no stone unturned in improving it. 

