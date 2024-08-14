#!/bin/bash

pattern="\/setup\$"
export CODE_BASE_PATH=$(pwd | perl -pe "s/$pattern//")
echo -e "Root of code base has been specified as:\n    $CODE_BASE_PATH"