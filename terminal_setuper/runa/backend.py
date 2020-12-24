#!/usr/bin/env python3

# brew install python3
# pip3 install iterm2
# pip3 install pyobjc
# pip3 install asyncio
# pip3 install gitpython

# iTerm => Preferences => General => Magic => Enable Python Api

import sys
import iterm2
import AppKit
import asyncio

import os, inspect
currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from terminal_setuper import TerminalSetuper

class RunaBackendTerminalSetuper(TerminalSetuper):
    def __init__(self):
        self.api = { 'path': '~/Work/runa/api', 'dev_branch': 'development', 'cded': False }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        await self.setup_api()

    async def setup_api(self):
        self.current_app = self.api

        await self.rebase_current_branch_to_dev(self.window.current_tab.current_session)

        tab = await self.window.async_create_tab(index = 0)
        session = tab.sessions[0]

        commands = [
            'docker-compose up postgres mongo redis',
            'rake db:migrate && rails server',
            'REDIS_PROVIDER='' bundle exec sidekiq -C config/sidekiq.yml'
        ]

        await self.run_in_session(session, commands)

        tab = await self.window.async_create_tab(index = 1)

        await self.run_in_session(tab.sessions[0], 'heroku accounts:set runa')
        await self.run_in_session(tab.sessions[0], 'rails console')

    async def setup_spa(self):
        self.current_app = self.spa
        tab = await self.window.async_create_tab(index = len(self.window.tabs))
        await self.rebase_current_branch_to_dev(tab.current_session)
        await self.cmd(tab.current_session, 'npm start')

async def main(connection):
    await RunaBackendTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
