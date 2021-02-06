output=$(yay -u | wc -l)

case 1 in
    $(($output== 0)))echo "";;
    $(($output<= 10)))echo "$output";;
    $(($output<= 20)))echo "$output";;
                       *)echo "$output";;
esac
