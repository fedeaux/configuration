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

class ResetTerminalSetuper:
    async def start(self, connection):
        app = await iterm2.async_get_app(connection)
        self.window = app.current_window

        await self.close_all_but_one_session()

    async def close_all_but_one_session(self):
        keep_open_tab = self.window.current_tab

        for tab in self.window.tabs:
            if tab != keep_open_tab:
                await tab.async_close(force = True)
            else:
                for session in tab.sessions[1:]:
                    await session.async_close(force = True)

async def main(connection):
    await ResetTerminalSetuper().start(connection)

iterm2.run_until_complete(main, True)
