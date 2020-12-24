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

class FinoTerminalSetuper(TerminalSetuper):
    def __init__(self):
        self.app = { 'path': '~/Work/able/fino' }

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
            'bundle exec sidekiq'
        ]

        await self.run_in_session(session, commands)

async def main(connection):
    await FinoTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
