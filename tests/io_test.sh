#!/bin/sh

export BUFFER_SIZE=256
export CHANNEL="/root/Videos/Big_Buck_Bunny_small.ogv"
export SOURCE_ADDR="150.214.150.68"
export SOURCE_PORT=4551
export SPLITTER_PORT=4557

usage() {
    echo $0
    echo "  [-b buffer size ($BUFFER_SIZE)]"
    echo "  [-c channel ($CHANNEL)]"
    echo "  [-s source IP address, ($SOURCE_ADDR)]"
    echo "  [-o source port ($SOURCE_PORT)]"
    echo "  [-p splitter port ($SPLITTER_PORT)]"
    echo "  [-? help]"
}

echo $0: parsing: $@

while getopts "b:c:s:o:p:?" opt; do
    case ${opt} in
	b)
	    BUFFER_SIZE="${OPTARG}"
	    ;;
	c)
	    CHANNEL="${OPTARG}"
	    ;;
	s)
	    SOURCE_ADDR="${OPTARG}"
	    ;;
	o)
	    SOURCE_PORT="${OPTARG}"
	    ;;
	p)
	    SPLITTER_PORT="${OPTARG}"
	    ;;
	?)
	    usage
	    exit 0
	    ;;
	\?)
	    echo "Invalid option: -${OPTARG}" >&2
	    usage
	    exit 1
	    ;;
	:)
	    echo "Option -${OPTARG} requires an argument." >&2
	    usage
	    exit 1
	    ;;
    esac
done


xterm -e '../splitter.py --buffer_size=$BUFFER_SIZE --channel $CHANNEL' &

sleep 1

monitor_port=$(( $SPLITTER_PORT + 1 ))
xterm -e '../peer.py --port $monitor_port --player_port 9998 --splitter_port $SPLITTER_PORT' &

xterm -e 'netcat localhost $monitor_port  > /dev/null' &

