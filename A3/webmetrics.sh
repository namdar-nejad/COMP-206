# Cheking parameters
if [ "$#" -ne 1 ];then
        echo "Error: No log file given."
        echo "Usage: ./webmetrics.sh <logfile>"
	exit 1
elif [ ! -f "$(realpath $1)" ]; then
	echo "Error: File '$(realpath $1)' does not exist."
        echo "Usage: ./webmetrics.sh <logfile>"
	exit 2
fi

# Printing the number of browser calls
echo Number of requests per web browser
echo "Safari,"$(grep -ic "Safari" $1)
echo "Firefox,"$(grep -ic "Firefox" $1)
echo "Chrome,"$(grep -ic "Chrome" $1)

# Counting the distinct users per day
echo $'\nNumber of distinct users per day'
for i in $(awk -F '[:[]' '{print $2}' "$(realpath $1)" | sort -u); do
	echo "$i,""$(awk '{sub(/:.*/, ""); print}' "$(realpath $1)" | sort -u | grep -ioc "$i")"

done

# Counting the most popular products
echo $'\nTop 20 popular product requests'
printf '%s\n' $(grep -o "GET /product/[0-9]\+/" < $1 | awk 'BEGIN {FS="/"} {print $3}' | awk '{a[$1]++} END {for (pair in a) printf("%s,%d\n", pair, a[pair])}' | sort -t, -rnk2 -k1 | head -n20)



exit 0
