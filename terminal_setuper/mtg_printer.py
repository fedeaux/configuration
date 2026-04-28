import iterm2, sys, asyncio, os, inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from terminal_setuper import TerminalSetuper

class MtgPrinterSetuper(TerminalSetuper):
    def __init__(self):
        self.app = { 'path': '/Users/fedorius/fedeaux/mtg-printer' }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        self.current_app = self.app

        session = self.window.current_tab.current_session

        await self.run_in_session(session, [
            'docker compose up',
            './bin/dev',
            'rails console',
            'clear'
        ])

async def main(connection):
    await MtgPrinterSetuper().start(connection)

iterm2.run_until_complete(main, True)
