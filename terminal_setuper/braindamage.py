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

class BraindamageTerminalSetuper(TerminalSetuper):
    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        self.current_app = self.app

        session = self.window.current_tab.current_session

        await self.run_in_session(session, [
            'docker-compose up',
            './bin/webpack-dev-server',
            'mgrok'
        ])

        tabs = [
            [
                'rails server',
                'bundle exec sidekiq'
            ],
            [
                'rails console',
                'clear'
            ]
        ]

        for commands in tabs:
            await self.run_in_new_tab(commands)
