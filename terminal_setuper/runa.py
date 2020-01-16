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

class RunaTerminalSetuper:
    def __init__(self):
        self.api = { 'path': '~/Work/runa/api', 'dev_branch': 'development', 'cded': False }
        self.spa = { 'path': '~/Work/runa/spa', 'dev_branch': 'develop', 'cded': False }

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.close_all_but_one_session()
        await self.setup()

    async def setup(self):
        await self.setup_api()
        await self.setup_spa()

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

        await self.run_in_session(tab.sessions[0], 'rails console')

    async def setup_spa(self):
        self.current_app = self.spa
        tab = await self.window.async_create_tab(index = len(self.window.tabs))
        await self.rebase_current_branch_to_dev(tab.current_session)
        await self.cmd(tab.current_session, 'npm start')

    async def close_all_but_one_session(self):
        keep_open_tab = self.window.current_tab

        for tab in self.window.tabs:
            if tab != keep_open_tab:
                await tab.async_close(force = True)
            else:
                for session in tab.sessions[1:]:
                    await session.async_close(force = True)

    async def run_in_session(self, session, commands):
        if isinstance(commands, list):
            for command in commands[:-1]:
                await self.cmd(session, command)
                session = await session.async_split_pane(vertical = True)

            await self.cmd(session, commands[-1])

        else:
            await self.cmd(session, commands)

    async def cd(self, session):
        if self.current_app["cded"]:
            return

        await session.async_send_text(f'cd {self.current_app["path"]} \n')
        self.current_app["cded"] = True

    async def cmd(self, session, command):
        await self.cd(session)
        await session.async_send_text(f'{command} \n')

    async def clear(self, session):
        await session.async_send_text(f'clear \n')

    async def rebase_current_branch_to_dev(self, session):
        repo = Repo(self.current_app['path'])
        active_branch = repo.active_branch

        if not repo.is_dirty():
          await self.cmd(session, f'git checkout {self.current_app["dev_branch"]}')
          await self.cmd(session, f'git pull origin {self.current_app["dev_branch"]}')
          await self.cmd(session, f'git checkout {active_branch}')
          await self.cmd(session, f'git rebase {self.current_app["dev_branch"]}')

        await self.clear(session)

async def main(connection):
    await RunaTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
