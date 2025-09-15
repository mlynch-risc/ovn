# IC Databases
sudo ovsdb-tool create /var/lib/ovn/ic/ovn-ic-nb.db ./ovn/ovn-ic-nb.ovsschema
sudo ovsdb-tool create /var/lib/ovn/ic/ovn-ic-sb.db ./ovn/ovn-ic-sb.ovsschema

sudo ovsdb-server --remote=ptcp:6645:127.0.0.1 --pidfile=/var/run/ovn/ic/ovn-ic-nb.pid --log-file=/var/log/ovn/ic/ovn-ic-nb.log --detach /var/lib/ovn/ic/ovn-ic-nb.db
sudo ovsdb-server --remote=ptcp:6646:127.0.0.1 --pidfile=/var/run/ovn/ic/ovn-ic-sb.pid --log-file=/var/log/ovn/ic/ovn-ic-sb.log --detach /var/lib/ovn/ic/ovn-ic-sb.db

# AZ1 Setup
sudo ovsdb-tool create /var/lib/ovn/az1/ovn-nb.db ./ovn/ovn-nb.ovsschema
sudo ovsdb-tool create /var/lib/ovn/az1/ovn-sb.db ./ovn/ovn-sb.ovsschema

sudo ovsdb-server --remote=ptcp:6641:127.0.0.1 --pidfile=/var/run/ovn/az1/ovn-nb.pid --detach /var/lib/ovn/az1/ovn-nb.db
sudo ovsdb-server --remote=ptcp:6642:127.0.0.1 --pidfile=/var/run/ovn/az1/ovn-sb.pid --detach /var/lib/ovn/az1/ovn-sb.db

sudo ovn-northd --ovnnb-db=tcp:127.0.0.1:6641 --ovnsb-db=tcp:127.0.0.1:6642 --pidfile=/var/run/ovn/az1/ovn-northd.pid --detach

# AZ2 Setup
sudo ovsdb-tool create /var/lib/ovn/az2/ovn-nb.db ./ovn/ovn-nb.ovsschema
sudo ovsdb-tool create /var/lib/ovn/az2/ovn-sb.db ./ovn/ovn-sb.ovsschema

sudo ovsdb-server --remote=ptcp:6651:127.0.0.1 --pidfile=/var/run/ovn/az2/ovn-nb.pid --detach /var/lib/ovn/az2/ovn-nb.db
sudo ovsdb-server --remote=ptcp:6652:127.0.0.1 --pidfile=/var/run/ovn/az2/ovn-sb.pid --detach /var/lib/ovn/az2/ovn-sb.db

sudo ovn-northd --ovnnb-db=tcp:127.0.0.1:6651 --ovnsb-db=tcp:127.0.0.1:6652  --pidfile=/var/run/ovn/az2/ovn-northd.pid --detach

# Set AZ names
sudo ovn-nbctl --db=tcp:127.0.0.1:6641 set NB_Global . name=az1
sudo ovn-nbctl --db=tcp:127.0.0.1:6651 set NB_Global . name=az2

# Start IC processes
sudo ovn-ic --ovnnb-db=tcp:127.0.0.1:6641 --ovnsb-db=tcp:127.0.0.1:6642 --ic-nb-db=tcp:127.0.0.1:6645 --ic-sb-db=tcp:127.0.0.1:6646 --pidfile=/var/run/ovn/az1/ovn-ic.pid --detach
sudo ovn-ic --ovnnb-db=tcp:127.0.0.1:6651 --ovnsb-db=tcp:127.0.0.1:6652 --ic-nb-db=tcp:127.0.0.1:6645 --ic-sb-db=tcp:127.0.0.1:6646 --pidfile=/var/run/ovn/az2/ovn-ic.pid --detach
