# LToUDP router — bridges a LToUDP network to an EtherTalk TAP interface via tashrouter.
# Configuration via CLI flags or environment variables; priority: CLI > env > defaults.
# (c) 2026 by Harald Roelle

import logging
import sys
import types
import argparse
import os
from dataclasses import dataclass, field, fields, Field
from typing import Any
import signal
import threading

#import tashrouter.netlog
from tashrouter.port.ethertalk.tap import TapPort
from tashrouter.port.localtalk.ltoudp import LtoudpPort
from tashrouter.port.localtalk.tashtalk import TashTalkPort
from tashrouter.router.router import Router


# ── Config dataclass ──────────────────────────────────────────────────────────

@dataclass
class Config:
    tap_iface:      str = field(default='ltoudp_tap',  metadata={'help': 'LToUDP TAP interface name'})
    ltoudp_zone:    str = field(default='LToUDP zone', metadata={'help': 'LToUDP network zone name'})
    ltoudp_net:     int = field(default=62,            metadata={'help': 'LToUDP seed network number'})

    def __str__(self) -> str:
        return '\n'.join(f'  {f.name} = {getattr(self, f.name)!r}' for f in fields(self))

    @staticmethod
    def env_var(f: Field[Any]) -> str:
        '''Derive environment variable name from field name: foo_bar -> FOO_BAR'''
        return f.name.upper()

    @staticmethod
    def cli_flag(f: Field[Any]) -> str:
        '''Derive CLI flag from field name: foo_bar -> --foo-bar'''
        return '--' + f.name.replace('_', '-')


# ── Loaders ───────────────────────────────────────────────────────────────────

def load_from_env() -> dict[str, str]:
    '''Read values from environment variables, derived from field names.'''
    return {
        f.name: os.environ[Config.env_var(f)]
        for f in fields(Config)
        if Config.env_var(f) in os.environ
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    '''Build argument parser from dataclass field metadata.'''
    parser = argparse.ArgumentParser(
        description='LToUDP router configuration',
        formatter_class=argparse.HelpFormatter,
    )
    defaults = Config()
    for f in fields(Config):
        parser.add_argument(
            Config.cli_flag(f),
            metavar='VALUE',
            default=None,
            help=f'{f.metadata["help"]}  [env: {Config.env_var(f)}] (default: {getattr(defaults, f.name)!r})',
        )
    return parser.parse_args(argv)


# ── Main resolver ─────────────────────────────────────────────────────────────

def load_config(argv: list[str] | None = None) -> Config:
    '''
    Merge all sources in priority order and return a Config object.
    Priority: CLI > env vars > defaults
    '''
    args = parse_args(argv)

    merged: dict[str, Any] = vars(Config()).copy()
    merged.update(load_from_env())
    merged.update({
        f.name: v
        for f in fields(Config)
        if (v := getattr(args, f.name)) is not None
    })

    return Config(**merged)


# ── Entry point ───────────────────────────────────────────────────────────────

def main() -> int:
    def _request_stop(sig: int, _frame: types.FrameType | None = None) -> None:
        logging.info('Received %s — shutting down', signal.Signals(sig).name)
        stop.set()

    logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s: %(message)s')
    #tashrouter.netlog.set_log_str_func(logging.debug)  # comment this line for speed and reduced spam

    config = load_config()

    stop = threading.Event()

    for sig in (signal.SIGINT, signal.SIGTERM):
        signal.signal(sig, _request_stop)

    with open(f'/sys/class/net/{config.tap_iface}/address', 'r') as f:
        tapmac = f.read().strip()
    tapmac_bytes = bytes(int(x, 16) for x in tapmac.split(':'))
    tapmac_bytes = bytes([*tapmac_bytes[:-1], tapmac_bytes[-1] ^ 0xFF])

    ltoudp_port = LtoudpPort(seed_network=config.ltoudp_net, seed_zone_name=config.ltoudp_zone.encode('UTF-8'))
    tap_port = TapPort(tap_name=config.tap_iface, hw_addr=tapmac_bytes)
    router = Router('router', ports=(ltoudp_port, tap_port))

    logging.info('Active configuration:\n%s', config)

    router.start()

    logging.info('Router running')
    stop.wait()
    router.stop()

    return 0


if __name__ == '__main__':
    exit_code = main()
    logging.info('LToUDP router shutdown complete')
    sys.exit(exit_code)
