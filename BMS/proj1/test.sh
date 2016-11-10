while [[ $# -gt 1 ]]
do
key="$1"

RAND=0
BURST=0

case $key in
    -i|--input)
    INPUT="$2"
    shift # past argument
    ;;
    -r|--random)
    RAND="$2"
    shift # past argument
    ;;
    -b|--burst)
    BURST="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

RES=$(./bms1A $INPUT)

echo $RES

if [ $RAND -gt 0 ]; then
	echo "Inserting random errors"
	`./errInjecter -i "${INPUT}.out" -r $RAND`
elif [ $BURST -gt 0 ]; then
	echo "Inserting burst errors"
	`./errInjecter -i "${INPUT}.out" -b $BURST`
fi

`./bms1B "${INPUT}.out.err"`

DIFF=`diff "${INPUT}" "${INPUT}.out.err.ok"`

echo $DIFF

