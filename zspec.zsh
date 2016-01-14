disable -r end

within_desc=false
within_it=false
count_desc=0
count_it=0

describe() {
    let count_desc++
}

it() {
    let count_it++

    if (( $count_desc == 0 )); then
        echo err
        exit 1
    fi
}

end() {
    if (( count_it > 0 )); then
        let count_it--
    elif (( count_desc > 0 )); then
        let count_desc--
    else
        echo err
        exit 1
    fi
}

source "$1"
if (( count_it > 0 || count_desc > 0 )); then
    echo err
    exit
fi
