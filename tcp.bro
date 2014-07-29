# Bro script that pulls field from individual TCP packets.
# The input trace must contain nothing but TCP.

# Also emit a conn.log.
@load base/protocols/conn

module TCP;

export {
	redef enum Log::ID += { LOG };

	type Info: record {
		t: time	&log;
		src: addr	&log;
		dst: addr	&log;
		dir: string	&log;
		iplen: count	&log;
		datalen: count	&log;
		syn: bool	&log;
	};

	global log_tcp: event(rec: Info);
}

event bro_init()
{
	Log::create_stream(TCP::LOG, [$columns=Info, $ev=log_tcp]);
}

event new_packet(c: connection, p: pkt_hdr)
{
	local rec: TCP::Info = [
		$t=network_time(),
		$src=c$id$orig_h,
		$dst=c$id$resp_h,
		$dir=p$tcp$dport==443/tcp ? "OUT" : "IN",
		$iplen=p$ip$len,
		$datalen=p$tcp$dl,
		$syn=(p$tcp$flags/2)%2==1
	];
	Log::write(TCP::LOG, rec);
}
