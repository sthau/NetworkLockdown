# Replication code for "Interacting Regional Policies for Containing a Disease"
With Arun G. Chandrasekhar, Paul Goldsmith-Pinkham, and Matthew O. Jackson. 



# Workflow:
## Individual Simulation:
1) Set up folder to run sims with:
- graph.mat
- parameters.mat (renamed version of a file from the parameters folder)
- kx_policy_new.m or jurisdiction_policy_new.m as desired
- a corresponding simulation file from the Simulations Folder
2) Run simulation file
- If you run an individual test, make sure to comment out the exit command on the last line

## Large Scale Replication:
1) Move the folder "Server Files" to a computing cluster that uses Slurm
2) In each sub-folder (Figure2, Figure3, Global), edit the .sh file with output in the name so that it runs on your cluster. Do NOT edit the last line of this  file. 
- Figure2: figure2_output.sh
- Figure3: figure3_output.sh
- Global: figure_global_output.sh
3) run either run_main.sh or run_alt.sh
- run_main.sh runs versions used in the body of the paper
- run_alt.sh runs versions used for robustness checks in the appendix
4) After all of the jobs have run, run the corresponding clean file
- this will generate a folder with all of your output to transfer off of the cluster
5) Once off of the server, copy in the corresponding processing file into your output folder and run it to combine the partitioned results into single .mat files
6) Move combined files to Figures folder and run the R script to generate the figures


## Parameters:
- the "Parameters" folder contains a number of .mat files with inputs for the sims
- because the simulations were run in parallel, there are many parameter files corresponding to different sections of the simulations

  - current titles of the files correspond to what parameters it contains

    - fig2 are for the (k,x) policy simulations
      - fig2 unknown are for the for (k,x) with an unknown seed simulations
      - fig3 are for the jurisdiction policy simulations
      - global are for global lockdowns
      - base are the main parameters listed in the body of the paper
      - low are with alpha=0.05, instead of 0.1
      - long are theta=8, tau=5, rather than theta=5, tau=3	
      - flu are R0=2
      - smallpox are R0=5
      - measles are R0=15
	- each file contains:
		- count = number of sims
		- partition = indicator of which section for the given parameter set
		- R0 = basic reproductive number
		- theta = duration of disease
		- tau = latency in detection
		- alpha = detection probability
		- x = shut down threshold
		- radius = shut down radius (referred to as k elsewhere in the paper)
		- seed_list = list of i0 nodes
		- threshold_list = list of sets of 4 jurisdictions (to be set 
		as lax when necessary)
		- T = max time threshold

## Pre-simulations
graph_gen.m
- Generates graph and gives graph statistics

graph.mat
- Contains the graph file and associated information
- G = adjacency matrix of the graph, sparse matrix data type
- K = number of nodes
- loc = number of jurisdictions
- num = vector of jurisdiction populations
- q_mat = matrix of connection probabilities
- types = matrix of indicators for which nodes belong to which jurisdiction
- start = indicies for first node in each jurisdiction
- stop = indicies for last node in each jurisdiction

generate_parameters.m
- generates parameter sets


## Simulations:
kx_policy_new.m
- Runs the (k,x) policies described in the paper and SI
  - Inputs:
    - K, T, alpha, theta, tau, x, G, R0, radius, seed, eps
    - seed is a node selected from seed_list
    - eps = fraction of nodes that do not quarantine, set in run files
  - Outputs:
    - infection_mat = KxT matrix indicating when nodes are infected
    - detection_mat = KxT matrix indicating when nodes are detected
    - recovered_mat = KxT matrix indicating when nodes are recovered
    - q_idx = KxT matrix indicating when nodes are quarantined
    - fail_idx = 1 if failure, 0 if initial quarantine succeeds
    - q_ball_close = list of nodes that are quarantined in initial quarantine
    - q_ball_check = list of nodes that are checked when determining initial quarantine
    - enforce = indicator vector of if nodes comply with lockdowns

kx_policy_v3.m
- Runs the (k,x) policies described in the paper and SI
  - Inputs:
    - K, T, alpha, theta, tau, x, G, R0, radius, seed, eps
    - seed is a node selected from seed_list
    - eps = fraction of nodes that do not quarantine, set in run files
  - Outputs:
    - infection_mat = KxT matrix indicating when nodes are infected
    - detection_mat = KxT matrix indicating when nodes are detected
    - recovered_mat = KxT matrix indicating when nodes are recovered
    - q_idx = KxT matrix indicating when nodes are quarantined
    - fail_idx = 1 if failure, 0 if initial quarantine succeeds
    - dist_list = list of average distance between detected nodes (returns -1 if there are no detections)

jurisdiction_policy_new.m
  - Inputs
    - K, T, loc, types, q_mat, quarantine_type, alpha, theta, tau, x, G, R0, seed, adapt_idx
    - seed is a node selected from seed_list
    - quarantine_type = quarantine strategy used, set in run files
      - 1 = myopic, internal jurisdiction
      - 2 = global, both detections and shut down
      - 3 = proactive jurisdictions
    - with quarantine_type=1 or 3, x must be set as a vector with each entry being a particular location's threshold, else must be a single value
		- adapt_idx = vector that indicates if locations use adaptive policy, 1 is proactive, 0 is myopic, only used if quarantine_type=3
  - Outputs:
    - infection_mat = KxT matrix indicating when nodes are infected
    - detection_mat = KxT matrix indicating when nodes are detected
    - recovered_mat = KxT matrix indicating when nodes are recovered
    - q_idx = KxT matrix indicating when nodes are quarantined
    - real_infection_archive = loc x T matrix with number of infections in each jurisdiction at time t

figure_1.m
  - runs (k,x) policy with no latency (takes in theta from parameter set, and then sets tau=0)
  - input: parameters.mat and graph.mat
  - output: figure2A_output.mat

figure_2.m
  - runs (k,x) policy with with latency
  - input: parameters.mat and graph.mat
  - output: figure2B_output.mat

figure_3.m
  - runs (k,x) policy with with latency and enforcement failure
  - eps is set in this file
  - input: parameters.mat and graph.mat
  - output: figure2D_output

figure_4.m
  - runs jurisdiction based policy with all myopic internal thresholds
	- sets x to be a vector with the value of x from parameters.mat
	- sets adapt_idx to all ones in the file
	- inputs: parameters.mat and graph.mat
	- ouput: figure3A_output.mat

figure_5.m
  - runs jurisdiction based policy with all proactive thresholds
	- sets x to be a vector with the value of x from parameters.mat
	- sets adapt_idx to all ones in the file
	- inputs: parameters.mat and graph.mat
	- ouput: figure3B_output.mat

figure_6.m 
  - runs jurisdiction based policy with all myopic internal thresholds, 4 with x=5
	- sets x to be a vector with the value of x from parameters.mat
	- sets adapt_idx to all ones in the file
	- inputs: parameters.mat and graph.mat
	- ouput: figure3C_output.mat

figure_7.m
  - runs jurisdiction based policy with 36 proactive thresholds, 4 with x=5 and myopic
	- sets x to be a vector with the value of x from parameters.mat
	- sets adapt_idx to all ones for proactive, 0 for myopic in file
	- inputs: parameters.mat and graph.mat
	- ouput: figure3D_output.mat

figure_global.m
  - runs global policy - global shutdown based on globally detected cases
	- x is set as a single value
	- inputs: parameters.mat and graph.mat
	- output: global_output.mat

## Processing:
figure2_processing.m
  - combines 2 partitions of figure 2 and exports them as .mat files
	- inputs: 
		- figure2A_outputa.mat
		- figure2B_outputa.mat
		- figure2D_outputa.mat
		- figure2A_outputb.mat
		- figure2B_outputb.mat
		- figure2D_outputb.mat
  - outputs:
		- figure2A_output.mat
		- figure2B_output.mat
		- figure2D_output.mat

figure3_processing_5.m
  - combines 5 partitions of figure 3 files and exports them as .mat files
	- inputs:
		- figure3A_output*.mat
		- figure3B_output*.mat
		- figure3C_output*.mat
		- figure3D_output*.mat
		- uses inputs from alternate figure 3 simulations
	- outputs:
		- figure3A_output.mat
		- figure3B_output.mat
		- figure3C_output.mat
		- figure3D_output.mat


figure3_processing_10.m
  - combines 10 partitions of figure 3 files (from main results) and exports them as .mat files
	- inputs:
		- figure3A_output*.mat
		- figure3B_output*.mat
		- figure3C_output*.mat
		- figure3D_output*.mat
		- uses inputs from base figure 3 simulations
	- outputs:
		- figure3A_output.mat
		- figure3B_output.mat
		- figure3C_output.mat
		- figure3D_output.mat

global_processing.m
  - combines 2 partitions of global_output and exports them as a .mat file
	- inputs: 
		- global_outputa.mat
		- global_outputb.mat
	- outputs:
		- global_output.mat

## Output Descriptions:
- For figure 2, the following are contained in output files
  - note that output D now refers to figure 2C in the paper
  - Output Files:
		- infection_mat_* = time series of infections by period and sim, recorded after step 2 of the progression
		- detection_mat_* = time series of detections by period and sim, recorded after step 1 of the progression
			- a node infected in time t with tau=0 that becomes detected would be marked detected in t+1
    - recovered_mat_* =  time series of recoveries by period and sim, recorded after step 2 
		- q_idx_* = time series of number of nodes quarantined by period and sims, recorded before step 2
			- if a node starts quarantine during step 4 of time t, they will first be recorded as quarantined at t+1
    - fail_rate_* = fraction of the time an infection made it farther than the initial quarantine radius
		- ipp_* = infected person periods
		- qpp_* = quarantined person periods
- For figure 3, the following are contained in output files
	- Output Files:
		- infection_mat_* = time series of infections by period and sim, recorded after step 2 of the progression
    - detection_mat_* = time series of detections by period and sim, recorded after step 1 of the progression
			- a node infected in time t with tau=0 that becomes detected would be marked detected in t+1
		- recovered_mat_* =  time series of recoveries by period and sim, recorded after step 2 
    - q_idx_* = time series of jurisdictions quarantined by period and sims, recorded before step 2
			- if a jurisdiction starts quarantine during step 4 of time t, they will first be recorded as quarantined at t+1
		- fail_rate_* = fraction of the time an infection made it farther than the initial quarantine radius
    - ipp_* = infected person periods in each sim
		- qpp_* = quarantined person periods in each sim
		- req_* = number of regions that quarantine multiple times, per sim
    - high_* = fraction of infections that occur in lax jurisdictions, per sim
			- only appears in output for C and D
- For global_output, the following are contained in output files
	- Output Files:
		- infection_mat_5 = time series of infections by period and sim, recorded after step 2 of the progression
		- detection_mat_5 = time series of detections by period and sim, recorded after step 1 of the progression
			- a node infected in time t with tau=0 that becomes detected would be marked detected in t+1
		- recovered_mat_5 =  time series of recoveries by period and sim, recorded after step 2 
		- q_idx_5 = time series of number of jurisdictions quarantined by period and sims, recorded before step 2
      - if a jurisdiction starts quarantine during step 4 of time t, they will first be recorded as quarantined at t+1
		- ipp_5 = infected person periods
		- qpp_5 = quarantined person periods
			









