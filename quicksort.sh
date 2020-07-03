#!/usr/local/bin/bash

quicksort()
{
    local head
    lesseq()
    {
        if [[ 1 -gt "$#" ]]; then return; fi
        if [[ "$1" < "$head" || "$1" == "$head" ]]; then echo "$1" ; fi
        shift
        lesseq "$@"
    }
    greater()
    {
        if [[ 1 -gt "$#" ]]; then return; fi
        if [[ "$1" > "$head" ]]; then echo "$1"; fi
        shift
        greater "$@"
    }
    loop()
    {
        if [[ 1 -gt "$#" ]]; then return; fi
        head="$1"
        shift
        echo $(loop $(lesseq "$@")) "$head" $(loop $(greater "$@"))
    }
    loop "$@"
}

map()
{
    local head="$1"
    local x
    loop()
    {
        if [[ -z $# ]]; then return; fi
        shift
        echo $($head "$1")
        loop "$@"
    }
    loop "$@"
}
