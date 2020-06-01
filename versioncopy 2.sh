#!/usr/local/bin/bash
# version-test.sh
echo $BASH_VERSION

lambda() {

  lam() {
    local arg
    while [[ $# -gt 0 ]]; do
      arg="$1"
      shift
      if [[ $arg = '.' ]]; then
        echo "$@"
        return
      else
        echo "read $arg;"
      fi
    done
  }

  eval $(lam "$@")

}

λ() {
  lambda "$@"
}

map() {
  if [[ $1 != "λ" ]] && [[ $1 != "lambda" ]]; then

    local has_dollar=$(list $@ | grep '\$' | wc -l)

    if [[ $has_dollar -ne 0 ]]; then
      args=$(echo $@ | sed -e 's/\$/\$a/g')
      map λ a . $args
    else
      map λ a . "$@"' $a'
    fi
  else
    local x
    while read x; do
      echo "$x" | "$@"
    done
  fi
}

doesItMatch() {
    local a=$1
    local b=$2

    if [[ $a = $b ]]; then
        echo "They Match!"
    fi

}

echo "2" "1" "1" | map lambda a b c . 'doesItMatch $a $b'