#!/bin/bash
. ./fun.sh # Using super nerdy functional library as dependency

# Recursively get directories by using ls -R and removing everything but the full paths of the directories. Also replacing
# white space in files names with "@" to work around white space delimitor usage in Bash
declare -a files=("$(list "$@") $(ls -R "$@" | grep -e '^/' | sed -e 's/://' -e 's/[[:space:]]/@/g' | grep -v 'shasum')")

#list $files # debug list files

# maps shasum over all the directories and calls all the files inside. Also using sed to put white spaces back in 
# files names
hashes=$(list $files | map lambda x . 'shasum -a 256 $(echo $x | sed -e 's/@/[[:space:]]/g' )/* 2> /dev/null')

# turns hashes and file names into tuples
tupify() {
    local x=$@
    local y
    local tuped
    
    if [[ ${#x[0]} -gt 0 ]]
    then
        tuped=$(tup $(list $x | take 2)) 
        y+=($tuped)
        tupify $(list $x | drop 2)      #recursively called
        
    fi
    echo $y
}

# checks the head of the hash list with the tail and repeats on the tail until the list is empty
checkForMatch() {
    local r
    checkForMatch_itr() {
        local x=$@
        local a=${x[0]}
        #echo $x "XX"
        echo $a  
        
        if [[ -z $x ]]; then 
            echo finished #list ${r[@]}
        else  
            compareHead() {
                local IN=$1
                
                echo $a
                # if [ $a = $IN ]; then
                #     echo $IN
                # else
                #     echo fail
                # fi
            }

            r+=( $(list $x | ltail | map lambda a . 'compareHead $a' ))
            
            checkForMatch_itr $(list $x | ltail)      # $( r+=( $(list $x | ltail | map lambda x . 'compareHead $x') ${r[@]} )  ) # called recursively
        fi
        
        
         
    }

    # remove hashes from the tuples
    checkForMatch_itr $(list $@ | map lambda x . 'tupl $x')
    #echo $r
    #list $y | uniq -c | grep -v '^   1'        # uses uniq from Bash to match hashes
    
}





checkForMatch $(tupify $hashes)







# checkForMatch() {
    
#     local x=$@
#     local r

#     local y=$(list $x | map lambda x . 'tupl $x')       # remove hashes from the tuples

#     if [ ${#y[0]} -gt 0 ]
#     then 
#         compareHead() {
#             local a=$(list $y | lhead)
#             if [ $a = $1 ]
#             then
#                 echo "got one $1"
#             fi
#         }
    
#         r=$(list $y | ltail | map lambda x . 'compareHead $x')
#         checkForMatch $(list $y | drop 1)      # called recursively
#     fi
#     echo $r
#     #list $y | uniq -c | grep -v '^   1'        # uses uniq from Bash to match hashes
    
# }


#list $y | map lambda x . ''



# | grep -v -e "${@}" -e "^[[:space:]]*$"

#echo "hello" | checkForMatch

    #| map lambda x . 'shasum -a 256 $x'




    # if [ ${#x[0] != 0 } ]
    # then
    #     #echo "I'm still going"
    #     #echo ${#x[0]}
    #     tuped=$(tup $(list $x | take 2)) 
    #     y+=($tuped)
    #     echo $y
    #     tupify $(list $x | drop 2)
        
    # fi