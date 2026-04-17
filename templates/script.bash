function template() {
    local choice=$1
    local dir="$HOME/templates"

    declare -A map=(
        ["make-cpp"]="MakefileCPP"
        ["make-proj"]="MakefileProj"
        ["cmake"]="CMakeLists.txt"
        ["cpp"]="setup.cpp"
        ["py"]="setup.py"
        [".clangd"]=".clangd"
        [".clang-format"]=".clang-format"
    )

    if [[ -n ${map[$choice]} ]]; then
        cp "$dir/${map[$choice]}" .
    else
        echo "error: unrecognized template"
        echo "choose from: ${!map[*]}"
        return 1
    fi
}
