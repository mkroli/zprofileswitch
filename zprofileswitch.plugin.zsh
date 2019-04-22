function zprofileswitch() {
	local PSD="${PROFILESWITCH_DIR:-${HOME}/.zprofileswitch}"
	[ -d "${PSD}/profile" ] || mkdir -p "${PSD}/profile"
	case "${1}" in
		"eval")
			[ -r "${PSD}/current" ] && source "${PSD}/current"
			;;
		"list")
			ls "${PSD}/profile" | grep -v current
			;;
		"switch")
			if [ -n "${2}" ] && [ -r "${PSD}/profile/${2}" ]; then
				rm -f "${PSD}/current"
				ln -s "${PSD}/profile/${2}" "${PSD}/current"
				source "${PSD}/current"
			else
				print "profile ${2} does not exist"
			fi
			;;
		"edit")
			if [ -n "${2}" ]; then
				${EDITOR} "${PSD}/profile/${2}"
			else
				print "profile missing"
			fi
			;;
		"set")
			if [ -n "${2}" ]; then
				( for stmt in "${(@)*[3,-1]}"; do
					print -- "${stmt}"
				done ) > "${PSD}/profile/${2}"
			else
				print "profile missing"
			fi
			;;
		"delete")
			if [ -n "${2}" ] && [ -r "${PSD}/profile/${2}" ]; then
				[ -h "${PSD}/current" ] && [ "$(readlink "${PSD}/current")" = "${PSD}/profile/${2}" ] && rm -f "${PSD}/current"
				rm -f "${PSD}/profile/${2}"
			else
				print "profile ${2} does not exist"
			fi
			;;
		*)
			cat <<"EOF"
zprofileswitch

Usage:
  zprofileswitch list
  zprofileswitch switch <profile>
  zprofileswitch edit <profile>
  zprofileswitch set <profile> <statement>...
  zprofileswitch delete <profile>
EOF
	esac
}

zprofileswitch eval

alias zps=zprofileswitch
