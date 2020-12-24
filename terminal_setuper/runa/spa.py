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

class RunaSpaTerminalSetuper(TerminalSetuper):
    def __init__(self):
       self.spa = { 'path': '~/Work/runa/spa', 'dev_branch': 'develop' }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.setup()

    async def setup(self):
        await self.setup_spa()

    async def setup_spa(self):
        self.current_app = self.spa
        tab = await self.window.async_create_tab(index = len(self.window.tabs))
        await self.rebase_current_branch_to_dev(tab.current_session)
        await self.cmd(tab.current_session, 'nvm use 12.11.0')
        await self.cmd(tab.current_session, 'yarn install')
        await self.cmd(tab.current_session, 'npm start')

        tab = await self.window.async_create_tab(index = len(self.window.tabs))
        await self.cd(tab.current_session)

async def main(connection):
    await RunaSpaTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
