network_adapter="bridge"
containers=$(docker network inspect $(echo $network_adapter) --format {{.Containers}} | 
	tr "}" "\n" | 
	tr -d " " | 
	cut -f1 -d ":" | 
	cut -f2 -d "[" | 
	head -n-1)

i=1
echo "Network adapter name: $network_adapter"
echo -n "Subnet and gateway: "
echo "$(docker network inspect $(echo $network_adapter) --format {{.IPAM.Config}} | 
                                                                    tr "{[]}" " " | 
                                                                    cut -c3- | 
                                                                    rev | 
                                                                    cut -c9- | 
                                                                    rev)"
echo -e "-----------------------------------------------------------\n"
for a in $containers; do 
    echo "Container no. $i:"
    echo "Name: $(docker container inspect $(echo $a) --format {{.Name}} | cut -c2-)"
    echo "Id: $a"
    echo -n "IP address: "
    docker container inspect $(echo $a) --format {{.NetworkSettings.IPAddress}}
    echo ""
    ((i=i + 1))
done
