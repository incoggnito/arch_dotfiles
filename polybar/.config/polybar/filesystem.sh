output=$(df -k .)
arrout=(${output// / })
output=${arrout[13]}
#output=${output%\%}
echo ${arrout[13]}
#case 1 in
    #$(($output<= 50)))echo "$output";;
                       #*)echo " HD $output %";;
#esac
