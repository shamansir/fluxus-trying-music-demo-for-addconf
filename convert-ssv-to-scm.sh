echo "(define twit-data '("`sed -e 's/\(.*\)/(\1)/' ./$1.ssv`"))" > ./$1.scm
