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
from git import Repo

class TerminalSetuper:
    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window
        await self.setup()

    async def run_in_session(self, session, commands):
        if isinstance(commands, list):
            for command in commands[:-1]:
                await self.cmd(session, command)
                session = await session.async_split_pane(vertical = True)

            await self.cmd(session, commands[-1])

        else:
            await self.cmd(session, commands)

    async def run_in_new_tab(self, commands):
        tab = await self.window.async_create_tab()
        await self.run_in_session(tab.sessions[0], commands)

    async def cd(self, session):
        await session.async_send_text(f'cd {self.current_app["path"]} \n')

    async def cmd(self, session, command):
        await self.cd(session)
        await session.async_send_text(f'{command} \n')

    async def clear(self, session):
        await session.async_send_text(f'clear \n')

    async def rebase_current_branch_to_dev(self, session):
        repo = Repo(self.current_app['path'])
        active_branch = repo.active_branch

        # if not repo.is_dirty():
        #   await self.cmd(session, f'git checkout {self.current_app["dev_branch"]}')
        #   await self.cmd(session, f'git pull origin {self.current_app["dev_branch"]}')
        #   await self.cmd(session, f'git checkout {active_branch}')
        #   await self.cmd(session, f'git rebase {self.current_app["dev_branch"]}')

        await self.clear(session)
