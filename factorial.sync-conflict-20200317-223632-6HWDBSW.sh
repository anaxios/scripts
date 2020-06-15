#!/bin/bash

. fun.sh

factorial() {
    fact_iter() {
        local product=$1
        local counter=$2
        local max_count=$3
        if [[ $counter -gt $max_count ]]; then
            res $product
        else
            call fact_iter $(echo $counter\*$product | bc) $(($counter + 1)) $max_count
        fi
    }

    with_trampoline fact_iter 1 1 $1
}

time factorial 100 | fold -w 70