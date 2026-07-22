import iterm2, sys, asyncio, os, inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from braindamage import BraindamageTerminalSetuper

class VideoerTerminalSetuper(BraindamageTerminalSetuper):
    def __init__(self):
        self.app = { 'path': os.environ['TERMINAL_SETUPER_VIDEOER_PATH'] }

async def main(connection):
    await VideoerTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
