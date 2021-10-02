#!/usr/bin/env python3

# brew install python3
# pip3 install iterm2
# pip3 install pyobjc
# pip3 install asyncio

# iTerm => Preferences => General => Magic => Enable Python Api

import iterm2
import AppKit
import asyncio

class BirlTerminalSetuper:
    def __init__(self):
        self.path = '~/Work/birl/web'

    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.close_all_but_one_session()
        await self.setup()

    async def setup(self):
        self.current_path = self.path

        await self.cd(self.window.current_tab.current_session)

        tab = await self.window.async_create_tab(index = 0)
        session = tab.sessions[0]

        await self.cd(session)

        commands = [
            'docker-compose up',
            'bundle exec sidekiq',
            'yibw'
        ]

        await self.run_in_session(session, commands)

        tab = await self.window.async_create_tab(index = 1)
        await self.run_in_session(tab.sessions[0], 'rails server')

        tab = await self.window.async_create_tab(index = 1)
        await self.run_in_session(tab.sessions[0], 'heroku accounts:set my')
        await self.run_in_session(tab.sessions[0], 'rails console')

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
        await session.async_send_text(f'cd {self.current_path} \n')

    async def cmd(self, session, command):
        await self.cd(session)
        await session.async_send_text(f'clear \n {command} \n')

async def main(connection):
    await BirlTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
