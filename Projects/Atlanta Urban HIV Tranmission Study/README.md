# Atlanta Urban HIV Transmision Study

Done in collaboration with [Aparna Seth](https://www.linkedin.com/in/aparna-seth-1b737212) and [Sarah Shaw](https://www.linkedin.com/in/sarahshaw5). We investigate the HIV tranmission in the Atlanta Urban metastudy from 1988-2001

[Final Poster](https://github.com/DarkArcZ/data-analysis/blob/d6437041080df23cacb65cf3ef2cb875cb7b0ba6/Projects/Atlanta%20Urban%20HIV%20Tranmission%20Study/CSSS%20567%20Final%20Poster_Seth_Shaw_Wong_12.8.21.pdf).

## Background
• The HIV/AIDS epidemic in the U.S. has evolved in recent years, with marked decreases in both incidence and mortality.

• Attention has turned from rapid epidemic spread to persistent endemic transmission, primarily in urban centers

• Data is part of a larger HIV transmission network metastudy from 1988-2001 which aimed to analyze how partnership network structure and risk taking behaviors impact transmission of HIV and other STIs

• Key hypothesis: individual behaviors do not suﬃciently explain the propagation of infection and network structure and dynamics can play a critical and explanatory role

• Speciﬁcally, the patterns of risks and interactions within a social network can be compared to other systems for their relationship to the transmission of HIV infection

## Methods
• We use data from a longitudinal study from 1996-99 conducted with 228 respondents in Atlanta, GA

• Three geographically separated community sites were selected and two persons at each site were identiﬁed as `seeds’ to start a connected chain of persons and their contacts until 10 persons and their contacts had been enrolled in the community chain (Respondent Driven Sampling)

• Primary respondents were interviewed along with a sample of their contacts every 6 months for 2 years to collect data on their HIV status; demographic, medical, and behavioral factors; and the composition of the social, sexual, and drug-use networks

• We examine the number of nodes, edges, and degree in the network. Further, we develop a Stochastic Block Model (SBM) without covariates to determine probabilities of a connection based on group membership

• We visualize the network based on mode of connection and sex

![network_graph](https://github.com/DarkArcZ/data-analysis/blob/e83f5bbffc157d73021a1918d4262ba63c0747d7/Projects/Atlanta%20Urban%20HIV%20Tranmission%20Study/network_graph.png)

## Results

#### Table 1: Demographic and Socioeconomic Characteristics of all Respondents from First Interview 
| Characteristics | Men (%) | Women (%) |
| --- | --- | --- |
| Age in years (mean) | 40.3 | 39.4 |
| Sex | 62 | 38 |
| High school dropout | 48 | 54|
| Homeless | 35 | 24 |
| Unemployed | 49 | 61 |
| Sex Worker | 2 | 15 |
| Drug Dealer | 1 | 2 |

• The network has 228 nodes with 678 connections and is represented by the graph to the right

• Average degree centrality is 5.95; few individuals as outliers with large connections

• Degree correlation is -0.28; the network shows weak disassortativity

![degree_distribution](https://github.com/DarkArcZ/data-analysis/blob/67c37cd60b296912758ff12ee5fd94017e3d90bd/Projects/Atlanta%20Urban%20HIV%20Tranmission%20Study/degree_distribution.png)

#### Table 2: Network Data Description Statistics
Descriptive Statistics | Values|
|---|---|
| Nodes | 228 |
| Edges | 678 |
|Degree - Mean (Range) | 5.95(1-38) |
| Assortativity | -0.28194 |
| Triangles - Mean (Range) | 80.16 (1-255) |

• Table 3 presents SBM-generated estimated probabilities of an edge between two nodes based on their group membership

• Intergroup connections are more common than intragroup connections; groups 5 and 6 are the least likely to have any connections across groups

• Likely that the probability of an edge is not independent of other connections

![table3](https://github.com/DarkArcZ/data-analysis/blob/67c37cd60b296912758ff12ee5fd94017e3d90bd/Projects/Atlanta%20Urban%20HIV%20Tranmission%20Study/table3.png)

## Limitations
• We expect that factors such as age, race, sex, and HIV status may impact group assignments and probability of an edge (supported by GOF analysis). However, we were unable to include covariates in the SBM as this required longitudinal analyses which were beyond the current scope

• Data quality concerns across varying timepoints

• The study only collected data on 228 participants, when in fact, the network generated through RDS had a total of 292 individuals

## References
• Morris, Martina, and Rothenberg, Richard. HIV Transmission Network Metastudy Project: An Archive of Data From Eight Network Studies, 1988--2001. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2011-08-09. https://doi.org/10.3886/ICPSR22140.v1

• Rothenberg RB, Long DM, Sterk CE, Pach A, Potterat JJ, Muth S, Baldwin JA, Trotter RT 3rd. The Atlanta Urban Networks Study: a blueprint for endemic transmission. AIDS. 2000 Sep 29;14(14):2191-200. doi: 10.1097/00002030-200009290-00016. PMID: 11061661.
