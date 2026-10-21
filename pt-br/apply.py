#!/usr/bin/env python3
"""Aplica idioma usando a CLI oficial; faz backup da personalidade existente."""
import argparse, os, shutil, subprocess
from pathlib import Path
from datetime import datetime, timezone

def apply(home, hermes):
    home = Path(home).expanduser().resolve()
    home.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, HERMES_HOME=str(home), HERMES_LANGUAGE='pt')
    subprocess.run([str(hermes), 'config', 'set', 'display.language', 'pt'], env=env, check=True)
    source = Path(__file__).with_name('SOUL.md').read_bytes()
    target = home / 'SOUL.md'
    if target.exists() and target.read_bytes() != source:
        stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
        shutil.copy2(target, home / ('SOUL.md.backup-' + stamp))
    target.write_bytes(source)
    print('Português aplicado. Personalidade anterior preservada em backup, se diferente.')
    return home

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--home', required=True)
    parser.add_argument('--hermes', default='hermes')
    args = parser.parse_args()
    apply(args.home, args.hermes)
