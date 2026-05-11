#!/bin/bash
set -euo pipefail

LAN_IF=${LAN_IF:-lan}
VINTAGELAN_IF=${VINTAGELAN_IF:-vintagehost_if}
ETHOUDP_IF=${ETHOUDP_IF:-ethoudp_tap}

NET_VINTAGELAN=$(ip -json addr show dev "$VINTAGELAN_IF" | jq -r 'first(.[0].addr_info[] | select(.family=="inet") | .local+"/"+(.prefixlen|tostring))')
NET_ETHOUTP=$(ip    -json addr show dev "$ETHOUDP_IF"    | jq -r 'first(.[0].addr_info[] | select(.family=="inet") | .local+"/"+(.prefixlen|tostring))')

# Add rule only if not already present
ipt_add()   { iptables -C "${@:1}" 2>/dev/null || iptables -A "${@:1}"; }
ipt_add_t() { iptables -t "$1" -C "${@:2}" 2>/dev/null || iptables -t "$1" -A "${@:2}"; }

# Delete rule, ignore if already gone
ipt_del()   { iptables -D "${@:1}" 2>/dev/null || true; }
ipt_del_t() { iptables -t "$1" -D "${@:2}" 2>/dev/null || true; }


function start() {
    # ── Direct routing between the two internal networks ──────────────────────
    ipt_add FORWARD -s "$NET_VINTAGELAN" -d "$NET_ETHOUTP"  -j ACCEPT
    ipt_add FORWARD -s "$NET_ETHOUTP"  -d "$NET_VINTAGELAN" -j ACCEPT

    # ── Allow established/related return traffic on external interface ─────────
    ipt_add FORWARD -i "$LAN_IF" \
        -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    # ── Allow outbound forwarding to external from both internal nets ──────────
    ipt_add FORWARD -s "$NET_VINTAGELAN" -o "$LAN_IF" -j ACCEPT
    ipt_add FORWARD -s "$NET_ETHOUTP"  -o "$LAN_IF" -j ACCEPT

    # ── Masquerade: internal -> external, but NOT to the peer internal net ─────
    ipt_add_t nat POSTROUTING -s "$NET_VINTAGELAN" ! -d "$NET_ETHOUTP"  -o "$LAN_IF" -j MASQUERADE
    ipt_add_t nat POSTROUTING -s "$NET_ETHOUTP"  ! -d "$NET_VINTAGELAN" -o "$LAN_IF" -j MASQUERADE
}


function stop() {
    ipt_del FORWARD -s "$NET_VINTAGELAN" -d "$NET_ETHOUTP"  -j ACCEPT
    ipt_del FORWARD -s "$NET_ETHOUTP"  -d "$NET_VINTAGELAN" -j ACCEPT

    ipt_del FORWARD -i "$LAN_IF" \
        -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    ipt_del FORWARD -s "$NET_VINTAGELAN" -o "$LAN_IF" -j ACCEPT
    ipt_del FORWARD -s "$NET_ETHOUTP"  -o "$LAN_IF" -j ACCEPT

    ipt_del_t nat POSTROUTING -s "$NET_VINTAGELAN" ! -d "$NET_ETHOUTP"  -o "$LAN_IF" -j MASQUERADE
    ipt_del_t nat POSTROUTING -s "$NET_ETHOUTP"  ! -d "$NET_VINTAGELAN" -o "$LAN_IF" -j MASQUERADE
}

echo "IP router container starting"
echo "  LAN_IF=$LAN_IF"
echo "  VINTAGELAN_IF=$VINTAGELAN_IF ($NET_VINTAGELAN)"
echo "  ETHOUDP_IF=$ETHOUDP_IF ($NET_ETHOUTP)"

start

trap stop TERM INT QUIT
while :; do
    sleep infinity &
    wait $!
done

echo "IP router container terminated"
