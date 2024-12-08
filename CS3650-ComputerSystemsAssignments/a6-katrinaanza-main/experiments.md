# Threaded Merge Sort Experiments


## Host 1: [Codespaces Terminal]

- CPU: AMD EPYC 7763 (virtualized with 2 vCPUs allocated)
- Cores: 1 physical core (2 virtual CPUs through hyperthreading)
- Cache size (if known): L1d 32KiB
                         L1i 32KiB
                         L2 512KiB
                         L3 32MiB
- RAM: 7.7GiB
- Storage (if known): 32G
- OS: Ubuntu 22.04.1 LTS

### Input data

*Briefly describe how large your data set is and how you created it. Also include how long `msort` took to sort it.*

Our data set is 100,000,000 randomly generated integers created from the command 'shuf -i1-100000000 > hundred-million.txt'. 'msort' took 19.450208 to sort this data set.

### Experiments

*Replace X, Y, Z with the number of threads used in each experiment set.*

#### 1 Threads

Command used to run experiment: `MSORT_THREADS=1 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run
1. Running with 1 thread(s). Reading input.
   Array read in 7.486941 seconds, beginning sort.
   Sorting completed in 15.409776 seconds.
   Array printed in 5.743886 seconds.

Second run
2. Running with 1 thread(s). Reading input.
   Array read in 7.279023 seconds, beginning sort.
   Sorting completed in 15.236283 seconds.
   Array printed in 6.948913 seconds.

Third run
3. Running with 1 thread(s). Reading input.
   Array read in 7.048419 seconds, beginning sort.
   Sorting completed in 15.333375 seconds.
   Array printed in 5.714965 seconds.

Fourth
4. Running with 1 thread(s). Reading input.
   Array read in 7.085714 seconds, beginning sort.
   Sorting completed in 15.252562 seconds.
   Array printed in 5.588837 seconds.

#### 2 Threads

Command used to run experiment: `MSORT_THREADS=2 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 2 thread(s). Reading input.
   Array read in 7.193768 seconds, beginning sort.
   Sorting completed in 15.379231 seconds.
   Array printed in 5.687424 seconds.

Second run:
2. Running with 2 thread(s). Reading input.
   Array read in 7.127048 seconds, beginning sort.
   Sorting completed in 15.481062 seconds.
   Array printed in 5.622597 seconds.

Third run:
3. Running with 2 thread(s). Reading input.
   Array read in 7.203523 seconds, beginning sort.
   Sorting completed in 15.343871 seconds.
   Array printed in 5.854750 seconds.

Fourth run:
4. Running with 2 thread(s). Reading input.
   Array read in 7.256455 seconds, beginning sort.
   Sorting completed in 15.263790 seconds.
   Array printed in 5.805805 seconds.

#### 4 Threads

Command used to run experiment: `MSORT_THREADS=4 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 4 thread(s). Reading input.
   Array read in 7.229602 seconds, beginning sort.
   Sorting completed in 15.322049 seconds.
   Array printed in 5.929993 seconds.

Second run:
2. Running with 4 thread(s). Reading input.
   Array read in 7.219299 seconds, beginning sort.
   Sorting completed in 15.313063 seconds.
   Array printed in 5.874028 seconds.

Third run:
3. Running with 4 thread(s). Reading input.
   Array read in 7.048291 seconds, beginning sort.
   Sorting completed in 15.263530 seconds.
   Array printed in 5.945147 seconds.

Fourth run:
4. Running with 4 thread(s). Reading input.
   Array read in 7.229789 seconds, beginning sort.
   Sorting completed in 15.153101 seconds.
   Array printed in 5.599891 seconds.

*repeat sections as needed*

## Host 2: [Anzas-MacBook-Pro.local]

- CPU: Apple M2 Pro 
- Cores: 12-core
- Cache size (if known): L1 Instruction Cache: 128 KB (131,072 bytes)
                       : L1 Data Cache: 64 KB (65,536 bytes)
                       : L2 Cache: 16 MB (16,777,216 bytes)
- RAM: 16 GB
- Storage (if known): 926 GB (Total), 12 GB (Used), 805 GB (Available)
- OS: macOS 14.6.1 (Build 23G93)

### Input data

*Briefly describe how large your data set is and how you created it. Also include how long `msort` took to sort it.*

Our data set is 100,000,000 randomly generated integers created from the command 'shuf -i1-100000000 > hundred-million.txt'. 'msort' took 10.410208 to sort this data set.

### Experiments

*Replace X, Y, Z with the number of threads used in each experiment set.*

#### 1 Threads

Command used to run experiment: `MSORT_THREADS=1 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 1 thread(s). Reading input.
   Array read in 7.462687 seconds, beginning sort.
   Sorting completed in 10.405137 seconds.
   Array printed in 5.364164 seconds.

Second run:
2. Running with 1 thread(s). Reading input.
   Array read in 7.381599 seconds, beginning sort.
   Sorting completed in 10.261664 seconds.
   Array printed in 5.328481 seconds.

Third run:
3. Running with 1 thread(s). Reading input.
   Array read in 7.366739 seconds, beginning sort.
   Sorting completed in 10.465474 seconds.
   Array printed in 5.395505 seconds.

Fourth run:
4. Running with 1 thread(s). Reading input.
   Array read in 7.313138 seconds, beginning sort.
   Sorting completed in 10.447429 seconds.
   Array printed in 5.345856 seconds.

#### 2 Threads

Command used to run experiment: `MSORT_THREADS=2 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 2 thread(s). Reading input.
   Array read in 7.363186 seconds, beginning sort.
   Sorting completed in 10.389992 seconds.
   Array printed in 5.365888 seconds.

Second run:
2. Running with 2 thread(s). Reading input.
   Array read in 7.393347 seconds, beginning sort.
   Sorting completed in 10.481839 seconds.
   Array printed in 5.392921 seconds.

Third run:
3. Running with 2 thread(s). Reading input.
   Array read in 7.366301 seconds, beginning sort.
   Sorting completed in 10.466318 seconds.
   Array printed in 5.341083 seconds.

Fourth run:
4. Running with 2 thread(s). Reading input.
   Array read in 7.369832 seconds, beginning sort.
   Sorting completed in 10.352076 seconds.
   Array printed in 5.388955 seconds. 

#### 4 Threads

Command used to run experiment: `MSORT_THREADS=4 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 4 thread(s). Reading input.
   Array read in 7.342549 seconds, beginning sort.
   Sorting completed in 9.460676 seconds.
   Array printed in 5.408364 seconds.

Second run:
2. Running with 4 thread(s). Reading input.
   Array read in 7.376287 seconds, beginning sort.
   Sorting completed in 9.402829 seconds.
   Array printed in 5.443896 seconds.

Third run:
3. Running with 4 thread(s). Reading input.
   Array read in 7.377698 seconds, beginning sort.
   Sorting completed in 9.450864 seconds.
   Array printed in 5.443509 seconds.

Fourth run:
4. Running with 4 thread(s). Reading input.
   Array read in 7.373691 seconds, beginning sort.
   Sorting completed in 9.563331 seconds.
   Array printed in 5.450693 seconds.

#### 6 Threads

Command used to run experiment: `MSORT_THREADS=6 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 6 thread(s). Reading input.
   Array read in 7.418470 seconds, beginning sort.
   Sorting completed in 10.099523 seconds.
   Array printed in 5.463803 seconds.

Second run:
2. Running with 6 thread(s). Reading input.
Array read in 7.376871 seconds, beginning sort.
Sorting completed in 9.537310 seconds.
Array printed in 5.428776 seconds.

#### 8 Threads

Command used to run experiment: `MSORT_THREADS=8 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 8 thread(s). Reading input.
   Array read in 7.310320 seconds, beginning sort.
   Sorting completed in 11.301293 seconds.
   Array printed in 5.479643 seconds.

Second run:
2. Running with 8 thread(s). Reading input.
   Array read in 7.340546 seconds, beginning sort.
   Sorting completed in 11.677037 seconds.
   Array printed in 5.463652 seconds.

#### 10 Threads

Command used to run experiment: `MSORT_THREADS=10 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 10 thread(s). Reading input.
   Array read in 7.362571 seconds, beginning sort.
   Sorting completed in 15.916673 seconds.
   Array printed in 5.469539 seconds.

Second run:
2. Running with 10 thread(s). Reading input.
   Array read in 7.269181 seconds, beginning sort.
   Sorting completed in 15.897945 seconds.
   Array printed in 5.425108 seconds.

#### 20 Threads

Command used to run experiment: `MSORT_THREADS=20 ./tmsort 100000000 < hundred-million.txt > /dev/null`

Sorting portion timings:

First run:
1. Running with 20 thread(s). Reading input.
   Array read in 7.324206 seconds, beginning sort.
   Sorting completed in 48.995892 seconds.
   Array printed in 5.511026 seconds.

Second run:
2. Running with 20 thread(s). Reading input.
   Array read in 7.452630 seconds, beginning sort.
   Sorting completed in 43.127729 seconds.
   Array printed in 5.527003 seconds.

*repeat sections as needed*

## Observations and Conclusions

*Reflect on the experiment results and the optimal number of threads for your concurrent merge sort implementation on different hosts or platforms. Try to explain why the performance stops improving or even starts deteriorating at certain thread counts.*

The experiments indicate that on Host 2 (Anza's MacBook Pro), the sorting time decreases with an increasing number of threads up to 4 threads, after which the performance improvement starts to plateau or even degrade, particularly at higher thread counts (e.g., 10 and 20 threads). This suggests that the system may be experiencing diminishing returns as the overhead from managing additional threads outweighs the benefits of parallelization. The Apple M2 Pro processor has 12 cores, so when the thread count exceeds the number of available cores, the threads may become contending for CPU resources, leading to inefficiency. On Host 1 (Codespaces Terminal), the performance also follows a similar pattern but with more noticeable limitations due to fewer virtual cores (2 virtual CPUs). Overall, the optimal number of threads for this implementation seems to be around 4 for both hosts, as further increasing the thread count does not lead to significant performance gains.
