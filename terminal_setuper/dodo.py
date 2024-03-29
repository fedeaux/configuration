import iterm2, sys, AppKit, asyncio, os, inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from braindamage import BraindamageTerminalSetuper

class DodoTerminalSetuper(BraindamageTerminalSetuper):
    def __init__(self):
        self.app = { 'path': os.environ['TERMINAL_SETUPER_DODO_PATH'] }

async def main(connection):
    await DodoTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
