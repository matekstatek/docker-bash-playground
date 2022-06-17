all=0
stopped=0
while getopts ase: flag
do
	case "${flag}" in
		a) 
		all=1;;
		
		s) 
		stopped=1;;
		
		e) 
		#elements=${OPTARG}
		elements=$@;;
	esac
done

list=$(docker container ls -a)
lines=$(echo $list | wc -l)
elements_count=$(echo $elements | wc -w)

if [[ $lines -eq 1 ]]; then
	echo "There's no containers"
	return 0
fi

if [[ $all -eq 1 ]]; then
	docker container ls -a
	answer="n"
	echo -en "Are you sure? (y/n): "
	read $answer
	if [[ $answer -eq "y" ]]; then
		echo "Deleted"
	fi
	
elif [[ $stopped -eq 1 ]]; then
	docker container ls -a | grep -i exit
	
	answer="n"
	echo -en "Are you sure? (y/n): "
	read $answer
	if [[ $answer -eq "y" ]]; then
		echo "Deleted"
	fi

elif [[ $elements_count -ne 0 ]]; then
	elements=$(echo $elements | tail -$elements_count)
	
	for el in "${elements[@]}"; do
		echo $el
		echo $(echo $list | grep -i $el)
	done
	
	answer="n"
	echo -en "Are you sure? (y/n): "
	read $answer
	if [[ $answer -eq "y" ]]; then
		echo "Deleted"
	fi
fi
	

