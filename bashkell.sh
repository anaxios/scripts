#!/usr/local/bin/bash
. fun.sh    # Using super nerdy functional library as dependency

    # Recursively get directories by using ls -R and removing everything but the full paths of the directories. Also replacing
    # white space in files names with "@" to work around white space delimitor usage in Bash
declare -a files=("$(list "$@") $(ls -R "$@" | grep -e '^/' | sed -e 's/://' -e 's/[[:space:]]/√/g' | grep -v 'shasum')")

    #list $files # debug list files

    # maps shasum over all the directories and calls all the files inside. Also using sed to put white spaces back in   
    # files names
hashes=$(list $files | map lambda x . 'shasum -a 256 $(echo $x | sed -e 's/√/[[:space:]]/g' )/* 2> /dev/null')

    # turns hashes and file names into tuples
tupify() {
    local r

    tupify_itr() {
        local x=$@
        
        while [[ -n $x ]]; do
            r+=( $(tup $(list $x | take 2)) )
            x=$(list $x | drop 2)      #recursively called
        done
        echo ${r[@]}
    }

    tupify_itr $@
}

# checks the head of the hash list with the tail and repeats on the tail until the list is empty
checkForMatch() {
    local x=$(list $@ | map lambda x . 'tupl $x')
    local r
    local h=$(list $x | lhead)
    compareHead() {
        local IN=$1
        h=$(list $x | lhead)
        
        if [ $h == $IN ]; then
            echo $h
        fi
    }

    while [[ -n $x ]]; do
        r+=( $(list $x | ltail | map lambda a . 'compareHead $a' ) )
        x=$(list $x | ltail)    
    done 
    echo ${r[@]} 
}





#checkForMatch $(tupify $hashes)
#tupify $hashes
list $(list $(tupify $hashes) | map lambda x . 'tupl $x') | uniq -c | grep -v '^   1'        # uses uniq from Bash to match hashes





# recursively make tuples but takes ages
# tupify() {
#     local r

#     tupify_itr() {
#         local x=$@
        
#         if [[ -z $x ]]; then
#            echo ${r[@]}
#         else
#             r+=( $(tup $(list $x | take 2)) )
#            tupify_itr $(list $x | drop 2)      #recursively called
#         fi
#     }

#     tupify_itr $@
# }

# recursive match check takes ages
# checkForMatch() {
#     local r
#     local x=$@
#     checkForMatch_itr() {
#         x=$@
#         local h=$(list $x | lhead)
#         compareHead() {
#             local IN=$1
#             local a=$h
            
#             if [ $a = $IN ]; then
#                 echo $IN
#             fi
#         }

#         if [[ -z $x ]]; then 
#             echo ${r[@]}
#         else  
#             r+=( $(list $x | ltail | map lambda a . 'compareHead $a' ))
#             checkForMatch_itr $(list $x | ltail)      # $( r+=( $(list $x | ltail | map lambda x . 'compareHead $x') ${r[@]} )  ) # called recursively
#         fi   
#     }

#     # remove hashes from the tuples
#     checkForMatch_itr $(list $@ | map lambda x . 'tupl $x')
    
     
# }