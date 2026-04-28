import sys, asyncio, os, inspect, iterm2

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from terminal_setuper import TerminalSetuper

class WordableSpecTerminalSetuper(TerminalSetuper):
    def __init__(self):
        self.app = { 'path': os.environ['TERMINAL_SETUPER_WORDABLE_PATH'] }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        self.current_app = self.app

        session = self.window.current_tab.current_session

        # for index, test in enumerate(['spec/vcr_setup', 'spec/system', 'spec/requests spec/services spec/routing', 'spec/controllers spec/models spec/jobs']):
        #     await self.run_in_new_tab(f'export TEST_ENV_NUMBER={index}; t {test}')

        await self.run_in_new_tab([f'export TEST_ENV_NUMBER={index}; t {test}' for index, test in enumerate(['spec/vcr_setup', 'spec/system', 'spec/requests spec/services spec/routing', 'spec/controllers spec/models spec/jobs'])])

async def main(connection):
    await WordableSpecTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
