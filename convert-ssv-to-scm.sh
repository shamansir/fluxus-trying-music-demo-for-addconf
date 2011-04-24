echo "(define mylist '("`sed -e 's/\(.*\)/(\1)/' ./$1.ssv`"))" > ./$1.scm
