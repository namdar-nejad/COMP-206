files="weblog1.txt weblog2.txt weblog3.txt"

for f in $files; do
	echo "Web metrics for log file $f"
	echo '===================='
	./webmetrics.sh $f
	echo ""
        echo ""
done
