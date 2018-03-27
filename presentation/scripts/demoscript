# SAVE=1      Save output to a tar file for off-line running
# SKIP=1      Do not wait for user to press a key to continue
# RECOVER=1   Use the canned output when a command fails
# USESAVED=1  Use canned output instead of running the commands
# USESAVED=2  Use canned output IFF it exists, otherwise run it

scriptName="${0##.*/}"
bold=$(tput bold)
normal=$(tput sgr0)
delay=${DELAY:-"0.02"}
skip="$SKIP"
save="$SAVE"
saveTar=$(cd $(dirname "$0");pwd)/${scriptName}.tar
recover="$RECOVER"
useSaved="$USESAVED"

trap clean EXIT

function clean {
	rm -f out
}

if [[ "${useSaved}" != "" && "${useSaved}" != "2" && ! -e "${saveTar}" ]]; then
	echo "Missing saved output file: ${saveTar}"
	exit 1
fi

if [[ "${save}" != "" && "${useSaved}" == "" ]]; then
	rm -f "${saveTar}"
fi

function myscript() {
    if [[ "$(uname)" == Darwin ]]; then
    	script -q -a /dev/null $*
    else
    	script -efq -a /dev/null -c "$*"
    fi
}

function slowType() {
	str="$*"
	if [[ "$delay" == "0" ]]; then
		echo -n $bold$str$normal
		return
	fi
	for i in `seq 0 ${#str}`; do
		echo -n $bold${str:$i:1}$normal
		sleep $delay
	done
}

function slowTty() {
	str="$*"
	echo -n $bold >&3
	if [[ "$delay" == "0" ]]; then
		echo -n "$str"
	else
	    for i in `seq 0 ${#str}`; do
		    echo -n "${str:$i:1}"
		    sleep $delay
	    done
	fi
	sleep 0.2  # just to give the other program time to show its input
	echo -n $normal >&3
}

function readChar() {
	read -s -n 1 ch
	case "$ch" in
		f ) delay="0" ;;
		s ) delay=${DELAY:-"0.02"} ;;
		r ) skip="x" ;;
	esac
}

function pause() {
	if [[ "$skip" == "" ]]; then
		readChar
	else
		sleep 0.2
	fi
}

cmdNum=0

function doit() {
	local ignorerc=""
	local shouldfail=""
	local noexec=""
	local fakeit=${useSaved:-}
	local noscroll=${NOSCROLL:-}
	local postcmd=""

	while [[ "$1" == "--"* ]]; do
		opt="$1"
		shift

		case "$opt" in
			--ignorerc   ) ignorerc="1"   ;;
			--shouldfail ) shouldfail="1" ;;
			--noexec     ) noexec="1"     ;;
			--usesaved   ) fakeit="1"     ;;
			--noscroll   ) noscroll="1"   ;;
			--scroll     ) noscroll=""    ;;
			--post*      ) postcmd="${opt#*=}" ;;
		esac
	done

	set +e
	echo -n $bold"$"$normal" "
	pause
	slowType $*
	echo "$*" >> cmds
	pause
	echo

	saveFile="run.${cmdNum}"
	local lines=$(tput lines)
	let lines=lines-3
	moreCMD="more -$lines"
	if [[ "$skip" != "" || "$noscroll" != "" ]]; then
		moreCMD="cat"
	fi
	if [[ "$postcmd" != "" ]]; then
		moreCMD="$postcmd | $moreCMD"
	fi

	# Unless we're told to not execute it, do it
	if [[ "$noexec" == "" ]]; then
		if [[ "$fakeit" != "" ]]; then
			# Faking it!
			if tar -xf "${saveTar}" "${saveFile}" > /dev/null 2>&1; then
			    # echo "** Using saved output ${saveFile} **"
				cp "${saveFile}" out
				rm "${saveFile}"
				cat out | eval ${moreCMD[@]}
			
				if [[ "$shouldfail" == "" ]]; then
					rc=0
				else
					rc=1
				fi
			else
				if [[ "$fakeit" == "2" ]]; then
					# file doesn't exist so just try to run it instead
					fakeit=""
				else
					echo -n > out
				fi
			fi
		fi

		if [[ "$fakeit" == "" ]]; then
			# Run the cmd
			bash -c " $* " 2>&1 | tee out | eval ${moreCMD[@]}
			rc=${PIPESTATUS[0]}

			# Save the output if we're asked to
			if [[ "$save" != "" ]]; then
				cp out "${saveFile}"
				# tar --delete -f "${saveTar}" "${saveFile}" > /dev/null 2>&1 || true
				tar -rf "${saveTar}" "${saveFile}"
				rm "${saveFile}"
			fi
		fi

		# If the cmd failed see if we should use the canned output
		if [[ "$recover" != "" ]]; then
			if [[ ( ( "$shouldfail" == "" && "$rc" != "0" ) || \
		        	( "$shouldfail" != "" && "$rc" == "0" ) ) ]] && \
				  tar -xf "${saveTar}" "${saveFile}" > /dev/null 2>&1 ; then
				# echo "** Using saved output ${saveFile} **"
				cp "${saveFile}" out
				rm "${saveFile}"
			fi
		fi
		let cmdNum=cmdNum+1
	else
		# We're not really executing it, just showing the cmd
		echo -n > out
		rc=0
	fi

	echo

	if [[ "$ignorerc" == "" ]]; then
		# We're not totally ignoring the exit code
		if [[ "$shouldfail" != "" ]]; then
			# We need to make sure the command failed as expected
			if [[ "$rc" == "0" ]]; then
				echo "Expected non-zero exit code, got: $rc"
				exit 1
			fi
		else
			# Normal non-zero exit code expected case
			if [[ "$rc" != "0" ]]; then
				echo "Non-zero exit code: $rc"
				exit 1
			fi
		fi
	fi

	set -e
}

function background() {
	echo -n $bold"$"$normal" "
	slowType $*
	echo "$*" >> cmds
	echo
	bash -c " $* " &
}

function ttyDoit() {
	local ignorerc=""
	local shouldfail=""

	while [[ "$1" == "--"* ]]; do
		opt="$1"
		shift

		case "$opt" in
			--ignorerc   ) ignorerc="1"   ;;
			--shouldfail ) shouldfail="1" ;;
		esac
	done

    echo -n $bold"$"$normal" "
	pause
    slowType "$*"
	pause
    echo

    exec 3>&1
	set +e
    (
		sleep 0.2
        while read -u 10 line ; do
			dontWait=""
			if [[ "$line" == "run "* ]]; then
				line=${line:4}
				${line}
				continue
			fi
			if [[ "$line" == "@"* ]]; then
				# Lines starting with "@" will be executed
				# immediately w/o pausing before or after showing it
				dontWait="x"
				line=${line:1}
			fi
			if [[ "$dontWait" == "" ]]; then pause ; fi
            slowTty $line
			if [[ "$dontWait" == "" ]]; then pause ; fi
            echo
			sleep 0.2
        done
        echo
    ) | myscript $*
	rc=${PIPESTATUS[1]}
	echo -n $normal
	echo
	[[ "$ignorerc" == "" && "$rc" != "0" ]] && echo "Non-zero exit code" && exit 1
	[[ "$shouldfail" != "" && "$rc" == "0" ]] && echo "Expected non-zero exit code" && exit 1
	set -e
}

function comment() {
	local LF="\\n"
	local CR=${LF}
	local echoopt=""
	local dopause=""
	local dopauseafter=""
	local nohash=""

	while [[ "$1" == "--"* ]]; do
		opt="$1"
		shift

		case "$opt" in
			--nolf  ) LF="" ;;
			--nocr  ) CR="" ; LF="" ;;
			--pause ) dopause="1" ; dopauseafter="1" ;;
			--pauseafter ) dopauseafter="1" ;;
			--nohash ) nohash="1" ;;
		esac
	done
	if [[ "$nohash" == "" ]]; then
	    echo -en $bold\#" "$normal
    fi
	if [[ "$dopause" == "1" ]]; then
		pause
	fi
	echo -en ${echoopt} "$bold$*$normal"
	if [[ "$dopause" == "1" || "$dopauseafter" == "1" ]]; then
		pause
	fi
	echo -en ${echoopt} "${CR}${LF}"
}

# Wait until the passed in cmd returns true
function wait() {
	# set -x
	if [[ "${useSaved}" != "" ]]; then
		return
	fi
	if [ "$1" == "!" ]; then
		shift
	    while (bash -c " $* " &> /dev/null); do
	        sleep 1
	    done
	else
	    while !(bash -c " $* " &> /dev/null); do
	        sleep 1
	    done
	fi
	# set +x
}

function scroll() {
	local lines=$(tput lines)
	let lines=lines-3

	echo -n $bold"$"$normal" "
	# set +e
	pause
	if [[ "$skip" == "" ]]; then
	  slowType more $*
	else
	  slowType cat $*
	fi
	pause
	echo
	if [[ "$skip" == "" ]]; then
	  more -$lines $*
	else
	  cat $*
	fi
	echo
}
