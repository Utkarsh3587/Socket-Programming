#!/bin/bash


declare -a urls=($1)

download_html_page() {
	website=$1 # 'https://stackoverflow.com'
	curlresult=`curl -sSL -w '%{http_code} %{url_effective}' $website -o html_code.html`
	# echo "INFO" "$curlresult" # orint status code and url
	sed -n 's/.*href="\([^"]*\).*/\1/p' html_code.html > url.txt
	echo "INFO: Download Html Page"

	print_search_term $1 $2

	find_all_related_urls $1
}


find_all_related_urls() {
	
	while IFS= read -r line; do
		# echo "URL ${line}"  # print all url

	    if [[ $line == /*  ]] && [[ " ${urls[*]} " != *"$1${line}"* ]]; then  #  https://stackoverflow.com${line}
	    	urls+=("$1${line}")
	    	echo "hello relative: $1$line"
	    elif [[ $line == $1/* ]] && [[ " ${urls[*]} " != *"$line"* ]]; then
	    	urls+=($line)
	    	echo "hello absolute: $line"
	    fi
	done < url.txt
}


print_search_term() {
	# echo `sed -n "/$2/=" "html_code.html"` # find line numbers of search string

	last_line=`grep -c . html_code.html`
	
	echo "INFO: Result from $1 =========>"
	echo
	for current_line in `sed -n "/$2/=" "html_code.html"`
	do
		previous_line=`expr $current_line - 1`
		next_line=`expr $current_line + 1`
		if [[ $previous_line != -1 ]]; then
			echo "${previous_line}" `sed "${previous_line}q;d" html_code.html`
		fi
		echo "${current_line}" `sed "${current_line}q;d" html_code.html`
		if [[ $next_line != $last_line ]]; then
			echo "${next_line}" `sed "${next_line}q;d" html_code.html`
		fi
		
		echo
	done

	echo "INFO: Result from $1 Completed =========>"
	echo
}

echo "INFO: Passed variable are URL: ${1} and Search String: ${2}"
echo

for (( i = 0; ; i++ )); do
	
	if [ -z ${urls[i]} ]; then
		echo "INFO: Completed! Terminating in a sec ${urls[i]}"
		break
	else
		echo "INFO: Download Webpage URL: ${urls[i]}"
		echo
		download_html_page ${urls[i]} $2
		sleep 2
	fi
done
