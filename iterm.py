#!/usr/bin/env python3

# brew install python3
# pip3 install iterm2
# pip3 install pyobjc
# pip3 install asyncio

# iTerm => Preferences => General => Magic => Enable Python Api

import iterm2
import AppKit
import asyncio

# Launch the app
# AppKit.NSWorkspace.sharedWorkspace().launchApplication_("iTerm2")

class TerminalSetuper:
    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        window = app.current_window

        await self.close_all_but_one_session(window, window.current_tab)
        await self.cmd(window.current_tab.current_session, 'cd ~/Work/runa/saas-rails-api')

        tab = await window.async_create_tab(index = 0)
        session = tab.sessions[0]

        await session.async_send_text("cd ~/Work/runa/saas-rails-api \n")

        commands = [
            'docker-compose up postgres mongo redis',
            'rails server',
            'rails sidekiq -C config/sidekiq.yml'
        ]

        await self.run_in_session(session, commands)

        tab = await window.async_create_tab(index = 1)
        commands = 'rails console'

        await self.run_in_session(tab.sessions[0], commands)

    async def close_all_but_one_session(self, window, keep_open_tab):
        for tab in window.tabs:
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

    async def cmd(self, session, command):
        await session.async_send_text("cd ~/Work/runa/saas-rails-api \n")
        await session.async_send_text("clear \n" + command + "\n")

async def main(connection):
    await TerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
