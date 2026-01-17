function run() {
    local filename=$1
    local name="${filename%%.*}"
    local ext="${filename##*.}"

    if [[ $ext == "cpp" ]]; then
        g++ -std=c++23 -g -Wall -o $name.out $filename && ./$name.out
    elif [[ $ext == "c" ]]; then
        gcc -std=c23 -g -Wall -o $name.out $filename && ./$name.out
    elif [[ $ext == "rs" ]]; then
        rustc -o $name.out $filename && ./$name.out
    fi
}
