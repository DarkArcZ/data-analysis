##CSSS 567 HIV Transmission Data

#setup
library(sand)
library(igraph)
library(tidyverse)
library(blockmodels)
library("RColorBrewer")
library(foreign)
##link chain - 10 steps

##reading in the data 
ego_data <- read.dta("egodyad.dta")
ego_data <- as_tibble(ego_data)


###exploring the data 
##atlanta urban networks project is study number 3/Atlanta  Urban (studynum)
ego_data$studynum %>% unique

ego_data %>% group_by(studynum) %>% summarize(n())
##Atlanta Urban has 7501 observations (mulitple observations per person)

#filtering so we just have the ATL urban network data
ego_data_atl <- ego_data %>% filter(studynum=="Atlanta Urban")

#how many unique individuals in the dataset?
test <- ego_data_atl$rid %>% unique
length(test) #228

ego_data_atl$ntype1 %>% unique
ego_data_atl$ntype2 %>% unique

## generate list of unique rid which represent nodes for which data was collected (n=228)
unique_rid <- ego_data_atl$rid %>% unique

# filter data set by the combinations of id1 and id2 that are also in rid (did not
#collect data for every individual recruited)
ego_final <- ego_data_atl %>% filter(id1 %in% unique_rid & id2 %in% unique_rid)

## generate edge list without duplicates
edgelist <- unique(ego_final[,c("id1", "id2")]) #678 unique edges

id1total <- edgelist$id1 %>% unique 
length(id1total) #184
id2total <- edgelist$id2 %>% unique
length(id2total) #226 (some overlap with id1, others are unique)


## generate vertext list of all unique ids
id1_v <- ego_final$id1 %>% unique
id1_v <- as_tibble(id1_v) #228
colnames(id1_v) <- "id"

id2_v <- ego_final$id2 %>% unique
id2_v <- as_tibble(id2_v) 
colnames(id2_v) <- "id"

vertex_list <- merge(id1_v, id2_v, all.x=TRUE, all.y=TRUE) 
vertex_list <- as_tibble(vertex_list) #228 nodes as expected


##making the igraph object
g_hiv <- graph.data.frame(edgelist,directed="FALSE",vertices=vertex_list) 
g_hiv$name <- "Atlanta Urban Network"


##plotting the network - interested in looking at edges based on mode of 
#connection (eg. social, drug, sexual, needle) between edges
set.seed(13)
plot(g_hiv, edge.color=rainbow(9)[ego_final$tietype], 
     vertex.size=4, vertex.label.cex=0.25, 
     vertex.color=terrain.colors(5)[ego_final$sex],
     vertex.label.color="black")
legend("topleft",bty = "n",
       legend=unique(ego_final$tietype),
       fill=rainbow(9)[unique(ego_final$tietype)])
legend("topright",bty = "n",
       legend=unique(ego_final$sex),
       fill=terrain.colors(5)[unique(ego_final$sex)])


## Descriptive Stats of the Graph

vcount(g_hiv) #228 vertices
ecount(g_hiv) #678 edges
get.edgelist(g_hiv) 
get.adjacency(g_hiv)
g_hiv.degrees <- degree(g_hiv)
mean(g_hiv.degrees)  # degree centrality 5.947368
range(g_hiv.degrees) # range = (1 - 38)
assortativity.degree(g_hiv) # degree correlation -0.2819366
g_hiv.triangles <- triangles(g_hiv) 
mean(g_hiv.triangles) #80.15818
range(g_hiv.triangles) #1 - 255

## Degree Distribution Visualizations

d.ego_data_atl <- degree(g_hiv)
dd.ego_data_atl <- degree.distribution(g_hiv)
d <- 1:max(d.ego_data_atl)-1
ind <- (dd.ego_data_atl != 0)
plot(d[ind], dd.ego_data_atl[ind], col="dodgerblue", 
     xlab=c("Degree (# of connections to other nodes)"), 
     ylab=c("Intensity"), main="Figure 1: Degree Distribution of Nodes in Network Data")

## Histograms

hist(d.ego_data_atl, col = "lightblue", 
     xlab = "Vertex Degree", ylab = "Frequency", 
     main = "Figure 2: Degree Distribution of Nodes in Network Data")

## Log-Degree Distribution

log_dist <- (dd.ego_data_atl !=0)
plot(d[log_dist], dd.ego_data_atl[log_dist], log = "xy", col = "darkorchid4", 
     xlab = c("Log-Degree"), ylab = c("Log Intensity"), 
     main = "Figure 3: Log-Log Degree Distribution")

#a.nn.deg.atl <- graph.knn(g_hiv_simple, V(g_hiv_simple))$knn
#plot(g_hiv_simple, a.nn.deg.atl, log = "xy", col = "goldenrod", xlab = c("Log Vertex Degree"), ylab = c("Log Average Neighbor Degree"))

###Subgraphs 
##A census of cliques of all sizes can provide some sense of a snapshot of how structured a graph is.

table(sapply(cliques(g_hiv), length))

##Understanding distribution of mode of connection & sex
table(ego_final$tietype) #majority are drug and social relationships
table(ego_final$sex) #majority male (this dataset includes multiple observations
#of same people)

### Build SBM - expect that the probability of an edge is related to group membership
library(sbm)
library(knitr)

#set all weights = 1 as we are more interested in whether there is a connection 
#or not at this time
E(g_hiv)$weight = 1

model1 <- BM_bernoulli("SBM", as_adj(g_hiv, sparse=FALSE), 
                       verbosity=3, plotting="")
model1$estimate()

##memberships for best-fit model + largest probability in each row (no covariates)
best_fit_prob <- model1$memberships[[which.max(model1$ICL)]]$Z
clust_assign <- apply(best_fit_prob, 1, which.max)
clust_assign %>% unique %>% sort #10 groups
clust_tb <- table(clust_assign) #nodes per group 
kable(clust_tb)

#probabilities
p_hat <- model1$model_parameters[[which.max(model1$ICL)]]$pi

colnames(p_hat) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5",
                     "Group 6", "Group 7", "Group 8", "Group 9", "Group 10")
rownames(p_hat) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5",
                     "Group 6", "Group 7", "Group 8", "Group 9", "Group 10")
kable(p_hat, caption="Model 1 (no covariates): Probability of an edge between 
      two nodes given their group membership")

## Take a look at group memberships as the network figure
set.seed(13)

plot(g_hiv, vertex.size=4, vertex.label.cex=0.25, 
     vertex.color=rainbow(9)[unique(clust_assign)],
     vertex.label.color="black")
legend("topright",bty = "n",
       legend=unique(clust_assign),
       fill=rainbow(9)[unique(clust_assign)],
       title="Group Membership")


## ERGMS & Model Fit
library(statnet)
library(intergraph)

g_hiva <- asNetwork(g_hiv)
m1 <- ergm(g_hiva ~ edges)
summary(m1)

gof_m1 <- gof(m1)
gof_m1
plot(gof_m1) #data doesn't quite fall within or close to the range of simulated
#data
