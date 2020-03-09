#!/usr/local/bin/bash
. fun.sh    # Using super nerdy functional library as dependency

echo $BASH_VERSION
    # Recursively get directories by using ls -R and removing everything but the full paths of the directories. Also replacing
    # white space in files names with "@" to work around white space delimitor usage in Bash
declare -a files=("$(list "$@") $(ls -R "$@" | grep -e '^/' | sed -e 's/://' -e 's/[[:space:]]/:/g' | grep -v 'shasum')")
#echo "files"
    #list $files # debug list files

    # maps shasum over all the directories and calls all the files inside. Also using sed to put white spaces back in   
    # files names
declare -a hashes=$(list $files | map lambda x . 'shasum -a 1 $(echo $x | sed -e 's/:/[[:space:]]/g' )/* 2> /dev/null | sed -e 's/[[:space:]]/_/g'')
#echo "hashes"
#list $hashes
 #   turns hashes and file names into tuples
tupify() {
    local r

    tupify_itr() {
        local x=$@
        
        while [[ -n $x ]]; do
            r+=( $(tup $(list $x | take 2)) )
            x=$(list $x | drop 2)    
        done
        echo ${r[@]}
    }

    tupify_itr $@
}

tupifyRecur() {
    local a
        tupify_itr() {
            local w=$@
            shift
            local x=$@

            if [[ -z $x ]]; then
                echo ${a[@]}
            else
                #echo "hello" ${tupped[@]}
                a+=( $(tup $(list $x | take 1 | cut -c 1-40 ) \
                     $(list $x | take 1 | cut -c 41-)) )
 #   echo ${a[@]}
                tupify_itr $x 
            fi
        }

    tupify_itr $@
}



# checks the head of the hash list with the tail and repeats on the tail until the list is empty
checkForMatchRecur() {
    local y
    #list $@
    
        checkForMatch_irt() {
            local otherx=$1
            shift
            local x=$@
            #local xtail=$(list $@ | ltail)
    #echo "du:"$@
           
               doesItMatch() {
                    #local z=${x[0]} 
                    local z=$otherx
                    if [[ $z = $1 ]]; then 
                       echo "duplicate:"$z #"re:"$1
                    fi
               }

            if [[ -z $x ]]; then
                echo ${y[@]}
            else
                y+=($(list $x | map lambda a . 'doesItMatch $a' ))
                checkForMatch_irt $x
            fi
        }
        
    checkForMatch_irt $(list $@ | map lambda a . 'tupl $a')
}

checkForMatch() {
    local x=$@
    local leftsideoftup+=($(list ${x[@]} | map lambda a . 'tupl $a'))
    local firstEl
    local accu

    while [ ${#leftsideoftup[@]} -gt 0 ]; do
        
        firstEl=${leftsideoftup[0]}
        leftsideoftup=(${leftsideoftup[@]:1})

        for i in $leftsideoftup; do
            if [[ $firstEl != $i ]]; then
                continue
            else
                accu+=($i)
            fi
        done

    done

    echo "$accu"
}


# echo "tupifyRecur"
# list $(tupifyRecur $hashes)
checkForMatchRecur $(tupifyRecur $hashes)
#list $(list $(tupify $hashes) | map lambda x . 'tupl $x') | uniq -c | grep -v '^   1'        # uses uniq from Bash to match hashes





