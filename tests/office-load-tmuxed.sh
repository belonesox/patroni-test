#!/usr/bin/env bash

export MASTER_IP="10.200.5.101"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

session="demo_sess"
main_win="demo"

tmux new-session -s "${session}" -n "${main_win}" -c $(pwd) -d
exec tmux attach -t "${session}"

tmux split-window -d -t 0 -h
tmux split-window -d -t 0 -v -p 50
tmux split-window -d -t 1 -v -p 50


# tmux send-keys -t 1 "while :; do ssh root@sol-db-centos-1 'journalctl -fu patroni'; sleep 1; done"  Enter
# tmux send-keys -t 2 "while :; do ssh root@sol-db-centos-2 'journalctl -fu patroni'; sleep 1; done" Enter
# tmux send-keys -t 3 "while :; do ssh root@sol-db-centos-3 'journalctl -fu patroni'; sleep 1; done" Enter

# tmux send-keys -t 1 "watch -n 1 ssh root@10.200.5.101 'consul operator raft --list-peers'" Enter
# tmux send-keys -t 2 "watch -n 1 ssh root@$MASTER_IP 'patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql'" Enter

watch -n 1 ssh root@10.200.5.101 'patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql'" Enter

tail -f  /var/lib/pgsql/9.6/data/pg_log/postgresql-Mon.log

tmux select-pane -t 0


ssh root@192.168.5.251 'patronictl -c /etc/patroni/postgres.yml list cluster-test-pgsql'
