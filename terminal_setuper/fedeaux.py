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

class FedeauxTerminalSetuper(TerminalSetuper):
    def __init__(self):
        self.backend = { 'path': '~/Work/fedeaux/node' }
        self.nativizer = { 'path': '~/Work/fedeaux/nativizer' }
        self.app = { 'path': '~/Work/fedeaux/DodoApp' }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        await self.setup_backend()
        await self.setup_nativizer()
        await self.setup_terminals()

    async def setup_backend(self):
        self.current_app = self.backend
        session = self.window.current_tab.current_session

        await self.cd(session)

        commands = [
            'docker-compose up',
            'ywb',
            'nodemon dist/dev-server.js --watch dist/dev-server.js'
        ]

        await self.run_in_session(session, commands)

    async def setup_nativizer(self):
        self.current_app = self.nativizer
        await self.run_in_new_tab('coffee index.coffee')

    async def setup_terminals(self):
        self.current_app = self.backend
        await self.run_in_new_tab('heroku accounts:set my')

        self.current_app = self.app
        await self.run_in_new_tab('react-native run-android')

async def main(connection):
    await FedeauxTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
