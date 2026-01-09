function template() {
    choice=$1

    if [[ $choice == "make-cpp" ]]; then
        # competition makefile
        cp ~/templates/MakefileCPP Makefile
    elif [[ $choice == "make-proj" ]]; then
        # project makefile
        cp ~/templates/MakefileProj Makefile

    elif [[ $choice == "cmake" ]]; then
        # project makefile
        cp ~/templates/CMakeLists.txt .

    elif [[ $choice == "cpp" ]]; then
        # competition cpp
        cp ~/templates/setup.cpp .

    elif [[ $choice == "py" ]]; then
        # competition python
        cp ~/templates/setup.py .
    else
        echo "error: unrecognized"
        echo "choose from: [make-cpp, make-proj, cmake, cpp, py]"
    fi
}
