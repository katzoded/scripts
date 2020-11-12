#!/usr/bin/sh





cat ${1} | \

~/dev-newton/scripts/ReplaceFileList.sh ".*\(value = .*\), \(transitionName = .*\), .*tv_sec = \(.*\), tv_usec = \(.*\)},.*" "\3.\4 \1 \2" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 0 transitionName = 3" "State = IDLE transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 1 transitionName = 3" "State = INVITING transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 2 transitionName = 3" "State = REDIRECTED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 3 transitionName = 3" "State = UNAUTHENTICATED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 4 transitionName = 3" "State = OFFERING transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 5 transitionName = 3" "State = ACCEPTED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 6 transitionName = 3" "State = CONNECTED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 7 transitionName = 3" "State = DISCONNECTED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 8 transitionName = 3" "State = DISCONNECTING transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 9 transitionName = 3" "State = TERMINATED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 10 transitionName = 3" "State = REMOTE_ACCEPTED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 11 transitionName = 3" "State = CANCELLED transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 12 transitionName = 3" "State = CANCELLING transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 13 transitionName = 3" "State = PROCEEDING transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 14 transitionName = 3" "State = PROCEEDING_TIMEOUT transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 15 transitionName = 3" "State = MSG_SEND_FAILURE transitionName = StateChange" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 0 transitionName = \([1|2]\)" "Msg = INVITE transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 1 transitionName = \([1|2]\)" "Msg = ACK transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 2 transitionName = \([1|2]\)" "Msg = BYE transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 3 transitionName = \([1|2]\)" "Msg = REGISTER transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 4 transitionName = \([1|2]\)" "Msg = REFER transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 5 transitionName = \([1|2]\)" "Msg = NOTIFY transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 6 transitionName = \([1|2]\)" "Msg = OTHER transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 7 transitionName = \([1|2]\)" "Msg = PRACK transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 8 transitionName = \([1|2]\)" "Msg = CANCEL transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "value = 9 transitionName = \([1|2]\)" "Msg = SUBSCRIBE transitionName = \1" | \

~/dev-newton/scripts/ReplaceFileList.sh "transitionName = 1" "transitionName = MsgReceived" | \

~/dev-newton/scripts/ReplaceFileList.sh "transitionName = 2" "transitionName = MsgSent"  | sort

