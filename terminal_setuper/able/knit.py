#!/usr/bin/env python3

# brew install python3
# pip3 install iterm2
# pip3 install pyobjc
# pip3 install asyncio

# iTerm => Preferences => General => Magic => Enable Python Api

import iterm2, sys, AppKit, asyncio, os, inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from terminal_setuper import TerminalSetuper

class KnitTerminalSetuper(TerminalSetuper):
    def __init__(self):
        print(os.environ)
        self.app = { 'path': os.environ['TERMINAL_SETUPER_KNIT_PATH'] }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        self.current_app = self.app
        session = self.window.current_tab.current_session

        await self.cd(session)

        commands = [
            'docker-compose up',
            'rails server',
            './bin/webpack-dev-server',
            'rails knit:watch_themes'
        ]

        await self.run_in_session(session, commands)

async def main(connection):
    await KnitTerminalSetuper().start(connection)
    tab = await self.window.async_create_tab()
    await self.cd(tab.session)

iterm2.run_until_complete(main, True)
