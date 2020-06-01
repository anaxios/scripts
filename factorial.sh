#!/usr/local/bin/bash


. fun.sh

# factorialT() {
#     fact_iter() {
#         local product=$1
#         local counter=$2
#         local max_count=$3
#         if [[ $counter -gt $max_count ]]; then
#             res $product
#         else
#             call fact_iter $(echo $counter\*$product | bc) $(($counter + 1)) $max_count
#         fi
#     }

#     with_trampoline fact_iter 1 1 $1
# }

# factorial() {
#     fact_iter() {
#         local product=$1
#         local counter=$2
#         local max_count=$3
#         if [[ $counter -gt $max_count ]]; then
#             echo $product
#         else
#             fact_iter $(echo $counter\*$product | bc) $(($counter + 1)) $max_count
#         fi
#     }

#     fact_iter 1 1 $1
# }

# time factorialT 53 | fold -w 70

sum() { [[ $1 -le 0 ]] && echo $2 || sum $(($1 - 1)) $(($1 + $2)) ; }

echo $(sum 10000 0)