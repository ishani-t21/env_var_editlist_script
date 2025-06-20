#!/usr/bin/sh

editlist() {
	VAR=PATH
	SEP=":"
	FLAG=""
	
	OPTIND=1
	
	while getopts lapde:s: f ; do
		case $f in
			l)
				if [ -n "${FLAG}" ] ; then
					echo "Error: Cannot pass more than one option from -l, -a, -p, -d" >&2
					exit 1
				fi
				FLAG="l"
				;;
			a)
				if [ -n "${FLAG}" ] ; then
					echo "Error: Cannot pass more than one option from -l, -a, -p, -d" >&2
					exit 1
				fi
				FLAG="a"
				;;
			p)
				if [ -n "${FLAG}" ] ; then
					echo "Error: Cannot pass more than one option from -l, -a, -p, -d" >&2
					exit 1
				fi
				FLAG="p"
				;;
			d)
				if [ -n "${FLAG}" ] ; then
					echo "Error: Cannot pass more than one option from -l, -a, -p, -d" >&2
					exit 1
				fi
				FLAG="d"
				;;
			e)
				VAR="${OPTARG}"
				;;				
			s)
				if [ "${#OPTARG}" -eq 1 ] ; then
					SEP="${OPTARG}"
				fi
				;;
			\?)
				exit 1
				;;
		esac
	done
	
	shift $((OPTIND - 1))
	
	if [ -z "${FLAG}" ] ; then
		echo "Error: Exactly one of -l, -a, -p, -d must be provided" >&2
		exit 1
	fi
	
	eval "ENV_VAR_VALUE=\$$VAR"
	
	if [ "${FLAG}" = "l" ] ; then
		/bin/echo "${ENV_VAR_VALUE}" | /bin/tr "${SEP}" '\n'
	
	elif [ "${FLAG}" = "a" ] ; then
		for arg in "$@" ; do
			case "${arg}" in
				*"${SEP}"*)
					echo "Error: String cannot contain the separator" >&2
					exit 1
					;;
				*)
					if [ -n "${ENV_VAR_VALUE}" ] ; then
						ENV_VAR_VALUE="${ENV_VAR_VALUE}${SEP}${arg}"
					else
						ENV_VAR_VALUE="${arg}"
					fi
					;;
			esac
		done
		eval "$VAR=\${ENV_VAR_VALUE}"
		export $VAR
	
	elif [ "${FLAG}" = "p" ] ; then
		for arg in "$@" ; do
			case "${arg}" in
				*"${SEP}"*)
					echo "Error: String cannot contain the separator" >&2
					exit 1
					;;
				*)
					if [ -n "${ENV_VAR_VALUE}" ] ; then
						ENV_VAR_VALUE="${arg}${SEP}${ENV_VAR_VALUE}"
					else
						ENV_VAR_VALUE="${arg}"
					fi
					;;
			esac
		done
		eval "$VAR=\${ENV_VAR_VALUE}"
		export $VAR
	
	elif [ "${FLAG}" = "d" ] ; then
		NEW_ENV_VAR_VALUE="${ENV_VAR_VALUE}"
		for arg in "$@" ; do
			case "${arg}" in
				*"${SEP}"*)
					echo "Error: String cannot contain the separator" >&2
					exit 1
					;;
				*)
					NEW_ENV_VAR_VALUE=$(\
						/bin/echo "${NEW_ENV_VAR_VALUE}" \
						| /bin/tr "${SEP}" '\n' \
						| /bin/grep -v -x -F -- "${arg}" \
						| /bin/tr '\n' "${SEP}" \
						| /bin/head -c -1)
					;;
			esac
		done
		eval "$VAR=\${NEW_ENV_VAR_VALUE}"
		export $VAR
	
	fi
}